#!/bin/bash

#https://www.facebook.com/will.fans/videos/1727290680633402/
url=$1

html=$(wget -U Mozilla -q -O - "$url")

video=${html#*video:}; video=${video#*url:\"}; video=${video%%\"*}
title=${html#*pageTitle\">}; title=${title%%<*}

echo "download $title"

wget -U Mozilla --referer "$url" -O "$title.mp4" "$video"
