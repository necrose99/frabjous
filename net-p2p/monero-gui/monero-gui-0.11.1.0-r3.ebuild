# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils qmake-utils systemd user

MO_GUI_COMMIT="6f14fde"
MO_PV="c328163ffa28fee3236ddc7a958a50cede727ba6" # branch: release-v0.11.0.0
MO_URI="https://github.com/monero-project/monero/archive/${MO_PV}.tar.gz"
MO_P="monero-${MO_PV}"

DESCRIPTION="The secure, private and untraceable cryptocurrency (with GUI wallet)"
HOMEPAGE="https://getmonero.org"
SRC_URI="https://github.com/monero-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${MO_URI} -> ${MO_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+daemon doc dot +gui libressl readline scanner simplewallet stacktrace utils"

CDEPEND="app-arch/xz-utils
	dev-libs/boost:0=[threads(+)]
	dev-libs/expat
	net-dns/unbound[threads]
	net-libs/ldns
	net-libs/miniupnpc
	gui? (
		dev-qt/qtwidgets:5
		dev-qt/qtdeclarative:5[xml]
		dev-qt/qtquickcontrols:5
		dev-qt/qtquickcontrols2:5
		scanner? (
			dev-qt/qtmultimedia:5[qml]
			media-gfx/zbar
		)
	)
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	readline? ( sys-libs/readline:0= )
	stacktrace? ( sys-libs/libunwind )"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen[dot?] )
	gui? ( dev-qt/linguist-tools )"
RDEPEND="${CDEPEND}
	daemon? ( !net-p2p/monero[daemon] )
	simplewallet? ( !net-p2p/monero[simplewallet] )
	utils? ( !net-p2p/monero[utils] )"

REQUIRED_USE="dot? ( doc ) scanner? ( gui )"
RESTRICT="mirror"

CMAKE_BUILD_TYPE=Release
CMAKE_USE_DIR="${S}/monero"
BUILD_DIR="${CMAKE_USE_DIR}/build/release"

pkg_setup() {
	if use daemon; then
		enewgroup monero
		enewuser monero -1 -1 /var/lib/monero monero
	fi
}

src_prepare() {
	rmdir "${CMAKE_USE_DIR}" || die
	mv "${WORKDIR}/${MO_P}" "${CMAKE_USE_DIR}" || die

	mkdir -p "${S}/build" "${BUILD_DIR}" || die

	# Fix hardcoded translations path
	sed -i 's:"/translations":"/../share/'${PN}'/translations":' \
		TranslationManager.cpp || die "sed fix failed"

	cmake-utils_src_prepare
}

src_configure() {
	if use gui; then
		echo "var GUI_VERSION = \"${MO_GUI_COMMIT}\"" > version.js || die
		echo "var GUI_MONERO_VERSION = \"${MO_PV:0:7}\"" >> version.js || die

		pushd "${S}"/build >/dev/null || die
		eqmake5 ../monero-wallet-gui.pro \
			"CONFIG+=release \
			$(usex !scanner '' WITH_SCANNER) \
			$(usex stacktrace '' libunwind_off)"
		popd > /dev/null || die
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${CMAKE_USE_DIR}"
		-DBUILD_DOCUMENTATION="$(usex doc)"
		-DBUILD_GUI_DEPS=ON
		-DSTACK_TRACE="$(usex stacktrace)"
		-DUSE_READLINE="$(usex readline)"
	)
	cmake-utils_src_configure
}

src_compile() {
	pushd "${BUILD_DIR}"/src/wallet >/dev/null || die
	emake version -C ../..
	emake && emake install
	popd > /dev/null || die

	emake -C "${BUILD_DIR}"/contrib/epee all install
	emake -C "${BUILD_DIR}"/external/easylogging++ all install

	use daemon && \
		emake -C "${BUILD_DIR}"/src/daemon

	use simplewallet && \
		emake -C "${BUILD_DIR}"/src/simplewallet

	use utils && \
		emake -C "${BUILD_DIR}"/src/blockchain_utilities

	use gui && \
		emake -C src/zxcvbn-c && emake -C build

	if use doc; then
		pushd ${CMAKE_USE_DIR} >/dev/null || die
		HAVE_DOT=$(usex dot) doxygen Doxyfile
		popd > /dev/null || die
	fi
}

src_install() {
	if use gui; then
		dobin build/release/bin/monero-wallet-gui

		# Install icons and desktop entry
		local X
		for X in 16 24 32 48 64 96 128 256; do
			newicon -s ${X} "images/appicons/${X}x${X}.png" monero.png
		done
		make_desktop_entry "monero-wallet-gui %u" \
			"Monero Wallet" monero \
			"Qt;Network;P2P;Office;Finance;" \
			"MimeType=x-scheme-handler/monero;\nTerminal=false"

		insinto /usr/share/${PN}/translations
		for lang in build/release/bin/translations/*.qm; do
			doins "${lang}"
		done
	fi

	if use daemon; then
		dobin "${BUILD_DIR}"/bin/monerod
		scanelf -Xe "${ED%/}"/usr/bin/monerod || die

		newinitd "${FILESDIR}"/${PN}.initd monero
		systemd_newunit "${FILESDIR}"/${PN}.service monero.service

		insinto /etc/monero
		newins monero/utils/conf/monerod.conf \
			monerod.conf.example

		diropts -o monero -g monero -m 0750
		dodir /var/log/monero
	fi

	use simplewallet && \
		dobin "${BUILD_DIR}"/bin/monero-wallet-cli

	if use utils; then
		dobin "${BUILD_DIR}"/bin/monero-blockchain-export
		dobin "${BUILD_DIR}"/bin/monero-blockchain-import
		scanelf -Xe "${ED%/}"/usr/bin/monero-blockchain-export || die
		scanelf -Xe "${ED%/}"/usr/bin/monero-blockchain-import || die
	fi

	if use doc; then
		docinto html
		dodoc -r ${CMAKE_USE_DIR}/doc/html/*
	fi
}

pkg_preinst() {
	use gui && gnome2_icon_savelist
}

update_caches() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	use gui && update_caches
	if use daemon; then
		if [ ! -e "${EROOT%/}"/etc/monero/monerod.conf ]; then
			elog "No monerod.conf found, copying the example over"
			cp "${EROOT%/}"/etc/monero/monerod.conf{.example,} || die
		fi
	fi
}

pkg_postrm() {
	use gui && update_caches
}
