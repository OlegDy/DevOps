# Домашнее задание 20 "3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Олег Дьяченко DEVOPS-22

## Задача 1

Сценарий выполнения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

```
root@server1:/home/vagrant# docker pull nginxdemos/hello
Using default tag: latest
latest: Pulling from nginxdemos/hello
213ec9aee27d: Pull complete
ae98275d0ecb: Pull complete
121e2d9f6af2: Pull complete
6a07d505af0f: Pull complete
3e8957b70867: Pull complete
2806408d582e: Pull complete
843ea801d698: Pull complete
ee2080a236be: Pull complete
6c23cd939c31: Pull complete
Digest: sha256:c0ba28dbd7b5e9c74b3221291e8b2cbbd507e292ca71df35ae5e0a4a0ed4436a
Status: Downloaded newer image for nginxdemos/hello:latest
docker.io/nginxdemos/hello:latest

root@server1:/home/vagrant# docker run -d -p 8080:80 --name ng nginxdemos/hello
3299394df4f5a050c0ccd362a7f5d3f13007d6dfe1216495cb6887a910787c79

root@server1:/home/vagrant# docker cp index.html ng:/usr/share/nginx/html/index.html

root@server1:/home/vagrant# curl localhost:8080
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>


root@server1:/home/vagrant# docker commit ng ng_devops
sha256:a5599ccb248439147e3b0607700b2bd7223d20896156e9762dde47ed082c87c8

root@server1:/home/vagrant# docker images
REPOSITORY         TAG       IMAGE ID       CREATED          SIZE
ng_devops          latest    a5599ccb2484   10 seconds ago   23.6MB
nginxdemos/hello   latest    4fcfc95becea   13 days ago      23.6MB

root@server1:/home/vagrant# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: olegdy
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

root@server1:/home/vagrant# docker tag ng_devops:latest olegdy/devops:v001
root@server1:/home/vagrant# docker push olegdy/devops:v001
The push refers to repository [docker.io/olegdy/devops]
bd7f7d2f7523: Pushed
4f74c452e694: Pushed
6a51f7ed0bdd: Pushed
afbe13e24b56: Pushed
0618d1e529fa: Pushed
6e96dd581d79: Pushed
acf5e0b2cf08: Pushed
d51445d70778: Pushed
b96b16a53835: Pushed
994393dc58e7: Pushed
v001: digest: sha256:91229647aa2a9f148c4f14d8ac30fca392382e7d6f405224a3cb001041425b10 size: 2397
```

[https://hub.docker.com/r/olegdy/devops](https://hub.docker.com/r/olegdy/devops)

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение; виртуалка или физика, лучше всетаки виртуалка можно ресурсов побольше дать если не справляется. 
- Nodejs веб-приложение; - докер, не шибко нагруженное. 
- Мобильное приложение c версиями для Android и iOS; - докер, т.к. для программистов. 
- Шина данных на базе Apache Kafka; - физика т.к. биг дата, правда некоторые сервисы все равно можно в виртуалки засунуть.
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana; - виртуалки по разным облакам, это для нас девопсников.
- Мониторинг-стек на базе Prometheus и Grafana; - виртуалка, для наших нужд.
- MongoDB, как основное хранилище данных для java-приложения; виртуалка, ну может физика на крайняк.
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. - виртуалка, физика.

я так думаю, все что биг дата и что то которое работает напрямую с железом это физика, все что для нас devops это виртуалки, программеры это докеры.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.


```
root@server1:/data# docker run -it -d -v /data:/data --name centos centos
40eaff7768892d26378375c0c7b90510ff4dd1da2f58bf5c0dbf9adcdc43c602

root@server1:/data# docker run -it -d -v /data:/data --name debian debian
7cc08b39d7a14d52896e5557cf187d1ffc6fcb9e97382ab35544796016503ee3

root@server1:/data# docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED              STATUS              PORTS     NAMES
7cc08b39d7a1   debian    "bash"        3 seconds ago        Up 2 seconds                  debian
40eaff776889   centos    "/bin/bash"   About a minute ago   Up About a minute             centos

root@server1:/data# docker exec -i centos /bin/bash
cd /data
ls
echo hello i am centos > centos.txt
ls
centos.txt

root@server1:/data# ls
centos.txt
root@server1:/data# echo hello i am host > host.txt
root@server1:/data# ls
centos.txt  host.txt

root@server1:/data# docker exec -i debian /bin/bash
cd /data
ls
centos.txt
host.txt
cat centos.txt
hello i am centos
cat host.txt
hello i am host
```
