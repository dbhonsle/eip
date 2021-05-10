FROM golang:1.15-buster AS golang
#FROM golang:1.13.15-buster AS golang
FROM centos:8
ENV GO111MODULE=on
ENV GOPATH=/go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN yum install -y rpm-build rpmlint yum-utils
RUN go version
COPY SPECS /root/rpmbuild/SPECS

COPY --from=golang /usr/local/go /usr/local/go
WORKDIR /root/rpmbuild
ENTRYPOINT ["/bin/rpmbuild"]