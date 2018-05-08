# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fcaps golang-vcs-snapshot systemd user

EGO_PN="github.com/jedisct1/${PN}"
DESCRIPTION="A flexible DNS proxy, with support for modern encrypted DNS protocols"
HOMEPAGE="https://dnscrypt.info"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="strip"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="systemd"

FILECAPS=( cap_net_bind_service+ep usr/bin/dnscrypt-proxy )

DOCS=( ChangeLog README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_prepare() {
	local DNSCRYPT_LOG="${EPREFIX}/var/log/${PN}"
	local DNSCRYPT_CACHE="${EPREFIX}/var/cache/${PN}"

	sed -i \
		-e "s| file = '\([[:graph:]]\+\)'| file = '${DNSCRYPT_LOG}/\1'|g" \
		-e "s|log_file = '\([[:graph:]]\+\)'|log_file = '${DNSCRYPT_LOG}/\1'|g" \
		-e "s|cache_file = '\([[:graph:]]\+\)'|cache_file = '${DNSCRYPT_CACHE}/\1'|g" \
		${PN}/example-dnscrypt-proxy.toml || die

	if use systemd; then
		sed -i "s|\['127.0.0.1:53', '\[::1\]:53'\]|\[\]|" \
			${PN}/example-dnscrypt-proxy.toml || die
	fi

	default
}

src_compile() {
	export GOPATH="${G}"
	go install -v -ldflags "-s -w" ./${PN} || die
}

src_install() {
	dobin ${G}/bin/dnscrypt-proxy
	einstalldocs

	insinto /etc/dnscrypt-proxy
	doins ${PN}/example-dnscrypt-proxy.toml
	doins ${PN}/example-{blacklist.txt,whitelist.txt}
	doins ${PN}/example-{cloaking-rules.txt,forwarding-rules.txt}

	insinto /usr/share/dnscrypt-proxy
	doins -r utils/generate-domains-blacklists/.

	newinitd "${FILESDIR}"/dnscrypt-proxy.initd-r2 ${PN}
	newconfd "${FILESDIR}"/dnscrypt-proxy.confd-r2 ${PN}
	systemd_dounit systemd/dnscrypt-proxy.service
	systemd_dounit systemd/dnscrypt-proxy.socket
}

pkg_postinst() {
	fcaps_pkg_postinst

	if [ ! -e "${EROOT%/}"/etc/${PN}/${PN}.toml ]; then
		elog "No ${PN}.toml found, copying the example over"
		cp "${EROOT%/}"/etc/${PN}/{example-,}${PN}.toml || die
	else
		elog "${PN}.toml found, please check example file for possible changes"
	fi

	if ! use systemd; then
		if ! use filecaps; then
			ewarn
			ewarn "'filecaps' USE flag is disabled"
			ewarn "${PN} will fail to listen on port 53 if started via OpenRC"
			ewarn "please either change port to > 1024, configure to run ${PN} as root"
			ewarn "or re-enable 'filecaps'"
			ewarn
		fi
	fi

	local v
	for v in ${REPLACING_VERSIONS}; do
		if [ ${v} = 1.* ]; then
			elog "Version 2.x.x is a complete rewrite of ${PN}"
			elog "please clean up old config/log files"
			elog
		fi
	done

	if [ -z "${REPLACING_VERSIONS}" ]; then
		elog "After starting the service you will need to update your"
		elog "/etc/resolv.conf and replace your current set of resolvers"
		elog "with:"
		elog
		elog "nameserver 127.0.0.1"
		elog
		elog "Also see https://github.com/jedisct1/${PN}/wiki"
	fi
}
