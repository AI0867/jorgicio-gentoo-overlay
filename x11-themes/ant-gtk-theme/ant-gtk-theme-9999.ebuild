# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A flat light theme with a modern look"
HOMEPAGE="https://www.opendesktop.org/p/1099856 https://github.com/EliverLara/Ant"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EliverLara/Ant.git"
else
	SRC_URI="https://github.com/EliverLara/Ant/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/Ant-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	x11-themes/gtk-engines-flat
"
DEPEND="${RDEPEND}"

src_prepare(){
	rm -r *.js* Art || die
	default
}

src_install(){
	insinto "/usr/share/themes/Ant"
	doins -r *
}
