# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
PYTHON_REQ_USE="ncurses?"

inherit distutils-r1 gnome2-utils

DESCRIPTION="Lightweight Bitcoin Cash client"
HOMEPAGE="https://electroncash.org"
SRC_URI="https://github.com/fyookball/electrum/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audio_modem cli cosign digitalbitbox email ncurses +qt5 sync vkb"

RDEPEND="
	dev-python/ecdsa[${PYTHON_USEDEP}]
	>=dev-python/jsonrpclib-0.3.1[${PYTHON_USEDEP}]
	dev-python/pbkdf2[${PYTHON_USEDEP}]
	|| (
		dev-python/pycryptodomex[${PYTHON_USEDEP}]
		dev-python/pyaes[${PYTHON_USEDEP}]
	)
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	virtual/python-dnspython[${PYTHON_USEDEP}]
	audio_modem? ( dev-python/amodem[${PYTHON_USEDEP}] )
	qt5? ( dev-python/PyQt5[widgets,${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

REQUIRED_USE="
	|| ( cli ncurses qt5 )
	audio_modem? ( qt5 )
	cosign? ( qt5 )
	digitalbitbox? ( qt5 )
	email? ( qt5 )
	sync? ( qt5 )
	vkb? ( qt5 )"

DOCS=( AUTHORS README.rst RELEASE-NOTES )

S="${WORKDIR}/${PN/on-cash/um}-${PV}"

src_prepare() {
	eapply "${FILESDIR}"/${PN}-2.9.4-no_user_root.patch

	# Remove unrequested GUI implementations:
	local gui setup_py_gui
	for gui in \
		$(usex cli '' stdio) \
		kivy \
		$(usex qt5 '' qt) \
		$(usex ncurses '' text)  \
	; do
		rm -r gui/"${gui}"* || die
	done

	# And install requested ones...
	for gui in \
		$(usex qt5 qt '')  \
	; do
		setup_py_gui="${setup_py_gui}'electroncash_gui.${gui}',"
	done
	sed -i "s/'electroncash_gui\\.qt',/${setup_py_gui}/" setup.py || die

	local bestgui
	if use qt5; then
		bestgui=qt
	elif use ncurses; then
		bestgui=text
	else
		bestgui=stdio
	fi
	sed -i 's/^\([[:space:]]*\)\(config_options\['\''cwd'\''\] = .*\)$/\1\2\n\1config_options.setdefault("gui", "'"${bestgui}"'")\n/' "$PN" || die

	local plugin
	# trezor requires python trezorlib module
	# keepkey requires trezor
	for plugin in  \
		$(usex audio_modem '' audio_modem ) \
		$(usex cosign '' cosigner_pool ) \
		$(usex digitalbitbox '' digitalbitbox ) \
		$(usex email '' email_requests ) \
		hw_wallet \
		keepkey \
		$(usex sync '' labels ) \
		ledger \
		trezor \
		$(usex vkb '' virtualkeyboard ) \
	; do
		rm -r plugins/"${plugin}"* || die
		sed -i "/${plugin}/d" setup.py || die
	done

	distutils-r1_src_prepare
}

src_compile() {
	# Compile the icons file for Qt:
	pyrcc5 icons.qrc -o gui/qt/icons_rc.py || die
	# Compile the protobuf description file:
	protoc --proto_path=lib/ --python_out=lib/ lib/paymentrequest.proto || die

	distutils-r1_src_compile
}

src_install() {
	doicon -s 128 icons/electron-cash.png
	distutils-r1_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
