#!/bin/bash

#https://www.facebook.com/will.fans/videos/1727290680633402/
url=$1

html=$(wget -U Mozilla -q -O - "$url")

video=${html#*video:}; video=${video#*url:\"}; video=${video%%\"*}
title=${html#*pageTitle\">}; title=${title%%<*}
audio=${html#*audio:[}; audio=${audio#*url:\"}; audio=${audio%%\"*}

echo "download $title"

r=$RANDOM
echo $audio
wget -U Mozilla --referer "$url" -O "video.$r.mp4" "$video"
wget -U Mozilla --referer "$url" -O "audio.$r.aac" "$audio"

ffmpeg -y -nostdin -i "video.$r.mp4" -i "audio.$r.aac" -c copy "$title.mp4"

if [ $? = 0 ]; then
  rm "video.$r.mp4"
  rm "audio.$r.aac"
fi