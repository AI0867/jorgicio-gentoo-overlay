# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_SINGLE_TARGET="python2_7"
DISTUTILS_SINGLE_IMPL=1

inherit eutils distutils-r1 ${GIT_ECLASS}

DESCRIPTION="Tweak tool for the MATE Desktop. Fork of mintDesktop."
HOMEPAGE="https://bitbucket.org/ubuntu-mate/${PN}"
if [[ ${PV} == 9999 ]];then
	GIT_ECLASS="git-r3"
	SRC_URI=""
	EGIT_REPO_URI="${HOMEPAGE}.git"
	KEYWORDS=""
	S="${WORKDIR}"
else
	SRC_URI="${HOMEPAGE}/get/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	COMMIT="9dcf744abc9e"
	S="${WORKDIR}/ubuntu-mate-${PN}-${COMMIT}"
fi

LICENSE="LGPL"
SLOT="0"
IUSE=""

DEPEND="mate-base/mate-desktop
		dev-python/setuptools
		dev-python/python-distutils-extra"
RDEPEND="${DEPEND}"

python_install(){
	distutils-r1_python_install
}
