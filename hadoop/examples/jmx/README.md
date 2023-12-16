# Connect to Hadoop services over JMX

A JMX connection can be established to the hadoop services.

## Quick Start

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
