# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils xdg-utils

DESCRIPTION="A Vim-inspired note taking application that knows programmers and Markdown better"
HOMEPAGE="https://github.com/tamlok/vnote"
EGIT_REPO_URI="${HOMEPAGE}.git"

if [[ ${PV} == 9999 ]];then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	EGIT_COMMIT="v${PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-qt/qtcore-5.9:5=
	>=dev-qt/qtwebengine-5.9:5=
	>=dev-qt/qtsvg-5.9:5=
"
RDEPEND="${DEPEND}"

pkg_setup(){
	export INSTALL_ROOT="${D}"
}

src_configure(){
	eqmake5 VNote.pro
}

pkg_postinst(){
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm(){
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
