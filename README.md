# Frabjous!

[![Build Status](https://travis-ci.org/csmk/frabjous.svg?branch=master)](https://travis-ci.org/csmk/frabjous)

Yet another personal [Gentoo](https://gentoo.org/) overlay. This overlay contain only ebuilds for packages that I'm interested in. It also include support for the upcoming `libressl` USE flag. So, for now I recommend to use this overlay in conjunction with the [libressl](https://github.com/gentoo/libressl) repository.

**DISCLAIMER:** This repository contains experimental ebuilds with extra added features. Use at your own risk! However, I've been using these packages in a production environment without major problems.

## How to install the overlay
You must have both `dev-vcs/git` and `app-portage/layman` installed on your system for this to work: `layman -a frabjous`

## Repository tree
```
    .
    ├── dev-db
    │   └── tidb
    ├── dev-go
    │   └── go-bindata
    ├── dev-libs
    │   └── libbrotli
    ├── mail-filter
    │   └── imapfilter
    ├── media-video
    │   └── gnome-mpv
    ├── net-dns
    │   ├── dnscrypt-wrapper
    │   └── knot
    ├── net-libs
    │   ├── nodejs
    │   └── wslay
    ├── net-misc
    │   └── stunnel
    ├── net-news
    │   └── feedreader
    ├── net-p2p
    │   ├── bitcoinclassicd
    │   ├── bitcoinclassic-qt
    │   ├── bitcoinxtd
    │   └── bitcoinxt-qt
    ├── www-apps
    │   ├── gogs
    │   ├── rocketchat
    │   └── wekan
    ├── www-client
    │   └── inox
    ├── www-servers
    │   ├── caddy-bin
    │   ├── nginx
    │   └── h2o
    └── x11-terms
        └── terminix-bin

```

## Tip Jar
Bitcoin donations are welcome: **18RsspfceUbXEqgzx29DuZYafZVDgM4F4g**

## Contributing
Contributions are welcome. Fork and create a pull request. Bugs to versions in the main gentoo tree should always be filed in the [Gentoo Bugzilla](https://bugs.gentoo.org/).

##Issues
Report bugs on the [github issues site](https://github.com/csmk/frabjous/issues)
