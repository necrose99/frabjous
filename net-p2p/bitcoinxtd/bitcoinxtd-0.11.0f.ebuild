# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

inherit db-use autotools eutils toolchain-funcs user systemd

DESCRIPTION="BitcoinXT crypto-currency wallet for automated services"
HOMEPAGE="https://bitcoinxt.software/"
My_PV="${PV/\.0f/}F"
SRC_URI="https://github.com/bitcoinxt/bitcoinxt/archive/v${My_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="+doc examples libressl +logrotate system-libsecp256k1 test upnp +wallet"

WALLET_DEPEND="media-gfx/qrencode sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]"

RDEPEND="
	app-shells/bash:0
	dev-libs/boost:0[threads(+)]
	dev-libs/glib:2
	dev-libs/crypto++
	!libressl? ( dev-libs/openssl:0[-bindist] )
	libressl? ( dev-libs/libressl )
	logrotate? ( app-admin/logrotate )
	system-libsecp256k1? ( =dev-libs/libsecp256k1-0.0.0_pre20150423 )
	virtual/bitcoin-leveldb
	upnp? ( net-libs/miniupnpc )
	wallet? ( ${WALLET_DEPEND} )
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/bitcoinxt-${My_PV}"

pkg_setup() {
	local UG='bitcoin'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/bitcoinxt "${UG}"
}

src_prepare() {
	epatch "${FILESDIR}/${PV}-syslibs.patch"
	eautoreconf
}

src_configure() {
	local my_econf=

	if use upnp; then
		my_econf="${my_econf} --with-miniupnpc --enable-upnp-default"
	else
		my_econf="${my_econf} --without-miniupnpc --disable-upnp-default"
	fi
	if use test; then
		my_econf="${my_econf} --enable-tests"
	else
		my_econf="${my_econf} --disable-tests"
	fi
	if use wallet; then
		my_econf="${my_econf} --enable-wallet"
	else
		my_econf="${my_econf} --disable-wallet"
	fi
	my_econf="${my_econf} --with-system-leveldb"
	econf \
		--disable-ccache \
		--disable-static \
		--disable-util-cli \
		--disable-util-tx \
		--without-libs \
		--with-daemon \
		--without-gui \
		${my_econf} \
		$(use_with libressl) \
		$(use_with system-libsecp256k1) \
		"$@"
}

src_compile() {
	local OPTS=()

	OPTS+=("CXXFLAGS=${CXXFLAGS} -I$(db_includedir "${DB_VER}")")
	OPTS+=("LDFLAGS=${LDFLAGS} -ldb_cxx-${DB_VER}")

	use upnp && OPTS+=(USE_UPNP=1)

	cd src || die
	emake CXX="$(tc-getCXX)" "${OPTS[@]}" bitcoind
	mv bitcoind ${PN}
}

src_install() {
	local my_data="/var/lib/bitcoinxt"

	dobin src/${PN}

	insinto /etc/bitcoinxt
	newins "${FILESDIR}/bitcoin.conf" bitcoin.conf
	fowners bitcoin:bitcoin /etc/bitcoinxt/bitcoin.conf
	fperms 660 /etc/bitcoinxt/bitcoin.conf

	newconfd "${FILESDIR}/bitcoinxtd.confd" ${PN}
	newinitd "${FILESDIR}/bitcoinxtd.initd" ${PN}
	systemd_dounit "${FILESDIR}/bitcoinxtd.service"

	keepdir "${my_data}"
	fperms 750 "${my_data}"
	fowners bitcoin:bitcoin "${my_data}"
	dosym /etc/bitcoinxt/bitcoin.conf "${my_data}/bitcoin.conf"

	if use doc; then
		dodoc doc/README.md
		dodoc doc/release-notes.md
		dodoc doc/assets-attribution.md doc/bips.md doc/tor.md
		doman contrib/debian/manpages/{bitcoind.1,bitcoin.conf.5}
	fi

	if use examples; then
		docinto examples
		dodoc -r contrib/{qos,spendfrom,tidy_datadir.sh}
	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/bitcoinxtd.logrotate" ${PN}
	fi
}
