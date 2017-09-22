# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

PKG_COMMIT="ec2b0fe"
EGO_PN="github.com/${PN}/${PN}"
DESCRIPTION="Grafana is an open source metric analytics & visualization suite"
HOMEPAGE="https://grafana.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!www-apps/grafana-bin"
DEPEND=">=net-libs/nodejs-6[npm]
	sys-apps/yarn"

RESTRICT="strip mirror"

QA_EXECSTACK="usr/libexec/grafana/phantomjs"

pkg_setup() {
	if has network-sandbox $FEATURES; then
		die "www-apps/grafana require 'network-sandbox' to be disabled in FEATURES"
	fi

	enewgroup grafana
	enewuser grafana -1 -1 /usr/share/grafana grafana
}

src_prepare() {
	pushd src/${EGO_PN} > /dev/null || die
	# Unfortunately 'network-sandbox' needs to disabled
	# because yarn/npm fetch dependencies here:
	emake deps-js

	# Check if we already have grunt installed globally
	if ! command -v grunt &>/dev/null; then
		npm install grunt-cli || die
	fi
	popd > /dev/null || die

	default
}

src_compile() {
	local GOLDFLAGS="-s -w \
	-X main.version=${PV} \
	-X main.commit=${PKG_COMMIT} \
	-X main.buildstamp=$(date -u '+%s')"

	GOPATH="${S}" go install -v -ldflags "${GOLDFLAGS}" \
		${EGO_PN}/pkg/cmd/grafana-{cli,server} || die

	emake -C src/${EGO_PN} build-js
}

src_test() {
	export GOPATH="${S}"
	emake -C src/${EGO_PN} test
}

src_install() {
	dobin bin/grafana-{cli,server}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	pushd src/${EGO_PN} > /dev/null || die
	exeinto /usr/libexec/grafana
	doexe vendor/phantomjs/phantomjs

	insinto /etc/grafana
	newins conf/sample.ini grafana.ini.example

	insinto /usr/share/grafana
	doins -r conf

	insinto /usr/share/grafana/public
	doins -r public_gen/*

	insinto /usr/share/grafana/vendor/phantomjs
	doins vendor/phantomjs/render.js
	dosym ../../../../libexec/grafana/phantomjs \
		/usr/share/grafana/vendor/phantomjs/phantomjs
	popd > /dev/null || die

	diropts -o grafana -g grafana -m 0750
	dodir /var/{lib,log}/grafana
}

pkg_preinst() {
	# Remove redundant file
	rm -r "${D}"/usr/share/${PN}/conf/sample.ini || die
}

pkg_postinst() {
	if [ ! -e "${EROOT}"/etc/${PN}/grafana.ini ]; then
		elog "No grafana.ini found, copying the example over"
		cp "${EROOT}"/etc/${PN}/grafana.ini{.example,} || die
	else
		elog "grafana.ini found, please check example file for possible changes"
	fi
}
