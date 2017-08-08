# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot versionator

COMMIT="db8ff90"
EGO_PN="github.com/pingcap/tidb"
TDB="${EGO_PN}/util/printer"
EGO_LDFLAGS="-s -w -X '${TDB}.TiDBBuildTS=$(date -u '+%Y-%m-%d %I:%M:%S')' \
	-X ${TDB}.TiDBGitHash=${COMMIT}"

MY_PV=$(get_version_component_range 3)
DESCRIPTION="A distributed NewSQL database compatible with MySQL protocol"
HOMEPAGE="https://github.com/pingcap/tidb"
SRC_URI="https://${EGO_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_prepare() {
	ln -s _vendor/src src/${EGO_PN}/vendor || die

	sed -i \
		-e 's:LDFLAGS:GOLDFLAGS:' \
		-e 's:$(shell git rev-parse HEAD)::g' \
			src/${EGO_PN}/Makefile || die

	default
}

src_compile() {
	emake -C src/${EGO_PN} parser

	GOPATH="${S}" go install -v -ldflags \
		"${EGO_LDFLAGS}" ${EGO_PN}/tidb-server || die
}

src_install() {
	dobin bin/tidb-server
}

pkg_postinst() {
	einfo "See https://pingcap.com/docs for configuration guide."
}
