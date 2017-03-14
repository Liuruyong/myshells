#!/bin/sh
gsed -i "/end/i\    pod 'Reveal-SDK'" Podfile
cp -a ~/work/Reveal-SDK Pods/
pod update --no-repo-update
