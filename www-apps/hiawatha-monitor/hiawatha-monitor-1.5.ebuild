# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Monitoring application for www-servers/hiawatha"
HOMEPAGE="https://www.hiawatha-webserver.org/howto/monitor"
SRC_URI="https://www.hiawatha-webserver.org/files/monitor-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=dev-lang/php-5*[mysql,xslt]
	virtual/cron
	virtual/mysql
	www-servers/hiawatha[xslt]"

RESTRICT="mirror"

S="${WORKDIR}/monitor"

src_install () {
	default

	rm -f ChangeLog README LICENSE

	insinto /usr/share/${PN}
	doins -r *
}
