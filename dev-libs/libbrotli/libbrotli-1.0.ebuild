# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 autotools

DESCRIPTION="Builds libraries out of the brotli decode and encode sources"
HOMEPAGE="https://github.com/bagder/libbrotli"
EGIT_REPO_URI=( {https,git}://github.com/bagder/libbrotli.git )
EGIT_COMMIT="e992cce7a174d6e2b3486616499d26bb0bad6448"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS=( README.md )

src_prepare() {
	default
	eautoreconf
}
