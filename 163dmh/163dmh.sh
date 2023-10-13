#!/bin/bash

list="$1"

#head -n1 "$1" | while read url title; do
cat "$1" | while read url title; do
  echo $title $url
  mkdir "$title"
  cd "$title"
  p=1
  i=$((p*5-4))
  while :; do
    html=$(wget -T 10 -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36" --no-check-certificate -O - "${url%\.html}-$p.html")
        x1="$html"; x2=${x1#*image-content}
        while [ "x$x1" != "x$x2" ]; do
          x1="$x2"; x2=${x1#*image-content}
          id=$((i+1000)); id=${id#1}
          i=$((i+1))
          img=${x1#*src=\"}; img=${img%%\"*}
          wget -T 10 -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36" --no-check-certificate -O "$title-$id.jpg" "$img"
          sleep 0.5
        done
        p=$((p+1))

    pageinfo=${html%%UCBrowser*}
    pageinfo=${pageinfo%<\/p>*}
    pageinfo=${pageinfo##*<p>}
    p1=${pageinfo%\/*}; p2=${pageinfo#*\/}
        echo "$p1/$p2"
        if [ $p1 = $p2 ]; then break; fi
        sleep 10
  done
  cd -
done
