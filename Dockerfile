FROM ubuntu:18.04

RUN apt-get update && apt-get install -y tzdata && apt-get install -y \
    autoconf \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    file \
    g++ --no-install-recommends \
    gcc \
    gdb \
    java-common \
    libc6-dev \
    libcups2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libisl15 \
    libpython2.7 \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxtst-dev \
    libxt-dev \
    make \
    mercurial \
    unzip \
    wget \
    zip \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Install OpenJDK 10 (required to build OpenJDK 11)
WORKDIR /usr/lib/jvm
RUN curl -SL https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz | tar xzf -
COPY jdk-10.jinfo .jdk-10.0.2.jinfo
RUN bash -c "grep /usr/lib/jvm .jdk-10.0.2.jinfo | awk '{ print \"update-alternatives --install /usr/bin/\" \$2 \" \" \$2 \" \" \$3 \" 2\"; }' | bash " \
  && update-java-alternatives -s jdk-10.0.2

# Install toolchain
RUN curl -SL https://github.com/wpilibsuite/toolchain-builder/releases/download/v2019-3/FRC-2019-Linux-Toolchain-6.3.0.tar.gz | sh -c 'mkdir -p /usr/local && cd /usr/local && tar xzf - --strip-components=2'

# Add ARM files for x11 (not RoboRIO, but doesn't have to be)
ADD arm-x11-files.tar.xz /usr/local/arm-frc2019-linux-gnueabi/

WORKDIR /tmp

RUN wget http://download.ni.com/ni-linux-rt/feeds/2018.1/arm/cortexa9-vfpv3/alsa-lib-dev_1.1.3-r0.2_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2018.1/arm/cortexa9-vfpv3/alsa-server_1.1.3-r0.2_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2018.1/arm/cortexa9-vfpv3/cups-dev_2.2.2-r0.6_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2018.1/arm/cortexa9-vfpv3/libasound2_1.1.3-r0.2_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2018.1/arm/cortexa9-vfpv3/libfontconfig-dev_2.12.1-r0.7_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2018.1/arm/cortexa9-vfpv3/libfontconfig1_2.12.1-r0.7_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2018.1/arm/cortexa9-vfpv3/libfreetype-dev_2.7.1-r0.7_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2018.1/arm/cortexa9-vfpv3/libfreetype6_2.7.1-r0.7_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2018.1/arm/cortexa9-vfpv3/libz1_1.2.11-r0.17_cortexa9-vfpv3.ipk \
  && for f in *.ipk; do \
    ar p $f data.tar.gz | sh -c 'cd /usr/local/arm-frc2019-linux-gnueabi && tar xzf -'; \
  done \
  && rm *.ipk

WORKDIR /build

