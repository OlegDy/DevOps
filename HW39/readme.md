## Домашнее задание 39 [8.5 Тестирование roles](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-05-testing)

### Олег Дьяченко DEVOPS-22

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`
2. Выполните `docker pull aragast/netology:latest` -  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. 
   <details><summary>вывод команды</summary>
   
   ```
   root@server2:/vagrant/playbook84/roles/ansible-clickhouse# molecule test -s centos_7
   INFO     centos_7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
   INFO     Performing prerun...
   INFO     Using /root/.cache/roles/alexeysetevoi.clickhouse symlink to current repository in order to enable Ansible to find the role using its expected full name.
   INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/roles
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > dependency
   WARNING  Skipping, missing the requirements file.
   WARNING  Skipping, missing the requirements file.
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > lint
   INFO     Lint is disabled.
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > cleanup
   WARNING  Skipping, cleanup playbook not configured.
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > destroy
   INFO     Sanity checks: 'docker'
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item=centos_7)
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   ok: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '288285648643.59316', 'results_file': '/root/.ansible_async/288285648643.59316', 'changed': True, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
   
   TASK [Delete docker network(s)] ************************************************
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > syntax
   
   playbook: /vagrant/playbook84/roles/ansible-clickhouse/molecule/resources/playbooks/converge.yml
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > create
   
   PLAY [Create] ******************************************************************
   
   TASK [Log into a Docker registry] **********************************************
   skipping: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
   
   TASK [Check presence of custom Dockerfiles] ************************************
   ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
   
   TASK [Create Dockerfiles from image names] *************************************
   changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
   
   TASK [Discover local Docker images] ********************************************
   ok: [localhost] => (item={'diff': [], 'dest': '/root/.cache/molecule/ansible-clickhouse/centos_7/Dockerfile_centos_7', 'src': '/root/.ansible/tmp/ansible-tmp-1676519293.3898768-59417-139033268920639/source', 'md5sum': 'e90d08cd34f49a5f8a41a07de1348618', 'checksum': '4b70768619482424811f2977aa277a5acf2b13a1', 'changed': True, 'uid': 0, 'gid': 0, 'owner': 'root', 'group': 'root', 'mode': '0600', 'state': 'file', 'size': 2199, 'invocation': {'module_args': {'src': '/root/.ansible/tmp/ansible-tmp-1676519293.3898768-59417-139033268920639/source', 'dest': '/root/.cache/molecule/ansible-clickhouse/centos_7/Dockerfile_centos_7', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': '4b70768619482424811f2977aa277a5acf2b13a1', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
   
   TASK [Build an Ansible compatible image (new)] *********************************
   ok: [localhost] => (item=molecule_local/centos:7)
   
   TASK [Create docker network(s)] ************************************************
   
   TASK [Determine the CMD directives] ********************************************
   ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
   
   TASK [Create molecule instance(s)] *********************************************
   changed: [localhost] => (item=centos_7)
   
   TASK [Wait for instance(s) creation to complete] *******************************
   FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
   changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '593099343235.59565', 'results_file': '/root/.ansible_async/593099343235.59565', 'changed': True, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=7    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
   
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > prepare
   WARNING  Skipping, prepare playbook not configured.
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > converge
   
   PLAY [Converge] ****************************************************************
   
   TASK [Gathering Facts] *********************************************************
   ok: [centos_7]
   
   TASK [Apply Clickhouse Role] ***************************************************
   
   TASK [ansible-clickhouse : Include OS Family Specific Variables] ***************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/precheck.yml for centos_7
   
   TASK [ansible-clickhouse : Requirements check | Checking sse4_2 support] *******
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Requirements check | Not supported distribution && release] ***
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/params.yml for centos_7
   
   TASK [ansible-clickhouse : Set clickhouse_service_enable] **********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Set clickhouse_service_ensure] **********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/install/yum.yml for centos_7
   
   TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ***
   changed: [centos_7]
   
   TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse repo installed] ***
   --- before: /etc/yum.repos.d/clickhouse.repo
   +++ after: /etc/yum.repos.d/clickhouse.repo
   @@ -0,0 +1,8 @@
   +[clickhouse]
   +async = 1
   +baseurl = https://repo.clickhouse.tech/rpm/stable/x86_64/
   +enabled = 1
   +gpgcheck = 1
   +gpgkey = https://repo.clickhouse.tech//CLICKHOUSE-KEY.GPG
   +name = Clickhouse repo
   +
   
   changed: [centos_7]
   
   TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ***
   changed: [centos_7]
   
   TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] ***
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/configure/sys.yml for centos_7
   
   TASK [ansible-clickhouse : Check clickhouse config, data and logs] *************
   ok: [centos_7] => (item=/var/log/clickhouse-server)
   --- before
   +++ after
   @@ -1,4 +1,4 @@
    {
   -    "mode": "0700",
   +    "mode": "0770",
        "path": "/etc/clickhouse-server"
    }
   
   changed: [centos_7] => (item=/etc/clickhouse-server)
   --- before
   +++ after
   @@ -1,7 +1,7 @@
    {
   -    "group": 0,
   -    "mode": "0755",
   -    "owner": 0,
   +    "group": 996,
   +    "mode": "0770",
   +    "owner": 999,
        "path": "/var/lib/clickhouse/tmp/",
   -    "state": "absent"
   +    "state": "directory"
    }
   
   changed: [centos_7] => (item=/var/lib/clickhouse/tmp/)
   --- before
   +++ after
   @@ -1,4 +1,4 @@
    {
   -    "mode": "0700",
   +    "mode": "0770",
        "path": "/var/lib/clickhouse/"
    }
   
   changed: [centos_7] => (item=/var/lib/clickhouse/)
   
   TASK [ansible-clickhouse : Config | Create config.d folder] ********************
   --- before
   +++ after
   @@ -1,4 +1,4 @@
    {
   -    "mode": "0500",
   +    "mode": "0770",
        "path": "/etc/clickhouse-server/config.d"
    }
   
   changed: [centos_7]
   
   TASK [ansible-clickhouse : Config | Create users.d folder] *********************
   --- before
   +++ after
   @@ -1,4 +1,4 @@
    {
   -    "mode": "0500",
   +    "mode": "0770",
        "path": "/etc/clickhouse-server/users.d"
    }
   
   changed: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate system config] ********************
   --- before
   +++ after: /root/.ansible/tmp/ansible-local-59743agocdc3k/tmpzqc80ev8/config.j2
   @@ -0,0 +1,381 @@
   +<?xml version="1.0"?>
   +<!--
   + -
   + - Ansible managed: Do NOT edit this file manually!
   + -
   +-->
   +<clickhouse>
   +    <logger>
   +        <!-- Possible levels: https://github.com/pocoproject/poco/blob/develop/Foundation/include/Poco/Logger.h#L105 -->
   +        <level>trace</level>
   +        <log>/var/log/clickhouse-server/clickhouse-server.log</log>
   +        <errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>
   +        <size>1000M</size>
   +        <count>10</count>
   +    </logger>
   +
   +    <http_port>8123</http_port>
   +
   +    <tcp_port>9000</tcp_port>
   +
   +    <!-- Used with https_port and tcp_port_secure. Full ssl options list: https://github.com/ClickHouse-Extras/poco/blob/master/NetSSL_OpenSSL/include/Poco/Net/SSLManager.h#L71 -->
   +    <openSSL>
   +        <server> <!-- Used for https server AND secure tcp port -->
   +            <!-- openssl req -subj "/CN=localhost" -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/clickhouse-server/server.key -out /etc/clickhouse-server/server.crt -->
   +            <certificateFile>/etc/clickhouse-server/server.crt</certificateFile>
   +            <privateKeyFile>/etc/clickhouse-server/server.key</privateKeyFile>
   +            <!-- openssl dhparam -out /etc/clickhouse-server/dhparam.pem 4096 -->
   +            <dhParamsFile>/etc/clickhouse-server/dhparam.pem</dhParamsFile>
   +            <verificationMode>none</verificationMode>
   +            <loadDefaultCAFile>true</loadDefaultCAFile>
   +            <cacheSessions>true</cacheSessions>
   +            <disableProtocols>sslv2,sslv3</disableProtocols>
   +            <preferServerCiphers>true</preferServerCiphers>
   +        </server>
   +
   +        <client> <!-- Used for connecting to https dictionary source -->
   +            <loadDefaultCAFile>true</loadDefaultCAFile>
   +            <cacheSessions>true</cacheSessions>
   +            <disableProtocols>sslv2,sslv3</disableProtocols>
   +            <preferServerCiphers>true</preferServerCiphers>
   +            <!-- Use for self-signed: <verificationMode>none</verificationMode> -->
   +            <invalidCertificateHandler>
   +                <!-- Use for self-signed: <name>AcceptCertificateHandler</name> -->
   +                <name>RejectCertificateHandler</name>
   +            </invalidCertificateHandler>
   +        </client>
   +    </openSSL>
   +
   +    <!-- Default root page on http[s] server. For example load UI from https://tabix.io/ when opening http://localhost:8123 -->
   +    <!--
   +    <http_server_default_response><![CDATA[<html ng-app="SMI2"><head><base href="http://ui.tabix.io/"></head><body><div ui-view="" class="content-ui"></div><script src="http://loader.tabix.io/master.js"></script></body></html>]]></http_server_default_response>
   +    -->
   +
   +    <!-- Port for communication between replicas. Used for data exchange. -->
   +    <interserver_http_port>9009</interserver_http_port>
   +
   +
   +
   +    <!-- Hostname that is used by other replicas to request this server.
   +         If not specified, than it is determined analoguous to 'hostname -f' command.
   +         This setting could be used to switch replication to another network interface.
   +      -->
   +    <!--
   +    <interserver_http_host>example.clickhouse.com</interserver_http_host>
   +    -->
   +
   +    <!-- Listen specified host. use :: (wildcard IPv6 address), if you want to accept connections both with IPv4 and IPv6 from everywhere. -->
   +    <!-- <listen_host>::</listen_host> -->
   +    <!-- Same for hosts with disabled ipv6: -->
   +    <!-- <listen_host>0.0.0.0</listen_host> -->
   +    <listen_host>127.0.0.1</listen_host>
   +
   +    <max_connections>2048</max_connections>
   +    <keep_alive_timeout>3</keep_alive_timeout>
   +
   +    <!-- Maximum number of concurrent queries. -->
   +    <max_concurrent_queries>100</max_concurrent_queries>
   +
   +    <!-- Set limit on number of open files (default: maximum). This setting makes sense on Mac OS X because getrlimit() fails to retrieve
   +         correct maximum value. -->
   +    <!-- <max_open_files>262144</max_open_files> -->
   +
   +    <!-- Size of cache of uncompressed blocks of data, used in tables of MergeTree family.
   +         In bytes. Cache is single for server. Memory is allocated only on demand.
   +         Cache is used when 'use_uncompressed_cache' user setting turned on (off by default).
   +         Uncompressed cache is advantageous only for very short queries and in rare cases.
   +      -->
   +    <uncompressed_cache_size>8589934592</uncompressed_cache_size>
   +
   +    <!-- Approximate size of mark cache, used in tables of MergeTree family.
   +         In bytes. Cache is single for server. Memory is allocated only on demand.
   +         You should not lower this value.
   +      -->
   +    <mark_cache_size>5368709120</mark_cache_size>
   +
   +
   +    <!-- Path to data directory, with trailing slash. -->
   +    <path>/var/lib/clickhouse/</path>
   +
   +    <!-- Path to temporary data for processing hard queries. -->
   +    <tmp_path>/var/lib/clickhouse/tmp/</tmp_path>
   +
   +    <!-- Directory with user provided files that are accessible by 'file' table function. -->
   +    <user_files_path>/var/lib/clickhouse/user_files/</user_files_path>
   +
   +    <!-- Path to configuration file with users, access rights, profiles of settings, quotas. -->
   +    <users_config>users.xml</users_config>
   +
   +    <!-- Default profile of settings. -->
   +    <default_profile>default</default_profile>
   +
   +    <!-- System profile of settings. This settings are used by internal processes (Buffer storage, Distibuted DDL worker and so on). -->
   +    <!-- <system_profile>default</system_profile> -->
   +
   +    <!-- Default database. -->
   +    <default_database>default</default_database>
   +
   +    <!-- Server time zone could be set here.
   +
   +         Time zone is used when converting between String and DateTime types,
   +          when printing DateTime in text formats and parsing DateTime from text,
   +          it is used in date and time related functions, if specific time zone was not passed as an argument.
   +
   +         Time zone is specified as identifier from IANA time zone database, like UTC or Africa/Abidjan.
   +         If not specified, system time zone at server startup is used.
   +
   +         Please note, that server could display time zone alias instead of specified name.
   +         Example: W-SU is an alias for Europe/Moscow and Zulu is an alias for UTC.
   +    -->
   +    <!-- <timezone>Europe/Moscow</timezone> -->
   +
   +    <!-- You can specify umask here (see "man umask"). Server will apply it on startup.
   +         Number is always parsed as octal. Default umask is 027 (other users cannot read logs, data files, etc; group can only read).
   +    -->
   +    <!-- <umask>022</umask> -->
   +
   +    <!-- Perform mlockall after startup to lower first queries latency
   +          and to prevent clickhouse executable from being paged out under high IO load.
   +         Enabling this option is recommended but will lead to increased startup time for up to a few seconds.
   +    -->
   +    <mlock_executable>False</mlock_executable>
   +
   +    <!-- Configuration of clusters that could be used in Distributed tables.
   +         https://clickhouse.com/docs/en/engines/table-engines/special/distributed/
   +      -->
   +    <remote_servers incl="clickhouse_remote_servers" />
   +
   +
   +    <!-- If element has 'incl' attribute, then for it's value will be used corresponding substitution from another file.
   +         By default, path to file with substitutions is /etc/metrika.xml. It could be changed in config in 'include_from' element.
   +         Values for substitutions are specified in /clickhouse/name_of_substitution elements in that file.
   +      -->
   +
   +    <!-- ZooKeeper is used to store metadata about replicas, when using Replicated tables.
   +         Optional. If you don't use replicated tables, you could omit that.
   +
   +         See https://clickhouse.com/docs/en/engines/table-engines/mergetree-family/replication/
   +      -->
   +    <zookeeper incl="zookeeper-servers" optional="true" />
   +
   +    <!-- Substitutions for parameters of replicated tables.
   +          Optional. If you don't use replicated tables, you could omit that.
   +         See https://clickhouse.com/docs/en/engines/table-engines/mergetree-family/replication/#creating-replicated-tables
   +      -->
   +    <macros incl="macros" optional="true" />
   +
   +
   +    <!-- Reloading interval for embedded dictionaries, in seconds. Default: 3600. -->
   +    <builtin_dictionaries_reload_interval>3600</builtin_dictionaries_reload_interval>
   +
   +    <!-- If true, dictionaries are created lazily on first use. Otherwise they are initialised on server startup. Default: true -->
   +    <!-- See also: https://clickhouse.com/docs/en/operations/server-configuration-parameters/settings/#server_configuration_parameters-dictionaries_lazy_load -->
   +    <dictionaries_lazy_load>True</dictionaries_lazy_load>
   +
   +    <!-- Maximum session timeout, in seconds. Default: 3600. -->
   +    <max_session_timeout>3600</max_session_timeout>
   +
   +    <!-- Default session timeout, in seconds. Default: 60. -->
   +    <default_session_timeout>60</default_session_timeout>
   +
   +    <!-- Sending data to Graphite for monitoring. Several sections can be defined. -->
   +    <!--
   +        interval - send every X second
   +        root_path - prefix for keys
   +        hostname_in_path - append hostname to root_path (default = true)
   +        metrics - send data from table system.metrics
   +        events - send data from table system.events
   +        asynchronous_metrics - send data from table system.asynchronous_metrics
   +    -->
   +    <!--
   +    <graphite>
   +        <host>localhost</host>
   +        <port>42000</port>
   +        <timeout>0.1</timeout>
   +        <interval>60</interval>
   +        <root_path>one_min</root_path>
   +        <hostname_in_path>true</hostname_in_path>
   +
   +        <metrics>true</metrics>
   +        <events>true</events>
   +        <asynchronous_metrics>true</asynchronous_metrics>
   +    </graphite>
   +    <graphite>
   +        <host>localhost</host>
   +        <port>42000</port>
   +        <timeout>0.1</timeout>
   +        <interval>1</interval>
   +        <root_path>one_sec</root_path>
   +
   +        <metrics>true</metrics>
   +        <events>true</events>
   +        <asynchronous_metrics>false</asynchronous_metrics>
   +    </graphite>
   +    -->
   +
   +
   +    <!-- Query log. Used only for queries with setting log_queries = 1. -->
   +    <query_log>
   +        <!-- What table to insert data. If table is not exist, it will be created.
   +             When query log structure is changed after system update,
   +              then old table will be renamed and new table will be created automatically.
   +        -->
   +        <database>system</database>
   +        <table>query_log</table>
   +        <!--
   +            PARTITION BY expr https://clickhouse.com/docs/en/table_engines/mergetree-family/custom_partitioning_key/
   +            Example:
   +                event_date
   +                toMonday(event_date)
   +                toYYYYMM(event_date)
   +                toStartOfHour(event_time)
   +        -->
   +        <partition_by>toYYYYMM(event_date)</partition_by>
   +        <!-- Interval of flushing data. -->
   +        <flush_interval_milliseconds>7500</flush_interval_milliseconds>
   +    </query_log>
   +
   +    <!-- Query thread log. Has information about all threads participated in query execution.
   +         Used only for queries with setting log_query_threads = 1. -->
   +    <query_thread_log>
   +        <database>system</database>
   +        <table>query_thread_log</table>
   +        <partition_by>toYYYYMM(event_date)</partition_by>
   +        <flush_interval_milliseconds>7500</flush_interval_milliseconds>
   +    </query_thread_log>
   +
   +    <!-- Uncomment if use part log.
   +         Part log contains information about all actions with parts in MergeTree tables (creation, deletion, merges, downloads).
   +    <part_log>
   +        <database>system</database>
   +        <table>part_log</table>
   +        <flush_interval_milliseconds>7500</flush_interval_milliseconds>
   +    </part_log>
   +    -->
   +
   +
   +    <!-- Parameters for embedded dictionaries, used in Yandex.Metrica.
   +         See https://clickhouse.com/docs/en/dicts/internal_dicts/
   +    -->
   +
   +    <!-- Path to file with region hierarchy. -->
   +    <!-- <path_to_regions_hierarchy_file>/opt/geo/regions_hierarchy.txt</path_to_regions_hierarchy_file> -->
   +
   +    <!-- Path to directory with files containing names of regions -->
   +    <!-- <path_to_regions_names_files>/opt/geo/</path_to_regions_names_files> -->
   +
   +
   +    <!-- Configuration of external dictionaries. See:
   +         https://clickhouse.com/docs/en/sql-reference/dictionaries/external-dictionaries/external-dicts
   +    -->
   +    <dictionaries_config>*_dictionary.xml</dictionaries_config>
   +
   +    <!-- Uncomment if you want data to be compressed 30-100% better.
   +         Don't do that if you just started using ClickHouse.
   +      -->
   +    <compression incl="clickhouse_compression">
   +    <!--
   +        <!- - Set of variants. Checked in order. Last matching case wins. If nothing matches, lz4 will be used. - ->
   +        <case>
   +
   +            <!- - Conditions. All must be satisfied. Some conditions may be omitted. - ->
   +            <min_part_size>10000000000</min_part_size>        <!- - Min part size in bytes. - ->
   +            <min_part_size_ratio>0.01</min_part_size_ratio>   <!- - Min size of part relative to whole table size. - ->
   +
   +            <!- - What compression method to use. - ->
   +            <method>zstd</method>
   +        </case>
   +    -->
   +    </compression>
   +
   +    <!-- Allow to execute distributed DDL queries (CREATE, DROP, ALTER, RENAME) on cluster.
   +         Works only if ZooKeeper is enabled. Comment it if such functionality isn't required. -->
   +    <distributed_ddl>
   +        <!-- Path in ZooKeeper to queue with DDL queries -->
   +        <path>/clickhouse/task_queue/ddl</path>
   +
   +        <!-- Settings from this profile will be used to execute DDL queries -->
   +        <!-- <profile>default</profile> -->
   +    </distributed_ddl>
   +
   +    <!-- Settings to fine tune MergeTree tables. See documentation in source code, in MergeTreeSettings.h -->
   +        <merge_tree>
   +        </merge_tree>
   +
   +    <!-- Protection from accidental DROP.
   +         If size of a MergeTree table is greater than max_table_size_to_drop (in bytes) than table could not be dropped with any DROP query.
   +         If you want do delete one table and don't want to restart clickhouse-server, you could create special file <clickhouse-path>/flags/force_drop_table and make DROP once.
   +         By default max_table_size_to_drop is 50GB; max_table_size_to_drop=0 allows to DROP any tables.
   +         The same for max_partition_size_to_drop.
   +         Uncomment to disable protection.
   +    -->
   +    <!-- <max_table_size_to_drop>0</max_table_size_to_drop> -->
   +    <!-- <max_partition_size_to_drop>0</max_partition_size_to_drop> -->
   +
   +    <!-- Example of parameters for GraphiteMergeTree table engine -->
   +    <graphite_rollup_example>
   +        <pattern>
   +            <regexp>click_cost</regexp>
   +            <function>any</function>
   +            <retention>
   +                <age>0</age>
   +                <precision>3600</precision>
   +            </retention>
   +            <retention>
   +                <age>86400</age>
   +                <precision>60</precision>
   +            </retention>
   +        </pattern>
   +        <default>
   +            <function>max</function>
   +            <retention>
   +                <age>0</age>
   +                <precision>60</precision>
   +            </retention>
   +            <retention>
   +                <age>3600</age>
   +                <precision>300</precision>
   +            </retention>
   +            <retention>
   +                <age>86400</age>
   +                <precision>3600</precision>
   +            </retention>
   +        </default>
   +    </graphite_rollup_example>
   +
   +
   +    <!-- Exposing metrics data for scraping from Prometheus. -->
   +    <!--
   +        endpoint – HTTP endpoint for scraping metrics by prometheus server. Start from ‘/’.
   +        port – Port for endpoint.
   +        metrics – Flag that sets to expose metrics from the system.metrics table.
   +        events – Flag that sets to expose metrics from the system.events table.
   +        asynchronous_metrics – Flag that sets to expose current metrics values from the system.asynchronous_metrics table.
   +    -->
   +    <!--
   +    <prometheus>
   +        <endpoint>/metrics</endpoint>
   +        <port>8001</port>
   +        <metrics>true</metrics>
   +        <events>true</events>
   +        <asynchronous_metrics>true</asynchronous_metrics>
   +    </prometheus>
   +    -->
   +
   +
   +    <!-- Directory in <clickhouse-path> containing schema files for various input formats.
   +         The directory will be created if it doesn't exist.
   +      -->
   +    <format_schema_path>/var/lib/clickhouse//format_schemas/</format_schema_path>
   +
   +    <!-- Uncomment to disable ClickHouse internal DNS caching. -->
   +    <!-- <disable_internal_dns_cache>1</disable_internal_dns_cache> -->
   +
   +    <kafka>
   +    </kafka>
   +
   +
   +
   +
   +
   +</clickhouse>
   
   changed: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate users config] *********************
   --- before
   +++ after: /root/.ansible/tmp/ansible-local-59743agocdc3k/tmpppp9x20w/users.j2
   @@ -0,0 +1,106 @@
   +<?xml version="1.0"?>
   +<!--
   + -
   + - Ansible managed: Do NOT edit this file manually!
   + -
   +-->
   +<clickhouse>
   +   <profiles>
   +    <!-- Profiles of settings. -->
   +    <!-- Default profiles. -->
   +        <default>
   +            <max_memory_usage>10000000000</max_memory_usage>
   +            <use_uncompressed_cache>0</use_uncompressed_cache>
   +            <load_balancing>random</load_balancing>
   +            <max_partitions_per_insert_block>100</max_partitions_per_insert_block>
   +        </default>
   +        <readonly>
   +            <readonly>1</readonly>
   +        </readonly>
   +        <!-- Default profiles end. -->
   +    <!-- Custom profiles. -->
   +        <!-- Custom profiles end. -->
   +    </profiles>
   +
   +    <!-- Users and ACL. -->
   +    <users>
   +    <!-- Default users. -->
   +            <!-- Default user for login if user not defined -->
   +        <default>
   +                <password></password>
   +                <networks incl="networks" replace="replace">
   +                <ip>::1</ip>
   +                <ip>127.0.0.1</ip>
   +                </networks>
   +        <profile>default</profile>
   +        <quota>default</quota>
   +            </default>
   +            <!-- Example of user with readonly access -->
   +        <readonly>
   +                <password></password>
   +                <networks incl="networks" replace="replace">
   +                <ip>::1</ip>
   +                <ip>127.0.0.1</ip>
   +                </networks>
   +        <profile>readonly</profile>
   +        <quota>default</quota>
   +            </readonly>
   +        <!-- Custom users. -->
   +            <!-- classic user with plain password -->
   +        <testuser>
   +                <password_sha256_hex>f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2</password_sha256_hex>
   +                <networks incl="networks" replace="replace">
   +                <ip>::1</ip>
   +                <ip>127.0.0.1</ip>
   +                </networks>
   +        <profile>default</profile>
   +        <quota>default</quota>
   +                 <allow_databases>
   +                    <database>testu1</database>
   +                </allow_databases>
   +                            </testuser>
   +            <!-- classic user with hex password -->
   +        <testuser2>
   +                <password>testplpassword</password>
   +                <networks incl="networks" replace="replace">
   +                <ip>::1</ip>
   +                <ip>127.0.0.1</ip>
   +                </networks>
   +        <profile>default</profile>
   +        <quota>default</quota>
   +                 <allow_databases>
   +                    <database>testu2</database>
   +                </allow_databases>
   +                            </testuser2>
   +            <!-- classic user with multi dbs and multi-custom network allow password -->
   +        <testuser3>
   +                <password>testplpassword</password>
   +                <networks incl="networks" replace="replace">
   +                <ip>192.168.0.0/24</ip>
   +                <ip>10.0.0.0/8</ip>
   +                </networks>
   +        <profile>default</profile>
   +        <quota>default</quota>
   +                 <allow_databases>
   +                    <database>testu1</database>
   +                    <database>testu2</database>
   +                    <database>testu3</database>
   +                </allow_databases>
   +                            </testuser3>
   +        </users>
   +
   +    <!-- Quotas. -->
   +    <quotas>
   +        <!-- Default quotas. -->
   +        <default>
   +        <interval>
   +        <duration>3600</duration>
   +        <queries>0</queries>
   +        <errors>0</errors>
   +        <result_rows>0</result_rows>
   +        <read_rows>0</read_rows>
   +        <execution_time>0</execution_time>
   +    </interval>
   +        </default>
   +            </quotas>
   +</clickhouse>
   
   changed: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate remote_servers config] ************
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate macros config] ********************
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate zookeeper servers config] *********
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] ***
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : Notify Handlers Now] ********************************
   
   RUNNING HANDLER [ansible-clickhouse : Restart Clickhouse Service] **************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/service.yml for centos_7
   
   TASK [ansible-clickhouse : Ensure clickhouse-server.service is enabled: True and state: restarted] ***
   changed: [centos_7]
   
   TASK [ansible-clickhouse : Wait for Clickhouse Server to Become Ready] *********
   ok: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/configure/db.yml for centos_7
   
   TASK [ansible-clickhouse : Set ClickHose Connection String] ********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Gather list of existing databases] ******************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Config | Delete database config] ********************
   skipping: [centos_7] => (item={'name': 'testu1'})
   skipping: [centos_7] => (item={'name': 'testu2'})
   skipping: [centos_7] => (item={'name': 'testu3'})
   skipping: [centos_7] => (item={'name': 'testu4', 'state': 'absent'})
   
   TASK [ansible-clickhouse : Config | Create database config] ********************
   changed: [centos_7] => (item={'name': 'testu1'})
   changed: [centos_7] => (item={'name': 'testu2'})
   changed: [centos_7] => (item={'name': 'testu3'})
   skipping: [centos_7] => (item={'name': 'testu4', 'state': 'absent'})
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/configure/dict.yml for centos_7
   
   TASK [ansible-clickhouse : Config | Generate dictionary config] ****************
   --- before
   +++ after: /root/.ansible/tmp/ansible-local-59743agocdc3k/tmp___2d7v7/dicts.j2
   @@ -0,0 +1,63 @@
   +<?xml version="1.0"?>
   +<!--
   + -
   + - Ansible managed: Do NOT edit this file manually!
   + -
   +-->
   +<clickhouse>
   + <dictionary>
   +   <name>test_dict</name>
   +   <source>
   +    <odbc>
   +     <connection_string>DSN=testdb</connection_string>
   +     <table>dict_source</table>
   +    </odbc>
   +   </source>
   +   <lifetime>
   +     <min>300</min>
   +     <max>360</max>
   +   </lifetime>
   +   <layout>
   +     <hashed/>
   +   </layout>
   +   <structure>
   +     <id>
   +       <name>testIntKey</name>
   +     </id>
   +     <attribute>
   +       <name>testAttrName</name>
   +       <type>UInt32</type>
   +       <null_value>0</null_value>
   +     </attribute>
   +   </structure>
   + </dictionary>
   + <dictionary>
   +   <name>test_dict</name>
   +   <source>
   +    <odbc>
   +     <connection_string>DSN=testdb</connection_string>
   +     <table>dict_source</table>
   +    </odbc>
   +   </source>
   +   <lifetime>
   +     <min>300</min>
   +     <max>360</max>
   +   </lifetime>
   +   <layout>
   +     <complex_key_hashed/>
   +   </layout>
   +   <structure>
   +     <key>
   +     <attribute>
   +       <name>testAttrComplexName</name>
   +       <type>String</type>
   +     </attribute>
   +     </key>
   +     <attribute>
   +       <name>testAttrName</name>
   +       <type>String</type>
   +       <null_value></null_value>
   +     </attribute>
   +   </structure>
   + </dictionary>
   +</clickhouse>
   
   changed: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   skipping: [centos_7]
   
   PLAY RECAP *********************************************************************
   centos_7                   : ok=27   changed=11   unreachable=0    failed=0    skipped=8    rescued=0    ignored=0
   
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > idempotence
   
   PLAY [Converge] ****************************************************************
   
   TASK [Gathering Facts] *********************************************************
   ok: [centos_7]
   
   TASK [Apply Clickhouse Role] ***************************************************
   
   TASK [ansible-clickhouse : Include OS Family Specific Variables] ***************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/precheck.yml for centos_7
   
   TASK [ansible-clickhouse : Requirements check | Checking sse4_2 support] *******
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Requirements check | Not supported distribution && release] ***
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/params.yml for centos_7
   
   TASK [ansible-clickhouse : Set clickhouse_service_enable] **********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Set clickhouse_service_ensure] **********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/install/yum.yml for centos_7
   
   TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ***
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse repo installed] ***
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ***
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] ***
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/configure/sys.yml for centos_7
   
   TASK [ansible-clickhouse : Check clickhouse config, data and logs] *************
   ok: [centos_7] => (item=/var/log/clickhouse-server)
   ok: [centos_7] => (item=/etc/clickhouse-server)
   ok: [centos_7] => (item=/var/lib/clickhouse/tmp/)
   ok: [centos_7] => (item=/var/lib/clickhouse/)
   
   TASK [ansible-clickhouse : Config | Create config.d folder] ********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Config | Create users.d folder] *********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate system config] ********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate users config] *********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate remote_servers config] ************
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate macros config] ********************
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : Config | Generate zookeeper servers config] *********
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] ***
   skipping: [centos_7]
   
   TASK [ansible-clickhouse : Notify Handlers Now] ********************************
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/service.yml for centos_7
   
   TASK [ansible-clickhouse : Ensure clickhouse-server.service is enabled: True and state: started] ***
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Wait for Clickhouse Server to Become Ready] *********
   ok: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/configure/db.yml for centos_7
   
   TASK [ansible-clickhouse : Set ClickHose Connection String] ********************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Gather list of existing databases] ******************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : Config | Delete database config] ********************
   skipping: [centos_7] => (item={'name': 'testu1'})
   skipping: [centos_7] => (item={'name': 'testu2'})
   skipping: [centos_7] => (item={'name': 'testu3'})
   skipping: [centos_7] => (item={'name': 'testu4', 'state': 'absent'})
   
   TASK [ansible-clickhouse : Config | Create database config] ********************
   skipping: [centos_7] => (item={'name': 'testu1'})
   skipping: [centos_7] => (item={'name': 'testu2'})
   skipping: [centos_7] => (item={'name': 'testu3'})
   skipping: [centos_7] => (item={'name': 'testu4', 'state': 'absent'})
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   included: /vagrant/playbook84/roles/ansible-clickhouse/tasks/configure/dict.yml for centos_7
   
   TASK [ansible-clickhouse : Config | Generate dictionary config] ****************
   ok: [centos_7]
   
   TASK [ansible-clickhouse : include_tasks] **************************************
   skipping: [centos_7]
   
   PLAY RECAP *********************************************************************
   centos_7                   : ok=25   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0
   
   INFO     Idempotence completed successfully.
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > side_effect
   WARNING  Skipping, side effect playbook not configured.
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > verify
   INFO     Running Ansible Verifier
   
   PLAY [Verify] ******************************************************************
   
   TASK [Example assertion] *******************************************************
   ok: [centos_7] => {
       "changed": false,
       "msg": "All assertions passed"
   }
   
   PLAY RECAP *********************************************************************
   centos_7                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   
   INFO     Verifier completed successfully.
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > cleanup
   WARNING  Skipping, cleanup playbook not configured.
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/hosts
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/group_vars
   INFO     Inventory /vagrant/playbook84/roles/ansible-clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /root/.cache/molecule/ansible-clickhouse/centos_7/inventory/host_vars
   INFO     Running centos_7 > destroy
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item=centos_7)
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
   changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '296088308169.72975', 'results_file': '/root/.ansible_async/296088308169.72975', 'changed': True, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
   
   TASK [Delete docker network(s)] ************************************************
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Pruning extra files from scenario ephemeral directory
   ```
   
   </details>


2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
    ```
    root@server2:/vagrant/playbook85/roles/vector-role# molecule init scenario --driver-name docker
    INFO     Initializing new scenario default...
    INFO     Initialized scenario in /vagrant/playbook85/roles/vector-role/molecule/default successfully.
    ```
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.  
4. Добавьте несколько assert'ов в verify.yml файл для проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.      
   
   Пришлось помучиться все делал под centos7, а добавил centos8 и ubuntu перестало работать. Но домучал.  
 
   <details><summary>Вывод команды</summary>

   ```
   root@server2:/vagrant/playbook85/roles/vector-role# molecule test
   INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
   INFO     Performing prerun...
   WARNING  Computed fully qualified role name of vector-role does not follow current galaxy requirements.
   Please edit meta/main.yml and assure we can correctly determine full role name:
   
   galaxy_info:
   role_name: my_name  # if absent directory name hosting role is used instead
   namespace: my_galaxy_namespace  # if absent, author is used instead
   
   Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
   Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names
   
   As an alternative, you can add 'role-name' to either skip_list or warn_list.
   
   INFO     Using /root/.cache/roles/vector-role symlink to current repository in order to enable Ansible to find the role using its expected full name.
   INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/roles
   INFO     Running default > dependency
   WARNING  Skipping, missing the requirements file.
   WARNING  Skipping, missing the requirements file.
   INFO     Running default > lint
   INFO     Lint is disabled.
   INFO     Running default > cleanup
   WARNING  Skipping, cleanup playbook not configured.
   INFO     Running default > destroy
   INFO     Sanity checks: 'docker'
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item=centos7)
   changed: [localhost] => (item=centos8)
   changed: [localhost] => (item=ubuntu)
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   ok: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '659220666328.115300', 'results_file': '/root/.ansible_async/659220666328.115300', 'changed': True, 'item': {'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:7', 'name': 'centos7', 'privileged': True}, 'ansible_loop_var': 'item'})
   ok: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '618229273212.115327', 'results_file': '/root/.ansible_async/618229273212.115327', 'changed': True, 'item': {'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:8', 'name': 'centos8', 'privileged': True}, 'ansible_loop_var': 'item'})
   ok: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '668385205579.115367', 'results_file': '/root/.ansible_async/668385205579.115367', 'changed': True, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'ubuntu:focal', 'name': 'ubuntu', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
   
   TASK [Delete docker network(s)] ************************************************
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Running default > syntax
   
   playbook: /vagrant/playbook85/roles/vector-role/molecule/default/converge.yml
   INFO     Running default > create
   
   PLAY [Create] ******************************************************************
   
   TASK [Log into a Docker registry] **********************************************
   skipping: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:7', 'name': 'centos7', 'privileged': True})
   skipping: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:8', 'name': 'centos8', 'privileged': True})
   skipping: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'ubuntu:focal', 'name': 'ubuntu', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
   
   TASK [Check presence of custom Dockerfiles] ************************************
   ok: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:7', 'name': 'centos7', 'privileged': True})
   ok: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:8', 'name': 'centos8', 'privileged': True})
   ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'ubuntu:focal', 'name': 'ubuntu', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
   
   TASK [Create Dockerfiles from image names] *************************************
   changed: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:7', 'name': 'centos7', 'privileged': True})
   changed: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:8', 'name': 'centos8', 'privileged': True})
   changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'ubuntu:focal', 'name': 'ubuntu', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
   
   TASK [Discover local Docker images] ********************************************
   ok: [localhost] => (item={'diff': [], 'dest': '/root/.cache/molecule/vector-role/default/Dockerfile_centos_7', 'src': '/root/.ansible/tmp/ansible-tmp-1676598225.6314383-115587-88398094932818/source', 'md5sum': 'fd341b6280f87a872bf8890df5c0bc92', 'checksum': '233a8b9aa85a4fe93b09e62ce108520490ad00e9', 'changed': True, 'uid': 0, 'gid': 0, 'owner': 'root', 'group': 'root', 'mode': '0600', 'state': 'file', 'size': 3648, 'invocation': {'module_args': {'src': '/root/.ansible/tmp/ansible-tmp-1676598225.6314383-115587-88398094932818/source', 'dest': '/root/.cache/molecule/vector-role/default/Dockerfile_centos_7', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': '233a8b9aa85a4fe93b09e62ce108520490ad00e9', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:7', 'name': 'centos7', 'privileged': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
   ok: [localhost] => (item={'diff': [], 'dest': '/root/.cache/molecule/vector-role/default/Dockerfile_centos_8', 'src': '/root/.ansible/tmp/ansible-tmp-1676598225.9664147-115587-217942188285527/source', 'md5sum': '1971c75923921dda4956df46c7fc61ce', 'checksum': '68cb441e1c731de4a0b9f9c093eaa6faccd7a333', 'changed': True, 'uid': 0, 'gid': 0, 'owner': 'root', 'group': 'root', 'mode': '0600', 'state': 'file', 'size': 3648, 'invocation': {'module_args': {'src': '/root/.ansible/tmp/ansible-tmp-1676598225.9664147-115587-217942188285527/source', 'dest': '/root/.cache/molecule/vector-role/default/Dockerfile_centos_8', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': '68cb441e1c731de4a0b9f9c093eaa6faccd7a333', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:8', 'name': 'centos8', 'privileged': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
   ok: [localhost] => (item={'diff': [], 'dest': '/root/.cache/molecule/vector-role/default/Dockerfile_ubuntu_focal', 'src': '/root/.ansible/tmp/ansible-tmp-1676598226.2221682-115587-245985834750769/source', 'md5sum': 'b4a918fa72ee5c0f06ad8874732cc36b', 'checksum': 'b4ca383a98d11113e5527d880ec6454d6048ca64', 'changed': True, 'uid': 0, 'gid': 0, 'owner': 'root', 'group': 'root', 'mode': '0600', 'state': 'file', 'size': 3744, 'invocation': {'module_args': {'src': '/root/.ansible/tmp/ansible-tmp-1676598226.2221682-115587-245985834750769/source', 'dest': '/root/.cache/molecule/vector-role/default/Dockerfile_ubuntu_focal', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': 'b4ca383a98d11113e5527d880ec6454d6048ca64', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'ubuntu:focal', 'name': 'ubuntu', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})
   
   TASK [Build an Ansible compatible image (new)] *********************************
   ok: [localhost] => (item=molecule_local/centos:7)
   ok: [localhost] => (item=molecule_local/centos:8)
   ok: [localhost] => (item=molecule_local/ubuntu:focal)
   
   TASK [Create docker network(s)] ************************************************
   
   TASK [Determine the CMD directives] ********************************************
   ok: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:7', 'name': 'centos7', 'privileged': True})
   ok: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:8', 'name': 'centos8', 'privileged': True})
   ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'ubuntu:focal', 'name': 'ubuntu', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
   
   TASK [Create molecule instance(s)] *********************************************
   changed: [localhost] => (item=centos7)
   changed: [localhost] => (item=centos8)
   changed: [localhost] => (item=ubuntu)
   
   TASK [Wait for instance(s) creation to complete] *******************************
   changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '45319886247.115972', 'results_file': '/root/.ansible_async/45319886247.115972', 'changed': True, 'item': {'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:7', 'name': 'centos7', 'privileged': True}, 'ansible_loop_var': 'item'})
   FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
   changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '24563252536.116000', 'results_file': '/root/.ansible_async/24563252536.116000', 'changed': True, 'item': {'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:8', 'name': 'centos8', 'privileged': True}, 'ansible_loop_var': 'item'})
   changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '641180567606.116039', 'results_file': '/root/.ansible_async/641180567606.116039', 'changed': True, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'ubuntu:focal', 'name': 'ubuntu', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=7    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
   
   INFO     Running default > prepare
   WARNING  Skipping, prepare playbook not configured.
   INFO     Running default > converge
   
   PLAY [Converge] ****************************************************************
   
   TASK [Gathering Facts] *********************************************************
   ok: [centos8]
   ok: [ubuntu]
   ok: [centos7]
   
   TASK [Include vector-role] *****************************************************
   
   TASK [vector-role : Install Vector yum] ****************************************
   skipping: [ubuntu]
   changed: [centos7]
   changed: [centos8]
   
   TASK [vector-role : Install Vector apt] ****************************************
   skipping: [centos7]
   skipping: [centos8]
   changed: [ubuntu]
   
   TASK [vector-role : Configure Service] *****************************************
   changed: [centos7]
   changed: [ubuntu]
   changed: [centos8]
   
   TASK [vector-role : Configure Vector 1] ****************************************
   changed: [centos7]
   changed: [centos8]
   changed: [ubuntu]
   
   TASK [vector-role : Configure Vector 2] ****************************************
   changed: [centos7]
   changed: [ubuntu]
   changed: [centos8]
   
   RUNNING HANDLER [vector-role : restart vector service] *************************
   changed: [ubuntu]
   changed: [centos8]
   changed: [centos7]
   
   PLAY RECAP *********************************************************************
   centos7                    : ok=6    changed=5    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   centos8                    : ok=6    changed=5    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   ubuntu                     : ok=6    changed=5    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Running default > idempotence
   
   PLAY [Converge] ****************************************************************
   
   TASK [Gathering Facts] *********************************************************
   ok: [ubuntu]
   ok: [centos8]
   ok: [centos7]
   
   TASK [Include vector-role] *****************************************************
   
   TASK [vector-role : Install Vector yum] ****************************************
   skipping: [ubuntu]
   ok: [centos7]
   ok: [centos8]
   
   TASK [vector-role : Install Vector apt] ****************************************
   skipping: [centos7]
   skipping: [centos8]
   ok: [ubuntu]
   
   TASK [vector-role : Configure Service] *****************************************
   ok: [centos7]
   ok: [ubuntu]
   ok: [centos8]
   
   TASK [vector-role : Configure Vector 1] ****************************************
   ok: [centos7]
   ok: [centos8]
   ok: [ubuntu]
   
   TASK [vector-role : Configure Vector 2] ****************************************
   ok: [centos7]
   ok: [centos8]
   ok: [ubuntu]
   
   PLAY RECAP *********************************************************************
   centos7                    : ok=5    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   centos8                    : ok=5    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   ubuntu                     : ok=5    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Idempotence completed successfully.
   INFO     Running default > side_effect
   WARNING  Skipping, side effect playbook not configured.
   INFO     Running default > verify
   INFO     Running Ansible Verifier
   
   PLAY [Verify] ******************************************************************
   
   TASK [Gathering Facts] *********************************************************
   ok: [ubuntu]
   ok: [centos8]
   ok: [centos7]
   
   TASK [verify vector is started] ************************************************
   changed: [centos8]
   changed: [ubuntu]
   changed: [centos7]
   
   PLAY RECAP *********************************************************************
   centos7                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   centos8                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ubuntu                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   
   INFO     Verifier completed successfully.
   INFO     Running default > cleanup
   WARNING  Skipping, cleanup playbook not configured.
   INFO     Running default > destroy
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item=centos7)
   changed: [localhost] => (item=centos8)
   changed: [localhost] => (item=ubuntu)
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '584078743386.129891', 'results_file': '/root/.ansible_async/584078743386.129891', 'changed': True, 'item': {'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:7', 'name': 'centos7', 'privileged': True}, 'ansible_loop_var': 'item'})
   changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '166731751119.129918', 'results_file': '/root/.ansible_async/166731751119.129918', 'changed': True, 'item': {'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'centos:8', 'name': 'centos8', 'privileged': True}, 'ansible_loop_var': 'item'})
   changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '543244992803.129965', 'results_file': '/root/.ansible_async/543244992803.129965', 'changed': True, 'item': {'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'sudo', 'container': 'docker'}, 'image': 'ubuntu:focal', 'name': 'ubuntu', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
   
   TASK [Delete docker network(s)] ************************************************
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Pruning extra files from scenario ephemeral directory
   ```
   </details>
   
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.  
   [1.1.0](https://github.com/OlegDy/vector-role/commit/989b17d9d9d8b580f6668481016d78c0f79db91f)

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод. 
   <details><summary>Вывод команды tox</summary>

   ```
   [root@8c947c5f773a vector-role]# tox
   py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
   py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
   py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.1,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.0.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.1.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.3.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.1,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.13.0
   py37-ansible210 run-test-pre: PYTHONHASHSEED='111927430'
   py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
   CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
   ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
   py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
   py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
   py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.1,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.0.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.1.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.3.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.1,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.13.0
   py37-ansible30 run-test-pre: PYTHONHASHSEED='111927430'
   py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
   CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
   ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
   py39-ansible210 create: /opt/vector-role/.tox/py39-ansible210
   py39-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
   py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==3.0.1,ansible-core==2.14.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.1,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,markdown-it-py==2.1.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==8.0.0,PyYAML==5.4.1,requests==2.28.2,resolvelib==0.8.1,rich==13.3.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.1,text-unidecode==1.3,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3
   py39-ansible210 run-test-pre: PYTHONHASHSEED='111927430'
   py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
   CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
   ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
   py39-ansible30 create: /opt/vector-role/.tox/py39-ansible30
   py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
   py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==3.0.1,ansible-core==2.14.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.1,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,markdown-it-py==2.1.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==8.0.0,PyYAML==5.4.1,requests==2.28.2,resolvelib==0.8.1,rich==13.3.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.1,text-unidecode==1.3,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3
   py39-ansible30 run-test-pre: PYTHONHASHSEED='111927430'
   py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
   CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
   ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
   __________________________________________________________________________________________________________________ summary __________________________________________________________________________________________________________________
   ERROR:   py37-ansible210: commands failed
   ERROR:   py37-ansible30: commands failed
   ERROR:   py39-ansible210: commands failed
   ERROR:   py39-ansible30: commands failed  
   ```
   </details>

5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария [molecule](playbook/roles/vector-role/molecule) и один [tox.ini](playbook/roles/vector-role/tox.ini) файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания.   

  <details><summary>Вывод команды tox</summary>

   ```
   [root@314bc3e674b1 vector-role]# tox
   py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.1,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.0.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.1.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.3.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.1,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.13.0
   py37-ansible210 run-test-pre: PYTHONHASHSEED='1855274039'
   py37-ansible210 run-test: commands[0] | molecule test -s light_for_tox --destroy always
   INFO     light_for_tox scenario test matrix: destroy, create, converge, idempotence, destroy
   INFO     Performing prerun...
   WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git': 'git'
   INFO     Guessed /opt/vector-role as project root directory
   WARNING  Computed fully qualified role name of vector-role does not follow current galaxy requirements.
   Please edit meta/main.yml and assure we can correctly determine full role name:
   
   galaxy_info:
   role_name: my_name  # if absent directory name hosting role is used instead
   namespace: my_galaxy_namespace  # if absent, author is used instead
   
   Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
   Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names
   
   As an alternative, you can add 'role-name' to either skip_list or warn_list.
   
   INFO     Using /root/.cache/ansible-lint/b984a4/roles/vector-role symlink to current repository in order to enable Ansible to find the role using its expected full name.
   INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
   INFO     Running light_for_tox > destroy
   INFO     Sanity checks: 'podman'
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item={'command': '/usr/sbin/init', 'image': 'centos:7', 'name': 'centos7', 'privileged': True})
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '925612226219.3217', 'results_file': '/root/.ansible_async/925612226219.3217', 'changed': True, 'failed': False, 'item': {'command': '/usr/sbin/init', 'image': 'centos:7', 'name': 'centos7', 'privileged': True}, 'ansible_loop_var': 'item'})
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   
   INFO     Running light_for_tox > create
   
   PLAY [Create] ******************************************************************
   
   TASK [get podman executable path] **********************************************
   ok: [localhost]
   
   TASK [save path to executable as fact] *****************************************
   ok: [localhost]
   
   TASK [Log into a container registry] *******************************************
   skipping: [localhost] => (item="centos7 registry username: None specified")
   
   TASK [Check presence of custom Dockerfiles] ************************************
   ok: [localhost] => (item=Dockerfile: None specified)
   
   TASK [Create Dockerfiles from image names] *************************************
   changed: [localhost] => (item="Dockerfile: None specified; Image: centos:7")
   
   TASK [Discover local Podman images] ********************************************
   ok: [localhost] => (item=centos7)
   
   TASK [Build an Ansible compatible image] ***************************************
   changed: [localhost] => (item=centos:7)
   
   TASK [Determine the CMD directives] ********************************************
   ok: [localhost] => (item="centos7 command: /usr/sbin/init")
   
   TASK [Remove possible pre-existing containers] *********************************
   changed: [localhost]
   
   TASK [Discover local podman networks] ******************************************
   skipping: [localhost] => (item=centos7: None specified)
   
   TASK [Create podman network dedicated to this scenario] ************************
   skipping: [localhost]
   
   TASK [Create molecule instance(s)] *********************************************
   changed: [localhost] => (item=centos7)
   
   TASK [Wait for instance(s) creation to complete] *******************************
   changed: [localhost] => (item=centos7)
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=10   changed=5    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
   
   INFO     Running light_for_tox > converge
   
   PLAY [Converge] ****************************************************************
   
   TASK [Gathering Facts] *********************************************************
   ok: [centos7]
   
   TASK [Include vector-role] *****************************************************
   
   TASK [vector-role : Install Vector yum] ****************************************
   changed: [centos7]
   
   TASK [vector-role : Install Vector apt] ****************************************
   skipping: [centos7]
   
   TASK [vector-role : Configure Service] *****************************************
   changed: [centos7]
   
   TASK [vector-role : Configure Vector 1] ****************************************
   changed: [centos7]
   
   TASK [vector-role : Configure Vector 2] ****************************************
   changed: [centos7]
   
   RUNNING HANDLER [vector-role : restart vector service] *************************
   changed: [centos7]
   
   PLAY RECAP *********************************************************************
   centos7                    : ok=6    changed=5    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Running light_for_tox > idempotence
   
   PLAY [Converge] ****************************************************************
   
   TASK [Gathering Facts] *********************************************************
   ok: [centos7]
   
   TASK [Include vector-role] *****************************************************
   
   TASK [vector-role : Install Vector yum] ****************************************
   ok: [centos7]
   
   TASK [vector-role : Install Vector apt] ****************************************
   skipping: [centos7]
   
   TASK [vector-role : Configure Service] *****************************************
   ok: [centos7]
   
   TASK [vector-role : Configure Vector 1] ****************************************
   ok: [centos7]
   
   TASK [vector-role : Configure Vector 2] ****************************************
   ok: [centos7]
   
   PLAY RECAP *********************************************************************
   centos7                    : ok=5    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Idempotence completed successfully.
   INFO     Running light_for_tox > destroy
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item={'command': '/usr/sbin/init', 'image': 'centos:7', 'name': 'centos7', 'privileged': True})
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
   changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '171182205638.6548', 'results_file': '/root/.ansible_async/171182205638.6548', 'changed': True, 'failed': False, 'item': {'command': '/usr/sbin/init', 'image': 'centos:7', 'name': 'centos7', 'privileged': True}, 'ansible_loop_var': 'item'})
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   
   INFO     Pruning extra files from scenario ephemeral directory
   py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.1,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.0.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.1.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.0,PyYAML==5.4.1,requests==2.28.2,rich==13.3.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.1,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.13.0
   py37-ansible30 run-test-pre: PYTHONHASHSEED='1855274039'
   py37-ansible30 run-test: commands[0] | molecule test -s light_for_tox --destroy always
   INFO     light_for_tox scenario test matrix: destroy, create, converge, idempotence, destroy
   INFO     Performing prerun...
   WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git': 'git'
   INFO     Guessed /opt/vector-role as project root directory
   WARNING  Computed fully qualified role name of vector-role does not follow current galaxy requirements.
   Please edit meta/main.yml and assure we can correctly determine full role name:
   
   galaxy_info:
   role_name: my_name  # if absent directory name hosting role is used instead
   namespace: my_galaxy_namespace  # if absent, author is used instead
   
   Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
   Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names
   
   As an alternative, you can add 'role-name' to either skip_list or warn_list.
   
   INFO     Using /root/.cache/ansible-lint/b984a4/roles/vector-role symlink to current repository in order to enable Ansible to find the role using its expected full name.
   INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
   INFO     Running light_for_tox > destroy
   INFO     Sanity checks: 'podman'
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item={'command': '/usr/sbin/init', 'image': 'centos:7', 'name': 'centos7', 'privileged': True})
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '181381729122.6675', 'results_file': '/root/.ansible_async/181381729122.6675', 'changed': True, 'failed': False, 'item': {'command': '/usr/sbin/init', 'image': 'centos:7', 'name': 'centos7', 'privileged': True}, 'ansible_loop_var': 'item'})
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   
   INFO     Running light_for_tox > create
   
   PLAY [Create] ******************************************************************
   
   TASK [get podman executable path] **********************************************
   ok: [localhost]
   
   TASK [save path to executable as fact] *****************************************
   ok: [localhost]
   
   TASK [Log into a container registry] *******************************************
   skipping: [localhost] => (item="centos7 registry username: None specified")
   
   TASK [Check presence of custom Dockerfiles] ************************************
   ok: [localhost] => (item=Dockerfile: None specified)
   
   TASK [Create Dockerfiles from image names] *************************************
   changed: [localhost] => (item="Dockerfile: None specified; Image: centos:7")
   
   TASK [Discover local Podman images] ********************************************
   ok: [localhost] => (item=centos7)
   
   TASK [Build an Ansible compatible image] ***************************************
   changed: [localhost] => (item=centos:7)
   
   TASK [Determine the CMD directives] ********************************************
   ok: [localhost] => (item="centos7 command: /usr/sbin/init")
   
   TASK [Remove possible pre-existing containers] *********************************
   changed: [localhost]
   
   TASK [Discover local podman networks] ******************************************
   skipping: [localhost] => (item=centos7: None specified)
   
   TASK [Create podman network dedicated to this scenario] ************************
   skipping: [localhost]
   
   TASK [Create molecule instance(s)] *********************************************
   changed: [localhost] => (item=centos7)
   
   TASK [Wait for instance(s) creation to complete] *******************************
   changed: [localhost] => (item=centos7)
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=10   changed=5    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
   
   INFO     Running light_for_tox > converge
   
   PLAY [Converge] ****************************************************************
   
   TASK [Gathering Facts] *********************************************************
   ok: [centos7]
   
   TASK [Include vector-role] *****************************************************
   
   TASK [vector-role : Install Vector yum] ****************************************
   changed: [centos7]
   
   TASK [vector-role : Install Vector apt] ****************************************
   skipping: [centos7]
   
   TASK [vector-role : Configure Service] *****************************************
   changed: [centos7]
   
   TASK [vector-role : Configure Vector 1] ****************************************
   changed: [centos7]
   
   TASK [vector-role : Configure Vector 2] ****************************************
   changed: [centos7]
   
   RUNNING HANDLER [vector-role : restart vector service] *************************
   changed: [centos7]
   
   PLAY RECAP *********************************************************************
   centos7                    : ok=6    changed=5    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Running light_for_tox > idempotence
   
   PLAY [Converge] ****************************************************************
   
   TASK [Gathering Facts] *********************************************************
   ok: [centos7]
   
   TASK [Include vector-role] *****************************************************
   
   TASK [vector-role : Install Vector yum] ****************************************
   ok: [centos7]
   
   TASK [vector-role : Install Vector apt] ****************************************
   skipping: [centos7]
   
   TASK [vector-role : Configure Service] *****************************************
   ok: [centos7]
   
   TASK [vector-role : Configure Vector 1] ****************************************
   ok: [centos7]
   
   TASK [vector-role : Configure Vector 2] ****************************************
   ok: [centos7]
   
   PLAY RECAP *********************************************************************
   centos7                    : ok=5    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Idempotence completed successfully.
   INFO     Running light_for_tox > destroy
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item={'command': '/usr/sbin/init', 'image': 'centos:7', 'name': 'centos7', 'privileged': True})
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
   changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '144692676753.9067', 'results_file': '/root/.ansible_async/144692676753.9067', 'changed': True, 'failed': False, 'item': {'command': '/usr/sbin/init', 'image': 'centos:7', 'name': 'centos7', 'privileged': True}, 'ansible_loop_var': 'item'})
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   
   INFO     Pruning extra files from scenario ephemeral directory
   py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==3.0.1,ansible-core==2.14.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.1,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,markdown-it-py==2.1.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==8.0.0,PyYAML==5.4.1,requests==2.28.2,resolvelib==0.8.1,rich==13.3.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.1,text-unidecode==1.3,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3
   py39-ansible210 run-test-pre: PYTHONHASHSEED='1855274039'
   py39-ansible210 run-test: commands[0] | molecule test -s light_for_tox --destroy always
   INFO     light_for_tox scenario test matrix: destroy, create, converge, idempotence, destroy
   INFO     Performing prerun...
   WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
   INFO     Guessed /opt/vector-role as project root directory
   WARNING  Computed fully qualified role name of vector-role does not follow current galaxy requirements.
   Please edit meta/main.yml and assure we can correctly determine full role name:
   
   galaxy_info:
   role_name: my_name  # if absent directory name hosting role is used instead
   namespace: my_galaxy_namespace  # if absent, author is used instead
   
   Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
   Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names
   
   As an alternative, you can add 'role-name' to either skip_list or warn_list.
   
   INFO     Using /root/.cache/ansible-lint/b984a4/roles/vector-role symlink to current repository in order to enable Ansible to find the role using its expected full name.
   INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
   INFO     Running light_for_tox > destroy
   INFO     Sanity checks: 'podman'
   Traceback (most recent call last):
     File "/opt/vector-role/.tox/py39-ansible210/bin/molecule", line 8, in <module>
       sys.exit(main())
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1130, in __call__
       return self.main(*args, **kwargs)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1055, in main
       rv = self.invoke(ctx)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1657, in invoke
       return _process_result(sub_ctx.command.invoke(sub_ctx))
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1404, in invoke
       return ctx.invoke(self.callback, **ctx.params)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 760, in invoke
       return __callback(*args, **kwargs)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/decorators.py", line 26, in new_func
       return f(get_current_context(), *args, **kwargs)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/test.py", line 159, in test
       base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 119, in execute_cmdline_scenarios
       execute_scenario(scenario)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 161, in execute_scenario
       execute_subcommand(scenario.config, action)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 150, in execute_subcommand
       return command(config).execute()
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/logger.py", line 187, in wrapper
       rt = func(*args, **kwargs)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/destroy.py", line 107, in execute
       self._config.provisioner.destroy()
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/provisioner/ansible.py", line 705, in destroy
       pb.execute()
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/provisioner/ansible_playbook.py", line 106, in execute
       self._config.driver.sanity_checks()
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule_podman/driver.py", line 212, in sanity_checks
       if runtime.version < Version("2.10.0") and runtime.config.ansible_pipelining:
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible_compat/runtime.py", line 208, in version
       self._version = parse_ansible_version(proc.stdout)
     File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible_compat/config.py", line 39, in parse_ansible_version
       raise InvalidPrerequisiteError(
   ansible_compat.errors.InvalidPrerequisiteError: Unable to parse ansible cli version: ansible 2.10.17
     config file = None
     configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
     ansible python module location = /opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible
     executable location = /opt/vector-role/.tox/py39-ansible210/bin/ansible
     python version = 3.9.2 (default, Jun 13 2022, 19:42:33) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]
   
   Keep in mind that only 2.12 or newer are supported.
   ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s light_for_tox --destroy always (exited with code 1)
   py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==3.0.1,ansible-core==2.14.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.0.1,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.1,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,markdown-it-py==2.1.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==8.0.0,PyYAML==5.4.1,requests==2.28.2,resolvelib==0.8.1,rich==13.3.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.1,text-unidecode==1.3,urllib3==1.26.14,wcmatch==8.4.1,yamllint==1.26.3
   py39-ansible30 run-test-pre: PYTHONHASHSEED='1855274039'
   py39-ansible30 run-test: commands[0] | molecule test -s light_for_tox --destroy always
   INFO     light_for_tox scenario test matrix: destroy, create, converge, idempotence, destroy
   INFO     Performing prerun...
   WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
   INFO     Guessed /opt/vector-role as project root directory
   WARNING  Computed fully qualified role name of vector-role does not follow current galaxy requirements.
   Please edit meta/main.yml and assure we can correctly determine full role name:
   
   galaxy_info:
   role_name: my_name  # if absent directory name hosting role is used instead
   namespace: my_galaxy_namespace  # if absent, author is used instead
   
   Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
   Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names
   
   As an alternative, you can add 'role-name' to either skip_list or warn_list.
   
   INFO     Using /root/.cache/ansible-lint/b984a4/roles/vector-role symlink to current repository in order to enable Ansible to find the role using its expected full name.
   INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
   INFO     Running light_for_tox > destroy
   INFO     Sanity checks: 'podman'
   Traceback (most recent call last):
     File "/opt/vector-role/.tox/py39-ansible30/bin/molecule", line 8, in <module>
       sys.exit(main())
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1130, in __call__
       return self.main(*args, **kwargs)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1055, in main
       rv = self.invoke(ctx)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1657, in invoke
       return _process_result(sub_ctx.command.invoke(sub_ctx))
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1404, in invoke
       return ctx.invoke(self.callback, **ctx.params)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 760, in invoke
       return __callback(*args, **kwargs)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/decorators.py", line 26, in new_func
       return f(get_current_context(), *args, **kwargs)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/test.py", line 159, in test
       base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 119, in execute_cmdline_scenarios
       execute_scenario(scenario)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 161, in execute_scenario
       execute_subcommand(scenario.config, action)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 150, in execute_subcommand
       return command(config).execute()
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/logger.py", line 187, in wrapper
       rt = func(*args, **kwargs)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/destroy.py", line 107, in execute
       self._config.provisioner.destroy()
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/provisioner/ansible.py", line 705, in destroy
       pb.execute()
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/provisioner/ansible_playbook.py", line 106, in execute
       self._config.driver.sanity_checks()
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule_podman/driver.py", line 212, in sanity_checks
       if runtime.version < Version("2.10.0") and runtime.config.ansible_pipelining:
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/runtime.py", line 208, in version
       self._version = parse_ansible_version(proc.stdout)
     File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/config.py", line 39, in parse_ansible_version
       raise InvalidPrerequisiteError(
   ansible_compat.errors.InvalidPrerequisiteError: Unable to parse ansible cli version: ansible 2.10.17
     config file = None
     configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
     ansible python module location = /opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible
     executable location = /opt/vector-role/.tox/py39-ansible30/bin/ansible
     python version = 3.9.2 (default, Jun 13 2022, 19:42:33) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]
   
   Keep in mind that only 2.12 or newer are supported.
   ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s light_for_tox --destroy always (exited with code 1)
   __________________________________________________________________________________________________________________ summary __________________________________________________________________________________________________________________
     py37-ansible210: commands succeeded
     py37-ansible30: commands succeeded
   ERROR:   py39-ansible210: commands failed
   ERROR:   py39-ansible30: commands failed   
   ```
   </details>

   [1.2.0](https://github.com/OlegDy/vector-role/commit/1db605d4bebe6de8e1f30bebec0734a6073fdf9c)  

   [tags](https://github.com/OlegDy/vector-role/tags)


