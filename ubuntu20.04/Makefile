# Makefile
#
# Created by Helge Heß
# Copyright © 2020-2021 ZeeZide GmbH. All rights reserved.

# This is a Makefile variant for direct consumption. Plus some extra stuff
# for testing purposes.
# Ubuntu version

prefix=/usr/local
# This is required because we need to hardcode the destination.json to the
# actual location.
ACTUAL_DESTINATION_PREFIX=/usr/local

#VERSION=5.3
#BRANCH=swift-$(VERSION)-branch
#SNAPSHOT=DEVELOPMENT-SNAPSHOT-2020-07-31-a
#MAIN_VERSION=5.3
#VERSION=$(MAIN_VERSION).3
#BRANCH=swift-$(VERSION)-release
#SNAPSHOT=RELEASE
DOWNLOAD_BASEURL=https://download.swift.org
MAIN_VERSION=5.6
VERSION=$(MAIN_VERSION).2
BRANCH=swift-$(VERSION)-release
SNAPSHOT=RELEASE

ARCH=x86_64
TARGET=$(ARCH)-unknown-linux
LINUX_TARGET_TRIPLE=$(ARCH)-linux-gnu
PLATFORM=ubuntu20.04
PACKAGE_URL=$(DOWNLOAD_BASEURL)/$(BRANCH)/$(subst .,,$(PLATFORM))/swift-$(VERSION)-$(SNAPSHOT)/swift-$(VERSION)-$(SNAPSHOT)-$(PLATFORM).tar.gz

BUILD_DIR=$(PWD)/.build
FETCH_DIR=$(PWD)/.fetch
PATCH_DIR=$(BUILD_DIR)/patch

DESTDIR_PREFIX=$(prefix)/lib/swift/dst/x86_64-unknown-linux/

PACKAGE_FETCH_FILENAME=swift-$(VERSION)-$(PLATFORM).tar.gz
PACKAGE_FETCH_FILE=$(FETCH_DIR)/$(PACKAGE_FETCH_FILENAME)

APT_DISTRIBUTION_NAME=focal
APT_PLATFORM=amd64
APT_REPOSITORY_URL=http://de.archive.ubuntu.com/ubuntu
APT_PACKAGES_FILE_URL=$(APT_REPOSITORY_URL)/dists/$(APT_DISTRIBUTION_NAME)/main/binary-$(APT_PLATFORM)/Packages.gz

MKDIR=mkdir
CP=cp
LN_S=ln -s
RM_RF=rm -rf
PGK_FETCHER=curl -L
DIRDIFF=diff -ruN

all: patch-5.6/build.patch

help:
	@echo $(PACKAGE_URL)
	@echo "make retrieve-packages"
	@echo "make build-toolchain"
	@echo "testbuild"

local-build: $(PACKAGE_FETCH_FILE) retrieve-packages build-toolchain

$(PACKAGE_FETCH_FILE):
	$(MKDIR) -p $(FETCH_DIR)
	(if ! test -f $@; then $(PGK_FETCHER) -o $@ $(PACKAGE_URL); fi)

install:
	echo TODO
	exit 42

clean:
	$(RM_RF) $(BUILD_DIR)

distclean: clean
	$(RM_RF) $(FETCH_DIR)


# patches

swift-5.3-patch: patch-5.3/build.patch

patch-5.3/build.patch: packagelist.make Makefile retrieve-sdk-packages.sh build-toolchain.sh patch-5.3/Makefile
	$(RM_RF) $@
	$(RM_RF) $(PATCH_DIR)
	$(MKDIR) -p $(PATCH_DIR)/empty
	$(MKDIR) -p $(PATCH_DIR)/patched
	$(CP) -ac retrieve-sdk-packages.sh $(PATCH_DIR)/patched/
	$(CP) -ac packagelist.make         $(PATCH_DIR)/patched/
	$(CP) -ac build-toolchain.sh       $(PATCH_DIR)/patched/
	$(CP) -ac patch-5.3/Makefile       $(PATCH_DIR)/patched/
	(cd $(PATCH_DIR); $(DIRDIFF) empty patched > $(PWD)/$@ ; [ $$? -eq 1 ])
	cat patch-5.3/build.patch | shasum -a 256

swift-5.6-patch: patch-5.6/build.patch

patch-5.6/build.patch: packagelist.make Makefile retrieve-sdk-packages.sh build-toolchain.sh patch-5.6/Makefile
	$(RM_RF) $@
	$(RM_RF) $(PATCH_DIR)
	$(MKDIR) -p $(PATCH_DIR)/empty
	$(MKDIR) -p $(PATCH_DIR)/patched
	$(CP) -ac retrieve-sdk-packages.sh $(PATCH_DIR)/patched/
	$(CP) -ac packagelist.make         $(PATCH_DIR)/patched/
	$(CP) -ac build-toolchain.sh       $(PATCH_DIR)/patched/
	$(CP) -ac patch-5.6/Makefile       $(PATCH_DIR)/patched/
	(cd $(PATCH_DIR); $(DIRDIFF) empty patched > $(PWD)/$@ ; [ $$? -eq 1 ])
	cat patch-5.6/build.patch | shasum -a 256

# package download

include packagelist.make

retrieve-packages:
	BUILD_DIR=$(BUILD_DIR) FETCH_DIR=$(FETCH_DIR)	\
	TARGET_ARCH=$(ARCH)				\
	LINUX_TARGET_TRIPLE=$(LINUX_TARGET_TRIPLE)	\
	TARGET_PLATFORM=$(PLATFORM)			\
	TARGET_SDK_NAME=$(ARCH)-$(PLATFORM).sdk 	\
	APT_REPOSITORY_URL=$(APT_REPOSITORY_URL)	\
	APT_PACKAGES_FILE_URL=$(APT_PACKAGES_FILE_URL)	\
	./retrieve-sdk-packages.sh "$(PACKAGE_NAMES)"


# toolchain builder

build-toolchain: $(PACKAGE_FETCH_FILE)
	SWIFT_VERSION=$(MAIN_VERSION) SWIFT_LIB_DIR=$(prefix)/lib/swift ./build-toolchain.sh $(PWD)/.fetch/swift-$(VERSION)-$(PLATFORM).tar.gz

testbuild:
	rm -rf my-test-app
	mkdir -p my-test-app && cd my-test-app && swift package init --type=executable
	cd my-test-app && swift build --destination $(BUILD_DIR)/swift-$(MAIN_VERSION)-$(PLATFORM).xtoolchain/destination.json

test-rebuild:
	cd my-test-app && swift build --destination $(BUILD_DIR)/swift-$(MAIN_VERSION)-$(PLATFORM).xtoolchain/destination.json

#DOCKER_IMAGE=swift:5.3.3-focal
DOCKER_IMAGE=swift:5.6.2-focal

# ld.so doesn't seem to be setup properly, ld.so.conf.d doesn't include
# the `/usr/lib/swift/linux`
testbuild-run:
	docker run --rm -t 		\
		--name test-x-build \
		--volume "$(PWD)/my-test-app/.build/debug:/run" \
		--workdir "/run" 		\
		$(DOCKER_IMAGE) 		\
		bash -c "LD_LIBRARY_PATH=/usr/lib/swift/linux ./my-test-app"

testbuild-bash:
	docker run --rm -it 		\
		--name test-x-build \
		--volume "$(PWD)/my-test-app/.build/debug:/run" \
		--workdir "/run" 		\
		$(DOCKER_IMAGE) 		\
		bash
