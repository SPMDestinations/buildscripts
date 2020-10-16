#!/bin/bash
#
# Based on
#     - https://github.com/apple/swift-package-manager/blob/main/Utilities/build_ubuntu_cross_compilation_toolchain

# by Johannes Weiß
# Adjustments by Helge Heß <me@helgehess.eu>

# This script fetches Debian packages from the upstream Linux distribution.
# Arguments: Package names

BUILD_DIR=${PWD}/.build
FETCH_DIR=${PWD}/.fetch
TARGET_ARCH=${TARGET_ARCH:=x86_64}
LINUX_TARGET_TRIPLE="${TARGET_ARCH}-linux-gnu"
TARGET_PLATFORM=${TARGET_PLATFORM:=amazonlinux2}
TARGET_SDK_NAME=${TARGET_SDK_NAME:="${TARGET_ARCH}-${TARGET_PLATFORM}.sdk"}

ALX_awsdomain=amazonaws.com
ALX_awsregion=default
ALX_product=core
ALX_target=latest
ALX_basearch=${TARGET_ARCH}
ALX_releasever=2
ALX_CORE_MIRROR_LIST=${ALX_CORE_MIRROR_LIST:="http://amazonlinux.${ALX_awsregion}.${ALX_awsdomain}/${ALX_releasever}/${ALX_product}/${ALX_target}/${ALX_basearch}/mirror.list"}
ALX_BLOBSTORE_URL=${ALX_BLOBSTORE_URL:="https://cdn.amazonlinux.com/blobstore"}

#APT_REPOSITORY_URL=${APT_REPOSITORY_URL:="http://gb.archive.ubuntu.com/ubuntu"}
#APT_PACKAGES_FILE_URL=${APT_PACKAGES_FILE_URL:="${APT_REPOSITORY_URL}/dists/xenial/main/binary-amd64/Packages.gz"}

IFS=', ' read -r -a pkg_names <<< "$1"

set -e

export PATH="/bin:/usr/bin"

# set -xv


# ******************* Helper Functions *****************************

# url
function download_stdout() {
    curl --fail -s "$1"
}

# url, key
function download_with_cache() {
    mkdir -p "${FETCH_DIR}"
    local out
    out="${FETCH_DIR}/$2"
    if [[ ! -f "$out" ]]; then
      curl --fail -s -o "$out" "$1"
    fi
    echo "$out"
}


# dst, file
function unpack_rpm() {
    local tmp
    tmp=$(mktemp -d /tmp/.unpack_rpm_XXXXXX)
    (
      cd "$tmp"
      tar -C "$1" -xf $2
    )
    rm -rf "$tmp"
}
# dst, file
function unpack_deb() {
    local tmp
    tmp=$(mktemp -d /tmp/.unpack_deb_XXXXXX)
    (
    cd "$tmp"
    ar -x "$2"
    tar -C "$1" -xf data.tar.*
    )
    rm -rf "$tmp"
}

# dst, file
function unpack() {
    ext=${2##*.}
    "unpack_$ext" "$@"
}


# ******************* Switch to target directory *******************

rm -rf   "${BUILD_DIR}/${TARGET_SDK_NAME}"
mkdir -p "${BUILD_DIR}/${TARGET_SDK_NAME}"

pkgs=()

if [[ "x${APT_REPOSITORY_URL}" != "x" ]]; then
  echo "Fetching APT download URLs for packages ..."
  # This is downloading the packages in `pkg_names`,
  # first ist fetchs the packages file.
  # weissi: Oopsie, this is slow but seemingly fast enough :)
  while read -r line; do
      for pkg_name in "${pkg_names[@]}"; do
          if [[ "$line" =~ ^Filename:\ (.*\/([^/_]+)_.*$) ]]; then
              # echo "${BASH_REMATCH[2]}"
              if [[ "${BASH_REMATCH[2]}" == "$pkg_name" ]]; then
                  new_pkg="${APT_REPOSITORY_URL}/${BASH_REMATCH[1]}"
                  pkgs+=( "$new_pkg" )
                  echo "- will download $new_pkg"
              fi
          fi
      done
  done < <(download_stdout "$APT_PACKAGES_FILE_URL" | gunzip -d -c | grep ^Filename:)
elif [[ "x${ALX_BLOBSTORE_URL}" != "x" ]]; then
  # FIXME: Similar to APT this should retrieve the YUM primary.sqlite3 and
  #        extract the desired URLs.
  for pkg_name in "${pkg_names[@]}"; do
    #ncurses-devel-6.0-8.20170212.amzn2.1.3.x86_64.rpm
    escaped=$(echo "${pkg_name}" | sed "s|\+|\%2B|g")
    new_pkg="${ALX_BLOBSTORE_URL}/${escaped}"
    pkgs+=( "$new_pkg" )
    echo "- will download $new_pkg"
  done
else
  echo "No package web location?"
fi

echo "Download and unpack packages into ${BUILD_DIR}/${TARGET_SDK_NAME} ..."
# Loop over the packages we want to fetch, and unpack them
tmp=$(mktemp -d "${BUILD_DIR}/tmp_pkgs_XXXXXX")
(
cd "$tmp"
for f in "${pkgs[@]}"; do
    name="$(basename "$f")"
    echo "  downloading: $name"
    archive="$(download_with_cache "$f" "$name")"
    if [[ -f "$archive" ]]; then
      unpack "${BUILD_DIR}/${TARGET_SDK_NAME}" "$archive"
    else
      echo "Failed to download: $name $f"
      exit 49
    fi
done
)
rm -rf "$tmp"

echo "Fixing absolute links in ${BUILD_DIR}/${TARGET_SDK_NAME} ..."
(
cd $BUILD_DIR

# fix absolute symlinks
find "$TARGET_SDK_NAME" -type l | while read -r line; do
    dst=$(readlink "$line")
    if [[ "${dst:0:1}" = / ]]; then
        rm "$line"
        fixedlink=$(echo "./$(dirname "${line#${TARGET_SDK_NAME}/}")" | sed 's:/[^/]*:/..:g')"${dst}"
        echo ln -s "${fixedlink#./}" "${line#./}"
        ln -s "${fixedlink#./}" "${line#./}"
    fi
done
)
