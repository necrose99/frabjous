# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="The open-source Trello-like kanban"
HOMEPAGE="https://wekan.github.io"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-db/mongodb-3.2
	<dev-db/mongodb-3.4
	<net-libs/nodejs-6.0[npm]"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

QA_PRESTRIPPED="/usr/share/wekan/programs/server/npm/node_modules/meteor/rajit_bootstrap3-datepicker/lib/bootstrap-datepicker/node_modules/phantomjs/lib/phantom/bin/phantomjs"
QA_TEXTRELS="
	usr/share/wekan/programs/server/node_modules/fibers/bin/linux-ia32-48/fibers.node
	usr/share/wekan/programs/server/node_modules/fibers/bin/linux-ia32-46/fibers.node"

pkg_setup() {
	if has network-sandbox $FEATURES; then
		die "www-apps/wekan require 'network-sandbox' to be disabled in FEATURES"
	fi

	enewgroup wekan
	enewuser wekan -1 -1 /usr/share/wekan wekan
}

src_unpack() {
	default
	mv "${WORKDIR}/bundle" "${S}" || die
}

src_prepare() {
	default

	pushd "programs/server" > /dev/null || die
	# Unfortunately 'network-sandbox' needs to disabled
	# because npm fetch a few dependencies here:
	npm install || die "Error in npm install"
	popd > /dev/null || die
}

src_install() {
	mkdir -p "${D}"/usr/share/wekan
	cp -a . "${D}"/usr/share/wekan

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	diropts -o wekan -g wekan -m 0750
	keepdir /var/log/wekan
}
