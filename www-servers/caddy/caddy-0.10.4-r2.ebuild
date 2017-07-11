# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# expires (https://github.com/epicagency/caddy-expires, MIT license)
HTTP_EXPIRES_EGO_PN="github.com/epicagency/caddy-expires"
HTTP_EXPIRES_EGIT_COMMIT="cb2ed464e061263893acfe4cdbcab6f54e244afc" #Version: 1.0.0
HTTP_EXPIRES_URI="https://${HTTP_EXPIRES_EGO_PN}/archive/${HTTP_EXPIRES_EGIT_COMMIT}.tar.gz"
HTTP_EXPIRES_P="${HTTP_EXPIRES_EGO_PN//\//-}-${HTTP_EXPIRES_EGIT_COMMIT}"

# cors (https://github.com/captncraig/cors, ??? license)
HTTP_CORS_EGO_PN="github.com/captncraig/cors"
HTTP_CORS_EGIT_COMMIT="153f484dcf3da8d204585836c3bc4b2ce326ab54" #Version: 153f484
HTTP_CORS_URI="https://${HTTP_CORS_EGO_PN}/archive/${HTTP_CORS_EGIT_COMMIT}.tar.gz"
HTTP_CORS_P="${HTTP_CORS_EGO_PN//\//-}-${HTTP_CORS_EGIT_COMMIT}"

# minify (https://github.com/hacdias/caddy-minify, Apache-2.0 license)
HTTP_MINIFY_EGO_PN="github.com/hacdias/caddy-minify"
HTTP_MINIFY_EGIT_COMMIT="ebd59eb798bca79555b2ac7163107be0c29e33cf" #Version: ebd59eb
HTTP_MINIFY_URI="https://${HTTP_MINIFY_EGO_PN}/archive/${HTTP_MINIFY_EGIT_COMMIT}.tar.gz"
HTTP_MINIFY_P="${HTTP_MINIFY_EGO_PN//\//-}-${HTTP_MINIFY_EGIT_COMMIT}"

# minify's dependency 1 (https://github.com/tdewolff/minify, MIT license)
HTTP_MINIFY1_EGO_PN="github.com/tdewolff/minify"
HTTP_MINIFY1_EGIT_COMMIT="2d28d6e43c68537a32f9b835a89d5038ebcb6ec9" #Version: 2d28d6e
HTTP_MINIFY1_URI="https://${HTTP_MINIFY1_EGO_PN}/archive/${HTTP_MINIFY1_EGIT_COMMIT}.tar.gz"
HTTP_MINIFY1_P="${HTTP_MINIFY1_EGO_PN//\//-}-${HTTP_MINIFY1_EGIT_COMMIT}"

# minify's dependency 2 (https://github.com/tdewolff/buffer, MIT license)
HTTP_MINIFY2_EGO_PN="github.com/tdewolff/buffer"
HTTP_MINIFY2_EGIT_COMMIT="df6253e2a2cda5aba1b5d0c59fc5bdf0a98ae192" #Version: df6253e
HTTP_MINIFY2_URI="https://${HTTP_MINIFY2_EGO_PN}/archive/${HTTP_MINIFY2_EGIT_COMMIT}.tar.gz"
HTTP_MINIFY2_P="${HTTP_MINIFY2_EGO_PN//\//-}-${HTTP_MINIFY2_EGIT_COMMIT}"

# minify's dependency 3 (https://github.com/tdewolff/parse, MIT license)
HTTP_MINIFY3_EGO_PN="github.com/tdewolff/parse"
HTTP_MINIFY3_EGIT_COMMIT="e3d09bbcbf6d7721468bbe5deb35fe71da57d0f3" #Version: e3d09bb
HTTP_MINIFY3_URI="https://${HTTP_MINIFY3_EGO_PN}/archive/${HTTP_MINIFY3_EGIT_COMMIT}.tar.gz"
HTTP_MINIFY3_P="${HTTP_MINIFY3_EGO_PN//\//-}-${HTTP_MINIFY3_EGIT_COMMIT}"

# minify's dependency 4 (https://github.com/tdewolff/strconv, MIT license)
HTTP_MINIFY4_EGO_PN="github.com/tdewolff/strconv"
HTTP_MINIFY4_EGIT_COMMIT="3e8091f4417ebaaa3910da63a45ea394ebbfb0e3" #Version: 3e8091f
HTTP_MINIFY4_URI="https://${HTTP_MINIFY4_EGO_PN}/archive/${HTTP_MINIFY4_EGIT_COMMIT}.tar.gz"
HTTP_MINIFY4_P="${HTTP_MINIFY4_EGO_PN//\//-}-${HTTP_MINIFY4_EGIT_COMMIT}"

# upload (https://github.com/wmark/caddy.upload, BSD license)
HTTP_UPLOAD_EGO_PN="github.com/wmark/caddy.upload"
HTTP_UPLOAD_EGIT_COMMIT="fe91e5c4d5687e74e07fd0ce0a2230ce19951014" #Version: 1.2.1
HTTP_UPLOAD_URI="https://${HTTP_UPLOAD_EGO_PN}/archive/${HTTP_UPLOAD_EGIT_COMMIT}.tar.gz"
HTTP_UPLOAD_P="${HTTP_UPLOAD_EGO_PN//\//-}-${HTTP_UPLOAD_EGIT_COMMIT}"

# upload's dependency 1 (github.com/wmark/go.abs, ??? license)
HTTP_UPLOAD1_EGO_PN="github.com/wmark/go.abs"
HTTP_UPLOAD1_EGIT_COMMIT="1ba06a13d0c0530cb12338dd83254ececc6e509f" #Version: 1ba06a1
HTTP_UPLOAD1_URI="https://${HTTP_UPLOAD1_EGO_PN}/archive/${HTTP_UPLOAD1_EGIT_COMMIT}.tar.gz"
HTTP_UPLOAD1_P="${HTTP_UPLOAD1_EGO_PN//\//-}-${HTTP_UPLOAD1_EGIT_COMMIT}"

# upload's dependency 2 (https://github.com/pkg/errors, BSD-2 license)
HTTP_UPLOAD2_EGO_PN="github.com/pkg/errors"
HTTP_UPLOAD2_EGIT_COMMIT="c605e284fe17294bda444b34710735b29d1a9d90" #Version: c605e28
HTTP_UPLOAD2_URI="https://${HTTP_UPLOAD2_EGO_PN}/archive/${HTTP_UPLOAD2_EGIT_COMMIT}.tar.gz"
HTTP_UPLOAD2_P="${HTTP_UPLOAD2_EGO_PN//\//-}-${HTTP_UPLOAD2_EGIT_COMMIT}"

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/mholt/${PN}"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Fast, cross-platform HTTP/2 web server with automatic HTTPS"
HOMEPAGE="https://caddyserver.com"
SRC_URI="${ARCHIVE_URI}
	cors? ( ${HTTP_CORS_URI} -> ${HTTP_CORS_P}.tar.gz )
	expires? ( ${HTTP_EXPIRES_URI} -> ${HTTP_EXPIRES_P}.tar.gz )
	minify? (
		${HTTP_MINIFY_URI} -> ${HTTP_MINIFY_P}.tar.gz
		${HTTP_MINIFY1_URI} -> ${HTTP_MINIFY1_P}.tar.gz
		${HTTP_MINIFY2_URI} -> ${HTTP_MINIFY2_P}.tar.gz
		${HTTP_MINIFY3_URI} -> ${HTTP_MINIFY3_P}.tar.gz
		${HTTP_MINIFY4_URI} -> ${HTTP_MINIFY4_P}.tar.gz
	)
	upload? (
		${HTTP_UPLOAD_URI} -> ${HTTP_UPLOAD_P}.tar.gz
		${HTTP_UPLOAD1_URI} -> ${HTTP_UPLOAD1_P}.tar.gz
		${HTTP_UPLOAD2_URI} -> ${HTTP_UPLOAD2_P}.tar.gz
	)"

LICENSE="Apache-2.0 MIT BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cors expires minify upload"

DEPEND=">=dev-lang/go-1.8"
RDEPEND="sys-libs/libcap"

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_unpack() {
	use cors && EGO_VENDOR+=( "${HTTP_CORS_EGO_PN} ${HTTP_CORS_EGIT_COMMIT}" )
	use expires && EGO_VENDOR+=( "${HTTP_EXPIRES_EGO_PN} ${HTTP_EXPIRES_EGIT_COMMIT}" )

	if use minify; then
		EGO_VENDOR+=(
			"${HTTP_MINIFY_EGO_PN} ${HTTP_MINIFY_EGIT_COMMIT}"
			"${HTTP_MINIFY1_EGO_PN} ${HTTP_MINIFY1_EGIT_COMMIT}"
			"${HTTP_MINIFY2_EGO_PN} ${HTTP_MINIFY2_EGIT_COMMIT}"
			"${HTTP_MINIFY3_EGO_PN} ${HTTP_MINIFY3_EGIT_COMMIT}"
			"${HTTP_MINIFY4_EGO_PN} ${HTTP_MINIFY4_EGIT_COMMIT}"
		)
	fi

	if use upload; then
		EGO_VENDOR+=(
			"blitznote.com/src/caddy.upload ${HTTP_UPLOAD_EGIT_COMMIT} ${HTTP_UPLOAD_EGO_PN}"
			"plugin.hosting/go/abs ${HTTP_UPLOAD1_EGIT_COMMIT} ${HTTP_UPLOAD1_EGO_PN}"
			"${HTTP_UPLOAD2_EGO_PN} ${HTTP_UPLOAD2_EGIT_COMMIT}"
		)
	fi

	golang-vcs-snapshot_src_unpack
}

src_prepare() {
	if use cors; then
		sed -i -e "/caddymain/a import _ \"$HTTP_CORS_EGO_PN/caddy\"" \
			src/${EGO_PN}/caddy/caddymain/run.go || die
	fi

	if use expires; then
		sed -i -e "/caddymain/a import _ \"$HTTP_EXPIRES_EGO_PN\"" \
			src/${EGO_PN}/caddy/caddymain/run.go || die
	fi

	if use minify; then
		sed -i -e "/caddymain/a import _ \"$HTTP_MINIFY_EGO_PN\"" \
			src/${EGO_PN}/caddy/caddymain/run.go || die
	fi

	if use upload; then
		sed -i -e "/caddymain/a import _ \"blitznote.com/src/caddy.upload\"" \
			src/${EGO_PN}/caddy/caddymain/run.go || die
	fi

	eapply_user
}

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"
	cd src/${EGO_PN} || die

	go install -v -ldflags "-X ${EGO_PN}/caddy/caddymain.gitTag=${PV}" ./caddy || die
}

src_install() {
	dobin bin/caddy
	dodoc src/${EGO_PN}/{dist/CHANGES.txt,README.md}

	newinitd "${FILESDIR}"/caddy.initd-r1 caddy
	newconfd "${FILESDIR}"/caddy.confd-r1 caddy
	systemd_dounit "${FILESDIR}"/caddy.service

	keepdir /var/log/caddy
	fowners caddy:caddy /var/log/caddy

	keepdir /etc/caddy/ssl
	fperms 750 /etc/caddy/ssl
	fowners caddy:caddy /etc/caddy/ssl

	insinto /etc/caddy
	doins "${FILESDIR}"/Caddyfile.example

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/caddy.logrotate caddy
}

pkg_postinst() {
	# caddy currently does not support dropping privileges so we
	# change attributes with setcap to allow access to priv ports
	# https://caddyserver.com/docs/faq
	setcap "cap_net_bind_service=+ep" "${EROOT%/}"/usr/bin/caddy || die
}
