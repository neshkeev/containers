# Multi Node Cluster

This example demonstrates how to deploy a Hadoop cluster with Docker Compose that contains:

- NameNode,
- DataNode,
- ResourceManager,
- NodeManager,
- ProxyServer,
- HistoryServer.

## HDFS demo

0. Start a Hadoop cluster:
```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/examples/multi-node-cluster/docker-compose.yml > docker-compose.yml
docker compose up -d
```
1. Wait until all the services are healthy:
```bash
docker compose ps
```
2. Enter the namenode docker container:
```bash
docker compose exec -it namenode bash
```
3. Execute the following commands:
```bash
hdfs dfs -mkdir -p /user/hadoop
echo 'Hello, World!' > /tmp/hello.txt
hdfs dfs -put /tmp/hello.txt /user/hadoop
hdfs dfs -cat /user/hadoop/hello.txt
```
4. Check the `hello.txt` file on HDFS from your WebBrowser: [http://localhost:9870/explorer.html#/user/hadoop](http://localhost:9870/explorer.html#/user/hadoop)
5. Stop the Hadoop cluster:
```bash
docker compose down
```

## YARN demo

0. Start a Hadoop cluster:
```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/examples/multi-node-cluster/docker-compose.yml > docker-compose.yml
docker compose up -d
```
1. Wait until all the services are healthy:
```bash
docker compose ps
```
2. Enter the resourcemanager docker container:
```bash
docker compose exec -it resourcemanager bash
```
3. Execute the following commands:
```bash
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 10 15
```
4. Explore the application from your WebBrowser: [http://localhost:8088](http://localhost:8088)
5. Stop the Hadoop cluster:
```bash
docker compose down
```

## Web Links

After the cluster is up and running feel free to explore it:

- NameNode: [http://localhost:9870](http://localhost:9870)
- DataNode:
    1. [http://localhost:19864](http://localhost:19864)
    1. [http://localhost:29864](http://localhost:29864)
    1. [http://localhost:39864](http://localhost:39864)
- ResourceManager: [http://localhost:8088](http://localhost:8088)
- NodeManager:
    1. [http://localhost:18042](http://localhost:18042)
    1. [http://localhost:28042](http://localhost:28042)
    1. [http://localhost:38042](http://localhost:38042)
- HistoryServer: [http://localhost:19888](http://localhost:19888/jobhistory)
