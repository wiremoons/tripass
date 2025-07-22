#!/bin/zsh

odin build . -define:BUILDTS="$(date '+%a %d %b %Y @ %H:%M:%S %Z')" -strict-style -vet -o:speed -obfuscate-source-code-locations
