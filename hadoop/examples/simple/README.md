# Simple Single Node Hadoop Cluster

## Start Hadoop

The example starts a Single Node Cluster Hadoop:

```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/examples/simple/docker-compose.yml > docker-compose.yml
docker compose up -d
```

## Work with HDFS

```bash
docker compose exec -it hadoop bash
hdfs dfs -mkdir -p /user/hadoop
echo 'Hello, World!' > /tmp/hello.txt
hdfs dfs -put /tmp/hello.txt /user/hadoop
hdfs dfs -cat /user/hadoop/hello.txt
```
Use Namenode UI to browse the HDFS filesystem: [http://localhost:9870/explorer.html](http://localhost:9870/explorer.html)

## Work with YARN

```bash
docker compose exec -it hadoop bash
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 10 15
```

Use Resource Manager UI to explore the applications: [http://localhost:8088](http://localhost:8088)
