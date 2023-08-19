## Домашнее задание 68 [3.3 Как работает сеть в K8s](https://github.com/netology-code/kuber-homeworks/blob/main/3.3/3.3.md)

### Олег Дьяченко DEVOPS-22

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.

```yaml
#namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: mtool
```

```yaml
#frontend.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: frontend
  name: frontend
  namespace: mtool
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - image: praqma/network-multitool:alpine-extra
          imagePullPolicy: IfNotPresent
          name: network-multitool
      terminationGracePeriodSeconds: 30

---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: mtool
spec:
  ports:
    - name: web
      port: 80
  selector:
    app: frontend
```

```yaml
#backend.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: backend
  name: backend
  namespace: mtool
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - image: praqma/network-multitool:alpine-extra
          imagePullPolicy: IfNotPresent
          name: network-multitool
      terminationGracePeriodSeconds: 30

---
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: mtool
spec:
  ports:
    - name: web
      port: 80
  selector:
    app: backend
```

```yaml
#cache.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: cache
  name: cache
  namespace: mtool
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cache
  template:
    metadata:
      labels:
        app: cache
    spec:
      containers:
        - image: praqma/network-multitool:alpine-extra
          imagePullPolicy: IfNotPresent
          name: network-multitool
      terminationGracePeriodSeconds: 30

---
apiVersion: v1
kind: Service
metadata:
  name: cache
  namespace: mtool
spec:
  ports:
    - name: web
      port: 80
  selector:
    app: cache
```

```
root@dgt-kuber-001:~/HW68# kubectl apply -f namespace.yaml
namespace/mtool created
root@dgt-kuber-001:~/HW68# kubectl apply -f kubectl apply -f frontend.yaml
deployment.apps/frontend created
service/frontend created
root@dgt-kuber-001:~/HW68# kubectl apply -f backend.yaml
deployment.apps/backend created
service/backend created
root@dgt-kuber-001:~/HW68# kubectl apply -f cache.yaml
deployment.apps/cache created
service/cache created
root@dgt-kuber-001:~/HW68# kubectl config set-context --current --namespace=mtool
Context "kubernetes-admin@cluster.local" modified.
```

```
root@dgt-kuber-001:~/HW68# kubectl get all -o wide
NAME                           READY   STATUS    RESTARTS   AGE     IP              NODE    NOMINATED NODE   READINESS GATES
pod/backend-5c496f8f74-4qz2t   1/1     Running   0          9m17s   10.233.75.1     node2   <none>           <none>
pod/cache-5cd6c7468-s4m5n      1/1     Running   0          9m9s    10.233.97.130   node5   <none>           <none>
pod/frontend-7ddf66cbb-7vrvz   1/1     Running   0          9m24s   10.233.74.65    node4   <none>           <none>

NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE     SELECTOR
service/backend    ClusterIP   10.233.35.227   <none>        80/TCP    9m17s   app=backend
service/cache      ClusterIP   10.233.18.186   <none>        80/TCP    9m9s    app=cache
service/frontend   ClusterIP   10.233.38.138   <none>        80/TCP    9m24s   app=frontend

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS          IMAGES                                  SELECTOR
deployment.apps/backend    1/1     1            1           9m17s   network-multitool   praqma/network-multitool:alpine-extra   app=backend
deployment.apps/cache      1/1     1            1           9m9s    network-multitool   praqma/network-multitool:alpine-extra   app=cache
deployment.apps/frontend   1/1     1            1           9m24s   network-multitool   praqma/network-multitool:alpine-extra   app=frontend

NAME                                 DESIRED   CURRENT   READY   AGE     CONTAINERS          IMAGES                                  SELECTOR
replicaset.apps/backend-5c496f8f74   1         1         1       9m17s   network-multitool   praqma/network-multitool:alpine-extra   app=backend,pod-template-hash=5c496f8f74
replicaset.apps/cache-5cd6c7468      1         1         1       9m9s    network-multitool   praqma/network-multitool:alpine-extra   app=cache,pod-template-hash=5cd6c7468
replicaset.apps/frontend-7ddf66cbb   1         1         1       9m24s   network-multitool   praqma/network-multitool:alpine-extra   app=frontend,pod-template-hash=7ddf66cbb
```

4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.

```yaml
#policies.yaml
# политика запрета всех соединений
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: mtool
spec:
  podSelector: {}
  policyTypes:
    - Ingress

---
# политика разрешает доступ фронта к бэку
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend-to-backend-policy
  namespace: mtool
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
      - podSelector:
          matchLabels:
            app: frontend
      ports:
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443

---
# политика разрешает доступ бэка к кэшу
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-to-cache-policy
  namespace: mtool
spec:
  podSelector:
    matchLabels:
      app: cache
  policyTypes:
    - Ingress
  ingress:
    - from:
      - podSelector:
          matchLabels:
            app: backend
      ports:
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443
```

```
root@dgt-kuber-001:/home/kuber/HW68# kubectl apply -f policies.yaml
networkpolicy.networking.k8s.io/default-deny-ingress created
networkpolicy.networking.k8s.io/frontend-to-backend-policy created
networkpolicy.networking.k8s.io/backend-to-cache-policy created
```

5. Продемонстрировать, что трафик разрешён и запрещён.

Трафик frontend -> backend -> cache, отвечает.

```
root@dgt-kuber-001:/home/kuber/HW68# kubectl exec frontend-7ddf66cbb-7vrvz -- curl backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  Praqma Network MultiTool (with NGINX) - backend-5c496f8f74-4qz2t - 10.233.75.1
100    79  100    79    0     0  15050      0 --:--:-- --:--:-- --:--:-- 15800

root@dgt-kuber-001:/home/kuber/HW68# kubectl exec backend-5c496f8f74-4qz2t -- curl cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  Praqma Network MultiTool (with NGINX) - cache-5cd6c7468-s4m5n - 10.233.97.130
100    78  100    78    0     0  10739      0 --:--:-- --:--:-- --:--:-- 11142
```

По остальным маршрутам трафик не ходит.
```
root@dgt-kuber-001:/home/kuber/HW68# kubectl exec cache-5cd6c7468-s4m5n -- curl backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:12 --:--:--     0^C
root@dgt-kuber-001:/home/kuber/HW68# kubectl exec cache-5cd6c7468-s4m5n -- curl frontend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0^C
root@dgt-kuber-001:/home/kuber/HW68# kubectl exec backend-5c496f8f74-4qz2t -- curl frontend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:08 --:--:--     0^C
root@dgt-kuber-001:/home/kuber/HW68# kubectl exec frontend-7ddf66cbb-7vrvz -- curl cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0^C
```