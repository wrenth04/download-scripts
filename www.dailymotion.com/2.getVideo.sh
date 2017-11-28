#!/bin/bash

cat list.txt | while read url id; do
  ./dailymotion.sh "https://www.dailymotion.com$url"
done
