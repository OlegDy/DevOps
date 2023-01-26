## Домашнее задание 35 [8.1 Введение в Ansible](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-01-base)

### Олег Дьяченко DEVOPS-22

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.  
   ```
   vagrant@server1:~$ ansible --version
   ansible [core 2.12.10]
   ```
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
   ```
   ansible-playbook site.yml -i inventory/test.yml
   
   TASK [Print fact] ******************************************************************************************************
   ok: [localhost] => {
       "msg": 12
   }
   ```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
    ```
    group_vars/all/examp.yml
    
    TASK [Print fact] ************************
    ok: [localhost] => {
        "msg": "all default fact"
    }
    ```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
   ```
   root@server1:/vagrant/playbook81# docker ps
   CONTAINER ID   IMAGE                      COMMAND           CREATED         STATUS         PORTS     NAMES
   2ffc9ab44892   pycontribs/ubuntu:latest   "sleep 6000000"   3 minutes ago   Up 3 minutes             ubuntu
   931f2b7023eb   pycontribs/centos:7        "sleep 6000000"   4 minutes ago   Up 4 minutes             centos7
   ```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
   ```
   TASK [Print fact] ******************
   ok: [centos7] => {
       "msg": "el"
   }
   ok: [ubuntu] => {
       "msg": "deb"
   }
   ```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
   ```
   TASK [Print fact] **********************
   ok: [centos7] => {
       "msg": "el default fact"
   }
   ok: [ubuntu] => {
       "msg": "deb default fact"
   }
   ```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
   ```
   root@server1:/vagrant/playbook81# ansible-vault encrypt group_vars/deb/*
   New Vault password:
   Confirm New Vault password:
   Encryption successful
   root@server1:/vagrant/playbook81# ansible-vault encrypt group_vars/el/*
   New Vault password:
   Confirm New Vault password:
   Encryption successful
   ```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
   ```
   root@server1:/vagrant/playbook81# ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
   Vault password:
   
   PLAY [Print os facts] ******************************************************************************
   
   TASK [Gathering Facts] *****************************************************************************
   ok: [ubuntu]
   ok: [centos7]
   ```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.  
   ```local execute on controller```
   ```
   root@server1:/vagrant/playbook81# ansible-doc -t connection -l ds
   [WARNING]: Collection ibm.qradar does not support Ansible version 2.12.10
   [WARNING]: Collection splunk.es does not support Ansible version 2.12.10
   [DEPRECATION WARNING]: ansible.netcommon.napalm has been deprecated. See the plugin documentation for more details. This feature will be
   removed from ansible.netcommon in a release after 2022-06-01. Deprecation warnings can be disabled by setting deprecation_warnings=False in
   ansible.cfg.
   ansible.netcommon.httpapi      Use httpapi to run command on network appliances
   ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection
   ansible.netcommon.napalm       Provides persistent connection using NAPALM
   ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol
   ansible.netcommon.network_cli  Use network_cli to run command on network appliances
   ansible.netcommon.persistent   Use a persistent unix socket for connection
   community.aws.aws_ssm          execute via AWS Systems Manager
   community.docker.docker        Run tasks in docker containers
   community.docker.docker_api    Run tasks in docker containers
   community.docker.nsenter       execute on host running controller container
   community.general.chroot       Interact with local chroot
   community.general.funcd        Use funcd to connect to target
   community.general.iocage       Run tasks in iocage jails
   community.general.jail         Run tasks in jails
   community.general.lxc          Run tasks in lxc containers via lxc python library
   community.general.lxd          Run tasks in lxc containers via lxc CLI
   community.general.qubes        Interact with an existing QubesOS AppVM
   community.general.saltstack    Allow ansible to piggyback on salt minions
   community.general.zone         Run tasks in a zone instance
   community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt
   community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines
   community.okd.oc               Execute tasks in pods running on OpenShift
   community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools
   community.zabbix.httpapi       Use httpapi to run command on network appliances
   containers.podman.buildah      Interact with an existing buildah container
   containers.podman.podman       Interact with an existing podman container
   kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes
   local                          execute on controller
   paramiko_ssh                   Run tasks via python ssh (paramiko)
   psrp                           Run tasks over Microsoft PowerShell Remoting Protocol
   ssh                            connect via SSH client binary
   winrm                          Run tasks over Microsoft's WinRM
   ```
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
   ```
   root@server1:/vagrant/playbook81/inventory# cat prod.yml
   ---
     el:
       hosts:
         centos7:
           ansible_connection: docker
     deb:
       hosts:
         ubuntu:
           ansible_connection: docker
     local:
       hosts:
         localhost:
           ansible_connection: local
   ```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
   ```
   root@server1:/vagrant/playbook81# ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
  
   TASK [Print fact] ***************************************************************************************************
   ok: [centos7] => {
       "msg": "el default fact"
   }
   ok: [ubuntu] => {
       "msg": "deb default fact"
   }
   ok: [localhost] => {
       "msg": "all default fact"
   }
   ```
   Добавил новую папку с фактами для группы local
   ```
   TASK [Print fact] *****************
   ok: [centos7] => {
       "msg": "el default fact"
   }
   ok: [ubuntu] => {
       "msg": "deb default fact"
   }
   ok: [localhost] => {
       "msg": "local default fact"
   }
   ```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.  
[playbook](playbook)


