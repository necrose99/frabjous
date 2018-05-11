# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="An open source web chat platform"
HOMEPAGE="https://rocket.chat"
SRC_URI="https://cdn-download.rocket.chat/build/rocket.chat-${PV}.tgz -> ${P}.tgz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND=">=net-libs/nodejs-6.11.5[npm]"
DEPEND="${CDEPEND}
	media-libs/libpng:0
	dev-util/patchelf"
RDEPEND="${CDEPEND}
	dev-db/mongodb
	media-gfx/graphicsmagick[jpeg,png]"

S="${WORKDIR}/bundle"

ROCKETCHAT_NODE="usr/libexec/rocketchat/programs/server/npm/node_modules"
QA_PRESTRIPPED="${ROCKETCHAT_NODE}/meteor/emojione_emojione/node_modules/grunt-contrib-qunit/node_modules/grunt-lib-phantomjs/node_modules/phantomjs/lib/phantom/bin/phantomjs
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libgsf-1.so.114.0.42
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libwebpmux.so.3.0.1
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libgio-2.0.so.0.5501.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libgobject-2.0.so.0.5501.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libfontconfig.so.1.10.1
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libvips.so.42.8.1
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libtiff.so.5.3.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libexif.so.12.3.3
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libgdk_pixbuf-2.0.so.0.3611.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libcairo.so.2.11400.12
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libpng16.so.16.34.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libffi.so.6.0.4
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libpangoft2-1.0.so.0.4100.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libgmodule-2.0.so.0.5501.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libglib-2.0.so.0.5501.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libvips-cpp.so.42.8.1
	${ROCKETCHAT_NODE}/sharp/vendor/lib/librsvg-2.so.2.42.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libxml2.so.2.9.7
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libjpeg.so.8.1.2
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libpixman-1.so.0.34.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libcroco-0.6.so.3.0.1
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libharfbuzz.so.0.10704.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libgif.so.7.0.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libwebp.so.7.0.1
	${ROCKETCHAT_NODE}/sharp/vendor/lib/liblcms2.so.2.0.8
	${ROCKETCHAT_NODE}/sharp/vendor/lib/liborc-0.4.so.0.28.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libpangocairo-1.0.so.0.4100.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libgthread-2.0.so.0.5501.0
	${ROCKETCHAT_NODE}/sharp/vendor/lib/libpango-1.0.so.0.4100.0
	${ROCKETCHAT_NODE}/sharp/build/Release/sharp.node
"
QA_FLAGS_IGNORED="${QA_PRESTRIPPED}"

pkg_setup() {
	has network-sandbox $FEATURES && \
		die "www-apps/rocketchat-server requires 'network-sandbox' to be disabled in FEATURES"

	enewgroup rocketchat
	enewuser rocketchat -1 -1 /usr/libexec/rocketchat rocketchat
}

src_prepare() {
	default
	export N_PREFIX="${S}/npm"
	local PATH="${N_PREFIX}"/bin:$PATH
	local N_CACHE="${WORKDIR}/npm-cache"
	local N_VERSION="$(cat .node_version.txt | cut -d 'v' -f2)"
	mkdir "${N_PREFIX}" "${N_CACHE}" || die

	ebegin "Installing node ${N_VERSION}"
	pushd "${N_PREFIX}" > /dev/null || die
		npm install --cache "${N_CACHE}" n || die
		./node_modules/n/bin/n -q ${N_VERSION} || die
	popd > /dev/null || die
	eend $?

	ebegin "Using node $(node --version) to install dependencies"
	pushd "programs/server" > /dev/null || die
		npm install --cache "${N_CACHE}" || die
		# Remove useless fibers.node
		rm -rf node_modules/fibers/bin/{linux-ia32,win-32}* || die
	popd > /dev/null || die
	eend $?

	pushd "programs/server/npm/node_modules/sharp/vendor/lib" > /dev/null || die
		# scanelf: rpath_security_checks(): Security problem with relative DT_RPATH
		patchelf --set-rpath '$ORIGIN' libffi.so.6.0.4 || die
		# Fix RWX
		scanelf -Xe librsvg-2.so.2.42.0 || die
	popd > /dev/null || die

	# Fix broken png files
	pushd "programs/server/npm/node_modules/meteor/kadira_flow-router/node_modules/page/examples/transitions" > /dev/null || die
		pngfix -q --out=out.png logo.png
		mv -f out.png logo.png || die
	popd > /dev/null || die
}

src_install() {
	diropts -o rocketchat -g rocketchat -m 0755
	dodir /usr/libexec/rocketchat
	cp -a --no-preserve=ownership \
		./* "${D%/}"/usr/libexec/rocketchat || die

	diropts -o rocketchat -g rocketchat -m 0750
	keepdir /var/log/rocketchat
	keepdir /var/lib/rocketchat/.babel-cache

	dosym ../../../var/lib/rocketchat/.babel-cache \
		/usr/libexec/rocketchat/.babel-cache

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
