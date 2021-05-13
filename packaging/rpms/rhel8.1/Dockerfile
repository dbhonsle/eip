#FROM golang:1.15-buster AS golang
FROM golang:1.13.15-buster AS golang
FROM registry.access.redhat.com/ubi8/ubi:8.1
ENV GO111MODULE=on
ENV GOPATH=/go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN yum install -y rpm-build yum-utils
COPY SPECS /root/rpmbuild/SPECS
RUN yum-builddep -y /root/rpmbuild/SPECS/*.spec

COPY --from=golang /usr/local/go /usr/local/go
WORKDIR /root/rpmbuild
ENTRYPOINT ["/bin/rpmbuild"]