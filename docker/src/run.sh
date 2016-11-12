#! /bin/bash

S_Xms=${S_Xms:-'1024m'}
S_Xmx=${S_Xmx:-'3072m'}
S_MaxPermSize=${S_MaxPermSize:-'128m'}
PROJECT_HOME=${PROJECT_HOME:-/opt}
PENTAHO_HOME=${PENTAHO_HOME:-/opt/biserver-ce}
MYSQL_HOST=${MYSQL_HOST:-127.0.0.1}
MYSQL_PORT=${MYSQL_PORT:-3306}
MYSQL_USERNAME=${MYSQL_USERNAME:-root}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}
mysql_login="mysql -h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USERNAME -p$MYSQL_PASSWORD"

echo "start pentaho server ..."

/initConfig.sh $PROJECT_HOME $MYSQL_HOST $MYSQL_PORT

# wait for mysql server starting
COUNTER=1
mysql_exists=1
while [ $COUNTER -lt 20 -a $mysql_exists -eq 1 ]; do
    echo MySQL server start with: $COUNTER
    let COUNTER=COUNTER+1
	$mysql_login --connect_timeout=5 -e "show databases;" &>/dev/null 2>&1
	mysql_exists=$?
	sleep 5
done

## wait for a moment
# for i in {1..10};do
#     sleep 1
#     echo -en "\rwaiting for mysql starting(${i}s) ......"
# done
# echo -e "\n"

if [ -f $PENTAHO_HOME/data/mysql5/.first_start ]; then
	echo "mysql database have already init."
else
	echo "init mysql config database starting."
	$mysql_login < "$PENTAHO_HOME/data/mysql5/create_jcr_mysql.sql"
	$mysql_login < "$PENTAHO_HOME/data/mysql5/create_quartz_mysql.sql"
	$mysql_login < "$PENTAHO_HOME/data/mysql5/create_repository_mysql.sql"
	echo "init mysql config database end."
	touch $PENTAHO_HOME/data/mysql5/.first_start
fi

if [ ! -n "$1" ];then
	echo "start pentaho service..."
	$PENTAHO_HOME/start-pentaho.sh && tail -f $PENTAHO_HOME/tomcat/logs/catalina.out
fi
