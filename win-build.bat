@echo off
git submodule init
git pull --recurse-submodules
git submodule update --remote --merge
rem Use command below in Powershel 7.x directly if prefered:
rem odin build . -define:BUILDTS="$(date)" -strict-style -vet
odin build . -define:BUILDTS="%date%" -strict-style -vet -o:speed
