# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Generate with
# curl -s https://raw.githubusercontent.com/shadowsocks/shadowsocks-rust/v1.6.8/Cargo.lock | sed 's/^"checksum \([[:graph:]]\+\) \([[:graph:]]\+\) (.*$/\1-\2/'
CRATES="
aho-corasick-0.6.3
ansi_term-0.9.0
arrayref-0.3.4
atty-0.2.3
base64-0.6.0
bitflags-0.7.0
bitflags-0.9.1
block-buffer-0.3.1
byte-tools-0.2.0
byte_string-1.0.0
byteorder-1.1.0
bytes-0.4.5
cc-1.0.3
cfg-if-0.1.2
clap-2.27.1
coco-0.1.1
crossbeam-0.2.10
digest-0.6.2
dtoa-0.4.2
either-1.3.0
env_logger-0.4.3
foreign-types-0.2.0
fuchsia-zircon-0.2.1
fuchsia-zircon-sys-0.2.0
futures-0.1.16
futures-cpupool-0.1.7
gcc-0.3.54
generic-array-0.8.3
idna-0.1.4
iovec-0.1.1
itoa-0.3.4
kernel32-sys-0.2.2
lazy_static-0.2.9
lazycell-0.5.1
libc-0.2.33
libsodium-ffi-0.1.9
log-0.3.8
matches-0.1.6
md-5-0.5.2
memchr-1.0.2
mio-0.6.11
mio-uds-0.6.4
miow-0.2.1
net2-0.2.31
nodrop-0.1.12
num-traits-0.1.40
num_cpus-1.7.0
openssl-0.9.21
openssl-sys-0.9.21
percent-encoding-1.0.0
pkg-config-0.3.9
qrcode-0.4.0
rand-0.3.17
rayon-0.7.1
rayon-core-1.2.1
redox_syscall-0.1.31
redox_termios-0.1.1
regex-0.2.2
regex-syntax-0.4.1
ring-0.11.0
safemem-0.2.0
scoped-tls-0.1.0
scopeguard-0.3.3
serde-1.0.16
serde_json-1.0.5
serde_urlencoded-0.5.1
slab-0.3.0
slab-0.4.0
strsim-0.6.0
subprocess-0.1.11
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.4
time-0.1.38
tokio-core-0.1.10
tokio-io-0.1.3
tokio-signal-0.1.2
typenum-1.9.0
unicode-bidi-0.3.4
unicode-normalization-0.1.5
unicode-width-0.1.4
unreachable-1.0.0
untrusted-0.5.1
url-1.5.1
utf8-ranges-1.0.0
vcpkg-0.2.2
vec_map-0.8.0
void-1.0.2
winapi-0.2.8
winapi-build-0.1.1
ws2_32-sys-0.2.1
"

inherit cargo user

DESCRIPTION="A Rust port of Shadowsocks"
HOMEPAGE="https://shadowsocks.org"
SRC_URI="https://github.com/shadowsocks/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl"

DEPEND="dev-libs/libsodium:0=[-minimal]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
RDEPEND="${DEPEND}"
RESTRICT="mirror"

PATCHES=( "${FILESDIR}"/${P}-openssl-0.9.21.patch )

pkg_setup() {
	enewgroup shadowsocks
	enewuser shadowsocks -1 -1 -1 shadowsocks
}

src_install() {
	dobin target/release/ss{local,server,url}

	newinitd "${FILESDIR}"/${PN}-local.initd-r2 ss-local
	newinitd "${FILESDIR}"/${PN}-server.initd-r2 ss-server

	diropts -o shadowsocks -g shadowsocks -m 0700
	dodir /{etc,var/log}/shadowsocks-rust

	insinto /etc/shadowsocks-rust
	newins "${FILESDIR}"/${PN}-local.conf local.json.example
	newins "${FILESDIR}"/${PN}-server.conf server.json.example
}
