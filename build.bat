@echo off
git submodule init
git submodule update
git pull --recurse-submodules
rem Use command below in Powershel 7.x directly if prefered:
rem odin build . -define:BUILDTS="$(date)" -strict-style -vet
odin build . -define:BUILDTS="%date%" -strict-style -vet
