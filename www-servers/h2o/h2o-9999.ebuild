# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"

inherit cmake-utils git-r3 ruby-single systemd user

DESCRIPTION="An optimized HTTP server with support for HTTP/1.x and HTTP/2"
HOMEPAGE="https://h2o.examp1e.net"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="bundled-ssl libh2o libressl libuv +mruby websocket"

RDEPEND="
	libh2o? (
		libuv? ( >=dev-libs/libuv-1.0.0 )
		websocket? ( net-libs/wslay )
	)
	!bundled-ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}
	mruby? (
		sys-devel/bison
		${RUBY_DEPS}
	)"
REQUIRED_USE="bundled-ssl? ( !libressl )
	libuv? ( libh2o )
	websocket? ( libh2o )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.2-fix_doc.patch
	"${FILESDIR}"/${P}-libexec.patch
)

pkg_setup() {
	enewgroup h2o
	enewuser h2o -1 -1 -1 h2o
}

src_prepare() {
	# Leave optimization level to user CFLAGS
	sed -i 's/-O2 -g ${CC_WARNING_FLAGS} //g' ./CMakeLists.txt \
		|| die "sed fix failed!"

	default
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc/h2o
		-DDISABLE_LIBUV="$(usex !libuv)"
		-DWITHOUT_LIBS="$(usex !libh2o)"
		-DWITH_BUNDLED_SSL="$(usex bundled-ssl)"
		-DWITH_MRUBY="$(usex mruby)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/h2o.initd-r2 h2o
	systemd_dounit "${FILESDIR}"/h2o.service

	insinto /etc/h2o
	doins "${FILESDIR}"/h2o.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/h2o.logrotate-r2 h2o

	diropts -o h2o -g h2o -m 0700
	dodir /var/log/h2o
}
