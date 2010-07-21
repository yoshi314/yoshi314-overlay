# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="GNU/Linux fork of the discontinued PlayStation emulator PCSX"
HOMEPAGE="http://pcsx-df.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/pcsx-df/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="alsa nls nautilus opengl"

DEPEND=">=x11-libs/gtk+-2
	gnome-base/libglade
	alsa? ( media-libs/alsa-lib )
	nls? ( virtual/libintl )
	bin_image? (
		media-libs/portaudio
		x11-libs/fltk )
	x86? ( dev-lang/nasm )
	opengl? (
		virtual/opengl
		x11-libs/libXxf86vm )
	nautilus? ( gnome-extra/nautilus-cd-burner )"

RDEPEND="${DEPEND}
	!games-emulation/pcsx
	nls? ( sys-devel/gettext )"
DEPEND="${DEPEND}
	x11-proto/videoproto"

RESTRICT="mirror"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s:/lib/games/psemu/:/lib/psemu/plugins/:" \
		-e 's:^icondir = .*:icondir = "/usr/share/pixmaps":' \
		-e 's:-DPIXMAPDIR=\\"${datadir}/pixmaps/\\":-DPIXMAPDIR=\\"/usr/share/pixmaps/\\":' \
		-e 's:-DLOCALE_DIR=\\"${datadir}/locale/\\":-DLOCALE_DIR=\\"/usr/share/locale/\\":' \
		-e "s:^localedir = .*:localedir = /usr/share/locale/:" \
		-e "s:^gnulocaledir = .*:gnulocaledir = /usr/share/locale/:" \
		-e 's:^desktopdir = .*:desktopdir = /usr/share/applications:' \
		$(find . -name "*.in") \
		|| die "sed failed"

	#set some gentoo specific stuff so we'll see other psemu plugins
	sed -i \
		-e "s:/usr/lib/games/psemu/:$(games_get_libdir)/psemu/plugins:" \
		-e "s:/usr/local/lib/games/psemu/:$(games_get_libdir)/psemu/cfg:" \
		-e "s:filename, \".*\\.so$\":filename, \"lib.*\":" \
		gui/Gtk2Gui.c gui/Config.c\
		|| die "sed failed"
	sed -i \
		-e "s:/usr/games/lib\(/psemu/plugins\):$(games_get_libdir)\1:" \
		-e "s:/usr/games/lib\(/psemu/pluginsconfig/\):$(games_get_libdir)\1:" \
		gui/LnxMain.c \
		|| die "sed failed"
}

src_compile() {
	egamesconf --enable-shared=yes --enable-static=no \
		$(use_enable alsa) \
		$(use_enable nls) \
		$(use_enable nautilus nautilusburn) \
		--disable-nautilusburn || die
	emake || die "emake failed"

	if use opengl ; then
		emake -C plugins/dfOpenGL || die "emake failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README doc/keys.txt doc/tweaks.txt ChangeLog
	prepgamesdirs

	#this makes epsxe also happy
	rm -f ${D}/$(games_get_libdir)/psemu/plugins/*.la
	rm -f ${D}/$(games_get_libdir)/psemu/plugins/*.a
	
	#fix for 2-3 equal plugins in pcsx-df and non-working cfg for some of them
	
	mv ${D}/$(games_get_libdir)/psemu/plugins/libDFInput.so.0.0.1 \
	${D}/$(games_get_libdir)/psemu/plugins/libDFInput.so

	mv ${D}/$(games_get_libdir)/psemu/plugins/libdfOpenGL.so.0.0.0 \
	${D}/$(games_get_libdir)/psemu/plugins/libdfOpenGL.so

	rm -f ${D}/$(games_get_libdir)/psemu/plugins/*.so.*
}

pkg_postinst() {
	games_pkg_postinst
	elog "There may be some problems configuring plugins "
	elog "when you run pcsx for the first time."
	elog "So just close it and launch again."
}
