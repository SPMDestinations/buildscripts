# packagelist.make
#
# Created by Helge Heß
# Copyright © 2020 ZeeZide GmbH. All rights reserved.
#
# OK, the `packages_files` is essentially the primary.sqlite.gz I suppose.
# Using this we could avoid the hardcoding of the package hashes:

# "${ALX_BLOBSTORE_URL}/d12a..1537ff7fb02e/glibc-devel-2.26-34.amzn2.x86_64.rpm"
PACKAGE_NAMES = \
  10ba20673d3b4ea230ca095140b418f8cdc694b90b0e8021ff1eaa5d01e674ae/gcc-7.3.1-6.amzn2.0.4.x86_64.rpm \
  74faca4ac8746c6369c6a701ca4f54e41bff4ce57c344a556042525a841d9046/gcc-c++-7.3.1-6.amzn2.0.4.x86_64.rpm \
  94a0c31b245df60e9332606b2900d5620d0a6e32f769bd7bfde56bcc7721b1d4/libgcc-7.3.1-6.amzn2.0.4.x86_64.rpm \
  7d952d019da52d2a612046739c84e0133e0aa83cd82317e0f77a15886ca7aed7/glibc-2.26-34.amzn2.x86_64.rpm \
  a63e42333f4e0b51ff0b184024a6b9b3ccba204924d4f3098e0f3205c465442f/glibc-static-2.26-34.amzn2.x86_64.rpm \
  d12adfb5d14224e877d39269007e9ac8261a63fd1f0964f46b241537ff7fb02e/glibc-devel-2.26-34.amzn2.x86_64.rpm \
  9749958937f840aa39299675adf81709e21c6e6bde7fcbe771ffa70abaececbd/glibc-headers-2.26-34.amzn2.x86_64.rpm \
  0a7b938a7b93ef8c955488bc0d7f4c26af8616de0297db55e670782f9472c77d/kernel-headers-4.14.181-140.257.amzn2.x86_64.rpm \
  69936fb4faa47c5327655623e1fca06a73fe61a99be6b7a95b676a6f9de18030/libicu-50.2-4.amzn2.x86_64.rpm \
  bbc96b51ef992c624a400d180c6dc3f8a3216d757abe8aecf71a22dff7afdda0/libicu-devel-50.2-4.amzn2.x86_64.rpm \
  0c543bfd8a78923dd79908e19893a91172de4e484532dbb4919b48aa1cb9c2f2/zlib-devel-1.2.7-18.amzn2.x86_64.rpm \
  8668d2f381ac2051c87538207711fe946fd56f301d22b1c6f7dc78c387245022/libuuid-2.30.2-2.amzn2.0.4.x86_64.rpm \
  64606879fc06aa733427c5e8d21439a859f6e05e091b51aed5e13a54a3e32895/libuuid-devel-2.30.2-2.amzn2.0.4.x86_64.rpm \
  552446b5e94791151e911a0340c2ff29884a568e7a9a06ace9e92e980207c2c1/libedit-devel-3.0-12.20121213cvs.amzn2.0.2.x86_64.rpm \
  3cc0779d8b962927ee741496bdfe43dacaae7cb54b15a30ea4fb8360b7c84627/libxml2-static-2.9.1-6.amzn2.3.3.x86_64.rpm \
  591d7fa97b6c532202896317103f97e9e80d65904e837d1c2918dc22a683c4d4/libxml2-devel-2.9.1-6.amzn2.3.3.x86_64.rpm \
  4e4cd21b65d516bc7165fda727fba148251d98be0d235cf35a0d71bb9ea9658d/sqlite-devel-3.7.17-8.amzn2.1.1.x86_64.rpm \
  2f8e739e42c8dc38f0399c807bbaa33388ba38a33811fb1bf81fea6cabfe85fc/python-devel-2.7.18-1.amzn2.x86_64.rpm \
  5bb9331e9b5ef78c12acb5df083a64e4d429e0dbca8b06e170c01b8727c085f3/ncurses-static-6.0-8.20170212.amzn2.1.3.x86_64.rpm \
  d9b6984d0bd7a63ac626d7884030e1da76b3142ac4822087bd7ea6ce719fa989/ncurses-devel-6.0-8.20170212.amzn2.1.3.x86_64.rpm \
  63d1cda56c322b12f042e3434fbfe0d78cae4ebe7465e09d225098589d0ce4c0/libcurl-devel-7.61.1-12.amzn2.0.1.x86_64.rpm \
  a7bf3d32ca223571a69330097cb53d86187d5b4f5e5643a1be76b1b73061dadb/openssl-static-1.0.2k-19.amzn2.0.3.x86_64.rpm \
  b4faa62839191a47bfdca65bc8d51dc657ccfd260dc80e1851e7dabcf9aafd17/openssl-devel-1.0.2k-19.amzn2.0.3.x86_64.rpm \
  2b013e46aa8367a842bd475f21cebee3477f5b2b56ee0c38652b8631b601be68/tzdata-2019c-1.amzn2.noarch.rpm \
  e7eb8fbe56e6bdcead90457638f3ed5d476e461605e9e517b81de2aa4383ea83/libtool-2.4.2-22.2.amzn2.0.2.x86_64.rpm \
  \
  8e41c178b123127d858b111e79bcf4fb02eebc0c140c859b5017a800320965cc/lua-static-5.1.4-15.amzn2.0.2.x86_64.rpm \
  7571938a62ff0561c2601547608e30bb219a883b646c2432ce56a57bacc96059/libpng-static-1.5.13-7.amzn2.0.2.x86_64.rpm \
  dc296d587514b4b5e4a39f1da99e7b9b9cbf4cc68be8c1a88a05818c4707f0d1/libtiff-static-4.0.3-32.amzn2.x86_64.rpm \
  e5391b3c3220bd4c02fcc451f24480d2a1c594ec7f1383ad6ddd1d5c6d0dcb85/libuv-static-1.23.2-1.amzn2.0.2.x86_64.rpm \
  d50cf7ce779436c187d5f0ac296c53a8c57d111e63484bea87a62dde1bb28f84/lz4-static-1.7.5-2.amzn2.0.1.x86_64.rpm \
  285504b02bdc1bb6bcad856f0b01da877835209f0bd35d4666773c77e3f85f87/pcre2-static-10.23-2.amzn2.0.2.x86_64.rpm \
  560cc04a2033747250c9c138a3694ead0fcae4a98dc856894f4205be9df863c4/popt-static-1.13-16.amzn2.0.2.x86_64.rpm \
  e694b8b1c2d5d63ce060954582d218dbe03930179d83edf96858e3b1e12a8f64/postgresql-static-9.2.24-1.amzn2.0.1.x86_64.rpm \
  304ccb92cdf992357a870a1a7f3a5ecf278dbae7ca18aa53c5b33825fd528532/zlib-static-1.2.7-18.amzn2.x86_64.rpm
