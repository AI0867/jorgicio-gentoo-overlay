# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils user git-r3

DESCRIPTION="Tracking software for asset recovery, now Node.js-powered"
HOMEPAGE="http://preyproject.com"
SRC_URI=""
EGIT_REPO_URI="https://github.com/${PN}/${PN}-node-client"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+openrc"

DEPEND="
	virtual/cron
	net-libs/nodejs[npm]
	dev-python/pygtk
	media-tv/xawtv
	sys-apps/net-tools
	|| ( media-gfx/scrot media-gfx/imagemagick )
	app-laptop/laptop-detect
	|| ( gnome-extra/zenity kde-base/kdialog )
	media-sound/mpg123
	media-sound/pulseaudio
	net-wireless/wireless-tools
	sys-apps/lsb-release
	openrc? ( sys-apps/openrc )
	"
RDEPEND="${DEPEND}"

src_install(){
	npm install -g --prefix="${D}/usr"
	make_desktop_entry 'prey config gui' "Prey Configuration" ${PN} "System;Monitor"
	insinto /etc/cron.d
	insopts -m644
	doins "${FILESDIR}/prey.cron"
	insinto /etc/prey
	insopts -m644
	newins ${PN}.conf.default ${PN}.conf
}

pkg_postinst(){
	prey config hooks post_install
	if use openrc;then
		rm /etc/init.d/prey-agent
		install -m755 ${FILESDIR}/prey-agent /etc/init.d
	fi
	elog "Don't forget add your user to the group prey (as root):"
	elog "gpasswd -a username prey"
	elog "After that, you must run the prey-agent daemon."
}
