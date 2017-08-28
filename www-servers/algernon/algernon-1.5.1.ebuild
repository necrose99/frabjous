# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/xyproto/${PN}"
DESCRIPTION="Pure Go web server with built-in Lua, Markdown, HyperApp and Pongo2 support"
HOMEPAGE="http://algernon.roboticoverlords.org"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples mysql postgres redis"

RDEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:* )
	redis? ( dev-db/redis )"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup algernon
	enewuser algernon -1 -1 -1 algernon
}

src_compile() {
	GOPATH="${S}" go build -v -ldflags "-s -w" ${EGO_PN} || die
}

src_install() {
	dobin ${PN}
	pushd src/${EGO_PN} > /dev/null || die
	dobin desktop/mdview

	insinto /etc/algernon
	doins system/serverconf.lua

	if use examples; then
		docinto examples
		dodoc -r samples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
	popd > /dev/null || die

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	dodir /var/www/algernon
	diropts -o algernon -g algernon -m 0700
	dodir /var/log/algernon

	insinto /etc/logrotate.d
	doins "${FILESDIR}"/${PN}.logrotate
}
