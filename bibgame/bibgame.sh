#!/bin/bash

AGENT="Mozilla"

from=$1
to=$2

from=${from:-1}
to=${to:-999}

output="list_$(date '+%Y%m%d'_${from}_${to}.csv)"
echo "title, pan, code, link" >> $output

find_baidu() {
  link="https://bibgame.com$1"
  html=$(wget -q -O - -U "$AGENT" "$link")
  title=${html#*title>}; title=${title%%<*}
  title=${title%-游戏年轮*}
  y=${html}
  y2=${y#*pan.baidu}
  while [ "$y" != "$y2" ]; do
    pan="https://pan.baidu${y2%%<*}"; pan=${pan%提*}
    pan=$(echo "$pan" | sed 's/&nbsp;//g' | sed 's/ //g')
    code=${y2#*码}; code=${code%%<*}; code=${code%复*}
    code=$(echo "$code" | sed 's/&nbsp;//g' | sed 's/[：: ]//g')
    echo "$title, $pan, $code, $link"
    echo "$title, $pan, $code, $link" >> $output
    y=${y2}
    y2=${y#*pan.baidu}
  done
}

page=$from
while [ $page -le $to ]; do
  echo "page $page"
  if [ $page = 1 ]; then
    url="https://bibgame.com/sgame/"
  else
    url="https://bibgame.com/sgame/index_$page.html"
  fi

  html=$(wget -q -O - -U "AGENT" "$url")
  x=${html#*topicList}
  x2=${x#*img_box}

  while [ "$x" != "$x2" ]; do
    link=${x2#*href=\"}; link=${link%%\"*}
    find_baidu "$link"
    x=${x2}
    x2=${x#*img_box}
  done

  page=$((page+1))
done
