#!/bin/bash

wget -O - https://get.docker.com/ | sudo sh

sudo docker run -d -p 443:22 wrenth04/tunnel
