# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="Prokaryotic Dynamic Programming Genefinding Algorithm"
HOMEPAGE="http://prodigal.ornl.gov/ https://github.com/hyattpd/Prodigal"
SRC_URI="https://github.com/hyattpd/Prodigal/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/Prodigal-${PV}"

src_prepare() {
	sed -i -e 's/LDFLAGS=/LDFLAGS+=/' Makefile || die
	eapply_user
}

src_install(){
	dobin prodigal
	dodoc README.md CHANGES
}
