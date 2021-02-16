<h2>SPMDestinations
  <img src="http://zeezide.com/img/SwiftXcodePkgIcon.svg"
       align="right" width="128" height="128" />
</h2>

The things necessary to build an x86_64 Ubuntu toolchain.

The root directory contains things to build a toolchain locally.
The `ubuntu20.04/patch-5.3` directory contains the things used in an actual
Homebrew formula patch.

### retrieve-sdk-packages.sh

There is the retrieve-sdk-packages.sh script which fetches the Debian packages
from an Ubuntu mirror, e.g. invoke it via `make retrieve-packages`.
It puts the packages into `.build/ubuntu-focal.sdk`.

### build-toolchain.sh

The `build-toolchain.sh` script takes:
- the non-Swift SDK built by `retrieve-sd-packages.sh`
- the binary host LLD 
- the unpacked host toolchain
and bundles everything up into the actual destination toolchain 
(.xtoolchain directory).

It also does the necessary patching.
