# Single Node Cluster Hadoop packaged by neshkeev

DISCLAMER:

> This software is packaged by neshkeev. The respective trademarks mentioned in the offering
are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## Overview of [Apache Hadoop](https://hadoop.apache.org/)

The Apache Hadoop software library is a framework that allows for the distributed processing of large data sets across clusters of computers using simple programming models.

## Goal

The packaging is ideal for demo, testing or teaching purposes, because it contains full-blown Hadoop Distribution inside a single docker image.
Client applications can perform basic operations using Hadoop MapReduce and the Hadoop Distributed File System (HDFS).

## TLDR

There is a functional [docker-compose.yml](examples/simple/docker-compose.yml) file in the repository. Run the application using it as shown below:

```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/examples/simple/docker-compose.yml > docker-compose.yml
docker-compose up
```

## Example

### Run a Map Reduce task

After having the container started (see TLDR) run the `grep` example that comes with the Hadoop distribution by default:

1. Login as `hdfs` into the container: `docker compose exec -it hadoop hsh hdfs`
1. Create the HDFS directory required to execute MapReduce jobs: `hdfs dfs -mkdir -p /user/hdfs`
1. Create the input directory: `hdfs dfs -mkdir - input`
1. Copy the input files into HDFS: `hdfs dfs -put /opt/hadoop/etc/hadoop/*.xml -f input`
1. Start the Map Reduce job: `hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.4.jar grep input output 'dfs[a-z.]+'`
1. Browse the web interface to analyze the workload:
    - NameNode: [`http://localhost:9870`](http://localhost:9870)
    - ResourceManager: [`http://localhost:8088`](http://localhost:8088)
1. Review the results: `hdfs dfs -cat output/*`
1. Copy the results to the local file system: `hdfs dfs -get output /home/hdfs/output`
1. Remove the results: `hdfs dfs -rm -r output`

## Configuration

### Location

The hadoop's files reside in the `/opt/hadoop` directory.

### Users

The images is configured to contains the following users:

- `root` - the root user
- `hdfs` - for operations with `HDFS`
- `yarn` - for operations with `Yarn`

### Login

By default when you `exec` into the container with `bash` you are `root`.
All operations with both `HDFS` and `Yarn` are expected be performed under a non-root user.
In order to login as a non-root user there is the `hsh` utility script available on `PATH`,
which accepts one argument that should be either `hdfs` or `yarn`.
By default when no arguments is passed `hdfs` is used.

### Site-specific cofiguration

The following site-specific configuration files allow configuring Apache Hadoop:

- /opt/hadoop/etc/hadoop/core-site.xml
- /opt/hadoop/etc/hadoop/hdfs-site.xml
- /opt/hadoop/etc/hadoop/yarn-site.xml
- /opt/hadoop/etc/hadoop/mapred-site.xml

The user is expected to mount their own files in these places in order to achieve the desired state.

## Kubernetes

The image hasn't been tested to be run inside a k8s environment yet, so it's up to the user to configure neede resources and pass the correct configs
