# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# authz (https://github.com/casbin/caddy-authz, Apache-2.0 license)
HTTP_AUTHZ_EGO_PN="github.com/casbin/caddy-authz"
HTTP_AUTHZ_COMMIT="e0ddc63c8d491486d44d1a055fd5277e23135e70" #Version: e0ddc63
HTTP_AUTHZ_URI="https://${HTTP_AUTHZ_EGO_PN}/archive/${HTTP_AUTHZ_COMMIT}.tar.gz"
HTTP_AUTHZ_P="${HTTP_AUTHZ_EGO_PN//\//-}-${HTTP_AUTHZ_COMMIT}"

# authz's dependency 1 (https://github.com/casbin/casbin, Apache-2.0 license)
HTTP_AUTHZ1_EGO_PN="github.com/casbin/casbin"
HTTP_AUTHZ1_COMMIT="27a24f1712c2b786be8b3fc996e0c513d35bae67" #Version: 0.8.0
HTTP_AUTHZ1_URI="https://${HTTP_AUTHZ1_EGO_PN}/archive/${HTTP_AUTHZ1_COMMIT}.tar.gz"
HTTP_AUTHZ1_P="${HTTP_AUTHZ1_EGO_PN//\//-}-${HTTP_AUTHZ1_COMMIT}"

# authz's dependency 2 (https://github.com/Knetic/govaluate, MIT license)
HTTP_AUTHZ2_EGO_PN="github.com/Knetic/govaluate"
HTTP_AUTHZ2_COMMIT="ecff4eed5a1b9d98d7f4795c732fb24ad55e6fc8" #Version: ecff4ee
HTTP_AUTHZ2_URI="https://${HTTP_AUTHZ2_EGO_PN}/archive/${HTTP_AUTHZ2_COMMIT}.tar.gz"
HTTP_AUTHZ2_P="${HTTP_AUTHZ2_EGO_PN//\//-}-${HTTP_AUTHZ2_COMMIT}"

# cgi (https://github.com/jung-kurt/caddy-cgi, MIT license)
HTTP_CGI_EGO_PN="github.com/jung-kurt/caddy-cgi"
HTTP_CGI_COMMIT="9bba4602dab21fdb73c3dc70ffafed3a2f328aa0" #Version: 1.4
HTTP_CGI_URI="https://${HTTP_CGI_EGO_PN}/archive/${HTTP_CGI_COMMIT}.tar.gz"
HTTP_CGI_P="${HTTP_CGI_EGO_PN//\//-}-${HTTP_CGI_COMMIT}"

# cors (https://github.com/captncraig/cors, ??? license)
HTTP_CORS_EGO_PN="github.com/captncraig/cors"
HTTP_CORS_COMMIT="153f484dcf3da8d204585836c3bc4b2ce326ab54" #Version: 153f484
HTTP_CORS_URI="https://${HTTP_CORS_EGO_PN}/archive/${HTTP_CORS_COMMIT}.tar.gz"
HTTP_CORS_P="${HTTP_CORS_EGO_PN//\//-}-${HTTP_CORS_COMMIT}"

# expires (https://github.com/epicagency/caddy-expires, MIT license)
HTTP_EXPIRES_EGO_PN="github.com/epicagency/caddy-expires"
HTTP_EXPIRES_COMMIT="cb2ed464e061263893acfe4cdbcab6f54e244afc" #Version: 1.0.0
HTTP_EXPIRES_URI="https://${HTTP_EXPIRES_EGO_PN}/archive/${HTTP_EXPIRES_COMMIT}.tar.gz"
HTTP_EXPIRES_P="${HTTP_EXPIRES_EGO_PN//\//-}-${HTTP_EXPIRES_COMMIT}"

# filemanager (https://github.com/hacdias/filemanager, Apache-2.0 license)
HTTP_FMANAGER_EGO_PN="github.com/hacdias/filemanager"
HTTP_FMANAGER_COMMIT="729064ffc8fb140d667ff39a04ddd122529a19cb" #Version: 729064f
HTTP_FMANAGER_URI="https://${HTTP_FMANAGER_EGO_PN}/archive/${HTTP_FMANAGER_COMMIT}.tar.gz"
HTTP_FMANAGER_P="${HTTP_FMANAGER_EGO_PN//\//-}-${HTTP_FMANAGER_COMMIT}"

# filemanager's dependency 1 (https://github.com/GeertJohan/go.rice, BSD-2 license)
# needed by github.com/hacdias/filemanager
HTTP_FMANAGER1_EGO_PN="github.com/GeertJohan/go.rice"
HTTP_FMANAGER1_COMMIT="c02ca9a983da5807ddf7d796784928f5be4afd09" #Version: c02ca9a
HTTP_FMANAGER1_URI="https://${HTTP_FMANAGER1_EGO_PN}/archive/${HTTP_FMANAGER1_COMMIT}.tar.gz"
HTTP_FMANAGER1_P="${HTTP_FMANAGER1_EGO_PN//\//-}-${HTTP_FMANAGER1_COMMIT}"

# filemanager's dependency 2 (https://github.com/daaku/go.zipexe, MIT license)
# needed by github.com/GeertJohan/go.rice
HTTP_FMANAGER2_EGO_PN="github.com/daaku/go.zipexe"
HTTP_FMANAGER2_COMMIT="a5fe2436ffcb3236e175e5149162b41cd28bd27d" #Version: a5fe243
HTTP_FMANAGER2_URI="https://${HTTP_FMANAGER2_EGO_PN}/archive/${HTTP_FMANAGER2_COMMIT}.tar.gz"
HTTP_FMANAGER2_P="${HTTP_FMANAGER2_EGO_PN//\//-}-${HTTP_FMANAGER2_COMMIT}"

# filemanager's dependency 3 (https://github.com/kardianos/osext, BSD license)
# needed by github.com/GeertJohan/go.rice
HTTP_FMANAGER3_EGO_PN="github.com/kardianos/osext"
HTTP_FMANAGER3_COMMIT="ae77be60afb1dcacde03767a8c37337fad28ac14" #Version: ae77be6
HTTP_FMANAGER3_URI="https://${HTTP_FMANAGER3_EGO_PN}/archive/${HTTP_FMANAGER3_COMMIT}.tar.gz"
HTTP_FMANAGER3_P="${HTTP_FMANAGER3_EGO_PN//\//-}-${HTTP_FMANAGER3_COMMIT}"

# filemanager's dependency 4 (https://github.com/asdine/storm, MIT license)
# needed by github.com/hacdias/filemanager
HTTP_FMANAGER4_EGO_PN="github.com/asdine/storm"
HTTP_FMANAGER4_COMMIT="2da548c16156b3197728372bff5614033084aff5" #Version: 0.8.1
HTTP_FMANAGER4_URI="https://${HTTP_FMANAGER4_EGO_PN}/archive/${HTTP_FMANAGER4_COMMIT}.tar.gz"
HTTP_FMANAGER4_P="${HTTP_FMANAGER4_EGO_PN//\//-}-${HTTP_FMANAGER4_COMMIT}"

# filemanager's dependency 5 (https://github.com/boltdb/bolt, MIT license)
# needed by github.com/asdine/storm
HTTP_FMANAGER5_EGO_PN="github.com/boltdb/bolt"
HTTP_FMANAGER5_COMMIT="e9cf4fae01b5a8ff89d0ec6b32f0d9c9f79aefdd" #Version: e9cf4fa
HTTP_FMANAGER5_URI="https://${HTTP_FMANAGER5_EGO_PN}/archive/${HTTP_FMANAGER5_COMMIT}.tar.gz"
HTTP_FMANAGER5_P="${HTTP_FMANAGER5_EGO_PN//\//-}-${HTTP_FMANAGER5_COMMIT}"

# filemanager's dependency 6 (https://github.com/dgrijalva/jwt-go, MIT license)
# needed by github.com/hacdias/filemanager
HTTP_FMANAGER6_EGO_PN="github.com/dgrijalva/jwt-go"
HTTP_FMANAGER6_COMMIT="a539ee1a749a2b895533f979515ac7e6e0f5b650" #Version: a539ee1
HTTP_FMANAGER6_URI="https://${HTTP_FMANAGER6_EGO_PN}/archive/${HTTP_FMANAGER6_COMMIT}.tar.gz"
HTTP_FMANAGER6_P="${HTTP_FMANAGER6_EGO_PN//\//-}-${HTTP_FMANAGER6_COMMIT}"

# filemanager's dependency 7 (https://github.com/mholt/archiver, MIT license)
# needed by github.com/hacdias/filemanager
HTTP_FMANAGER7_EGO_PN="github.com/mholt/archiver"
HTTP_FMANAGER7_COMMIT="3c9755ff45e1df13e5331d936c3ffab88233dccd" #Version: 3c9755f
HTTP_FMANAGER7_URI="https://${HTTP_FMANAGER7_EGO_PN}/archive/${HTTP_FMANAGER7_COMMIT}.tar.gz"
HTTP_FMANAGER7_P="${HTTP_FMANAGER7_EGO_PN//\//-}-${HTTP_FMANAGER7_COMMIT}"

# filemanager's dependency 8 (https://github.com/dsnet/compress, BSD license)
# needed by github.com/mholt/archiver
HTTP_FMANAGER8_EGO_PN="github.com/dsnet/compress"
HTTP_FMANAGER8_COMMIT="0ae8e136a5df9e3caf6c0f69983608b07438411b" #Version: 0ae8e13
HTTP_FMANAGER8_URI="https://${HTTP_FMANAGER8_EGO_PN}/archive/${HTTP_FMANAGER8_COMMIT}.tar.gz"
HTTP_FMANAGER8_P="${HTTP_FMANAGER8_EGO_PN//\//-}-${HTTP_FMANAGER8_COMMIT}"

# filemanager's dependency 9 (https://github.com/golang/snappy, BSD license)
# needed by github.com/mholt/archiver
HTTP_FMANAGER9_EGO_PN="github.com/golang/snappy"
HTTP_FMANAGER9_COMMIT="553a641470496b2327abcac10b36396bd98e45c9" #Version: 553a641
HTTP_FMANAGER9_URI="https://${HTTP_FMANAGER9_EGO_PN}/archive/${HTTP_FMANAGER9_COMMIT}.tar.gz"
HTTP_FMANAGER9_P="${HTTP_FMANAGER9_EGO_PN//\//-}-${HTTP_FMANAGER9_COMMIT}"

# filemanager's dependency 10 (https://github.com/nwaples/rardecode, BSD license)
# needed by github.com/mholt/archiver
HTTP_FMANAGER10_EGO_PN="github.com/nwaples/rardecode"
HTTP_FMANAGER10_COMMIT="f22b7ef81a0afac9ce1447d37e5ab8e99fbd2f73" #Version: f22b7ef
HTTP_FMANAGER10_URI="https://${HTTP_FMANAGER10_EGO_PN}/archive/${HTTP_FMANAGER10_COMMIT}.tar.gz"
HTTP_FMANAGER10_P="${HTTP_FMANAGER10_EGO_PN//\//-}-${HTTP_FMANAGER10_COMMIT}"

# filemanager's dependency 11 (https://github.com/pierrec/lz4, BSD license)
# needed by github.com/mholt/archiver
HTTP_FMANAGER11_EGO_PN="github.com/pierrec/lz4"
HTTP_FMANAGER11_COMMIT="5a3d2245f97fc249850e7802e3c01fad02a1c316" #Version: 5a3d224
HTTP_FMANAGER11_URI="https://${HTTP_FMANAGER11_EGO_PN}/archive/${HTTP_FMANAGER11_COMMIT}.tar.gz"
HTTP_FMANAGER11_P="${HTTP_FMANAGER11_EGO_PN//\//-}-${HTTP_FMANAGER11_COMMIT}"

# filemanager's dependency 12 (https://github.com/pierrec/xxHash, BSD license)
# needed by github.com/pierrec/lz4
HTTP_FMANAGER12_EGO_PN="github.com/pierrec/xxHash"
HTTP_FMANAGER12_COMMIT="5a004441f897722c627870a981d02b29924215fa" #Version: 5a00444
HTTP_FMANAGER12_URI="https://${HTTP_FMANAGER12_EGO_PN}/archive/${HTTP_FMANAGER12_COMMIT}.tar.gz"
HTTP_FMANAGER12_P="${HTTP_FMANAGER12_EGO_PN//\//-}-${HTTP_FMANAGER12_COMMIT}"

# filemanager's dependency 13 (https://github.com/ulikunitz/xz, BSD license)
# needed by github.com/mholt/archiver
HTTP_FMANAGER13_EGO_PN="github.com/ulikunitz/xz"
HTTP_FMANAGER13_COMMIT="0c6b41e72360850ca4f98dc341fd999726ea007f" #Version: 0.5.4
HTTP_FMANAGER13_URI="https://${HTTP_FMANAGER13_EGO_PN}/archive/${HTTP_FMANAGER13_COMMIT}.tar.gz"
HTTP_FMANAGER13_P="${HTTP_FMANAGER13_EGO_PN//\//-}-${HTTP_FMANAGER13_COMMIT}"

# filemanager's dependency 14 (https://github.com/gohugoio/hugo, Apache-2.0 license)
# needed by github.com/hacdias/filemanager
HTTP_FMANAGER14_EGO_PN="github.com/gohugoio/hugo"
HTTP_FMANAGER14_COMMIT="bbd33dbf5d9575ab95c8e00aa97b71a600e429b6" #Version: 0.25.1
HTTP_FMANAGER14_URI="https://${HTTP_FMANAGER14_EGO_PN}/archive/${HTTP_FMANAGER14_COMMIT}.tar.gz"
HTTP_FMANAGER14_P="${HTTP_FMANAGER14_EGO_PN//\//-}-${HTTP_FMANAGER14_COMMIT}"

# filemanager's dependency 15 (https://github.com/BurntSushi/toml, MIT license)
# needed by github.com/gohugoio/hugo/parser
HTTP_FMANAGER15_EGO_PN="github.com/BurntSushi/toml"
HTTP_FMANAGER15_COMMIT="a368813c5e648fee92e5f6c30e3944ff9d5e8895" #Version: a368813
HTTP_FMANAGER15_URI="https://${HTTP_FMANAGER15_EGO_PN}/archive/${HTTP_FMANAGER15_COMMIT}.tar.gz"
HTTP_FMANAGER15_P="${HTTP_FMANAGER15_EGO_PN//\//-}-${HTTP_FMANAGER15_COMMIT}"

# filemanager's dependency 16 (https://github.com/chaseadamsio/goorgeous, MIT license)
# needed by github.com/gohugoio/hugo/parser
HTTP_FMANAGER16_EGO_PN="github.com/chaseadamsio/goorgeous"
HTTP_FMANAGER16_COMMIT="677defd0e024333503d8c946dd4ba3f32ad3e5d2" #Version: 677defd
HTTP_FMANAGER16_URI="https://${HTTP_FMANAGER16_EGO_PN}/archive/${HTTP_FMANAGER16_COMMIT}.tar.gz"
HTTP_FMANAGER16_P="${HTTP_FMANAGER16_EGO_PN//\//-}-${HTTP_FMANAGER16_COMMIT}"

# filemanager's dependency 17 (https://github.com/shurcooL/sanitized_anchor_name, MIT license)
# needed by github.com/chaseadamsio/goorgeous
HTTP_FMANAGER17_EGO_PN="github.com/shurcooL/sanitized_anchor_name"
HTTP_FMANAGER17_COMMIT="541ff5ee47f1dddf6a5281af78307d921524bcb5" #Version: 541ff5e
HTTP_FMANAGER17_URI="https://${HTTP_FMANAGER17_EGO_PN}/archive/${HTTP_FMANAGER17_COMMIT}.tar.gz"
HTTP_FMANAGER17_P="${HTTP_FMANAGER17_EGO_PN//\//-}-${HTTP_FMANAGER17_COMMIT}"

# filemanager's dependency 18 (https://github.com/golang/crypto, BSD license)
# needed by github.com/hacdias/filemanager
HTTP_FMANAGER18_EGO_PN="github.com/golang/crypto"
HTTP_FMANAGER18_COMMIT="dd85ac7e6a88fc6ca420478e934de5f1a42dd3c6" #Version: dd85ac7
HTTP_FMANAGER18_URI="https://${HTTP_FMANAGER18_EGO_PN}/archive/${HTTP_FMANAGER18_COMMIT}.tar.gz"
HTTP_FMANAGER18_P="${HTTP_FMANAGER18_EGO_PN//\//-}-${HTTP_FMANAGER18_COMMIT}"

# filemanager's dependency 19 (https://github.com/golang/net, BSD license)
# needed by github.com/hacdias/filemanager
HTTP_FMANAGER19_EGO_PN="github.com/golang/net"
HTTP_FMANAGER19_COMMIT="f01ecb60fe3835d80d9a0b7b2bf24b228c89260e" #Version: f01ecb6
HTTP_FMANAGER19_URI="https://${HTTP_FMANAGER19_EGO_PN}/archive/${HTTP_FMANAGER19_COMMIT}.tar.gz"
HTTP_FMANAGER19_P="${HTTP_FMANAGER19_EGO_PN//\//-}-${HTTP_FMANAGER19_COMMIT}"

# filter (https://github.com/echocat/caddy-filter, MIT license)
HTTP_FILTER_EGO_PN="github.com/echocat/caddy-filter"
HTTP_FILTER_COMMIT="475893477aa56b83e77e542f0fa19bcfcfea29e4" #Version: 0.6
HTTP_FILTER_URI="https://${HTTP_FILTER_EGO_PN}/archive/${HTTP_FILTER_COMMIT}.tar.gz"
HTTP_FILTER_P="${HTTP_FILTER_EGO_PN//\//-}-${HTTP_FILTER_COMMIT}"

# minify (https://github.com/hacdias/caddy-minify, Apache-2.0 license)
HTTP_MINIFY_EGO_PN="github.com/hacdias/caddy-minify"
HTTP_MINIFY_COMMIT="ebd59eb798bca79555b2ac7163107be0c29e33cf" #Version: ebd59eb
HTTP_MINIFY_URI="https://${HTTP_MINIFY_EGO_PN}/archive/${HTTP_MINIFY_COMMIT}.tar.gz"
HTTP_MINIFY_P="${HTTP_MINIFY_EGO_PN//\//-}-${HTTP_MINIFY_COMMIT}"

# minify's dependency 1 (https://github.com/tdewolff/minify, MIT license)
HTTP_MINIFY1_EGO_PN="github.com/tdewolff/minify"
HTTP_MINIFY1_COMMIT="2d28d6e43c68537a32f9b835a89d5038ebcb6ec9" #Version: 2d28d6e
HTTP_MINIFY1_URI="https://${HTTP_MINIFY1_EGO_PN}/archive/${HTTP_MINIFY1_COMMIT}.tar.gz"
HTTP_MINIFY1_P="${HTTP_MINIFY1_EGO_PN//\//-}-${HTTP_MINIFY1_COMMIT}"

# minify's dependency 2 (https://github.com/tdewolff/buffer, MIT license)
HTTP_MINIFY2_EGO_PN="github.com/tdewolff/buffer"
HTTP_MINIFY2_COMMIT="df6253e2a2cda5aba1b5d0c59fc5bdf0a98ae192" #Version: df6253e
HTTP_MINIFY2_URI="https://${HTTP_MINIFY2_EGO_PN}/archive/${HTTP_MINIFY2_COMMIT}.tar.gz"
HTTP_MINIFY2_P="${HTTP_MINIFY2_EGO_PN//\//-}-${HTTP_MINIFY2_COMMIT}"

# minify's dependency 3 (https://github.com/tdewolff/parse, MIT license)
HTTP_MINIFY3_EGO_PN="github.com/tdewolff/parse"
HTTP_MINIFY3_COMMIT="e3d09bbcbf6d7721468bbe5deb35fe71da57d0f3" #Version: e3d09bb
HTTP_MINIFY3_URI="https://${HTTP_MINIFY3_EGO_PN}/archive/${HTTP_MINIFY3_COMMIT}.tar.gz"
HTTP_MINIFY3_P="${HTTP_MINIFY3_EGO_PN//\//-}-${HTTP_MINIFY3_COMMIT}"

# minify's dependency 4 (https://github.com/tdewolff/strconv, MIT license)
HTTP_MINIFY4_EGO_PN="github.com/tdewolff/strconv"
HTTP_MINIFY4_COMMIT="3e8091f4417ebaaa3910da63a45ea394ebbfb0e3" #Version: 3e8091f
HTTP_MINIFY4_URI="https://${HTTP_MINIFY4_EGO_PN}/archive/${HTTP_MINIFY4_COMMIT}.tar.gz"
HTTP_MINIFY4_P="${HTTP_MINIFY4_EGO_PN//\//-}-${HTTP_MINIFY4_COMMIT}"

# upload (https://github.com/wmark/caddy.upload, BSD license)
HTTP_UPLOAD_EGO_PN="github.com/wmark/caddy.upload"
HTTP_UPLOAD_COMMIT="fe91e5c4d5687e74e07fd0ce0a2230ce19951014" #Version: 1.2.1
HTTP_UPLOAD_URI="https://${HTTP_UPLOAD_EGO_PN}/archive/${HTTP_UPLOAD_COMMIT}.tar.gz"
HTTP_UPLOAD_P="${HTTP_UPLOAD_EGO_PN//\//-}-${HTTP_UPLOAD_COMMIT}"

# upload's dependency 1 (https://github.com/wmark/go.abs, ??? license)
HTTP_UPLOAD1_EGO_PN="github.com/wmark/go.abs"
HTTP_UPLOAD1_COMMIT="1ba06a13d0c0530cb12338dd83254ececc6e509f" #Version: 1ba06a1
HTTP_UPLOAD1_URI="https://${HTTP_UPLOAD1_EGO_PN}/archive/${HTTP_UPLOAD1_COMMIT}.tar.gz"
HTTP_UPLOAD1_P="${HTTP_UPLOAD1_EGO_PN//\//-}-${HTTP_UPLOAD1_COMMIT}"

# upload's dependency 2 (https://github.com/pkg/errors, BSD-2 license)
HTTP_UPLOAD2_EGO_PN="github.com/pkg/errors"
HTTP_UPLOAD2_COMMIT="c605e284fe17294bda444b34710735b29d1a9d90" #Version: c605e28
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
	filemanager? (
		${HTTP_FMANAGER_URI} -> ${HTTP_FMANAGER_P}.tar.gz
		${HTTP_FMANAGER1_URI} -> ${HTTP_FMANAGER1_P}.tar.gz
		${HTTP_FMANAGER2_URI} -> ${HTTP_FMANAGER2_P}.tar.gz
		${HTTP_FMANAGER3_URI} -> ${HTTP_FMANAGER3_P}.tar.gz
		${HTTP_FMANAGER4_URI} -> ${HTTP_FMANAGER4_P}.tar.gz
		${HTTP_FMANAGER5_URI} -> ${HTTP_FMANAGER5_P}.tar.gz
		${HTTP_FMANAGER6_URI} -> ${HTTP_FMANAGER6_P}.tar.gz
		${HTTP_FMANAGER7_URI} -> ${HTTP_FMANAGER7_P}.tar.gz
		${HTTP_FMANAGER8_URI} -> ${HTTP_FMANAGER8_P}.tar.gz
		${HTTP_FMANAGER9_URI} -> ${HTTP_FMANAGER9_P}.tar.gz
		${HTTP_FMANAGER10_URI} -> ${HTTP_FMANAGER10_P}.tar.gz
		${HTTP_FMANAGER11_URI} -> ${HTTP_FMANAGER11_P}.tar.gz
		${HTTP_FMANAGER12_URI} -> ${HTTP_FMANAGER12_P}.tar.gz
		${HTTP_FMANAGER13_URI} -> ${HTTP_FMANAGER13_P}.tar.gz
		${HTTP_FMANAGER14_URI} -> ${HTTP_FMANAGER14_P}.tar.gz
		${HTTP_FMANAGER15_URI} -> ${HTTP_FMANAGER15_P}.tar.gz
		${HTTP_FMANAGER16_URI} -> ${HTTP_FMANAGER16_P}.tar.gz
		${HTTP_FMANAGER17_URI} -> ${HTTP_FMANAGER17_P}.tar.gz
		${HTTP_FMANAGER18_URI} -> ${HTTP_FMANAGER18_P}.tar.gz
		${HTTP_FMANAGER19_URI} -> ${HTTP_FMANAGER19_P}.tar.gz
	)
	filter? ( ${HTTP_FILTER_URI} -> ${HTTP_FILTER_P}.tar.gz )
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

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="authz cgi cors expires filemanager filter minify upload"

DEPEND=">=dev-lang/go-1.8"
RDEPEND="sys-libs/libcap"

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_unpack() {
	if use authz; then
		EGO_VENDOR+=(
			"${HTTP_AUTHZ_EGO_PN} ${HTTP_AUTHZ_COMMIT}"
			"${HTTP_AUTHZ1_EGO_PN} ${HTTP_AUTHZ1_COMMIT}"
			"${HTTP_AUTHZ2_EGO_PN} ${HTTP_AUTHZ2_COMMIT}"
		)
	fi

	use cgi && EGO_VENDOR+=( "${HTTP_CGI_EGO_PN} ${HTTP_CGI_COMMIT}" )
	use cors && EGO_VENDOR+=( "${HTTP_CORS_EGO_PN} ${HTTP_CORS_COMMIT}" )
	use expires && EGO_VENDOR+=( "${HTTP_EXPIRES_EGO_PN} ${HTTP_EXPIRES_COMMIT}" )

	if use filemanager; then
		EGO_VENDOR+=(
			"${HTTP_FMANAGER_EGO_PN} ${HTTP_FMANAGER_COMMIT}"
			"${HTTP_FMANAGER1_EGO_PN} ${HTTP_FMANAGER1_COMMIT}"
			"${HTTP_FMANAGER2_EGO_PN} ${HTTP_FMANAGER2_COMMIT}"
			"${HTTP_FMANAGER3_EGO_PN} ${HTTP_FMANAGER3_COMMIT}"
			"${HTTP_FMANAGER4_EGO_PN} ${HTTP_FMANAGER4_COMMIT}"
			"${HTTP_FMANAGER5_EGO_PN} ${HTTP_FMANAGER5_COMMIT}"
			"${HTTP_FMANAGER6_EGO_PN} ${HTTP_FMANAGER6_COMMIT}"
			"${HTTP_FMANAGER7_EGO_PN} ${HTTP_FMANAGER7_COMMIT}"
			"${HTTP_FMANAGER8_EGO_PN} ${HTTP_FMANAGER8_COMMIT}"
			"${HTTP_FMANAGER9_EGO_PN} ${HTTP_FMANAGER9_COMMIT}"
			"${HTTP_FMANAGER10_EGO_PN} ${HTTP_FMANAGER10_COMMIT}"
			"${HTTP_FMANAGER11_EGO_PN} ${HTTP_FMANAGER11_COMMIT}"
			"${HTTP_FMANAGER12_EGO_PN} ${HTTP_FMANAGER12_COMMIT}"
			"${HTTP_FMANAGER13_EGO_PN} ${HTTP_FMANAGER13_COMMIT}"
			"github.com/spf13/hugo ${HTTP_FMANAGER14_COMMIT} ${HTTP_FMANAGER14_EGO_PN}"
			"${HTTP_FMANAGER15_EGO_PN} ${HTTP_FMANAGER15_COMMIT}"
			"${HTTP_FMANAGER16_EGO_PN} ${HTTP_FMANAGER16_COMMIT}"
			"${HTTP_FMANAGER17_EGO_PN} ${HTTP_FMANAGER17_COMMIT}"
			"golang.org/x/crypto ${HTTP_FMANAGER18_COMMIT} ${HTTP_FMANAGER18_EGO_PN}"
			"golang.org/x/net ${HTTP_FMANAGER19_COMMIT} ${HTTP_FMANAGER19_EGO_PN}"
		)
	fi

	use filter && EGO_VENDOR+=( "${HTTP_FILTER_EGO_PN} ${HTTP_FILTER_COMMIT}" )

	if use minify; then
		EGO_VENDOR+=(
			"${HTTP_MINIFY_EGO_PN} ${HTTP_MINIFY_COMMIT}"
			"${HTTP_MINIFY1_EGO_PN} ${HTTP_MINIFY1_COMMIT}"
			"${HTTP_MINIFY2_EGO_PN} ${HTTP_MINIFY2_COMMIT}"
			"${HTTP_MINIFY3_EGO_PN} ${HTTP_MINIFY3_COMMIT}"
			"${HTTP_MINIFY4_EGO_PN} ${HTTP_MINIFY4_COMMIT}"
		)
	fi

	if use upload; then
		EGO_VENDOR+=(
			"blitznote.com/src/caddy.upload ${HTTP_UPLOAD_COMMIT} ${HTTP_UPLOAD_EGO_PN}"
			"plugin.hosting/go/abs ${HTTP_UPLOAD1_COMMIT} ${HTTP_UPLOAD1_EGO_PN}"
			"${HTTP_UPLOAD2_EGO_PN} ${HTTP_UPLOAD2_COMMIT}"
		)
	fi

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

	if use filemanager; then
		sed -i -e '/caddymain/a import _ "github.com/hacdias/filemanager/caddy/filemanager"' \
			src/${CADDYMAIN}/run.go || die
	fi

	if use filter; then
		sed -i -e "/caddymain/a import _ \"$HTTP_FILTER_EGO_PN\"" \
			src/${CADDYMAIN}/run.go || die
	fi

	if use minify; then
		sed -i -e "/caddymain/a import _ \"$HTTP_MINIFY_EGO_PN\"" \
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
