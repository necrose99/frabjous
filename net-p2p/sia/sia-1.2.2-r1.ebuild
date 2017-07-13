# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/NebulousLabs/demotemutex 235395f"
	"github.com/NebulousLabs/fastrand 60b6156"
	"github.com/NebulousLabs/merkletree 9aa7ce5"
	"github.com/NebulousLabs/bolt e9cf4fa"

	"golang.org/x/crypto dd85ac7 github.com/golang/crypto"
	"golang.org/x/net f01ecb6 github.com/golang/net"
	"golang.org/x/text cfdf022 github.com/golang/text"

	"github.com/NebulousLabs/entropy-mnemonics 7b01a64"
	"github.com/NebulousLabs/errors 98e1f05"
	"github.com/NebulousLabs/go-upnp 11ba854"
	"github.com/NebulousLabs/muxado b4de4d8"

	"github.com/cpuguy83/go-md2man 23709d0"
	"github.com/klauspost/cpuid 09cded8"
	"github.com/klauspost/reedsolomon 18d548d"
	"github.com/julienschmidt/httprouter 975b5c4"
	"github.com/inconshreveable/go-update 8152e7e"
	"github.com/kardianos/osext ae77be6"

	"github.com/bgentry/speakeasy 4aabc24"
	"github.com/spf13/cobra c46add8"
	"github.com/spf13/pflag e57e3ee"
	"gopkg.in/yaml.v2 1be3d31 github.com/go-yaml/yaml" #v2
)

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/NebulousLabs/Sia"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Blockchain-based marketplace for file storage"
HOMEPAGE="https://sia.tech"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

pkg_setup() {
	enewgroup sia
	enewuser sia -1 -1 -1 sia
}

src_compile() {
	local PKGS=( ./api ./build ./compatibility ./crypto ./encoding ./modules ./modules/consensus \
		./modules/explorer ./modules/gateway ./modules/host ./modules/host/contractmanager \
		./modules/renter ./modules/renter/contractor ./modules/renter/hostdb ./modules/renter/hostdb/hosttree \
		./modules/renter/proto ./modules/miner ./modules/wallet ./modules/transactionpool ./persist ./siac \
		./siad ./sync ./types )

	cd src/${EGO_PN} || die

	GOPATH="${S}:$(get_golibdir_gopath)" go install -v "${PKGS[@]}"
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN}/doc/*.md

	newinitd "${FILESDIR}"/sia.initd sia
	newconfd "${FILESDIR}"/sia.confd sia
	systemd_dounit "${FILESDIR}"/sia.service

	keepdir /var/lib/sia
	fperms 750 /var/lib/sia
	fowners sia:sia /var/lib/sia
}
