# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils toolchain-funcs xdg

DESCRIPTION="Powerful yet simple to use screenshot software for GNU/Linux"
HOMEPAGE="https://flameshot.js.org"
EGIT_REPO_URI="https://github.com/lupoDharkael/${PN}.git"

LICENSE="FreeArt GPL-3+ Apache-2.0"
SLOT="0"

RDEPEND="
	>=dev-qt/qtsvg-5.3.0:5
	>=dev-qt/qtcore-5.3.0:5
	>=dev-qt/qtdbus-5.3.0:5
	>=dev-qt/qtnetwork-5.3.0:5
	>=dev-qt/qtwidgets-5.3.0:5"

DEPEND="
	${RDEPEND}
	>=dev-qt/linguist-tools-5.3.0:5"

src_prepare(){
	sed -i "s#icons#pixmaps#" ${PN}.pro
	sed -i "s#^Icon=.*#Icon=${PN}#" "docs/desktopEntry/package/${PN}.desktop"
	default
}

src_configure(){
	if tc-is-gcc && ver_test "$(gcc-version)" -lt 4.9.2 ;then
		die "You need at least GCC 4.9.2 to build this package"
	fi
	eqmake5 CONFIG+=packaging
}

src_install(){
	INSTALL_ROOT="${ED}" default
}
