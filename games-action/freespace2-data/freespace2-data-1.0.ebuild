# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils games

DESCRIPTION="Freespace 2 - This is the data portion of Freespace 2"
HOMEPAGE="http://www.freespace2.com/"
SRC_URI=""

LICENSE="freespace2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"
IUSE=""

DEPEND="app-arch/unshield"

S=${WORKDIR}

GAMES_LICENSE_CHECK="yes"
dir=${GAMES_PREFIX_OPT}/freespace2
Ddir=${D}/${dir}

pkg_setup() {
    games_pkg_setup
}

src_install() {
	cdrom_get_cds data1.cab tangoA_fs2.vp tangoB_fs2.vp

	# Disk 1
	einfo "Copying files from Disk 1..."
	for group in "Basic Install Files" "Intel Anims" "Music Compressed" \
			"High Res Files" "Hud Config Files";
		do
		unshield -g "$group" -L -j x ${CDROM_ROOT}/data1.cab;
	done;
	
	insinto "${dir}"/data
	doins */*.vp
	insinto "${dir}"/data/players
	doins */*.hcf

	# Disk 2
	cdrom_load_next_cd
	einfo "Copying files from Disk 2..."
	insinto "${dir}"/data
	doins "${CDROM_ROOT}"/tango1_fs2.vp
	newins "${CDROM_ROOT}"/tangoA_fs2.vp tangoa_fs2.vp

	# Disk 3
	cdrom_load_next_cd
	einfo "Copying files from Disk 3..."
	doins "${CDROM_ROOT}"/tango{2,3}_fs2.vp
	newins "${CDROM_ROOT}"/tangoB_fs2.vp tangob_fs2.vp

	# Now, since these files are coming off a CD, the times/sizes/md5sums won't
	# be different ... that means portage will try to unmerge some files (!)
	# We run touch on ${D} so as to make sure portage doesn't do any such thing
	find "${Ddir}" -exec touch '{}' \;

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	echo
	elog "This is only the data portion of the game. You need to merge"
	elog "games-action/fs2_open to play."
	echo
}

