#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/travis-functions.sh" || exit 1

install_portage() {
	announce pip --verbose install 'lxml>=3.6,<3.7'
	announce .travis/install_portage.sh
}

install_portage
