# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"

inherit autotools bash-completion-r1 fdo-mime gnome2-utils kde4-functions systemd user

My_PV="${PV/\.0f/}F"
DESCRIPTION="Bitcoin XT crypto-currency wallet for automated services"
HOMEPAGE="https://bitcoinxt.software/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${My_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="+daemon dbus examples gui +hardened kde libressl qrcode test upnp +utils +wallet +zeromq"
LANGS="ach af_ZA ar be_BY bg bs ca ca@valencia ca_ES cmn cs cy da de el_GR en eo es es_CL es_DO es_MX es_UY et eu_ES fa fa_IR fi fr fr_CA gl gu_IN he hi_IN hr hu id_ID it ja ka kk_KZ ko_KR ky la lt lv_LV mn ms_MY nb nl pam pl pt_BR pt_PT ro_RO ru sah sk sl_SI sq sr sv th_TH tr uk ur_PK uz@Cyrl vi vi_VN zh_HK zh_CN zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

DEPEND="
	dev-libs/boost:0[threads(+)]
	dev-libs/libevent
	net-misc/curl
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
		!net-p2p/bitcoin-classic[daemon]
		!net-p2p/bitcoin-unlimited[daemon]
	)
	gui?  (
		!net-p2p/bitcoin-qt
		!net-p2p/bitcoin-classic[gui]
		!net-p2p/bitcoin-unlimited[gui,qt4,qt5]
	)
	utils? (
		!net-p2p/bitcoin-cli
		!net-p2p/bitcoin-tx
		!net-p2p/bitcoin-classic[utils]
		!net-p2p/bitcoin-unlimited[utils]
	)"

RDEPEND="${DEPEND} ${NDEPEND}"

REQUIRED_USE="
	|| ( daemon gui utils )
	dbus? ( gui )
	kde? ( gui )
	qrcode? ( gui )"

S="${WORKDIR}/bitcoinxt-${My_PV}"

pkg_setup() {
	if use daemon; then
		local UG='bitcoinxt'
		enewgroup "${UG}"
		enewuser "${UG}" -1 -1 /var/lib/bitcoinxt "${UG}"
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
		$(use_with libressl) \
		$(use_with dbus qtdbus) \
		$(use_with qrcode qrencode)
}

src_install() {
	if use daemon; then
		local my_etc="/etc/bitcoinxt"
		local my_home="/var/lib/bitcoinxt"
		local my_data="${my_home}/.bitcoin"

		dobin src/bitcoind

		insinto "${my_etc}"
		newins "${FILESDIR}/${PN}.conf" bitcoin.conf
		fowners bitcoinxt:bitcoinxt "${my_etc}"/bitcoin.conf
		fperms 600 "${my_etc}"/bitcoin.conf
		newins contrib/debian/examples/bitcoin.conf bitcoin.conf.example

		newconfd "${FILESDIR}/${PN}.confd" ${PN}
		newinitd "${FILESDIR}/${PN}.initd" ${PN}
		systemd_dounit "${FILESDIR}/${PN}.service"

		keepdir "${my_data}"
		fperms 700 "${my_home}"
		fowners bitcoinxt:bitcoinxt "${my_home}"
		fowners bitcoinxt:bitcoinxt "${my_data}"
		dosym "${my_etc}"/bitcoin.conf "${my_data}"/bitcoin.conf

		dodoc doc/{assets-attribution.md,bips.md,tor.md}
		doman contrib/debian/manpages/{bitcoind.1,bitcoin.conf.5}
		newbashcomp contrib/bitcoind.bash-completion ${PN}

		insinto /etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotate" ${PN}
	fi

	if use gui; then
		dobin src/qt/bitcoin-qt

		# Install icons and desktop entry.
		local size
		for size in 16 32 64 128 256 ; do
			newicon -s ${size} "share/pixmaps/bitcoin${size}.png" bitcoin.png
		done
		make_desktop_entry "bitcoin-qt %u" "Bitcoin XT" "bitcoin" \
			"Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/bitcoin;\nTerminal=false"

		if use kde; then
			insinto /usr/share/kde4/services
			doins contrib/debian/bitcoin-qt.protocol
			dosym "../kde4/services/bitcoin-qt.protocol" "/usr/share/kservices5/bitcoin-qt.protocol"
		fi

		use daemon || dodoc doc/{assets-attribution.md,bips.md,tor.md}
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
