#!/bin/bash

url="$1"
url=${url:-https://hpjav.tv/tw/category/chinese-subtitles}

base=${url%%/page*}
from=${url##*/page/}
if [ "$url" = "$from" ]; then 
  from=1
fi

html=$(wget -U Mozilla -q -O - "$url")
n=$(echo "$html" | grep "Last Page" | wc -l)
if [ $n != 0 ]; then
  to=${html%Last Page*}; to=${to##*page/}; to=${to%%\'*}
else
  to=1
fi

page=$from
while [ $page -le $to ]; do
  echo "download $base/page/$page, total: $to"
  html=$(wget -U Mozilla -q -O - "$base/page/$page")
  x=${html}
  x2=${x#*video-item\"}

  while [ "$x" != "$x2" ]; do
    link=${x2#*href=\"}; link=${link%%\"*}
    echo $link
    ./hpjav.sh $link
    x=${x2}
    x2=${x#*video-item\"}
  done

  page=$((page+1))
done
