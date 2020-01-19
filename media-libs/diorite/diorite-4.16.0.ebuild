# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="threads(+)"
VALA_MIN_API_VERSION="0.42"

inherit python-any-r1 vala waf-utils

DESCRIPTION="Utility and widget library for Nuvola Player project based in GLib, GIO and GTK."
HOMEPAGE="https://github.com/tiliado/diorite"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="${HOMEPAGE}"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="debug"

DEPEND="
	$(vala_depend)
	${PYTHON_DEPS}
	media-gfx/scour
	dev-libs/glib:2
	dev-db/sqlite:3
	dev-libs/gobject-introspection
	dev-libs/libgee:0.8
"
RDEPEND="${DEPEND}
	dev-ruby/ruby-gio2
"

pkg_setup() {
	QA_SONAME="
		/usr/$(get_libdir)/libdioritedb4.so
		/usr/$(get_libdir)/libdioritegtk4.so
		/usr/$(get_libdir)/libdioriteglib4.so"
	python-any-r1_pkg_setup
}

src_prepare(){
	default_src_prepare
	vala_src_prepare
}

src_configure(){
	local myconf=()
	use !debug && myconf+=( --nodebug )
	waf-utils_src_configure \
		--no-strict \
		--novaladoc \
		--no-vala-lint \
		"${myconf[@]}"
}
