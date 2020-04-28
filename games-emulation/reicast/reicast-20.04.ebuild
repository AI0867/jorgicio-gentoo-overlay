# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xdg

DESCRIPTION="A Dreamcast Emulator"
HOMEPAGE="https://reicast.com"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/reicast/${PN}-emulator"
else
	SRC_URI="https://github.com/reicast/${PN}-emulator/archive/r${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-emulator-r${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="joystick pulseaudio sdl"

DEPEND="
	media-libs/alsa-lib
	media-libs/mesa[egl,gles2]
	virtual/libudev
	virtual/opengl
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl2[video,sound,joystick?] )"
RDEPEND="${DEPEND}"

src_prepare() {
	use pulseaudio && export USE_PULSEAUDIO=1
	if use sdl; then
		export USE_SDL=1
		export USE_SDL_AUDIO=1
	fi
	use joystick && export USE_JOYSTICK=1
	default
}

src_compile() {
	FLAGS="PREFIX=/usr CC=$(tc-getCC) CXX=$(tc-getCXX) "
	FLAGS+="AS=$(tc-getAS) STRIP=$(tc-getSTRIP) LD=$(tc-getLD)"
	emake -C ${PN}/linux ${FLAGS}
}

src_install() {
	emake -C ${PN}/linux \
		DESTDIR="${ED}" \
		${FLAGS} install
}
