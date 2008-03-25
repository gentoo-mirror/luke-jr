# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt3

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://ftp.digium.com/pub/asterisk/old-releases/${MY_P}.tar.gz
		http://downloads.digium.com/pub/asterisk/old-releases/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa curl debug freetds h323 imap jabber kde keepsrc ljr misdn mmx mysql newt nosamples odbc oss pic postgres qt3 radius snmp speex ssl sqlite static vorbis zaptel"

RDEPEND="virtual/libc
	sys-libs/ncurses
	dev-libs/popt
	sys-libs/zlib
	qt3? ( $(qt_min_version 3.0) )
	ssl? ( dev-libs/openssl )
	alsa? ( media-libs/alsa-lib )
	curl? ( net-misc/curl )
	newt? ( dev-libs/newt )
	h323? ( dev-libs/pwlib
		net-libs/openh323 )
	imap? ( virtual/imap-c-client )
	odbc? ( dev-db/unixODBC )
	snmp? ( net-analyzer/net-snmp )
	misdn? ( net-dialup/misdnuser )
	mysql? ( dev-db/mysql )
	speex? ( media-libs/speex )
	jabber? ( dev-libs/iksemel )
	radius? ( net-dialup/radiusclient-ng )
	sqlite? ( dev-db/sqlite )
	vorbis? ( media-libs/libvorbis )
	zaptel? ( >=net-libs/libpri-1.4.0
		>=net-misc/zaptel-1.4.1 )
	freetds? ( dev-db/freetds )
	postgres? ( dev-db/libpq )"

DEPEND="${RDEPEND}"
#	sys-devel/flex
#	sys-devel/bison"

S="${WORKDIR}/${MY_P}"

#
# shortcuts
#

# update from asterisk-1.0.x
is_ast10update() {
	return $(has_version "=net-misc/asterisk-1.0*")
}

# update from asterisk-1.2.x
is_ast12update() {
	return $(has_version "=net-misc/asterisk-1.2*")
}

# update in the asterisk-1.4.x line
is_astupdate() {
	if ! is_ast10update && ! is_ast12update; then
		return $(has_version "<net-misc/asterisk-${PV}")
	fi
	return 0
}

get_available_modules() {
	local modules mod x

	# build list of available modules...
	for x in app cdr codec format func pbx res; do

		for mod in $(find "${S}" -type f -name "${x}_*.c*" -print)
		do
			modules="${modules} $(basename ${mod/%.c*})"
		done
	done

	echo "${modules}"
}

#
# Display a nice countdown...
#
countdown() {
	local n

	ebeep

	n=${1:-10}
	while [[ $n -gt 0 ]]; do
		echo -en "  Waiting $n second(s)...\r"
		sleep 1
		(( n-- ))
	done
}

pkg_setup() {
	local checkfailed=0 waitaftermsg=0

	if is_ast10update || is_ast12update; then
		ewarn "      Asterisk UPGRADE Warning"
		ewarn ""
		ewarn "- Please read ${ROOT}usr/share/doc/${PF}/UPGRADE.txt.gz after the installation!"
		ewarn ""
		ewarn "      Asterisk UPGRADE Warning"
		echo
		waitaftermsg=1
	fi

	if [[ $waitaftermsg -eq 1 ]]; then
		einfo "Press Ctrl+C to abort"
		echo
		countdown
	fi

	#
	# Regular checks
	#
	einfo "Running some pre-flight checks..."
	echo

	# imap requires ssl if imap-c-client was built with ssl,
	# conversely if ssl and imap are both on then imap-c-client needs ssl
	if use imap; then
		if use ssl && ! built_with_use virtual/imap-c-client ssl; then
			eerror
			eerror "IMAP with SSL requested, but your IMAP C-Client libraries"
			eerror "are built without SSL!"
			eerror
			die "Please recompile the IMAP C-Client libraries with SSL support enabled"
		elif ! use ssl && built_with_use virtual/imap-c-client ssl; then
			eerror
			eerror "IMAP without SSL requested, but your IMAP C-Client"
			eerror "libraries are built with SSL!"
			eerror
			die "Please recompile the IMAP C-Client libraries without SSL support enabled"
		fi
	fi

	#
	# In a perfect world, $user should know what he's doing when specifying
	# a custom list of modules
	#
	if [[ -n "${ASTERISK_MODULES}" ]] ; then
		ewarn "_insert random warning message here_"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	#
	# comment about h323 issues
	#
	if use h323 ; then
		ewarn "h323 useflag: It is known that the h323 module doesn't compile
		the \"normal\" way: For a workaround, asterisk will be built two times
		without cleaning the build dir."
	fi

	#
	# put pid file(s) into /var/run/asterisk
	#
	epatch "${FILESDIR}"/1.4/${PN}-1.4.0-var_rundir.patch

	#
	# fix gsm codec cflags (e.g. i586 core epias) and disable
	# assembler optimizations (on non-mmx / non-x86 or x86 PIC systems)
	#
	epatch "${FILESDIR}"/1.4/${PN}-1.4.18-gsm-pic.patch


	#
	# add missing LIBS for uclibc
	#
	epatch "${FILESDIR}"/1.4/${PN}-1.4.0-uclibc.patch

	if use x86 && use mmx ; then
		if use pic ; then
			ewarn "pic useflag: Not enabling mmx optimizations"
		else
			einfo "mmx useflag: Enabling mmx optimizations"
			sed -i -e "s:^#K6OPT.*:K6OPT = -DK6OPT:" \
				codecs/gsm/Makefile || die "sed gsm makefile failed"
		fi
	fi

	#
	# fix imap & qt include check in configure
	# (TODO: patch configure.ac & run eautoreconf ?)
	#
	epatch "${FILESDIR}"/1.4/${PN}-1.4.18-configure-gentoo.diff

	if use ljr; then
		einfo "ljr useflag: Enabling Luke-Jr's enhancements"
		epatch "${FILESDIR}"/1.4/asterisk-1.4.11-jabber-priority.patch
	fi
	
	# add custom device state function (func_devstate)
	# http://asterisk.org/node/48360
	# http://svncommunity.digium.com/svn/russell/func_devstate-1.4/README.txt
	cp "${FILESDIR}"/1.4/func_devstate-r6.c "${S}"/funcs/func_devstate.c

	# parse modules list
	if [[ -n "${ASTERISK_MODULES}" ]]; then
		local x modules="$(get_available_modules)"

		einfo "Custom list of modules specified, checking..."

		use debug && {
			einfo "Available modules: ${modules}"
			einfo " Selected modules: ${ASTERISK_MODULES}"
		}

		for x in ${ASTERISK_MODULES}; do
			if [[ "${x}" = "-*" ]]; then
				MODULES_LIST=""
			else
				if has ${x} ${modules}
				then
					MODULES_LIST="${MODULES_LIST} ${x}"
				else
					eerror "Unknown module: ${x}"
				fi
			fi
		done

		export MODULES_LIST
	fi
}

src_compile() {
	#
	# start with configure
	#
	econf \
		--libdir="/usr/$(get_libdir)" \
		--localstatedir="/var" \
		--with-gsm=internal \
		--with-popt \
		--with-z \
		$(use_with qt3 qt "${QTDIR}") \
		$(use_with oss) \
		$(use_with ssl) \
		$(use_with alsa asound) \
		$(use_with curl) \
		$(use_with h323 h323 "/usr/share/openh323") \
		$(use_with imap) \
		$(use_with newt) \
		$(use_with odbc) \
		$(use_with snmp) \
		$(use_with misdn) \
		$(use_with misdn isdnnet) \
		$(use_with mysql) \
		$(use_with h323 pwlib "/usr/share/pwlib") \
		$(use_with speex) \
		$(use_with jabber iksemel) \
		$(use_with radius) \
		$(use_with sqlite) \
		$(use_with vorbis) \
		$(use_with vorbis ogg) \
		$(use_with zaptel) \
		$(use_with zaptel pri) \
		$(use_with zaptel tonezone) \
		$(use_with freetds tds) \
		$(use_with postgres) || die "econf failed"

	#
	# custom module filter
	# run menuselect to evaluate the list of modules
	# and rewrite the list afterwards
	#
	if [[ -n "${MODULES_LIST}" ]]
	then
		local mod category tmp_list failed_list

		###
		# run menuselect

		emake menuselect.makeopts || die "emake menuselect.makeopts failed"

		###
		# get list of modules with failed dependencies

		failed_list="$(awk -F= '/^MENUSELECT_DEPSFAILED=/{ print $3 }' menuselect.makeopts)"

		###
		# traverse our list of modules

		for category in app cdr codec format func pbx res; do
			tmp_list=""

			# search list of modules for matching ones first...
			for mod in ${MODULES_LIST}; do
				# module is from current category?
				if [[ "${mod/%_*}" = "${category}" ]]
				then
					# check menuselect thinks the dependencies are met
					if has ${mod} ${failed_list}
					then
						eerror "${mod}: dependencies required to build this module are not met, NOT BUILDING!"
					else
						tmp_list="${tmp_list} ${mod}"
					fi
				fi
			done

			use debug && echo "${category} tmp: ${tmp_list}"

			# replace the module list for $category with our custom one
			if [[ -n "${tmp_list}" ]]
			then
				category="$(echo ${category} | tr '[:lower:]' '[:upper:]')"
				sed -i -e "s:^\(MENUSELECT_${category}S?\):\1=${tmp_list}:" \
					menuselect.makeopts || die "failed to set list of ${category} applications"
			fi
		done
	fi

	#
	# fasten your seatbelts (and start praying)
	#
	if use h323 ; then
		# emake one time to get h323 to make.... yea not "clean" but works
		emake
	fi

	emake || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	emake -j1 DESTDIR="${D}" samples || die "emake samples failed"

	# remove installed sample files if nosamples flag is set
	if use nosamples; then
		einfo "Skipping installation of sample files..."
		rm -f  "${D}"var/lib/asterisk/mohmp3/*
		rm -f  "${D}"var/lib/asterisk/sounds/demo-*
		rm -f  "${D}"var/lib/asterisk/agi-bin/*
	else
		einfo "Sample files have been installed"
	fi
	rm -rf "${D}"var/spool/asterisk/voicemail/default

	# move sample configuration files to doc directory
	if is_ast10update || is_ast12update; then
		einfo "Updating from old (pre-1.4) asterisk version, new configuration files have been installed"
		einfo "into ${ROOT}etc/asterisk, use etc-update or dispatch-conf to update them"
	fi

	einfo "Configuration samples have been moved to: $ROOT/usr/share/doc/${PF}/conf"
	insinto /usr/share/doc/${PF}/conf
	doins "${D}"etc/asterisk/*.conf*

	# keep directories
	keepdir /var/spool/asterisk/{system,tmp,meetme,monitor,dictate,voicemail}
	keepdir /var/log/asterisk/{cdr-csv,cdr-custom}

	newinitd "${FILESDIR}"/1.4/asterisk.rc6 asterisk
	newconfd "${FILESDIR}"/1.4/asterisk.confd asterisk

	# some people like to keep the sources around for custom patching
	# copy the whole source tree to /usr/src/asterisk-${PVF} and run make clean there
	if use keepsrc
	then
		einfo "keepsrc useflag enabled, copying source..."
		dodir /usr/src

		cp -dPR "${S}" "${D}"/usr/src/${PF} || die "copying source tree failed"

		ebegin "running make clean..."
		make -C "${D}"/usr/src/${PF} clean >/dev/null || die "make clean failed"
		eend $?

		einfo "Source files have been saved to ${ROOT}usr/src/${PF}"
	fi
}

pkg_preinst() {
	enewgroup asterisk
	enewuser asterisk -1 -1 /var/lib/asterisk asterisk
}

pkg_postinst() {
	einfo "Fixing permissions"
	for x in spool run lib log; do
		chown -R asterisk:asterisk "${ROOT}"var/${x}/asterisk
		chmod -R u=rwX,g=rX,o=     "${ROOT}"var/${x}/asterisk
	done

	chown -R root:asterisk "${ROOT}"etc/asterisk
	chmod -R u=rwX,g=rX,o= "${ROOT}"etc/asterisk
	echo

	#
	# Announcements, warnings, reminders...
	#
	einfo "Asterisk has been installed"
	einfo ""
	einfo "If you want to know more about asterisk, visit these sites:"
	einfo "http://www.asteriskdocs.org/"
	einfo "http://www.voip-info.org/wiki-Asterisk"
	elog
	einfo "http://www.automated.it/guidetoasterisk.htm"
	elog
	einfo "Gentoo VoIP IRC Channel:"
	einfo "#gentoo-voip @ irc.freenode.net"
	echo
	echo

	#
	# Warning about 1.x -> 1.4 changes...
	#
	if is_ast10update || is_ast12update; then
		ewarn ""
		ewarn "- Please read ${ROOT}usr/share/doc/${PF}/UPGRADE.txt.gz before continuing"
		ewarn ""
	fi

	ewarn "************************ Work-In-Progress ebuild **********************"
	ewarn ""
	ewarn "Comments, bugs, feature requests go here:"
	ewarn ""
	ewarn "http://bugs.gentoo.org/show_bug.cgi?id=159013"
	ewarn ""
}

pkg_config() {
	einfo "Do you want to reset file permissions and ownerships (y/N)?"

	read tmp
	tmp="$(echo $tmp | tr '[:upper:]' '[:lower:]')"

	if [[ "$tmp" = "y" ]] ||\
		[[ "$tmp" = "yes" ]]
	then
		einfo "Resetting permissions to defaults..."

		for x in spool run lib log; do
			chown -R asterisk:asterisk "${ROOT}"var/${x}/asterisk
			chmod -R u=rwX,g=rX,o=     "${ROOT}"var/${x}/asterisk
		done

		chown -R root:asterisk "${ROOT}"etc/asterisk
		chmod -R u=rwX,g=rX,o= "${ROOT}"etc/asterisk

		einfo "done"
	else
		einfo "skipping"
	fi
}
