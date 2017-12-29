# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib eutils versionator

DESCRIPTION="ICA Client for Citrix Presentation servers"
HOMEPAGE="http://www.citrix.com/"
SRC_URI="amd64? ( linuxx64-${PV}.tar.gz )"
	#x86? ( linuxx86-${PV}.tar.gz )"

LICENSE="icaclient"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="minimal gstreamer010 nsplugin linguas_de linguas_es linguas_fr linguas_ja linguas_zh_CN"
RESTRICT="mirror strip userpriv fetch"

ICAROOT="/opt/Citrix/ICAClient"

QA_PREBUILT="${ICAROOT#/}/*"

RDEPEND="
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/libxml2
	media-fonts/font-adobe-100dpi
	media-fonts/font-misc-misc
	media-fonts/font-cursor-misc
	media-fonts/font-xfree86-type1
	media-fonts/font-misc-ethiopic
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	net-dns/libidn
	net-libs/libsoup:2.4
	sys-libs/e2fsprogs-libs
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXpm
	x11-libs/pango
	gstreamer010? (
		media-libs/gst-plugins-base:0.10
		media-libs/gstreamer:0.10
	)
 	!minimal? (
 		media-libs/libcanberra[gtk]
 		media-libs/libogg
 		media-libs/libvorbis
 		media-libs/speex
 		net-libs/webkit-gtk:2
 		virtual/krb5
 		x11-libs/libXaw
 		x11-libs/libXt
 	)
"
DEPEND=""

pkg_nofetch() {
	elog "Download the client file ${A} from
	https://www.citrix.com/downloads/citrix-receiver.html"
	elog "and place it in ${DISTDIR:-/usr/portage/distfiles}."
}

src_unpack() {
	default

	case ${ARCH} in
		amd64)
			ICAARCH=linuxx64
		;;
		x86)
			ICAARCH=linuxx86
		;;
		*)
			eerror "Given architecture is not supported by Citrix."
		;;
	esac

	S="${WORKDIR}/${ICAARCH}/${ICAARCH}.cor"
}

src_install() {
	local tmpl dest

	dodir "${ICAROOT}"

	exeinto "${ICAROOT}"
	doexe *.DLL libproxy.so wfica AuthManagerDaemon PrimaryAuthManager

 	if ! use minimal ; then
 		doexe selfservice ServiceRecord
 	fi

	exeinto "${ICAROOT}"/lib
	doexe lib/*.so

	if use nsplugin ; then
		exeinto "${ICAROOT}"
		doexe npica.so
		dosym "${ICAROOT}"/npica.so /usr/$(get_libdir)/nsbrowser/plugins/npica.so
	fi

	for dest in "${ICAROOT}"{,/nls/en{,.UTF-8}} ; do
		insinto "${dest}"
		doins nls/en.UTF-8/eula.txt
	done

	insinto "${ICAROOT}"
	doins -r usb

	insinto "${ICAROOT}"/config
	doins config/* config/.* nls/en/*.ini
	for tmpl in {appsrv,wfclient}.template ; do
		newins nls/en/${tmpl} ${tmpl/template/ini}
	done
	touch "${ED}/${ICAROOT}"/config/.server || die

	insinto "${ICAROOT}"/gtk
	doins gtk/*

	insinto "${ICAROOT}"/gtk/glade
	doins gtk/glade/*

	insinto "${ICAROOT}"/site
	doins -r site/*

	dodir "${ICAROOT}"/help

	insinto "${ICAROOT}"/config/usertemplate
	doins config/usertemplate/*

	LANGCODES="en"
	use linguas_de && LANGCODES+=" de"
	use linguas_es && LANGCODES+=" es"
	use linguas_fr && LANGCODES+=" fr"
	use linguas_ja && LANGCODES+=" ja"
	use linguas_zh_CN && LANGCODES+=" zh_CN"

	for lang in ${LANGCODES} ; do
		insinto "${ICAROOT}"/nls/${lang}
		doins nls/${lang}/*

		insinto "${ICAROOT}"/nls/$lang/UTF-8
		doins nls/${lang}.UTF-8/*

		insinto "${ICAROOT}"/nls/${lang}/LC_MESSAGES
		doins nls/${lang}/LC_MESSAGES/*

		insinto "${ICAROOT}"/nls/${lang}
		dosym UTF-8 "${ICAROOT}"/nls/${lang}/utf8

		for tmpl in {appsrv,wfclient}.template ; do
			cp "${ED}/${ICAROOT}"/nls/${lang}/${tmpl} \
				"${ED}/${ICAROOT}"/nls/${lang}/${tmpl/template/ini} \
				|| die
		done
	done

	insinto "${ICAROOT}"/nls
	dosym en /opt/Citrix/ICAClient/nls/C

	insinto "${ICAROOT}"/icons
	doins icons/*

	insinto "${ICAROOT}"/keyboard
	doins keyboard/*

	rm -r "${S}"/keystore/cacerts || die
	dosym /etc/ssl/certs "${ICAROOT}"/keystore/cacerts

	exeinto "${ICAROOT}"/util
	# echo_cmd, gst_aud_play and gst_aud_read still require gst-0.10
	if use gstreamer010 ; then
		doexe util/{echo_cmd,gst_aud_play,gst_aud_read,gst_play0.10,gst_read0.10,libgstflatstm0.10.so}
	fi
	doexe util/{configmgr,conncenter,gst_play1.0,gst_read1.0,hdxcheck.sh,icalicense.sh,libgstflatstm1.0.so}
	doexe util/{lurdump,new_store,nslaunch,pnabrowse,storebrowse,sunraymac.sh,what,xcapture}

	doenvd "${FILESDIR}"/10ICAClient

	make_wrapper wfica "${ICAROOT}"/wfica . "${ICAROOT}"

	dodir /etc/revdep-rebuild/
	echo "SEARCH_DIRS_MASK=\"${ICAROOT}\"" > "${D}"/etc/revdep-rebuild/70icaclient
}

pkg_preinst() {
	local old_plugin="/usr/lib64/nsbrowser/plugins/npwrapper.npica.so"
	if use amd64 && [[ -f ${old_plugin} ]] ; then
		local wrapper="/usr/bin/nspluginwrapper"
		if [[ -x ${wrapper} ]] ; then
			einfo "Removing npica.so from wrapper."
			${wrapper} -r ${old_plugin}
		fi
	fi
}
