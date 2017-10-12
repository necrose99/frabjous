# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
advapi32-sys-0.2.0
aho-corasick-0.6.3
ansi_term-0.9.0
antidote-1.0.0
app_dirs-1.1.1
arrayvec-0.3.20
aster-0.41.0
atty-0.2.2
backtrace-0.2.3
backtrace-sys-0.1.11
base-x-0.2.2
base32-0.3.1
bigint-3.0.0
bigint-4.2.0
bincode-0.8.0
bit-set-0.2.0
bit-set-0.4.0
bit-vec-0.4.3
bitflags-0.5.0
bitflags-0.7.0
bitflags-0.8.2
bitflags-0.9.1
blastfig-0.3.3
bloomchain-0.1.0
byteorder-0.5.3
byteorder-1.0.0
bytes-0.4.4
cc-1.0.0
cfg-if-0.1.0
cid-0.2.2
clap-2.24.2
clippy-0.0.103
clippy_lints-0.0.103
coco-0.1.1
conv-0.3.3
cookie-0.3.1
core-foundation-0.2.2
core-foundation-sys-0.2.2
crossbeam-0.2.10
crunchy-0.1.6
crypt32-sys-0.2.0
custom_derive-0.1.7
daemonize-0.2.2
dbghelp-sys-0.2.0
difference-1.0.0
docopt-0.8.1
dtoa-0.4.0
either-1.0.2
elastic-array-0.9.0
env_logger-0.4.2
error-chain-0.5.0
ethabi-2.0.0
fdlimit-0.1.1
flate2-0.2.14
fnv-1.0.5
foreign-types-0.2.0
futures-0.1.11
futures-cpupool-0.1.5
gcc-0.3.51
gdi32-sys-0.2.0
getopts-0.2.14
glob-0.2.11
globset-0.1.4
hamming-0.1.3
heapsize-0.4.0
heck-0.2.0
httparse-1.1.2
hyper-0.10.5
hyper-native-tls-0.2.2
idna-0.1.0
igd-0.6.0
integer-encoding-1.0.3
iovec-0.1.0
isatty-0.1.1
itertools-0.5.9
itoa-0.3.0
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-0.2.8
lazycell-0.4.0
lazycell-0.5.0
libc-0.2.21
libflate-0.1.9
linked-hash-map-0.2.1
linked-hash-map-0.3.0
local-encoding-0.2.0
log-0.3.7
lru-cache-0.1.0
matches-0.1.2
memchr-1.0.1
mime-0.2.0
mime_guess-1.6.1
miniz-sys-0.1.9
mio-0.6.8
mio-uds-0.6.2
miow-0.1.5
miow-0.2.1
msdos_time-0.1.4
multibase-0.6.0
multihash-0.6.0
native-tls-0.1.2
net2-0.2.29
nodrop-0.1.9
nom-1.2.2
ntp-0.2.0
num-0.1.32
num-bigint-0.1.32
num-complex-0.1.32
num-integer-0.1.32
num-iter-0.1.32
num-rational-0.1.32
num-traits-0.1.32
num_cpus-1.2.0
number_prefix-0.2.5
odds-0.2.12
ole32-sys-0.2.0
openssl-0.9.13
openssl-0.9.19
openssl-sys-0.9.13
openssl-sys-0.9.19
order-stat-0.1.3
owning_ref-0.3.3
parity-dapps-glue-1.7.0
parity-wasm-0.12.1
parity-wordlist-1.0.1
parking_lot-0.4.0
parking_lot_core-0.2.0
phf-0.7.14
phf_codegen-0.7.14
phf_generator-0.7.14
phf_shared-0.7.14
pkg-config-0.3.9
podio-0.1.5
pretty_assertions-0.1.2
primal-0.2.3
primal-bit-0.2.3
primal-check-0.2.2
primal-estimate-0.2.1
primal-sieve-0.2.5
pulldown-cmark-0.0.3
quasi-0.32.0
quasi_codegen-0.32.0
quasi_macros-0.32.0
quick-error-1.1.0
quine-mc_cluskey-0.2.2
quote-0.3.10
rand-0.3.14
rayon-0.7.1
rayon-0.8.2
rayon-core-1.2.1
regex-0.2.1
regex-syntax-0.3.1
regex-syntax-0.4.0
reqwest-0.6.2
ring-0.9.5
rpassword-0.2.2
rpassword-0.3.0
rust-crypto-0.2.36
rustc-demangle-0.1.4
rustc-hex-1.0.0
rustc-serialize-0.3.19
rustc_version-0.1.7
rustc_version-0.2.0
schannel-0.1.5
scoped-tls-0.1.0
scopeguard-0.3.2
secur32-sys-0.2.0
security-framework-0.1.14
security-framework-sys-0.1.14
semver-0.1.20
semver-0.2.3
semver-0.6.0
semver-parser-0.7.0
serde-1.0.9
serde_derive-1.0.9
serde_derive_internals-0.15.1
serde_json-1.0.2
serde_urlencoded-0.5.1
sha1-0.2.0
shell32-sys-0.1.1
siphasher-0.1.1
skeptic-0.4.0
slab-0.2.0
slab-0.3.0
smallvec-0.1.8
smallvec-0.2.1
smallvec-0.4.0
spmc-0.2.1
stable_deref_trait-1.0.0
strsim-0.6.0
subtle-0.1.0
syn-0.11.11
synom-0.11.3
syntex-0.58.0
syntex_errors-0.58.0
syntex_pos-0.58.0
syntex_syntax-0.58.0
take-0.1.0
target_info-0.1.0
tempdir-0.3.5
term-0.4.5
term_size-0.3.0
termios-0.2.2
thread-id-3.0.0
thread_local-0.3.3
time-0.1.35
tiny-keccak-1.2.1
tokio-core-0.1.6
tokio-io-0.1.1
tokio-proto-0.1.0
tokio-service-0.1.0
tokio-timer-0.1.1
tokio-uds-0.1.4
toml-0.1.28
toml-0.4.2
traitobject-0.1.0
transient-hashmap-0.4.0
typeable-0.1.2
unicase-1.4.0
unicode-bidi-0.2.3
unicode-normalization-0.1.2
unicode-segmentation-1.1.0
unicode-width-0.1.4
unicode-xid-0.0.4
unreachable-0.1.1
untrusted-0.5.0
url-1.2.0
user32-sys-0.2.0
utf8-ranges-1.0.0
vcpkg-0.2.2
vec_map-0.8.0
vecio-0.1.0
vergen-0.1.0
void-1.0.2
winapi-0.2.8
winapi-build-0.1.1
ws2_32-sys-0.2.1
xdg-2.0.0
xml-rs-0.3.4
xmltree-0.3.2
zip-0.1.18
"

inherit cargo systemd user

DESCRIPTION="Fast, light, and robust Ethereum client"
HOMEPAGE="https://parity.io"
SRC_URI="https://github.com/paritytech/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+daemon libressl"

RDEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( <=dev-libs/libressl-2.6.1:0= )"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

DOCS=( {CHANGELOG,README,SECURITY}.md )

pkg_setup() {
	# Unfortunately 'network-sandbox' needs to
	# disabled because Cargo fetch a few dependencies.
	has network-sandbox $FEATURES && \
		die "net-p2p/parity require 'network-sandbox' to be disabled in FEATURES"

	if use daemon; then
		enewgroup parity
		enewuser parity -1 -1 /var/lib/parity parity
	fi
}

src_prepare() {
	if has_version "<=dev-libs/libressl-2.6.1" && \
		has_version ">=dev-libs/libressl-2.5.5"; then
		eapply "${FILESDIR}"/${PN}-1.7.2-openssl-0.9.19.patch
	fi

	default
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"

	cargo build -v \
		$(usex !debug --release '') \
		|| die "cargo build failed"
}

src_install() {
	dobin target/release/parity
	einstalldocs

	if use daemon; then
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_dounit scripts/${PN}.service
	fi
}
