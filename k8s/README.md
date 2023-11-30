# Kubernetes-In-Docker

[Kubernetes-In-Docker](https://kind.sigs.k8s.io/) is an image that allows running Kubernetes cluster in a docker container

The main differences of this image from [the official kind image](https://hub.docker.com/r/kindest/node) are:

- `kubectl` can be executed from the docker container,
- SSH server.

This image might come in handy in complex docker compose environments where `kubectl` commands are needed. Connect to the `k8s` container through SSH and and execute `kubectl` commands.

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
curl -LO https://raw.githubusercontent.com/neshkeev/containers/master/k8s/example/single-node/docker-compose.yml
```
4. Start the docker compose services:
```bash
docker compose up -d
```
5. Wait until the k8s cluster starts:
```bash
docker compose logs k8s -f
```
6. Run the `hello-world` pod from the `k8s` container:
```bash
docker compose exec -it k8s kubectl run hello-world --image=hello-world --image-pull-policy=Always
```
7. Check if the pod is available:
```bash
docker compose exec -it k8s kubectl get pods
```
8. Check the state of the pod:
```bash
docker compose exec -it k8s kubectl describe pod/hello-world
```
9. Check the logs of the pod:
```bash
docker compose exec -it k8s kubectl logs pod/hello-world
```
10. Remove the pod:
```bash
docker compose exec -it k8s kubectl delete pod/hello-world
```
11. Check if the pod has gone:
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

### Stop docker compose services

1. Check if the pod's gone
```bash
docker compose exec -it k8s kind delete cluster
```
2. Stop the docker compose services
```bash
docker compose down
```

## Multi-node k8s cluster

In order to start a multi-cluster k8s setup execute the following commands:

0. (Optional) If you are on Windows:
```bash
export MSYS_NO_PATHCONV=1
```
1. Create a directory:
```bash
mkdir -p example/conf
```
2. Enter the created directory:
```bash
cd example
```
3. Download `docker-compose.yml`:
```bash
curl -LO https://raw.githubusercontent.com/neshkeev/containers/master/k8s/example/multi-node/docker-compose.yml
```
4. Download the `config.yml` kind (Kubernetes-In-Docker) config file:
```bash
curl -Lo conf/config.yml https://raw.githubusercontent.com/neshkeev/containers/master/k8s/example/multi-node/conf/config.yml
```
5. Start the docker compose services:
```bash
docker compose up -d
```
6. Wait until the k8s cluster starts:
```bash
docker compose logs k8s -f
```
7. Check if the k8s cluster consists of three nodes:
```bash
docker compose exec -it k8s kubectl get nodes
```

### Stop docker compose services

1. Check if the pod's gone
```bash
docker compose exec -it k8s kind delete cluster
```
2. Stop the docker compose services
```bash
docker compose down
```

## Further configuration

### K8s configuration

This docker images spins [`kind`](https://kind.sigs.k8s.io/), so all the `kind`'s [configuration](https://kind.sigs.k8s.io/docs/user/configuration/) can be applied.

Please keep in mind that you need to:

1. [Mount](https://github.com/neshkeev/containers/blob/721dceea67dd19238515078145c5092a594b5ad2/k8s/example/multi-node/docker-compose.yml#L33) your [`config.yaml`](https://github.com/neshkeev/containers/blob/721dceea67dd19238515078145c5092a594b5ad2/k8s/example/multi-node/conf/config.yml) file into the `k8s` container,
2. (Optionally) [point](https://github.com/neshkeev/containers/blob/721dceea67dd19238515078145c5092a594b5ad2/k8s/example/multi-node/docker-compose.yml#L36) the `K8S_CONFIG_FILE` environment variable to the mounted file on the container's file system.

Setting the `K8S_CONFIG_FILE` environment variable can be omitted, if you mount the config file at the `/etc/kubernetes/config.yml` mount point.

## Known Issues

### SSH server crushes

**Issue**: a `k8s` container's SSH server crushes on restart

**Solution**: remove the container and start it again

### kubectl fails with `... no such host`

**Issue**: When I execute `kubectl get nodes` or another commands I get:
```bash
$ kubectl get nodes

E1129 19:26:09.617992     758 memcache.go:265] couldn't get current server API group list: Get "https://kind-control-plane:6443/api?timeout=32s": dial tcp: lookup kind-control-plane on 127.0.0.11:53: no such host
```

**Solution**: Please make sure the network of the k8s container is named [`kind`](https://github.com/neshkeev/containers/blob/721dceea67dd19238515078145c5092a594b5ad2/k8s/example/single-node/docker-compose.yml#L5)
