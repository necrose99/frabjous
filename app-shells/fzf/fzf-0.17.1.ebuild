# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with glide.lock
# Deps that are not needed:
# github.com/gdamore/encoding
# github.com/gdamore/tcell
# github.com/lucasb-eyer/go-colorful
# golang.org/x/sys
# golang.org/x/text
EGO_VENDOR=(
	"github.com/mattn/go-isatty 66b8e73"
	"github.com/mattn/go-runewidth 14207d2"
	"github.com/mattn/go-shellwords 02e3cf0"
	"golang.org/x/crypto e1a4589 github.com/golang/crypto"
)

inherit bash-completion-r1 golang-vcs-snapshot

PKG_COMMIT="0b33dc6"
EGO_PN="github.com/junegunn/fzf"
DESCRIPTION="A general-purpose command-line fuzzy finder"
HOMEPAGE="https://github.com/junegunn/fzf"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion fish-completion neovim tmux vim zsh-completion"

RDEPEND="fish-completion? ( app-shells/fish )
	neovim? ( app-editors/neovim )
	tmux? ( app-misc/tmux )
	vim? ( app-editors/vim )
	zsh-completion? ( app-shells/zsh )"
RESTRICT="mirror strip"

DOCS=( {CHANGELOG,README}.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X main.revision=${PKG_COMMIT}"

	go build -v -ldflags \
		"${GOLDFLAGS}" || die
}

src_test() {
	go test -v ./src{,/algo,/tui,/util} || die
}

src_install() {
	dobin fzf
	doman man/man1/fzf.1
	einstalldocs

	if use bash-completion; then
		newbashcomp shell/completion.bash fzf
		insinto /etc/profile.d/
		newins shell/key-bindings.bash fzf.sh
	fi

	if use fish-completion; then
		insinto /usr/share/fish/functions/
		newins shell/key-bindings.fish fzf_key_bindings.fish
	fi

	if use neovim; then
		insinto /usr/share/nvim/runtime/plugin
		doins plugin/fzf.vim
	fi

	if use tmux; then
		dobin bin/fzf-tmux
		doman man/man1/fzf-tmux.1
	fi

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins plugin/fzf.vim
		dodoc README-VIM.md
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		newins shell/completion.zsh _fzf
		insinto /usr/share/zsh/site-contrib/
		newins shell/key-bindings.zsh fzf.zsh
	fi
}
