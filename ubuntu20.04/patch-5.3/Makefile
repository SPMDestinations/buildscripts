# Makefile
#
# Created by Helge Heß
# Copyright © 2020-2021 ZeeZide GmbH. All rights reserved.

# This script variant expects an unarchived target Swift toolchain in $PWD,
# i.e. `usr` (with bin, include, lib, local, share)

prefix=/usr/local

# This is required because we need to hardcode the destination.json to the
# actual location.
ACTUAL_DESTINATION_PREFIX=/usr/local

MAIN_VERSION=5.3
SWIFT_VERSION=$(MAIN_VERSION).3

TARGET_ARCH=x86_64
TARGET_TRIPLE=$(TARGET_ARCH)-unknown-linux
LINUX_TARGET_TRIPLE=$(TARGET_ARCH)-linux-gnu
PLATFORM=ubuntu20.04

BUILD_DIR=$(PWD)/.build
FETCH_DIR=$(PWD)/.fetch

DESTDIR_RELAPTH=lib/swift/dst/$(TARGET_TRIPLE)
DESTDIR_PREFIX=$(prefix)/$(DESTDIR_RELAPTH)
INSTALL_PREFIX=$(ACTUAL_DESTINATION_PREFIX)/$(DESTDIR_RELAPTH)

APT_DISTRIBUTION_NAME=focal
APT_PLATFORM=amd64
APT_REPOSITORY_URL=http://de.archive.ubuntu.com/ubuntu
APT_PACKAGES_FILE_URL=$(APT_REPOSITORY_URL)/dists/$(APT_DISTRIBUTION_NAME)/main/binary-$(APT_PLATFORM)/Packages.gz

CROSS_TOOLCHAIN_NAME=swift-$(MAIN_VERSION)-$(PLATFORM).xtoolchain

# The packages we want in the SDK. Those should be as many as possible, so
# that arbitrary software can be built.
# (In case that turns out to be an issue, we can always do separate packages
#  later).
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
	rm -rf $(BUILD_DIR)

distclean: clean
	rm -rf $(FETCH_DIR)

# package download

retrieve-packages:
	BUILD_DIR=$(BUILD_DIR) FETCH_DIR=$(FETCH_DIR)	\
	TARGET_ARCH=$(TARGET_ARCH)			\
	LINUX_TARGET_TRIPLE=$(LINUX_TARGET_TRIPLE)	\
	TARGET_PLATFORM=$(PLATFORM)			\
	TARGET_SDK_NAME=$(TARGET_ARCH)-$(PLATFORM).sdk 	\
	APT_REPOSITORY_URL=$(APT_REPOSITORY_URL)	\
	APT_PACKAGES_FILE_URL=$(APT_PACKAGES_FILE_URL)	\
	./retrieve-sdk-packages.sh "$(PACKAGE_NAMES)"

# toolchain builder

build-toolchain: $(PACKAGE_FETCH_FILE)
	BUILD_DIR=$(BUILD_DIR) \
	FETCH_DIR=$(FETCH_DIR)	\
	SWIFT_VERSION=$(MAIN_VERSION) 			\
	TARGET_ARCH=$(TARGET_ARCH)			\
	TARGET_PLATFORM=$(PLATFORM)			\
	CROSS_TOOLCHAIN_NAME=$(CROSS_TOOLCHAIN_NAME)	\
	HOST_PLATFORM=$(uname -m)			\
	INSTALL_PREFIX=$(INSTALL_PREFIX)		\
	SWIFT_LIB_DIR=$(SWIFT_LIB_DIR) \
	./build-toolchain.sh
