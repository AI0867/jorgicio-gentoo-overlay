# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic gnome2-utils vcs-snapshot xdg-utils

COMMIT="624f69161f4e2f66491ed4bfb981155e922b0c36"

DESCRIPTION="A front-end (GUI) for mednafen emulator"
HOMEPAGE="https://github.com/AmatCoder/mednaffe"
SRC_URI="https://github.com/AmatCoder/mednaffe/archive/${COMMIT}.tar.gz  -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=games-emulation/mednafen-1.21.1[debugger]
	>=x11-libs/gtk+-3.4:3"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

src_prepare() {
	default
	append-cflags -Wl,-export-dynamic
	sed -i -e 's:$(datadir):/usr/share:' share/Makefile.am || die
	eautoreconf
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
