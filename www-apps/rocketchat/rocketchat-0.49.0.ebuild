# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"

inherit user

DESCRIPTION="The ultimate open source web chat platform"
HOMEPAGE="https://rocket.chat/"
SRC_URI="https://rocket.chat/releases/${PV}/download -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-db/mongodb
	>=net-libs/nodejs-4.6.2[npm]
	media-gfx/imagemagick[jpeg,png]"
DEPEND="${RDEPEND}"

pkg_setup() {
	local UG='rocket'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 "/usr/share/${PN}" "${UG}"
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
	local my_dest="/usr/share/${PN}"
	local my_log="/var/log/${PN}"

	mkdir -p "${D}${my_dest}"
	cp -a . "${D}${my_dest}"

	keepdir "${my_log}"
	fowners "${UG}":"${UG}" "${my_log}"

	# This is to enable webhook integration with script support
	keepdir "${my_dest}/.babel-cache"
	fowners "${UG}":"${UG}" "${my_dest}/.babel-cache"

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
