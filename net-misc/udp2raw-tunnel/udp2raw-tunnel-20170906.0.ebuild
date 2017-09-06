# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An Encrpyted, Anti-Replay, Multiplexed UDP tunnel"
HOMEPAGE="https://github.com/wangyu-/udp2raw-tunnel"
SRC_URI="https://github.com/wangyu-/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror"

src_compile() {
	emake fast
}

src_install() {
	dobin udp2raw

	insinto /etc/udp2raw
	doins example.conf
}
