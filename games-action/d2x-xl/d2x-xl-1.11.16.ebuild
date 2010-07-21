# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils games

SRC_D2X="http://www.descent2.de/downloads"
SRC_DIEDEL="http://diedel.koolbear.com/downloads"
SRC_KOOLBEAR="http://www.koolbear.com/cgi-bin/dl/dirwrap.cgi?rt=count&path=Descent/levels/d2/D2-XL/Hi-Rez_Textures"
SRC_FILE="${PN}-src-${PV}.rar"

DESCRIPTION="Descent 2 engine supporting high-resolution textures"
HOMEPAGE="http://www.descent2.de/"
# www.descent2.de must be *first* in the SRC_URI list, because
# all the sourceforge links exhaust Portage's retry patience.
SRC_URI="${SRC_D2X}/${SRC_FILE}
	mirror://sourceforge/${PN}/${SRC_FILE}
	http://homepage.mac.com/simx/hoard.ham.zip
	${SRC_DIEDEL}/extra-hog.rar
	${SRC_KOOLBEAR}/hires-ceilings.rar
	${SRC_KOOLBEAR}/hires-doors.rar
	${SRC_KOOLBEAR}/hires-fans-grates.rar
	${SRC_KOOLBEAR}/hires-lava-water.rar
	${SRC_KOOLBEAR}/hires-metal.rar
	${SRC_KOOLBEAR}/hires-missiles.rar
	${SRC_KOOLBEAR}/hires-models.rar
	${SRC_KOOLBEAR}/hires-powerups.rar
	${SRC_KOOLBEAR}/hires-rock.rar
	${SRC_KOOLBEAR}/hires-signs.rar
	${SRC_KOOLBEAR}/hires-special.rar
	${SRC_KOOLBEAR}/hires-switches.rar"


# For license, see bug #117344
LICENSE="D1X"
SLOT="0"
KEYWORDS="~x86"
IUSE="cdinstall debug icon models"

# Depends on timidity++ to ensure that midi is set up
UIRDEPEND="media-libs/alsa-lib
	media-libs/libpng
	>=media-libs/libsdl-1.2.11
	>=media-libs/sdl-mixer-1.2.7
	>=media-libs/sdl-image-1.2.3-r1
	media-sound/timidity++
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext"
# Can use the demo data
RDEPEND="${UIRDEPEND}
	cdinstall? ( games-action/descent2-data )
	!cdinstall? ( games-action/descent2-demodata )
	models? ( games-action/descent2-models )"
DEPEND="${UIRDEPEND}
	icon? ( media-gfx/icoutils )
	x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto
	x11-proto/xproto
	app-arch/unzip
	|| (
		app-arch/unrar
		app-arch/rar )"

S=${WORKDIR}
dir=${GAMES_DATADIR}/d2x

src_unpack() {
	unpack ${A}

	# unpack is temporarily broken - see bug #196565
	#unpack ./d2x-xl-makefiles.rar
	unrar x -idq -o+ d2x-xl-makefiles.rar || die "unrar"

	if use icon ; then
		icotool -x descent.ico || die "icotool"
	fi

	# Subdirectories are confusing - don't use them if possible
	local d
	for d in data missions models textures screenshots ; do
		[[ -e "${d}" ]] && mv -f "${d}"/* .
	done

	# Game files must be in lower-case
	mv EXTRA.HOG extra.hog || die

	# Need "missions" directory, for the missions to be recognized
	mkdir -p missions
	for f in $(ls *.{hog,msn,mn2}) ; do
		mv -f "${f}" missions || die "mv ${f}"
	done

	# These files are sometimes saved in the wrong format
	edos2unix configure.ac || die
	edos2unix depcomp || die

	sed -i \
		-e "s:1.2.8:$(sdl-config --version):" \
		configure.ac || die "sed configure.ac"

	# For eautoreconf
	chmod +x configure || die "chmod +x"

	# Make the default directory standard
	sed -i \
		-e "s:/usr/local/games/${PN}:${dir}:" \
		main/inferno.c || die "sed inferno.c"

	# Hide the temporary midi file in $HOME
	sed -i \
		-e "s:%s/d2x-temp.mid:%s/.${PN}/d2x-temp.mid:" \
		arch/linux/midi.c || die "sed midi.c"

	eautoreconf || die "eautoreconf"
}

src_compile() {
	local debug_opts="--disable-debug --enable-release"
	use debug && debug_opts="--enable-debug --disable-release"

	egamesconf \
		--disable-assembler \
		--with-opengl \
		${debug_opts} \
		--with-sharepath="${dir}" \
		|| die "egamesconf"

	emake || die "emake"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin"

	# Recommended options at http://www.descent2.de/d2x-switches.html
	local options="-fullscreen -grabmouse -nocdrom -nomovies 1 -sound22k -render_quality 3 -renderpath 1 -gl_alttexmerge -playermessages -pps 20 -render2texture 1 -menustyle 1 -fastmenus 1 -sdl_mixer 1 -use_d1sounds 1 -altbg_name menubg.tga -altbg_brightness 0.75 -altbg_alpha -1.0 -altbg_grayscale 0 -enable_lightmaps 1 -hires_textures 1 -hires_models 1 -gl_reticle 1 -use_shaders 1 -mathformat 2"
	games_make_wrapper ${PN}-common "${PN} ${options}"

	if use icon ; then
		newicon descent_1_32x32x4.png ${PN}.png || die "newicon"
	fi
	make_desktop_entry ${PN}-common "Descent 2 XL" ${PN}.png

	insinto "${dir}"
	# hoard.ham is required for multiplayer.
	# Using "ls" to stop doins from failing when files do not exist.
	local f
	for f in $(ls *.{ham,mvl,ogf,oof,p11,p22,pcx,pig,plr,s11,s22,sg0,tga}) ; do
		doins "${f}" || die "doins ${f}"
	done
	doins -r missions || die "doins -r missions"

	# These docs may be empty files, in which case they are not installed
	for f in $(ls AUTHORS ChangeLog NEWS README *.txt) ; do
		dodoc "${f}"
	done

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	echo
	elog "To play the game with common options, run:  d2x-xl-common"
	echo
}
