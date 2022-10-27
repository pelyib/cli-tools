#!/usr/bin/env bash

# Original snippet is from:
# https://coderwall.com/p/x3jmig/remove-all-your-local-git-branches-but-keep-master

git branch | grep -v $(git rev-parse --abbrev-ref HEAD) | grep 'feature\|bugfix' | xargs git branch -D
