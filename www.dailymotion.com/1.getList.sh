#!/bin/bash

search="keyword"

for p in {1..19}; do
  echo $p
  wget -U Mozilla -q -O - "https://www.dailymotion.com/tw/relevance/universal/search/$search/$p" | pup ".media-block a attr{href}" >> list.txt
done
