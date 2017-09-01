# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2 vala

DESCRIPTION="A modern desktop application designed to complement web-based RSS accounts"
HOMEPAGE="https://jangernert.github.io/FeedReader/"
SRC_URI="https://github.com/jangernert/FeedReader/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=x11-libs/gtk+-3.22:3
	app-crypt/libsecret[vala(+)]
	app-text/html2text
	dev-db/sqlite:3
	dev-libs/libgee:0.8
	dev-libs/libpeas
	net-misc/curl
	gnome-base/gnome-keyring
	net-libs/gnome-online-accounts[introspection]
	media-libs/gst-plugins-base:1.0
	x11-libs/libnotify
	$(vala_depend)"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fix_vala.patch )
RESTRICT="mirror"

S="${WORKDIR}/FeedReader-${PV}"

src_prepare() {
	vala_src_prepare
	default
}

src_configure() {
	local mycmakeargs=(
		-DVALA_EXECUTABLE="${VALAC}"
		-DCMAKE_INSTALL_PREFIX="${PREFIX}/usr"
		-DGSETTINGS_LOCALINSTALL=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}

pkg_preinst() {
	gnome2_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
