# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"

DESCRIPTION="An IMAP mail filtering utility"
HOMEPAGE="https://github.com/lefcha/imapfilter"
SRC_URI="https://github.com/lefcha/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	dev-libs/libpcre
	dev-lang/lua:*"
DEPEND="${RDEPEND}"

DOCS="AUTHORS NEWS README samples/*"

src_prepare() {
	# Fix compatibility with LibreSSL
	eapply "${FILESDIR}"/${PN}-2.6.8-libressl-compat.patch

	sed -i -e "/^PREFIX/s:/usr/local:${EPREFIX}/usr:" \
		-e "/^MANDIR/s:man:share/man:" \
		-e "/^CFLAGS/s:CFLAGS =:CFLAGS +=:" \
		-e "/^CFLAGS/s/-O//" \
		src/Makefile || die

		eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	default
	doman doc/imapfilter.1 doc/imapfilter_config.5
}
