# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit systemd user

DESCRIPTION="A server-side dnscrypt proxy"
HOMEPAGE="https://dnscrypt.org/"
SRC_URI="https://github.com/cofyc/dnscrypt-wrapper/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc examples"

DEPEND="
	dev-libs/libsodium
	>=dev-libs/libevent-2.1.5"
RDEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_install() {
	local my_data="/etc/dnscrypt-wrapper"

	dosbin ${PN}

	dodir "${my_data}"
	fperms 750 "${my_data}"
	fowners dnscrypt:dnscrypt "${my_data}"

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	if use doc; then
		dodoc -r {COPYING,README.md}
	fi

	if use examples; then
		docinto examples
		dodoc -r example/{1.cert,1.key,README.md,public.key,secret.key,start_proxy.sh,start_wrapper.sh}
	fi
}
