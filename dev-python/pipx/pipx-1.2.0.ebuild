# Copyright 1999-2021 Jorgigio Gentoo Overlay Fork Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Execute binaries from Python packages in isolated environments"
HOMEPAGE="https://pypa.github.io/pipx/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pypa/${PN}"
else
	SRC_URI="https://github.com/pypa/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/userpath[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/mkdocs[${PYTHON_USEDEP}]
	)"
