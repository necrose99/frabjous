# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 systemd user

# depends/packages/bdb.mk (http://www.oracle.com, AGPL-3 license)
BDB_PV="6.2.23"
BDB_PKG="db-${BDB_PV}.tar.gz"
BDB_HASH="47612c8991aa9ac2f6be721267c8d3cdccf5ac83105df8e50809daea24e95dc7"
BDB_URI="http://download.oracle.com/berkeley-db/${BDB_PKG}"
BDB_STAMP=".stamp_fetched-bdb-${BDB_PKG}.hash"

# depends/packages/boost.mk (http://www.boost.org, Boost-1.0 license)
BOOST_PV="1.62.0"
BOOST_PKG="boost_${BOOST_PV//./_}.tar.bz2"
BOOST_HASH="36c96b0f6155c98404091d8ceb48319a28279ca0333fba1ad8611eb90afb2ca0"
BOOST_URI="https://downloads.sourceforge.net/project/boost/boost/${BOOST_PV}/${BOOST_PKG}"
BOOST_STAMP=".stamp_fetched-boost-${BOOST_PKG}.hash"

# depends/packages/native_ccache.mk (https://ccache.samba.org, GPL-3 license)
NATIVE_CC_PV="3.3.1"
NATIVE_CC_PKG="ccache-${NATIVE_CC_PV}.tar.bz2"
NATIVE_CC_HASH="cb6e4bafbb19ba0a2ec43386b123a5f92a20e1e3384c071d5d13e0cb3c84bf73"
NATIVE_CC_URI="https://samba.org/ftp/ccache/${NATIVE_CC_PKG}"
NATIVE_CC_STAMP=".stamp_fetched-native_ccache-${NATIVE_CC_PKG}.hash"

# depends/packages/libgmp.mk (https://gmplib.org, LGPL-3+ license)
GMP_PV="6.1.1"
GMP_PKG="gmp-${GMP_PV}.tar.bz2"
GMP_HASH="a8109865f2893f1373b0a8ed5ff7429de8db696fc451b1036bd7bdf95bbeffd6"
GMP_URI="https://gmplib.org/download/gmp/${GMP_PKG}"
GMP_STAMP=".stamp_fetched-libgmp-${GMP_PKG}.hash"

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

# depends/packages/libevent.mk (http://libevent.org, GPL-3 license)
LIBEVENT_PV="2.1.8"
LIBEVENT_PKG="libevent-${LIBEVENT_PV}.tar.gz"
LIBEVENT_HASH="316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d"
LIBEVENT_URI="https://github.com/libevent/libevent/archive/release-${LIBEVENT_PV}-stable.tar.gz"
LIBEVENT_STAMP=".stamp_fetched-libevent-${LIBEVENT_PKG}.hash"

# depends/packages/libsnark.mk (https://github.com/zcash/libsnark, MIT license)
LIBSNARK_PV="9ada3f84ab484c57b2247c2f41091fd6a0916573"
LIBSNARK_PKG="libsnark-${LIBSNARK_PV}.tar.gz"
LIBSNARK_HASH="dad153fe46e2e1f33557a195cbe7d69aed8b19ed9befc08ddcb8c6d3c025941f"
LIBSNARK_URI="https://github.com/zcash/libsnark/archive/${LIBSNARK_PV}.tar.gz"
LIBSNARK_STAMP=".stamp_fetched-libsnark-${LIBSNARK_PKG}.hash"

# depends/packages/libsodium.mk (https://libsodium.org, ISC license)
LIBNa_PV="1.0.11"
LIBNa_PKG="libsodium-${LIBNa_PV}.tar.gz"
LIBNa_HASH="a14549db3c49f6ae2170cbbf4664bd48ace50681045e8dbea7c8d9fb96f9c765"
LIBNa_URI="https://download.libsodium.org/libsodium/releases/${LIBNa_PKG}"
LIBNa_STAMP=".stamp_fetched-libsodium-${LIBNa_PKG}.hash"

# depends/packages/openssl.mk (https://www.openssl.org, openssl license)
OPENSSL_PV="1.1.0d"
OPENSSL_PKG="openssl-${OPENSSL_PV}.tar.gz"
OPENSSL_HASH="7d5ebb9e89756545c156ff9c13cf2aa6214193b010a468a3bc789c3c28fe60df"
OPENSSL_URI="https://www.openssl.org/source/${OPENSSL_PKG}"
OPENSSL_STAMP=".stamp_fetched-openssl-${OPENSSL_PKG}.hash"

# depends/packages/rust.mk (http://www.rust-lang.org, Apache 2.0 / MIT license)
RUST_PV="1.16.0"
RUST_PKG="rust-${RUST_PV}-x86_64-unknown-linux-gnu.tar.gz"
RUST_HASH="48621912c242753ba37cad5145df375eeba41c81079df46f93ffb4896542e8fd"
RUST_URI="https://static.rust-lang.org/dist/${RUST_PKG}"
RUST_STAMP=".stamp_fetched-rust-${RUST_PKG}.hash"

# depends/packages/librustzcash.mk (https://github.com/zcash/librustzcash, Apache 2.0 / MIT license)
RUSTZCASH_PV="91348647a86201a9482ad4ad68398152dc3d635e"
RUSTZCASH_PKG="librustzcash-${RUSTZCASH_PV}.tar.gz"
RUSTZCASH_HASH="a5760a90d4a1045c8944204f29fa2a3cf2f800afee400f88bf89bbfe2cce1279"
RUSTZCASH_URI="https://github.com/zcash/librustzcash/archive/${RUSTZCASH_PV}.tar.gz"
RUSTZCASH_STAMP=".stamp_fetched-librustzcash-${RUSTZCASH_PKG}.hash"

# depends/packages/zeromq.mk (http://www.zeromq.org, LGPL-3 license)
ZEROMQ_PV="4.2.1"
ZEROMQ_PKG="zeromq-${ZEROMQ_PV}.tar.gz"
ZEROMQ_HASH="27d1e82a099228ee85a7ddb2260f40830212402c605a4a10b5e5498a7e0e9d03"
ZEROMQ_URI="https://github.com/zeromq/libzmq/releases/download/v${ZEROMQ_PV}/${ZEROMQ_PKG}"
ZEROMQ_STAMP=".stamp_fetched-zeromq-${ZEROMQ_PKG}.hash"

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
	${BOOST_URI}
	${NATIVE_CC_URI}
	${GMP_URI}
	${GMOCK_URI} -> ${GMOCK_PKG}
	${GTEST_URI} -> ${GTEST_PKG}
	${LIBEVENT_URI} -> ${LIBEVENT_PKG}
	${LIBSNARK_URI} -> ${LIBSNARK_PKG}
	${LIBNa_URI}
	${OPENSSL_URI}
	${ZEROMQ_URI}
	rust? ( ${RUST_URI}
		${RUSTZCASH_URI} -> ${RUSTZCASH_PKG}
		$(cargo_crate_uris ${CRATES})
	)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples hardened libs mining rust"

QA_TEXTRELS="usr/bin/zcash-tx
	usr/bin/zcashd"

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
	local DEP_SRC STAMP_DIR
	DEP_SRC="${S}/depends/sources"
	STAMP_DIR="${DEP_SRC}/download-stamps"

	# Prepare download-stamps
	mkdir -p "${STAMP_DIR}" || die
	echo "${BDB_HASH} ${BDB_PKG}" > "${STAMP_DIR}/${BDB_STAMP}" || die
	echo "${BOOST_HASH} ${BOOST_PKG}" > "${STAMP_DIR}/${BOOST_STAMP}" || die
	echo "${NATIVE_CC_HASH} ${NATIVE_CC_PKG}" > "${STAMP_DIR}/${NATIVE_CC_STAMP}" || die
	echo "${GMP_HASH} ${GMP_PKG}" > "${STAMP_DIR}/${GMP_STAMP}" || die
	echo "${GMOCK_HASH} ${GMOCK_PKG}" > "${STAMP_DIR}/${GMOCK_STAMP}" || die
	echo "${GTEST_HASH} ${GTEST_PKG}" > "${STAMP_DIR}/${GTEST_STAMP}" || die
	echo "${LIBEVENT_HASH} ${LIBEVENT_PKG}" > "${STAMP_DIR}/${LIBEVENT_STAMP}" || die
	echo "${LIBSNARK_HASH} ${LIBSNARK_PKG}" > "${STAMP_DIR}/${LIBSNARK_STAMP}" || die
	echo "${LIBNa_HASH} ${LIBNa_PKG}" > "${STAMP_DIR}/${LIBNa_STAMP}" || die
	echo "${OPENSSL_HASH} ${OPENSSL_PKG}" > "${STAMP_DIR}/${OPENSSL_STAMP}" || die
	echo "${ZEROMQ_HASH} ${ZEROMQ_PKG}" > "${STAMP_DIR}/${ZEROMQ_STAMP}" || die

	# Symlink dependencies
	ln -s "${DISTDIR}"/${BDB_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${BOOST_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${NATIVE_CC_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${GMP_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${GMOCK_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${GTEST_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${LIBEVENT_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${LIBSNARK_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${LIBNa_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${OPENSSL_PKG} "${DEP_SRC}" || die
	ln -s "${DISTDIR}"/${ZEROMQ_PKG} "${DEP_SRC}" || die

	if use rust; then
		echo "${RUST_HASH} ${RUST_PKG}" > "${STAMP_DIR}/${RUST_STAMP}" || die
		echo "${RUSTZCASH_HASH} ${RUSTZCASH_PKG}" > "${STAMP_DIR}/${RUSTZCASH_STAMP}" || die
		ln -s "${DISTDIR}"/${RUST_PKG} "${DEP_SRC}" || die
		ln -s "${DISTDIR}"/${RUSTZCASH_PKG} "${DEP_SRC}" || die
	fi

	if ! use hardened; then
		sed -i 's:--enable-hardening:--disable-hardening:' \
			zcutil/build.sh || die
	fi

	sed -i 's:./b2:./b2 --ignore-site-config:g' \
		depends/packages/boost.mk || die "sed fix failed"

	default
}

src_compile() {
	unset ABI
	./zcutil/build.sh --disable-tests \
		$(usex mining '' --disable-mining) \
		$(usex rust '' --disable-rust) \
		$(usex libs '' --disable-libs) \
		-j$(nproc) || die "Build failed!"
}

src_install() {
	emake prefix="${D}/usr" install \
		|| die "emake install failed"

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	insinto /etc/zcash
	doins "${FILESDIR}"/${PN}.conf
	fowners ${PN}:${PN} /etc/zcash/${PN}.conf
	fperms 0600 /etc/zcash/${PN}.conf
	newins contrib/debian/examples/${PN}.conf ${PN}.conf.example

	keepdir /var/lib/zcashd
	dosym ../../../etc/zcash/${PN}.conf /var/lib/zcashd/${PN}.conf

	dodoc doc/{payment-api,security-warnings,tor}.md

	newbashcomp contrib/bitcoind.bash-completion ${PN}d
	newbashcomp contrib/bitcoin-cli.bash-completion ${PN}-cli
	newbashcomp contrib/bitcoin-tx.bash-completion ${PN}-tx

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

	einfo
	einfo "You should manually fetch the parameters for all users:"
	einfo "$ ${PN}-fetch-params"
	einfo
	einfo "This script will fetch the Zcash zkSNARK parameters and verify"
	einfo "their integrity with sha256sum."
	einfo
	einfo "The parameters are currently just under 911MB in size, so plan accordingly"
	einfo "for your bandwidth constraints. If the files are already present and"
	einfo "have the correct sha256sum, no networking is used."
	einfo
}
