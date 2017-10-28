# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
ansi_term-0.8.0
bitflags-0.9.1
byteorder-0.4.2
cmake-0.1.24
datetime-0.4.4
gcc-0.3.51
getopts-0.2.14
git2-0.6.6
glob-0.2.11
idna-0.1.2
iso8601-0.1.1
lazy_static-0.2.8
libc-0.2.24
libgit2-sys-0.6.12
libz-sys-1.0.16
locale-0.2.2
matches-0.1.6
natord-1.0.9
nom-1.2.4
num-0.1.39
num-bigint-0.1.39
num-complex-0.1.38
num-integer-0.1.34
num-iter-0.1.33
num-rational-0.1.38
num-traits-0.1.39
num_cpus-1.6.2
number_prefix-0.2.7
pad-0.1.4
percent-encoding-1.0.0
pkg-config-0.3.9
rand-0.3.15
rustc-serialize-0.3.24
scoped_threadpool-0.1.7
term_grid-0.1.5
unicode-bidi-0.3.3
unicode-normalization-0.1.5
unicode-width-0.1.4
url-1.5.1
users-0.5.2
vcpkg-0.2.2
"

inherit bash-completion-r1 cargo

DESCRIPTION="A replacement for 'ls' written in Rust"
HOMEPAGE="https://the.exa.website"
SRC_URI="https://github.com/ogham/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fish-completion zsh-completion"

DEPEND="dev-libs/libgit2"
RDEPEND="${DEPEND}
	fish-completion? ( app-shells/fish )
	zsh-completion? ( app-shells/zsh )"
RESTRICT="mirror"

pkg_setup() {
	# Unfortunately, I couldn't figure out how to import/extract
	# the dependency 'zoneinfo_compiled' from GitHub and force
	# Cargo to use it before compile phase. So let's block
	# 'network-sandbox' for now.
	has network-sandbox $FEATURES && \
		die "sys-apps/exa requires 'network-sandbox' to be disabled in FEATURES"
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"

	cargo build -v \
		$(usex debug '' --release) \
		--no-default-features --features "default" \
		|| die "cargo build failed"
}

src_install() {
	dobin target/release/exa
	doman contrib/man/exa.1

	newbashcomp contrib/completions.bash exa

	if use fish-completion;then
		insinto /usr/share/fish/completions
		newins contrib/completions.fish exa.fish
	fi

	if use zsh-completion;then
		insinto /usr/share/zsh/site-functions
		newins contrib/completions.zsh _exa
	fi
}
