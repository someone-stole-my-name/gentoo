# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLUGINS_HASH="029bd8ccb58c4452bd82ab42be8739f1639e42d4"
inherit cmake-utils xdg-utils

DESCRIPTION="Desktop agnostic launcher"
HOMEPAGE="https://albertlauncher.github.io/"
# plugins is a git submodule. the hash is taken from the submodule reference in the ${PV} tag.
SRC_URI="https://github.com/albertlauncher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/albertlauncher/plugins/archive/${PLUGINS_HASH}.tar.gz -> ${P}-plugins.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
	dev-cpp/muParser
	dev-qt/qtcharts:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"

src_prepare() {
	mv "${WORKDIR}"/plugins-${PLUGINS_HASH}/* "${S}"/plugins/ || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DEBUG=$(usex debug)
		-DBUILD_PYTHON=OFF #plugin directory is empty causing build failure
		-DBUILD_VIRTUALBOX=OFF #plugin needs virtualbox installed to build, untested
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
