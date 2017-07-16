# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CADDY_PLUGINS=(
	"AUTHZ1 github.com/casbin/caddy-authz e0ddc63" # Apache-2.0 license
	"AUTHZ2 github.com/casbin/casbin 27a24f1" #v0.8.0 Apache-2.0 license
	"AUTHZ3 github.com/Knetic/govaluate ecff4ee" # MIT license

	"CGI github.com/jung-kurt/caddy-cgi 9bba460" #v1.4 MIT license
	"CORS github.com/captncraig/cors 153f484" # ??? license
	"EXPIRES github.com/epicagency/caddy-expires cb2ed46" #v1.0.0 MIT license
	"FILTER github.com/echocat/caddy-filter 4758934" #v0.6 MIT license
	"GIT github.com/abiosoft/caddy-git 39d2e56" # MIT license

	"GRPC1 github.com/pieterlouw/caddy-grpc 8f2a330" #v0.0.2 Apache-2.0 license
	"GRPC2 github.com/mwitkow/grpc-proxy 97396d9" # Apache-2.0 license
	"GRPC3 github.com/improbable-eng/grpc-web 298ec40" # Apache-2.0 license
	"GRPC4 github.com/rs/cors 8dd4211" #v1.1 MIT license
	"GRPC5 github.com/grpc/grpc-go b15215f" #v1.4.2 Apache-2.0 license
	"GRPC6 github.com/google/go-genproto b0a3dcf" # Apache-2.0 license
	"GRPC7 github.com/golang/net f01ecb6" # BSD license

	"IPFILTER1 github.com/pyed/ipfilter 6b25e48" # Apache-2.0 license
	"IPFILTER2 github.com/oschwald/maxminddb-golang d19f6d4" #1.2.0 ISC license

	"JWT1 github.com/BTBurke/caddy-jwt f575a64" #v2.4.0 MIT license
	"JWT2 github.com/dgrijalva/jwt-go a539ee1" # MIT license

	"LOGIN1 github.com/tarent/loginsrv 6adcd85" #v1.0.0 MIT license
	"LOGIN2 github.com/abbot/go-http-auth 0ddd408" #v0.4.0 Apache-2.0 license
	"LOGIN3 github.com/tarent/lib-compose f05f8e2" # MIT license
	"LOGIN4 github.com/tarent/logrus ba1b36c" #v0.11.5 MIT license
	"LOGIN5 github.com/golang/crypto dd85ac7" # BSD license

	"MAILOUT1 github.com/SchumacherFM/mailout ca5dbc9" #v1.1.1 Apache-2.0 license
	"MAILOUT2 github.com/juju/ratelimit 5b9ff86" # LGPL-3 license
	"MAILOUT3 github.com/go-gomail/gomail 81ebce5" #v2 MIT license

	"MINIFY1 github.com/hacdias/caddy-minify ebd59eb" # Apache-2.0 license
	"MINIFY2 github.com/tdewolff/minify 2d28d6e" # MIT license
	"MINIFY3 github.com/tdewolff/buffer df6253e" # MIT license
	"MINIFY4 github.com/tdewolff/parse e3d09bb" # MIT license
	"MINIFY5 github.com/tdewolff/strconv 3e8091f" # MIT license

	"PROMTHS1 github.com/miekg/caddy-prometheus dc74c64" # Apache-2.0 license
	"PROMTHS2 github.com/prometheus/client_golang 95b6848" # Apache-2.0 license
	"PROMTHS3 github.com/beorn7/perks 4c0e845" # MIT license
	"PROMTHS4 github.com/prometheus/client_model 6f38060" # Apache-2.0 license
	"PROMTHS5 github.com/prometheus/procfs e645f4e" # Apache-2.0 license
	"PROMTHS6 github.com/prometheus/common 3e6a763" # Apache-2.0 license
	"PROMTHS7 github.com/matttproud/golang_protobuf_extensions 3247c84" #v1.0.0 Apache-2.0 license

	"UPLOAD1 github.com/wmark/caddy.upload fe91e5c" #v1.2.1 BSD license
	"UPLOAD2 github.com/wmark/go.abs 1ba06a1" # ??? license
	"UPLOAD3 github.com/pkg/errors c605e28" # BSD-2 license
)

for CAP in "${CADDY_PLUGINS[@]}"; do
	CAP=(${CAP})
	readonly HTTP_${CAP[0]}_EGO_PN=${CAP[1]} HTTP_${CAP[0]}_COMMIT=${CAP[2]}
	readonly HTTP_${CAP[0]}_URI=https://${CAP[1]}/archive/${CAP[2]}.tar.gz
	readonly HTTP_${CAP[0]}_P=${CAP[1]//\//-}-${CAP[2]}
done

EGO_PN="github.com/mholt/${PN}"
CADDYMAIN="${EGO_PN}/caddy/caddymain"

inherit golang-vcs-snapshot systemd user

DESCRIPTION="Fast, cross-platform HTTP/2 web server with automatic HTTPS"
HOMEPAGE="https://caddyserver.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	authz? (
		${HTTP_AUTHZ1_URI} -> ${HTTP_AUTHZ1_P}.tar.gz
		${HTTP_AUTHZ2_URI} -> ${HTTP_AUTHZ2_P}.tar.gz
		${HTTP_AUTHZ3_URI} -> ${HTTP_AUTHZ3_P}.tar.gz
	)
	cgi? ( ${HTTP_CGI_URI} -> ${HTTP_CGI_P}.tar.gz )
	cors? ( ${HTTP_CORS_URI} -> ${HTTP_CORS_P}.tar.gz )
	expires? ( ${HTTP_EXPIRES_URI} -> ${HTTP_EXPIRES_P}.tar.gz )
	filter? ( ${HTTP_FILTER_URI} -> ${HTTP_FILTER_P}.tar.gz )
	git? ( ${HTTP_GIT_URI} -> ${HTTP_GIT_P}.tar.gz )
	grpc? (
		${HTTP_GRPC1_URI} -> ${HTTP_GRPC1_P}.tar.gz
		${HTTP_GRPC2_URI} -> ${HTTP_GRPC2_P}.tar.gz
		${HTTP_GRPC3_URI} -> ${HTTP_GRPC3_P}.tar.gz
		${HTTP_GRPC4_URI} -> ${HTTP_GRPC4_P}.tar.gz
		${HTTP_GRPC5_URI} -> ${HTTP_GRPC5_P}.tar.gz
		${HTTP_GRPC6_URI} -> ${HTTP_GRPC6_P}.tar.gz
		${HTTP_GRPC7_URI} -> ${HTTP_GRPC7_P}.tar.gz
	)
	ipfilter? (
		${HTTP_IPFILTER1_URI} -> ${HTTP_IPFILTER1_P}.tar.gz
		${HTTP_IPFILTER2_URI} -> ${HTTP_IPFILTER2_P}.tar.gz
	)
	jwt? (
		${HTTP_JWT1_URI} -> ${HTTP_JWT1_P}.tar.gz
		${HTTP_JWT2_URI} -> ${HTTP_JWT2_P}.tar.gz
	)
	login? (
		${HTTP_LOGIN1_URI} -> ${HTTP_LOGIN1_P}.tar.gz
		${HTTP_LOGIN2_URI} -> ${HTTP_LOGIN2_P}.tar.gz
		${HTTP_LOGIN3_URI} -> ${HTTP_LOGIN3_P}.tar.gz
		${HTTP_LOGIN4_URI} -> ${HTTP_LOGIN4_P}.tar.gz
		${HTTP_LOGIN5_URI} -> ${HTTP_LOGIN5_P}.tar.gz
	)
	mailout? (
		${HTTP_MAILOUT1_URI} -> ${HTTP_MAILOUT1_P}.tar.gz
		${HTTP_MAILOUT2_URI} -> ${HTTP_MAILOUT2_P}.tar.gz
		${HTTP_MAILOUT3_URI} -> ${HTTP_MAILOUT3_P}.tar.gz
		!login? ( ${HTTP_LOGIN5_URI} -> ${HTTP_LOGIN5_P}.tar.gz )
	)
	minify? (
		${HTTP_MINIFY1_URI} -> ${HTTP_MINIFY1_P}.tar.gz
		${HTTP_MINIFY2_URI} -> ${HTTP_MINIFY2_P}.tar.gz
		${HTTP_MINIFY3_URI} -> ${HTTP_MINIFY3_P}.tar.gz
		${HTTP_MINIFY4_URI} -> ${HTTP_MINIFY4_P}.tar.gz
		${HTTP_MINIFY5_URI} -> ${HTTP_MINIFY5_P}.tar.gz
	)
	prometheus? (
		${HTTP_PROMTHS1_URI} -> ${HTTP_PROMTHS1_P}.tar.gz
		${HTTP_PROMTHS2_URI} -> ${HTTP_PROMTHS2_P}.tar.gz
		${HTTP_PROMTHS3_URI} -> ${HTTP_PROMTHS3_P}.tar.gz
		${HTTP_PROMTHS4_URI} -> ${HTTP_PROMTHS4_P}.tar.gz
		${HTTP_PROMTHS5_URI} -> ${HTTP_PROMTHS5_P}.tar.gz
		${HTTP_PROMTHS6_URI} -> ${HTTP_PROMTHS6_P}.tar.gz
		${HTTP_PROMTHS7_URI} -> ${HTTP_PROMTHS7_P}.tar.gz
	)
	upload? (
		${HTTP_UPLOAD1_URI} -> ${HTTP_UPLOAD1_P}.tar.gz
		${HTTP_UPLOAD2_URI} -> ${HTTP_UPLOAD2_P}.tar.gz
		${HTTP_UPLOAD3_URI} -> ${HTTP_UPLOAD3_P}.tar.gz
	)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="authz cgi cors expires filter git grpc ipfilter jwt login mailout minify prometheus upload"

RDEPEND="sys-libs/libcap"
REQUIRED_USE="login? ( jwt )"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_unpack() {
	use authz && \
		EGO_VENDOR+=(
			"${HTTP_AUTHZ1_EGO_PN} ${HTTP_AUTHZ1_COMMIT}"
			"${HTTP_AUTHZ2_EGO_PN} ${HTTP_AUTHZ2_COMMIT}"
			"${HTTP_AUTHZ3_EGO_PN} ${HTTP_AUTHZ3_COMMIT}"
		)

	use cgi && EGO_VENDOR+=( "${HTTP_CGI_EGO_PN} ${HTTP_CGI_COMMIT}" )
	use cors && EGO_VENDOR+=( "${HTTP_CORS_EGO_PN} ${HTTP_CORS_COMMIT}" )
	use expires && EGO_VENDOR+=( "${HTTP_EXPIRES_EGO_PN} ${HTTP_EXPIRES_COMMIT}" )
	use filter && EGO_VENDOR+=( "${HTTP_FILTER_EGO_PN} ${HTTP_FILTER_COMMIT}" )
	use git && EGO_VENDOR+=( "${HTTP_GIT_EGO_PN} ${HTTP_GIT_COMMIT}" )

	use grpc && \
		EGO_VENDOR+=(
			"${HTTP_GRPC1_EGO_PN} ${HTTP_GRPC1_COMMIT}"
			"${HTTP_GRPC2_EGO_PN} ${HTTP_GRPC2_COMMIT}"
			"${HTTP_GRPC3_EGO_PN} ${HTTP_GRPC3_COMMIT}"
			"${HTTP_GRPC4_EGO_PN} ${HTTP_GRPC4_COMMIT}"
			"google.golang.org/grpc ${HTTP_GRPC5_COMMIT} ${HTTP_GRPC5_EGO_PN}"
			"google.golang.org/genproto ${HTTP_GRPC6_COMMIT} ${HTTP_GRP6_EGO_PN}"
			"golang.org/x/net ${HTTP_GRPC7_COMMIT} ${HTTP_GRPC7_EGO_PN}"
		)

	use ipfilter && \
		EGO_VENDOR+=(
			"${HTTP_IPFILTER1_EGO_PN} ${HTTP_IPFILTER1_COMMIT}"
			"${HTTP_IPFILTER2_EGO_PN} ${HTTP_IPFILTER2_COMMIT}"
		)

	use jwt && \
		EGO_VENDOR+=(
			"${HTTP_JWT1_EGO_PN} ${HTTP_JWT1_COMMIT}"
			"${HTTP_JWT2_EGO_PN} ${HTTP_JWT2_COMMIT}"
		)

	use login && \
		EGO_VENDOR+=(
			"${HTTP_LOGIN1_EGO_PN} ${HTTP_LOGIN1_COMMIT}"
			"${HTTP_LOGIN2_EGO_PN} ${HTTP_LOGIN2_COMMIT}"
			"${HTTP_LOGIN3_EGO_PN} ${HTTP_LOGIN3_COMMIT}"
			"${HTTP_LOGIN4_EGO_PN} ${HTTP_LOGIN4_COMMIT}"
			"golang.org/x/crypto ${HTTP_LOGIN5_COMMIT} ${HTTP_LOGIN5_EGO_PN}"
		)

	if use mailout; then
		EGO_VENDOR+=(
			"${HTTP_MAILOUT1_EGO_PN} ${HTTP_MAILOUT1_COMMIT}"
			"${HTTP_MAILOUT2_EGO_PN} ${HTTP_MAILOUT2_COMMIT}"
			"gopkg.in/gomail.v2 ${HTTP_MAILOUT3_COMMIT} ${HTTP_MAILOUT3_EGO_PN}"
		)
		use login || \
			EGO_VENDOR+=( "golang.org/x/crypto ${HTTP_LOGIN5_COMMIT} ${HTTP_LOGIN5_EGO_PN}" )
	fi

	use minify && \
		EGO_VENDOR+=(
			"${HTTP_MINIFY1_EGO_PN} ${HTTP_MINIFY1_COMMIT}"
			"${HTTP_MINIFY2_EGO_PN} ${HTTP_MINIFY2_COMMIT}"
			"${HTTP_MINIFY3_EGO_PN} ${HTTP_MINIFY3_COMMIT}"
			"${HTTP_MINIFY4_EGO_PN} ${HTTP_MINIFY4_COMMIT}"
			"${HTTP_MINIFY5_EGO_PN} ${HTTP_MINIFY5_COMMIT}"
		)

	use prometheus && \
		EGO_VENDOR+=(
			"${HTTP_PROMTHS1_EGO_PN} ${HTTP_PROMTHS1_COMMIT}"
			"${HTTP_PROMTHS2_EGO_PN} ${HTTP_PROMTHS2_COMMIT}"
			"${HTTP_PROMTHS3_EGO_PN} ${HTTP_PROMTHS3_COMMIT}"
			"${HTTP_PROMTHS4_EGO_PN} ${HTTP_PROMTHS4_COMMIT}"
			"${HTTP_PROMTHS5_EGO_PN} ${HTTP_PROMTHS5_COMMIT}"
			"${HTTP_PROMTHS6_EGO_PN} ${HTTP_PROMTHS6_COMMIT}"
			"${HTTP_PROMTHS7_EGO_PN} ${HTTP_PROMTHS7_COMMIT}"
		)

	use upload && \
		EGO_VENDOR+=(
			"blitznote.com/src/caddy.upload ${HTTP_UPLOAD1_COMMIT} ${HTTP_UPLOAD1_EGO_PN}"
			"plugin.hosting/go/abs ${HTTP_UPLOAD2_COMMIT} ${HTTP_UPLOAD2_EGO_PN}"
			"${HTTP_UPLOAD3_EGO_PN} ${HTTP_UPLOAD3_COMMIT}"
		)

	golang-vcs-snapshot_src_unpack
}

src_prepare() {
	if use authz; then
		sed -i "/caddymain/a import _ \"$HTTP_AUTHZ1_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use cgi; then
		sed -i "/caddymain/a import _ \"$HTTP_CGI_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use cors; then
		sed -i "/caddymain/a import _ \"$HTTP_CORS_EGO_PN/caddy\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use expires; then
		sed -i "/caddymain/a import _ \"$HTTP_EXPIRES_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use filter; then
		sed -i "/caddymain/a import _ \"$HTTP_FILTER_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use git; then
		sed -i "/caddymain/a import _ \"$HTTP_GIT_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use grpc; then
		sed -i "/caddymain/a import _ \"$HTTP_GRPC1_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use ipfilter; then
		sed -i "/caddymain/a import _ \"$HTTP_IPFILTER1_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use jwt; then
		sed -i "/caddymain/a import _ \"$HTTP_JWT1_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use login; then
		sed -i "/caddymain/a import _ \"$HTTP_LOGIN1_EGO_PN/caddy\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use mailout; then
		sed -i "/caddymain/a import _ \"$HTTP_MAILOUT1_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use minify; then
		sed -i "/caddymain/a import _ \"$HTTP_MINIFY1_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use prometheus; then
		sed -i "/caddymain/a import _ \"$HTTP_PROMTHS1_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use upload; then
		sed -i '/caddymain/a import _ "blitznote.com/src/caddy.upload"' \
			src/${CADDYMAIN}/run.go || die
	fi

	eapply_user
}

src_compile() {
	GOPATH="${S}" go install -v -ldflags \
		"-X ${CADDYMAIN}.gitTag=${PV}" ${EGO_PN}/caddy || die
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
