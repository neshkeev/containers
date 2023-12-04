# Docker-In-Docker

[Docker-In-Docker](https://hub.docker.com/_/docker) is an image that allows executing docker commands from inside a docker container.

The main differences from [the official one](https://hub.docker.com/_/docker) are:

- docker compose is built in,
- SSH server

This image might come in handy in complex docker compose environments where a dedicated docker container needs to manage the other containers. The container can connect to the dind container through SSH and and execute docker commands.

The [Dockerfile](https://github.com/neshkeev/containers/blob/master/dind/Dockerfile) can be found on [GitHub](https://github.com/neshkeev/containers/tree/master/dind)

## Quick Start

1. Create a directory:
```bash
mkdir example
```
2. Enter the created directory:
```bash
cd example
```
3. Download `docker-compose.yml`:
```bash
curl -LO https://raw.githubusercontent.com/neshkeev/containers/master/dind/example/reuse-host-docker/docker-compose.yml
```
4. Start the docker compose services:
```bash
docker compose up -d
```
5. Run the `hello-world` services from the `dind` container:
```bash
docker compose exec -it dind docker run hello-world
```
6. Check the status of the current docker compose setup from inside the `dind` container:
```bash
docker compose exec -it dind docker compose ps
```
7. Check the status of the current docker compose setup via SSH:
```bash
docker compose exec -it dind ssh root@localhost 'docker compose ps'
```
