#! /bin/bash
set -e

# docker run --name db -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password -d mysql:latest
# docker run --name pentaho -p 30000:8080 --link db -idt daocloud.io/darebeat/ubuntu-java

if [ ! -f "./src/biserver-ce-6.1.0.1-196.zip" ];then
    cd src
    wget https://sourceforge.net/projects/pentaho/files/Business%20Intelligence%20Server/6.0/biserver-ce-6.0.1.0-386.zip
    cd ..
fi

imi=$(docker images | grep daocloud.io/darebeat/ubuntu-pentaho | awk '{print $3}')
if [ $imi ]; then
    docker rmi -f $imi
fi

docker build -t daocloud.io/darebeat/ubuntu-pentaho .

echo "... ok"
