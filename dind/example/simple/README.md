# Start a Docker service from a docker container

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
curl -LO https://raw.githubusercontent.com/neshkeev/containers/master/dind/example/simple/docker-compose.yml
```
4. Start the docker compose services:
```bash
docker compose up -d
```
5. Run the `hello-world` services from the `dind` container:
```bash
docker compose exec -it dind docker run hello-world
```
6. Use Docker Compose:
```bash
docker compose exec -it dind docker compose version
```
7. Use Docker Compose from SSH:
```bash
docker compose exec -it dind ssh root@localhost 'docker compose version'
```
