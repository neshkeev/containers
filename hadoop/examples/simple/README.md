# Simple Single Node Hadoop Cluster

## Start Hadoop

The example starts a Single Node Cluster Hadoop:

```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/example/simple/docker-compose.yml > docker-compose.yml
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/example/simple/config > config
docker compose up -d
```

## Work with HDFS

```bash
docker compose exec -it hadoop hsh
hdfs dfs -mkdir -p /user/hdfs
echo 'Hello, World!' > /tmp/hello.txt
hdfs dfs -put /tmp/hello.txt /user/hdfs
hdfs dfs -cat /user/hdfs/hello.txt
```
Use Namenode UI to browse the filesystem: http://localhost:9870/explorer.html#/user/hdfs

## Work with YARN

```bash
docker compose exec -it hadoop hsh yarn
cd /opt/hadoop
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 10 15
```

User Resource Manager UI to explore applications: http://localhost:8088
