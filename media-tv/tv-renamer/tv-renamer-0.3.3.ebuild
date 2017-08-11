# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
atk-sys-0.3.4
bitflags-0.5.0
bitflags-0.7.0
bitflags-0.8.2
c_vec-1.2.1
cairo-rs-0.1.3
cairo-sys-rs-0.3.4
cookie-0.2.5
gcc-0.3.50
gdi32-sys-0.2.0
gdk-0.5.3
gdk-pixbuf-0.1.3
gdk-pixbuf-sys-0.3.4
gdk-sys-0.3.4
gio-0.1.3
gio-sys-0.3.4
glib-0.1.3
glib-sys-0.3.4
gobject-sys-0.3.4
gtk-0.1.3
gtk-sys-0.3.4
hpack-0.2.0
httparse-1.2.3
hyper-0.9.18
idna-0.1.2
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-0.2.8
libc-0.2.23
libressl-pnacl-sys-2.1.6
log-0.3.8
matches-0.1.6
mime-0.2.6
num_cpus-1.5.1
openssl-0.7.14
openssl-sys-0.7.17
openssl-sys-extras-0.7.14
openssl-verify-0.1.0
pango-0.1.3
pango-sys-0.3.4
pkg-config-0.3.9
pnacl-build-helper-1.4.11
quick-error-1.2.0
rand-0.3.15
redox_syscall-0.1.18
rustc-serialize-0.3.24
same-file-0.1.3
solicit-0.4.4
tempdir-0.3.5
time-0.1.37
traitobject-0.0.1
tvdb-0.4.0
typeable-0.1.2
unicase-1.4.2
unicode-bidi-0.3.3
unicode-normalization-0.1.4
url-1.4.1
user32-sys-0.2.0
version_check-0.1.2
walkdir-1.0.7
winapi-0.2.8
winapi-build-0.1.1
xml-rs-0.3.6
xmltree-0.3.2
"

inherit cargo eutils

DESCRIPTION="A TV series renaming application written in Rust"
HOMEPAGE="https://github.com/mmstick/tv-renamer"
SRC_URI="https://github.com/mmstick/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

DEPEND=">=x11-libs/gtk+-3.16:3
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"

RESTRICT="mirror"

src_prepare() {
	# Fix .desktop to pass QA
	sed -i 's:Utiliy:X-Utiliy:' \
		assets/${PN}.desktop || die

	default
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"

	cargo build -v $(usex debug "" --release) \
		|| die "cargo build failed"
}

src_install() {
	dobin target/release/${PN}
	dosym ${PN} /usr/bin/${PN}-gtk

	domenu assets/${PN}.desktop
}
