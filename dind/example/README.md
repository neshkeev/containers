# Quick Start

0. (Optional) If you are on Windows:
```bash
export MSYS_NO_PATHCONV=1
```
1. Download `docker-compose.yml`:
```bash
curl -LO
```
2. Start the docker compose services:
```bash
docker compose up -d
```
3. Run the `hello-world` services from the `dind` container:
```bash
docker compose exec -it dind docker run hello-world
```
4. Check the status of the current docker compose setup from inside the `dind` container:
```bash
docker compose exec -it dind docker compose -f /root/example/docker-compose.yml ps
```
5. Check the status of the current docker compose setup via SSH:
```bash
docker compose exec -it dind ssh root@localhost 'docker compose -f /root/example/docker-compose.yml ps'
```
