# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit user

DESCRIPTION="Neo4j is a highly scalable, native graph database."
HOMEPAGE="http://neo4j.org/"
SRC_URI="${P}-unix.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=virtual/jre-1.8
"

MY_PN=${PN/-community/}

pkg_nofetch() {
	einfo "Please download '${P}' from:"
	einfo "'https://neo4j.com/download-thanks/?edition=community&release=${PV}&flavour=unix'"
	einfo "and move it to '${DISTDIR}'"

	einfo
	einfo "If the above mentioned urls do not point to the correct version anymore,"
	einfo "please download the files from Neo4j download archive:"
	einfo
	einfo "  https://neo4j.com/download/other-releases/  "
	einfo
}

pkg_setup(){
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} ${MY_PN}
	}

src_prepare() {
	eapply -p0 "${FILESDIR}/${P}-${MY_PN}.conf.patch"
	eapply_user
}

src_install(){
	dodir /opt/${PN}

	# Install executable
	dodir /opt/${PN}/bin
	exeinto /opt/${PN}/bin
	doexe bin/neo*
	dodir /opt/${PN}/bin/tools
	insinto /opt/${PN}/bin/tools
	doins -r bin/tools/*

	dosym /opt/${PN}/bin/neo4j /usr/bin/neo4j
	dosym /opt/${PN}/bin/neo4j-admin /usr/bin/admin
	dosym /opt/${PN}/bin/neo4j-import /usr/bin/neo4j-import
	dosym /opt/${PN}/bin/neo4j-shell /usr/bin/neo4j-shell

	# Install lib
	dodir /opt/${PN}/lib
	insinto /opt/${PN}/lib
	doins lib/*

	# Install server configuration files
	dodir /etc/${MY_PN}
	insinto /etc/${MY_PN}
	doins conf/*

	# Setup directories for plugins, import and certificates
	dodir /opt/${PN}/{plugins,certificates,import}

	# Logs directory
	dodir /var/log/${MY_PN}
	fowners  ${MY_PN}:${MY_PN} /var/log/${MY_PN}
	fperms -R 0754 /var/log/${MY_PN}

	# Data storage
	dodir /var/lib/${MY_PN}/data
	fowners -R ${MY_PN}:${MY_PN} /var/lib/${MY_PN}
	fperms -R 0755 /var/lib/${MY_PN}

	# Daemon init script and configuration 
	newconfd "${FILESDIR}"/${MY_PN}.confd ${MY_PN}
	newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}

	newenvd "${FILESDIR}"/${MY_PN}.envd 50${MY_PN}
}
