# Simple Hadoop

The example starts a single Node Cluster Hadoop:

```bash
curl -sSL https://raw.githubusercontent.com/neshkeev/containers/master/hadoop/example/simple/docker-compose.yml > docker-compose.yml
docker-compose up -d
docker-compose exec -it hadoop hsh
hdfs dfs -mkdir -p /user/hdfs
```
