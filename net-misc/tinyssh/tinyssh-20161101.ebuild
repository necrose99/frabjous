# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

DESCRIPTION="A small SSH server with state-of-the-art cryptography"
HOMEPAGE="https://tinyssh.org"
SRC_URI="https://github.com/janmojzis/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-apps/ucspi-tcp"
RESTRICT="mirror"

src_prepare() {
	# Leave optimization level to user CFLAGS
	sed -i 's/-O3 -fomit-frame-pointer -funroll-loops//g' \
		./conf-cc || die "sed fix failed!"

	# Use make-tinysshcc.sh script, which has
	# no tests and doesn't execute binaries
	# https://github.com/janmojzis/tinyssh/issues/2
	sed -i 's/tinyssh/tinysshcc/g' ./Makefile || die

	default
}

src_compile() {
	emake compile
}

src_install() {
	dosbin build/bin/${PN}d{,-makekey}
	dobin build/bin/${PN}d-printkey
	doman man/*

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	systemd_newunit "${FILESDIR}"/${PN}.service "${PN}@.service"
	systemd_newunit "${FILESDIR}"/${PN}.socket "${PN}@.socket"
	systemd_dounit "${FILESDIR}"/${PN}-makekey.service
}

pkg_postinst() {
	ewarn
	ewarn "WARNING:"
	ewarn "TinySSH is in alpha stage, not ready for production use!"
	ewarn
	ewarn "Please, see https://tinyssh.org for more information."
	ewarn
}
