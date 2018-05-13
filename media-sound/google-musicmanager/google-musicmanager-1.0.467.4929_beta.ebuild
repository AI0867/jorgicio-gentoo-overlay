# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils unpacker

DESCRIPTION="An application for adding music to your Google Music library"
HOMEPAGE="https://music.google.com"
SRC_URI="amd64? ( https://dl.google.com/linux/musicmanager/deb/pool/main/${P:0:1}/${PN}-beta/${PN}-beta_${PV/_beta}-r0_amd64.deb )"

LICENSE="Google-TOS Apache-2.0 MIT LGPL-2.1 gSOAP BSD FDL-1.2 MPL-1.1 openssl ZLIB libtiff"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="log"

RESTRICT="strip mirror"

RDEPEND="
	dev-libs/expat
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwebkit:5
	dev-qt/qtsingleapplication
	media-libs/flac
	media-libs/libvorbis
	<net-dns/libidn-1.35
	sys-libs/glibc
	log? ( dev-libs/log4cxx )
	"

DEPEND="app-arch/xz-utils
	app-admin/chrpath"

INSTALL_BASE="opt/google/musicmanager"

QA_PREBUILT="${INSTALL_BASE}/*"

S="${WORKDIR}/${INSTALL_BASE}"

src_install() {
	insinto "/${INSTALL_BASE}"
	doins config.json product_logo* lang.*.qm

	exeinto "/${INSTALL_BASE}"
	chrpath -d MusicManager || die
	doexe MusicManager google-musicmanager minidump_upload
	#TODO unbundle this
	doexe libaacdec.so libaudioenc.so.0 libmpgdec.so.0 libid3tag.so

	dosym /"${INSTALL_BASE}"/google-musicmanager /opt/bin/google-musicmanager

	local icon size
	for icon in product_logo_*.png; do
		size=${icon#product_logo_}
		size=${size%.png}
		newicon -s "${size}" "${icon}" ${PN}.png
	done
	domenu ${PN}.desktop
}
