# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

MMWAPP_PN="mattermost-webapp"
MMWAPP_P="${MMWAPP_PN}-${PV}"

GIT_COMMIT="8f6bb15"
EGO_PN="github.com/mattermost/${PN}"
DESCRIPTION="Open source Slack-alternative in Golang and React"
HOMEPAGE="https://mattermost.com"
SRC_URI="https://github.com/mattermost/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/mattermost/${MMWAPP_PN}/archive/v${PV}.tar.gz -> ${MMWAPP_P}.tar.gz"
RESTRICT="mirror strip test"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=net-libs/nodejs-6.0.0
	sys-apps/yarn"

G="${WORKDIR}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	has network-sandbox $FEATURES && \
		die "www-apps/mattermost-server requires 'network-sandbox' to be disabled in FEATURES"

	enewgroup mattermost
	enewuser mattermost -1 -1 -1 mattermost
}

src_unpack() {
	default

	mkdir -p "${G}"/src/${EGO_PN/$PN} || die
	mv "${WORKDIR}"/${P} "${S}" || die
	mv "${WORKDIR}"/${MMWAPP_P} "${S}"/client || die
}

src_prepare() {
	# Disable developer settings, fix path
	# set to listen localhost and disable 
	# diagnostics (call home) by default
	sed -i \
		-e 's|"ListenAddress": ":8065"|"ListenAddress": "127.0.0.1:8065"|g' \
		-e 's|"ListenAddress": ":8067"|"ListenAddress": "127.0.0.1:8067"|g' \
		-e 's|"ConsoleLevel": "DEBUG"|"ConsoleLevel": "INFO"|g' \
		-e 's|"EnableDiagnostics":.*|"EnableDiagnostics": false|' \
		-e 's|"Directory": ".*"|"Directory": "/var/lib/mattermost/"|g' \
		-e 's|tcp(dockerhost:3306)|unix(/run/mysqld/mysqld.sock)|g' \
		config/default.json || die

	# Reset email sending to original configuration
	sed -i \
		-e 's|"SendEmailNotifications": true,|"SendEmailNotifications": false,|g' \
		-e 's|"FeedbackEmail": "test@example.com",|"FeedbackEmail": "",|g' \
		-e 's|"SMTPServer": "dockerhost",|"SMTPServer": "",|g' \
		-e 's|"SMTPPort": "2500",|"SMTPPort": "",|g' \
		config/default.json || die

	default
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
	-X ${EGO_PN}/model.BuildNumber=${PV} \
	-X '${EGO_PN}/model.BuildDate=$(date -u)' \
	-X ${EGO_PN}/model.BuildHash=${GIT_COMMIT} \
	-X ${EGO_PN}/model.BuildHashEnterprise=none \
	-X ${EGO_PN}/model.BuildEnterpriseReady=false"

	# Unfortunately 'network-sandbox' needs to disabled
	# because sys-apps/yarn fetch dependencies here:
	emake -C client build

	go build -v -ldflags "${GOLDFLAGS}" \
		-o "${S}"/platform ./cmd/platform || die
}

src_install() {
	exeinto /usr/libexec/mattermost/bin
	doexe platform

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service

	insinto /etc/mattermost
	doins config/README.md
	newins config/default.json config.json
	fowners mattermost:mattermost /etc/mattermost/config.json
	fperms 600 /etc/mattermost/config.json

	insinto /usr/share/mattermost
	doins -r {fonts,i18n,templates}

	insinto /usr/share/mattermost/client
	doins -r client/dist/*

	diropts -o mattermost -g mattermost -m 0750
	dodir /var/{lib,log}/mattermost

	dosym ../../../../etc/mattermost/config.json /usr/libexec/mattermost/config/config.json
	dosym ../../share/mattermost/fonts /usr/libexec/mattermost/fonts
	dosym ../../share/mattermost/i18n /usr/libexec/mattermost/i18n
	dosym ../../share/mattermost/templates /usr/libexec/mattermost/templates
	dosym ../../share/mattermost/client /usr/libexec/mattermost/client
	dosym ../../../var/log/mattermost /usr/libexec/mattermost/logs
}
