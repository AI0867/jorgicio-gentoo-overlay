# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib versionator qmake-utils autotools git-2

MY_PV="$(replace_all_version_separators _)"
DESCRIPTION="A Qt-based program for syncing your MEGA account in your PC. This is the official app."
HOMEPAGE="http://mega.co.nz"
SRC_URI=""
EGIT_REPO_URI="https://github.com/meganz/MEGAsync"

LICENSE="MEGA"
SLOT="0"
KEYWORDS=""
IUSE="+ares +cryptopp +sqlite libsodium +zlib +curl freeimage readline examples threads +qt4 qt5 nautilus"

REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( 
			dev-qt/qtcore:5
			dev-qt/linguist-tools
		)"
RDEPEND="${DEPEND}
		dev-libs/openssl
		dev-libs/libgcrypt
		media-libs/libpng
		ares? ( net-dns/c-ares )
		cryptopp? ( dev-libs/crypto++ )
		app-arch/xz-utils
		dev-libs/libuv
		sqlite? ( dev-db/sqlite:3 )
		libsodium? ( dev-libs/libsodium )
		zlib? ( sys-libs/zlib )
		curl? ( net-misc/curl[ssl] )
		freeimage? ( media-libs/freeimage )
		readline? ( sys-libs/readline:0 )
		nautilus? (
			>=gnome-base/nautilus-3.12.0
			!!gnome-extra/nautilus-megasync 
			)
		"

src_prepare(){
	git clone "https://github.com/meganz/sdk"
	git submodule init
	git config submodule.src/MEGASync/mega.url sdk
	git submodule update
	cd src/MEGASync/mega
	eautoreconf
}

src_configure(){
	cd "${S}"/src/MEGASync/mega
	econf \
		"--disable-silent-rules" \
		"--disable-curl-checks" \
		"--disable-megaapi" \
		$(use_with zlib) \
		$(use_with sqlite) \
		$(use_with cryptopp) \
		$(use_with ares cares) \
		$(use_with curl) \
		"--without-termcap" \
		$(use_enable threads posix-threads) \
		$(use_with libsodium sodium) \
		$(use_with freeimage) \
		$(use_with readline) \
		$(use_enable examples)	
	cd ../..
	local config_qt="release"
	use nautilus && config_qt+=" with_ext"
	local myeqmakeargs=(
		MEGA.pro
		CONFIG+="${config_qt}"
	)
	if use qt4; then
		eqmake4 ${myeqmakeargs[@]}
		$(qt4_get_bindir)/lrelease MEGASync/MEGASync.pro
	elif use qt5; then
		eqmake5 ${myeqmakeargs[@]}
		$(qt5_get_bindir)/lrelease MEGASync/MEGASync.pro
	fi
}

src_compile(){
	cd "${S}"/src
	emake INSTALL_ROOT="${D}" || die
}

src_install(){
	insinto usr/share/licenses/${PN}
	doins LICENCE.md installer/terms.txt
	cd src/MEGASync
	dobin ${PN}
	cd platform/linux/data
	insinto usr/share/applications
	doins ${PN}.desktop
	cd icons/hicolor
	for size in 16x16 32x32 48x48 128x128 256x256;do
		insinto usr/share/icons/hicolor/$size/apps/mega.png
		doins $size/apps/mega.png
	done
	if use nautilus; then
		cd "${S}/src/MEGAShellExtNautilus"
		insinto usr/lib/nautilus/extensions-3.0
		doins libMEGAShellExtNautilus.so.1.0.0
		cd data/emblems
		for size in 32x32 64x64;do
			insinto usr/share/icons/hicolor/$size/emblems
			doins $size/mega-{pending,synced,syncing,upload}.{icon,png}
			dosym usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1.0.0 usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1.0
			dosym usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1.0.0 usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1
			dosym usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1.0.0 usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so
		done
	fi
}
