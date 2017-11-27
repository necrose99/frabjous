# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils xdg

MY_PV="${PV/_pre}"
DESCRIPTION="A terminal built on web technologies"
HOMEPAGE="https://hyper.is"
SRC_URI="https://github.com/zeit/hyper/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-util/electron-bin-1.7.9
	media-gfx/graphicsmagick
	media-libs/libicns
	>=net-libs/nodejs-6.0.0
	sys-apps/yarn"
RDEPEND="app-arch/xz-utils"

S="${WORKDIR}/${PN}-${MY_PV}"

pkg_setup() {
	has network-sandbox $FEATURES && \
		die "x11-terms/hyper requires 'network-sandbox' to be disabled in FEATURES"
}

src_prepare() {
	yarn install || die
	default
}

src_compile() {
	local PATH="${S}/node_modules/.bin:$PATH"

	npm run build && \
	cross-env BABEL_ENV=production babel \
		--out-file app/renderer/bundle.js \
		--minified app/renderer/bundle.js \
		--no-comments && \
	build --linux --dir || die
}

src_install() {
	newbin "${FILESDIR}"/hyper-launcher.sh hyper

	insinto /usr/lib/${PN}
	doins -r dist/linux-unpacked/resources/*
	doins -r bin

	# Install icons and desktop entry
	local s
	for s in 16 24 32 48 64 96 128 256; do
		newicon -s ${s} "${FILESDIR}/icon/${s}.png" hyper.png
	done
	make_desktop_entry hyper Hyper hyper \
		Development "Terminal=false"
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	if [ -z "${REPLACING_VERSIONS}" ]; then
		einfo
		elog "You might have to add the kernel sysctl parameter"
		elog "fs.inotify.max_user_watches=524288 or similiar."
		elog "See https://github.com/zeit/hyper/issues/1502"
		einfo
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
