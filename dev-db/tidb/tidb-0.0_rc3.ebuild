# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot versionator

EGIT_COMMIT="db8ff90"
EGO_PN="github.com/pingcap/tidb"
TiDB="${EGO_PN}/util/printer"

MY_PV=$(get_version_component_range 3)
DESCRIPTION="A distributed NewSQL database compatible with MySQL protocol"
HOMEPAGE="https://github.com/pingcap/tidb"
SRC_URI="https://${EGO_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	ln -s _vendor/src src/${EGO_PN}/vendor || die

	sed -i "s/\$(shell git rev-parse HEAD)//g" \
			src/${EGO_PN}/Makefile || die

	default
}

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	cd src/${EGO_PN} || die

	emake parser || die

	go build -v -ldflags "-X '${TiDB}.TiDBBuildTS=$(date -u '+%Y-%m-%d %I:%M:%S')' -X ${TiDB}.TiDBGitHash=${EGIT_COMMIT}" \
		-o bin/tidb-server tidb-server/main.go || die
}

src_install() {
	dobin src/${EGO_PN}/bin/tidb-server
	dodoc src/${EGO_PN}/README.md
}
