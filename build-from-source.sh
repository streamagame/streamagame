#!/bin/bash

DEPENDENCIES="git \
	openjdk-7-jdk \
	libfreetype6-dev \
	libaudio-dev \
	cmake \
	libxtst-dev \
	libasound2-dev \
	libgl1-mesa-dev \
	libglu1-mesa-dev \
	libpulse-dev \
	python-mako \
	gnupg \
	flex \
	bison \
	gperf \
	build-essential \
	zip \
	curl \
	zlib1g-dev \
	gcc-multilib \
	g++-multilib \
	libc6-dev-i386 \
	lib32ncurses5-dev \
	x11proto-core-dev \
	libx11-dev \
	lib32z-dev \
	ccache \
	libxml2-utils \
	xsltproc \
	unzip \
	repo"

echo "Checking if all dependencies are installed:"

ANYMISSING=0

for p in $DEPENDENCIES; do
	echo -n "Checking for $p ... "
	if dpkg-query -l $p > /dev/null 2>&1; then
		echo "yes"
	else
		ANYMISSING=1
		echo "no!"
	fi
done

if [ $ANYMISSING == 1 ]; then
	echo "Please install the missing dependencies."
	exit 1;
fi

echo "All dependencies seem to be there. Lets get started."

# Compute component

echo "Building compute component (Android) ..."
mkdir compute/
cd compute
echo "- Initializing local repository"
repo init -u https://github.com/streamagame/streamagame-aosp-manifest.git -b streamagame-lollipop-x86 || exit 1
echo "- Downloading sources"
repo sync || exit 1
echo "- Building ISO image from source"
. build/envsetup.sh
lunch android_x86-userdebug
export INIT_BOOTCHART=true
make -j8 iso_img || exit 1

# Rendering component

echo "Building rendering component ..."
lunch sdk-eng
export EMUGL_BUILD_DEBUG=1
./external/qemu/distrib/package-release.sh --package-dir=$PWD/../rendering/ --system=linux --verbose || exit 1

# Streaming component

echo "Building streaming component (GamingAnywhere) ..."
cd streaming/
./build.posix.sh || exit 1
