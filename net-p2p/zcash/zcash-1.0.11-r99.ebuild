# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools bash-completion-r1 flag-o-matic systemd user

# depends/packages/bdb.mk (http://www.oracle.com, AGPL-3 license)
BDB_PV="6.2.23"
BDB_PKG="db-${BDB_PV}.tar.gz"
BDB_HASH="47612c8991aa9ac2f6be721267c8d3cdccf5ac83105df8e50809daea24e95dc7"
BDB_URI="http://download.oracle.com/berkeley-db/${BDB_PKG}"
BDB_STAMP=".stamp_fetched-bdb-${BDB_PKG}.hash"

# depends/packages/googlemock.mk (https://github.com/google/googlemock, ??? license)
GMOCK_PV="1.7.0"
GMOCK_PKG="googlemock-${GMOCK_PV}.tar.gz"
GMOCK_HASH="3f20b6acb37e5a98e8c4518165711e3e35d47deb6cdb5a4dd4566563b5efd232"
GMOCK_URI="https://github.com/google/googlemock/archive/release-${GMOCK_PV}.tar.gz"
GMOCK_STAMP=".stamp_fetched-googlemock-${GMOCK_PKG}.hash"

# depends/packages/googletest.mk (https://github.com/google/googletest, ??? license)
GTEST_PV="1.7.0"
GTEST_PKG="googletest-${GTEST_PV}.tar.gz"
GTEST_HASH="f73a6546fdf9fce9ff93a5015e0333a8af3062a152a9ad6bcb772c96687016cc"
GTEST_URI="https://github.com/google/googletest/archive/release-${GTEST_PV}.tar.gz"
GTEST_STAMP=".stamp_fetched-googletest-${GTEST_PKG}.hash"

# depends/packages/libsnark.mk (https://github.com/zcash/libsnark, MIT license)
LIBSNARK_PV="9ada3f84ab484c57b2247c2f41091fd6a0916573"
LIBSNARK_PKG="libsnark-${LIBSNARK_PV}.tar.gz"
LIBSNARK_HASH="dad153fe46e2e1f33557a195cbe7d69aed8b19ed9befc08ddcb8c6d3c025941f"
LIBSNARK_URI="https://github.com/zcash/libsnark/archive/${LIBSNARK_PV}.tar.gz"
LIBSNARK_STAMP=".stamp_fetched-libsnark-${LIBSNARK_PKG}.hash"

# depends/packages/proton.mk (https://qpid.apache.org/proton/, Apache 2.0 license)
PROTON_PV="0.17.0"
PROTON_ARCH="qpid-proton-${PROTON_PV}.tar.gz"
PROTON_HASH="6ffd26d3d0e495bfdb5d9fefc5349954e6105ea18cc4bb191161d27742c5a01a"
PROTON_URI="mirror://apache/qpid/proton/${PROTON_PV}/${PROTON_ARCH}"
PROTON_STAMP=".stamp_fetched-proton-${PROTON_ARCH}.hash"

# depends/packages/librustzcash.mk (https://github.com/zcash/librustzcash, Apache 2.0 / MIT license)
RUSTZCASH_PV="91348647a86201a9482ad4ad68398152dc3d635e"
RUSTZCASH_PKG="librustzcash-${RUSTZCASH_PV}.tar.gz"
RUSTZCASH_HASH="a5760a90d4a1045c8944204f29fa2a3cf2f800afee400f88bf89bbfe2cce1279"
RUSTZCASH_URI="https://github.com/zcash/librustzcash/archive/${RUSTZCASH_PV}.tar.gz"
RUSTZCASH_STAMP=".stamp_fetched-librustzcash-${RUSTZCASH_PKG}.hash"

# crate dependency for librustzcash
CRATES="libc-0.2.21"
cargo_crate_uris() {
	local crate
	for crate in "$@"; do
		local name version url
		name="${crate%-*}"
		version="${crate##*-}"
		url="https://crates.io/api/v1/crates/${name}/${version}/download -> ${crate}.crate"
		echo "${url}"
	done
}

#MY_PV=${PV/_p/-}
DESCRIPTION="Cryptocurrency that offers privacy of transactions"
HOMEPAGE="https://z.cash"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${BDB_URI}
	${GMOCK_URI} -> ${GMOCK_PKG}
	${GTEST_URI} -> ${GTEST_PKG}
	${LIBSNARK_URI} -> ${LIBSNARK_PKG}
	proton? ( ${PROTON_URI} )
	rust? ( ${RUSTZCASH_URI} -> ${RUSTZCASH_PKG}
		$(cargo_crate_uris ${CRATES})
	)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples hardened libs mining proton reduce-exports rust zeromq"

DEPEND="dev-libs/boost:0[threads(+)]
	>=dev-libs/gmp-6.1.0
	>=dev-libs/libevent-2.1.8
	dev-libs/libsodium[-minimal]
	rust? ( >=dev-util/cargo-0.16.0 )
	zeromq? ( >=net-libs/zeromq-4.2.1 )"
RDEPEND="${DEPEND}"

DOCS=( doc/{payment-api,security-warnings,tor}.md )

#S="${WORKDIR}/${PN}-${MY_PV}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/zcashd ${PN}
}

src_unpack() {
	# Unpack only the main source
	unpack ${P}.tar.gz

	if use rust; then
		ECARGO_HOME="${WORKDIR}/cargo_home"
		ECARGO_VENDOR="${ECARGO_HOME}/gentoo"
		export CARGO_HOME="${ECARGO_HOME}"
		mkdir -p "${ECARGO_VENDOR}" || die
		for archive in ${A}; do
			case "${archive}" in
				*.crate)
					ebegin "Loading ${archive} into Cargo registry"
					tar -xf "${DISTDIR}"/${archive} -C "${ECARGO_VENDOR}/" || die
					# generate sha256sum of the crate itself as cargo needs this
					shasum=$(sha256sum "${DISTDIR}"/${archive} | cut -d ' ' -f 1)
					pkg=$(basename ${archive} .crate)
					cat <<- EOF > ${ECARGO_VENDOR}/${pkg}/.cargo-checksum.json
					{
						"package": "${shasum}",
						"files": {}
					}
					EOF
					eend $?
					;;
			esac
		done
		cat <<- EOF > "${ECARGO_HOME}/config"
		[source.gentoo]
		directory = "${ECARGO_VENDOR}"

		[source.crates-io]
		replace-with = "gentoo"
		local-registry = "/nonexistant"
		EOF
	fi
}

src_prepare() {
	local DEP_SRC STAMP_DIR LIBS X
	DEP_SRC="${S}/depends/sources"
	STAMP_DIR="${DEP_SRC}/download-stamps"

	# Prepare download-stamps
	mkdir -p "${STAMP_DIR}" || die
	echo "${BDB_HASH} ${BDB_PKG}" > "${STAMP_DIR}/${BDB_STAMP}" || die
	echo "${GMOCK_HASH} ${GMOCK_PKG}" > "${STAMP_DIR}/${GMOCK_STAMP}" || die
	echo "${GTEST_HASH} ${GTEST_PKG}" > "${STAMP_DIR}/${GTEST_STAMP}" || die
	echo "${LIBSNARK_HASH} ${LIBSNARK_PKG}" > "${STAMP_DIR}/${LIBSNARK_STAMP}" || die

	# Symlink dependencies
	ln -s "${DISTDIR}"/${BDB_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${GMOCK_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${GTEST_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${LIBSNARK_PKG} "${DEP_SRC}" || die

	if use proton; then
		echo "${PROTON_HASH} ${PROTON_ARCH}" > "${STAMP_DIR}/${PROTON_STAMP}" || die
		ln -s "${DISTDIR}"/${PROTON_ARCH} "${DEP_SRC}" || die
	fi

	if use rust; then
		echo "${RUSTZCASH_HASH} ${RUSTZCASH_PKG}" > "${STAMP_DIR}/${RUSTZCASH_STAMP}" || die
		ln -s "${DISTDIR}"/${RUSTZCASH_PKG} "${DEP_SRC}" || die

		# No need to build the bundled rust
		sed -i 's:$(package)_dependencies=.*::g' \
			depends/packages/librustzcash.mk || die
	fi

	# No need to build the bundled libgmp and libsodium
	sed -i 's:$(package)_dependencies=.*::g' \
		depends/packages/libsnark.mk || die

	pushd depends > /dev/null || die
	ebegin "Building bundled dependencies"
	LIBS=( bdb googletest googlemock libsnark
		$(usex rust librustzcash '')
		$(usex proton proton '')
	)
	for X in "${LIBS[@]}"; do
		make ${X} || die
	done
	for X in "${LIBS[@]}"; do
		tar -xzf built/x86_64-unknown-linux-gnu/${X}/${X}-*.tar.gz \
		-C x86_64-unknown-linux-gnu || die
	done
	eend $?
	popd > /dev/null || die

	default
	eautoreconf
}

src_configure() {
	append-cppflags "-I${S}/depends/x86_64-unknown-linux-gnu/include"
	append-ldflags "-L${S}/depends/x86_64-unknown-linux-gnu/lib \
		-L${S}/depends/x86_64-unknown-linux-gnu/lib64"

	econf \
		--prefix="${EPREFIX}"/usr \
		--disable-ccache \
		--disable-tests \
		$(use_enable hardened hardening) \
		$(use_enable mining) \
		$(use_enable proton) \
		$(use_enable reduce-exports) \
		$(use_enable rust) \
		$(use_enable zeromq zmq) \
		$(use_with libs) \
		|| die "econf failed"
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r2 ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd-r2 ${PN}.conf

	insinto /etc/zcash
	doins "${FILESDIR}"/${PN}.conf
	fowners zcash:zcash /etc/zcash/${PN}.conf
	fperms 0600 /etc/zcash/${PN}.conf
	newins contrib/debian/examples/${PN}.conf ${PN}.conf.example

	local X
	for X in '-cli' '-tx' 'd'; do
		newbashcomp contrib/bitcoin${X}.bash-completion ${PN}${X}
	done

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	if use examples; then
		docinto examples
		dodoc -r contrib/{bitrpc,qos,spendfrom}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	ewarn
	ewarn "SECURITY WARNINGS:"
	ewarn "Zcash is experimental and a work-in-progress. Use at your own risk."
	ewarn
	ewarn "Please, see important security warnings in"
	ewarn "${EROOT}usr/share/doc/${P}/security-warnings.md.bz2"
	ewarn
	if [ -z "${REPLACING_VERSIONS}" ]; then
		einfo
		elog "You should manually fetch the parameters for all users:"
		elog "$ zcash-fetch-params"
		elog
		elog "This script will fetch the Zcash zkSNARK parameters and verify"
		elog "their integrity with sha256sum."
		elog
		elog "The parameters are currently just under 911MB in size, so plan accordingly"
		elog "for your bandwidth constraints. If the files are already present and"
		elog "have the correct sha256sum, no networking is used."
		einfo
	fi
}
