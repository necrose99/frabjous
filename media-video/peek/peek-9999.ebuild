# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
RESTRICT="mirror"
VALA_MIN_API_VERSION=0.22

inherit cmake-utils git-r3 gnome2-utils vala

DESCRIPTION="An simple animated Gif screen recorder"
HOMEPAGE="https://github.com/phw/peek"
EGIT_REPO_URI=( {https,git}://github.com/phw/peek.git )

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.14:3
	media-video/ffmpeg
	media-gfx/imagemagick"

DEPEND="${RDEPEND}
	$(vala_depend)
	>=sys-devel/gettext-0.19.0"

src_prepare() {
	default
	vala_src_prepare
	sed -i -e "/NAMES/s:valac:${VALAC}:" cmake/FindVala.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=ON
		-DGSETTINGS_COMPILE=OFF
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
