DESCRIPTION="an open source telephony platform designed to facilitate the creation of voice and chat driven products scaling from a soft-phone up to a soft-switch"
HOMEPAGE="http://freeswitch.org/"
LICENSE="MPL-1.1"

FS_P="${P/_/.}"
SRC_URI="http://files.freeswitch.org/${FS_P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa cepstral debug g7xx gsm iax ilbc jabber javascript jingle ldap libedit lpc10 odbc mrcp php portaudio radius resample sip sndfile speex static-blob wanpipe xmlrpc zeroconf"
IUSE_LINGUAS="de en es fr it nl"
# TODO: USE flags for other modules

for i in ${IUSE_LINGUAS}; do
	IUSE="$IUSE linguas_$i"
done

# TODO: supposedly zeroconf requires howl... which says it is dead
# resample, lpc10, wanpipe, php
RDEPEND="
!static-blob? (
	=dev-libs/apr-1*
	=dev-libs/apr-util-1*
	javascript? (
		net-misc/curl
		dev-lang/spidermonkey
	)
	xmlrpc? (
		net-misc/curl
		=dev-libs/xmlrpc-c-1.03.14-r1
	)
	jingle? (
		net-libs/libdingaling
		dev-libs/iksemel
	)
	iax? ( net-libs/iax )
	jabber? ( dev-libs/iksemel )
	portaudio? ( media-libs/portaudio )
	dev-libs/libpcre
	sndfile? ( media-libs/libsndfile )
	sip? ( net-libs/sofia-sip )
	speex? ( media-libs/speex )
	g7xx? ( media-libs/voipcodecs )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	=dev-db/sqlite-3.3*
	net-libs/libsrtp
	net-libs/libteletone
	mrcp? ( app-accessibility/openmrcp )
	net-dns/udns
)
	radius? ( net-dialup/freeradius )
	ldap? ( net-nds/openldap )
	gsm? ( media-sound/gsm )
"
DEPEND="${RDEPEND}
!static-blob? (
	net-libs/stfu
)
"

use static-blob ||
inherit autotools eutils

S="${WORKDIR}/${FS_P}"

pkg_setup() {
	if ! use static-blob; then
		ewarn 'Nobody really supports this.'
		ewarn 'Email luke_freeswitch@dashjr.org if you have issues.'
		ewarn 'USE=static-blob if you want support from the FreeSwitch developers.'
		ebeep 5
	fi
}

src_unpack() {
	unpack ${A}
	
if ! use static-blob; then
	cd "${S}"
	
	einfo "Patching source to use system libraries..."
	mv -v libs/apr/build/apr_common.m4 build/config/
	mv -v libs/xmlrpc-c/lib/abyss/src/token.h src/mod/xml_int/mod_xml_rpc/
	mv -v libs/srtp/include/srtp.h src/
	mv -v libs/sqlite/src/hash.h src/
	rm -rf libs
	epatch "${FILESDIR}/${PN}-system-libs.patch"
	
	# this is basically bootstrap.sh
	cp -v build/modules.conf.in modules.conf
	eautoreconf
fi
}

use_mod() {
	pfx="$(use "$1" &>/dev/null || echo '#')"
	sed -i 's:^#\?\('"$2"'\)$:'"${pfx}"'\1:' "${S}/modules.conf"
}

src_compile() {
	PKG_CONFIG=$(which pkg-config) \
	econf \
		--prefix=/opt/freeswitch \
		$(use_enable debug) \
		$(use_enable odbc    core-odbc-support   ) \
		$(use_enable libedit core-libedit-support) \
		$(use_enable resample) \
	|| die "econf failed"
	
	use_mod cepstral   asr_tts/mod_cepstral
	use_mod mrcp       asr_tts/mod_openmrcp
	use_mod g7xx       codecs/mod_g7'.*'
	use_mod g7xx       codecs/mod_voipcodecs
	use_mod ilbc       codecs/mod_ilbc
	use_mod speex      codecs/mod_speex
	use_mod ldap       directories/mod_ldap
	use_mod jingle     endpoints/mod_dingaling
	use_mod iax        endpoints/mod_iax
	use_mod portaudio  endpoints/mod_portaudio
	use_mod sip        endpoints/mod_sofia
	use_mod wanpipe    endpoints/mod_wanpipe
	use_mod alsa       endpoints/mod_alsa
	use_mod radius     event_handlers/mod_radius_cdr
	use_mod sndfile    formats/mod_sndfile
	use_mod python     languages/mod_python
	use_mod javascript languages/mod_spidermonkey'.*'
	use odbc || use_mod odbc languages/mod_spidermonkey_odbc
	use_mod xmlrpc     xml_int/mod_xml_rpc
	for i in ${IUSE_LINGUAS}; do
	use_mod linguas_$i say/mod_say_$i
	done
	
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "einstall failed"
	mkdir -p "${D}/usr/bin"
	cd "${D}/usr/bin"
	ln -s ../../opt/freeswitch/bin/* .
}
