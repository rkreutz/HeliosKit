#! /bin/zsh -e

source ".scripts/functions.sh"

DEFAULT_VERSION='0.3.1'

if [ "dev" = "$1" ]; then
    log::message "Building development version"
    /bin/zsh ".scripts/dev.sh" $2
elif test -f ".scripts/$1.sh"; then
    log::message "Building version $1"
    /bin/zsh ".scripts/$1.sh" $2
else
    log::message "Building version $DEFAULT_VERSION"
    /bin/zsh ".scripts/$DEFAULT_VERSION.sh" $1
fi
