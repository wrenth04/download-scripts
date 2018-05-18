#!/bin/bash

from=$1
to=$2
FID=

if [ "x$from" = "x" ]; then from=1; fi
if [ "x$to" = "x" ]; then to=$from; fi

p=$from
while [ $p -le $to ]; do
  x=$(wget -q -O - -U Mozilla "http://www.jav777.cc/page/$p")
  x2=${x#*post-title}
  while [ "$x" != "$x2" ]; do
    echo "page $p"
    url=${x2#*href=\"}; url=${url%%\"*}
    title=${x2#*title=\"}; title=${title%%\"*}
    img=${x2%% sizes*}; img=${img% *}; img=${img##* }

    x=${x2}
    x2=${x#*post-title}
    n=$(gdrive list -q "name='$title.mp4' and trashed=false" | wc -l)
    if [ $n != 1 ]; then continue; fi
    node launchChrome.js 

    echo $img
    echo $url
    echo $title
    video=$(node jav777.js "$url" | head -n 1)
    echo $video

    echo "Download $title"
    ffmpeg -y -nostdin -i "$video" -c copy "$title.mp4"
    gdrive upload -p $FID "$title.mp4"
    #ffmpeg -y -nostdin -i "$video" -c copy -f mp4 pipe:1 | gdrive upload - -p $FID "$title.mp4"
    rm "$title.mp4"
    wget -U Mozilla -q -O - "$img" | gdrive upload - -p $FID "$title.jpg"
  done
  p=$((p+1))
done
