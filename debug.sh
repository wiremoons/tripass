#!/bin/zsh
#
# Use only if verbose output is required when running the application.
# See 'build.sh' for the normal 'release' build of the application.
printf "[!] WARNING : a debug build of the application will be created.\n"
odin build . -define:BUILDTS="$(date '+%a %d %b %Y @ %H:%M:%S %Z')" -strict-style -vet -o:none -debug
