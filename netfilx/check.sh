#!/bin/bash

countries="pn pt pw ad af al am at az ba rs ru bg sg si by sk ch cy tj cz tm ua ee uz fm ge gi gr hr hu kg kr kz li lt lv md me mh mk mo mp pr ps py qa ae ag ai an ao aq ar as re au aw ax ro bb bd be bf rw bh bi bj bl bm bn bo sa sb bq sc br sd bs bt se bv sh bw sj bz sl sm sn so ca sr cc ss st cd cf sv cg sx ci sz ck cl cm co tc cr td tf cu tg cv th cw cx tk tl tn to tr tt de tv tw tz dj dk dm do ug dz um us ec eg eh uy va er vc es et ve vg vi vn vu fi fj fk fo fr wf ga gb ws gd gf gg gh gl gm gn gp gq gs gt gu gw gy hk hm hn ye ht id yt ie il im in io za iq ir is it zm je zw jm jo jp ke kh ki km kn kw ky la lb lc lk lr ls lu ly ma mc mf mg ml mm mn mq mr ms mt mu mv mw mx my mz na nc ne nf ng ni nl no np nr nu nz om pa pe pf pg ph pk pl pm pn"

for c in $countries; do
  url="https://help.netflix.com/zh-tw/node/16282/$c"
  n=$(wget -O - -q -U "Mozilla" "$url" | grep "目前不提供" | wc -l)
  if [ $n = 0 ]; then
    grep "\.$c" code.txt
    echo "$url"
  fi
done
