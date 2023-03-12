#! /bin/zsh -e

source "Build Scripts/functions.sh"

DEFAULT_VERSION='0.1.5'

if [ "dev" = "$1" ]; then
    log::message "Building development version"
    /bin/zsh "Build Scripts/dev.sh" $2
elif test -f "Build Scripts/$1.sh"; then
    log::message "Building version $1"
    /bin/zsh "Build Scripts/$1.sh" $2
else
    log::message "Building version $DEFAULT_VERSION"
    /bin/zsh "Build Scripts/$DEFAULT_VERSION.sh" $1
fi
