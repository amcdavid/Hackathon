#!/bin/sh
parent="$1"
# This is fragile -- the gh-pages branch must exist, eg
# 1. git checkout --orphan gh-pages
# then remove everything except the leaderboard
#
# 2. Should actually track what branch was originally checked out and return
# repo to starting state if we fail midway
#branch=$(cd $parent && git branch)
pages=$(cd "$parent" && git checkout gh-pages)
cp Leaderboard.html "$parent"
cd "$parent" && git add Leaderboard.html && git commit -m 'update leaderboard' && git push origin gh-pages && git co master
