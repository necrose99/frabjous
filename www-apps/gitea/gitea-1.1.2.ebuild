# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"
DESCRIPTION="A painless self-hosted Git service, written in Go"
HOMEPAGE="https://gitea.io"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="memcached mysql postgres redis sqlite tidb"

DEPEND="dev-go/go-bindata"
RDEPEND="dev-vcs/git
	memcached? ( net-misc/memcached )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	redis? ( dev-db/redis )
	sqlite? ( dev-db/sqlite )
	tidb? ( dev-db/tidb )"

RESTRICT="strip"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitea git
}

src_prepare() {
	local GITEA_PREFIX=${EPREFIX}/var/lib/gitea

	sed -i 's/Version=.*/Version='${PV}'" -X "main.Tags=$(TAGS)"/g' \
		src/${EGO_PN}/Makefile || die

	sed -i -e "s:^ROOT =:ROOT = ${GITEA_PREFIX}/repos:" \
		-e "s:^TEMP_PATH =.*:TEMP_PATH = ${GITEA_PREFIX}/data/tmp/uploads:" \
		-e "s:^STATIC_ROOT_PATH =:STATIC_ROOT_PATH = ${GITEA_PREFIX}:" \
		-e "s:^APP_DATA_PATH =.*:APP_DATA_PATH = ${GITEA_PREFIX}/data:" \
		-e "s:^PATH = data/gitea.db:PATH = ${GITEA_PREFIX}/data/gitea.db:" \
		-e "s:^ISSUE_INDEXER_PATH =.*:ISSUE_INDEXER_PATH = ${GITEA_PREFIX}/indexers/issues.bleve:" \
		-e "s:^PROVIDER_CONFIG =.*:PROVIDER_CONFIG = ${GITEA_PREFIX}/data/sessions:" \
		-e "s:^AVATAR_UPLOAD_PATH =.*:AVATAR_UPLOAD_PATH = ${GITEA_PREFIX}/data/avatars:" \
		-e "s:^PATH = data/attachments:PATH = ${GITEA_PREFIX}/data/attachments:" \
		-e "s:^ROOT_PATH =:ROOT_PATH = ${EPREFIX}/var/log/gitea:" \
		-e "s:^MODE = console:MODE = file:" \
		-e "s:^LEVEL = Trace:LEVEL = Info:" \
		src/${EGO_PN}/conf/app.ini || die

	default
}

src_compile() {
	GOPATH="${S}:$(get_golibdir_gopath)" TAGS="sqlite tidb pam" \
		emake -C src/${EGO_PN} generate install
}

src_install() {
	dobin bin/gitea

	insinto /var/lib/gitea/conf
	newins src/${EGO_PN}/conf/app.ini app.ini.example

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/gitea.logrotate gitea

	newinitd "${FILESDIR}"/gitea.initd gitea
	systemd_dounit "${FILESDIR}"/gitea.service

	keepdir /var/log/gitea /var/lib/gitea/data
	fowners -R git:git /var/log/gitea /var/lib/gitea/
}

pkg_postinst() {
	if [[ ! -e ${EROOT}/var/lib/gitea/conf/app.ini ]]; then
		elog "No app.ini found, copying the example over"
		cp "${EROOT}"/var/lib/gitea/conf/app.ini{.example,} || die
	else
		elog "app.ini found, please check example file for possible changes"
	fi
}
