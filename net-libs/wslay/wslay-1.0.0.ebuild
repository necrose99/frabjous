# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

MY_P="${PN}-release-${PV}"
DESCRIPTION="The WebSocket library written in C"
HOMEPAGE="http://wslay.sourceforge.net/"
SRC_URI="https://github.com/tatsuhiro-t/wslay/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

IUSE="static-libs"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

DEPEND="dev-python/sphinx"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS ChangeLog COPYING NEWS README README.rst )

AUTOTOOLS_AUTORECONF=1

src_configure() {
	cp -fa "${S}"/doc/sphinx/conf.py.in "${S}"/doc/sphinx/conf.py
	autotools-utils_src_configure
}
