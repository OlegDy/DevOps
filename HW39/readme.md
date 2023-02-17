## Домашнее задание 39 [8.5 Тестирование roles](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-05-testing)

### Олег Дьяченко DEVOPS-22

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`
2. Выполните `docker pull aragast/netology:latest` -  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. [вывод команды](out_clickhouse_centos_7.txt)
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
    ```
    root@server2:/vagrant/playbook85/roles/vector-role# molecule init scenario --driver-name docker
    INFO     Initializing new scenario default...
    INFO     Initialized scenario in /vagrant/playbook85/roles/vector-role/molecule/default successfully.
    ```
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.  
4. Добавьте несколько assert'ов в verify.yml файл для проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.  
   Пришлось помучиться все делал под centos7, а добавил centos8 и ubuntu перестало работать. Но домучал.  
   [Вывод команды](out_molecule_test.txt)
 
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.  
   [1.1.0](https://github.com/OlegDy/vector-role/commit/989b17d9d9d8b580f6668481016d78c0f79db91f)

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод. [Вывод команды tox](out_tox1)
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария [molecule](playbook/roles/vector-role/molecule) и один [tox.ini](playbook/roles/vector-role/tox.ini) файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания.   

   [Вывод команды tox](out_tox2)  

   [1.2.0](https://github.com/OlegDy/vector-role/commit/1db605d4bebe6de8e1f30bebec0734a6073fdf9c)  

   [tags](https://github.com/OlegDy/vector-role/tags)


