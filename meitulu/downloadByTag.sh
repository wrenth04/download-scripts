#!/bin/bash

tags="$@"
if [ "x$tags" = "x" ]; then
  tags="dachidu"
fi

for tag in $tags; do
  html=$(wget -U Mozilla -q -O - "https://www.meitulu.com/t/$tag/" | gzip -d)
  page=${html%footer*}; page=${page%href*}
  page=${page##*href}; page=${page#*>}; page=${page%%<*}

  p=1
  while [ $p -le $page ]; do
    echo "page $p/$page"
    if [ $p = 1 ]; then
      ./meitulu.sh "https://www.meitulu.com/t/$tag/"
    else
      ./meitulu.sh "https://www.meitulu.com/t/$tag/$p.html"
    fi
    p=$((p+1))
  done
done
