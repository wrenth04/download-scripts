#!/bin/bash

keyword="$1"
keyword=${keyword:-uncensored leaked}
keyword=$(echo "$keyword" | sed 's/ /\+/g')

page=1
end=9999

while [ $page -le $end ]; do
  html=$(wget -U Mozilla -q -O - "https://kissjav.com/search/video/?s=$keyword&page=$page")
  if [ $end = 9999 ]; then
    p=${html#*p}; p=${p%%prevnext*}
    p=${p%</a*}; p=${p##*>}
    end=$p
  fi

  x=${html}
  x2=${x#*class=\"video\"}
  while [ "$x" != "$x2" ]; do
    url=${x2#*href=\"}; url=${url%%\"*}
    ./kissjav.sh "https://kissjav.com$url"
    x=${x2}
    x2=${x#*class=\"video\"}
  done

  page=$((page+1))
done

