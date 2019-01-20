#!/bin/bash

url="$1"

html=$(wget -q -U Mozilla -O - "$url")

x=${html#*chapters}; x=${x%scoreRes*}
x2=${x#*href=\"}

while [ "$x" != "$x2" ]; do
  url=${x2%%\"*}
  n=$(echo "$url" | grep comic | wc -l)
  x=${x2}
  x2=${x#*href=\"}
  if [ $n = 0 ]; then continue; fi
  echo $url
  ./chapter.sh "https://tw.manhuagui.com$url"
done
