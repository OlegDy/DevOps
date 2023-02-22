## Домашнее задание 40 [8.6 Создание собственных модулей](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-06-module)

### Олег Дьяченко DEVOPS-22

## Подготовка к выполнению
1. Создайте пустой публичных репозиторий в любом своём проекте: `my_own_collection`
2. Скачайте репозиторий ansible: `git clone https://github.com/ansible/ansible.git` по любому удобному вам пути
3. Зайдите в директорию ansible: `cd ansible`
4. Создайте виртуальное окружение: `python3 -m venv venv`
5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении
6. Установите зависимости `pip install -r requirements.txt`
7. Запустить настройку окружения `. hacking/env-setup`
8. Если все шаги прошли успешно - выйти из виртуального окружения `deactivate`
9. Ваше окружение настроено, для того чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`

   ```
   ...
   Setting up Ansible to run out of checkout...
   
   PATH=/vagrant/playbook86/ansible/bin:/vagrant/playbook86/ansible/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
   PYTHONPATH=/vagrant/playbook86/ansible/test/lib:/vagrant/playbook86/ansible/lib
   MANPATH=/vagrant/playbook86/ansible/docs/man:/usr/local/man:/usr/local/share/man:/usr/share/man
   
   Remember, you may wish to specify your host file with -i
   
   Done!
   
   (venv) root@server2:/vagrant/playbook86/ansible# deactivate
   root@server2:/vagrant/playbook86/ansible#
   ```

## Основная часть

Наша цель - написать собственный module, который мы можем использовать в своей role, через playbook. Всё это должно быть собрано в виде collection и отправлено в наш репозиторий.

1. В виртуальном окружении создать новый `my_own_module.py` файл
2. Наполнить его содержимым
   
   Или возьмите данное наполнение из [статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).

3. Заполните файл в соответствии с требованиями ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.
4. Проверьте module на исполняемость локально.

   ```
   (venv) root@server2:/vagrant/playbook86/ansible# python -m ansible.modules.my_own_module args.json
   
   {"changed": true, "original_message": "/tmp/test.txt", "message": "/tmp/test.txt,test message!", "invocation": {"module_args": {"path": "/tmp/test.txt", "content": "test message"}}}
   (venv) root@server2:/vagrant/playbook86/ansible# python -m ansible.modules.my_own_module args.json
   
   {"changed": true, "original_message": "/tmp2/test.txt", "message": "/tmp2/test.txt,test message!", "failed": true, "msg": "No such directory", "invocation": {"module_args": {"path": "/tmp2/test.txt", "content": "test message"}}}
   ```

5. Напишите single task playbook и используйте module в нём.
6. Проверьте через playbook на идемпотентность.

   ```yml
   ---
   - name: Test module
     hosts: localhost
     tasks:
       - name: call my own module
         my_own_module:
           path: '/tmp/test_module.txt'
           content: 'hi, test OK'
   
   
   ```

   ```
   (venv) root@server2:/vagrant/playbook86/ansible# ansible-playbook site.yml -v
   [WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are
   modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can
   become unstable at any point.
   Using /etc/ansible/ansible.cfg as config file
   [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
   
   PLAY [Test module] *********************************************************************************************************
   
   TASK [Gathering Facts] *****************************************************************************************************
   ok: [localhost]
   
   TASK [call my own module] **************************************************************************************************
   changed: [localhost] => {"changed": true, "message": "/tmp/test_module.txt,hi, test OK!", "original_message": "/tmp/test_module.txt"}
   
   PLAY RECAP *****************************************************************************************************************
   localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ```

7. Выйдите из виртуального окружения.
8. Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`
9. В данную collection перенесите свой module в соответствующую директорию.
10. Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module
11. Создайте playbook для использования этой role.
12. Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.
13. Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.
14. Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.
15. Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`
16. Запустите playbook, убедитесь, что он работает.  

   Пока делал роль модуль ```my_own_module``` переименовал в ```create_file```. Описал в readme уже по новому.

   ```
   root@server2:/vagrant/playbook86/create_file# ansible-galaxy collection build
   Created collection for olegdy.my_own_collection at /vagrant/playbook86/create_file/olegdy-my_own_collection-1.0.0.tar.gz
   
   root@server2:/vagrant/playbook86/create_file# ansible-galaxy collection install olegdy-my_own_collection-1.0.0.tar.gz
   Starting galaxy collection install process
   Process install dependency map
   Starting collection install process
   Installing 'olegdy.my_own_collection:1.0.0' to '/root/.ansible/collections/ansible_collections/olegdy/my_own_collection'
   olegdy.my_own_collection:1.0.0 was installed successfully
   
   root@server2:/vagrant/playbook86/create_file# ansible-playbook site.yml -v
   Using /etc/ansible/ansible.cfg as config file
   [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
   
   PLAY [create file] **************************************************************************************************************************************************************************************************************************
   
   TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
   ok: [localhost]
   
   TASK [create_file : create file] ************************************************************************************************************************************************************************************************************
   changed: [localhost] => {"changed": true, "message": "/tmp/test.txt,Hi test OK!", "original_message": "/tmp/test.txt"}
   
   PLAY RECAP **********************************************************************************************************************************************************************************************************************************
   localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   
   ```

17. В ответ необходимо прислать ссылки на collection и tar.gz архив, а также скриншоты выполнения пунктов 4, 6, 15 и 16.

   [Коллекция, роль и архив](https://github.com/OlegDy/my_own_collection)

