# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror"

inherit bash-completion-r1 systemd user versionator

MY_PV=$(replace_version_separator 3 '-')
DESCRIPTION="Cryptocurrency that offers privacy of transactions"
HOMEPAGE="https://z.cash"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT openssl AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+examples mining proton rust test"

DEPEND="app-arch/unzip
	net-misc/wget"

S="${WORKDIR}/${PN}-${MY_PV}"

pkg_setup() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 /var/lib/zcashd "${PN}"
}

src_prepare() {
	unset ABI
	sed -i 's/\.\/b2/\.\/b2 --ignore-site-config/g' depends/packages/boost.mk \
		|| die "sed fix failed. Uh-oh..."

	eapply_user
}

src_compile() {
	./zcutil/build.sh \
		$(usex !test "--disable-tests" "") \
		$(usex !mining "--disable-mining" "") \
		$(usex !rust "--disable-rust" "") \
		$(usex proton "--enable-proton" "") \
		|| die "Build failed!"
}

src_install() {
	dobin src/{zcashd,zcash-cli,zcash-tx}
	dobin src/zcash/GenerateParams
	newbin zcutil/fetch-params.sh ${PN}-fetch-params

	dolib.so src/.libs/libzcashconsensus.so*

	insinto /usr/include/${PN}
	doins src/script/zcashconsensus.h

	local my_etc="/etc/zcash"
	local my_data="/var/lib/zcashd"

	insinto "${my_etc}"
	doins "${FILESDIR}"/${PN}.conf
	fowners ${PN}:${PN} "${my_etc}"/${PN}.conf
	fperms 0600 "${my_etc}"/${PN}.conf
	use examples && newins contrib/debian/examples/${PN}.conf ${PN}.conf.example

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	keepdir "${my_data}"
	dosym ${my_etc}/${PN}.conf "${my_data}"/${PN}.conf

	dodoc doc/{payment-api,security-warnings,tor}.md
	doman doc/man/zcashd.1
	doman doc/man/zcash-cli.1
	doman doc/man/zcash-fetch-params.1

	newbashcomp contrib/bitcoind.bash-completion ${PN}d
	newbashcomp contrib/bitcoin-cli.bash-completion ${PN}-cli
	newbashcomp contrib/bitcoin-tx.bash-completion ${PN}-tx

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	if use examples; then
		docinto examples
		dodoc -r contrib/{bitrpc,qos,spendfrom,tidy_datadir.sh}
	fi
}

pkg_postinst() {
	chmod 0750 "${EROOT%/}"/var/lib/zcashd || die
	chown -R ${PN}:${PN} "${EROOT%/}"/var/lib/zcashd || die

	ewarn
	ewarn "SECURITY WARNINGS:"
	ewarn "Zcash is unfinished and highly experimental. Use at your own risk."
	ewarn
	ewarn "Please, see important security warnings in"
	ewarn "${EROOT}usr/share/doc/${P}/security-warnings.md.bz2"
	ewarn

	elog
	elog "You should manually fetch the parameters for all users:"
	elog "$ ${PN}-fetch-params"
	elog
	elog "This script will fetch the Zcash zkSNARK parameters and verify"
	elog "their integrity with sha256sum."
	elog
	elog "The parameters are currently just under 911MB in size, so plan accordingly"
	elog "for your bandwidth constraints. If the files are already present and"
	elog "have the correct sha256sum, no networking is used."
	elog
}
