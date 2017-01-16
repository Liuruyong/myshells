#!/bin/sh
gsed -i "/end/i\    pod 'Reveal-SDK',\ '~> 5'" Podfile
pod update --no-repo-update
