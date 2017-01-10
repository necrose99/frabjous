# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"

inherit bash-completion-r1 systemd user

DESCRIPTION="Cryptocurrency that offers privacy of transactions"
HOMEPAGE="https://z.cash/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples +hardened test"

DEPEND="app-arch/unzip
	net-misc/wget"

RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 /var/lib/zcashd "${PN}"
}

src_prepare() {
	eapply_user
}

src_compile() {
	unset ABI
	if ! use hardened ; then
		sed -i 's/--enable-hardening/--disable-hardening/' zcutil/build.sh \
			|| die "sed fix failed. Uh-oh..."
	fi
	sed -i 's/\.\/b2/\.\/b2 --ignore-site-config/g' depends/packages/boost.mk \
		|| die "sed fix failed. Uh-oh..."
	if ! use test ; then
		./zcutil/build.sh --disable-tests || die "Build failed!"
	else
		./zcutil/build.sh || die "Build failed!"
	fi
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
	doins "${FILESDIR}/${PN}.conf"
	fowners zcash:zcash "${my_etc}/${PN}.conf"
	fperms 0600 "${my_etc}/${PN}.conf"
	newins contrib/DEBIAN/examples/${PN}.conf ${PN}.conf.example

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir "${my_data}"
	fowners zcash:zcash "${my_data}"
	fperms 0700 "${my_data}"
	dosym ${my_etc}/${PN}.conf "${my_data}/${PN}.conf"

	dodoc doc/{payment-api.md,security-warnings.md,tor.md}
	doman contrib/DEBIAN/manpages/zcashd.1
	doman contrib/DEBIAN/manpages/zcash-cli.1
	newbashcomp contrib/bitcoind.bash-completion ${PN}d
	newbashcomp contrib/bitcoin-cli.bash-completion ${PN}-cli
	newbashcomp contrib/bitcoin-tx.bash-completion ${PN}-tx

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	if use examples; then
		docinto examples
		dodoc -r contrib/{bitrpc,qos,spendfrom,tidy_datadir.sh}
	fi
}

pkg_postinst() {
	ewarn
	ewarn "SECURITY WARNINGS:"
	ewarn "Zcash is unfinished and highly experimental. Use at your own risk."
	ewarn
	ewarn "Please, see important security warnings in"
	ewarn "${EROOT}usr/share/doc/${P}/security-warnings.md.bz2"
	ewarn

	einfo
	einfo "You should manually fetch the parameters for all users:"
	einfo "$ ${PN}-fetch-params"
	einfo
	einfo "This script will fetch the Zcash zkSNARK parameters and verify"
	einfo "their integrity with sha256sum."
	einfo
	einfo "The parameters are currently just under 911MB in size, so plan accordingly"
	einfo "for your bandwidth constraints. If the files are already present and"
	einfo "have the correct sha256sum, no networking is used."
	einfo
}
