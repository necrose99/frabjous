# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

# TODO: Finish the daemon part;
# username/group, init script, unit files, etc.

DESCRIPTION="The secure, private and untraceable cryptocurrency"
HOMEPAGE="https://getmonero.org"
SRC_URI="https://github.com/monero-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+daemon doc dot libressl +simplewallet stacktrace utils"

CDEPEND="app-arch/xz-utils
	dev-libs/boost:0=[threads(+)]
	dev-libs/expat
	net-dns/unbound
	net-libs/ldns
	net-libs/miniupnpc
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	stacktrace? ( sys-libs/libunwind )"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen[dot?] )"
RDEPEND="${CDEPEND}
	daemon? ( !net-p2p/monero-core[daemon] )
	simplewallet? ( !net-p2p/monero-core[simplewallet] )
	utils? ( !net-p2p/monero-core[utils] )"

REQUIRED_USE="dot? ( doc )"
RESTRICT="mirror"

CMAKE_BUILD_TYPE=Release

src_configure() {
	append-ldflags -Wl,-z,noexecstack
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION="$(usex doc)"
		-DSTACK_TRACE="$(usex stacktrace)"
	)
	cmake-utils_src_configure
}

src_compile() {
	use daemon && \
		emake -C "${BUILD_DIR}"/src/daemon

	if use simplewallet; then
		emake -C "${BUILD_DIR}"/src/simplewallet
		emake -C "${BUILD_DIR}"/src/wallet
	fi

	use utils && \
		emake -C "${BUILD_DIR}"/src/blockchain_utilities

	if use doc; then
		pushd ${CMAKE_USE_DIR} >/dev/null || die
		HAVE_DOT=$(usex dot) doxygen Doxyfile
		popd > /dev/null || die
	fi
}

src_install() {
	use daemon && \
		dobin "${BUILD_DIR}"/bin/monerod

	if use simplewallet; then
		dobin "${BUILD_DIR}"/bin/monero-wallet-cli
		dobin "${BUILD_DIR}"/bin/monero-wallet-rpc
	fi

	if use utils; then
		dobin "${BUILD_DIR}"/bin/monero-blockchain-export
		dobin "${BUILD_DIR}"/bin/monero-blockchain-import
	fi

	if use doc; then
		docinto html
		dodoc -r doc/html/*
	fi
}
