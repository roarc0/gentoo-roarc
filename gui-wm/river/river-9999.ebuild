# Copyright 2021 Aisha Tammy
# Distributed under the terms of the ISC License

EAPI=7

DESCRIPTION="Dynamic tiling wayland compositor"
HOMEPAGE="https://github.com/riverwm/river"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ifreund/river"
else
	COMMIT=26b0acddb7c56311b9d476c059d1e9af9d27dfbf
	SRC_URI="https://github.com/ifreund/river/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libevdev
	dev-libs/libinput
	dev-libs/wayland
	>=gui-libs/wlroots-0.15.0[X]
	x11-libs/cairo[X]
	x11-libs/libxkbcommon:=[X]
	x11-libs/pixman
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-lang/zig-0.9.0
	dev-libs/wayland-protocols
	virtual/pkgconfig
	app-text/scdoc
"

src_configure() {
	export zigoptions=(
		--verbose
		-Drelease-safe
		-Dxwayland=true
		-Dman-pages=true
		"${EXTRA_ECONF[@]}"
	)
	export CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_compile() {
	zig build "${zigoptions[@]}" --prefix "${T}/temp_install" || die
}

src_test() {
	zig build test "${zigoptions[@]}" --prefix "${T}/temp_install" || die
}

src_install() {
	zig build install "${zigoptions[@]}" --prefix "${ED}/usr" || die
	mkdir "${ED}"/usr/etc || die
	mv "${ED}"/usr/etc "${ED}" || die
}
