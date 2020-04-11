# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

MY_PN="uBlock"

DESCRIPTION="An efficient blocker for Chromium and Firefox. Fast and lean."
HOMEPAGE="https://github.com/gorhill/uBlock"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/gorhill/${MY_PN}.git"
else
	MY_PV="${PV/_pre/b}"
	MY_PV="${PV/_rc/rc}"
	MY_P="${MY_PN}-${MY_PV}"
	SRC_URI="https://github.com/gorhill/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="chromium firefox firefox-bin opera thunderbird"
REQUIRED_USE="|| ( chromium firefox firefox-bin opera thunderbird )"

DOCS=( MANIFESTO.md README.md )

src_unpack(){
	[[ ${PV} == 9999 ]] && git-r3_src_unpack || default_src_unpack
	EGIT_REPO_URI="https://github.com/uBlockOrigin/uAssets.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/uAssets"
	[[ ${PV} == 9999 ]] && EGIT_COMMIT_DATE=$(GIT_DIR="${S}/.git" git show -s --format=%ct || die)
	git-r3_src_unpack
}

src_prepare(){
	sed -r -i \
		-e 's/(git.+clone.+)https.+/\1\.\.\/uAssets/' \
		tools/make-assets.sh || die
	default
}

src_compile() {
	if use chromium; then
		tools/make-chromium.sh || die
	fi
	if use firefox || use firefox-bin; then
		tools/make-firefox.sh all || die
	fi
	if use opera; then
		tools/make-opera.sh || die
	fi
	if use thunderbird; then
		tools/make-thunderbird.sh all || die
	fi
	default
}

src_install() {
	if use chromium; then
		insinto "/usr/share/chromium/extensions/${PN}"
		doins -r dist/build/uBlock0.chromium/.
	fi

	if use firefox; then
		insinto "/usr/$(get_libdir)/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
		newins dist/build/uBlock0.firefox.xpi uBlock0@raymondhill.net.xpi
	fi

	if use firefox-bin; then
		insinto "/opt/firefox/extensions/"
		newins dist/build/uBlock0.firefox.xpi uBlock0@raymondhill.net.xpi
	fi

	if use opera; then
		insinto "/usr/$(get_libdir)/opera/extensions/${PN}"
		doins -r dist/build/uBlock0.opera/.
	fi

	if use thunderbird; then
		insinto "/usr/$(get_libdir)/thunderbird/extensions/{3550f703-e582-4d05-9a08-453d09bdfdc6}"
		newins dist/build/uBlock0.thunderbird.xpi uBlock0@raymondhill.net.xpi
	fi
	einstalldocs
}

pkg_postinst(){
	if use chromium; then
		echo
		elog "If you use Chromium/Chrome (or based), the extension is installed in"
		elog "${EROOT}/usr/share/chromium/extensions/"
		elog "To enable ${PN}, follow these steps:"
		echo
		elog "* Go to Chromium/Chrome extensions."
		elog "* Click to check \"Developer mode\""
		elog "* Click \"Load unpacked extension\""
		elog "* In the file selector dialog, search the path mentioned above."
		elog "* Click \"Open\""
		echo
		elog "Then the extension will be available in your browser."
		echo
	fi
}
