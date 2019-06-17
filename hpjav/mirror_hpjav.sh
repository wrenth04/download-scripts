#!/bin/bash

url="$1"
url=${url:-https://hpjav.tv/tw/category/chinese-subtitles}

if [ "${url}" = "${url#*http}" ]; then
  url="https://hpjav.tv/tw/?s=$url"
fi

base=${url%%/page*}; base=${base%\?*}
from=${url##*/page/}
if [ "$url" = "$from" ]; then 
  from=1
fi
from=${from%%\?*}; from=${from%%/*}
s=${url##*s=}
if [ "$url" != "$s" ]; then
  s="?s=$s"
else
  s=""
fi

html=$(wget -U Mozilla -q -O - "$url")
n=$(echo "$html" | grep "Last Page" | wc -l)
if [ $n != 0 ]; then
  to=${html%Last Page*}; to=${to##*page/}; to=${to%%\'*}; to=${to%\?*}
else
  to=1
fi

page=$from
while [ $page -le $to ]; do
  echo -e "\n$(date) download $base/page/$page$s, total: $to"
  html=$(wget -U Mozilla -q -O - "$base/page/$page$s")
  x=${html}
  x2=${x#*video-item\"}

  while [ "$x" != "$x2" ]; do
    link=${x2#*href=\"}; link=${link%%\"*}
    title=${x2#*alt=\"}; title=${title%%\"*}
    n=$(gdrive list -q "name contains '$title' and name contains 'hpjav.mp4' and trashed=false" | wc -l)
    x=${x2}
    x2=${x#*video-item\"}
    if [ $n != 1 ]; then continue; fi
    echo $link
    echo $title
    ./hpjav.sh $link
  done
  exit

  page=$((page+1))
done
