# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror"

inherit autotools bash-completion-r1 fdo-mime gnome2-utils kde4-functions systemd user

MY_PV="${PV/\.0f/}F"
DESCRIPTION="An alternative full node Bitcoin implementation with GUI, daemon and utils"
HOMEPAGE="https://bitcoinxt.software"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="daemon +dbus examples +gui +hardened kde libressl +qrcode test upnp utils +wallet zeromq"
LANGS="ach af_ZA ar be_BY bg bs ca ca@valencia ca_ES cmn cs cy da de el_GR en eo es es_CL es_DO es_MX es_UY et eu_ES fa fa_IR fi fr fr_CA gl gu_IN he hi_IN hr hu id_ID it ja ka kk_KZ ko_KR ky la lt lv_LV mn ms_MY nb nl pam pl pt_BR pt_PT ro_RO ru sah sk sl_SI sq sr sv th_TH tr uk ur_PK uz@Cyrl vi vi_VN zh_HK zh_CN zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

CDEPEND="dev-libs/boost:0[threads(+)]
	dev-libs/libevent
	net-misc/curl
	gui? (
		dev-libs/protobuf
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		dbus? ( dev-qt/qtdbus:5 )
		qrcode? ( media-gfx/qrencode )
	)
	!libressl? ( dev-libs/openssl:0[-bindist] )
	libressl? ( dev-libs/libressl )
	upnp? ( net-libs/miniupnpc )
	wallet? ( media-gfx/qrencode sys-libs/db:4.8[cxx] )
	zeromq? ( net-libs/zeromq )"
DEPEND="${CDEPEND}
	gui? ( dev-qt/linguist-tools )"
RDEPEND="${CDEPEND}
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

REQUIRED_USE="
	|| ( daemon gui utils )
	dbus? ( gui )
	kde? ( gui )
	qrcode? ( gui )"

S="${WORKDIR}/${PN}-${MY_PV}"
UG="${PN}"

pkg_setup() {
	if use daemon; then
		enewgroup ${UG}
		enewuser ${UG} -1 -1 /var/lib/bitcoinxt ${UG}
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
	local myconf=
	use daemon || myconf+=( --without-daemon )
	use dbus && myconf+=( --with-qtdbus )
	use gui && myconf+=( --with-gui=qt5 )
	use gui || myconf+=( --without-gui )
	use hardened || myconf+=( --disable-hardening )
	use libressl && myconf+=( --with-libressl )
	use qrcode && myconf+=( --with-qrencode )
	use test || myconf+=( --disable-tests )
	use upnp && myconf+=( --with-miniupnpc --enable-upnp-default )
	use upnp || myconf+=( --without-miniupnpc --disable-upnp-default )
	use utils || myconf+=( --without-utils )
	use wallet || myconf+=( --disable-wallet )
	use zeromq || myconf+=( --disable-zmq )
	econf \
		--without-libs \
		--disable-bench \
		--disable-ccache \
		--disable-maintainer-mode \
		--enable-reduce-exports \
		"${myconf[@]}" || die
}

src_install() {
	if use daemon; then
		local my_etc="/etc/bitcoinxt"

		dobin src/bitcoind

		insinto "${my_etc}"
		newins "${FILESDIR}"/${PN}.conf bitcoin.conf
		fowners ${UG}:${UG} "${my_etc}"/bitcoin.conf
		fperms 600 "${my_etc}"/bitcoin.conf
		newins contrib/debian/examples/bitcoin.conf bitcoin.conf.example

		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service

		keepdir "/var/lib/bitcoinxt/.bitcoin"

		dodoc doc/{assets-attribution.md,bips.md,tor.md}
		doman contrib/debian/manpages/{bitcoind.1,bitcoin.conf.5}
		newbashcomp contrib/bitcoind.bash-completion ${PN}

		insinto /etc/logrotate.d
		newins "${FILESDIR}"/${PN}.logrotate ${PN}
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
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	buildsycoca
}

pkg_postinst() {
	use gui && update_caches

	if use daemon; then
		chmod 0750 "${EROOT%/}"/var/lib/bitcoinxt || die
		chown -R ${PN}:${PN} "${EROOT%/}"/var/lib/bitcoinxt || die
	fi
}

pkg_postrm() {
	use gui && update_caches
}
