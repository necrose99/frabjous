# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"

inherit cmake-utils fdo-mime gnome2-utils

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="https://keepassxc.org"
SRC_URI="https://github.com/keepassxreboot/${PN}/releases/download/${PV}/${P}-src.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="autotype http test"

RDEPEND="dev-libs/libgcrypt:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	net-libs/libmicrohttpd
	sys-libs/zlib
	autotype? (
		dev-qt/qtx11extras:5
		x11-libs/libXi
		x11-libs/libXtst
	)"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	test? ( dev-qt/qttest:5 )"

src_prepare() {
	 use test || \
		sed -e "/^find_package(Qt5Test/d" -i CMakeLists.txt || die

	default
}

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS="$(usex test)"
		-DWITH_XC_AUTOTYPE="$(usex autotype)"
		-DWITH_XC_HTTP="$(usex http)"
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
