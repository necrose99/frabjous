# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

GIT_COMMIT="adbe7d110f08629f3628dfcb2ffdfa1fc757abd8"
DESCRIPTION="An Encrpyted, Anti-Replay, Multiplexed UDP tunnel"
HOMEPAGE="https://github.com/wangyu-/udp2raw-tunnel"
SRC_URI="https://github.com/wangyu-/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hwaes"

RESTRICT="mirror"

src_prepare() {
	# Leave optimization level to user CXXFLAGS
	# Fix git commit
	sed -i \
		-e 's: -03::' \
		-e 's:${NAME}_$@:${NAME}:' \
		-e 's:FLAGS= -std=c++11.*:FLAGS= ${CXXFLAGS} -std=c++11:' \
		-e 's:$(shell git rev-parse HEAD):'${GIT_COMMIT}':' \
		makefile || die

	default
}

src_compile() {
	if ! use hwaes; then
		emake fast
	else
		append-flags -Wa,--noexecstack
		emake amd64_hw_aes
	fi
}

src_install() {
	dobin udp2raw

	insinto /etc/udp2raw
	doins example.conf
}
