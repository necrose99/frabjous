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
	local X
	emake prefix="${D}/usr" install

	newinitd "${FILESDIR}"/${PN}.initd-r3 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r3 ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd-r2 ${PN}.conf

	insinto /etc/zcash
	doins "${FILESDIR}"/${PN}.conf
	fowners zcash:zcash /etc/zcash/${PN}.conf
	fperms 0600 /etc/zcash/${PN}.conf
	newins contrib/debian/examples/${PN}.conf ${PN}.conf.example

	dodoc doc/{payment-api,security-warnings,tor}.md

	for X in '-cli' '-tx' 'd'; do
		newbashcomp contrib/bitcoin${X}.bash-completion ${PN}${X}
	done

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
	if [ -z "${REPLACING_VERSIONS}" ]; then
		einfo
		elog "You should manually fetch the parameters for all users:"
		elog "$ zcash-fetch-params"
		elog
		elog "This script will fetch the Zcash zkSNARK parameters and verify"
		elog "their integrity with sha256sum."
		elog
		elog "The parameters are currently just under 911MB in size, so plan accordingly"
		elog "for your bandwidth constraints. If the files are already present and"
		elog "have the correct sha256sum, no networking is used."
		einfo
	fi
}
