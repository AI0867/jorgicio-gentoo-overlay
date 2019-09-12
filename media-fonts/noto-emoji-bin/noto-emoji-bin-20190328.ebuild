# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Google Noto Emoji fonts (binary version)"
HOMEPAGE="https://www.google.com/get/noto https://github.com/googlei18n/noto-emoji"
COMMIT="e7490e1841094da518f4672398bdd74ee3c5fcac"
SRC_URI="https://github.com/googlei18n/${PN/-bin}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="!media-fonts/noto-emoji"

S="${WORKDIR}/${PN/-bin}-${COMMIT}/fonts"
FONT_S="${S}"
FONT_SUFFIX="ttf"
FONT_PN="${PN/-bin}"
FONT_CONF=( "${FILESDIR}/56-${PN/-bin}.conf" )

src_prepare() {
	rm LICENSE NotoEmoji-Regular.ttf || die
	default
}
