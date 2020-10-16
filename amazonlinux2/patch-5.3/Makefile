# Makefile
#
# Created by Helge Heß
# Copyright © 2020 ZeeZide GmbH. All rights reserved.

# This is a Makefile variant for direct consumption. Plus some extra stuff
# for testing purposes.

prefix=/usr/local
# This is required because we need to hardcode the destination.json to the
# actual location.
ACTUAL_DESTINATION_PREFIX=/usr/local

VERSION=5.3
HOST_VERSION=$(VERSION)
TARBALL_VERSION=$(VERSION)

TARGET_ARCH=x86_64
TARGET_TRIPLE=$(TARGET_ARCH)-unknown-linux
LINUX_TARGET_TRIPLE=$(TARGET_ARCH)-linux-gnu
PLATFORM=amazonlinux2

HOST_SWIFT_TOOLCHAIN=/usr/local/lib/swift/xctoolchains/$(TARGET_ARCH)-apple-darwin/$(HOST_VERSION)-current/swift.xctoolchain

BUILD_DIR=$(PWD)/.build
FETCH_DIR=$(PWD)/.fetch

DESTDIR_RELAPTH=lib/swift/dst/$(TARGET_TRIPLE)
DESTDIR_PREFIX=$(prefix)/$(DESTDIR_RELAPTH)
INSTALL_PREFIX=$(ACTUAL_DESTINATION_PREFIX)/$(DESTDIR_RELAPTH)

ALX_awsdomain=amazonaws.com
ALX_awsregion=default
ALX_product=core
ALX_target=latest
ALX_basearch=$(TARGET_ARCH)
ALX_releasever=2
ALX_CORE_MIRROR_LIST="http://amazonlinux.${ALX_awsregion}.${ALX_awsdomain}/${ALX_releasever}/${ALX_product}/${ALX_target}/${ALX_basearch}/mirror.list"
ALX_BLOBSTORE_URL="https://cdn.amazonlinux.com/blobstore"

CROSS_TOOLCHAIN_NAME=swift-$(VERSION)-$(PLATFORM).xtoolchain

include packagelist.make

MKDIR=mkdir
CP=cp
CLONE=cp -ac
LN_S=ln -s

all: retrieve-packages build-toolchain

install: all
	$(MKDIR) -p $(DESTDIR_PREFIX)
	$(CLONE) $(BUILD_DIR)/$(CROSS_TOOLCHAIN_NAME) \
	         $(DESTDIR_PREFIX)/$(CROSS_TOOLCHAIN_NAME)

clean:
	$(RM_RF) $(BUILD_DIR)

distclean: clean
	$(RM_RF) $(FETCH_DIR)
	
retrieve-packages:
	BUILD_DIR=$(BUILD_DIR) FETCH_DIR=$(FETCH_DIR)	\
	TARGET_ARCH=$(TARGET_ARCH)				\
	LINUX_TARGET_TRIPLE=$(LINUX_TARGET_TRIPLE)	\
	TARGET_PLATFORM=$(PLATFORM)			\
	TARGET_SDK_NAME=$(TARGET_ARCH)-$(PLATFORM).sdk 	\
	ALX_CORE_MIRROR_LIST=$(ALX_CORE_MIRROR_LIST)	\
	ALX_BLOBSTORE_URL=$(ALX_BLOBSTORE_URL)		\
	./retrieve-sdk-packages.sh "$(PACKAGE_NAMES)"


# toolchain builder

# A different: the build-toolchain doesn't carry the parameter
build-toolchain:
	BUILD_DIR=$(BUILD_DIR) FETCH_DIR=$(FETCH_DIR)	\
	SWIFT_VERSION=$(VERSION)			\
	TARGET_ARCH=$(TARGET_ARCH)			\
	TARGET_PLATFORM=$(PLATFORM)			\
	HOST_SWIFT_TOOLCHAIN=$(HOST_SWIFT_TOOLCHAIN)	\
	CROSS_TOOLCHAIN_NAME=$(CROSS_TOOLCHAIN_NAME)	\
	HOST_PLATFORM=$(uname -m)			\
	INSTALL_PREFIX=$(INSTALL_PREFIX)		\
	./build-toolchain.sh
