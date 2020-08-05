<h2>SPMDestinations
  <img src="http://zeezide.com/img/SwiftXcodePkgIcon.svg"
       align="right" width="128" height="128" />
</h2>

What is this? It's a set of Homebrew formulas (installation packages) to install
(and build) Swift cross compilers hosted on macOS.
For example it allows you to build a Swift Package Manager package on macOS,
but for Ubuntu Linux. Without running anything in Docker.

This repository contains helper scripts to build the patches necessary.
For information on the main project (and to file bug reports etc),
hop over to the [homebrew-tap](https://github.com/SPMDestinations/homebrew-tap).


Many parts of those scripts built upon the
[script](https://github.com/apple/swift-package-manager/blob/master/Utilities/build_ubuntu_cross_compilation_toolchain)
by [Johannes Weiß](https://github.com/weissi).


The scripts in here separate out the script into three steps:
1. Grabbing lld from a prebuilt binary CLang/LLVM tarball
2. Grabbing and unpacking a host Swift toolchain
3. Building a Linux Swift SDK:
3.1. Downloading and unpacking the target Swift toolchain 
3.2. Grabbing the RPM/Debian package for the target Linux
3.3. Fixing up absolutes pathes and module maps

Some of the scripts in here are designed to run standalone.
Those with a `patch-` generate patches for specific Homebrew formulas.

E.g. the `ubuntu16.04` directory contains a Makefile/scripts at the top
which are built to create the toolchain in a .build directory.
The `ubuntu16.04/patch-5.3` directory contains the things used in an actual
Homebrew formula patch.

The Swift Formula's are designed so that they have the Swift.org toolchain
as their primary package URL. We then use Homebrew patch URLs to adjust the
toolchains (they inject a makefile and the necessary scripts).


### Who

**SPMDestinations** is brought to you by
[ZeeZide](http://zeezide.de).
We like feedback, GitHub stars, cool contract work,
presumably any form of praise you can think of.
