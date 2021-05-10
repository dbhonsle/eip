# eip-docker
## eip program prints external ip address of the system to stdout  

##  Build instructions for virious linux distros  
```sh
#from source root
cd ./packaging/rpms
#create three directories SOURCES RPMS SRPMS
#In our case it is at /Users/deepak/projects/hello/
#compress the eip-docker source as eip-1.0.tar.xz that includes first moving source contents into eip-1.0 dir and compressing
```

## Build base os docker images
```sh
#Build docker image for rhel 8.1
docker build -t rpmrhel8 -f rhel8.1/Dockerfile .

#Build image for Centos 8
docker build -t rpmcentos8 -f centos8/Dockerfile .

#Build image for opensuse tumbleweed
docker build -t rpmsusetumbleweed -f opensuse-tumbleweed/Dockerfile .

#Build image for opensuse leap
docker build -t rpmsuseleap -f opensuse-leap/Dockerfile .
```

## Run the instance to buils rpms and srpms
```sh
#Run instance for rhel 8.1 builds
docker run --rm -v /Users/deepak/projects/hello/SOURCES:/root/rpmbuild/SOURCES:ro -v /Users/deepak/projects/hello/RPMS:/root/rpmbuild/RPMS -v /Users/deepak/projects/hello/SRPMS:/root/rpmbuild/SRPMS rpmrhel8 -ba SPECS/eip.spec

#Run instance for Centos 8 builds
docker run --rm -v /Users/deepak/projects/hello/SOURCES:/root/rpmbuild/SOURCES:ro -v /Users/deepak/projects/hello/RPMS:/root/rpmbuild/RPMS -v /Users/deepak/projects/hello/SRPMS:/root/rpmbuild/SRPMS rpmcentos8 -ba --undefine _missing_build_ids_terminate_build -D 'debug_package %{nil}' SPECS/eip.spec

#Run instance for opensuse tumbleweed build
docker run --rm -v /Users/deepak/projects/hello/SOURCES:/root/rpmbuild/SOURCES:ro -v /Users/deepak/projects/hello/RPMS:/root/rpmbuild/RPMS -v /Users/deepak/projects/hello/SRPMS:/root/rpmbuild/SRPMS rpmsusetumbleweed -ba SPECS/eip.spec

#Run instance for opensuse leap build (We tried on s390x platform with SOURCES etc created in /home/linux1/ )
docker run --rm -v /home/linux1/SOURCES:/root/rpmbuild/SOURCES:ro -v /home/linux1/RPMS:/root/rpmbuild/RPMS -v /home/linux1/SRPMS:/root/rpmbuild/SRPMS rpmsuseleap -ba SPECS/eip.spec
```

## Alternatively we can build the rpm without transferring go binary from go buster image to target os image by using the go bundled with the os. This can be done for rhel, centos and may be fedora os of now

##  Build instructions
```sh
#from source root
cd ./contrib
#create three directories SOURCES RPMS SRPMS
#In our case it is at /Users/deepak/projects/hello/
#compress the eip-docker source as eip-1.0.tar.xz that includes first moving source contents into eip-1.0 dir and compressing
```

## Build base os including build project deps docker image
```sh
Build image for rhel 8
docker build -t rpmcentos8onhost -f Dockerfile .
The above step should mimic classic centos 8 with all build dependencies
```

## Run the instance to buils rpms and srpms
```sh
#Run instance for rhel 8 builds
docker run --rm -v /Users/deepak/projects/hello/SOURCES:/root/rpmbuild/SOURCES:ro -v /Users/deepak/projects/hello/RPMS:/root/rpmbuild/RPMS -v /Users/deepak/projects/hello/SRPMS:/root/rpmbuild/SRPMS rpmcentos8onhost -ba SPECS/eip.spec.in
```
