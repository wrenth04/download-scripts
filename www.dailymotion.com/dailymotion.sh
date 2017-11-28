#!/bin/bash

url=$1

html=$(wget -U Mozilla -q -O - "$url")

title=$(echo "$html" | grep "og:title")
title=${title#*content=\"}; title=${title%%\"*}
title=${title% - Dailymotion*}
title=$(echo "$title" | sed "s/\//\./g")

for q in "1920x1080" "1280x720" "848x480"; do
  video=$(echo "$html" | grep "$q")
  if [ "x" = "x$video" ]; then continue; fi
  video=${video##*$q}; video=${video%%\"*}
  video=$(echo $video | sed "s/\\\\\\//\\//g")
  break
done

wget -U Mozilla -O "$title.$q.mp4" "https://www.dailymotion.com/cdn/H264-$q$video"
