# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

DESCRIPTION="Free and open source cross-platform YUV viewer with advanced analytics toolset"
HOMEPAGE="https://ient.github.io/YUView"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/ient/YUView.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	SRC_URI="https://github.com/ient/YUView/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/YUView-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	virtual/ffmpeg
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qtcore:5"

src_configure(){
	eqmake5 PREFIX="${EPREFIX}/usr" YUView.pro
}

src_install(){
	emake INSTALL_ROOT="${D}" install
	exeinto /usr/$(get_libdir)/YUView
	doexe libde265/libde265-internals.so
	insinto /usr/$(get_libdir)/YUView
	doins libde265/libde265.so.0
}

pkg_postinst(){
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm(){
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
