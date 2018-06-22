#!/bin/bash

url=$1
id=${url#*/t/}; id=${id%%/*}

html=$(wget -U Mozilla -q -O - "$url" | gzip -d)
html=${html#*listtags}

x=${html}
x2=${x#*<li>}

while [ "$x" != "$x2" ]; do
  url=${x2#*href=\"}; url=${url%%\"*}
  title=${x2#*p_title}; title=${title#*blank\">}; title=${title%%<*}
  title=$(echo "$title" | sed 's/\//\./g')
  echo "$url $title"
break

  x=${x2}
  x2=${x#*<li>}
done | while read url title; do
  echo "Download $url $title"
  if [ -e "$title" ]; then continue; fi

  mkdir "$title"
  aid=${url#*/item/}; aid=${aid%%.html}
  i=1
  while :; do
    echo -ne "\r$i..."
    output="$title/$title-$i.jpg"
    wget -U Mozilla --referer "$url" -O "$output" -q "https://mtl.ttsqgs.com/images/img/$aid/$i.jpg"
    i=$((i+1))
    e=$(ls -l "$output" | grep " 0 ")
    if [ "x$e" != "x" ]; then 
      rm "$output"
      break
    fi
  done
done
