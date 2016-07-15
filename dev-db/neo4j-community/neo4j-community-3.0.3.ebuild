# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Neo4j is a graph database management system developed by Neo Technology, inc."
HOMEPAGE="http://neo4j.org/"
SRC_URI="https://neo4j.com/artifact.php?name=${PN}-${PV}-unix.tar.gz"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!dev-db/neo4j-enterprise
	    >=virtual/jre-1.8
	    sys-process/lsof"


pkg_setup(){
	enewgroup neo4j
	enewuser neo4j -1 /bin/sh /opt/neo4j-community neo4j
}

src_prepare() {
	epatch "${FILESDIR}/neo4j-shared.patch"
}

src_install() {
	newenvd "${FILESDIR}"/neo4j.envd 50neo4j

	DESTDIR="/opt/${PN}"

    exeinto ${DESTDIR}/bin
	doexe "${S}"/bin/*
	
	insinto ${DESTDIR}/lib
	doins ${S}/lib/* 

    # prepare neo4j file tree
	dodir ${DESTDIR}/data/databases
	dodir ${DESTDIR}/plugins
	dodir ${DESTDIR}/import

	# config files
	insinto /etc/neo4j
	doins "${S}"/conf/neo4j.conf || die
	doins "${S}"/conf/neo4j-wrapper.conf || die

    #prepare dir for log
	dodir /var/log/neo4j
    chgrp neo4j /var/log/neo4j
	chmod g+w /var/log/neo4j

	dodir /var/run/neo4j
    chgrp neo4j /var/run/neo4j
	chmod g+w /var/run/neo4j

	# documentation
	dodoc "${S}"/*.txt

	# init script
	newinitd "${FILESDIR}"/neo4j.init neo4j || die


	# create symlinks
	dosym ${DESTDIR}/bin/neo4j /opt/bin/neo4j || die
}
