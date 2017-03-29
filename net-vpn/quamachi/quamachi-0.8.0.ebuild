# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{3,4,5,6} )

inherit python-r1 eutils

DESCRIPTION="A QT5-based Hamachi GUI for Linux"
HOMEPAGE="http://Quamachi.Xavion.name"
SRC_URI="mirror://sourceforge/${PN}/${PN^}-${PV}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	dev-python/PyQt5[X,${PYTHON_USEDEP}]
	>=net-vpn/logmein-hamachi-2.1
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN^}/Build"

src_install(){
	emake DESTDIR="${D}" Sys-SBin="/usr/bin" install
}
