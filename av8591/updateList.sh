#!/bin/bash

data=$(wget -O - "http://www.av8591.com/feeds/posts/summary?alt=json-in-script&callback=showpageCount&max-results=99999")
data=${data#*(}; data=${data%)*}
echo "$data" > data.json

node index.js > list.txt
