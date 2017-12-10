# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

SQUASH_DEP=(
	"BRIEFLZ jibsen/brieflz 63760a061c5ac8a70aba4ed25a2b2efec650eade"
	"BSC IlyaGrebnov/libbsc 3dea3471251fbac72c895f42f22a1aa75b81da33"
	"CSC fusiyuan2010/CSC c5dbe0944d07acbc97d2c04ec9f99a139c6f3931"
	"DENSITY centaurean/density a05d383c58471f57904c17fd39b3f76fb5bc674d"
	"DOBOZ nemequ/doboz d03e0f9c1d66ec34d68c439b410ac7f0b1935bd5"
	"FARI davidcatt/FastARI e1e87aad2bb5d45d14502e2b54802c61950a6166"
	"FASTLZ svn2github/fastlz 9ed1867d81a18cbda42805e7238e2dd5997dedfc"
	"GIPFELI google/gipfeli 04fe241e27f6dcfef239afc6c5e3cee0b4d7c333"
	"HEATSRK atomicobject/heatshrink 7d419e1fa4830d0b919b9b6a91fe2fb786cf3280"
	"LIBDFLT ebiggers/libdeflate a32bdb097de48e5ddffc959a58297d384b58fcaa"
	"LZF nemequ/liblzf fb25820c3c0aeafd127956ae6c115063b47e459a"
	"LZFSE lzfse/lzfse 497c5c176732769abf36ccc71a31c06bad93a84d"
	"LZG mbitsnbites/liblzg 035f0aad8e645d449389fe17c757e38f54b4d995"
	"LZHAM richgel999/lzham_codec_devel 7f1bb9223abfad330797e436254df738c7f52551"
	"LZJB nemequ/lzjb 4544a180ed2ecfed8228d580253fbeaaae1fd2b4"
	"MINIZ richgel999/miniz 28f5066e332590c8a68fa4870e89233e72ce7a44"
	"MSC coderforlife/ms-compress e5d8cc5f4396be26c2c3ccc13fe59ce3a8885fea"
	"WFLZ ShaneYCG/wflz e742c4bad7b3427fb3eeb1fc5af361af9d517a66"
	"ZLIBNG Dead2/zlib-ng 45a5149c6a8309c83ea81bce95279a41f31c730c"
	"ZLING richox/libzling 40ec9ee83abde8ca0539b6f31bf5961cd38f7c66"
	"ZPAQ zpaq/zpaq 9ab539f644e364f0d92e2918b90ce2534c75653f"
	"HEDLEY nemequ/hedley 5ea407f445de331cbf7e4636857078fc3cd15994"
	"TINYC tinycthread/tinycthread 6957fc8383d6c7db25b60b8c849b29caab1caaee"
	"WICONV win-iconv/win-iconv 9f98392dfecadffd62572e73e9aba878e03496c4"
	"MUNIT nemequ/munit 389aef009e8773a030939bd4fc3cc0af6f865ea1"
	"PARG jibsen/parg 97f3a075109ebace4f660fb341c6b99b2a4b092a"
)

YALZ_PV="6810061c57dd"
YALZ_P="tkatchev-yalz77-${YALZ_PV}"

for sd in "${SQUASH_DEP[@]}"; do
	sd=(${sd})
	readonly ${sd[0]}_PV=${sd[2]} \
		${sd[0]}_P=${sd[1]#*/}-${sd[2]} \
		${sd[0]}_URI=https://github.com/${sd[1]}/archive/${sd[2]}.tar.gz
done

GIT_COMMIT="bcf1acf1661ead91d9201f4b2a6616a884cebbef"
DESCRIPTION="Compression abstraction library and utilities"
HOMEPAGE="https://quixdb.github.io/squash/"
SRC_URI="https://github.com/quixdb/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://bitbucket.org/tkatchev/yalz77/get/${YALZ_PV}.tar.gz -> ${YALZ_P}.tar.gz
	${BRIEFLZ_URI} -> ${BRIEFLZ_P}.tar.gz
	${BSC_URI} -> ${BSC_P}.tar.gz
	${CSC_URI} -> ${CSC_P}.tar.gz
	${DENSITY_URI} -> ${DENSITY_P}.tar.gz
	${DOBOZ_URI} -> ${DOBOZ_P}.tar.gz
	${FARI_URI} -> ${FARI_P}.tar.gz
	${FASTLZ_URI} -> ${FASTLZ_P}.tar.gz
	${GIPFELI_URI} -> ${GIPFELI_P}.tar.gz
	${HEATSRK_URI} -> ${HEATSRK_P}.tar.gz
	${LIBDFLT_URI} -> ${LIBDFLT_P}.tar.gz
	${LZF_URI} -> ${LZF_P}.tar.gz
	${LZFSE_URI} -> ${LZFSE_P}.tar.gz
	${LZG_URI} -> ${LZG_P}.tar.gz
	${LZHAM_URI} -> ${LZHAM_P}.tar.gz
	${LZJB_URI} -> ${LZJB_P}.tar.gz
	${MINIZ_URI} -> ${MINIZ_P}.tar.gz
	${MSC_URI} -> ${MSC_P}.tar.gz
	${WFLZ_URI} -> ${WFLZ_P}.tar.gz
	${ZLIBNG_URI} -> ${ZLIBNG_P}.tar.gz
	${ZLING_URI} -> ${ZLING_P}.tar.gz
	${ZPAQ_URI} -> ${ZPAQ_P}.tar.gz
	${HEDLEY_URI} -> ${HEDLEY_P}.tar.gz
	${TINYC_URI} -> ${TINYC_P}.tar.gz
	${WICONV_URI} -> ${WICONV_P}.tar.gz
	${MUNIT_URI} -> ${MUNIT_P}.tar.gz
	${PARG_URI} -> ${PARG_P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/brotli
	app-arch/lz4
	app-arch/lzop
	app-arch/snappy
	app-arch/xz-utils
	app-arch/zstd
	dev-util/ragel"

DOCS=( AUTHORS NEWS README )

S="${WORKDIR}/${PN}-${GIT_COMMIT}"

src_prepare() {
	local WD PDS pds
	WD="${WORKDIR}"

	PDS=( plugins/brieflz/brieflz
		plugins/bsc/libbsc
		plugins/csc/csc
		plugins/density/density
		plugins/doboz/doboz
		plugins/fari/FastARI
		plugins/fastlz/fastlz
		plugins/gipfeli/gipfeli
		plugins/heatshrink/heatshrink
		plugins/libdeflate/libdeflate
		plugins/lzf/liblzf
		plugins/lzfse/lzfse
		plugins/lzg/liblzg
		plugins/lzham/lzham
		plugins/lzjb/lzjb
		plugins/miniz/miniz
		plugins/ms-compress/ms-compress
		plugins/wflz/wflz
		plugins/yalz77/yalz77
		plugins/zlib-ng/zlib-ng
		plugins/zling/libzling
		plugins/zpaq/zpaq
		squash/hedley
		squash/tinycthread
		squash/win-iconv
		tests/munit
		utils/parg )

	for pds in "${PDS[@]}"; do
		rmdir "${S}/$pds" || die
	done

	# Move dependencies
	mv "${WD}/${BRIEFLZ_P}" "${S}/${PDS[0]}" || die
	mv "${WD}/${BSC_P}" "${S}/${PDS[2]}" || die
	mv "${WD}/${CSC_P}" "${S}/${PDS[3]}" || die
	mv "${WD}/${DENSITY_P}" "${S}/${PDS[4]}" || die
	mv "${WD}/${DOBOZ_P}" "${S}/${PDS[5]}" || die
	mv "${WD}/${FARI_P}" "${S}/${PDS[6]}" || die
	mv "${WD}/${FASTLZ_P}" "${S}/${PDS[7]}" || die
	mv "${WD}/${GIPFELI_P}" "${S}/${PDS[8]}" || die
	mv "${WD}/${HEATSRK_P}" "${S}/${PDS[9]}" || die
	mv "${WD}/${LIBDFLT_P}" "${S}/${PDS[10]}" || die
	mv "${WD}/${LZF_P}" "${S}/${PDS[11]}" || die
	mv "${WD}/${LZFSE_P}" "${S}/${PDS[12]}" || die
	mv "${WD}/${LZG_P}" "${S}/${PDS[13]}" || die
	mv "${WD}/${LZHAM_P}" "${S}/${PDS[14]}" || die
	mv "${WD}/${LZJB_P}" "${S}/${PDS[15]}" || die
	mv "${WD}/${MINIZ_P}" "${S}/${PDS[16]}" || die
	mv "${WD}/${MSC_P}" "${S}/${PDS[17]}" || die
	mv "${WD}/${WFLZ_P}" "${S}/${PDS[18]}" || die
	mv "${WD}/${YALZ_P}" "${S}/${PDS[19]}" || die
	mv "${WD}/${ZLIBNG_P}" "${S}/${PDS[20]}" || die
	mv "${WD}/${ZLING_P}" "${S}/${PDS[21]}" || die
	mv "${WD}/${ZPAQ_P}" "${S}/${PDS[22]}" || die
	mv "${WD}/${HEDLEY_P}" "${S}/${PDS[23]}" || die
	mv "${WD}/${TINYC_P}" "${S}/${PDS[24]}" || die
	mv "${WD}/${WICONV_P}" "${S}/${PDS[25]}" || die
	mv "${WD}/${MUNIT_P}" "${S}/${PDS[26]}" || die
	mv "${WD}/${PARG_P}" "${S}/${PDS[27]}" || die

	default
}
