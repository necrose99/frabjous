# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils xdg

MY_P=${P/-bin}
SRC_URI_BASE="https://github.com/saenzramiro/rambox/releases/download"
DESCRIPTION="Free, Open Source and Cross Platform messaging and emailing app"
HOMEPAGE="http://rambox.pro/"
SRC_URI="amd64? ( ${SRC_URI_BASE}/${PV}/${MY_P^}-x64.tar.gz -> ${P}-x64.tar.gz )
	x86? ( ${SRC_URI_BASE}/${PV}/${MY_P^}-ia32.tar.gz -> ${P}-ia32.tar.gz )"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="dev-libs/libpcre:3
	dev-libs/libtasn1:0
	dev-libs/nettle:0
	dev-libs/nspr:0
	dev-libs/nss:0
	gnome-base/gconf:2
	media-libs/alsa-lib:0
	media-libs/libpng:0
	net-libs/gnutls:0
	x11-libs/gtk+:2
	x11-libs/libXScrnSaver:0"

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
