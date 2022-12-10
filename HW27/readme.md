# Домашнее задание 27 [6.5. Elasticsearch](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-05-elasticsearch)

## Олег Дьяченко DEVOPS-22

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

```
docker build -t elastic .
docker run -d -p 9200:9200 --name elastic elastic
```
[dockerfile](dockerfile)
```
FROM centos:7

RUN yum -y install sudo wget perl-Digest-SHA

COPY elasticsearch-8.5.3-linux-x86_64.tar.gz elasticsearch-8.5.3-linux-x86_64.tar.gz

RUN tar -xzf elasticsearch-8.5.3-linux-x86_64.tar.gz

RUN rm -f elasticsearch-8.5.3-linux-x86_64.tar.gz

RUN echo "cluster.name: cluster_netology_test" >> /elasticsearch-8.5.3/config/elasticsearch.yml && \
    echo "node.name: netology_test" >> /elasticsearch-8.5.3/config/elasticsearch.yml && \
    echo "path.data: /var/lib/elasticsearch" >> /elasticsearch-8.5.3/config/elasticsearch.yml && \
    echo "network.host: 0.0.0.0" >> /elasticsearch-8.5.3/config/elasticsearch.yml && \
    echo "discovery.type: single-node" >> /elasticsearch-8.5.3/config/elasticsearch.yml && \
    echo "xpack.security.enabled: false" >> /elasticsearch-8.5.3/config/elasticsearch.yml

RUN useradd -MU elastic && \
    chown -R elastic:elastic elasticsearch-8.5.3 && \
    mkdir /var/lib/elasticsearch && \
    chown -R elastic:elastic /var/lib/elasticsearch

EXPOSE 9200
EXPOSE 9300

CMD ["sudo", "-u", "elastic", "/elasticsearch-8.5.3/bin/elasticsearch"]
```
```
root@server1:/docker27# docker images
    REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
    elastic      latest    5f16fe477c51   30 minutes ago   3.4GB
    centos       7         eeb6ee3f44bd   15 months ago    204MB
root@server1:/docker27# docker tag elastic:latest olegdy/elastic:v001
root@server1:/docker27# docker images
    REPOSITORY       TAG       IMAGE ID       CREATED          SIZE
    elastic          latest    5f16fe477c51   31 minutes ago   3.4GB
    olegdy/elastic   v001      5f16fe477c51   31 minutes ago   3.4GB
    centos           7         eeb6ee3f44bd   15 months ago    204MB
root@server1:/docker27# docker login
    Authenticating with existing credentials...
    WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
    Configure a credential helper to remove this warning. See
    https://docs.docker.com/engine/reference/commandline/login/#credentials-store
    
    Login Succeeded
root@server1:/docker27# docker push olegdy/elastic:v001
    The push refers to repository [docker.io/olegdy/elastic]
    42b36d704138: Pushed
    d8b2b921ab3b: Pushed
    d690197b77d6: Pushed
    48682c5b198e: Pushed
    074e09d8051c: Pushed
    08a649f767a5: Pushed
    174f56854903: Mounted from library/centos
    v001: digest: sha256:89a2c42a31bd41a91bf36f2bad05e9b80754523baf45adfec0ce3b2bd135a40d size: 1795
```
[Образ elasticsearch](https://hub.docker.com/r/olegdy/elastic)
```
root@server1:/docker27# curl localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "cluster_netology_test",
  "cluster_uuid" : "entHgoGlSBCEGu7DD-d9Sw",
  "version" : {
    "number" : "8.5.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "4ed5ee9afac63de92ec98f404ccbed7d3ba9584e",
    "build_date" : "2022-12-05T18:22:22.226119656Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.2",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
root@server1:/docker27# curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
    {"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}root@server1:/docker27#

root@server1:/docker27# curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
    {"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}root@server1:/docker27#

root@server1:/docker27# curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
    {"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}root@server1:/docker27#
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```
root@server1:/docker27# curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   ind-1 9QDaI5K9QmWFnXpCFdwi6g   1   0          0            0       225b           225b
    yellow open   ind-3 0VLtylZySnOPfI3IYMqXfQ   4   2          0            0       900b           900b
    yellow open   ind-2 Te250cVlRxqwYVhvGmob_w   2   1          0            0       450b           450b
```

```
root@server1:/docker27# curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "cluster_netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

root@server1:/docker27# curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "cluster_netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

root@server1:/docker27# curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "cluster_netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```

Получите состояние кластера `elasticsearch`, используя API.
```
root@server1:/docker27# curl -XGET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "cluster_netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Индексы в статусе Yellow потому что у них указано число реплик, а других серверов нет.
Нашел решение: 
```
root@server1:/docker27# curl -H "Content-Type: application/json" -XPUT localhost:9200/*/_settings -d '{ "index" : { "number_of_replicas" : 0 } }'
    {"acknowledged":true}

root@server1:/docker27# curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   ind-1 9QDaI5K9QmWFnXpCFdwi6g   1   0          0            0       225b           225b
    green  open   ind-3 0VLtylZySnOPfI3IYMqXfQ   4   0          0            0       900b           900b
    green  open   ind-2 Te250cVlRxqwYVhvGmob_w   2   0          0            0       450b           450b
```

Удалите все индексы.

```
root@server1:/docker27# curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
root@server1:/docker27# curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
root@server1:/docker27# curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
root@server1:/docker27# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
```

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.
```
root@server1:/docker27# docker exec -i elastic /bin/bash
echo "path.repo: /elasticsearch-8.5.3/snapshots" >> /elasticsearch-8.5.3/config/elasticsearch.yml
mkdir /elasticsearch-8.5.3/snapshots
chown -R elastic:elastic /elasticsearch-8.5.3/snapshots
exit

docker stop elastic
docker start elastic

root@server1:/docker27# curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch-8.5.3/snapshots" }}'
{
  "acknowledged" : true
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```
root@server1:/docker27# curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
    {"acknowledged":true,"shards_acknowledged":true,"index":"test"}

root@server1:/docker27# curl -X GET 'http://localhost:9200/test?pretty'
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1670649609644",
        "number_of_replicas" : "0",
        "uuid" : "hfQ6VzgRQ2uNjIhswkVNAQ",
        "version" : {
          "created" : "8050399"
        }
      }
    }
  }
}

root@server1:/docker27# curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test  hfQ6VzgRQ2uNjIhswkVNAQ   1   0          0            0       225b           225b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.
```
root@server1:/docker27# curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"k7SVHqEiRpKyFg4wSY5kFA","repository":"netology_backup","version_id":8050399,"version":"8.5.3","indices":["test",".geoip_databases"],"data_streams":[],"include_global_state":true,
"state":"SUCCESS","start_time":"2022-12-10T05:24:31.788Z","start_time_in_millis":1670649871788,"end_time":"2022-12-10T05:24:32.993Z","end_time_in_millis":1670649872993,"duration_in_millis":1205,"failures":[],"shards":{"total":2,"failed":0,"successf
ul":2},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}

cd snapshots
ls -l -a -h
total 48K
drwxr-xr-x 3 elastic elastic 4.0K Dec 10 05:24 .
drwxr-xr-x 1 elastic elastic 4.0K Dec 10 05:06 ..
-rw-r--r-- 1 elastic elastic  846 Dec 10 05:24 index-0
-rw-r--r-- 1 elastic elastic    8 Dec 10 05:24 index.latest
drwxr-xr-x 4 elastic elastic 4.0K Dec 10 05:24 indices
-rw-r--r-- 1 elastic elastic  19K Dec 10 05:24 meta-k7SVHqEiRpKyFg4wSY5kFA.dat
-rw-r--r-- 1 elastic elastic  358 Dec 10 05:24 snap-k7SVHqEiRpKyFg4wSY5kFA.dat

```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
root@server1:/docker27# curl -X DELETE 'http://localhost:9200/test'
    {"acknowledged":true}

root@server1:/docker27# curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "test-2"
}

root@server1:/docker27# curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 jpg-xIoySvCzYC-_lH6cGA   1   0          0            0       225b           225b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
```
root@server1:/docker27# curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'
{
  "accepted" : true
}
root@server1:/docker27# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 jpg-xIoySvCzYC-_lH6cGA   1   0          0            0       225b           225b
green  open   test   wEHDyh1XRzWL7m4jf4vZtA   1   0          0            0       225b           225b
```
