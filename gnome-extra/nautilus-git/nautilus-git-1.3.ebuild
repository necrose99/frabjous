# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 meson

DESCRIPTION="Nautilus extension to add important information about the current git directory"
HOMEPAGE="https://github.com/bil-elmoussaoui/nautilus-git"
SRC_URI="https://github.com/bil-elmoussaoui/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-vcs/git
	dev-python/nautilus-python"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		-Dfile_manager=nautilus
	)
	meson_src_configure
}
