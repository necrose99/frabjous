# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="b1100b5"
EGO_PN="github.com/gogits/gogs"

DESCRIPTION="A painless self-hosted Git service"
HOMEPAGE="https://gogs.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cert memcached mysql openssh pam postgres redis sqlite tidb"

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
	enewgroup gogs
	enewuser gogs -1 /bin/bash /var/lib/gogs gogs
}

src_prepare() {
	local GOGS_PREFIX=${EPREFIX}/var/lib/gogs

	sed -i \
		-e "s:BuildGitHash=.*:BuildGitHash=${GIT_COMMIT}\":g" \
		-e "s:TAGS =.*::g" \
		-e "s:-ldflags ':-ldflags '-s -w :" \
		src/${EGO_PN}/Makefile || die

	sed -i \
		-e "s:^RUN_USER =.*:RUN_USER = gogs:" \
		-e "s:^ROOT =:ROOT = ${GOGS_PREFIX}/repos:" \
		-e "s:^TEMP_PATH =.*:TEMP_PATH = ${GOGS_PREFIX}/data/tmp/uploads:" \
		-e "s:^STATIC_ROOT_PATH =:STATIC_ROOT_PATH = ${EPREFIX}/usr/share/gogs:" \
		-e "s:^APP_DATA_PATH =.*:APP_DATA_PATH = ${GOGS_PREFIX}/data:" \
		-e "s:^PATH = data/gogs.db:PATH = ${GOGS_PREFIX}/data/gogs.db:" \
		-e "s:^PROVIDER_CONFIG =.*:PROVIDER_CONFIG = ${GOGS_PREFIX}/data/sessions:" \
		-e "s:^AVATAR_UPLOAD_PATH =.*:AVATAR_UPLOAD_PATH = ${GOGS_PREFIX}/data/avatars:" \
		-e "s:^PATH = data/attachments:PATH = ${GOGS_PREFIX}/data/attachments:" \
		-e "s:^ROOT_PATH =:ROOT_PATH = ${EPREFIX}/var/log/gogs:" \
		src/${EGO_PN}/conf/app.ini || die

	default
}

src_compile() {
	local TAGS_OPTS=

	use cert && TAGS_OPTS+=" cert"
	use pam && TAGS_OPTS+=" pam"
	use sqlite && TAGS_OPTS+=" sqlite"
	use tidb && TAGS_OPTS+=" tidb"

	LDFLAGS="" GOPATH="${S}" TAGS="${TAGS_OPTS/ /}" emake -C src/${EGO_PN} build
}

src_install() {
	pushd src/${EGO_PN} > /dev/null || die
	dobin gogs

	insinto /var/lib/gogs/conf
	newins conf/app.ini app.ini.example

	insinto /usr/share/gogs
	insopts -o root -g gogs -m640
	doins -r {conf,public,templates}
	popd > /dev/null || die

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	dodir /var/lib/gogs/data
	keepdir /var/{lib,log}/gogs
	fowners -R gogs:gogs /var/{lib,log}/gogs

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_preinst() {
	# Remove unnecessary files
	rm -r "${D}"/usr/share/gogs/public/{less,config.codekit} || die
}

pkg_postinst() {
	if [ ! -e ${EROOT}/var/lib/gogs/conf/app.ini ]; then
		elog "No app.ini found, copying the example over"
		cp "${EROOT}"/var/lib/gogs/conf/app.ini{.example,} || die
	else
		elog "app.ini found, please check example file for possible changes"
	fi
}
