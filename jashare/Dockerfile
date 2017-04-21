FROM node
RUN apt-get update && \
  apt-get install -y wget && \
  mkdir -p /app
WORKDIR /app
RUN npm install -g phantomjs
COPY . /app
CMD ./start.sh
