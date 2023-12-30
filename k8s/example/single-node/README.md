# Single Node K8s Cluster

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
