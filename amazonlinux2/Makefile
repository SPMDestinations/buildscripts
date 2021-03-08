# Makefile
#
# Created by Helge Heß
# Copyright © 2020 ZeeZide GmbH. All rights reserved.

# This is a Makefile variant for direct consumption. Plus some extra stuff
# for testing purposes.
# AmazonLinux 2 version

prefix=/usr/local
# This is required because we need to hardcode the destination.json to the
# actual location.
ACTUAL_DESTINATION_PREFIX=/usr/local

# 5.3 release URL:
# https://swift.org/builds/swift-5.3-release/amazonlinux2/swift-5.3-RELEASE/swift-5.3-RELEASE-amazonlinux2.tar.gz
VERSION=5.3
BRANCH=swift-$(VERSION)-release
SNAPSHOT=RELEASE
HOST_VERSION=$(VERSION)
TARBALL_VERSION=$(VERSION)

# 5.3 dev URL:
# https://swift.org/builds/swift-5.3-branch/amazonlinux2/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a/swift-5.3-DEVELOPMENT-SNAPSHOT-2020-08-15-a-amazonlinux2.tar.gz
#BRANCH=development
#SNAPSHOT=SNAPSHOT-2020-08-15-a
#TARBALL_VERSION=DEVELOPMENT


ARCH=x86_64
TARGET=$(ARCH)-unknown-linux
LINUX_TARGET_TRIPLE=$(ARCH)-linux-gnu
PLATFORM=amazonlinux2
PACKAGE_URL=https://swift.org/builds/$(BRANCH)/$(subst .,,$(PLATFORM))/swift-$(TARBALL_VERSION)-$(SNAPSHOT)/swift-$(TARBALL_VERSION)-$(SNAPSHOT)-$(PLATFORM).tar.gz

HOST_SWIFT_TOOLCHAIN=/usr/local/lib/swift/xctoolchains/$(ARCH)-apple-darwin/$(HOST_VERSION)-current/swift.xctoolchain
HOST_X_LLD=$(SWIFT_LIB_DIR)/clang-llvm/${HOST_PLATFORM}-apple-darwin/8.0.0/bin/lld


INSTALL_PREFIX=$(BUILD_DIR)

BUILD_DIR=$(PWD)/.build
FETCH_DIR=$(PWD)/.fetch
PATCH_DIR=$(BUILD_DIR)/patch

DESTDIR_PREFIX=$(prefix)/lib/swift/dst/x86_64-unknown-linux/

PACKAGE_FETCH_FILENAME=swift-$(VERSION)-$(PLATFORM).tar.gz
PACKAGE_FETCH_FILE=$(FETCH_DIR)/$(PACKAGE_FETCH_FILENAME)

#APT_DISTRIBUTION_NAME=xenial
#APT_PLATFORM=amd64
#APT_REPOSITORY_URL=http://de.archive.ubuntu.com/ubuntu
#APT_PACKAGES_FILE_URL=$(APT_REPOSITORY_URL)/dists/$(APT_DISTRIBUTION_NAME)/main/binary-$(APT_PLATFORM)/Packages.gz

ALX_awsdomain=amazonaws.com
ALX_awsregion=default
ALX_product=core
ALX_target=latest
ALX_basearch=$(ARCH)
ALX_releasever=2
ALX_CORE_MIRROR_LIST="http://amazonlinux.${ALX_awsregion}.${ALX_awsdomain}/${ALX_releasever}/${ALX_product}/${ALX_target}/${ALX_basearch}/mirror.list"
ALX_BLOBSTORE_URL="https://cdn.amazonlinux.com/blobstore"


MKDIR=mkdir
CP=cp
LN_S=ln -s
RM_RF=rm -rf
PGK_FETCHER=curl -L --fail --show-error
DIRDIFF=diff -ruN

all: patch-5.2/build.patch patch-5.3/build.patch
#all: local-build
	
help:
	@echo $(PACKAGE_URL)
	@echo "make retrieve-packages"
	@echo "make build-toolchain"
	@echo "testbuild"

local-build: $(PACKAGE_FETCH_FILE) retrieve-packages build-toolchain

$(PACKAGE_FETCH_FILE):
	$(MKDIR) -p $(FETCH_DIR)
	@echo "Fetching upstream package:"
	@echo "  $(PACKAGE_URL)"
	(if ! test -f $@; then $(PGK_FETCHER) -o $@ $(PACKAGE_URL); fi)

install:
	echo TODO
	exit 42

clean:
	$(RM_RF) $(BUILD_DIR)

distclean: clean
	$(RM_RF) $(FETCH_DIR)
	
	
# patches

swift-5.2-patch: patch-5.2/build.patch
	
patch-5.2/build.patch: packagelist.make Makefile retrieve-sdk-packages.sh build-toolchain.sh patch-5.2/Makefile
	$(RM_RF) $@
	$(RM_RF) $(PATCH_DIR)
	$(MKDIR) -p $(PATCH_DIR)/empty
	$(MKDIR) -p $(PATCH_DIR)/patched
	$(CP) -ac retrieve-sdk-packages.sh $(PATCH_DIR)/patched/
	$(CP) -ac packagelist.make         $(PATCH_DIR)/patched/
	$(CP) -ac build-toolchain.sh       $(PATCH_DIR)/patched/
	$(CP) -ac patch-5.2/Makefile       $(PATCH_DIR)/patched/
	(cd $(PATCH_DIR); $(DIRDIFF) empty patched > $(PWD)/$@ ; [ $$? -eq 1 ])
	cat patch-5.2/build.patch | shasum -a 256


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

# package download

include packagelist.make

retrieve-packages:
	BUILD_DIR=$(BUILD_DIR) FETCH_DIR=$(FETCH_DIR)	\
	TARGET_ARCH=$(ARCH)				\
	LINUX_TARGET_TRIPLE=$(LINUX_TARGET_TRIPLE)	\
	TARGET_PLATFORM=$(PLATFORM)			\
	TARGET_SDK_NAME=$(ARCH)-$(PLATFORM).sdk 	\
	ALX_CORE_MIRROR_LIST=$(ALX_CORE_MIRROR_LIST)	\
	ALX_BLOBSTORE_URL=$(ALX_BLOBSTORE_URL)		\
	./retrieve-sdk-packages.sh "$(PACKAGE_NAMES)"


# toolchain builder

build-toolchain: $(PACKAGE_FETCH_FILE)
	SWIFT_VERSION=$(VERSION)			\
	HOST_SWIFT_TOOLCHAIN=$(HOST_SWIFT_TOOLCHAIN)	\
	TARGET_ARCH=$(ARCH)				\
	TARGET_PLATFORM=$(PLATFORM)			\
	HOST_X_LLD=$(HOST_X_LLD) \
	INSTALL_PREFIX=$(INSTALL_PREFIX) \
	./build-toolchain.sh $(PWD)/.fetch/swift-$(VERSION)-$(PLATFORM).tar.gz


# build test app

testbuild:
	rm -rf my-test-app
	mkdir -p my-test-app && cd my-test-app && swift package init --type=executable
	cd my-test-app && swift build --destination $(BUILD_DIR)/swift-$(VERSION)-$(PLATFORM).xtoolchain/destination.json

test-rebuild:
	cd my-test-app && swift build --destination $(BUILD_DIR)/swift-$(VERSION)-$(PLATFORM).xtoolchain/destination.json

DOCKER_IMAGE=swift:5.2.4-amazonlinux2

# ld.so doesn't seem to be setup properly, ld.so.conf.d doesn't include
# the `/usr/lib/swift/linux`
testbuild-run:
	docker run --rm -t 			\
		--name test-x-build		\
		--volume "$(PWD)/my-test-app/.build/debug:/run" \
		--workdir "/run" 		\
		$(DOCKER_IMAGE) 		\
		bash -c "LD_LIBRARY_PATH=/usr/lib/swift/linux ./my-test-app"

testbuild-bash:
	docker run --rm -it 			\
		--name test-x-build 		\
		--volume "$(PWD)/my-test-app/.build/debug:/run" \
		--workdir "/run" 		\
		$(DOCKER_IMAGE) 		\
		bash
	