#!/bin/bash

wget -O all.json "https://tw.portal-pokemon.com/play/pokedex/api/v1?pokemon_ability_id=&zukan_id_from=1&zukan_id_to=807"
node getlist.js | while read url name; do
  wget -O "$name" "$url"
done

