# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# authz (https://github.com/casbin/caddy-authz, Apache-2.0 license)
HTTP_AUTHZ_EGO_PN="github.com/casbin/caddy-authz"
HTTP_AUTHZ_COMMIT="e0ddc63"
HTTP_AUTHZ_URI="https://${HTTP_AUTHZ_EGO_PN}/archive/${HTTP_AUTHZ_COMMIT}.tar.gz"
HTTP_AUTHZ_P="${HTTP_AUTHZ_EGO_PN//\//-}-${HTTP_AUTHZ_COMMIT}"

# authz: dep 1 (https://github.com/casbin/casbin, Apache-2.0 license)
HTTP_AUTHZ1_EGO_PN="github.com/casbin/casbin"
HTTP_AUTHZ1_COMMIT="27a24f1" #v0.8.0
HTTP_AUTHZ1_URI="https://${HTTP_AUTHZ1_EGO_PN}/archive/${HTTP_AUTHZ1_COMMIT}.tar.gz"
HTTP_AUTHZ1_P="${HTTP_AUTHZ1_EGO_PN//\//-}-${HTTP_AUTHZ1_COMMIT}"

# authz: dep 2 (https://github.com/Knetic/govaluate, MIT license)
HTTP_AUTHZ2_EGO_PN="github.com/Knetic/govaluate"
HTTP_AUTHZ2_COMMIT="ecff4ee"
HTTP_AUTHZ2_URI="https://${HTTP_AUTHZ2_EGO_PN}/archive/${HTTP_AUTHZ2_COMMIT}.tar.gz"
HTTP_AUTHZ2_P="${HTTP_AUTHZ2_EGO_PN//\//-}-${HTTP_AUTHZ2_COMMIT}"

# cgi (https://github.com/jung-kurt/caddy-cgi, MIT license)
HTTP_CGI_EGO_PN="github.com/jung-kurt/caddy-cgi"
HTTP_CGI_COMMIT="9bba460" #v1.4
HTTP_CGI_URI="https://${HTTP_CGI_EGO_PN}/archive/${HTTP_CGI_COMMIT}.tar.gz"
HTTP_CGI_P="${HTTP_CGI_EGO_PN//\//-}-${HTTP_CGI_COMMIT}"

# cors (https://github.com/captncraig/cors, ??? license)
HTTP_CORS_EGO_PN="github.com/captncraig/cors"
HTTP_CORS_COMMIT="153f484"
HTTP_CORS_URI="https://${HTTP_CORS_EGO_PN}/archive/${HTTP_CORS_COMMIT}.tar.gz"
HTTP_CORS_P="${HTTP_CORS_EGO_PN//\//-}-${HTTP_CORS_COMMIT}"

# expires (https://github.com/epicagency/caddy-expires, MIT license)
HTTP_EXPIRES_EGO_PN="github.com/epicagency/caddy-expires"
HTTP_EXPIRES_COMMIT="cb2ed46" #v1.0.0
HTTP_EXPIRES_URI="https://${HTTP_EXPIRES_EGO_PN}/archive/${HTTP_EXPIRES_COMMIT}.tar.gz"
HTTP_EXPIRES_P="${HTTP_EXPIRES_EGO_PN//\//-}-${HTTP_EXPIRES_COMMIT}"

# filter (https://github.com/echocat/caddy-filter, MIT license)
HTTP_FILTER_EGO_PN="github.com/echocat/caddy-filter"
HTTP_FILTER_COMMIT="4758934" #v0.6
HTTP_FILTER_URI="https://${HTTP_FILTER_EGO_PN}/archive/${HTTP_FILTER_COMMIT}.tar.gz"
HTTP_FILTER_P="${HTTP_FILTER_EGO_PN//\//-}-${HTTP_FILTER_COMMIT}"

# git (https://github.com/abiosoft/caddy-git, MIT license)
HTTP_GIT_EGO_PN="github.com/abiosoft/caddy-git"
HTTP_GIT_COMMIT="39d2e56"
HTTP_GIT_URI="https://${HTTP_GIT_EGO_PN}/archive/${HTTP_GIT_COMMIT}.tar.gz"
HTTP_GIT_P="${HTTP_GIT_EGO_PN//\//-}-${HTTP_GIT_COMMIT}"

# grpc (https://github.com/pieterlouw/caddy-grpc, Apache-2.0 license)
HTTP_GRPC_EGO_PN="github.com/pieterlouw/caddy-grpc"
HTTP_GRPC_COMMIT="8f2a330" #v0.0.2
HTTP_GRPC_URI="https://${HTTP_GRPC_EGO_PN}/archive/${HTTP_GRPC_COMMIT}.tar.gz"
HTTP_GRPC_P="${HTTP_GRPC_EGO_PN//\//-}-${HTTP_GRPC_COMMIT}"

# grpc: dep 1 (https://github.com/mwitkow/grpc-proxy, Apache-2.0 license)
HTTP_GRPC1_EGO_PN="github.com/mwitkow/grpc-proxy"
HTTP_GRPC1_COMMIT="97396d9"
HTTP_GRPC1_URI="https://${HTTP_GRPC1_EGO_PN}/archive/${HTTP_GRPC1_COMMIT}.tar.gz"
HTTP_GRPC1_P="${HTTP_GRPC1_EGO_PN//\//-}-${HTTP_GRPC1_COMMIT}"

# grpc: dep 2 (https://github.com/improbable-eng/grpc-web, Apache-2.0 license)
HTTP_GRPC2_EGO_PN="github.com/improbable-eng/grpc-web"
HTTP_GRPC2_COMMIT="298ec40"
HTTP_GRPC2_URI="https://${HTTP_GRPC2_EGO_PN}/archive/${HTTP_GRPC2_COMMIT}.tar.gz"
HTTP_GRPC2_P="${HTTP_GRPC2_EGO_PN//\//-}-${HTTP_GRPC2_COMMIT}"

# grpc: dep 3 (https://github.com/rs/cors, MIT license)
# pulled by github.com/improbable-eng/grpc-web
HTTP_GRPC3_EGO_PN="github.com/rs/cors"
HTTP_GRPC3_COMMIT="8dd4211" #v1.1
HTTP_GRPC3_URI="https://${HTTP_GRPC3_EGO_PN}/archive/${HTTP_GRPC3_COMMIT}.tar.gz"
HTTP_GRPC3_P="${HTTP_GRPC3_EGO_PN//\//-}-${HTTP_GRPC3_COMMIT}"

# grpc: dep 4 (https://github.com/grpc/grpc-go, Apache-2.0 license)
HTTP_GRPC4_EGO_PN="github.com/grpc/grpc-go"
HTTP_GRPC4_COMMIT="b15215f" #v1.4.2
HTTP_GRPC4_URI="https://${HTTP_GRPC4_EGO_PN}/archive/${HTTP_GRPC4_COMMIT}.tar.gz"
HTTP_GRPC4_P="${HTTP_GRPC4_EGO_PN//\//-}-${HTTP_GRPC4_COMMIT}"

# grpc: dep 5 (https://github.com/google/go-genproto, Apache-2.0 license)
# pulled by github.com/grpc/grpc-go
HTTP_GRPC5_EGO_PN="github.com/google/go-genproto"
HTTP_GRPC5_COMMIT="b0a3dcf"
HTTP_GRPC5_URI="https://${HTTP_GRPC5_EGO_PN}/archive/${HTTP_GRPC5_COMMIT}.tar.gz"
HTTP_GRPC5_P="${HTTP_GRPC5_EGO_PN//\//-}-${HTTP_GRPC5_COMMIT}"

# grpc: dep 6 (https://github.com/golang/net, BSD license)
# pulled by github.com/grpc/grpc-go
HTTP_GRPC6_EGO_PN="github.com/golang/net"
HTTP_GRPC6_COMMIT="f01ecb6"
HTTP_GRPC6_URI="https://${HTTP_GRPC6_EGO_PN}/archive/${HTTP_GRPC6_COMMIT}.tar.gz"
HTTP_GRPC6_P="${HTTP_GRPC6_EGO_PN//\//-}-${HTTP_GRPC6_COMMIT}"

# ipfilter (https://github.com/pyed/ipfilter, Apache-2.0 license)
HTTP_IPFILTER_EGO_PN="github.com/pyed/ipfilter"
HTTP_IPFILTER_COMMIT="6b25e48"
HTTP_IPFILTER_URI="https://${HTTP_IPFILTER_EGO_PN}/archive/${HTTP_IPFILTER_COMMIT}.tar.gz"
HTTP_IPFILTER_P="${HTTP_IPFILTER_EGO_PN//\//-}-${HTTP_IPFILTER_COMMIT}"

# ipfilter: dep 1 (https://github.com/oschwald/maxminddb-golang, ISC license)
HTTP_IPFILTER1_EGO_PN="github.com/oschwald/maxminddb-golang"
HTTP_IPFILTER1_COMMIT="d19f6d4" #v1.2.0
HTTP_IPFILTER1_URI="https://${HTTP_IPFILTER1_EGO_PN}/archive/${HTTP_IPFILTER1_COMMIT}.tar.gz"
HTTP_IPFILTER1_P="${HTTP_IPFILTER1_EGO_PN//\//-}-${HTTP_IPFILTER1_COMMIT}"

# jwt (https://github.com/BTBurke/caddy-jwt, MIT license)
HTTP_JWT_EGO_PN="github.com/BTBurke/caddy-jwt"
HTTP_JWT_COMMIT="f575a64" #v2.4.0
HTTP_JWT_URI="https://${HTTP_JWT_EGO_PN}/archive/${HTTP_JWT_COMMIT}.tar.gz"
HTTP_JWT_P="${HTTP_JWT_EGO_PN//\//-}-${HTTP_JWT_COMMIT}"

# jwt: dep 1 (https://github.com/dgrijalva/jwt-go, MIT license)
HTTP_JWT1_EGO_PN="github.com/dgrijalva/jwt-go"
HTTP_JWT1_COMMIT="a539ee1"
HTTP_JWT1_URI="https://${HTTP_JWT1_EGO_PN}/archive/${HTTP_JWT1_COMMIT}.tar.gz"
HTTP_JWT1_P="${HTTP_JWT1_EGO_PN//\//-}-${HTTP_JWT1_COMMIT}"

# login (https://github.com/tarent/loginsrv, MIT license)
HTTP_LOGIN_EGO_PN="github.com/tarent/loginsrv"
HTTP_LOGIN_COMMIT="6adcd85" #v1.0.0
HTTP_LOGIN_URI="https://${HTTP_LOGIN_EGO_PN}/archive/${HTTP_LOGIN_COMMIT}.tar.gz"
HTTP_LOGIN_P="${HTTP_LOGIN_EGO_PN//\//-}-${HTTP_LOGIN_COMMIT}"

# login: dep 1 (https://github.com/abbot/go-http-auth, Apache-2.0 license)
HTTP_LOGIN1_EGO_PN="github.com/abbot/go-http-auth"
HTTP_LOGIN1_COMMIT="0ddd408" #v0.4.0
HTTP_LOGIN1_URI="https://${HTTP_LOGIN1_EGO_PN}/archive/${HTTP_LOGIN1_COMMIT}.tar.gz"
HTTP_LOGIN1_P="${HTTP_LOGIN1_EGO_PN//\//-}-${HTTP_LOGIN1_COMMIT}"

# login: dep 2 (https://github.com/tarent/lib-compose, MIT license)
HTTP_LOGIN2_EGO_PN="github.com/tarent/lib-compose"
HTTP_LOGIN2_COMMIT="f05f8e2"
HTTP_LOGIN2_URI="https://${HTTP_LOGIN2_EGO_PN}/archive/${HTTP_LOGIN2_COMMIT}.tar.gz"
HTTP_LOGIN2_P="${HTTP_LOGIN2_EGO_PN//\//-}-${HTTP_LOGIN2_COMMIT}"

# login: dep 3 (https://github.com/tarent/logrus, MIT license)
HTTP_LOGIN3_EGO_PN="github.com/tarent/logrus"
HTTP_LOGIN3_COMMIT="ba1b36c" #v0.11.5
HTTP_LOGIN3_URI="https://${HTTP_LOGIN3_EGO_PN}/archive/${HTTP_LOGIN3_COMMIT}.tar.gz"
HTTP_LOGIN3_P="${HTTP_LOGIN3_EGO_PN//\//-}-${HTTP_LOGIN3_COMMIT}"

# login: dep 4 (https://github.com/golang/crypto, BSD license)
HTTP_LOGIN4_EGO_PN="github.com/golang/crypto"
HTTP_LOGIN4_COMMIT="dd85ac7"
HTTP_LOGIN4_URI="https://${HTTP_LOGIN4_EGO_PN}/archive/${HTTP_LOGIN4_COMMIT}.tar.gz"
HTTP_LOGIN4_P="${HTTP_LOGIN4_EGO_PN//\//-}-${HTTP_LOGIN4_COMMIT}"

# mailout (https://github.com/SchumacherFM/mailout, Apache-2.0 license)
HTTP_MAILOUT_EGO_PN="github.com/SchumacherFM/mailout"
HTTP_MAILOUT_COMMIT="ca5dbc9" #v1.1.1
HTTP_MAILOUT_URI="https://${HTTP_MAILOUT_EGO_PN}/archive/${HTTP_MAILOUT_COMMIT}.tar.gz"
HTTP_MAILOUT_P="${HTTP_MAILOUT_EGO_PN//\//-}-${HTTP_MAILOUT_COMMIT}"

# mailout: dep 1 (https://github.com/juju/ratelimit, LGPL-3 license)
HTTP_MAILOUT1_EGO_PN="github.com/juju/ratelimit"
HTTP_MAILOUT1_COMMIT="5b9ff86"
HTTP_MAILOUT1_URI="https://${HTTP_MAILOUT1_EGO_PN}/archive/${HTTP_MAILOUT1_COMMIT}.tar.gz"
HTTP_MAILOUT1_P="${HTTP_MAILOUT1_EGO_PN//\//-}-${HTTP_MAILOUT1_COMMIT}"

# mailout: dep 2 (https://github.com/go-gomail/gomail, MIT license)
HTTP_MAILOUT2_EGO_PN="github.com/go-gomail/gomail"
HTTP_MAILOUT2_COMMIT="81ebce5" #v2
HTTP_MAILOUT2_URI="https://${HTTP_MAILOUT2_EGO_PN}/archive/${HTTP_MAILOUT2_COMMIT}.tar.gz"
HTTP_MAILOUT2_P="${HTTP_MAILOUT2_EGO_PN//\//-}-${HTTP_MAILOUT2_COMMIT}"

# minify (https://github.com/hacdias/caddy-minify, Apache-2.0 license)
HTTP_MINIFY_EGO_PN="github.com/hacdias/caddy-minify"
HTTP_MINIFY_COMMIT="ebd59eb"
HTTP_MINIFY_URI="https://${HTTP_MINIFY_EGO_PN}/archive/${HTTP_MINIFY_COMMIT}.tar.gz"
HTTP_MINIFY_P="${HTTP_MINIFY_EGO_PN//\//-}-${HTTP_MINIFY_COMMIT}"

# minify: dep 1 (https://github.com/tdewolff/minify, MIT license)
HTTP_MINIFY1_EGO_PN="github.com/tdewolff/minify"
HTTP_MINIFY1_COMMIT="2d28d6e"
HTTP_MINIFY1_URI="https://${HTTP_MINIFY1_EGO_PN}/archive/${HTTP_MINIFY1_COMMIT}.tar.gz"
HTTP_MINIFY1_P="${HTTP_MINIFY1_EGO_PN//\//-}-${HTTP_MINIFY1_COMMIT}"

# minify: dep 2 (https://github.com/tdewolff/buffer, MIT license)
HTTP_MINIFY2_EGO_PN="github.com/tdewolff/buffer"
HTTP_MINIFY2_COMMIT="df6253e"
HTTP_MINIFY2_URI="https://${HTTP_MINIFY2_EGO_PN}/archive/${HTTP_MINIFY2_COMMIT}.tar.gz"
HTTP_MINIFY2_P="${HTTP_MINIFY2_EGO_PN//\//-}-${HTTP_MINIFY2_COMMIT}"

# minify: dep 3 (https://github.com/tdewolff/parse, MIT license)
HTTP_MINIFY3_EGO_PN="github.com/tdewolff/parse"
HTTP_MINIFY3_COMMIT="e3d09bb"
HTTP_MINIFY3_URI="https://${HTTP_MINIFY3_EGO_PN}/archive/${HTTP_MINIFY3_COMMIT}.tar.gz"
HTTP_MINIFY3_P="${HTTP_MINIFY3_EGO_PN//\//-}-${HTTP_MINIFY3_COMMIT}"

# minify: dep 4 (https://github.com/tdewolff/strconv, MIT license)
HTTP_MINIFY4_EGO_PN="github.com/tdewolff/strconv"
HTTP_MINIFY4_COMMIT="3e8091f"
HTTP_MINIFY4_URI="https://${HTTP_MINIFY4_EGO_PN}/archive/${HTTP_MINIFY4_COMMIT}.tar.gz"
HTTP_MINIFY4_P="${HTTP_MINIFY4_EGO_PN//\//-}-${HTTP_MINIFY4_COMMIT}"

# prometheus (https://github.com/miekg/caddy-prometheus, Apache-2.0 license)
HTTP_PROMTHS_EGO_PN="github.com/miekg/caddy-prometheus"
HTTP_PROMTHS_COMMIT="dc74c64"
HTTP_PROMTHS_URI="https://${HTTP_PROMTHS_EGO_PN}/archive/${HTTP_PROMTHS_COMMIT}.tar.gz"
HTTP_PROMTHS_P="${HTTP_PROMTHS_EGO_PN//\//-}-${HTTP_PROMTHS_COMMIT}"

# prometheus: dep 1 (https://github.com/prometheus/client_golang, Apache-2.0 license)
HTTP_PROMTHS1_EGO_PN="github.com/prometheus/client_golang"
HTTP_PROMTHS1_COMMIT="95b6848"
HTTP_PROMTHS1_URI="https://${HTTP_PROMTHS1_EGO_PN}/archive/${HTTP_PROMTHS1_COMMIT}.tar.gz"
HTTP_PROMTHS1_P="${HTTP_PROMTHS1_EGO_PN//\//-}-${HTTP_PROMTHS1_COMMIT}"

# prometheus: dep 2 (https://github.com/beorn7/perks, MIT license)
# pulled by github.com/prometheus/client_golang
HTTP_PROMTHS2_EGO_PN="github.com/beorn7/perks"
HTTP_PROMTHS2_COMMIT="4c0e845"
HTTP_PROMTHS2_URI="https://${HTTP_PROMTHS2_EGO_PN}/archive/${HTTP_PROMTHS2_COMMIT}.tar.gz"
HTTP_PROMTHS2_P="${HTTP_PROMTHS2_EGO_PN//\//-}-${HTTP_PROMTHS2_COMMIT}"

# prometheus: dep 3 (https://github.com/prometheus/client_model, Apache-2.0 license)
# pulled by github.com/prometheus/client_golang
HTTP_PROMTHS3_EGO_PN="github.com/prometheus/client_model"
HTTP_PROMTHS3_COMMIT="6f38060"
HTTP_PROMTHS3_URI="https://${HTTP_PROMTHS3_EGO_PN}/archive/${HTTP_PROMTHS3_COMMIT}.tar.gz"
HTTP_PROMTHS3_P="${HTTP_PROMTHS3_EGO_PN//\//-}-${HTTP_PROMTHS3_COMMIT}"

# prometheus: dep 4 (https://github.com/prometheus/procfs, Apache-2.0 license)
# pulled by github.com/prometheus/client_golang
HTTP_PROMTHS4_EGO_PN="github.com/prometheus/procfs"
HTTP_PROMTHS4_COMMIT="e645f4e"
HTTP_PROMTHS4_URI="https://${HTTP_PROMTHS4_EGO_PN}/archive/${HTTP_PROMTHS4_COMMIT}.tar.gz"
HTTP_PROMTHS4_P="${HTTP_PROMTHS4_EGO_PN//\//-}-${HTTP_PROMTHS4_COMMIT}"

# prometheus: dep 5 (https://github.com/prometheus/common, Apache-2.0 license)
# pulled by github.com/prometheus/client_golang
HTTP_PROMTHS5_EGO_PN="github.com/prometheus/common"
HTTP_PROMTHS5_COMMIT="3e6a763"
HTTP_PROMTHS5_URI="https://${HTTP_PROMTHS5_EGO_PN}/archive/${HTTP_PROMTHS5_COMMIT}.tar.gz"
HTTP_PROMTHS5_P="${HTTP_PROMTHS5_EGO_PN//\//-}-${HTTP_PROMTHS5_COMMIT}"

# prometheus: dep 6 (https://github.com/matttproud/golang_protobuf_extensions, Apache-2.0 license)
# pulled by github.com/prometheus/common
HTTP_PROMTHS6_EGO_PN="github.com/matttproud/golang_protobuf_extensions"
HTTP_PROMTHS6_COMMIT="3247c84" #v1.0.0
HTTP_PROMTHS6_URI="https://${HTTP_PROMTHS6_EGO_PN}/archive/${HTTP_PROMTHS6_COMMIT}.tar.gz"
HTTP_PROMTHS6_P="${HTTP_PROMTHS6_EGO_PN//\//-}-${HTTP_PROMTHS6_COMMIT}"

# upload (https://github.com/wmark/caddy.upload, BSD license)
HTTP_UPLOAD_EGO_PN="github.com/wmark/caddy.upload"
HTTP_UPLOAD_COMMIT="fe91e5c" #v1.2.1
HTTP_UPLOAD_URI="https://${HTTP_UPLOAD_EGO_PN}/archive/${HTTP_UPLOAD_COMMIT}.tar.gz"
HTTP_UPLOAD_P="${HTTP_UPLOAD_EGO_PN//\//-}-${HTTP_UPLOAD_COMMIT}"

# upload: dep 1 (https://github.com/wmark/go.abs, ??? license)
HTTP_UPLOAD1_EGO_PN="github.com/wmark/go.abs"
HTTP_UPLOAD1_COMMIT="1ba06a1"
HTTP_UPLOAD1_URI="https://${HTTP_UPLOAD1_EGO_PN}/archive/${HTTP_UPLOAD1_COMMIT}.tar.gz"
HTTP_UPLOAD1_P="${HTTP_UPLOAD1_EGO_PN//\//-}-${HTTP_UPLOAD1_COMMIT}"

# upload: dep 2 (https://github.com/pkg/errors, BSD-2 license)
HTTP_UPLOAD2_EGO_PN="github.com/pkg/errors"
HTTP_UPLOAD2_COMMIT="c605e28"
HTTP_UPLOAD2_URI="https://${HTTP_UPLOAD2_EGO_PN}/archive/${HTTP_UPLOAD2_COMMIT}.tar.gz"
HTTP_UPLOAD2_P="${HTTP_UPLOAD2_EGO_PN//\//-}-${HTTP_UPLOAD2_COMMIT}"

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/mholt/${PN}"
CADDYMAIN="${EGO_PN}/caddy/caddymain"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Fast, cross-platform HTTP/2 web server with automatic HTTPS"
HOMEPAGE="https://caddyserver.com"
SRC_URI="${ARCHIVE_URI}
	authz? (
		${HTTP_AUTHZ_URI} -> ${HTTP_AUTHZ_P}.tar.gz
		${HTTP_AUTHZ1_URI} -> ${HTTP_AUTHZ1_P}.tar.gz
		${HTTP_AUTHZ2_URI} -> ${HTTP_AUTHZ2_P}.tar.gz
	)
	cgi? ( ${HTTP_CGI_URI} -> ${HTTP_CGI_P}.tar.gz )
	cors? ( ${HTTP_CORS_URI} -> ${HTTP_CORS_P}.tar.gz )
	expires? ( ${HTTP_EXPIRES_URI} -> ${HTTP_EXPIRES_P}.tar.gz )
	filter? ( ${HTTP_FILTER_URI} -> ${HTTP_FILTER_P}.tar.gz )
	git? ( ${HTTP_GIT_URI} -> ${HTTP_GIT_P}.tar.gz )
	grpc? (
		${HTTP_GRPC_URI} -> ${HTTP_GRPC_P}.tar.gz
		${HTTP_GRPC1_URI} -> ${HTTP_GRPC1_P}.tar.gz
		${HTTP_GRPC2_URI} -> ${HTTP_GRPC2_P}.tar.gz
		${HTTP_GRPC3_URI} -> ${HTTP_GRPC3_P}.tar.gz
		${HTTP_GRPC4_URI} -> ${HTTP_GRPC4_P}.tar.gz
		${HTTP_GRPC5_URI} -> ${HTTP_GRPC5_P}.tar.gz
		${HTTP_GRPC6_URI} -> ${HTTP_GRPC6_P}.tar.gz
	)
	ipfilter? (
		${HTTP_IPFILTER_URI} -> ${HTTP_IPFILTER_P}.tar.gz
		${HTTP_IPFILTER1_URI} -> ${HTTP_IPFILTER1_P}.tar.gz
	)
	jwt? (
		${HTTP_JWT_URI} -> ${HTTP_JWT_P}.tar.gz
		${HTTP_JWT1_URI} -> ${HTTP_JWT1_P}.tar.gz
	)
	login? (
		${HTTP_LOGIN_URI} -> ${HTTP_LOGIN_P}.tar.gz
		${HTTP_LOGIN1_URI} -> ${HTTP_LOGIN1_P}.tar.gz
		${HTTP_LOGIN2_URI} -> ${HTTP_LOGIN2_P}.tar.gz
		${HTTP_LOGIN3_URI} -> ${HTTP_LOGIN3_P}.tar.gz
		${HTTP_LOGIN4_URI} -> ${HTTP_LOGIN4_P}.tar.gz
	)
	mailout? (
		${HTTP_MAILOUT_URI} -> ${HTTP_MAILOUT_P}.tar.gz
		${HTTP_MAILOUT1_URI} -> ${HTTP_MAILOUT1_P}.tar.gz
		${HTTP_MAILOUT2_URI} -> ${HTTP_MAILOUT2_P}.tar.gz
		!login? ( ${HTTP_LOGIN4_URI} -> ${HTTP_LOGIN4_P}.tar.gz )
	)
	minify? (
		${HTTP_MINIFY_URI} -> ${HTTP_MINIFY_P}.tar.gz
		${HTTP_MINIFY1_URI} -> ${HTTP_MINIFY1_P}.tar.gz
		${HTTP_MINIFY2_URI} -> ${HTTP_MINIFY2_P}.tar.gz
		${HTTP_MINIFY3_URI} -> ${HTTP_MINIFY3_P}.tar.gz
		${HTTP_MINIFY4_URI} -> ${HTTP_MINIFY4_P}.tar.gz
	)
	prometheus? (
		${HTTP_PROMTHS_URI} -> ${HTTP_PROMTHS_P}.tar.gz
		${HTTP_PROMTHS1_URI} -> ${HTTP_PROMTHS1_P}.tar.gz
		${HTTP_PROMTHS2_URI} -> ${HTTP_PROMTHS2_P}.tar.gz
		${HTTP_PROMTHS3_URI} -> ${HTTP_PROMTHS3_P}.tar.gz
		${HTTP_PROMTHS4_URI} -> ${HTTP_PROMTHS4_P}.tar.gz
		${HTTP_PROMTHS5_URI} -> ${HTTP_PROMTHS5_P}.tar.gz
		${HTTP_PROMTHS6_URI} -> ${HTTP_PROMTHS6_P}.tar.gz
	)
	upload? (
		${HTTP_UPLOAD_URI} -> ${HTTP_UPLOAD_P}.tar.gz
		${HTTP_UPLOAD1_URI} -> ${HTTP_UPLOAD1_P}.tar.gz
		${HTTP_UPLOAD2_URI} -> ${HTTP_UPLOAD2_P}.tar.gz
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
			"${HTTP_AUTHZ_EGO_PN} ${HTTP_AUTHZ_COMMIT}"
			"${HTTP_AUTHZ1_EGO_PN} ${HTTP_AUTHZ1_COMMIT}"
			"${HTTP_AUTHZ2_EGO_PN} ${HTTP_AUTHZ2_COMMIT}"
		)

	use cgi && EGO_VENDOR+=( "${HTTP_CGI_EGO_PN} ${HTTP_CGI_COMMIT}" )
	use cors && EGO_VENDOR+=( "${HTTP_CORS_EGO_PN} ${HTTP_CORS_COMMIT}" )
	use expires && EGO_VENDOR+=( "${HTTP_EXPIRES_EGO_PN} ${HTTP_EXPIRES_COMMIT}" )
	use filter && EGO_VENDOR+=( "${HTTP_FILTER_EGO_PN} ${HTTP_FILTER_COMMIT}" )
	use git && EGO_VENDOR+=( "${HTTP_GIT_EGO_PN} ${HTTP_GIT_COMMIT}" )

	use grpc && \
		EGO_VENDOR+=(
			"${HTTP_GRPC_EGO_PN} ${HTTP_GRPC_COMMIT}"
			"${HTTP_GRPC1_EGO_PN} ${HTTP_GRPC1_COMMIT}"
			"${HTTP_GRPC2_EGO_PN} ${HTTP_GRPC2_COMMIT}"
			"${HTTP_GRPC3_EGO_PN} ${HTTP_GRPC3_COMMIT}"
			"google.golang.org/grpc ${HTTP_GRPC4_COMMIT} ${HTTP_GRPC4_EGO_PN}"
			"google.golang.org/genproto ${HTTP_GRPC5_COMMIT} ${HTTP_GRPC5_EGO_PN}"
			"golang.org/x/net ${HTTP_GRPC6_COMMIT} ${HTTP_GRPC6_EGO_PN}"
		)

	use ipfilter && \
		EGO_VENDOR+=(
			"${HTTP_IPFILTER_EGO_PN} ${HTTP_IPFILTER_COMMIT}"
			"${HTTP_IPFILTER1_EGO_PN} ${HTTP_IPFILTER1_COMMIT}"
		)

	use jwt && \
		EGO_VENDOR+=(
			"${HTTP_JWT_EGO_PN} ${HTTP_JWT_COMMIT}"
			"${HTTP_JWT1_EGO_PN} ${HTTP_JWT1_COMMIT}"
		)

	use login && \
		EGO_VENDOR+=(
			"${HTTP_LOGIN_EGO_PN} ${HTTP_LOGIN_COMMIT}"
			"${HTTP_LOGIN1_EGO_PN} ${HTTP_LOGIN1_COMMIT}"
			"${HTTP_LOGIN2_EGO_PN} ${HTTP_LOGIN2_COMMIT}"
			"${HTTP_LOGIN3_EGO_PN} ${HTTP_LOGIN3_COMMIT}"
			"golang.org/x/crypto ${HTTP_LOGIN4_COMMIT} ${HTTP_LOGIN4_EGO_PN}"
		)

	if use mailout; then
		EGO_VENDOR+=(
			"${HTTP_MAILOUT_EGO_PN} ${HTTP_MAILOUT_COMMIT}"
			"${HTTP_MAILOUT1_EGO_PN} ${HTTP_MAILOUT1_COMMIT}"
			"gopkg.in/gomail.v2 ${HTTP_MAILOUT2_COMMIT} ${HTTP_MAILOUT2_EGO_PN}"
		)
		use login || \
			EGO_VENDOR+=( "golang.org/x/crypto ${HTTP_LOGIN4_COMMIT} ${HTTP_LOGIN4_EGO_PN}" )
	fi

	use minify && \
		EGO_VENDOR+=(
			"${HTTP_MINIFY_EGO_PN} ${HTTP_MINIFY_COMMIT}"
			"${HTTP_MINIFY1_EGO_PN} ${HTTP_MINIFY1_COMMIT}"
			"${HTTP_MINIFY2_EGO_PN} ${HTTP_MINIFY2_COMMIT}"
			"${HTTP_MINIFY3_EGO_PN} ${HTTP_MINIFY3_COMMIT}"
			"${HTTP_MINIFY4_EGO_PN} ${HTTP_MINIFY4_COMMIT}"
		)

	use prometheus && \
		EGO_VENDOR+=(
			"${HTTP_PROMTHS_EGO_PN} ${HTTP_PROMTHS_COMMIT}"
			"${HTTP_PROMTHS1_EGO_PN} ${HTTP_PROMTHS1_COMMIT}"
			"${HTTP_PROMTHS2_EGO_PN} ${HTTP_PROMTHS2_COMMIT}"
			"${HTTP_PROMTHS3_EGO_PN} ${HTTP_PROMTHS3_COMMIT}"
			"${HTTP_PROMTHS4_EGO_PN} ${HTTP_PROMTHS4_COMMIT}"
			"${HTTP_PROMTHS5_EGO_PN} ${HTTP_PROMTHS5_COMMIT}"
			"${HTTP_PROMTHS6_EGO_PN} ${HTTP_PROMTHS6_COMMIT}"
		)

	use upload && \
		EGO_VENDOR+=(
			"blitznote.com/src/caddy.upload ${HTTP_UPLOAD_COMMIT} ${HTTP_UPLOAD_EGO_PN}"
			"plugin.hosting/go/abs ${HTTP_UPLOAD1_COMMIT} ${HTTP_UPLOAD1_EGO_PN}"
			"${HTTP_UPLOAD2_EGO_PN} ${HTTP_UPLOAD2_COMMIT}"
		)

	golang-vcs-snapshot_src_unpack
}

src_prepare() {
	if use authz; then
		sed -i -e "/caddymain/a import _ \"$HTTP_AUTHZ_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use cgi; then
		sed -i -e "/caddymain/a import _ \"$HTTP_CGI_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use cors; then
		sed -i -e "/caddymain/a import _ \"$HTTP_CORS_EGO_PN/caddy\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use expires; then
		sed -i -e "/caddymain/a import _ \"$HTTP_EXPIRES_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use filter; then
		sed -i -e "/caddymain/a import _ \"$HTTP_FILTER_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use git; then
		sed -i -e "/caddymain/a import _ \"$HTTP_GIT_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use grpc; then
		sed -i -e "/caddymain/a import _ \"$HTTP_GRPC_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use ipfilter; then
		sed -i -e "/caddymain/a import _ \"$HTTP_IPFILTER_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use jwt; then
		sed -i -e "/caddymain/a import _ \"$HTTP_JWT_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use login; then
		sed -i -e "/caddymain/a import _ \"$HTTP_LOGIN_EGO_PN/caddy\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use mailout; then
		sed -i -e "/caddymain/a import _ \"$HTTP_MAILOUT_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use minify; then
		sed -i -e "/caddymain/a import _ \"$HTTP_MINIFY_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use prometheus; then
		sed -i -e "/caddymain/a import _ \"$HTTP_PROMTHS_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use upload; then
		sed -i -e '/caddymain/a import _ "blitznote.com/src/caddy.upload"' \
			src/${CADDYMAIN}/run.go || die
	fi

	eapply_user
}

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	go install -v -ldflags "-X ${CADDYMAIN}.gitTag=${PV}" ${EGO_PN}/caddy || die
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
