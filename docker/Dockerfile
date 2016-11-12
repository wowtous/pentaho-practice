FROM daocloud.io/darebeat/ubuntu-java
MAINTAINER Darebeat <fengwei2010@126.com>

add ./src /
RUN echo -e "\nexport TERM=xterm" >> ~/.bashrc
RUN apt-get update && apt-get install unzip -y \
    && unzip *.zip -d /opt \
    && tar zxf /transfer_data_to_mysql_config.tar.gz -C /opt \
    && rm -rf /*.zip \
    && apt-get autoremove -y && apt-get autoclean

# start config
ENV S_Xms 512m
ENV S_Xmx 1536m
ENV S_MaxPermSize 128m

# project directory config
ENV PROJECT_HOME /opt
ENV PENTAHO_HOME /opt/biserver-ce

# mysql config
ENV MYSQL_HOST 127.0.0.1
ENV MYSQL_PORT 3306
ENV MYSQL_USERNAME root
ENV MYSQL_PASSWORD password

CMD ["/run.sh"]
