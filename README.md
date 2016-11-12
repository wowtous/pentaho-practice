## Downloads
[biserver-ce-6.1.0.1-196.zip](http://nchc.dl.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/6.1/biserver-ce-6.1.0.1-196.zip)

## publish steps

```sh
# unzip package
unzip biserver-ce-6.1.0.1-196.zip -d <biserver-ce-home>

# decompress the config file
cd bin && initConfig.sh <biserver-ce-home> localhost <Your MySQL Host> && cd ..

# load data
mysql -p < <biserver-ce-home>/biserver-ce/data/mysql5/create_jcr_mysql.sql
mysql -p < <biserver-ce-home>/biserver-ce/data/mysql5/create_quartz_mysql.sql
mysql -p < <biserver-ce-home>/biserver-ce/data/mysql5/create_repository_mysql.sql
```

## start pentaho
```
cd <biserver-ce-home>/biserver-ce
./start-pentaho.sh && tail -f tomcat/logs/catalina.out
ps -elf|grep tomcat
pkill tomcat
kill -9 $(ps -elf|grep -m1 tomcat|awk '{print $4}')
```
