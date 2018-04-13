# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 systemd user

DESCRIPTION="A server-side DNSCrypt proxy"
HOMEPAGE="https://github.com/cofyc/dnscrypt-wrapper"
EGIT_REPO_URI="https://github.com/cofyc/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DEPEND="dev-libs/libsodium[-minimal]
	>=dev-libs/libevent-2.1.8"
RDEPEND="${DEPEND}"

DOCS=( README.md )

pkg_setup() {
	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" \
		DESTDIR="${D}" install

	diropts -o dnscrypt -g dnscrypt -m750
	dodir /etc/dnscrypt-wrapper

	newinitd "${FILESDIR}"/${PN}.initd-r3 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r2 ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service

	insinto /etc/default
	newins "${FILESDIR}"/${PN}.confd-r2 ${PN}

	einstalldocs

	if use examples; then
		docinto examples
		dodoc -r example/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
