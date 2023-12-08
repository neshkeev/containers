# Multi Node Cluster

This example demonstrates how to deploy a three-node cluster with Docker Compose.

## HDFS demo

1. Enter the namenode docker container:
```bash
docker compose exec -it namenode`
```
2. Execute the following commands:
```bash
hdfs dfs -mkdir -p /user/hadoop
echo 'Hello, World!' > /tmp/hello.txt
hdfs dfs -put /tmp/hello.txt /user/hadoop
hdfs dfs -cat /user/hadoop/hello.txt
```
3. Explore the `hello.txt` file on HDFS from your WebBrowser: [http://localhost:9870/explorer.html#/user/hadoop](http://localhost:9870/explorer.html#/user/hadoop)

## YARN demo

1. Enter the namenode docker container:
```bash
docker compose exec -it namenode`
```
2. Execute the following commands:
```bash
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 10 15
```
3. Explore the application from your WebBrowser: [http://localhost:8088](http://localhost:8088)

## Web Links

After the cluster is up and running feel free to explore it:

- Namenode: [http://localhost:9870](http://localhost:9870)
- DataNode:
    1. [http://localhost:19864](http://localhost:19864)
    1. [http://localhost:29864](http://localhost:29864)
    1. [http://localhost:39864](http://localhost:39864)
- ResourceManager: [http://localhost:8088](http://localhost:8088)
- NodeManager:
    1. [http://localhost:18042](http://localhost:18042)
    1. [http://localhost:28042](http://localhost:28042)
    1. [http://localhost:38042](http://localhost:38042)
