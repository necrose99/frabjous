# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Builds libraries out of the brotli decode and encode sources"
HOMEPAGE="https://github.com/bagder/libbrotli"
EGIT_REPO_URI="https://github.com/bagder/libbrotli.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DOCS=( README.md )

src_prepare() {
	default
	eautoreconf
}
