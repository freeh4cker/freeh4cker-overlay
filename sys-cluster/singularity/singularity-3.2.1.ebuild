# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build bash-completion-r1

EGO_PN=github.com/sylabs/${PN}
EGIT_COMMIT="v${PV}"

DESCRIPTION="Application containers for Linux"
HOMEPAGE="https://www.sylabs.io/singularity/"
SRC_URI="https://${EGO_PN}/releases/download/${EGIT_COMMIT}/${P}.tar.gz"
S=${WORKDIR}/${PN}

LICENSE="cctbx-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-fs/squashfs-tools-4.3"
RDEPEND="${DEPEND}"
BDEPEND=""


src_compile(){
	pushd  ${S}
	./mconfig --prefix=/usr --sysconfdir=/etc --localstatedir=/var/lib
	make -C ./builddir
	touch "${S}"/etc/capability.json
}

src_install(){
	# Install Binaries
	dobin "${S}"/builddir/singularity
	dobin "${S}"/scripts/run-singularity

	# Install libexec
	dodir /usr/libexec/singularity
	into /usr/libexec/singularity
	dobin "${S}"/builddir/cmd/starter/c/starter
	newbin "${S}"/builddir/cmd/starter/c/starter starter-suid

	dodir /usr/libexec/singularity/cni
	exeinto /usr/libexec/singularity/cni
	for plugin in "${S}"/builddir/cni/*;
	do  
		doexe "${plugin}"
	done

	# Create mounting point directory
	keepdir /var/lib/singularity/mnt/session

	# Install configuration files
	dodir /etc/singularity
	insinto /etc/singularity

	doins "${S}"/etc/capability.json
	doins "${S}"/builddir/singularity.conf
	doins "${S}"/etc/nvliblist.conf
	doins "${S}"/etc/remote.yaml
	newins "${S}"/internal/pkg/syecl/syecl.toml.example ecl.toml

	dodir /etc/singularity/actions
	exeinto /etc/singularity/actions
	for action in "${S}"/etc/actions/*;
	do
		doexe ${action}
	done

	dodir /etc/singularity/seccomp-profiles
	insinto /etc/singularity/seccomp-profiles
	doins "${S}"/etc/seccomp-profiles/default.json

	dodir /etc/singularity/network
	insinto /etc/singularity/network
	for conf in  "${S}"/etc/network/*;
	do
		doins "${conf}"
	done

	dodir /etc/singularity/cgroups
	insinto /etc/singularity/cgroups/
	doins	"${S}"/internal/pkg/cgroups/example/cgroups.toml

	# Install bash completion
	newbashcomp "${S}"/builddir/etc/bash_completion.d/"${PN}" ${PN}
}
