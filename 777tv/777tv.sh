
u="https://777tv.net/vod/play/id/82428/sid/1/nid/"

for i in {1..39}; do
html=$(wget -O - -U Mozilla "$u$i.html")
m3u8=${html%%m3u8*}
m3u8=${m3u8##*\"}
m3u8=$(echo "$m3u8" | sed 's/\\\//\//g')
echo $m3u8

title=${html#*title>}; title=${title%%<*}; title=${title%% - *}
title=$(echo "$title" | sed 's/線上看//g')
echo $title
youtube-dl -o "$title.mp4" "${m3u8}m3u8"
done
