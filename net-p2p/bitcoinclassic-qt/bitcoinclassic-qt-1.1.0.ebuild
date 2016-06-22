# Copyright 2010-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

inherit db-use autotools eutils toolchain-funcs fdo-mime gnome2-utils kde4-functions qt4-r2

DESCRIPTION="Bitcoin Classic crypto-currency GUI wallet"
HOMEPAGE="https://bitcoinclassic.com/"
SRC_URI="https://github.com/bitcoinclassic/bitcoinclassic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus +doc +http kde +libevent libressl +qrcode qt4 qt5 system-libsecp256k1 system-univalue test +tor upnp +wallet zeromq"
LANGS="af af_ZA ar be_BY bg bg_BG bs ca ca@valencia ca_ES cs cs_CZ cy da de el el_GR en en_GB eo es es_AR es_CL es_CO es_DO es_ES es_MX es_UY es_VE et eu_ES fa fa_IR fi fr fr_CA fr_FR gl he hi_IN hr hu id_ID it ja ka kk_KZ ko_KR ky la lt lv_LV mk_MK mn ms_MY nb nl pam pl pt_BR pt_PT ro ro_RO ru ru_RU sk sl_SI sq sr sv ta th_TH tr tr_TR uk ur_PK uz@Cyrl uz@Latn vi vi_VN zh zh_CN zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

WALLET_DEPEND="media-gfx/qrencode sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]"

RDEPEND="
	app-shells/bash:0
	dev-libs/boost:0[threads(+)]
	dev-libs/glib:2
	dev-libs/crypto++
	dev-libs/protobuf
	libevent? ( dev-libs/libevent )
	!libressl? ( dev-libs/openssl:0[-bindist] )
	libressl? ( dev-libs/libressl )
	qrcode? ( media-gfx/qrencode )
	qt4? ( dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtgui:5 dev-qt/qtnetwork:5 dev-qt/qtwidgets:5 dev-qt/linguist-tools:5 )
	system-libsecp256k1? ( =dev-libs/libsecp256k1-0.0.0_pre20151118[recovery] )
	system-univalue? ( dev-libs/univalue )
	upnp? ( net-libs/miniupnpc )
	virtual/bitcoin-leveldb
	wallet? ( ${WALLET_DEPEND} )
	zeromq? ( net-libs/zeromq )
	dbus? (
		qt4? ( dev-qt/qtdbus:4 )
		qt5? ( dev-qt/qtdbus:5 )
	)
"

DEPEND="${RDEPEND}"

REQUIRED_USE="^^ ( qt4 qt5 )
	http? ( libevent ) tor? ( libevent ) libevent? ( http tor )
	system-libsecp256k1? ( system-univalue )
"

S="${WORKDIR}/bitcoinclassic-${PV}"

src_prepare() {
	epatch "${FILESDIR}/${PV}-syslibs.patch"

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

	cd "${S}"
	eautoreconf
}

src_configure() {
	local my_econf=

	if use !libevent; then
		my_econf="${my_econf} --without-libevent"
	fi
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
		--without-daemon \
		${my_econf} \
		$(use_with dbus qtdbus) \
		$(use_with qrcode qrencode) \
		$(use_with system-libsecp256k1) \
		$(use_with system-univalue) \
		--with-gui=$(usex qt5 qt5 qt4)
		"$@"
}

src_compile() {
	local OPTS=()

	OPTS+=("CXXFLAGS=${CXXFLAGS} -I$(db_includedir "${DB_VER}")")
	OPTS+=("LDFLAGS=${LDFLAGS} -ldb_cxx-${DB_VER}")

	use upnp && OPTS+=(USE_UPNP=1)

	cd src || die
	emake CXX="$(tc-getCXX)" "${OPTS[@]}"
	mv qt/bitcoin-qt ${PN}
}

src_install() {
	dobin src/${PN}

	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" "${PN}.ico"
	make_desktop_entry "${PN} %u" "Bitcoin Classic" "/usr/share/pixmaps/${PN}.ico" "Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/bitcoin;\nTerminal=false"

	if use kde; then
		insinto /usr/share/kde4/services
		doins contrib/debian/bitcoin-qt.protocol
	fi

	if use doc; then
		dodoc doc/README.md
		dodoc doc/release-notes.md
		dodoc doc/assets-attribution.md doc/bips.md
		doman contrib/debian/manpages/bitcoin-qt.1
		use tor && doc/tor.md
		use zeromq && dodoc -r contrib/zmq
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

update_caches() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	buildsycoca
}

pkg_postinst() {
	update_caches
}

pkg_postrm() {
	update_caches
}
