# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Qt-based application for WhatsApp Web"
HOMEPAGE="https://gitlab.com/scarpetta/qtwaw"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
else
	inherit vcs-snapshot
	SRC_URI="${HOMEPAGE}/-/archive/v${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	kde-frameworks/kdbusaddons:5
	kde-frameworks/knotifications:5"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
