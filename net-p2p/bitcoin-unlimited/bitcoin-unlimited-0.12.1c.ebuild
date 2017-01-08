# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"

inherit autotools bash-completion-r1 fdo-mime gnome2-utils kde4-functions systemd user

DESCRIPTION="Bitcoin Unlimited crypto-currency wallet for automated services"
HOMEPAGE="https://www.bitcoinunlimited.info/"
SRC_URI="https://github.com/BitcoinUnlimited/BitcoinUnlimited/archive/bu${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="+daemon dbus examples gui +hardened kde libressl qrcode test upnp +utils +wallet +zeromq"
LANGS="ach af af_ZA ar be_BY bg bg_BG bs ca ca@valencia ca_ES cmn cs cs_CZ cy da de el el_GR en en_GB eo es es_AR es_CL es_CO es_DO es_ES es_MX es_UY es_VE et eu_ES fa fa_IR fi fr fr_CA fr_FR gl gu_IN he hi_IN hr hu id_ID it ja ka kk_KZ ko_KR ky la lt lv_LV mk_MK mn ms_MY nb nl pam pl pt_BR pt_PT ro ro_RO ru ru_RU sk sl_SI sq sr sv ta th_TH tr tr_TR uk ur_PK uz@Cyrl uz@Latn vi vi_VN zh zh_CN zh_HK zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

DEPEND="
	dev-libs/boost:0[threads(+)]
	dev-libs/libevent
	gui? (
		dev-libs/protobuf
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		dev-qt/linguist-tools:5
		dbus? ( dev-qt/qtdbus:5 )
		qrcode? ( media-gfx/qrencode )
	)
	!libressl? ( dev-libs/openssl:0[-bindist] )
	libressl? ( dev-libs/libressl )
	upnp? ( net-libs/miniupnpc )
	wallet? ( media-gfx/qrencode sys-libs/db:4.8[cxx] )
	zeromq? ( net-libs/zeromq )"

NDEPEND="
	daemon? (
		!net-p2p/bitcoind
		!net-p2p/bitcoinxt[daemon]
		!net-p2p/bitcoin-classic[daemon]
	)
	gui?  (
		!net-p2p/bitcoin-qt
		!net-p2p/bitcoinxt[gui]
		!net-p2p/bitcoin-classic[gui]
	)
	utils? (
		!net-p2p/bitcoin-cli
		!net-p2p/bitcoin-tx
		!net-p2p/bitcoinxt[utils]
		!net-p2p/bitcoin-classic[utils]
	)"

RDEPEND="${DEPEND} ${NDEPEND}"

REQUIRED_USE="
	|| ( daemon gui utils )
	dbus? ( gui )
	kde? ( gui )
	qrcode? ( gui )"

S="${WORKDIR}/BitcoinUnlimited-bu${PV}"

pkg_setup() {
	if use daemon; then
		local UG='bitcoin'
		enewgroup "${UG}"
		enewuser "${UG}" -1 -1 /var/lib/bitcoin "${UG}"
	fi
}

src_prepare() {
	if use gui; then
		local filt= yeslang= nolang= lan ts x

		for lan in $LANGS; do
			if [ ! -e src/qt/locale/bitcoin_$lan.ts ]; then
				die "Language '$lan' no longer supported. Ebuild needs update."
			fi
		done

		for ts in $(ls src/qt/locale/*.ts)
		do
			x="${ts/*bitcoin_/}"
			x="${x/.ts/}"
			if ! use "linguas_$x"; then
				nolang="$nolang $x"
				rm "$ts" || die
				filt="$filt\\|$x"
			else
				yeslang="$yeslang $x"
			fi
		done
		filt="bitcoin_\\(${filt:2}\\)\\.\(qm\|ts\)"
		sed "/${filt}/d" -i 'src/qt/bitcoin_locale.qrc' || die
		sed "s/locale\/${filt}/bitcoin.qrc/" -i 'src/Makefile.qt.include' || die
		einfo "Languages -- Enabled:$yeslang -- Disabled:$nolang"
	fi

	use daemon || sed -i 's/have bitcoind &&//;s/^\(complete -F _bitcoind \)bitcoind \(bitcoin-cli\)$/\1\2/' \
		contrib/bitcoind.bash-completion || die

	use utils || sed -i 's/have bitcoind &&//;s/^\(complete -F _bitcoind bitcoind\) bitcoin-cli$/\1/' \
		contrib/bitcoind.bash-completion || die

	eapply_user
	eautoreconf
}

src_configure() {
	local my_econf=

	if use !daemon; then
		my_econf="${my_econf} --without-daemon"
	fi
	if use gui; then
		my_econf="${my_econf} --with-gui=qt5"
	else
		my_econf="${my_econf} --without-gui"
	fi
	if use !hardened; then
		my_econf="${my_econf} --disable-hardening"
	fi
	if use !test; then
		my_econf="${my_econf} --disable-tests"
	fi
	if use upnp; then
		my_econf="${my_econf} --with-miniupnpc --enable-upnp-default"
	else
		my_econf="${my_econf} --without-miniupnpc --disable-upnp-default"
	fi
	if use !utils; then
		my_econf="${my_econf} --without-utils"
	fi
	if use !wallet; then
		my_econf="${my_econf} --disable-wallet"
	fi
	if use !zeromq; then
		my_econf="${my_econf} --disable-zmq"
	fi
	econf \
		--disable-bench \
		--disable-ccache \
		--disable-maintainer-mode \
		--enable-reduce-exports \
		--without-libs \
		${my_econf} \
		$(use_with dbus qtdbus)  \
		$(use_with qrcode qrencode)
}

src_install() {
	if use daemon; then
		local my_etc="/etc/bitcoin"
		local my_home="/var/lib/bitcoin"
		local my_data="${my_home}/.bitcoin"

		dobin src/bitcoind

		insinto "${my_etc}"
		newins "${FILESDIR}/${PN}.conf" bitcoin.conf
		fowners bitcoin:bitcoin "${my_etc}"/bitcoin.conf
		fperms 600 "${my_etc}"/bitcoin.conf
		newins contrib/debian/examples/bitcoin.conf bitcoin.conf.example
		doins share/rpcuser/rpcuser.py

		newconfd "${FILESDIR}/${PN}.confd" ${PN}
		newinitd "${FILESDIR}/${PN}.initd" ${PN}
		systemd_dounit "${FILESDIR}/${PN}.service"

		keepdir "${my_data}"
		fperms 700 "${my_home}"
		fowners bitcoin:bitcoin "${my_home}"
		fowners bitcoin:bitcoin "${my_data}"
		dosym "${my_etc}"/bitcoin.conf "${my_data}"/bitcoin.conf

		dodoc doc/{bips.md,tor.md}
		doman contrib/debian/manpages/{bitcoind.1,bitcoin.conf.5}
		newbashcomp contrib/bitcoind.bash-completion ${PN}

		insinto /etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotate" ${PN}
	fi

	if use gui; then
		dobin src/qt/bitcoin-qt

		# Install icons and desktop entry.
		for size in 16 24 32 64 128 256 512 ; do
			newicon -s ${size} "share/pixmaps/bitcoin${size}.png" bitcoin.png
		done
		make_desktop_entry "bitcoin-qt %u" "Bitcoin Unlimited" "bitcoin" \
			"Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/bitcoin;\nTerminal=false"

		if use kde; then
			insinto /usr/share/kde4/services
			doins contrib/debian/bitcoin-qt.protocol
			dosym "../kde4/services/bitcoin-qt.protocol" "/usr/share/kservices5/bitcoin-qt.protocol"
		fi

		use daemon || dodoc doc/{bips.md,tor.md}
		doman contrib/debian/manpages/bitcoin-qt.1
	fi

	if use examples; then
		docinto examples
		use daemon && dodoc -r contrib/{qos,spendfrom,tidy_datadir.sh}
		use zeromq && dodoc -r contrib/zmq
	fi

	if use utils; then
		dobin src/bitcoin-cli
		dobin src/bitcoin-tx

		doman contrib/debian/manpages/bitcoin-cli.1
		use daemon || newbashcomp contrib/bitcoind.bash-completion ${PN}
	fi
}

pkg_preinst() {
	use gui && gnome2_icon_savelist
}

update_caches() {
	use gui && gnome2_icon_cache_update && \
	fdo-mime_desktop_database_update && \
	buildsycoca
}

pkg_postinst() {
	use gui && update_caches
}

pkg_postrm() {
	use gui && update_caches
}
