#! /bin/zsh -e

source "Build Scripts/functions.sh"

set -e

PACKAGE_VERSION=999.0.0
HELIOS_VERSION=0.1.3

env::setup
env::build_configuration $1

if [ ! -d $HELIOS_DIRECTORY ]; then
    log::error "Build the latest version before startig development"
    exit -1
else
    cd $HELIOS_DIRECTORY
fi

rust::setup

# Change the target to the one you will use for development
rust::build_target x86_64-apple-ios
#rust::build_ios
#rust::build_ios_sim
#rust::build_macos
#rust::build

build::lipo
build::generate_c_headers
build::xcframework

post_build::compress
post_build::copy_bridge_files
post_build::success
