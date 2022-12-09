# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DESCRIPTION="Metapackage for free fonts"
HOMEPAGE=""

SRC_URI=""
LICENSE="metapackage"
SLOT="0"

KEYWORDS="amd64 ppc64 x86"
IUSE="+cyrillic l10n_am l10n_ar l10n_bn l10n_bo l10n_fa l10n_he l10n_iu l10n_ja l10n_km l10n_ko l10n_si l10n_syc l10n_te l10n_th l10n_zh psf X"

REQUIRED_USE="|| ( psf X )"

CJK_DEPEND="
	media-fonts/wqy-bitmapfont
	media-fonts/wqy-microhei
	media-fonts/wqy-unibit
"

DEPEND="
	X? (
		media-fonts/ahem
		media-fonts/armagetronad-font
		media-fonts/artwiz-aleczapka-en
		media-fonts/artwiz-latin1
		media-fonts/cheapskatefonts
		media-fonts/clearsans
		media-fonts/console-font
		media-fonts/crosextrafonts-caladea
		media-fonts/croscorefonts
		media-fonts/dina
		media-fonts/droid
		media-fonts/encodings
		media-fonts/essays1743
		media-fonts/fgdc-emergency
		media-fonts/font-adobe-100dpi
		media-fonts/font-adobe-75dpi
		media-fonts/font-adobe-utopia-100dpi
		media-fonts/font-adobe-utopia-75dpi
		media-fonts/font-adobe-utopia-type1
		media-fonts/font-alias
		media-fonts/font-bh-100dpi
		media-fonts/font-bh-75dpi
		media-fonts/font-bh-lucidatypewriter-100dpi
		media-fonts/font-bh-lucidatypewriter-75dpi
		media-fonts/font-bitstream-100dpi
		media-fonts/font-bitstream-75dpi
		media-fonts/font-bitstream-speedo
		media-fonts/font-bitstream-type1
		media-fonts/font-cursor-misc
		media-fonts/font-daewoo-misc
		media-fonts/font-dec-misc
		media-fonts/font-ibm-type1
		media-fonts/font-micro-misc
		media-fonts/font-misc-misc
		media-fonts/font-mutt-misc
		media-fonts/font-schumacher-misc
		media-fonts/font-screen-cyrillic
		media-fonts/font-sony-misc
		media-fonts/font-sun-misc
		media-fonts/font-xfree86-type1
		media-fonts/freefont
		media-fonts/fs-fonts
		media-fonts/glass-tty-vt220
		media-fonts/hack
		media-fonts/intlfonts
		media-fonts/jetbrains-mono
		media-fonts/jsmath
		media-fonts/jsmath-extra-dark
		media-fonts/konfont
		media-fonts/lfpfonts-fix
		media-fonts/lfpfonts-var
		media-fonts/liberation-fonts
		media-fonts/libertine
		media-fonts/lohit-fonts
		media-fonts/montecarlo
		media-fonts/ohsnap
		media-fonts/open-sans
		media-fonts/oto
		media-fonts/overpass
		media-fonts/polarsys-b612-fonts
		media-fonts/powerline-symbols
		media-fonts/proggy-fonts
		media-fonts/quivira
		media-fonts/roboto
		media-fonts/sgi-fonts
		media-fonts/source-han-sans
		media-fonts/symbola
		media-fonts/takao-fonts
		media-fonts/termsyn
		media-fonts/tuffy
		media-fonts/ubuntu-font-family
		media-fonts/unifont
		media-fonts/urw-fonts
		media-fonts/webby-fonts
		media-fonts/x11fonts-jmk

		cyrillic? (
			media-fonts/cronyx-fonts
			media-fonts/font-cronyx-cyrillic
			media-fonts/font-misc-cyrillic
			media-fonts/font-winitzki-cyrillic
		)

		l10n_am? ( media-fonts/font-misc-ethiopic )
		l10n_ar? (
			media-fonts/arabeyes-fonts
			media-fonts/font-arabic-misc
			media-fonts/kacst-fonts
		)
		l10n_bn? ( media-fonts/free-bangla-font )
		l10n_bo? ( media-fonts/tibetan-machine-font )
		l10n_fa? ( media-fonts/farsi-fonts )
		l10n_he? ( media-fonts/culmus )
		l10n_iu? ( media-fonts/pigiarniq )
		l10n_ja? (
			media-fonts/font-jis-misc
			media-fonts/fs-fonts
			media-fonts/ipaex
			media-fonts/ja-ipafonts
			media-fonts/jisx0213-fonts
			media-fonts/kanjistrokeorders
			media-fonts/koruri
			media-fonts/mix-mplus-ipa
			media-fonts/monafont
			media-fonts/mplus-fonts
			media-fonts/mplus-outline-fonts
			media-fonts/sazanami
			media-fonts/shinonome
			media-fonts/umeplus-fonts
			media-fonts/vlgothic
			${CJK_DEPEND}
		)
		l10n_km? ( media-fonts/khmer )
		l10n_ko? (
			media-fonts/baekmuk-fonts
			media-fonts/unfonts
			media-fonts/unfonts-extra
			${CJK_DEPEND}
		)
		l10n_si? ( media-fonts/lklug )
		l10n_syc? ( media-fonts/font-misc-meltho )
		l10n_te? ( media-fonts/pothana2k )
		l10n_th? ( media-fonts/thaifonts-scalable )
		l10n_zh? (
			media-fonts/arphicfonts
			media-fonts/font-isas-misc
			media-fonts/opendesktop-fonts
			media-fonts/wqy-zenhei
			media-fonts/zh-kcfonts
			${CJK_DEPEND}
		)
	)
	
	psf? (
		media-fonts/solarize
		media-fonts/termsyn
		media-fonts/unifont
	)
"
RDEPEND="${DEPEND}"

# NOTE: media-fonts/ricty has a non-free dep on media-fonts/inconsolata (OFL-1.1)
