#!/bin/bash

url=$1

html=$(wget -O - -q -U Mozilla "$url")
vid=${html#*videos\":{\"}; vid=${vid%%\"*}

json=$(wget -O - -q -U Mozilla "https://video-api.yql.yahoo.com/v1/video/sapi/streams/$vid?protocol=http&format=mp4%2Cwebm&srid=1358170914&rt=html&devtype=desktop&offnetwork=false&region=TW&site=tv&expb=&expn=y20&lang=zh-Hant-TW&width=830&height=467&resize=true&ps=e8rvk3qc&autoplay=true&image_sizes=&excludePS=true&acctid=686&synd=&pspid=2144374991&plidl=&topic=&pver=7.86.605.1505274470&try=1&failover_count=1&firstVideo=$vid&env=prod")

video=${json%\",\"width\":1920*};
host=${video%\",\"path*}; host=${host##*\"}
video=${video##*\"}

title=${json#*title\":\"}; title=${title%%\"*}
title=$(echo "$title" | sed "s/\//\./g")

echo "download $title"
wget -O "$title.mp4" -U Mozilla "$host$video"
