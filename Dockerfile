FROM ubuntu:17.10

RUN apt-get update && apt-get install -y software-properties-common \
  && apt-add-repository -y ppa:wpilib/toolchain \
  && apt-get update && apt-get install -y \
    build-essential \
    g++ --no-install-recommends \
    gcc \
    libc6-dev \
    make \
    openjdk-9-jdk-headless \
    frc-toolchain \
    libcups2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxtst-dev \
    libxt-dev \
    mercurial \
    unzip \
    zip \
  && rm -rf /var/lib/apt/lists/*

ADD arm-x11-files.tar.xz /usr/arm-frc-linux-gnueabi/

ADD http://download.ni.com/ni-linux-rt/feeds/2017/arm/ipk/cortexa9-vfpv3/alsa-lib-dev_1.1.0-r0.5_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2017/arm/ipk/cortexa9-vfpv3/alsa-lib_1.1.0-r0.5_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2017/arm/ipk/cortexa9-vfpv3/cups-dev_2.1.3-r0.5_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2017/arm/ipk/cortexa9-vfpv3/libasound2_1.1.0-r0.5_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2017/arm/ipk/cortexa9-vfpv3/libfontconfig-dev_2.11.94-r0.38_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2017/arm/ipk/cortexa9-vfpv3/libfontconfig1_2.11.94-r0.38_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2017/arm/ipk/cortexa9-vfpv3/libfreetype-dev_2.6.3-r0.36_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2017/arm/ipk/cortexa9-vfpv3/libfreetype6_2.6.3-r0.36_cortexa9-vfpv3.ipk \
    http://download.ni.com/ni-linux-rt/feeds/2017/arm/ipk/cortexa9-vfpv3/libz1_1.2.8-r0.329_cortexa9-vfpv3.ipk \
    /tmp/

RUN for f in /tmp/*.ipk; do \
    ar p $f data.tar.gz | sh -c 'cd /usr/arm-frc-linux-gnueabi && tar xzf -'; \
  done

WORKDIR /build

RUN hg clone http://hg.openjdk.java.net/jdk-updates/jdk10u jdk10u

WORKDIR jdk10u

