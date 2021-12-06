# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="dzen for Wayland"
HOMEPAGE="https://github.com/djpohly/dtao"
EGIT_REPO_URI="https://github.com/djpohly/dtao"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/wayland
	x11-libs/pixman
	media-libs/fcft
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
	app-text/ronn
"

src_install() {
	emake PREFIX="${ED}/usr" install
	einstalldocs
}
