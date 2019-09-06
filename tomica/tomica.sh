#!/bin/bash

for i in {1..140}; do
  id=$((i+1000)); id=${id#1}
  wget -O regular-$id.jpg https://www.takaratomy.co.jp/products/tomica/lineup/regular/images/$id.jpg
done
