# The hg revision
HG_REV=4397fa4529b2
# The full version, e.g. "11u28-1"
VER=$(shell grep Version control | cut -c 10-)
# The Java major version only, e.g. "11"
JAVA_MAJOR=$(shell grep Version control | cut -c 10-11)
# The Java major+minor version, e.g. "11.0.0"
JAVA_MAJORMINOR=$(shell grep Version control | cut -c 10- | cut -du -f 1)
# The Java patch, e.g. "28" for "11u28"
JAVA_PATCH=$(shell grep Version control | cut -c 10- | cut -du -f 2 | cut -d- -f 1)
# The year, e.g. "2019"
YEAR=$(shell grep Package control | cut -c 13-16)
DOCKER_IMAGE=wpilib/frc-openjdk:${YEAR}-${JAVA_MAJOR}u
IPK_NAME=frc${YEAR}-openjdk-11-jre_${VER}_cortexa9-vfpv3.ipk

JVM_VARIANT=client
JVM_FEATURES=
#JVM_VARIANT=minimal1
#JVM_FEATURES=all-gcs,jvmti,services,vm-structs

.PHONY: all clean ipk

ipk: ${IPK_NAME}

all:
	$(MAKE) clean
	$(MAKE) ipk

clean:
	rm -f control.tar.gz
	rm -f data.tar.gz
	rm -f debian-binary
	rm -f ${IPK_NAME}
	rm -f jre_${VER}.tar.gz
	rm -f jre_${VER}-strip.tar.gz
	rm -rf jre

jre_${VER}.tar.gz:
	wget -nc https://hg.openjdk.java.net/jdk-updates/jdk11u/archive/${HG_REV}.tar.bz2
	docker run --rm -v ${PWD}:/artifacts ${DOCKER_IMAGE} bash -c "\
		tar xjf /artifacts/${HG_REV}.tar.bz2 \
		&& cd jdk11u-${HG_REV} \
		&& patch -p1 < /artifacts/g1OopClosures.hpp.patch \
		&& patch -p1 < /artifacts/UseConcMarkSweepGC.patch \
		&& bash configure \
			--openjdk-target=arm-frc${YEAR}-linux-gnueabi \
			--with-abi-profile=arm-vfp-sflt \
			--with-jvm-variants=${JVM_VARIANT} \
			--with-jvm-features=${JVM_FEATURES} \
			--with-native-debug-symbols=zipped \
			--enable-unlimited-crypto \
			--with-sysroot=/usr/local/arm-frc${YEAR}-linux-gnueabi \
			--with-version-pre=frc \
			--with-version-patch=${JAVA_PATCH} \
			--with-version-opt=${YEAR}-${VER} \
			--disable-warnings-as-errors \
		&& make all legacy-jre-image \
		&& cd build/linux-arm-normal-${JVM_VARIANT}-release/images \
		&& tar czf jre_${VER}.tar.gz jre \
		&& chown -R $(shell id -u):$(shell id -g) jre_${VER}.tar.gz \
		&& cp -a jre_${VER}.tar.gz /artifacts \
		&& find jre -name \*.diz -delete \
		&& find jre -name \*.so -type f | xargs arm-frc${YEAR}-linux-gnueabi-strip \
		&& arm-frc${YEAR}-linux-gnueabi-strip jre/bin/* jre/lib/jexec \
		&& tar czf jre_${VER}-strip.tar.gz jre \
		&& chown -R $(shell id -u):$(shell id -g) jre_${VER}-strip.tar.gz \
		&& cp -a jre_${VER}-strip.tar.gz /artifacts"


${IPK_NAME}: jre_${VER}.tar.gz
	rm -rf jre
	tar xzf jre_${VER}-strip.tar.gz
	tar czf data.tar.gz \
	    --transform "s,^jre,usr/local/frc/JRE," \
	    --owner=root \
	    --group=root \
	    jre
	tar czf control.tar.gz control postinst prerm
	echo 2.0 > debian-binary
	ar r ${IPK_NAME} control.tar.gz data.tar.gz debian-binary
