#FROM golang:1.15-buster AS golang
FROM golang:1.13.15-buster AS golang
FROM opensuse/tumbleweed:latest
ENV GO111MODULE=off
ENV GOPATH=/go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN zypper install -y xz rpm-build make gcc git glib2-devel glibc-devel glibc-devel-static
COPY SPECS /root/rpmbuild/SPECS

COPY --from=golang /usr/local/go /usr/local/go
WORKDIR /root/rpmbuild
ENTRYPOINT ["/usr/bin/rpmbuild"]