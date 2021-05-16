#!/usr/bin/env bash
set -euxo pipefail

# returned path can vary: /usr/bin/dnf /bin/dnf ...
pkg_manager=$(command -v dnf yum | head -n1)
echo "Package manager binary: $pkg_manager"

declare -a PKGS=(\
                xz \
                rpm-build \
                make \
                gcc \
                git \
                glib2-devel \
                glibc-devel \
                )

if [[ $pkg_manager == *dnf ]]; then
    # We need to enable PowerTools if we want to get
    # install all the pkgs we define in PKGS
    # PowerTools exists on centos-8 but not on fedora-30 and rhel-8
    if (dnf -v -C repolist all|grep "Repo-id      : PowerTools" >/dev/null); then
        sudo dnf config-manager --set-enabled PowerTools
    fi
fi

#grep -i 'PRETTY_NAME' /etc/os-release | grep "SUSE"
if (grep -i 'PRETTY_NAME' /etc/os-release | grep "SUSE" ) ; then
    PKGS+=(glibc-devel-static \
        golang-packaging \
	)
elif (grep -i 'PRETTY_NAME' /etc/os-release | grep -i 'Red Hat\|CentOS\|Fedora' ) ; then
    PKGS+=(glibc-static \
        golang-bin \
	)
fi

echo ${PKGS[*]}
#sudo $pkg_manager install -y ${PKGS[*]}
$pkg_manager install -y ${PKGS[*]}

# clean up src.rpm as it's been built
#sudo rm -f eip-*.src.rpm
rm -f eip-*.src.rpm
make -f ./Makefile

