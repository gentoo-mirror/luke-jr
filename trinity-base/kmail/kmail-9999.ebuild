# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"
TRINITY_MODULE_NAME="tdepim"

inherit trinity-meta

DESCRIPTION="An email client for Trinity"
KEYWORDS=""
IUSE="imap mbox sasl"
COMMON_DEPEND="
	>=trinity-base/libtdepim-${PV}:${SLOT}
	>=trinity-base/mimelib-${PV}:${SLOT}
	>=trinity-base/libtdenetwork-${PV}:${SLOT}
	>=trinity-base/ktnef-${PV}:${SLOT}
	>=trinity-base/libkcal-${PV}:${SLOT}
	>=trinity-base/libkmime-${PV}:${SLOT}
	>=trinity-base/libkpgp-${PV}:${SLOT}
	>=trinity-base/certmanager-${PV}:${SLOT}
	>=trinity-base/libkpimidentities-${PV}:${SLOT}
	>=trinity-base/libksieve-${PV}:${SLOT}
"
# kontact?

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	>=trinity-base/tdebase-tdeioslaves-${PV}:${SLOT}
	mbox? ( >=trinity-base/tdepim-tdeioslaves-${PV}:${SLOT} )
	imap? ( >=trinity-base/tdepim-tdeioslaves-${PV}:${SLOT}[imap,sasl=] )
"
# tdebase-tdeioslaves for smtp

TSM_EXTRACT_ALSO="
	ktnef/
	libemailfunctions/
	mimelib/
	libtdenetwork/
	certmanager/lib/
	libtdepim/
	korganizer/korganizerinterface.h
	korganizer/kcalendarinterface.h
	libkpgp/
	libkmime/
	libksieve/
	kmail/
"
