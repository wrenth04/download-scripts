#!/bin/bash

keyword=$1
p=$2
if [ "x$keyword" = "x" ]; then exit; fi

#https://v.jav101.com/search/FC2/1?order=time
if [ "x$p" = "x" ]; then p=1; fi
page=999

while [ $p -le $page ]; do
  html=$(wget -U Mozilla -q -O - "https://v.jav101.com/search/$keyword/$p?order=time")

  if [ $page = 999 ]; then
    page=${html#*page_index}
    page=${page%</option*}
    page=${page##*>}
  fi

  if [ "x$page" = "x" ]; then page=1; fi

  x=${html}  
  x2=${x#*\"videoBox\"}

  while [ "$x" != "$x2" ]; do
    id=${x2#*/play/}
    id=${id%%\"*}
    echo "$keyword page $p/$page"
    ./jav101.sh "https://v.jav101.com/play/$id"
   
    x=${x2}  
    x2=${x#*\"videoBox\"}
  done

  p=$((p+1))
done
