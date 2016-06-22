# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

inherit db-use autotools eutils toolchain-funcs user systemd

DESCRIPTION="Bitcoin Classic crypto-currency wallet for automated services"
HOMEPAGE="https://bitcoinclassic.com/"
SRC_URI="https://github.com/bitcoinclassic/bitcoinclassic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="+doc examples libressl +logrotate system-libsecp256k1 system-univalue test upnp +wallet zeromq"

WALLET_DEPEND="media-gfx/qrencode sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]"

RDEPEND="
	app-shells/bash:0
	dev-libs/boost:0[threads(+)]
	dev-libs/glib:2
	dev-libs/crypto++
	!libressl? ( dev-libs/openssl:0[-bindist] )
	libressl? ( dev-libs/libressl )
	logrotate? ( app-admin/logrotate )
	system-libsecp256k1? ( =dev-libs/libsecp256k1-0.0.0_pre20151118[recovery] )
	system-univalue? ( dev-libs/univalue )
	virtual/bitcoin-leveldb
	upnp? ( net-libs/miniupnpc )
	wallet? ( ${WALLET_DEPEND} )
	zeromq? ( net-libs/zeromq )
"

DEPEND="${RDEPEND}"

REQUIRED_USE="system-libsecp256k1? ( system-univalue )"

S="${WORKDIR}/bitcoinclassic-${PV}"

pkg_setup() {
	local UG='bitcoin'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/bitcoinclassic "${UG}"
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
	if use !zeromq; then
		my_econf="${my_econf} --disable-zmq"
	fi
	my_econf="${my_econf} --with-system-leveldb"
	econf \
		--disable-bench \
		--disable-ccache \
		--disable-static \
		--disable-util-cli \
		--disable-util-tx \
		--without-libs \
		--with-daemon \
		--without-gui \
		${my_econf} \
		$(use_with system-libsecp256k1) \
		$(use_with system-univalue) \
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
	local my_data="/var/lib/bitcoinclassic"

	dobin src/${PN}

	insinto /etc/bitcoinclassic
	newins "${FILESDIR}/bitcoin.conf" bitcoin.conf
	fowners bitcoin:bitcoin /etc/bitcoinclassic/bitcoin.conf
	fperms 660 /etc/bitcoinclassic/bitcoin.conf

	newconfd "${FILESDIR}/bitcoinclassicd.confd" ${PN}
	newinitd "${FILESDIR}/bitcoinclassicd.initd" ${PN}
	systemd_dounit "${FILESDIR}/bitcoinclassicd.service"

	keepdir "${my_data}"
	fperms 750 "${my_data}"
	fowners bitcoin:bitcoin "${my_data}"
	dosym /etc/bitcoinclassic/bitcoin.conf "${my_data}/bitcoin.conf"

	if use doc; then
		dodoc doc/README.md
		dodoc doc/release-notes.md
		dodoc doc/assets-attribution.md doc/bips.md doc/tor.md
		doman contrib/debian/manpages/{bitcoind.1,bitcoin.conf.5}
		use zeromq && dodoc -r contrib/zmq
	fi

	if use examples; then
		docinto examples
		dodoc -r contrib/{qos,spendfrom,tidy_datadir.sh}
	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/bitcoinclassicd.logrotate" ${PN}
	fi
}
