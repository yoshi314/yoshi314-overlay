# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic toolchain-funcs versionator games

MY_PN="hexen2"
MY_PV=$(replace_version_separator 3 '-')
DATA_PV="1.29b"
DEMO_PV="1.11"
HW_PV="0.15"
LIT_PV="20140628"

DESCRIPTION="Hexen II source port - Hammer of Thyrion"
HOMEPAGE="http://uhexen2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}source-${MY_PV}.tgz
	mirror://sourceforge/${PN}/gamedata-all-${DATA_PV}.tgz
	demo? ( mirror://sourceforge/${PN}/${MY_PN}demo-pakfiles-${DEMO_PV}.tgz )
	hexenworld? ( mirror://sourceforge/${PN}/hexenworld-pakfiles-${HW_PV}.tgz )
	lights? ( mirror://sourceforge/${PN}/${MY_PN}-litfiles-${LIT_PV}.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa cdda +client debug dedicated demo gtk hexenworld lights +mad +midi +mp3 mpg123 +ogg opengl opus oss sdlaudio static +sound +timidity tools tremor +vorbis +wav wildmidi cpu_flags_x86_mmx"
REQUIRED_USE="
	|| ( client dedicated tools )
	mp3? ( || ( mad mpg123 ) )
	mad? ( mp3 )
	mpg123? ( mp3 )
	midi? ( || ( timidity wildmidi ) )
	timidity? ( midi )
	wildmidi? ( midi )
	ogg? ( || ( tremor vorbis ) )
	tremor? ( ogg )
	vorbis? ( ogg )
"
GUIDEPEND=">=media-libs/libsdl-1.2.15-r8
	gtk? ( >=x11-libs/gtk+-2.24.25:2 )
	opengl? ( >=virtual/opengl-7.0-r1 )
	alsa? ( >=media-libs/alsa-lib-1.0.27.2 )
	midi? (
		timidity? ( >=media-sound/timidity++-2.13.2-r13 )
		wildmidi? ( >=media-sound/wildmidi-0.2.3.5 )
	)
	mp3? (
		mad? ( >=media-libs/libmad-0.15.1b-r6 )
		mpg123? ( >=media-sound/mpg123-1.18.1 )
	)
	ogg? (
		tremor? ( >=media-libs/tremor-0_pre20130223 )
		vorbis? ( >=media-libs/libvorbis-1.3.3-r1 )
	)
	opus? (
		>=media-libs/opus-1.0.2-r2
		>=media-libs/opusfile-0.4
	)"
RDEPEND="client? ( ${GUIDEPEND} )"
DEPEND="${RDEPEND}
	x86? ( cpu_flags_x86_mmx? ( || (
		>=dev-lang/nasm-2.11.06
		>=dev-lang/yasm-1.2.0
	) ) )"

S=${WORKDIR}/${MY_PN}source-${MY_PV}
dir=${GAMES_DATADIR}/${MY_PN}

yesno() {
	local yesno="yes"
	for f in "$@" ; do use ${f} || yesno="no" ; done
	echo ${yesno}
}

pkg_setup() {
	games_pkg_setup
}

src_prepare() {
	use demo && dir=${GAMES_DATADIR}/${MY_PN}/demo
	gl=""

	if use opengl ; then
		gl="gl"
		sed -i \
			-e "/BIN_OGL_PREFIX/s:\"gl\":\"\":" \
			launcher/games.h					
	fi

	sed -i \
		-e "/GAME_DATADIR/s:\".*\":\"${dir}\":" \
		launcher/games.h					

	sed -i \
		-e "/desired_speed/s:= [0-9]*;:= 44100;:" \
		engine/h2shared/snd_dma.c		

	sed -i \
		-e "/parms.basedir/s:cwd:\"${dir}\":" \
		engine/{hexen2{,/server},hexenworld/{client,server}}/sys_unix.c	
}

src_compile() {
	use demo && dir=${GAMES_DATADIR}/${MY_PN}/demo
	local g_opts=""

	use debug	&& g_opts+=" DEBUG=1"
	use demo	&& g_opts+=" DEMO=1"

	local c_opts=" \
		LINK_GL_LIBS=$(yesno static) \
		USE_SOUND=$(yesno sound) \
		USE_CDAUDIO=$(yesno cdda) \
		USE_ALSA=$(yesno alsa) \
		USE_OSS=$(yesno oss) \
		USE_SDLAUDIO=$(yesno sdlaudio) \
		USE_MIDI=$(yesno midi) \
		USE_CODEC_TIMIDITY=$(yesno timidity) \
		USE_CODEC_WILDMIDI=$(yesno wildmidi) \
		USE_CODEC_MP3=$(yesno mp3) \
		USE_CODEC_OPUS=$(yesno opus) \
		USE_CODEC_VORBIS=$(yesno ogg) \
		USE_CODEC_WAVE=$(yesno wav) \
		USE_X86_ASM=$(yesno x86 cpu_flags_x86_mmx) \
	"
	use mad				|| c_opts+=" MP3LIB=mpg123"
	use vorbis			|| c_opts+=" VORBISLIB=tremor"
	has_version dev-lang/nasm	|| c_opts+=" NASM=yasm"

	if use client ; then
		cd ${S}/engine/${MY_PN}
		einfo "\nBuilding UHexen2 game executable(s)"

		emake clean
		emake \
			${g_opts} \
			${c_opts} \
			CPUFLAGS="${CFLAGS} -ffast-math" \
			${gl}h2							

		if use gtk ; then
			cd ${S}/launcher
			einfo "\nBuilding graphical launcher"

			emake clean
			emake \
				${g_opts} \
				CPUFLAGS="${CFLAGS} -ffast-math"
		fi

		if use hexenworld ; then
			cd ${S}/engine/hexenworld
			einfo "\nBuilding Hexenworld servers"

			emake -C server clean
			emake \
				${g_opts} \
				CPUFLAGS="${CFLAGS} -ffast-math" \
				-C server				

			einfo "\nBuilding Hexenworld client(s)"

			emake -C client clean
			emake \
				${g_opts} \
				${c_opts} \
				CPUFLAGS="${CFLAGS} -ffast-math" \
				${gl}hw \
				-C client 		
		fi
	fi

	if use dedicated ; then
		cd ${S}/engine/${MY_PN}
		einfo "\nBuilding Dedicated Server"

		emake -C server clean
		emake \
			${g_opts} \
			CPUFLAGS="${CFLAGS} -ffast-math" \
			-C server					
	fi

	if use tools ; then
		cd ${S}/utils
		einfo "\nBuilding utils"

		local utils_list+="bspinfo dcc genmodel hcc jsh2color light pak qbsp qfiles texutils/bsp2wal texutils/lmp2pcx vis"
		for x in ${utils_list} ; do
			emake -C ${x} clean
			emake \
				${g_opts} \
				CPUFLAGS="${CFLAGS} -ffast-math" \
				-C ${x}					
		done

		if use hexenworld ; then
			cd ${S}/hw_utils
			einfo "\nBuilding Hexenworld utils"

			local hw_utils="hwmaster hwmquery hwrcon"
			for x in ${hw_utils} ; do
				emake -C ${x} clean
				emake \
					${g_opts} \
					CPUFLAGS="${CFLAGS} -ffast-math" \
					-C ${x}				
			done
		fi
	fi
}

src_install() {
	if use demo ; then
		insinto "${dir}"/data1/maps
		doins ${WORKDIR}/data1/maps/demo*			
		rm -rf ${WORKDIR}/data1/maps
	else
		insinto "${dir}"
		doins -r ${WORKDIR}/portals				
		rm -f ${WORKDIR}/data1/maps/demo*
	fi

	insinto "${dir}"
	doins -r ${WORKDIR}/data1					

	dodoc docs/README{,.hwcl,.hwmaster,.hwsv,.music}		

	if use client ; then
		newgamesbin engine/hexen2/${gl}hexen2 ${MY_PN}		
		newicon engine/resource/hexen2n.png ${MY_PN}.png	
		make_desktop_entry ${MY_PN} "Hexen II" ${MY_PN}

		if use gtk ; then
			newgamesbin launcher/h2launcher ${MY_PN}-launcher
			make_desktop_entry ${MY_PN}-launcher "Hexen II Launcher" ${MY_PN}
		fi

		if use hexenworld ; then
			rm -f ${WORKDIR}/hw/pak4_readme.txt

			insinto "${dir}"
			doins -r ${WORKDIR}/hw

			newgamesbin engine/hexenworld/server/hwsv hwsv	
			newgamesbin engine/hexenworld/client/${gl}hwcl hwcl	

			doicon engine/resource/hexenworld.png		
			make_desktop_entry hwcl "Hexen II Hexenworld Client" hexenworld
		fi
	fi

	if use dedicated ; then
		insinto "${dir}"/data1
		doins -r ${WORKDIR}/siege/server.cfg			

		newgamesbin engine/hexen2/server/h2ded ${MY_PN}-ded	
	fi

	if use tools ; then
		dobin utils/bspinfo/bspinfo				
		dobin utils/dcc/dhcc					
		dobin utils/genmodel/genmodel				
		dobin utils/hcc/hcc					
		dobin utils/jsh2color/jsh2colour			
		dobin utils/light/light						
		dobin utils/pak/paklist					
		dobin utils/pak/pakx				
		dobin utils/qbsp/qbsp			
		dobin utils/qfiles/qfiles	
		dobin utils/texutils/lmp2pcx/lmp2pcx
		dobin utils/texutils/bsp2wal/bsp2wal
		dobin utils/vis/vis				

		docinto utils
		dodoc utils/README			
		dodoc utils/dcc/dcc.txt	
		newdoc utils/dcc/README README.dcc		
		newdoc utils/hcc/README README.hcc	
		newdoc utils/jsh2color/README README.jsh2color	
		newdoc utils/jsh2color/ChangeLog ChangeLog.jsh2color

		if use hexenworld ; then
			dobin hw_utils/hwmaster/hwmaster
			dobin hw_utils/hwmquery/hwmquery
			dobin hw_utils/hwrcon/{hwrcon,hwterm}	

			docinto utils
			dodoc hw_utils/hwmquery/hwmquery.txt
			dodoc hw_utils/hwrcon/{hwrcon,hwterm}.txt
		fi
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog
	if use client ; then
		if use demo ; then
			elog "UHexen2 has been compiled specifically to play the demo maps."
			elog
		else
			elog "To play the game, you must install the game data files."
			elog "You must manually copy the pak0.pak and pak1.pak files to"
			elog "${dir}/data1"
			elog
			elog "In order to play the Portal of Praevus expansion pack,"
			elog "you must also manually copy the pak3.pak file to"
			elog "${dir}/portals"
			elog
			elog "To play the demo, emerge with the 'demo' USE flag."
			elog
		fi
		if use gtk ; then
			elog "To use a graphical launcher, run: hexen2-launcher"
			elog
		fi
	fi
	if use dedicated ; then
		elog "To start the dedicated server, run: hexen2-ded"
		elog
	fi
	if use tools ; then
		elog "You've installed some Hexen2 utilities"
		elog "(useful for mod developing)"
		elog
		elog " - map compiling tools: bspinfo, light, qbsp, vis"
		elog " - tools for viewing and extracting .pak files: paklist, pakx"
		elog " - dhcc (old progs.dat compiler/decompiler)"
		elog " - genmodel (3-D model grabber)"
		elog " - hcc (HexenC compiler)"
		elog " - jsh2color (light colouring utility)"
		elog " - qfiles (build pak files and regenerate bsp models)"
		elog " - bsp2wal (extract all textures from a bsp file)"
		elog " - lmp2pcx (convert hexen2 texture data into pcx and tga)"
		elog
		if use hexenworld ; then
			elog "Besides that, you've also installed some Hexenworld utilities:"
			elog
			elog " - hwmquery (console app to query HW master servers)"
			elog " - hwrcon (remote interface to HW rcon command)"
			elog " - hwterm (HW remote console terminal)"
			elog
		fi
	fi
}
