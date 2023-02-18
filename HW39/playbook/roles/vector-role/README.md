Ansible-Role Vector 
=========

Role install Vector on CentOS and Ubuntu 


Role Variables
--------------

Available variables `defaults/main.yml` and `vars/main.yml`

  vector_version: 0.21.1
  vector_config_dir: "{{ ansible_user_dir }}/vector_config"


Example Playbook
----------------

The simpliest example:
```yaml
- name: Install Vector
  hosts: vector
  roles:
    - vector
```

License
-------

MIT

Author Information
------------------

Oleg Dyachenko

