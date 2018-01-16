#!/bin/bash

#https://www.facebook.com/will.fans/videos/1727290680633402/
url=$1

html=$(wget -U "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36" -q -O - "$url")

thtml=$(echo "$html" | grep "pageTitle")
title=${thtml#*pageTitle\">}; title=${title%%<*}
title=$(echo "$title" | sed "s/\//\./g")
ahtml=$(echo "$html" | grep "audio:")
audio=${ahtml#*audio:[}; audio=${audio#*url:\"}; audio=${audio%%\"*}
echo "download $title"

r=$RANDOM
wget -U Mozilla --referer "$url" -O "audio.$r.aac" "$audio"
for q in 1080p 720p 480p 360p; do
  x=$(echo "$html" | grep "\"$q")
  if [ "x$x" = "x" ]; then continue; fi
  break
done

video=${x#*$q}; video=${video#*http}; video=${video%%\\x3C*}
video=$(echo "$video" | sed "s/\&amp;/\&/g")

wget -U Mozilla --referer "$url" -O "video.$r.mp4" "http$video"
ffmpeg -y -nostdin -i "video.$r.mp4" -i "audio.$r.aac" -c copy "$title.$q.mp4"

if [ $? = 0 ]; then
  rm "video.$r.mp4"
  rm "audio.$r.aac"
fi

