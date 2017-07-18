# Frabjous! [![Build Status](https://img.shields.io/travis/csmk/frabjous/master.svg?style=flat-square)](https://travis-ci.org/csmk/frabjous)

### What the...
This overlay contain only ebuilds for packages that I'm interested in or that have been requested. It also include support for the upcoming `libressl` USE flag.

**Note**: As I don't own a machine with `systemd`, packages that use systemd unit files hasn't been tested. Although I try my best to follow the standards. If you find a bug, please report.

**DISCLAIMER:** All ebuilds are permanently in _test_ (~*) mode. As such, you should probably consider it to be _unsafe_ and treat it as such. Use at your own risk! However, I've been using these packages in a production environment without major problems.

## How to install the overlay
You must have both `dev-vcs/git` and `app-portage/layman` installed on your system for this to work.

Just run **`layman -a frabjous`**, then you'll be ready to emerge the _goodies_.

Alternatively, you can use it by adding this in `/etc/portage/repos.conf/frabjous.conf`:

```ini
[frabjous]
priority = 50
location = /usr/local/overlay/frabjous
sync-type = git
sync-uri = https://github.com/csmk/frabjous.git
auto-sync = Yes
```

## Repository tree
This is a list of packages available and their associated description:

Package | Description
--- | ---
app-benchmarks/**[bombardier](app-benchmarks/bombardier)** | Fast cross-platform HTTP benchmarking tool written in Go
app-benchmarks/**[hey](app-benchmarks/hey)** | HTTP load generator, ApacheBench (ab) replacement
app-benchmarks/**[vegeta](app-benchmarks/vegeta)** | HTTP load testing tool and library. It's over 9000!
app-crypt/**[acmetool](app-crypt/acmetool)** | An automatic certificate acquisition tool for ACME (Let's Encrypt)
app-crypt/**[minisign](app-crypt/minisign)** | A dead simple tool to sign files and verify digital signatures
app-crypt/**[opmsg](app-crypt/opmsg)** | opmsg message encryption (an alternative to GnuPG)
app-crypt/**[ssh-vault](app-crypt/ssh-vault)** | Encrypt/Decrypt using SSH private keys
app-editors/**[micro](app-editors/micro)** | A modern and intuitive terminal-based text editor
dev-db/**[pgweb](dev-db/pgweb)** | Web-based PostgreSQL database browser written in Go
dev-db/**[tidb](dev-db/tidb)** | A distributed NewSQL database compatible with MySQL protocol
dev-go/**[depth](dev-go/depth)** | Retrieve and visualize Go source code dependency trees
dev-libs/**[libbrotli](dev-libs/libbrotli)** | Builds libraries out of the brotli decode and encode sources
dev-util/**[electron](dev-util/electron)** | Cross platform application development framework based on web technologies
gnome-extra/**[nautilus-git](gnome-extra/nautilus-git)** | Nautilus extension to add important information about the current git directory
mail-filter/**[imapfilter](mail-filter/imapfilter)** | An IMAP mail filtering utility
media-video/**[curlew](media-video/curlew)** | Easy to use and Free Multimedia Converter for Linux
media-video/**[gnome-mpv](media-video/gnome-mpv)** | A simple GTK+ frontend for mpv
media-video/**[peek](media-video/peek)** | Simple animated GIF screen recorder with an easy to use interface
net-analyzer/**[goaccess](net-analyzer/goaccess)** | A real-time web log analyzer and interactive viewer that runs in a terminal
net-dns/**[dnscrypt-proxy](net-dns/dnscrypt-proxy)** | A tool for securing communications between a client and a DNS resolver
net-dns/**[dnscrypt-wrapper](net-dns/dnscrypt-wrapper)** | A server-side dnscrypt proxy
net-dns/**[knot-resolver](net-dns/knot-resolver)** | A caching full DNS resolver implementation written in C and LuaJIT
net-dns/**[knot](net-dns/knot)** | High-performance authoritative-only DNS server
net-dns/**[unbound](net-dns/unbound)** | A validating, recursive and caching DNS resolver
net-firewall/**[firehol](net-firewall/firehol)** | A firewall for humans...
net-im/**[dino](net-im/dino)** | A modern Jabber/XMPP Client using GTK+/Vala
net-libs/**[nodejs](net-libs/nodejs)** | A JavaScript runtime built on Chrome's V8 JavaScript engine
net-libs/**[wslay](net-libs/wslay)** | The WebSocket library written in C
net-misc/**[gotty-client](net-misc/gotty-client)** | A terminal client for GoTTY
net-misc/**[pget](net-misc/pget)** | A parallel file download client in Go
net-news/**[feedreader](net-news/feedreader)** | A modern desktop application designed to complement web-based RSS accounts
net-p2p/**[Sia](net-p2p/Sia)** | Blockchain-based marketplace for file storage
net-p2p/**[bitcoin-classic](net-p2p/bitcoin-classic)** | An alternative full node Bitcoin implementation with GUI, daemon and utils
net-p2p/**[bitcoin-unlimited](net-p2p/bitcoin-unlimited)** | An alternative full node Bitcoin implementation with GUI, daemon and utils
net-p2p/**[bitcoinxt](net-p2p/bitcoinxt)** | An alternative full node Bitcoin implementation with GUI, daemon and utils
net-p2p/**[drops](net-p2p/drops)** | A p2p transport network for opmsg end2end encrypted messages
net-p2p/**[zcash](net-p2p/zcash)** | Cryptocurrency that offers privacy of transactions
net-vpn/**[govpn](net-vpn/govpn)** | A VPN daemon aimed to be reviewable, secure and DPI/censorship-resistant
net-vpn/**[onioncat](net-vpn/onioncat)** | An IP-Transparent Tor Hidden Service Connector
sys-fs/**[gocryptfs](sys-fs/gocryptfs)** | Encrypted overlay filesystem written in Go
sys-process/**[gkill](sys-process/gkill)** | An interactive process killer
www-apps/**[gotty](www-apps/gotty)** | A simple command line tool that turns your CLI tools into web applications
www-apps/**[hugo](www-apps/hugo)** | A Fast and Flexible Static Site Generator built with love in GoLang
www-client/**[inox](www-client/inox)** | Chromium spin-off to enhance privacy by disabling data transmission to Google
www-servers/**[caddy](www-servers/caddy)** | Fast, cross-platform HTTP/2 web server with automatic HTTPS
www-servers/**[h2o](www-servers/h2o)** | An optimized HTTP server with support for HTTP/1.x and HTTP/2
www-servers/**[nginx](www-servers/nginx)** | Robust, small and high performance http and reverse proxy server
x11-apps/**[radeon-profile](x11-apps/radeon-profile)** | App for display info about radeon card
x11-apps/**[radeon-profile-daemon](x11-apps/radeon-profile-daemon)** | Daemon for radeon-profile GUI
x11-misc/**[noti](x11-misc/noti)** | Trigger notifications when a process completes

All commits are signed with the key ID `A6C7CA717170C3FD`. The key fingerprint is [`10E4 B84B FAB9 3923 F181 695F B0E3 361B A998 2E58`](https://keybase.io/csmk).

## Tip Jar
Bitcoin donations are welcome: **`18RsspfceUbXEqgzx29DuZYafZVDgM4F4g`**

## Requests and Issues
Yes, I do accept requests for new packages, but I do not promise to deliver, especially if the complexity of the package are far cry from my knowledge level. Bugs should always be filed in [github issues site](https://github.com/csmk/frabjous/issues).

## Contributing 
Contributions are welcome. Fork and create a pull request.
