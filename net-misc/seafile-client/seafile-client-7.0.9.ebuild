# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Seafile desktop client"
HOMEPAGE="https://www.seafile.com/ https://github.com/haiwen/seafile-client/"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl shibboleth test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3
	dev-libs/libevent
	dev-libs/jansson
	<dev-qt/qtcore-5.15:5
	<dev-qt/qtdbus-5.15:5
	<dev-qt/qtgui-5.15:5
	<dev-qt/qtnetwork-5.15:5
	<dev-qt/qtwidgets-5.15:5
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
	net-libs/libsearpc
	~net-misc/seafile-${PV}
	shibboleth? ( <dev-qt/qtwebengine-5.15:5[widgets] )"
DEPEND="${RDEPEND}
	test? ( <dev-qt/qttest-5.15:5 )"
BDEPEND="<dev-qt/linguist-tools-5.15:5"

PATCHES=(
	"${FILESDIR}/${PN}-select-qt5.patch"
	"${FILESDIR}/${P}-libressl.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHIBBOLETH_SUPPORT="$(usex shibboleth)"
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
