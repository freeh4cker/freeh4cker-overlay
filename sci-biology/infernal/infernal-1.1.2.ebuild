# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

src_install() {
	pushd src > /dev/null
	for cm_bin in cmalign cmbuild cmcalibrate cmconvert cmemit cmfetch cmpress cmsearch cmscan cmstat ; do
		dobin ${cm_bin}
	done
	popd > /dev/null

	pushd documentation/manpages > /dev/null
	for man_page in *.man ; do
		newman ${man_page} "$(basename $man_page .man).1"
	done;
	popd > /dev/null

	insinto /usr/share/${PN}
	doins -r tutorial matrices
	dodoc Userguide.pdf README RELEASE-NOTES
}