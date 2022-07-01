<h2>SPMDestinations
  <img src="http://zeezide.com/img/SwiftXcodePkgIcon.svg"
       align="right" width="128" height="128" />
</h2>

A makefile to fetch and install a _host_ (i.e. macOS) Swift toolchain.
It has the commands to unpack the .pkg hosted on swift.org.

This is also done in the homebrew-tap, in the swift-xctoolchain-5.x.rb.
I.e. to add a new version, create a new swif-xctoolchain-5.x.rb variant.

This buildscript can be used to test what the homebrew tap does.


The URL to the Swift.org download is specified in the Makefile,
e.g.
```
https://download.swift.org/swift-5.6.2-release/xcode/swift-5.6.2-RELEASE/swift-5.6.2-RELEASE-osx.pkg
```

A make call looks like this:
```
helge@M1ni macos-swift $ make
mkdir -p .fetch
(if ! test -f .fetch/swift-5.6.2.pkg.xar; then \
	 curl -L -o .fetch/swift-5.6.2.pkg.xar https://download.swift.org/swift-5.6.2-release/xcode/swift-5.6.2-RELEASE/swift-5.6.2-RELEASE-osx.pkg;\
	 fi)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  923M  100  923M    0     0  17.9M      0  0:00:51  0:00:51 --:--:-- 17.6M
Unpacking toolchain pkg ..
(cd .build;\
	 xar -xf ../.fetch/swift-5.6.2.pkg.xar;\
	 mkdir -p swift.xctoolchain; cd swift.xctoolchain;\
	 cat ../*.pkg/Payload | gunzip -dc | cpio -i )
7443573 blocks
Toolchain unpacked.
```

The package is fetched into `.fetch` (~1GB) and the unpacked version is in
`.build`:
```
helge@M1ni macos-swift $ tree .fetch .build|head -n 20
.fetch
└── swift-5.6.2.pkg.xar
.build
├── Distribution
├── swift-5.6.2-RELEASE-osx-package.pkg
│   ├── Bom
│   ├── PackageInfo
│   ├── Payload
│   └── Scripts
└── swift.xctoolchain
    ├── Developer
    │   └── Platforms
    │       └── MacOSX.platform
    │           └── Developer
    │               └── Library
    │                   ├── Frameworks
    │                   │   ├── PlaygroundSupport.framework
    │                   │   │   ├── Headers -> Versions/Current/Headers
    │                   │   │   ├── Modules -> Versions/Current/Modules
    │                   │   │   ├── PlaygroundSupport -> Versions/Current/PlaygroundSupport
```
