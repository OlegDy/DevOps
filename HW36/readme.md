## Домашнее задание 36 [8.2 Работа с Playbook](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-02-playbook)

### Олег Дьяченко DEVOPS-22

# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.  
   Сделал [docker-compose](playbook/docker-compose.yml)  
   Едиинственное службы не запускались пока не прописал, промучался пару дней. Причем не понял почему.
   ```
    privileged: true
    image: pycontribs/centos:7
    entrypoint: "/usr/sbin/init"
   ```
   По сути просто не все в докерах можно отработать получается, хотя все-таки сделал.
   Если сможете, отпишитесь что думаете на этот случай.

## Основная часть

1. Приготовьте свой собственный inventory файл [ссылка prod.yml](playbook/inventory/prod.yml).
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [Ссылка](playbook/site.yml).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.  
    Долго мучался, playbook из дз как есть не работал от слова совсем.  
    Получается handler вызывается после всего таска, а так как служба не запущена, база создаться не может, происходит fail,
    и handler запускается, но не отрабатывает команды. После моей вставки все работает. 
    ```
    root@server1:/vagrant/playbook82# ansible-lint site.yml
    [503] Tasks that run when changed should likely be handlers
    site.yml:33
    Task/Handler: Init clickhouse-server
    
     - name: Install clickhouse packages
          become: true
          ansible.builtin.yum:
            name:
              - clickhouse-common-static-{{ clickhouse_version }}.rpm
              - clickhouse-client-{{ clickhouse_version }}.rpm
              - clickhouse-server-{{ clickhouse_version }}.rpm
          register: result
    
     - name: Init clickhouse-server       <- 33 строка
          become: true
          ansible.builtin.service:
            name: clickhouse-server
            state: restarted
          when: result.changed
    
    ```
    Но lint говорит желательно делать через handler, переделал site.yml. Перенес "Create database Clickhouse" в новый play. 
    Теперь и код работает и lint не ругается. По итогу [site.yml](playbook/site.yml)

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
    ```
    root@server1:/vagrant/playbook82# ansible-playbook site.yml -i inventory/prod.yml --check
    
    PLAY [Install Clickhouse] *******************************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Get clickhouse distrib] ***************************************************************************************
    changed: [clickhouse-01] => (item=clickhouse-client)
    changed: [clickhouse-01] => (item=clickhouse-server)
    failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}
    
    TASK [Get clickhouse distrib] ***************************************************************************************
    changed: [clickhouse-01]
    
    TASK [Install clickhouse packages] **********************************************************************************
    fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}
    
    PLAY RECAP **********************************************************************************************************
    clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0
    ```
    Файлы не скачались поэтому не могут установиться.  

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

    ```
    root@server1:/vagrant/playbook82# ansible-playbook -i inventory/prod.yml --diff site.yml
    
    PLAY [Install Clickhouse] *******************************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Get clickhouse distrib] ***************************************************************************************
    changed: [clickhouse-01] => (item=clickhouse-client)
    changed: [clickhouse-01] => (item=clickhouse-server)
    failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}
    
    TASK [Get clickhouse distrib] ***************************************************************************************
    changed: [clickhouse-01]
    
    TASK [Install clickhouse packages] **********************************************************************************
    changed: [clickhouse-01]
    
    RUNNING HANDLER [Start clickhouse service] **************************************************************************
    changed: [clickhouse-01]
    
    PLAY [Create database Clickhouse] ***********************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Create database] **********************************************************************************************
    changed: [clickhouse-01]
    
    PLAY [Install vector] ***********************************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************
    ok: [vector-01]
    
    TASK [Install Vector] ***********************************************************************************************
    changed: [vector-01]
    
    TASK [Configure Service] ********************************************************************************************
    --- before
    +++ after: /root/.ansible/tmp/ansible-local-962412e_i2kko/tmpf4r4g2it/vector.service.j2
    @@ -0,0 +1,10 @@
    +[Unit]
    +Description=Vector Service
    +After=network.target
    +Requires=network-online.target
    +[Service]
    +User=root
    +Group=0
    +ExecStart=/usr/bin/vector --config-yaml /root/vector_config/vector.yml --watch-config true
    +Restart=always
    +WantedBy=multi-user.target%
    \ No newline at end of file
    
    changed: [vector-01]
    
    TASK [Configure Vector 1] *******************************************************************************************
    --- before
    +++ after
    @@ -1,5 +1,5 @@
     {
    -    "mode": "0755",
    +    "mode": "0644",
         "path": "/root/vector_config",
    -    "state": "absent"
    +    "state": "directory"
     }
    
    changed: [vector-01]
    
    TASK [Configure Vector 2] *******************************************************************************************
    --- before
    +++ after: /root/.ansible/tmp/ansible-local-962412e_i2kko/tmpvzzijmb_/vector.yml.j2
    @@ -0,0 +1,2 @@
    +---
    +null
    
    changed: [vector-01]
    
    RUNNING HANDLER [restart vector service] ****************************************************************************
    changed: [vector-01]
    
    PLAY RECAP **********************************************************************************************************
    clickhouse-01              : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
    vector-01                  : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
    ```
    root@server1:/vagrant/playbook82# ansible-playbook -i inventory/prod.yml --diff site.yml
    
    PLAY [Install Clickhouse] *******************************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Get clickhouse distrib] ***************************************************************************************
    ok: [clickhouse-01] => (item=clickhouse-client)
    ok: [clickhouse-01] => (item=clickhouse-server)
    failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}
    
    TASK [Get clickhouse distrib] ***************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Install clickhouse packages] **********************************************************************************
    ok: [clickhouse-01]
    
    PLAY [Create database Clickhouse] ***********************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Create database] **********************************************************************************************
    ok: [clickhouse-01]
    
    PLAY [Install vector] ***********************************************************************************************
    
    TASK [Gathering Facts] **********************************************************************************************
    ok: [vector-01]
    
    TASK [Install Vector] ***********************************************************************************************
    ok: [vector-01]
    
    TASK [Configure Service] ********************************************************************************************
    ok: [vector-01]
    
    TASK [Configure Vector 1] *******************************************************************************************
    ok: [vector-01]
    
    TASK [Configure Vector 2] *******************************************************************************************
    ok: [vector-01]
    
    PLAY RECAP **********************************************************************************************************
    clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
    vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

    Ссылка на [playbook](playbook)  
    Ссылка на [readme.md](playbook/readme.md)