## Домашнее задание 61 [2.1 Хранение в K8s. Часть 1](https://github.com/netology-code/kuber-homeworks/blob/main/2.1/2.1.md)

### Олег Дьяченко DEVOPS-22

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.

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
            - name: depl1-volume
              mountPath: /output
          - name: multitool
            image: wbitt/network-multitool:latest
            ports:
            - containerPort: 80
            env:
            - name: HTTP_PORT
              value: "80"
            volumeMounts:
            - name: depl1-volume
              mountPath: /input
          volumes:
          - name: depl1-volume
            emptyDir: {}
    ```

2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.

    ```
    PS C:\PycharmProjects\DevOps\hw61\manifest> kubectl exec pods/deployment1-84948f6499-xhbmd -c busybox -- cat /output/output.txt
    message from busybox!
    message from busybox!
    message from busybox!
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

3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.

    ```
    PS C:\PycharmProjects\DevOps\hw61\manifest> kubectl exec pods/deployment1-84948f6499-xhbmd -c multitool -- cat /input/output.txt
    message from busybox!
    message from busybox!
    message from busybox!
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

5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.

    ```yaml
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: deployment2
      labels:
        app: depl2
    spec:
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
            image: wbitt/network-multitool
            volumeMounts:
            - name: varlog
              mountPath: /output
            ports:
            ports:
            - containerPort: 80
            env:
            - name: HTTP_PORT
              value: "80"
          volumes:
          - name: varlog
            hostPath:
              path: /var/log
    ```         

2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
    
    ```
    PS C:\PycharmProjects\DevOps\hw61\manifest> kubectl exec pods/deployment2-bbnvf -c multitool -- tail -10 /output/syslog
    Jul  7 06:16:02 ubuntu-001 systemd[1]: run-containerd-runc-k8s.io-918fe40e883844369412e51ea3d4c1ec39699badf8b51ade1a0e9d1fcc6a134a-runc.iuZ9Qj.mount: Deactivated successfully.
    Jul  7 06:16:05 ubuntu-001 systemd[1]: run-containerd-runc-k8s.io-2bba472c094beeb175b1b48f2c48d5628e9a42f762080b127340339532502a4a-runc.aGQ6kN.mount: Deactivated successfully.
    Jul  7 06:16:09 ubuntu-001 systemd[4158195]: Started snap.microk8s.microk8s.47778d6e-ac76-4b49-bc6b-838a34d4b2b0.scope.
    Jul  7 06:16:09 ubuntu-001 systemd[4158195]: Started snap.microk8s.microk8s.312e1d5e-c50e-44be-9b82-43bf0f75a823.scope.
    Jul  7 06:16:17 ubuntu-001 systemd[4158195]: Started snap.microk8s.microk8s.64fa01e7-47d5-4430-b990-be0970866a8f.scope.
    Jul  7 06:16:17 ubuntu-001 systemd[1]: run-containerd-runc-k8s.io-2bba472c094beeb175b1b48f2c48d5628e9a42f762080b127340339532502a4a-runc.MCxOcv.mount: Deactivated successfully.
    Jul  7 06:16:22 ubuntu-001 systemd[1]: run-containerd-runc-k8s.io-918fe40e883844369412e51ea3d4c1ec39699badf8b51ade1a0e9d1fcc6a134a-runc.a8tOJu.mount: Deactivated successfully.
    Jul  7 06:16:22 ubuntu-001 systemd[1]: run-containerd-runc-k8s.io-918fe40e883844369412e51ea3d4c1ec39699badf8b51ade1a0e9d1fcc6a134a-runc.PMX5RP.mount: Deactivated successfully.
    Jul  7 06:16:25 ubuntu-001 systemd[1]: run-containerd-runc-k8s.io-2bba472c094beeb175b1b48f2c48d5628e9a42f762080b127340339532502a4a-runc.BrnUbg.mount: Deactivated successfully.
    Jul  7 06:16:35 ubuntu-001 systemd[1]: run-containerd-runc-k8s.io-2bba472c094beeb175b1b48f2c48d5628e9a42f762080b127340339532502a4a-runc.UZWWes.mount: Deactivated successfully.
    ```

4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

------
