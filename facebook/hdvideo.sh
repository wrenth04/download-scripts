#!/bin/bash

#https://www.facebook.com/will.fans/videos/1727290680633402/
url=$1

html=$(wget -U "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36" -q -O - "$url")

thtml=$(echo "$html" | grep "pageTitle")
title=${thtml#*pageTitle\">}; title=${title%%<*}
echo "download $title"

for q in 1080p 720p 480p; do
  x=$(echo "$html" | grep "\"$q")
  if [ "x$x" = "x" ]; then continue; fi

  video=${x#*$q}; video=${video#*http}; video=${video%%\\x3C*}
  video=$(echo "$video" | sed "s/\&amp;/\&/g")

  wget -U Mozilla -O "$title.$q.mp4" "http$video"

  break
done


