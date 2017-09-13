# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

GIT_COMMIT="e520501"
EGO_PN="github.com/prometheus/promu"
DESCRIPTION="The utility tool for Prometheus projects"
HOMEPAGE="https://github.com/prometheus/promu"
SRC_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

src_compile() {
	local GOLDFLAGS="-s -w -extldflags '-static' \
		-X ${EGO_PN}/vendor/${EGO_PN/\/promu}/common/version.Version=${PV/_*} \
		-X ${EGO_PN}/vendor/${EGO_PN/\/promu}/common/version.Revision=${GIT_COMMIT}"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin bin/promu

	pushd src/${EGO_PN} > /dev/null || die
	dodoc {README,CONTRIBUTING}.md
	newdoc doc/examples/.promu.yml promu.example.yml
	popd > /dev/null || die
}
