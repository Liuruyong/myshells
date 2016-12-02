#!/bin/sh
gsed -i "/end/i\    pod 'Reveal-SDK',\ '~> 4'" Podfile
pod update --no-repo-update
