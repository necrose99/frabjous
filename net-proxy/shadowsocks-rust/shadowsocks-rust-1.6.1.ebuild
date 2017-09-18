# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.3
ansi_term-0.9.0
arrayref-0.3.4
atty-0.2.2
base64-0.6.0
bitflags-0.7.0
bitflags-0.9.1
block-buffer-0.3.1
byte-tools-0.2.0
byteorder-1.1.0
bytes-0.4.4
cfg-if-0.1.2
clap-2.25.1
coco-0.1.1
conv-0.3.3
crossbeam-0.2.10
custom_derive-0.1.7
digest-0.6.2
domain-0.2.1
dtoa-0.4.1
either-1.1.0
env_logger-0.4.3
foreign-types-0.2.0
futures-0.1.14
gcc-0.3.51
generic-array-0.8.2
idna-0.1.4
iovec-0.1.0
itoa-0.3.1
kernel32-sys-0.2.2
lazy_static-0.2.8
lazycell-0.4.0
libc-0.2.28
libsodium-sys-0.0.15
linked-hash-map-0.4.2
log-0.3.8
lru-cache-0.1.1
lru_time_cache-0.6.0
magenta-0.1.1
magenta-sys-0.1.1
matches-0.1.6
md-5-0.5.2
memchr-1.0.1
mio-0.6.9
mio-uds-0.6.4
miow-0.2.1
net2-0.2.30
netdb-0.1.0
nodrop-0.1.9
num-traits-0.1.40
num_cpus-1.6.2
odds-0.2.25
openssl-0.9.15
openssl-sys-0.9.15
percent-encoding-1.0.0
pkg-config-0.3.9
qrcode-0.4.0
rand-0.3.16
rayon-0.7.1
rayon-core-1.2.1
redox_syscall-0.1.27
regex-0.2.2
regex-syntax-0.4.1
ring-0.11.0
safemem-0.2.0
scoped-tls-0.1.0
scopeguard-0.3.2
serde-1.0.11
serde_json-1.0.2
serde_urlencoded-0.5.1
slab-0.3.0
sodiumoxide-0.0.15
strsim-0.6.0
subprocess-0.1.10
term_size-0.3.0
textwrap-0.6.0
thread_local-0.3.4
time-0.1.38
tokio-core-0.1.9
tokio-io-0.1.2
tokio-signal-0.1.2
typenum-1.9.0
unicode-bidi-0.3.4
unicode-normalization-0.1.5
unicode-segmentation-1.1.0
unicode-width-0.1.4
unreachable-1.0.0
untrusted-0.5.0
url-1.5.1
utf8-ranges-1.0.0
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
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

DEPEND="dev-libs/libsodium
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

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
