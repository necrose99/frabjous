# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

DESCRIPTION="The open-source Trello-like kanban"
HOMEPAGE="https://wekan.github.io"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="net-libs/nodejs[npm]"
RDEPEND="${DEPEND}
	>=dev-db/mongodb-3.2"

RESTRICT="mirror"

QA_PRESTRIPPED="usr/libexec/wekan/phantomjs"

S="${WORKDIR}/bundle"

pkg_setup() {
	# Unfortunately 'network-sandbox' needs to
	# disabled because npm fetch a few dependencies.
	if has network-sandbox $FEATURES; then
		die "www-apps/wekan require 'network-sandbox' to be disabled in FEATURES"
	fi

	enewgroup wekan
	enewuser wekan -1 -1 /usr/share/wekan wekan
}

src_prepare() {
	default
	export N_PREFIX="${WORKDIR}/npm"
	local N_VERSION="4.8.4" PATH="${N_PREFIX}"/bin:$PATH
	mkdir "${N_PREFIX}"{,-cache} || die

	ebegin "Installing node ${N_VERSION}"
	pushd "${N_PREFIX}" > /dev/null || die
	npm install --cache "${WORKDIR}"/npm-cache n || die
	./node_modules/n/bin/n -q ${N_VERSION} || die
	popd > /dev/null || die
	eend $?

	ebegin "Using node $(node --version) to install wekan dependencies"
	pushd "programs/server" > /dev/null || die
	npm install --cache "${WORKDIR}"/npm-cache || die
	# Remove useless fibers.node
	rm -rf node_modules/fibers/bin/{darwin,linux-ia32,win-32}* || die
	popd > /dev/null || die
	eend $?
}

src_install() {
	local PHANTOM_DIR="programs/server/npm/node_modules/meteor/rajit_bootstrap3-datepicker/lib/bootstrap-datepicker/node_modules/phantomjs/lib/phantom/bin"

	mkdir -p "${D%/}"/usr/{libexec,share}/wekan || die
	mv ${PHANTOM_DIR}/phantomjs "${D%/}"/usr/libexec/wekan || die
	dosym ../../../../../../../../../../../../../../../libexec/wekan/phantomjs \
		/usr/share/wekan/${PHANTOM_DIR}/phantomjs

	cp -a "${N_PREFIX}" "${D%/}"/usr/libexec/wekan || die
	cp -a . "${D%/}"/usr/share/wekan || die

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	diropts -o wekan -g wekan -m 0750
	dodir /var/log/wekan
}
