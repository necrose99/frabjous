# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools bash-completion-r1 fdo-mime gnome2-utils systemd user

MY_PN="${PN/-/}"
DESCRIPTION="A full node Bitcoin (or Bitcoin Cash) implementation with GUI, daemon and utils"
HOMEPAGE="https://bitcoinclassic.com"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="daemon dbus +gui hardened libressl +qrcode reduce-exports system-univalue uahf upnp utils +wallet zeromq"
LANGS="af af_ZA ar be_BY bg bg_BG bs ca ca@valencia ca_ES cs cs_CZ cy
	da de el el_GR en en_GB eo es es_AR es_CL es_CO es_DO es_ES es_MX
	es_UY es_VE et eu_ES fa fa_IR fi fr fr_CA fr_FR gl he hi_IN hr hu
	id_ID it ja ka kk_KZ ko_KR ky la lt lv_LV mk_MK mn ms_MY nb nl pam
	pl pt_BR pt_PT ro ro_RO ru ru_RU sk sl_SI sq sr sv ta th_TH tr tr_TR
	uk ur_PK uz@Cyrl uz@Latn vi vi_VN zh zh_CN zh_TW"

for X in ${LANGS}; do
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
	wallet? ( sys-libs/db:4.8[cxx] )
	zeromq? ( net-libs/zeromq )"
DEPEND="${CDEPEND}
	gui? ( dev-qt/linguist-tools )"
RDEPEND="${CDEPEND}
	daemon? (
		!net-p2p/bitcoind
		!net-p2p/bitcoinxt[daemon]
		!net-p2p/bitcoin-abc[daemon]
		!net-p2p/bitcoin-unlimited[daemon]
		!net-p2p/bucash[daemon]
	)
	gui?  (
		!net-p2p/bitcoin-qt
		!net-p2p/bitcoinxt[gui]
		!net-p2p/bitcoin-abc[gui]
		!net-p2p/bitcoin-unlimited[gui]
		!net-p2p/bucash[gui]
	)
	utils? (
		!net-p2p/bitcoin-cli
		!net-p2p/bitcoin-tx
		!net-p2p/bitcoinxt[utils]
		!net-p2p/bitcoin-abc[utils]
		!net-p2p/bitcoin-unlimited[utils]
		!net-p2p/bucash[utils]
	)"

REQUIRED_USE="dbus? ( gui ) qrcode? ( gui )"
RESTRICT="mirror"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	if use daemon; then
		enewgroup bitcoin
		enewuser bitcoin -1 -1 /var/lib/bitcoin bitcoin
	fi
}

src_prepare() {
	if use gui; then
		# Fix compatibility with LibreSSL
		eapply "${FILESDIR}"/${PN}-1.3.0-libressl.patch

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
	econf \
		--without-libs \
		--disable-ccache \
		--disable-maintainer-mode \
		--disable-tests \
		$(usex gui "--with-gui=qt5" --without-gui) \
		$(use_with daemon) \
		$(use_with qrcode qrencode) \
		$(use_with system-univalue) \
		$(use_with upnp miniupnpc) \
		$(use_with utils) \
		$(use_enable hardened hardening) \
		$(use_enable uahf) \
		$(use_enable reduce-exports) \
		$(use_enable wallet) \
		$(use_enable zeromq zmq) \
		|| die "econf failed"
}

src_install() {
	default

	if use daemon; then
		newbin share/rpcuser/rpcuser.py bitcoin-rpcuser

		newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
		newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service
		systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

		insinto /etc/bitcoin
		newins "${FILESDIR}"/${PN}.conf-r1 bitcoin.conf
		fowners bitcoin:bitcoin /etc/bitcoin/bitcoin.conf
		fperms 600 /etc/bitcoin/bitcoin.conf
		newins contrib/debian/examples/bitcoin.conf bitcoin.conf.example

		diropts -o bitcoin -g bitcoin -m 0750
		keepdir /var/lib/bitcoin/.bitcoin

		doman contrib/debian/manpages/{bitcoind.1,bitcoin.conf.5}
		newbashcomp contrib/bitcoind.bash-completion bitcoin

		insinto /etc/logrotate.d
		newins "${FILESDIR}"/${PN}.logrotate ${PN}
	fi

	if use gui; then
		local size
		for size in 16 32 64 128 256 ; do
			newicon -s ${size} "share/pixmaps/bitcoin${size}.png" bitcoin.png
		done
		make_desktop_entry "bitcoin-qt %u" "Bitcoin Classic" "bitcoin" \
			"Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/bitcoin;\nTerminal=false"

		doman contrib/debian/manpages/bitcoin-qt.1
	fi

	if use utils; then
		doman contrib/debian/manpages/bitcoin-cli.1
		use daemon || newbashcomp contrib/bitcoind.bash-completion bitcoin
	fi
}

pkg_preinst() {
	use gui && gnome2_icon_savelist
}

update_caches() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postinst() {
	use gui && update_caches
}

pkg_postrm() {
	use gui && update_caches
}
