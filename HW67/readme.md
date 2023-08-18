## Домашнее задание 67 [3.2 Установка Kubernetes](https://github.com/netology-code/kuber-homeworks/blob/main/3.2/3.2.md)

### Олег Дьяченко DEVOPS-22

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

### Ответ

Развернул виртуальные машины на своем рабочем сервере VMware, поставил Ubuntu 22.04 и затем клонировал 5 машин.

Устанавливал кластер через kubespray, по их документации. Все поднялось, но достаточно долго.

Билдер подготовил файл inventory/mycluster/hosts.yaml. Согласно заданию сделал настройки.

```yaml
hosts.yaml
all:
  hosts:
    node1:
      ansible_host: 172.26.61.111
      ip: 172.26.61.111
      access_ip: 172.26.61.111
    node2:
      ansible_host: 172.26.61.112
      ip: 172.26.61.112
      access_ip: 172.26.61.112
    node3:
      ansible_host: 172.26.61.113
      ip: 172.26.61.113
      access_ip: 172.26.61.113
    node4:
      ansible_host: 172.26.61.114
      ip: 172.26.61.114
      access_ip: 172.26.61.114
    node5:
      ansible_host: 172.26.61.115
      ip: 172.26.61.115
      access_ip: 172.26.61.115
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node1:
        node2:
        node3:
        node4:
        node5:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```

В файле `inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml` проверил настройку runtime
```
## Container runtime
## docker for docker, crio for cri-o and containerd for containerd.
## Default: containerd
container_manager: containerd
```

```
root@node1:~# kubectl get nodes
NAME    STATUS   ROLES           AGE   VERSION
node1   Ready    control-plane   29m   v1.27.4
node2   Ready    <none>          28m   v1.27.4
node3   Ready    <none>          28m   v1.27.4
node4   Ready    <none>          28m   v1.27.4
node5   Ready    <none>          28m   v1.27.4
```

```
root@node1:~# kubectl get nodes -o wide
NAME    STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
node1   Ready    control-plane   29m   v1.27.4   172.26.61.111   <none>        Ubuntu 22.04.3 LTS   5.15.0-79-generic   containerd://1.7.3
node2   Ready    <none>          29m   v1.27.4   172.26.61.112   <none>        Ubuntu 22.04.3 LTS   5.15.0-79-generic   containerd://1.7.3
node3   Ready    <none>          29m   v1.27.4   172.26.61.113   <none>        Ubuntu 22.04.3 LTS   5.15.0-79-generic   containerd://1.7.3
node4   Ready    <none>          29m   v1.27.4   172.26.61.114   <none>        Ubuntu 22.04.3 LTS   5.15.0-79-generic   containerd://1.7.3
node5   Ready    <none>          29m   v1.27.4   172.26.61.115   <none>        Ubuntu 22.04.3 LTS   5.15.0-79-generic   containerd://1.7.3
```

Не нашел в подах etcd.
```
root@node1:~# kubectl get pod -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-5c5b57ffb5-t54mw   1/1     Running   0          44m
kube-system   calico-node-7gtdr                          1/1     Running   0          44m
kube-system   calico-node-cqbw8                          1/1     Running   0          44m
kube-system   calico-node-ktwfw                          1/1     Running   0          44m
kube-system   calico-node-l2xd2                          1/1     Running   0          44m
kube-system   calico-node-nw74t                          1/1     Running   0          44m
kube-system   coredns-5c469774b8-2kstv                   1/1     Running   0          43m
kube-system   coredns-5c469774b8-mtrxd                   1/1     Running   0          43m
kube-system   dns-autoscaler-f455cf558-jlzbm             1/1     Running   0          43m
kube-system   kube-apiserver-node1                       1/1     Running   1          46m
kube-system   kube-controller-manager-node1              1/1     Running   2          46m
kube-system   kube-proxy-495vl                           1/1     Running   0          45m
kube-system   kube-proxy-5vc6j                           1/1     Running   0          45m
kube-system   kube-proxy-7bq76                           1/1     Running   0          45m
kube-system   kube-proxy-czwjh                           1/1     Running   0          45m
kube-system   kube-proxy-hht5l                           1/1     Running   0          45m
kube-system   kube-scheduler-node1                       1/1     Running   1          46m
kube-system   nginx-proxy-node2                          1/1     Running   0          45m
kube-system   nginx-proxy-node3                          1/1     Running   0          45m
kube-system   nginx-proxy-node4                          1/1     Running   0          45m
kube-system   nginx-proxy-node5                          1/1     Running   0          45m
kube-system   nodelocaldns-b59wx                         1/1     Running   0          43m
kube-system   nodelocaldns-b78tx                         1/1     Running   0          43m
kube-system   nodelocaldns-f5w62                         1/1     Running   0          43m
kube-system   nodelocaldns-lw2hl                         1/1     Running   0          43m
kube-system   nodelocaldns-vk4pg                         1/1     Running   0          43m
```

Но потом поковырялся и нашел его в процессах и сервисах.

```
root@node1:~# ps xa | grep etcd
   6808 ?        Ssl    0:55 /usr/local/bin/etcd

root@node1:~# systemctl | grep etcd
  etcd.service                         loaded active running   etcd
```

