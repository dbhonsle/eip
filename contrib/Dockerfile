FROM centos:8
ENV GO111MODULE=on
ENV GOPATH=/go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN yum install -y rpm-build rpmlint yum-utils gcc make golang-bin
RUN go version
COPY spec /root/rpmbuild/SPECS

WORKDIR /root/rpmbuild
ENTRYPOINT ["/bin/rpmbuild"]