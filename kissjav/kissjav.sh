#!/bin/bash

url="$1"

html=$(wget -U Mozilla -q -O - "$url")
title=${html#*og:title};
title=${title#*content=\"}; title=${title%%\"*}
video=${html#*content-tab-download}
video=${video#*href=\"}; video=${video%%\"*}
img=${html#*og:image}
img=${img#*content=\"}; img=${img%%\"*}

echo "$title"
echo "$img"
echo "$video"

title=$(echo "$title" | sed 's/\//\./g' | sed 's/  */ /g')
wget -U Mozilla --referer "$url" -O "$title.jpg" "$img"
wget -U Mozilla --referer "$url" -O "$title.mp4" "$video"
