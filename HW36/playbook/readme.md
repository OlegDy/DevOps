# 8.2 описание Playbook

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

## Описание Playbook 

[inventory](inventory/prod.yml)

### Установка Clickhouse 

- name: Get clickhouse distrib - скачать дистрибутивы
- name: Install clickhouse packages - установить дистрибутивы, запустить сервис после установки.
- name: Create database Clickhouse - создать базу

### Установка Vector
- name: Install Vector - скачать и установить дистрибутив
- name: Configure Service - настроить запуск сервиса и запустить его после настройки.
- name: Configure Vector 1 - создать каталог конфигурации
- name: Configure Vector 2 - скопировать файл конфигурации vector из ansible

## Ограничения
Устанавливается посредством yum, т.е. ОС линейки RedHat.