# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Inference of RNA alignments"
HOMEPAGE="http://eddylab.org/infernal/"
SRC_URI="http://eddylab.org/infernal/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
IUSE="mpi"
KEYWORDS="~x86 ~amd64"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

src_configure() {
	econf --prefix="${D}/usr" $(use_enable mpi)
}

