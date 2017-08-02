# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools bash-completion-r1 fdo-mime gnome2-utils kde4-functions systemd user

UG="bitcoin"
DESCRIPTION="A full node Bitcoin implementation with GUI, daemon and utils"
HOMEPAGE="https://bitcoin.org"
SRC_URI="https://github.com/${UG}/${UG}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="daemon dbus +gui kde libressl +qrcode system-univalue upnp utils +wallet zeromq"
LANGS="af af_ZA ar be_BY bg bg_BG ca ca@valencia ca_ES cs cy da de el el_GR en en_GB \
	eo es es_AR es_CL es_CO es_DO es_ES es_MX es_UY es_VE et et_EE eu_ES fa fa_IR fi \
	fr fr_CA fr_FR gl he hi_IN hr hu id_ID it it_IT ja ka kk_KZ ko_KR ku_IQ ky la lt \
	lv_LV mk_MK mn ms_MY nb ne nl pam pl pt_BR pt_PT ro ro_RO ru ru_RU sk sl_SI sq sr \
	sr@latin sv ta th_TH tr tr_TR uk ur_PK uz@Cyrl vi vi_VN zh zh_CN zh_HK zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

CDEPEND="dev-libs/boost:0[threads(+)]
	dev-libs/libevent
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
	system-univalue? ( dev-libs/univalue )
	upnp? ( net-libs/miniupnpc )
	wallet? (
		media-gfx/qrencode
		sys-libs/db:4.8[cxx]
	)
	zeromq? ( net-libs/zeromq )"
DEPEND="${CDEPEND}
	gui? ( dev-qt/linguist-tools )"
RDEPEND="${CDEPEND}
	daemon? (
		!net-p2p/bitcoind
		!net-p2p/bitcoinxt[daemon]
		!net-p2p/bitcoin-abc[daemon]
		!net-p2p/bitcoin-classic[daemon]
		!net-p2p/bitcoin-unlimited[daemon]
	)
	gui?  (
		!net-p2p/bitcoin-qt
		!net-p2p/bitcoinxt[gui]
		!net-p2p/bitcoin-abc[gui]
		!net-p2p/bitcoin-classic[gui]
		!net-p2p/bitcoin-unlimited[gui]
	)
	utils? (
		!net-p2p/bitcoin-cli
		!net-p2p/bitcoin-tx
		!net-p2p/bitcoinxt[utils]
		!net-p2p/bitcoin-abc[utils]
		!net-p2p/bitcoin-classic[utils]
		!net-p2p/bitcoin-unlimited[utils]
	)"

REQUIRED_USE="
	|| ( daemon gui utils )
	dbus? ( gui )
	kde? ( gui )
	qrcode? ( gui )"

S="${WORKDIR}/${UG}-${PV}"

pkg_setup() {
	if use daemon; then
		enewgroup ${UG}
		enewuser ${UG} -1 -1 /var/lib/bitcoin ${UG}
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

	eapply_user
	eautoreconf
}

src_configure() {
	local myconf=
	use gui && myconf+=( --with-gui=qt5 )
	use gui || myconf+=( --without-gui )
	use upnp && myconf+=( --with-miniupnpc --enable-upnp-default )
	use upnp || myconf+=( --without-miniupnpc --disable-upnp-default )
	econf \
		--without-libs \
		--disable-bench \
		--disable-ccache \
		--disable-maintainer-mode \
		--disable-tests \
		--enable-reduce-exports \
		$(use_with daemon) \
		$(use_with qrcode qrencode) \
		$(use_with system-univalue) \
		$(use_with utils) \
		$(use_enable wallet) \
		$(use_enable zeromq zmq) \
		"${myconf[@]}" || die
}

src_install() {
	default

	if use daemon; then
		local my_etc="/etc/bitcoin"

		insinto "${my_etc}"
		newins "${FILESDIR}"/${PN}.conf bitcoin.conf
		fowners ${UG}:${UG} "${my_etc}"/bitcoin.conf
		fperms 600 "${my_etc}"/bitcoin.conf
		newins contrib/debian/examples/bitcoin.conf bitcoin.conf.example
		doins share/rpcuser/rpcuser.py

		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service

		keepdir "/var/lib/bitcoin/.bitcoin"

		doman doc/man/bitcoind.1
		newbashcomp contrib/bitcoind.bash-completion ${UG}d

		insinto /etc/logrotate.d
		newins "${FILESDIR}"/${PN}.logrotate ${PN}
	fi

	if use gui; then
		local size
		for size in 16 32 64 128 256 ; do
			newicon -s ${size} "share/pixmaps/bitcoin${size}.png" bitcoin.png
		done
		make_desktop_entry "bitcoin-qt %u" "Bitcoin Core" "bitcoin" \
			"Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/bitcoin;\nTerminal=false"

		if use kde; then
			insinto /usr/share/kde4/services
			doins contrib/debian/bitcoin-qt.protocol
			dosym "../kde4/services/bitcoin-qt.protocol" "/usr/share/kservices5/bitcoin-qt.protocol"
		fi

		doman doc/man/bitcoin-qt.1
	fi

	if use utils; then
		doman doc/man/bitcoin-{cli,tx}.1
		newbashcomp contrib/bitcoin-cli.bash-completion ${UG}-cli
		newbashcomp contrib/bitcoin-tx.bash-completion ${UG}-tx
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
		chmod 0750 "${EROOT%/}"/var/lib/bitcoin || die
		chown -R ${UG}:${UG} "${EROOT%/}"/var/lib/bitcoin || die
	fi
}

pkg_postrm() {
	use gui && update_caches
}
