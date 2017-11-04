# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/dannyvankooten/${PN}"
DESCRIPTION="WebExtension host binary for app-admin/pass, a UNIX password manager"
HOMEPAGE="https://www.passwordstore.org"
SRC_URI="https://${EGO_PN}/releases/download/${PV}/browserpass-src.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-admin/pass
	|| (
		www-client/firefox
		www-client/firefox-bin
		www-client/chromium
		www-client/inox
	)"
RESTRICT="mirror strip"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_prepare() {
	sed -i "s:%%replace%%:${EPREFIX}/usr/bin/browserpass:" \
		firefox/host.json chrome/host.json || die

	default
}

src_compile() {
	export GOPATH="${G}"

	go build -v -ldflags "-s -w" \
		./cmd/browserpass || die
}

# Broken for now.
#src_test() {
#	go test -v ./... || die
#}

src_install() {
	dobin browserpass
	einstalldocs

	if has_version "www-client/firefox" || \
		has_version "www-client/firefox-bin"; then
		insinto /usr/$(get_libdir)/mozilla/native-messaging-hosts
		newins firefox/host.json com.dannyvankooten.browserpass.json
	fi

	if has_version "www-client/chromium" ||
		has_version "www-client/inox"; then
		insinto /etc/chromium/native-messaging-hosts
		newins chrome/host.json com.dannyvankooten.browserpass.json
	fi
}

pkg_postinst() {
	elog "To use Browserpass, you must install the extention to your browser"
	if has_version "www-client/firefox" || \
		has_version "www-client/firefox-bin"; then
		elog "- https://addons.mozilla.org/en-US/firefox/addon/browserpass-ce/"
	fi
	if has_version "www-client/chromium" || \
		has_version "www-client/inox"; then
		elog "- https://chrome.google.com/webstore/detail/browserpass-ce/naepdomgkenhinolocfifgehidddafch"
	fi
}
