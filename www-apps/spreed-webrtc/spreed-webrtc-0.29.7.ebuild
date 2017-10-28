# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools user

DESCRIPTION="A WebRTC audio/video call and conferencing server and web client"
HOMEPAGE="https://www.spreed.me"
SRC_URI="https://github.com/strukturag/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="net-libs/nodejs[npm]"
DEPEND="${RDEPEND}
	dev-lang/go"
RESTRICT="mirror"

pkg_setup() {
	has network-sandbox $FEATURES && \
		die "www-apps/spreed-webrtc requires 'network-sandbox' to be disabled in FEATURES"

	enewgroup spreed
	enewuser spreed -1 -1 -1 spreed
}

src_prepare() {
	# Fix log path
	sed -i "s:/var/log.*:/var/log/${PN}/server.log:" \
		server.conf.in || die

	eautoreconf
	# Unfortunately 'network-sandbox' needs to disabled
	# because net-libs/nodejs fetch dependencies here:
	npm install || die

	default
}

src_compile() {
	LDFLAGS="" emake
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	insinto /etc/spreed-webrtc
	newins server.conf.in spreed-webrtc.conf.example

	diropts -o spreed -g spreed -m 0750
	dodir /var/log/spreed-webrtc
}
