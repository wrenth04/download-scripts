#!/bin/bash

from=$1
to=$2
FID=

if [ "x$from" = "x" ]; then from=1; fi
if [ "x$to" = "x" ]; then to=$from; fi

p=$from

while [ $p -le $to ]; do
  x=$(wget -q -O - -U Mozilla "https://javfinder.is/category/censored/page-$p.html")
  x2=${x#*main-thumb}
  while [ "$x" != "$x2" ]; do
    echo "page $p"
    url=${x2#*href=\"}; url="https://javfinder.is${url%%\"*}"
    title=${url##*/}; title=${title%\.html}
    n=$(gdrive list -q "name='$title.mp4' and trashed=false" | wc -l)
    if [ $n != 1 ]; then continue; fi
    node launchChrome.js 
    video=$(node javfinder.js "$url" | head -n 1)
    img=${x2#*data-src}; img=${img#*url=}; img=${img%%\"*}

    echo "Download $title"
    wget -U Mozilla -q -O - "$video" | gdrive upload - -p $FID "$title.mp4"
    wget -U Mozilla -q -O - "$img" | gdrive upload - -p $FID "$title.png"
    x=${x2}
    x2=${x#*main-thumb}
  done
  p=$((p+1))
done
