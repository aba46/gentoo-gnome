# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
# FIXME: gtk-doc scanner fails assertion in gtk_icon_theme_get_for_screen().
# How? Why?
IUSE="doc" # doc
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~mips ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
fi

RDEPEND="
	app-arch/bzip2
	>=app-arch/xz-utils-4.9
	dev-db/sqlite:3
	>=dev-libs/dbus-glib-0.71
	>=dev-libs/glib-2.25.11:2
	>=dev-libs/libxml2-2.6.5:2
	>=dev-libs/libxslt-1.1.4
	>=gnome-extra/yelp-xsl-${PV}
	>=net-libs/webkit-gtk-1.3.2:3
	>=x11-libs/gtk+-2.91.8:3
	x11-themes/gnome-icon-theme-symbolic"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.41.0
	dev-util/itstool
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	gnome-base/gnome-common
	doc? ( >=dev-util/gtk-doc-1.13 )"
# If eautoreconf:
#	gnome-base/gnome-common

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		app-text/yelp-tools
		gnome-base/gnome-common"
fi

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		--enable-bz2
		--enable-lzma"
	[[ ${PV} != 9999 ]] && G2CONF="${G2CONF} ITSTOOL=$(type -P true)"
}

src_prepare() {
	# Fix compatibility with Gentoo's sys-apps/man
	# https://bugzilla.gnome.org/show_bug.cgi?id=648854
	epatch "${FILESDIR}/${PN}-3.0.3-man-compatibility.patch"

	[[ ${PV} != 9999 ]] && eautoreconf

	gnome2_src_prepare
}
