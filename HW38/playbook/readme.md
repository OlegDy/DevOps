# 8.4 описание Playbook

## Переменные

Для clickhouse [group_vars/clickhouse/vars.yml](group_vars/clickhouse/vars.yml)
```
clickhouse_version: "22.3.3.44" - версия clickhouse 
clickhouse_packages:
  - clickhouse-client
  - clickhouse-server
  - clickhouse-common-static
```
Для vector [group_vars/vector/vars.yml](group_vars/vector/vars.yml)
```
  vector_version: 0.21.1 - версия vector
  vector_config_dir: "{{ ansible_user_dir }}/vector_config"
  vector_config:
```
Настройка самого vector [vector.yml](templates/vector.yml.j2)

Для vector [group_vars/lighthouse/vars.yml](group_vars/lighthouse/vars.yml)
```
  lighthouse_port: "80"
```
Настройка [templates/nginx.j2](templates/nginx.j2)

## Описание Playbook 

[inventory prod](inventory/prod.yml)

[inventory test](inventory/test.yml)

### Установка Clickhouse 

Установка производится через роль  
```
  - name: clickhouse-role
    src: https://github.com/AlexeySetevoi/ansible-clickhouse.git
    version: "1.11.0"
```

### Установка Vector

Установка производится через роль  

```
  - name: lighthouse-role
    src: https://github.com/OlegDy/lighthouse-role.git
    version: "1.0.0"
```

### Установка Lighthouse

Установка производится через роль  
```
  - name: vector-role
    src: https://github.com/OlegDy/vector-role.git
    version: "1.0.0"
```

## Ограничения
Устанавливается посредством yum, т.е. ОС линейки RedHat.