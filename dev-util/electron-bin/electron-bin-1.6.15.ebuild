# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SRC_URI_BASE="https://github.com/electron/electron/releases/download"
DESCRIPTION="Build cross platform desktop apps with JavaScript, HTML, and CSS"
HOMEPAGE="https://electron.atom.io"
SRC_URI="amd64? ( ${SRC_URI_BASE}/v${PV}/${PN/-bin}-v${PV}-linux-x64.zip -> ${P}-x64.zip )
	x86? ( ${SRC_URI_BASE}/${PV}/v${PN/-bin}-v${PV}-linux-ia32.zip -> ${P}-ia32.zip )"
RESTRICT="mirror"

https://github.com/electron/electron/releases/download/v1.6.15/electron-v1.6.15-linux-x64.zip

LICENSE="MIT"
SLOT="1.6"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="dev-libs/nss
	dev-libs/expat
	dev-libs/libappindicator
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/libpng
	net-print/cups
	sys-libs/zlib
	virtual/opengl
	virtual/ttf-fonts
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/libXtst
	x11-libs/pango"
DEPEND="app-arch/unzip"

S="${WORKDIR}"
MY_PN=${PN}-${SLOT}

QA_PRESTRIPPED="/opt/${MY_PN}/libffmpeg.so
	/opt/${MY_PN}/libnode.so
	/opt/${MY_PN}/electron"

src_install() {
	exeinto /opt/${MY_PN}
	doexe electron
	scanelf -Xe "${ED%/}"/opt/${MY_PN}/electron || die

	insinto /opt/${MY_PN}
	doins -r locales resources
	doins *.pak \
		icudtl.dat \
		natives_blob.bin \
		snapshot_blob.bin \
		libnode.so \
		libffmpeg.so

	dosym ../../opt/${MY_PN}/electron /usr/bin/electron-${SLOT}
}
