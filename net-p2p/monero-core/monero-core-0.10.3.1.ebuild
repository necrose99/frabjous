# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_BUILD_TYPE=Release
CMAKE_USE_DIR="${S}/monero"
BUILD_DIR="${CMAKE_USE_DIR}/build/release"

inherit cmake-utils gnome2-utils qmake-utils

# TODO: Finish the daemon part;
# username/group, init script, unit files, etc.

MO=monero
MO_CORE_COMMIT="4ca35af"
MO_PV="c9063c0b8f78a1fca4c2306d5b1df5f664c030c2"
MO_URI="https://github.com/${MO}-project/${MO}/archive/${MO_PV}.tar.gz"
MO_P="${MO}-${MO_PV}"

DESCRIPTION="Monero: the secure, private and untraceable cryptocurrency"
HOMEPAGE="https://getmonero.org"
SRC_URI="https://github.com/${MO}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${MO_URI} -> ${MO_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+daemon doc dot +gui libressl scanner simplewallet stacktrace utils"

CDEPEND="app-arch/xz-utils
	dev-libs/boost:0[threads(+)]
	dev-libs/expat
	net-dns/unbound
	net-libs/ldns
	net-libs/miniupnpc
	gui? (
		dev-qt/qtwidgets:5
		dev-qt/qtquickcontrols:5
		dev-qt/qtquickcontrols2:5
		scanner? (
			dev-qt/qtmultimedia:5[qml]
			media-gfx/zbar
		)
	)
	!libressl? ( dev-libs/openssl:0[-bindist] )
	libressl? ( dev-libs/libressl )
	stacktrace? ( sys-libs/libunwind )"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen[dot=] )
	gui? ( dev-qt/linguist-tools )"
RDEPEND="${CDEPEND}"

REQUIRED_USE="dot? ( doc )
	scanner? ( gui )"

RESTRICT="mirror"

QA_EXECSTACK="usr/bin/monerod
	usr/bin/monero-blockchain-import
	usr/bin/monero-blockchain-export"

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
	# Reduce some harmless noises
	append-cxxflags -Wno-unused-but-set-variable

	if use gui; then
		echo "var GUI_VERSION = \"${MO_CORE_COMMIT}\"" > version.js || die
		echo "var GUI_MONERO_VERSION = \"${MO_PV:0:-33}\"" >> version.js || die

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
	)
	cmake-utils_src_configure
}

src_compile() {
	pushd "${BUILD_DIR}"/src/wallet >/dev/null || die
	emake version -C ../..
	emake && emake install
	popd > /dev/null || die

	emake -C "${BUILD_DIR}"/contrib/epee all install

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
		dobin build/release/bin/${MO}-wallet-gui

		# Install icons and desktop entry
		local SZ
		for SZ in 16 24 32 48 64 96 128 256 ; do
			newicon -s ${SZ} "images/appicons/${SZ}x${SZ}.png" ${MO}.png
		done
		make_desktop_entry "${MO}-wallet-gui %u" \
			"Monero Wallet" ${MO} \
			"Qt;Network;P2P;Office;Finance;" \
			"MimeType=x-scheme-handler/monero;\nTerminal=false"

		insinto /usr/share/${PN}/translations
		for lang in build/release/bin/translations/*.qm ; do
			doins "${lang}"
		done
	fi

	if use daemon; then
		dobin "${BUILD_DIR}"/bin/${MO}d
	fi

	use simplewallet && \
		dobin "${BUILD_DIR}"/bin/${MO}-wallet-cli

	if use utils; then
		dobin "${BUILD_DIR}"/bin/${MO}-blockchain-export
		dobin "${BUILD_DIR}"/bin/${MO}-blockchain-import
		dobin "${BUILD_DIR}"/bin/${MO}-utils-deserialize
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
}

pkg_postrm() {
	use gui && update_caches
}
