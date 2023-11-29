# Kubernetes-In-Docker

[Kubernetes-In-Docker](https://hub.docker.com/r/kindest/node) is an image that allows running Kubernetes cluster in a docker container

The main differences of this image from [the official one](https://hub.docker.com/r/kindest/node) are:

- `kubectl` can be executed from the docker container,
- SSH server

This image might come in handy in complex docker compose environments where kubectl commands are needed. The container can connect to the `k8s` container through SSH and and execute `kubectl` commands.

The [Dockerfile](https://github.com/neshkeev/containers/blob/master/k8s/Dockerfile) can be found on [GitHub](https://github.com/neshkeev/containers/blob/master/k8s)

## Quick Start

0. (Optional) If you are on Windows:
```bash
export MSYS_NO_PATHCONV=1
```
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
curl -LO https://raw.githubusercontent.com/neshkeev/containers/master/k8s/example/docker-compose.yml
```
4. Start the docker compose services:
```bash
docker compose up -d
```
5. Run the `hello-world` pod from the `k8s` container:
```bash
docker compose exec -it k8s kubectl run hello-world --image=hello-world --image-pull-policy=Always
```
6. Check if the pod is available:
```bash
docker compose exec -it k8s kubectl get pods
```
7. Check the state of the pod:
```bash
docker compose exec -it k8s kubectl describe pod/hello-world
```
8. Check the logs of the pod:
```bash
docker compose exec -it k8s kubectl logs pod/hello-world
```
9. Remove the pod:
```bash
docker compose exec -it k8s kubectl delete pod/hello-world
```
6. Check if the pod has gone:
```bash
docker compose exec -it k8s kubectl get pods
```

### Execute kubectl commands through SSH

1. Run the `hello-world` pod from the `k8s` container:
```bash
docker compose exec -it k8s ssh root@localhost 'kubectl run hello-world --image=hello-world --image-pull-policy=Always'
```
2. Check if the pod is available:
```bash
docker compose exec -it k8s ssh root@localhost 'kubectl get pods'
```
3. Check the state of the pod:
```bash
docker compose exec -it k8s ssh root@localhost 'kubectl describe pod/hello-world'
```
4. Check the logs of the pod:
```bash
docker compose exec -it k8s ssh root@localhost 'kubectl logs pod/hello-world'
```
5. Remove the pod:
```bash
docker compose exec -it k8s ssh root@localhost 'kubectl delete pod/hello-world'
```
6. Check if the pod's gone
```bash
docker compose exec -it k8s ssh root@localhost 'kubectl get pods'
```

## Known Issues

### A k8s container's SSH server crushes on restart

**Solution**: remove the container and start it again

### kubectl fails with `... no such host`

**Issue**: When I execute `kubectl get nodes` or another commands I get:
```bash
$ kubectl get nodes

E1129 19:26:09.617992     758 memcache.go:265] couldn't get current server API group list: Get "https://kind-control-plane:6443/api?timeout=32s": dial tcp: lookup kind-control-plane on 127.0.0.11:53: no such host
```

**Solution**: Please make sure the network of the k8s container is named [`kind`](https://github.com/neshkeev/containers/blob/50e3bfaf616c5ef18e8e546aa4459f88d30e016d/k8s/example/docker-compose.yml#L5)
