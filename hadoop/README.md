# Single Node Cluster Hadoop packaged by neshkeev

**DISCLAMER**:

> This software is packaged by neshkeev. The respective trademarks mentioned in the offering
are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TLDR

There is a functional [docker-compose.yml](examples/simple/docker-compose.yml) file in the repository. Run the application using it as shown below:

```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/examples/simple/docker-compose.yml > docker-compose.yml
docker compose up
```

## Overview of [Apache Hadoop](https://hadoop.apache.org/)

The Apache Hadoop software library is a framework that allows for the distributed processing of large data sets across clusters of computers using simple programming models.

## Architectures

The docker image can be used to run a Hadoop Cluster on the following architectures:

- [`amd64`](examples/simple/docker-compose.yml),
- [`aarch64/arm64`](examples/arm64/docker-compose.yml).

## Goal

The packaging is ideal for demo, testing or teaching purposes, because it contains full-blown Hadoop Distribution inside a single docker image.
Client applications can perform basic operations using Hadoop MapReduce and the Hadoop Distributed File System (HDFS).

## Configuration

In order to cofigure a Hadoop cluster there are two options that can be used in combination.

### Mount config files

One can mount prepared cofig files:

- `core-site.xml` -> `/opt/hadoop/etc/hadoop/core-site.xml`
- `hdfs-site.xml` -> `/opt/hadoop/etc/hadoop/hdfs-site.xml`,
- `yarn-site.xml` -> `/opt/hadoop/etc/hadoop/yarn-site.xml`,
- `mapred-site.xml` -> `/opt/hadoop/etc/hadoop/mapred-site.xml`,
- and so on

### Environment Variables

Existing config files can be amended with environment variables.

In order to amend a config properties one needs to construct a variable name to match the following pattern: `PREFIX` + config.name.

For example, the value for `fs.defaultFS` should be stored in the `CORE-SITE.XML_fs.defaultFS` like this: `CORE-SITE.XML_fs.defaultFS=hdfs://namenode:9000`

The prefix is derived from the file the config belongs to. See the examples' [docker-compose.yml](examples/simple/docker-compose.yml#L26) files for references.

### Precedence

The values from environment variables takes precedence over the mounted config files.

## Examples

### Compute Pi on a single node cluster

1. Download [`docker-compose.yml`](https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/examples/simple/docker-compose.yml):
```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/examples/multi-node-cluster/docker-compose.yml > docker-compose.yml
```
2. Start the docker compose services:
```bash
docker compose up
```
3. Enter the `hadoop` docker compose service:
```bash
docker compose exec -it hadoop bash
```
4. Run the Pi computation task:
```bash
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 10 15
```
5. Explore the workload on the web interface:
    - NameNode: [`http://localhost:9870/explorer.html`](http://localhost:9870/explorer.html)
    - ResourceManager: [`http://localhost:8088`](http://localhost:8088)

### Run a Map Reduce task on a single node cluster

Run the `grep` example that comes with the Hadoop distribution by default:

1. Download [`docker-compose.yml`](https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/examples/simple/docker-compose.yml):
```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/examples/multi-node-cluster/docker-compose.yml > docker-compose.yml
```
2. Start the docker compose services:
```bash
docker compose up
```
3. Enter the `hadoop` docker compose service:
```bash
docker compose exec -it hadoop bash
```
4. Create a directory for the user that is required to execute MapReduce jobs:
```bash
hdfs dfs -mkdir -p /user/hadoop
```
5. Create the input directory:
```bash
hdfs dfs -mkdir -p input
```
6. Copy the input files into HDFS:
```bash
hdfs dfs -put -f /opt/hadoop/etc/hadoop/*.xml input
```
7. Start the Map Reduce job:
```
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar grep input output 'dfs[a-z.]+'
```
8. Explore the workload on the web interface:
    - NameNode: [`http://localhost:9870/explorer.html`](http://localhost:9870/explorer.html)
    - ResourceManager: [`http://localhost:8088`](http://localhost:8088)
9. Review the results:
```bash
hdfs dfs -cat output/*
```
10. Copy the results to the local file system:
```bash
hdfs dfs -get output ~/output
```
11. Analyze the results:
```bash
find ~/output
```
12. Remove the results:
```
hdfs dfs -rm -r output
```

### Connect to Hadoop Services Over JMX

1. Start a Hadoop Cluster
```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/example/jmx/docker-compose.yml > docker-compose.yml
docker compose up -d
```
2. Open jconsole (or visualvm):
```bash
jconsole
```
3. Create a remote JMX Connection:
    - NameNode: `localhost:59870`
    - DataNode: `localhost:59864`
    - ResourceManager: `localhost:58088`
    - NodeManager: `localhost:58042`
    - HistoryServer: `localhost:59888`
