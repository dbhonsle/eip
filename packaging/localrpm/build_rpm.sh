#!/usr/bin/env bash
set -euxo pipefail

if [ "$(id -u)" -ne 0 ]; then
    SUDO=sudo
else
    SUDO=
fi

# returned path can vary: /usr/bin/dnf /bin/dnf ...
pkg_manager=$(command -v dnf yum zypper | head -n1)
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
        $(SUDO) dnf install -y dnf-plugins-core
        $(SUDO) dnf config-manager --set-enabled PowerTools
    elif (dnf -v -C repolist all|grep "Repo-id            : powertools" >/dev/null); then
        $(SUDO) dnf install -y dnf-plugins-core
        $(SUDO) dnf config-manager --set-enabled powertools
    fi
    # Note [rhel-8]
    # rhel-8 requires an active subscription and enabling 
    # codeready-builder-for-rhel-8-rhui-rpms repo
    # use below command to enable it
    # sudo dnf config-manager --set-enabled codeready-builder-for-rhel-8-rhui-rpms
    # [ubi rhel-8 & above docker images]
    # ubi rhel-8.1 and higher version images come with ubi-8-codeready-builder repo enabled by default
fi

if (grep -i 'PRETTY_NAME' /etc/os-release | grep "SUSE" ) ; then
    # For SLES 15.x enable packagehub
    # sudo SUSEConnect -p PackageHub/15.x/x86_64 [replace x with service pack version of installed os]
        PKGS+=(glibc-devel-static \
            golang-packaging \
	    )
elif (grep -i 'PRETTY_NAME' /etc/os-release | grep -i 'Red Hat\|CentOS\|Fedora|\Amazon' ) ; then
    PKGS+=(glibc-static \
        golang-bin \
	)
fi

export extra_arg="--without debug"

echo ${PKGS[*]}
$SUDO $pkg_manager install -y ${PKGS[*]}

# clean up src.rpm as it's been built
$SUDO rm -f eip-*.src.rpm

make -f ./packaging/localrpm/Makefile

if [ -d ~/rpmbuild/BUILD ]; then
    chmod -R +w ~/rpmbuild/BUILD
fi

rpmbuild --rebuild ${extra_arg:-} eip-*.src.rpm