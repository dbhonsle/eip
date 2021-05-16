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
##  Build instructions To build rpm for local platform [Note: can be used on any rpm pacakage management supported system]
```sh
make clean localrpm
```
##  Build instructions to build cross platform binaries for virious linux [Note: cross build can only run on a x86_64 based system]
```sh
make clean cross
```