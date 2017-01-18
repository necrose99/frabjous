# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"

inherit user

DESCRIPTION="The ultimate open source web chat platform"
HOMEPAGE="https://rocket.chat"
SRC_URI="https://rocket.chat/releases/${PV}/download -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-db/mongodb
	>=net-libs/nodejs-4.6.2[npm]
	media-gfx/imagemagick[jpeg,png]"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup rocket
	enewuser rocket -1 -1 "/usr/share/${PN}" rocket
}

src_unpack() {
	default
	mv "${WORKDIR}/bundle" "${WORKDIR}/${P}"
}

src_prepare() {
	default
	pushd "programs/server"
	npm install || die "Error in npm install"
	popd
}

src_install() {
	local my_home="/usr/share/${PN}"
	local my_log="/var/log/${PN}"

	mkdir -p "${D}${my_home}"
	cp -a . "${D}${my_home}"

	keepdir "${my_log}"
	fowners rocket:rocket "${my_log}"

	# This is to enable webhook integration with script support
	keepdir "${my_home}"/.babel-cache
	fowners rocket:rocket "${my_home}"/.babel-cache

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
