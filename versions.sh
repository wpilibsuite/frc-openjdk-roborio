# The git tag
GIT_TAG=jdk-21.0.1+12
# The full version, e.g. "11u28-1"
VER=`grep Version control | cut -c 10-`
# The Java major version only, e.g. "11"
JAVA_MAJOR=`grep Version control | cut -c 10-11`
# The Java major+minor version, e.g. "11.0.0"
JAVA_MAJORMINOR=`grep Version control | cut -c 10- | cut -du -f 1`
# The Java patch, e.g. "28" for "11u28"
JAVA_PATCH=`grep Version control | cut -c 10- | cut -du -f 2 | cut -d- -f 1`
# The year, e.g. "2019"
YEAR=`grep Package control | cut -c 13-16`

UBUNTU=22.04
DOCKER_IMAGE=wpilib/roborio-cross-ubuntu:${YEAR}-${UBUNTU}
IPK_NAME=frc${YEAR}-openjdk-21-jre_${VER}_cortexa9-vfpv3.ipk

