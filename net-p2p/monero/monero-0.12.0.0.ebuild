# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils systemd user

DESCRIPTION="The secure, private and untraceable cryptocurrency"
HOMEPAGE="https://getmonero.org"
SRC_URI="https://github.com/monero-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+daemon doc dot libressl readline +simplewallet stacktrace utils"

CDEPEND="app-arch/xz-utils
	dev-libs/boost:0=[threads(+)]
	dev-libs/expat
	dev-libs/libsodium
	net-dns/unbound[threads]
	net-libs/cppzmq
	net-libs/ldns
	net-libs/miniupnpc
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	readline? ( sys-libs/readline:0= )
	stacktrace? ( sys-libs/libunwind )"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen[dot?] )"
RDEPEND="${CDEPEND}
	daemon? ( !net-p2p/monero-gui[daemon] )
	simplewallet? ( !net-p2p/monero-gui[simplewallet] )
	utils? ( !net-p2p/monero-gui[utils] )"

REQUIRED_USE="dot? ( doc )"
RESTRICT="mirror"

CMAKE_BUILD_TYPE=Release

pkg_setup() {
	if use daemon; then
		enewgroup monero
		enewuser monero -1 -1 /var/lib/monero monero
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION="$(usex doc)"
		-DSTACK_TRACE="$(usex stacktrace)"
		-DUSE_READLINE="$(usex readline)"
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
	if use daemon; then
		dobin "${BUILD_DIR}"/bin/monerod
		scanelf -Xe "${ED%/}"/usr/bin/monerod || die

		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service

		insinto /etc/monero
		newins utils/conf/monerod.conf monerod.conf.example

		diropts -o monero -g monero -m 0750
		dodir /var/log/monero
	fi

	if use simplewallet; then
		dobin "${BUILD_DIR}"/bin/monero-wallet-cli
		dobin "${BUILD_DIR}"/bin/monero-wallet-rpc
	fi

	if use utils; then
		dobin "${BUILD_DIR}"/bin/monero-blockchain-export
		dobin "${BUILD_DIR}"/bin/monero-blockchain-import
		scanelf -Xe "${ED%/}"/usr/bin/monero-blockchain-export || die
		scanelf -Xe "${ED%/}"/usr/bin/monero-blockchain-import || die
	fi

	if use doc; then
		docinto html
		dodoc -r doc/html/*
	fi
}

pkg_postinst() {
	if use daemon; then
		if [ ! -e "${EROOT%/}"/etc/monero/monerod.conf ]; then
			elog "No monerod.conf found, copying the example over"
			cp "${EROOT%/}"/etc/monero/monerod.conf{.example,} || die
		fi
	fi
}
