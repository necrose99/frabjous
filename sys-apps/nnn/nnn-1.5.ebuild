# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The missing terminal file browser for X"
HOMEPAGE="https://github.com/jarun/nnn"
SRC_URI="https://github.com/jarun/nnn/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses:0=
	sys-libs/readline:0="
RDEPEND="${DEPEND}"

DOCS=( README.md )

QA_PRESTRIPPED="usr/bin/nnn"

src_prepare() {
	# sed fix prefix path and leave
	# optimization level to user CFLAGS
	sed -i \
		-e "s:/usr/local:/usr:" \
		-e "s:-O3 -Wall ::" \
		Makefile || die

	default
}
