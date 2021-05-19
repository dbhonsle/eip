# eip
## eip program prints external ip address of the system to stdout  

## Prerequisites on build system
- Docker
- gcc
- make

##  Build instructions To build binary for local platform
```sh
make clean all
```
##  Build instructions to build rpm for opensuse leap
```sh
make clean rpm
```
##  Build instructions To build rpm for local platform [Note: can be used on following rpm pacakage management supported system like rhel-8, ubi rhel-8:1 & above, centos-8, SLES 15.x, Amazon Linux 2, fedora - 33 & above]
# Prerequisites:
# [rhel-8]
rhel-8 requires an active subscription and enabling of codeready-builder-for-rhel-8-rhui-rpms repo,
to enable codeready-builder-for-rhel-8-rhui-rpms in rhel-8
```sh
sudo dnf config-manager --set-enabled codeready-builder-for-rhel-8-rhui-rpms
```
# [SLES 15.x]
```sh
# replace x with service pack version of installed os
sudo SUSEConnect -p PackageHub/15.x/x86_64 
```
# [ubi rhel-8.1 & above docker images, centos-8, Amazon Linux 2, fedora - 33 & above]
ubi rhel-8.1 and higher version images come with ubi-8-codeready-builder repo enabled by default, fedora and Amazon Linux 2 come ready with requied repos enabled

# Build rpm locally:
```sh
make clean localrpm
```
##  Build instructions to build cross platform binaries for virious linux [Note: cross build can only run on a x86_64 based system]
```sh
make clean cross
```