# Reuse Docker from the host

You can manage your host's Docker services, which makes it possible to control the `dind` docker service from itself.

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
