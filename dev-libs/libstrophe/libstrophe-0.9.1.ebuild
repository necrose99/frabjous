# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A simple, lightweight C library for writing XMPP clients"
HOMEPAGE="http://strophe.im/libstrophe/"
SRC_URI="https://github.com/strophe/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="|| ( MIT GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples libressl +ssl static-libs test +xml"

RDEPEND="ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	xml? ( dev-libs/libxml2:2 )
	!xml? ( dev-libs/expat )"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )
	doc? ( app-doc/doxygen )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ssl tls) \
		$(use_enable test static) \
		$(use_enable static-libs static) \
		$(use_with xml libxml2) \
		|| die "econf failed"
}
src_compile() {
	default
	if use doc; then
		doxygen || die
		HTML_DOCS=( docs/html/* )
	fi
}

src_install() {
	default
	use examples && dodoc -r examples
}
