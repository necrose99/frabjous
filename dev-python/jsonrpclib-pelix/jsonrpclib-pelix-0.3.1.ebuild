# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="python (2 & 3) implementation of the JSON-RPC spec (1.0 and 2.0)"
HOMEPAGE="https://github.com/tcalmant/jsonrpclib"
SRC_URI="https://github.com/tcalmant/jsonrpclib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"

RDEPEND="dev-python/simplejson
	!dev-python/jsonrpclib"

S="${WORKDIR}/${PN/-pelix}-${PV}"
