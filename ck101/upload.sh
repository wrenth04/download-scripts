#!/bin/bash

folder=$1

gdrive upload --recursive -p $FID "$folder"
rm -rf "$folder"
