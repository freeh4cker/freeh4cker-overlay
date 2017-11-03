# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Sequence and alignment format file checker/converter"
HOMEPAGE="ftp://ftp.pasteur.fr/pub/gensoft/projects/squizz/README"
SRC_URI="ftp://ftp.pasteur.fr/pub/gensoft/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

src_test(){
	einfo ">>> Test phase [check]: ${CATEGORY}/${PF}"
	emake -j1 check
}
