#!/bin/bash

export ELECTRON_IS_DEV=0

electron-1.7 --app=/usr/lib/hyper/app.asar $@
