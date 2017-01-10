# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"

inherit cmake-utils systemd user

DESCRIPTION="An optimized HTTP server with support for HTTP/1.x and HTTP/2"
HOMEPAGE="https://github.com/h2o/h2o"
SRC_URI="https://github.com/h2o/h2o/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bundled-ssl libh2o libressl +mruby websocket"

RDEPEND="
	libh2o? (
		>=dev-libs/libuv-1.0.0
		websocket? ( net-libs/wslay )
	)
	!bundled-ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)"
DEPEND="${RDEPEND}
	mruby? (
		sys-devel/bison
		|| ( dev-lang/ruby:2.2 dev-lang/ruby:2.3 )
	)"
REQUIRED_USE="
	websocket? ( libh2o )
	bundled-ssl? ( !libressl )"

pkg_setup() {
	enewgroup h2o
	enewuser h2o -1 -1 /var/www/h2o h2o
}

src_prepare() {
	eapply_user

	# Remove hardcoded flags
	sed -i "s/-O2 -g //g" ./CMakeLists.txt || die "sed fix failed!"
}

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_LIBS="$(usex !libh2o)"
		-DWITH_BUNDLED_SSL="$(usex bundled-ssl)"
		-DWITH_MRUBY="$(usex mruby)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/h2o.initd-r1 h2o
	systemd_dounit "${FILESDIR}"/h2o.service

	insinto /etc/h2o
	doins "${FILESDIR}"/h2o.conf

	keepdir /var/{log,www}/h2o
	fowners h2o:h2o /var/{log,www}/h2o
	fperms 0700 /var/log/h2o

	insinto /etc/logrotate.d
	newins "${FILESDIR}/h2o.logrotate" ${PN}
}
