# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils flag-o-matic python-single-r1 systemd user

DESCRIPTION="A validating, recursive and caching DNS resolver"
HOMEPAGE="https://unbound.net"
SRC_URI="https://unbound.net/downloads/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug dnscrypt dnstap +ecdsa gost libressl python selinux static-libs test threads"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND=">=dev-libs/expat-2.1.0-r3
	>=dev-libs/libevent-2.0.21:0=
	libressl? ( >=dev-libs/libressl-2.2.4:0 )
	!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0 )
	dnscrypt? ( dev-libs/libsodium )
	dnstap? (
		dev-libs/fstrm
		>=dev-libs/protobuf-c-1.0.2-r1
	)
	ecdsa? (
		!libressl? ( dev-libs/openssl:0[-bindist] )
	)
	python? ( ${PYTHON_DEPS} )"
DEPEND="${CDEPEND}
	python? ( dev-lang/swig )
	test? (
		net-dns/ldns-utils[examples]
		dev-util/splint
		app-text/wdiff
	)"
RDEPEND="${CDEPEND}
	net-dns/dnssec-root
	selinux? ( sec-policy/selinux-bind )"

# To avoid below error messages, set 'trust-anchor-file' to same value in
# 'auto-trust-anchor-file'.
# [23109:0] error: Could not open autotrust file for writing,
# /etc/dnssec/root-anchors.txt: Permission denied
PATCHES=( "${FILESDIR}"/${PN}-1.5.7-trust-anchor-file.patch )

pkg_setup() {
	enewgroup unbound
	enewuser unbound -1 -1 /etc/unbound unbound

	use python && python-single-r1_pkg_setup
}

src_configure() {
	append-ldflags -Wl,-z,noexecstack
	econf \
		$(use_enable debug) \
		$(use_enable gost) \
		$(use_enable dnscrypt) \
		$(use_enable dnstap) \
		$(use_enable ecdsa) \
		$(use_enable static-libs static) \
		$(use_with python pythonmodule) \
		$(use_with python pyunbound) \
		$(use_with threads pthreads) \
		--disable-flto \
		--disable-rpath \
		--with-libevent="${EPREFIX}"/usr \
		--with-pidfile="${EPREFIX}"/var/run/unbound.pid \
		--with-rootkey-file="${EPREFIX}"/etc/dnssec/root-anchors.txt \
		--with-ssl="${EPREFIX}"/usr \
		--with-libexpat="${EPREFIX}"/usr

		# http://unbound.nlnetlabs.nl/pipermail/unbound-users/2011-April/001801.html
		# $(use_enable debug lock-checks) \
		# $(use_enable debug alloc-checks) \
		# $(use_enable debug alloc-lite) \
		# $(use_enable debug alloc-nonregional) \
}

src_install() {
	default
	prune_libtool_files --modules
	use python && python_optimize

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newunit "${FILESDIR}"/${PN}_at.service "unbound@.service"
	systemd_dounit "${FILESDIR}"/${PN}-anchor.service

	dodoc doc/{README,CREDITS,TODO,Changelog,FEATURES}
	dodoc contrib/unbound_munin_

	if use selinux; then
		docinto selinux
		dodoc contrib/selinux/*
	fi

	exeinto /usr/share/unbound
	doexe contrib/update-anchor.sh
}
