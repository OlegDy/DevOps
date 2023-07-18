## Домашнее задание 64 [2.4 Управление доступом](https://github.com/netology-code/kuber-homeworks/blob/main/2.4/2.4.md)

### Олег Дьяченко DEVOPS-22

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.  

    Создаю сертификаты

    ```
    lega@ubuntu-001:~/cert_dev$ openssl genrsa -out dev.key 2048
    lega@ubuntu-001:~/cert_dev$ openssl req -new -key dev.key -out dev.csr -subj '/CN=dev/O=devgr'
    lega@ubuntu-001:~/cert_dev$ openssl x509 -req -in dev.csr -CA /var/snap/microk8s/current/certs/ca.crt -CAkey /var/snap/microk8s/current/certs/ca.key -CAcreateserial -out dev.crt -days 500
    Certificate request self-signature ok
    subject=CN = dev, O = devgr
    ```

    Создаю пользователя kubectl

    ```
    PS C:\PycharmProjects\DevOps\hw64> kubectl config set-credentials dev --client-certificate=C:\Programs\K8s\cert_dev\dev.crt --client-key=C:\Programs\K8s\cert_dev\dev.key
    User "dev" set.
    
    PS C:\PycharmProjects\DevOps\hw64> kubectl config set-context dev-context --cluster=microk8s-cluster --user=dev
    Context "dev-context" created.
    ```


2. Настройте конфигурационный файл kubectl для подключения.  

    Включил rbac на microk8s.
    ```
    lega@ubuntu-001:~$ microk8s enable rbac
    Infer repository core for addon rbac
    Enabling RBAC
    Reconfiguring apiserver
    Restarting apiserver
    RBAC is enabled
    ```

    ```
    PS C:\PycharmProjects\DevOps\hw64> kubectl config view
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority-data: DATA+OMITTED
        server: https://172.26.61.68:16443
      name: microk8s-cluster
    contexts:
    - context:
        cluster: microk8s-cluster
        user: dev
      name: dev-context
    - context:
        cluster: microk8s-cluster
        user: admin
      name: microk8s
    current-context: microk8s
    kind: Config
    preferences: {}
    users:
    - name: admin
      user:
        token: REDACTED
    - name: dev
      user:
        client-certificate: ..\..\..\Programs\K8s\cert_dev\dev.crt
        client-key: ..\..\..\Programs\K8s\cert_dev\dev.key
    ```

    ```
    PS C:\PycharmProjects\DevOps\hw64> kubectl config use-context dev-context
    Switched to context "dev-context".
    PS C:\PycharmProjects\DevOps\hw64> kubectl config current-context
    dev-context
    ```

    Проверяем доступ, его нет.

    ```
    PS C:\PycharmProjects\DevOps\hw64> kubectl get pods
    Error from server (Forbidden): pods is forbidden: User "dev" cannot list resource "pods" in API group "" in the namespace "default"
    ```

3. Создайте роли и все необходимые настройки для пользователя.

    Сделал роль и тестовый Pod. Переключился под админа и применил манифест.

    ```
    PS C:\PycharmProjects\DevOps\hw64> kubectl config use-context microk8s
    Switched to context "microk8s".
    
    PS C:\PycharmProjects\DevOps\hw64> kubectl get pods
    No resources found in default namespace.
    
    PS C:\PycharmProjects\DevOps\hw64\manifest> kubectl.exe apply -f .\roles.yaml                                           
    role.rbac.authorization.k8s.io/pod-reader-role created
    rolebinding.rbac.authorization.k8s.io/pod-reader-rb created
    pod/multitool created
    ```
    
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: pod-reader-role
    rules:
    - apiGroups: [""]
      resources: ["pods", "pods/log"]
      verbs: ["get"]
    
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: pod-reader-rb
    subjects:
    - kind: User
      name: dev
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: Role
      name: pod-reader-role
      apiGroup: rbac.authorization.k8s.io
    
    ---
    apiVersion: v1
    kind: Pod
    metadata:
      name: multitool
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool:latest
    ```


4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).

    На общий список прав не хватает
    ```
    PS C:\PycharmProjects\DevOps\hw64\manifest> kubectl config use-context dev-context
    Switched to context "dev-context".
    PS C:\PycharmProjects\DevOps\hw64\manifest> kubectl get pods                      
    Error from server (Forbidden): pods is forbidden: User "dev" cannot list resource "pods" in API group "" in the namespace "default"
    ```
    Но на просмотр параметров и логов пода есть.
    ```
    PS C:\PycharmProjects\DevOps\hw64\manifest> kubectl get pods multitool   
    NAME        READY   STATUS    RESTARTS   AGE
    multitool   1/1     Running   0          2m9s
    
    PS C:\PycharmProjects\DevOps\hw64\manifest> kubectl describe pods multitool
    Name:             multitool
    Namespace:        default
    Priority:         0
    Service Account:  default
    Node:             ubuntu-001/172.26.61.68
    Start Time:       Tue, 18 Jul 2023 16:00:42 +1000
    Labels:           <none>
    Annotations:      cni.projectcalico.org/containerID: 567c102f82fe190fa56370e4fc6547b5490af237288f78f39a606c9a97eb6376
                      cni.projectcalico.org/podIP: 10.1.63.127/32
                      cni.projectcalico.org/podIPs: 10.1.63.127/32
    Status:           Running
    IP:               10.1.63.127
    IPs:
      IP:  10.1.63.127
    Containers:
      multitool:
        Container ID:   containerd://e4b7a69e0afb97dbf006926604d24e591282040ea70b59ca13f7f10bde227fda
        Image:          wbitt/network-multitool:latest
        Image ID:       docker.io/wbitt/network-multitool@sha256:82a5ea955024390d6b438ce22ccc75c98b481bf00e57c13e9a9cc1458eb92652
        Port:           <none>
        Host Port:      <none>
        State:          Running
          Started:      Tue, 18 Jul 2023 16:00:45 +1000
        Ready:          True
        Restart Count:  0
        Environment:    <none>
        Mounts:
          /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-5nkcv (ro)
    Conditions:
      Type              Status
      Initialized       True
      Ready             True
      ContainersReady   True
      PodScheduled      True
    Volumes:
      kube-api-access-5nkcv:
        Type:                    Projected (a volume that contains injected data from multiple sources)
        TokenExpirationSeconds:  3607
        ConfigMapName:           kube-root-ca.crt
        ConfigMapOptional:       <nil>
        DownwardAPI:             true
    QoS Class:                   BestEffort
    Node-Selectors:              <none>
    Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
    Events:                      <none>
    
    PS C:\PycharmProjects\DevOps\hw64\manifest> kubectl logs multitool 
    The directory /usr/share/nginx/html is not mounted.
    Therefore, over-writing the default index.html file with some useful information:
    WBITT Network MultiTool (with NGINX) - multitool - 10.1.63.127 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
    ```

5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

------



