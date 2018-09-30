# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="A modular Wayland compositor library"
HOMEPAGE="https://swaywm.org"

EGIT_REPO_URI="https://github.com/swaywm/wlroots.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
# 1) currently the build system seems not to support disabling xkb
# 2) examples require most likely ffmpeg above 4.0 and are therefore currently not
#    built
IUSE="caps +systemd -elogind x11 +xwayland +xkb examples"
REQUIRED_USE="?? ( systemd elogind )"

DEPEND=">=dev-libs/wayland-1.15.0
		>=dev-libs/wayland-protocols-1.15.0
		>=media-libs/mesa-17.1.0[egl,gles2,gbm]
		x11-libs/libdrm
		>=dev-libs/libinput-1.7.0
		xkb? ( x11-libs/libxkbcommon )
		virtual/udev
		x11-libs/pixman
		caps? ( sys-libs/libcap )
		systemd? ( sys-apps/systemd )
		elogind? ( sys-auth/elogind )
		x11? ( x11-libs/libxcb
				x11-libs/xcb-util-wm )
		examples? ( media-libs/libpng:0/16
					media-video/ffmpeg )
		xwayland? ( x11-libs/libxcb
					x11-libs/xcb-util-wm )"

RDEPEND="${DEPEND}"

src_configure() {
	if use systemd || use elogind ; then
		local uselogind="enabled"
	else
		local uselogind="disabled"
	fi
	local emesonargs=(
		-Dlibcap=$(usex caps enabled disabled)
		-Dlogind=$uselogind
		-Dlogind-provider=$(usex elogind elogind systemd)
		-Dx11-backend=$(usex x11 enabled disabled)
		-Dxcb-icccm=$(usex x11 enabled disabled)
		-Dxcb-xkb=$(usex xkb enabled disabled)
		-Dxwayland=$(usex xwayland enabled disabled)
		$(meson_use examples)
		$(meson_use examples rootston)
	)
	meson_src_configure
}
