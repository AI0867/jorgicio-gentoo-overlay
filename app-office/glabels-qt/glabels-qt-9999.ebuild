# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg

DESCRIPTION="Development version of the next major version of gLabels (4.0)"
HOMEPAGE="https://github.com/jimevins/glabels-qt"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
else
	MASTER_VERSION="master558"
	MY_PV="${PV:0:4}-${MASTER_VERSION}"
	SRC_URI="${HOMEPAGE}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qttranslations:5
	dev-qt/linguist:5
	dev-qt/designer:5
	dev-qt/assistant:5
	dev-qt/qdbusviewer:5
	dev-qt/qtgui:5
	<media-libs/zint-2.7[qt5]
"
RDEPEND="${DEPEND}"
