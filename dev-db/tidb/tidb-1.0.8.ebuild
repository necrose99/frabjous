# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

GIT_COMMIT="3a6cddd"
EGO_PN="github.com/pingcap/tidb"
DESCRIPTION="A distributed NewSQL database compatible with MySQL protocol"
HOMEPAGE="https://pingcap.com/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror strip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( {README,docs/{QUICKSTART,ROADMAP}}.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_prepare() {
	# The tarball isn't a proper git repository,
	# so let's silence the "fatal" message.
	sed -i \
		-e 's:$(shell git describe --tags --dirty)::g' \
		-e 's:$(shell git rev-parse HEAD)::g' \
		-e 's:$(shell git rev-parse --abbrev-ref HEAD)::g' \
		Makefile || die

	default
}

src_compile() {
	export GOPATH="${G}:${S}/_vendor"
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/mysql.TiDBReleaseVersion=${PV} \
		-X '${EGO_PN}/util/printer.TiDBBuildTS=$(date -u '+%Y-%m-%d %I:%M:%S')' \
		-X ${EGO_PN}/util/printer.TiDBGitHash=${GIT_COMMIT} \
		-X ${EGO_PN}/util/printer.TiDBGitBranch=non-git"

	emake parser

	go install -v -ldflags "${GOLDFLAGS}" \
		./tidb-server || die
}

src_test() {
	go test -v -p 3 -cover ./... || die
}

src_install() {
	dobin "${G}"/bin/tidb-server
	einstalldocs
}

pkg_postinst() {
	einfo
	elog "See https://pingcap.com/docs for configuration guide."
	einfo
}
