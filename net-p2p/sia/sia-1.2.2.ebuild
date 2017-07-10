# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/NebulousLabs/demotemutex 235395f71c4073ee8e71eb51476e7989043b9809"
	"github.com/NebulousLabs/fastrand 60b615657d85339c105efb2170327a2d948d4b17"
	"github.com/NebulousLabs/merkletree 9aa7ce56e83cb5f244ff08807250866e5f04ce5a"
	"github.com/NebulousLabs/bolt e9cf4fae01b5a8ff89d0ec6b32f0d9c9f79aefdd"

	"golang.org/x/crypto 3627ff35f31987174dbee61d9d1dcc1c643e7174 github.com/golang/crypto"
	"golang.org/x/net 054b33e6527139ad5b1ec2f6232c3b175bd9a30c github.com/golang/net"
	"golang.org/x/text cfdf022e86b4ecfb646e1efbd7db175dd623a8fa github.com/golang/text"

	"github.com/NebulousLabs/entropy-mnemonics 7b01a644a63680b90de22bacfb11d832e944eaab"
	"github.com/NebulousLabs/errors 98e1f05a42d03a706ec86baf52f0bb5a40923f0d"
	"github.com/NebulousLabs/go-upnp 11ba8545e2a2103af18cbb040e73256d6db25582"
	"github.com/NebulousLabs/muxado b4de4d8a34c7ca6e2f597ccfd33ec88224af5ad0"

	"github.com/cpuguy83/go-md2man 23709d0847197db6021a51fdb193e66e9222d4e7"
	"github.com/klauspost/cpuid 09cded8978dc9e80714c4d85b0322337b0a1e5e0"
	"github.com/klauspost/reedsolomon 18d548df635f0d2c5c0e6bfc500d425ba1859403"
	"github.com/julienschmidt/httprouter 975b5c4c7c21c0e3d2764200bf2aa8e34657ae6e"
	"github.com/inconshreveable/go-update 8152e7eb6ccf8679a64582a66b78519688d156ad"
	"github.com/kardianos/osext ae77be60afb1dcacde03767a8c37337fad28ac14"

	"github.com/bgentry/speakeasy 4aabc24848ce5fd31929f7d1e4ea74d3709c14cd"
	"github.com/spf13/cobra 8c6fa02d2225de0f9bdcb7ca912556f68d172d8c"
	"github.com/spf13/pflag e57e3eeb33f795204c1ca35f56c44f83227c6e66"
	"gopkg.in/yaml.v2 cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b github.com/go-yaml/yaml"
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
IUSE=""

DEPEND=">=dev-lang/go-1.8"

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
	dodoc src/${EGO_PN}/{README,CHANGELOG}.md

	newinitd "${FILESDIR}"/sia.initd sia
	newconfd "${FILESDIR}"/sia.confd sia
	systemd_dounit "${FILESDIR}"/sia.service

	keepdir /var/lib/sia
	fperms 750 /var/lib/sia
	fowners sia:sia /var/lib/sia
}
