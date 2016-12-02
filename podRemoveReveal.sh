#!/bin/sh
gsed -i /Reveal/d Podfile
pod update --no-repo-update
