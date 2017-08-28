# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"
DESCRIPTION="Gitea - Git with a cup of tea"
HOMEPAGE="https://gitea.io"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="memcached mysql openssh pam postgres redis sqlite tidb"

DEPEND="dev-go/go-bindata"
RDEPEND="dev-vcs/git[curl,threads]
	memcached? ( net-misc/memcached )
	mysql? ( virtual/mysql )
	openssh? ( net-misc/openssh )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql )
	redis? ( dev-db/redis )
	sqlite? ( dev-db/sqlite )
	tidb? ( dev-db/tidb )"

RESTRICT="mirror strip"

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
		-e "s:^STATIC_ROOT_PATH =:STATIC_ROOT_PATH = ${EPREFIX}/usr/share/gitea:" \
		-e "s:^APP_DATA_PATH =.*:APP_DATA_PATH = ${GITEA_PREFIX}/data:" \
		-e "s:^PATH = data/gitea.db:PATH = ${GITEA_PREFIX}/data/gitea.db:" \
		-e "s:^ISSUE_INDEXER_PATH =.*:ISSUE_INDEXER_PATH = ${GITEA_PREFIX}/indexers/issues.bleve:" \
		-e "s:^PROVIDER_CONFIG =.*:PROVIDER_CONFIG = ${GITEA_PREFIX}/data/sessions:" \
		-e "s:^AVATAR_UPLOAD_PATH =.*:AVATAR_UPLOAD_PATH = ${GITEA_PREFIX}/data/avatars:" \
		-e "s:^PATH = data/attachments:PATH = ${GITEA_PREFIX}/data/attachments:" \
		-e "s:^ROOT_PATH =:ROOT_PATH = ${EPREFIX}/var/log/gitea:" \
		src/${EGO_PN}/conf/app.ini || die

	default
}

src_compile() {
	local TAGS_OPTS=

	use pam && TAGS_OPTS+=" pam"
	use sqlite && TAGS_OPTS+=" sqlite"
	use tidb && TAGS_OPTS+=" tidb"

	GOPATH="${S}" TAGS="${TAGS_OPTS/ /}" emake -C src/${EGO_PN} generate build
}

src_install() {
	pushd src/${EGO_PN} > /dev/null || die
	dobin gitea

	insinto /var/lib/gitea/conf
	newins conf/app.ini app.ini.example

	insinto /var/lib/gitea
	doins -r options

	insinto /usr/share/gitea
	insopts -o root -g git -m640
	doins -r {public,templates}
	popd > /dev/null || die

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	diropts -m 0750
	dodir /var/lib/gitea/data
	diropts -m 0700
	dodir /var/log/gitea
	fowners -R git:git /var/{lib,log}/gitea

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_postinst() {
	if [ ! -e "${EROOT}"/var/lib/${PN}/conf/app.ini ]; then
		elog "No app.ini found, copying the example over"
		cp "${EROOT}"/var/lib/${PN}/conf/app.ini{.example,} || die
	else
		elog "app.ini found, please check example file for possible changes"
	fi
}
