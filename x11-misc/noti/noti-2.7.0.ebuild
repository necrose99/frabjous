# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

LINT_EGO_PN="github.com/golang/lint"
GOTOOLS_EGO_PN="honnef.co/go/tools"

EGO_PN="github.com/variadico/noti"
DESCRIPTION="Trigger notifications when a process completes"
HOMEPAGE="https://github.com/variadico/noti"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="mirror strip"

DOCS=( docs/{noti,release}.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

RDEPEND="
	|| (
		x11-libs/libnotify
		app-accessibility/espeak
	)"

src_compile() {
	export GOPATH="${G}"
	go build -v -ldflags "-s -w" \
		-o "${S}"/noti ./cmd/noti || die

	if use test; then
		go install -v -ldflags "-s -w" \
			./vendor/${LINT_EGO_PN}/golint || die

		go install -v -ldflags "-s -w" \
			./vendor/${GOTOOLS_EGO_PN}/cmd/megacheck || die
	fi
}

src_test() {
	local PATH="${G}/bin:$PATH"
	emake test
}

src_install() {
	dobin noti
	einstalldocs
}
