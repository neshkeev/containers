# Multi-Node Kubernetes-In-Docker Cluster

In order to start a multi-cluster k8s setup execute the following commands:

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
8. Run the `hello-world` pod from the `k8s` container:
```bash
docker compose exec -it k8s kubectl run hello-world --image=hello-world --image-pull-policy=Always
```
9. Check if the pod is available:
```bash
docker compose exec -it k8s kubectl get pods
```
10. Check the state of the pod:
```bash
docker compose exec -it k8s kubectl describe pod/hello-world
```
11. Check the logs of the pod:
```bash
docker compose exec -it k8s kubectl logs pod/hello-world
```
12. Remove the pod:
```bash
docker compose exec -it k8s kubectl delete pod/hello-world
```
13. Check if the pod has gone:
```bash
docker compose exec -it k8s kubectl get pods
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
