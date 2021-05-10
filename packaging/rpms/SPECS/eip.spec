#
# Copyright (c) 2021 SUSE LLC
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.
 
# Please submit bugfixes or comments via https://bugs.opensuse.org/
# 

%define _topdir         /root/rpmbuild
Name:           eip
Version:        1.0
Release:        0
License:        GPL-2.0
Summary:        eip shows external ip && hello displays Hello World
Url:            https://www.rewdale.com/
Group:          Development/Languages/Other
Source:         eip-%{version}.tar.xz

#%undefine _missing_build_ids_terminate_build
#%global debug_package %{nil}

%description
$DESCRIPTION
eip shows external ip

%prep
%setup -q -n eip-%{version}

%build
mkdir -p /go/src/github.com/dbhonsle
rm -f /go/src/github.com/dbhonsle/eip
ln -s ${RPM_BUILD_DIR}/eip-%{version} /go/src/github.com/dbhonsle/eip
go build -v -o ${GOPATH}/bin/eip github.com/dbhonsle/eip

%install
install -d ${RPM_BUILD_ROOT}%{_bindir}
install -p -m 755 ${GOPATH}/bin/eip ${RPM_BUILD_ROOT}%{_bindir}/eip

%files
%{_bindir}/eip
%license LICENSE
%doc README

%changelog
