#!/bin/zsh

mkdir -p arm-x11-files-download
pushd arm-x11-files-download
wget -nc http://http.us.debian.org/debian/pool/main/x/xorgproto/x11proto-dev_2018.4-4_all.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxrandr/libxrandr-dev_1.5.1-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxrandr/libxrandr2_1.5.1-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxext/libxext-dev_1.3.3-1+b2_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxext/libxext6_1.3.3-1+b2_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libx11/libx11-dev_1.6.7-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libx11/libx11-6_1.6.7-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxcb/libxcb1-dev_1.13.1-2_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxcb/libxcb1_1.13.1-2_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxau/libxau-dev_1.0.8-1+b2_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxau/libxau6_1.0.8-1+b2_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxdmcp/libxdmcp-dev_1.1.2-3_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxdmcp/libxdmcp6_1.1.2-3_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libb/libbsd/libbsd0_0.9.1-2_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxrender/libxrender1_0.9.10-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxrender/libxrender-dev_0.9.10-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxfixes/libxfixes-dev_5.0.3-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxfixes/libxfixes3_5.0.3-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxi/libxi-dev_1.7.9-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxi/libxi6_1.7.9-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxt/libxt-dev_1.1.5-1+b3_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxt/libxt6_1.1.5-1+b3_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libs/libsm/libsm-dev_1.2.3-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libs/libsm/libsm6_1.2.3-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libi/libice/libice-dev_1.0.9-2_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libi/libice/libice6_1.0.9-2_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/i/iptables/libxtables-dev_1.8.2-4_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/i/iptables/libxtables12_1.8.2-4_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxtst/libxtst-dev_1.2.3-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/libx/libxtst/libxtst6_1.2.3-1_armel.deb
wget -nc http://http.us.debian.org/debian/pool/main/x/xorg/x11-common_7.7+19_all.deb
wget -nc http://http.us.debian.org/debian/pool/main/x/xtrans/xtrans-dev_1.3.5-1_all.deb
wget -nc http://http.us.debian.org/debian/pool/main/u/util-linux/libuuid1_2.33.1-0.1_armel.deb
popd

rm -rf arm-x11-files
mkdir -p arm-x11-files
pushd arm-x11-files
    for file in ../arm-x11-files-download/*.deb; do
	ar p $file data.tar.xz | tar xJf -
    done
    rm -rf etc usr/bin usr/share usr/lib/arm-linux-gnueabi/pkgconfig usr/lib/X11
    mv usr/lib/arm-linux-gnueabi/* usr/lib/
    rmdir usr/lib/arm-linux-gnueabi
    mv lib/arm-linux-gnueabi/* lib/
    rmdir lib/arm-linux-gnueabi

    rm -f ../arm-x11-files.tar.xz
    tar cJf ../arm-x11-files.tar.xz .
popd

