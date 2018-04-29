# The full version, e.g. "10u46-1"
VER=$(shell grep Version control | cut -c 10-)
# The Java major version only, e.g. "10"
JAVA_MAJOR=$(shell grep Version control | cut -c 10-11)
# The Java major+minor version, e.g. "10.0.1"
JAVA_MAJORMINOR=$(shell grep Version control | cut -c 10- | cut -du -f 1)
# The Java patch, e.g. "46" for "10u46"
JAVA_PATCH=$(shell grep Version control | cut -c 10- | cut -du -f 2 | cut -d- -f 1)
# The year, e.g. "2018"
YEAR=$(shell grep Package control | cut -c 13-16)
DOCKER_IMAGE=wpilib/frc-openjdk:${YEAR}-${JAVA_MAJOR}u
IPK_NAME=frc${YEAR}-openjdk-10-jre_${VER}_cortexa9-vfpv3.ipk

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
	rm -rf jre

jre_${VER}.tar.gz:
	docker run -v ${PWD}:/artifacts ${DOCKER_IMAGE} bash -c "\
		hg pull \
		&& hg up jdk-${JAVA_MAJORMINOR}+${JAVA_PATCH} \
		&& patch -p1 < /artifacts/space.inline.hpp.patch \
		&& patch -p1 < /artifacts/g1OopClosures.hpp.patch \
		&& bash configure \
			--openjdk-target=arm-frc${YEAR}-linux-gnueabi \
			--with-abi-profile=arm-vfp-sflt \
			--with-jvm-variants=${JVM_VARIANT} \
			--with-jvm-features=${JVM_FEATURES} \
			--with-native-debug-symbols=zipped \
			--enable-unlimited-crypto \
			--with-sysroot=/usr/arm-frc${YEAR}-linux-gnueabi \
			--with-version-pre=frc \
			--with-version-patch=${JAVA_PATCH} \
			--with-version-opt=${YEAR}-${VER} \
			--disable-warnings-as-errors \
		&& make all \
		&& cd build/linux-arm-normal-${JVM_VARIANT}-release/images \
		&& tar czf jre_${VER}.tar.gz jre \
		&& chown -R $(shell id -u):$(shell id -u) jre_${VER}.tar.gz \
		&& cp -a jre_${VER}.tar.gz /artifacts"


${IPK_NAME}: jre_${VER}.tar.gz
	tar xzf jre_${VER}.tar.gz
	find jre -name \*.so -type f | xargs strip
	strip jre/bin/* jre/lib/jexec
	tar czf data.tar.gz \
	    --transform "s,^jre,usr/local/frc/JRE," \
	    --exclude=\*.diz \
	    --owner=root \
	    --group=root \
	    jre
	tar czf control.tar.gz control postinst prerm
	echo 2.0 > debian-binary
	ar r ${IPK_NAME} control.tar.gz data.tar.gz debian-binary
