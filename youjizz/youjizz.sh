#!/bin/bash

url=$1

html=$(wget -q -O - -U Mozilla "$url")

title=$(echo "$html" | grep title | sed 's/\//\./g')
title=${title#*title>}; title=${title%%<*} 
title=$(echo "$title" | sed 's/ share.*//')
video=$(echo "$html" | grep _hls | sed 's/\\\//\//g')
video=${video%%_hls*}; video=${video%{*}; video=${video##*filename\":\"}; video="https:${video%%\"*}"

echo $title
wget -U Mozilla -O "$title.mp4" "$video"

