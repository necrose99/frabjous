# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Library written in C for encoding and decoding data using base32 or base64"
HOMEPAGE="https://github.com/paolostivanin/libbaseencode"
SRC_URI="https://github.com/paolostivanin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-fix_cmake_dest.patch )

src_prepare() {
	# Leave optimization level to user CFLAGS
	sed -i '/CMAKE_C_FLAGS/d' CMakeLists.txt || die

	cmake-utils_src_prepare
}
