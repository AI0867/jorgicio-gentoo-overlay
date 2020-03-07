# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="A Vim-inspired note taking application that knows programmers and Markdown better"
HOMEPAGE="https://github.com/tamlok/vnote"
HOEDOWN_VERSION="4.0.0"
SRC_URI="
	${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/tamlok/hoedown/archive/${HOEDOWN_VERSION}.tar.gz -> hoedown-${HOEDOWN_VERSION}.tar.gz
"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

LICENSE="MIT"
SLOT="0"

DEPEND="
	>=dev-qt/qtcore-5.9:5=
	>=dev-qt/qtwebengine-5.9:5=
	>=dev-qt/qtsvg-5.9:5=
"
RDEPEND="${DEPEND}"

pkg_setup(){
	export INSTALL_ROOT="${D}"
}

src_unpack() {
	default
	mv "${WORKDIR}/hoedown-${HOEDOWN_VERSION}"/* "${S}/hoedown" || die
}

src_configure(){
	eqmake5 VNote.pro
}
