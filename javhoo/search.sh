#!/bin/bash

no=$1

html=$(wget -q -O - -U Mozilla "https://www.javhoo.com/av/$no")

title=${html#*keywords\" content=\"}; title=${title%%\"*}
echo $title

a1=${html}
a2=${a1#*href=\"magnet}
a2=${a2#*href=\"magnet}
while [ "$a1" != "$a2" ]; do
  magnet="magnet${a2%%\"*}"
  size=${a2#*>}; size=${size%%<*}
  a2=${a2#*href=\"magnet}
  
  echo "$magnet $size"

  a1=${a2}
  a2=${a1#*href=\"magnet}
  a2=${a2#*href=\"magnet}
done
