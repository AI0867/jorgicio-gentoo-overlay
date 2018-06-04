# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="Cross-platform open source music player built with Qt5, QTav and Taglib."
HOMEPAGE="https://mbach.github.io/Miam-Player"

MY_PN="Miam-Player"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MBach/${MY_PN}"
	SRC_URI=""
	KEYWORDS=""
else
	MY_P="${MY_PN}-${PV}"
	SRC_URI="https://github.com/MBach/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="pulseaudio"

DEPEND="
	dev-qt/qtmultimedia:5[alsa,pulseaudio?,gstreamer]
	dev-qt/qtx11extras:5
"
RDEPEND="${DEPEND}
	media-libs/taglib
	media-libs/qtav:0/1[pulseaudio?]
"

src_prepare(){
	for x in {Core,Library,TabPlaylists,UniqueLibrary}; do
		sed -i -e "s/lib\$\$LIB_SUFFIX/\$\$LIB_SUFFIX/" "src/${x}/${x}.pro" || die
	done
	PATCHES="${FILESDIR}/${PN}-add-qheaderview.patch"
	default
}

src_configure(){
	eqmake5 LIB_SUFFIX="$(get_libdir)"
}

src_install(){
	emake INSTALL_ROOT="${D}" install
	newicon debian/usr/share/icons/hicolor/64x64/apps/application-x-${PN//-}.png ${PN}.png
}
