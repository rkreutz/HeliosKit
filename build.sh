#! /bin/sh -e

DEFAULT_VERSION='0.1.4'

if test -f "Build Scripts/$1.sh"; then
    echo "\033[0;36m▸ Building version $1\033[0m"
    /bin/sh "Build Scripts/$1.sh" $2
else
    echo "\033[0;36m▸ Building version $DEFAULT_VERSION\033[0m"
    /bin/sh "Build Scripts/$DEFAULT_VERSION.sh" $1
fi
