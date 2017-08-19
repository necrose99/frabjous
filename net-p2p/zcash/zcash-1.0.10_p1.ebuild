# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 systemd user

MY_PV=${PV/_p/-}
DESCRIPTION="Cryptocurrency that offers privacy of transactions"
HOMEPAGE="https://z.cash"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT openssl AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples libs mining rust"

DEPEND="app-arch/unzip
	net-misc/wget"

QA_TEXTRELS="usr/bin/zcash-tx
	usr/bin/zcashd"

S="${WORKDIR}/${PN}-${MY_PV}"

pkg_setup() {
	if has network-sandbox $FEATURES; then
		die "net-p2p/zcash require 'network-sandbox' to be disabled in FEATURES"
	fi

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/zcashd ${PN}
}

src_prepare() {
	sed -i 's:./b2:./b2 --ignore-site-config:g' \
		depends/packages/boost.mk || die "sed fix failed"

	default
}

src_compile() {
	unset ABI
	./zcutil/build.sh --disable-tests \
		$(usex mining '' --disable-mining) \
		$(usex rust '' --disable-rust) \
		$(usex libs '' --disable-libs) \
		|| die "Build failed!"
}

src_install() {
	emake prefix="${D}/usr" install

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	insinto /etc/zcash
	doins "${FILESDIR}"/${PN}.conf
	fowners zcash:zcash /etc/zcash/${PN}.conf
	fperms 0600 /etc/zcash/${PN}.conf
	newins contrib/debian/examples/${PN}.conf ${PN}.conf.example

	keepdir /var/lib/zcashd
	dosym ../../../etc/zcash/${PN}.conf /var/lib/zcashd/${PN}.conf

	dodoc doc/{payment-api,security-warnings,tor}.md

	newbashcomp contrib/bitcoind.bash-completion ${PN}d
	newbashcomp contrib/bitcoin-cli.bash-completion ${PN}-cli
	newbashcomp contrib/bitcoin-tx.bash-completion ${PN}-tx

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	if use examples; then
		docinto examples
		dodoc -r contrib/{bitrpc,qos,spendfrom}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	ewarn
	ewarn "SECURITY WARNINGS:"
	ewarn "Zcash is experimental and a work-in-progress. Use at your own risk."
	ewarn
	ewarn "Please, see important security warnings in"
	ewarn "${EROOT}usr/share/doc/${P}/security-warnings.md.bz2"
	ewarn

	einfo
	einfo "You should manually fetch the parameters for all users:"
	einfo "$ zcash-fetch-params"
	einfo
	einfo "This script will fetch the Zcash zkSNARK parameters and verify"
	einfo "their integrity with sha256sum."
	einfo
	einfo "The parameters are currently just under 911MB in size, so plan accordingly"
	einfo "for your bandwidth constraints. If the files are already present and"
	einfo "have the correct sha256sum, no networking is used."
	einfo
}
