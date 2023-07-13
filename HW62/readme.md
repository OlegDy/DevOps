## Домашнее задание 62 [2.2 Хранение в K8s. Часть 2](https://github.com/netology-code/kuber-homeworks/blob/main/2.2/2.2.md)

### Олег Дьяченко DEVOPS-22

# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: deployment1
      labels:
        app: depl1
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: depl1
      template:
        metadata:
          labels:
            app: depl1
        spec:
          containers:
    
          - name: busybox
            image: busybox
            command: ['sh', '-c', 'while true; do echo message from busybox! >> /output/output.txt; sleep 5; done']
            volumeMounts:
            - name: pv1
              mountPath: /output
    
          - name: multitool
            image: wbitt/network-multitool:latest
            ports:
            - containerPort: 80
            env:
            - name: HTTP_PORT
              value: "80"
            volumeMounts:
            - name: pv1
              mountPath: /input
    
          volumes:
          - name: pv1
            persistentVolumeClaim:
              claimName: pvc1
    
    ---
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: pv1
    spec:
      storageClassName: host-path
      capacity:
        storage: 1Gi
      accessModes:
      - ReadWriteOnce
      hostPath:
        path: /data1/pv1
    
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: pvc1
    spec:
      storageClassName: host-path
      volumeMode: Filesystem
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
    ```
    
    ```
    PS C:\PycharmProjects\DevOps\hw62\manifest> kubectl.exe get all              
    NAME                               READY   STATUS    RESTARTS   AGE
    pod/deployment1-6c6b9456d8-hvczx   2/2     Running   0          11s
    
    NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/deployment1   1/1     1            1           11s
    
    NAME                                     DESIRED   CURRENT   READY   AGE
    replicaset.apps/deployment1-6c6b9456d8   1         1         1       11s
    ```

3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории.

    ```
    PS C:\PycharmProjects\DevOps\hw62\manifest> kubectl exec pods/deployment1-6c6b9456d8-hvczx -c multitool -- cat /input/output.txt
    message from busybox!
    message from busybox!
    message from busybox!
    message from busybox!
    message from busybox!
    message from busybox!
    message from busybox!
    message from busybox!
    message from busybox!
    ```

4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.

    ```
    lega@ubuntu-001:/var/log$ microk8s kubectl delete deployments.apps deployment1
    deployment.apps "deployment1" deleted
    
    lega@ubuntu-001:/var/log$ microk8s kubectl get pvc
    NAME   STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    pvc1   Bound    pv1      1Gi        RWO            host-path      5m44s
    
    lega@ubuntu-001:/var/log$ microk8s kubectl delete pvc pvc1
    persistentvolumeclaim "pvc1" deleted
    ```
    
    ```
    lega@ubuntu-001:/var/log$ microk8s kubectl get all,pv,pvc
    NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
    service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   14d
    
    NAME                   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM          STORAGECLASS   REASON   AGE
    persistentvolume/pv1   1Gi        RWO            Retain           Released   default/pvc1   host-path               6m43s
    ```
    
    После удаления соответвующего PersistentVolumeClaim, PersistentVolume остаётся, и отмечается как “released“, однако становится недоступен для новых PersistentVolumeClaim, т.к. содержит данные предыдущего PersistentVolumeClaim.

5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.

    ```
    lega@ubuntu-001:/$ ls -la /data1/pv1/
    total 12
    drwxr-xr-x 2 root root 4096 июл 12 05:38 .
    drwxr-xr-x 3 root root 4096 июл 12 05:38 ..
    -rw-r--r-- 1 root root 1562 июл 12 05:44 output.txt
    ```
    
    ```
    lega@ubuntu-001:/$ microk8s kubectl describe pv pv1
    Name:            pv1
    Labels:          <none>
    Annotations:     pv.kubernetes.io/bound-by-controller: yes
    Finalizers:      [kubernetes.io/pv-protection]
    StorageClass:    host-path
    Status:          Released
    Claim:           default/pvc1
    Reclaim Policy:  Retain
    Access Modes:    RWO
    VolumeMode:      Filesystem
    Capacity:        1Gi
    Node Affinity:   <none>
    Message:
    Source:
        Type:          HostPath (bare host directory volume)
        Path:          /data1/pv1
        HostPathType:
    Events:            <none>
    ```
    
    ```
    lega@ubuntu-001:/$ microk8s kubectl delete pv pv1
    persistentvolume "pv1" deleted
    
    lega@ubuntu-001:/$ ls -la /data1/pv1/
    total 12
    drwxr-xr-x 2 root root 4096 июл 12 05:38 .
    drwxr-xr-x 3 root root 4096 июл 12 05:38 ..
    -rw-r--r-- 1 root root 1562 июл 12 05:44 output.txt
    ```
    
    Политика `Reclaim Policy:  Retain` - после удаления PV ресурсы из внешних
    провайдеров автоматически не удаляются, но и при Delete — после удаления PV ресурсы удаляются только в облачных Storage. Файл остался бы в любом случае.


------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.

    ```
    lega@ubuntu-001:/$ microk8s enable nfs
    Infer repository community for addon nfs
    Infer repository core for addon helm3
    Addon core/helm3 is already enabled
    Installing NFS Server Provisioner - Helm Chart 1.4.0
    
    Node Name not defined. NFS Server Provisioner will be deployed on random Microk8s Node.
    
    If you want to use a dedicated (large disk space) Node as NFS Server, disable the Addon and start over: microk8s enable nfs -n NODE_NAME
    Lookup Microk8s Node name as: kubectl get node -o yaml | grep 'kubernetes.io/hostname'
    
    Preparing PV for NFS Server Provisioner
    
    persistentvolume/data-nfs-server-provisioner-0 created
    "nfs-ganesha-server-and-external-provisioner" has been added to your repositories
    Release "nfs-server-provisioner" does not exist. Installing it now.
    NAME: nfs-server-provisioner
    LAST DEPLOYED: Wed Jul 12 07:11:55 2023
    NAMESPACE: nfs-server-provisioner
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    NOTES:
    The NFS Provisioner service has now been installed.
    
    A storage class named 'nfs' has now been created
    and is available to provision dynamic volumes.
    
    You can use this storageclass by creating a `PersistentVolumeClaim` with the
    correct storageClassName attribute. For example:
    
        ---
        kind: PersistentVolumeClaim
        apiVersion: v1
        metadata:
          name: test-dynamic-volume-claim
        spec:
          storageClassName: "nfs"
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 100Mi
    
    NFS Server Provisioner is installed
    
    WARNING: Install "nfs-common" package on all MicroK8S nodes to allow Pods with NFS mounts to start: sudo apt update && sudo apt install -y nfs-common
    WARNING: NFS Server Provisioner servers by default hostPath storage from a single Node.
    ```
    ```
    lega@ubuntu-001:/$ microk8s kubectl get storageclasses.storage.k8s.io
    NAME                          PROVISIONER                            RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
    microk8s-hostpath (default)   microk8s.io/hostpath                   Delete          WaitForFirstConsumer   false                  22d
    nfs                           cluster.local/nfs-server-provisioner   Delete          Immediate              true                   72s
    ```

2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: deployment2
     labels:
       app: depl2
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: depl2
     template:
       metadata:
         labels:
           app: depl2
       spec:
         containers:
   
         - name: multitool
           image: wbitt/network-multitool:latest
           ports:
           - containerPort: 80
           env:
           - name: HTTP_PORT
             value: "80"
           volumeMounts:
           - name: pv2
             mountPath: /input
   
         volumes:
         - name: pv2
           persistentVolumeClaim:
             claimName: pvc1
   
   ---
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: pvc1
   spec:
     storageClassName: "nfs"
     accessModes:
     - ReadWriteOnce
     resources:
       requests:
         storage: 1Gi
   ```
   
   ```
   lega@ubuntu-001:/$ microk8s kubectl get storageclasses.storage.k8s.io
   NAME                          PROVISIONER                            RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
   microk8s-hostpath (default)   microk8s.io/hostpath                   Delete          WaitForFirstConsumer   false                  22d
   nfs                           cluster.local/nfs-server-provisioner   Delete          Immediate              true                   17h
   ```
   
   ```
   lega@ubuntu-001:/$ microk8s kubectl get all,pv,pvc
   NAME                               READY   STATUS    RESTARTS   AGE
   pod/deployment2-64bb56d876-kc57q   1/1     Running   0          83s
   
   NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
   service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   15d
   
   NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
   deployment.apps/deployment2   1/1     1            1           83s
   
   NAME                                     DESIRED   CURRENT   READY   AGE
   replicaset.apps/deployment2-64bb56d876   1         1         1       83s
   
   NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                  STORAGECLASS   REASON   AGE
   persistentvolume/data-nfs-server-provisioner-0              1Gi        RWO            Retain           Bound    nfs-server-provisioner/data-nfs-server-provisioner-0                           17h
   persistentvolume/pvc-cc4c1f17-fc58-43b2-ae10-eb3b23426092   1Gi        RWO            Delete           Bound    default/pvc1                                           nfs                     83s
   
   NAME                         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
   persistentvolumeclaim/pvc1   Bound    pvc-cc4c1f17-fc58-43b2-ae10-eb3b23426092   1Gi        RWO            nfs            83s
   ```

3. Продемонстрировать возможность чтения и записи файла изнутри пода.

   ```
   lega@ubuntu-001:/$ microk8s kubectl exec pods/deployment2-64bb56d876-kc57q -it -- bash
   bash-5.1# ls
   bin     certs   dev     docker  etc     home    input   lib     media   mnt     opt     proc    root    run     sbin    srv     sys     tmp     usr     var
   bash-5.1# cd input
   bash-5.1# ls
   bash-5.1# echo hello > readme.txt
   bash-5.1# cat readme.txt
   hello
   bash-5.1#
   ```
   
   Локально на microk8s 
   ```
   lega@ubuntu-001:/$ cat /var/snap/microk8s/common/nfs-storage/pvc-cc4c1f17-fc58-43b2-ae10-eb3b23426092/readme.txt
   hello
   ```