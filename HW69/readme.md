## Домашнее задание 69 [3.4 Обновление приложений](https://github.com/netology-code/kuber-homeworks/blob/main/3.4/3.4.md)

### Олег Дьяченко DEVOPS-22

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

### Ответ:

Исходя из пункта 4 нужно заменить и фронт и бэк и одновременно.
Судя по пункту 3 - ресурсов нет от слова совсем, потому что не угадаешь, может запаса и 10% будет, а по пункту 2 их еще и не увеличить.  
Остается один вариант Recreate. При таком обновлении не надо использовать дополнительные ресурсы, так как у нас нет возможности их увеличиить. Старые реплики будут уничтожены и запущены обновленные вместо них. Выбрать время когда минимальный трафик (в основном ночное время), заранее предупредить о технических работах на кластере.

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-depl
  labels:
    app: app-depl
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 3
  selector:
    matchLabels:
      app: app-depl
  template:
    metadata:
      labels:
        app: app-depl
    spec:
      containers:
      - name: nginx
        image: nginx:1.19
        ports:
        - containerPort: 80
      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 8080
        env:
        - name: HTTP_PORT
          value: "8080"
        - name: HTTPS_PORT
          value: "11443"
```

```
root@dgt-kuber-001:/home/kuber/HW69# kubectl get all -o wide
NAME                           READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
pod/app-depl-574f94857-7xfhr   2/2     Running   0          66s   10.233.102.131   node1   <none>           <none>
pod/app-depl-574f94857-87qrz   2/2     Running   0          66s   10.233.74.68     node4   <none>           <none>
pod/app-depl-574f94857-c827x   2/2     Running   0          66s   10.233.75.4      node2   <none>           <none>
pod/app-depl-574f94857-kqgsr   2/2     Running   0          66s   10.233.71.3      node3   <none>           <none>
pod/app-depl-574f94857-vt44t   2/2     Running   0          66s   10.233.97.132    node5   <none>           <none>

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS        IMAGES                               SELECTOR
deployment.apps/app-depl   5/5     5            5           66s   nginx,multitool   nginx:1.19,wbitt/network-multitool   app=app-depl

NAME                                 DESIRED   CURRENT   READY   AGE   CONTAINERS        IMAGES                               SELECTOR
replicaset.apps/app-depl-574f94857   5         5         5       66s   nginx,multitool   nginx:1.19,wbitt/network-multitool   app=app-depl,pod-template-hash=574f94857
```

2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.

Применяю стратегию RollingUpdate. Чтобы приложение оставалось доступным во время обновления, использую параметр maxUnavailable: 3. Удалится сразу 3 реплики, и 2 останутся доступными. Для сокращения времени обновления параметр maxSurge установил в 2. Если обновление будет удачно, то на первом заходе будут готовы все 5 реплик (3 + 2). Оставшиеся 2 старые реплики будут остановлены. Если обновление пойдет неудачно, то останется 2 старых работающих реплики.

Меняю версию nginx на 1.20:

```
      containers:
      - name: nginx
        image: nginx:1.20
        ports:
```

Промежуточный
```
root@dgt-kuber-001:/home/kuber/HW69# kubectl get all -o wide
NAME                            READY   STATUS              RESTARTS   AGE   IP              NODE    NOMINATED NODE   READINESS GATES
pod/app-depl-574f94857-kqgsr    2/2     Running             0          18m   10.233.71.3     node3   <none>           <none>
pod/app-depl-574f94857-vt44t    2/2     Running             0          18m   10.233.97.132   node5   <none>           <none>
pod/app-depl-58974c6985-2xljq   0/2     ContainerCreating   0          24s   <none>          node4   <none>           <none>
pod/app-depl-58974c6985-6mxkr   0/2     ContainerCreating   0          24s   <none>          node5   <none>           <none>
pod/app-depl-58974c6985-cj2jh   0/2     ContainerCreating   0          24s   <none>          node1   <none>           <none>
pod/app-depl-58974c6985-d9s8m   0/2     ContainerCreating   0          24s   <none>          node2   <none>           <none>
pod/app-depl-58974c6985-vmfnp   0/2     ContainerCreating   0          24s   <none>          node3   <none>           <none>

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS        IMAGES                               SELECTOR
deployment.apps/app-depl   2/5     5            2           18m   nginx,multitool   nginx:1.20,wbitt/network-multitool   app=app-depl

NAME                                  DESIRED   CURRENT   READY   AGE   CONTAINERS        IMAGES                               SELECTOR
replicaset.apps/app-depl-574f94857    2         2         2       18m   nginx,multitool   nginx:1.19,wbitt/network-multitool   app=app-depl,pod-template-hash=574f94857
replicaset.apps/app-depl-58974c6985   5         5         0       24s   nginx,multitool   nginx:1.20,wbitt/network-multitool   app=app-depl,pod-template-hash=58974c6985
```

Финальный
```
root@dgt-kuber-001:/home/kuber/HW69# kubectl get all -o wide
NAME                            READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
pod/app-depl-58974c6985-2xljq   2/2     Running   0          4h20m   10.233.74.69     node4   <none>           <none>
pod/app-depl-58974c6985-6mxkr   2/2     Running   0          4h20m   10.233.97.133    node5   <none>           <none>
pod/app-depl-58974c6985-cj2jh   2/2     Running   0          4h20m   10.233.102.132   node1   <none>           <none>
pod/app-depl-58974c6985-d9s8m   2/2     Running   0          4h20m   10.233.75.5      node2   <none>           <none>
pod/app-depl-58974c6985-vmfnp   2/2     Running   0          4h20m   10.233.71.4      node3   <none>           <none>

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS        IMAGES                               SELECTOR
deployment.apps/app-depl   5/5     5            5           4h39m   nginx,multitool   nginx:1.20,wbitt/network-multitool   app=app-depl

NAME                                  DESIRED   CURRENT   READY   AGE     CONTAINERS        IMAGES                               SELECTOR
replicaset.apps/app-depl-574f94857    0         0         0       4h39m   nginx,multitool   nginx:1.19,wbitt/network-multitool   app=app-depl,pod-template-hash=574f94857
replicaset.apps/app-depl-58974c6985   5         5         5       4h20m   nginx,multitool   nginx:1.20,wbitt/network-multitool   app=app-depl,pod-template-hash=58974c6985
root@dgt-kuber-001:/home/kuber/HW69#
```

3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.

Меняю версию nginx на 1.28:

```
      containers:
      - name: nginx
        image: nginx:1.28
        ports:
```

Пошли ошибки при создании подов, остаются рабочими 2 реплики, приложение остается доступным:

```
root@dgt-kuber-001:/home/kuber/HW69# kubectl get all -o wide
NAME                            READY   STATUS             RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
pod/app-depl-58974c6985-2xljq   2/2     Running            0          4h33m   10.233.74.69     node4   <none>           <none>
pod/app-depl-58974c6985-vmfnp   2/2     Running            0          4h33m   10.233.71.4      node3   <none>           <none>
pod/app-depl-5fc85c697-66slb    1/2     ErrImagePull       0          77s     10.233.74.70     node4   <none>           <none>
pod/app-depl-5fc85c697-8pj57    1/2     ErrImagePull       0          77s     10.233.75.6      node2   <none>           <none>
pod/app-depl-5fc85c697-fgksd    1/2     ImagePullBackOff   0          76s     10.233.102.133   node1   <none>           <none>
pod/app-depl-5fc85c697-vrnxm    1/2     ErrImagePull       0          76s     10.233.97.134    node5   <none>           <none>
pod/app-depl-5fc85c697-x5pt8    1/2     ErrImagePull       0          76s     10.233.71.5      node3   <none>           <none>

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS        IMAGES                               SELECTOR
deployment.apps/app-depl   2/5     5            2           4h52m   nginx,multitool   nginx:1.28,wbitt/network-multitool   app=app-depl

NAME                                  DESIRED   CURRENT   READY   AGE     CONTAINERS        IMAGES                               SELECTOR
replicaset.apps/app-depl-574f94857    0         0         0       4h52m   nginx,multitool   nginx:1.19,wbitt/network-multitool   app=app-depl,pod-template-hash=574f94857
replicaset.apps/app-depl-58974c6985   2         2         2       4h33m   nginx,multitool   nginx:1.20,wbitt/network-multitool   app=app-depl,pod-template-hash=58974c6985
replicaset.apps/app-depl-5fc85c697    5         5         0       77s     nginx,multitool   nginx:1.28,wbitt/network-multitool   app=app-depl,pod-template-hash=5fc85c697
```

4. Откатиться после неудачного обновления.

```
root@dgt-kuber-001:/home/kuber/HW69# kubectl rollout undo deployment app-depl
deployment.apps/app-depl rolled back
```

Все откатилось нормально. 

```
root@dgt-kuber-001:/home/kuber/HW69# kubectl get all -o wide
NAME                            READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
pod/app-depl-58974c6985-2xljq   2/2     Running   0          4h35m   10.233.74.69     node4   <none>           <none>
pod/app-depl-58974c6985-mb687   2/2     Running   0          27s     10.233.102.134   node1   <none>           <none>
pod/app-depl-58974c6985-n4zz6   2/2     Running   0          27s     10.233.97.135    node5   <none>           <none>
pod/app-depl-58974c6985-vmfnp   2/2     Running   0          4h35m   10.233.71.4      node3   <none>           <none>
pod/app-depl-58974c6985-z2dpt   2/2     Running   0          27s     10.233.75.7      node2   <none>           <none>

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS        IMAGES                               SELECTOR
deployment.apps/app-depl   5/5     5            5           4h54m   nginx,multitool   nginx:1.20,wbitt/network-multitool   app=app-depl

NAME                                  DESIRED   CURRENT   READY   AGE     CONTAINERS        IMAGES                               SELECTOR
replicaset.apps/app-depl-574f94857    0         0         0       4h54m   nginx,multitool   nginx:1.19,wbitt/network-multitool   app=app-depl,pod-template-hash=574f94857
replicaset.apps/app-depl-58974c6985   5         5         5       4h35m   nginx,multitool   nginx:1.20,wbitt/network-multitool   app=app-depl,pod-template-hash=58974c6985
replicaset.apps/app-depl-5fc85c697    0         0         0       3m25s   nginx,multitool   nginx:1.28,wbitt/network-multitool   app=app-depl,pod-template-hash=5fc85c697
```
