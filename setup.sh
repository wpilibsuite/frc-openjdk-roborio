#!/bin/bash
set -e
set -o pipefail

source versions.sh

apt-get update && apt-get install -y \
    autoconf \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    file \
    g++ --no-install-recommends \
    gcc \
    gdb \
    git \
    java-common \
    libc6-dev \
    libcups2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libisl23 \
    libpython2.7 \
    libx11-dev \
    libxext-dev \
    libxrandr-dev \
    libxrender-dev \
    libxtst-dev \
    libxt-dev \
    make \
    unzip \
    wget \
    zip

curl -SL https://download.java.net/java/GA/jdk20.0.2/6e380f22cbe7469fa75fb448bd903d8e/9/GPL/openjdk-20.0.2_linux-x64_bin.tar.gz | sh -c 'cd /usr/lib/jvm && tar xzf -'
cp jdk-20.jinfo /usr/lib/jvm/.jdk-20.0.2.jinfo
grep /usr/lib/jvm /usr/lib/jvm/.jdk-20.0.2.jinfo \
    | awk '{ print "update-alternatives --install /usr/bin/" $2 " " $2 " " $3 " 2"; }' \
    | bash
update-java-alternatives -s jdk-20.0.2

# Add ARM files for x11 (not RoboRIO, but doesn't have to be)
cat arm-x11-files.tar.xz | sh -c "cd /usr/local/arm-nilrt-linux-gnueabi/sysroot && tar xJf -"

# Add cross libraries
wget \
    https://download.ni.com/ni-linux-rt/feeds/academic/2023/arm/extra/cortexa9-vfpv3/alsa-server_1.1.9-r0.0_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/academic/2023/arm/extra/cortexa9-vfpv3/cups-dev_2.2.6-r0.34_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/academic/2023/arm/extra/cortexa9-vfpv3/libasound-dev_1.1.9-r0.0_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/academic/2023/arm/extra/cortexa9-vfpv3/libasound2_1.1.9-r0.0_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/academic/2023/arm/main/cortexa9-vfpv3/libfontconfig-dev_2.12.6-r0.18_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/academic/2023/arm/main/cortexa9-vfpv3/libfontconfig1_2.12.6-r0.18_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/academic/2023/arm/main/cortexa9-vfpv3/libfreetype-dev_2.9-r0.18_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/academic/2023/arm/main/cortexa9-vfpv3/libfreetype6_2.9-r0.18_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/academic/2023/arm/main/cortexa9-vfpv3/libz1_1.2.11-r0.207_cortexa9-vfpv3.ipk

for f in *.ipk; do \
    ar p $f data.tar.xz | sh -c "cd /usr/local/arm-nilrt-linux-gnueabi/sysroot && tar xJf -"; \
done

