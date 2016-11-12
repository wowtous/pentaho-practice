#! /bin/bash
# PROJECT_HOME will be setting to the location of biserver-ce.
# PROJECT_HOME=/opt/pentaho
#
# You can run the initConfig.sh like this:
# cd .
# ./initConfig.sh /opt localhost 127.0.0.1
PROJECT_HOME=${PROJECT_HOME:-$1}
PENTAHO_HOME=${PENTAHO_HOME:-$1/biserver-ce}
OLDHOST=${OLDHOST:-'localhost'}
MYSQL_HOST=${MYSQL_HOST:-$2}
MYSQL_PORT=${MYSQL_PORT:-$3}
S_Xms=${S_Xms:-'1024m'}
S_Xmx=${S_Xmx:-'3072m'}
S_MaxPermSize=${S_MaxPermSize:-'128m'}
sysOS=`uname -s`
sedi='sed -i'

echo "PROJECT_HOME: $PROJECT_HOME"
echo "MYSQL_HOST: $MYSQL_HOST"
echo "MYSQL_PORT: $MYSQL_PORT"

if [ -f transfer_data_to_mysql_config.tar.gz ];then
	tar zxf transfer_data_to_mysql_config.tar.gz -C $PROJECT_HOME
fi

if [ $sysOS == "Darwin" ];then
	sedi="sed -i ''"
	echo "I'm MacOS $sedi"
else
	echo "I'm Linux $sedi"
fi

$sedi "s/localhost:3306/$MYSQL_HOST:$MYSQL_PORT/g" $PENTAHO_HOME/pentaho-solutions/system/hibernate/mysql5.hibernate.cfg.xml \
$PENTAHO_HOME/pentaho-solutions/system/jackrabbit/repository.xml \
$PENTAHO_HOME/pentaho-solutions/system/simple-jndi/jdbc.properties \
$PENTAHO_HOME/pentaho-solutions/system/applicationContext-spring-security-hibernate.properties \
$PENTAHO_HOME/pentaho-solutions/system/applicationContext-spring-security-jdbc.properties \
$PENTAHO_HOME/tomcat/webapps/pentaho/META-INF/context.xml

$sedi "s/$OLDHOST/%/g" $PENTAHO_HOME/data/mysql5/create_jcr_mysql.sql \
$PENTAHO_HOME/data/mysql5/create_quartz_mysql.sql \
$PENTAHO_HOME/data/mysql5/create_repository_mysql.sql

if [ `grep Xmx2048m $PENTAHO_HOME/import-export.sh | awk '{print $2}'` ];then
	$sedi "s/-Xmx2048m -XX:MaxPermSize=256m/-Xmx$S_Xms -XX:MaxPermSize=$S_MaxPermSize/g" $PENTAHO_HOME/import-export.sh
else
	echo "Import Script Already Modify"
fi

if [ `grep Xms2048m $PENTAHO_HOME/start-pentaho.sh | awk '{print $2}'` ];then
	$sedi "s/-Xms2048m -Xmx6144m -XX:MaxPermSize=256m/-Xms$S_Xms -Xmx$S_Xmx -XX:MaxPermSize=$S_MaxPermSize/g" $PENTAHO_HOME/start-pentaho.sh
	$sedi "s/-Xms2048m -Xmx6144m  -XX:MaxPermSize=256m/-Xms$S_Xms -Xmx$S_Xmx  -XX:MaxPermSize=$S_MaxPermSize/g" $PENTAHO_HOME/start-pentaho-debug.sh
else
	echo "Start Script Already Modify"
fi
