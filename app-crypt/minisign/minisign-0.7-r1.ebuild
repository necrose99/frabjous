# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A dead simple tool to sign files and verify digital signatures"
HOMEPAGE="https://jedisct1.github.io/minisign/"
SRC_URI="https://github.com/jedisct1/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RESTRICT="mirror"

DEPEND="|| (
	>=dev-libs/libsodium-1.0.13[-minimal]
	<=dev-libs/libsodium-1.0.12
	)"
