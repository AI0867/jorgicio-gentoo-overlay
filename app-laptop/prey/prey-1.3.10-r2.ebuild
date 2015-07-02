# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils user git-r3

DESCRIPTION="Tracking software for asset recovery, now Node.js-powered"
HOMEPAGE="http://preyproject.com"
SRC_URI=""
EGIT_REPO_URI="https://github.com/${PN}/${PN}-node-client"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
		app-shells/bash
		virtual/cron
		net-libs/nodejs[npm]
		dev-python/pygtk
		|| ( net-misc/curl net-misc/wget )
        dev-perl/IO-Socket-SSL
        dev-perl/Net-SSLeay
        sys-apps/net-tools
		|| ( media-gfx/scrot media-gfx/imagemagick )
		app-laptop/laptop-detect
		|| ( media-video/mplayer[encode,jpeg,v4l] media-tv/xawtv )
		net-analyzer/traceroute
		|| ( gnome-extra/zenity kde-base/kdialog )
		media-sound/mpg123
		media-sound/pulseaudio
		sys-apps/iproute2
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
