## Pentaho Docker

1. build docker image

```sh
./build.sh
```

2. start pentaho

```sh
docker-compose up -d
```

3. parameter description

```
MYSQL_HOST => mysql database connection host
MYSQL_PORT => mysql database connection port
MYSQL_USERNAME => mysql database connection username
MYSQL_PASSWORD => mysql database connection password

S_Xms => the memory size app starting => JVM最小的内存启动
S_Xmx => the max memory size when app is running => JVM最大可得到的内存大小
S_MaxPermSize => the max permanate generation size => JVM运行时分配的最大永久性内存大小,不会被垃圾回收的内存
```
