# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"

inherit user

DESCRIPTION="The open-source Trello-like kanban"
HOMEPAGE="https://wekan.io/"
My_PV="${PV/\_rc2/}-rc2"
SRC_URI="https://github.com/wekan/wekan/releases/download/v${My_PV}/${PN}-${My_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-db/mongodb
	>=net-libs/nodejs-6.9.1[npm]"
DEPEND="${RDEPEND}"

WEKAN_DEST="/usr/share/${PN}"
WEKAN_LOG="/var/log/${PN}"
WEKAN_USER="wekan"
WEKAN_GROUP="wekan"

pkg_setup() {
	enewgroup ${WEKAN_GROUP}
	enewuser ${WEKAN_USER} -1 -1 "${WEKAN_DEST}" ${WEKAN_GROUP}
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
	mkdir -p "${D}${WEKAN_DEST}"
	cp -a . "${D}${WEKAN_DEST}"

	keepdir "${WEKAN_LOG}"
	fowners "${WEKAN_USER}":"${WEKAN_GROUP}" "${WEKAN_LOG}"

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
