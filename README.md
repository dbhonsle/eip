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

##  Build instructions to build cross platform binaries for virious linux can be used on x86_64 and aarch64 based systems
```sh
make clean cross
```

##  Build instructions to build rpm for opensuse leap
```sh
make clean rpm
```