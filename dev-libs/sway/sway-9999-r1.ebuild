# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="i3-compatible Wayland compositor"
HOMEPAGE="https://swaywm.org/"
EGIT_REPO_URI="https://github.com/swaywm/sway.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="bash-completion fish-completion +xwayland zsh-completion doc wallpapers"

DEPEND="dev-libs/json-c
		dev-libs/libpcre
		>=dev-libs/wlroots-9999
		>=dev-libs/wayland-1.15.0
		x11-libs/libxkbcommon
		xwayland? ( x11-libs/libxcb )
		x11-libs/cairo
		x11-libs/pango
		x11-libs/gdk-pixbuf[jpeg]
		x11-libs/pixman
		>=dev-libs/libinput-1.6.0
		virtual/pam
		sys-apps/systemd
		doc? ( app-text/scdoc )"

RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_use bash-completion bash-completions)
		$(meson_use fish-completion fish-completions)
		$(meson_use zsh-completion zsh-completions)
		$(meson_use xwayland enable-xwayland)
		$(meson_use wallpapers default-wallpaper)
	)
	meson_src_configure
}
