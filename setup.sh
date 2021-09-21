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
    libisl15 \
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

curl -SL https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz | sh -c 'cd /usr/lib/jvm && tar xzf -'
cp jdk-16.jinfo /usr/lib/jvm/.jdk-16.0.2.jinfo
grep /usr/lib/jvm /usr/lib/jvm/.jdk-16.0.2.jinfo \
    | awk '{ print "update-alternatives --install /usr/bin/" $2 " " $2 " " $3 " 2"; }' \
    | bash
update-java-alternatives -s jdk-16.0.2

# Add ARM files for x11 (not RoboRIO, but doesn't have to be)
cat arm-x11-files.tar.xz | sh -c "cd /usr/local/arm-frc${YEAR}-linux-gnueabi && tar xJf -"

# Add cross libraries
wget \
    https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/alsa-lib-dev_1.1.5-r0.6_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/alsa-server_1.1.5-r0.6_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/cups-dev_2.2.6-r0.14_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/libasound2_1.1.5-r0.6_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/libfontconfig-dev_2.12.6-r0.6_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/libfontconfig1_2.12.6-r0.6_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/libfreetype-dev_2.9-r0.6_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/libfreetype6_2.9-r0.6_cortexa9-vfpv3.ipk \
    https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/libz1_1.2.11-r0.71_cortexa9-vfpv3.ipk

for f in *.ipk; do \
    ar p $f data.tar.gz | sh -c "cd /usr/local/arm-frc${YEAR}-linux-gnueabi && tar xzf -"; \
done

