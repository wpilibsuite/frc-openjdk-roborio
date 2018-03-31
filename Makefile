VER=$(shell grep Version control | cut -c 10-)
DOCKER_IMAGE=wpilib/frc-openjdk:${VER}
IPK_NAME=frc-openjdk-10-jre_${VER}_cortexa9-vfpv3.ipk

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
	rm -f jre.tar.gz
	rm -rf jre

jre.tar.gz:
	docker run -v ${PWD}:/artifacts ${DOCKER_IMAGE} bash -c "\
		bash configure \
			--openjdk-target=arm-frc-linux-gnueabi \
			--with-abi-profile=arm-vfp-sflt \
			--with-jvm-variants=minimal1 \
			--with-native-debug-symbols=zipped \
			--enable-unlimited-crypto \
			--with-sysroot=/usr/arm-frc-linux-gnueabi \
			--with-version-pre=frc \
			--with-version-opt= \
		&& cd build/linux-arm-normal-minimal1-release \
		&& make all \
		&& cd images \
		&& tar czf jre.tar.gz jre \
		&& chown -R $(shell id -u):$(shell id -u) jre.tar.gz \
		&& cp -a jre.tar.gz /artifacts"


${IPK_NAME}: jre.tar.gz
	tar xzf jre.tar.gz
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
