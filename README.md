# Frabjous!
Yet another personal Gentoo overlay. This overlay contain only ebuilds for software I'm using. It also include support for the upcoming `libressl` USE flag.

## How to install the overlay
You must have both `dev-vcs/git` and `app-portage/layman` installed on your system for this to work:
```layman -f -o https://raw.githubusercontent.com/csmk/frabjous/master/overlay.xml -a frabjous```

## Repository Tree
```
    .
    ├── net-dns
    │   ├── ldns-utils
    │   └── nsd
    ├── net-p2p
    │   ├── bitcoinxtd
    │   └── bitcoinxt-qt
    └── dev-util
        └── nginx
```

##Issues
Report bugs on the [github issues site](https://github.com/csmk/frabjous/issues)
