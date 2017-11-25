# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils xdg

MY_P=${P/-bin}
SRC_URI_BASE="https://github.com/saenzramiro/rambox/releases/download"
DESCRIPTION="Free, Open Source and Cross Platform messaging and emailing app"
HOMEPAGE="http://rambox.pro/"
SRC_URI="amd64? ( ${SRC_URI_BASE}/${PV}/${MY_P^}-x64.tar.gz )
	x86? ( ${SRC_URI_BASE}/${PV}/${MY_P^}-ia32.tar.gz )"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="dev-libs/expat
	dev-libs/libappindicator
	dev-libs/nss
	gnome-base/gconf
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/libpng
	net-print/cups
	net-libs/gnutls
	sys-libs/zlib
	x11-libs/gtk+
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/libXtst"

QA_PRESTRIPPED="/opt/rambox-bin/libffmpeg.so
	/opt/rambox-bin/libnode.so
	/opt/rambox-bin/rambox"

S="${WORKDIR}/${MY_P^}"

src_install() {
	exeinto /opt/${PN}
	doexe rambox
	scanelf -Xe "${ED%/}"/opt/${PN}/rambox || die

	insinto /opt/${PN}
	doins -r locales resources
	doins blink_image_resources_200_percent.pak \
		content_resources_200_percent.pak \
		content_shell.pak \
		ui_resources_200_percent.pak \
		views_resources_200_percent.pak \
		icudtl.dat \
		natives_blob.bin \
		snapshot_blob.bin \
		libnode.so \
		libffmpeg.so

	dosym ../../opt/${PN}/rambox /usr/bin/rambox-bin

	doicon -s 128 "${FILESDIR}"/icon/rambox.png
	make_desktop_entry rambox-bin Rambox "rambox" Network
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
