#!/bin/bash

bookId=171
from=118283
to=120010
output="a.txt"

progress() {
  from=$1
  to=$2
  page=$3
  
  all=$((to - from))
  num=$((page - from))
  p=$((num * 100 / all))
  echo -ne "$num/$all($p%) "
}

page=$from
while [ $page -le $to ]; do
  for i in {1..10}; do
    url="https://hetubook.com/book/$bookId/$page.html"
    html=$(wget -w 5 -U Mozilla -q -O - "$url")
    #next=${html%id=\"next*}; next=${next##*href=\"}; next="https://hetubook.com${next%%\"*}"
    content=${html#*id=\"content\">}; content=${content%</div*}
    title=${content#*h2\">}; title=${title%%<*}
    content=${content#*h2>}
    content=$(echo "$content" | sed 's/></>\\n\\n</g' | sed 's/<[^>]*>//g' | sed 's/http.*[mｍ]//g')
    if [ "x$content" != "x" ]; then break; fi
  done
  if [ $i = 10 ]; then
    echo "miss $url" >> "$output"
  fi

  echo "$(progress $from $to $page) $title - $page"
  echo -ne "
$title

$content

" >> "$output"
  #echo $next

  page=$((page + 1))
done
