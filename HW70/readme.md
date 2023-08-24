## Домашнее задание 70 [3.5 Troubleshooting](https://github.com/netology-code/kuber-homeworks/blob/main/3.5/3.5.md)

### Олег Дьяченко DEVOPS-22

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.


### Ответ:

Запуск
```
root@dgt-kuber-001:/home/kuber/HW69# kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
```

Нет namespaces, дописываю манифест и запускаю снова.

```
---
apiVersion: v1
kind: Namespace
metadata:
  name: web

---
apiVersion: v1
kind: Namespace
metadata:
  name: data
```

Статусы подов в порядке
```
root@dgt-kuber-001:/home/kuber/HW70# kubectl get all -n web
NAME                                READY   STATUS    RESTARTS   AGE
pod/web-consumer-84fc79d94d-7r98l   1/1     Running   0          8m40s
pod/web-consumer-84fc79d94d-s4fdg   1/1     Running   0          8m40s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/web-consumer   2/2     2            2           8m40s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/web-consumer-84fc79d94d   2         2         2       8m40s
```

```
root@dgt-kuber-001:/home/kuber/HW70# kubectl get all -n data
NAME                           READY   STATUS    RESTARTS   AGE
pod/auth-db-864ff9854c-x9nmr   1/1     Running   0          9m3s

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/auth-db   ClusterIP   10.233.49.186   <none>        80/TCP    9m3s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/auth-db   1/1     1            1           9m3s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/auth-db-864ff9854c   1         1         1       9m3s
```

Смотрим логи подов  
Здесь явных ошибок не видно
```
root@dgt-kuber-001:/home/kuber/HW70# kubectl logs -n data auth-db-864ff9854c-x9nmr
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
```

тут не может найти в dns хост 'auth-db'
```
root@dgt-kuber-001:/home/kuber/HW70# kubectl logs -n web web-consumer-84fc79d94d-7r98l
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
```
  
Разные Namespace по короткому имени не находит.  
Дополняю имя хоста 'auth-db.data'

```
        - while true; do curl auth-db.data; sleep 5; done
```

Перезапускаю манифест, перезапускаются поды
```
web           web-consumer-5769f9f766-kchgz              1/1     Running       0          21s
web           web-consumer-5769f9f766-w8kkh              1/1     Running       0          20s
web           web-consumer-84fc79d94d-7r98l              1/1     Terminating   0          22m
web           web-consumer-84fc79d94d-s4fdg              1/1     Terminating   0          22m
```

Логи пода, теперь все работает.
```
root@dgt-kuber-001:/home/kuber/HW70# kubectl logs -n web web-consumer-5769f9f766-kchgz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
100   612  100   612    0     0   4020      0 --:--:-- --:--:-- --:--:--  298k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  58103      0 --:--:-- --:--:-- --:--:--  119k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }

```

