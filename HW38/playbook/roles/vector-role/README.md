Ansible-Role Vector for CentOS 7
=========

Role install Vector on CentOS 7 

Requirements
------------

Only YUM installs

Role Variables
--------------

Available variables `defaults/main.yml` and `vars/main.yml`

  vector_version: 0.21.1
  vector_config_dir: "{{ ansible_user_dir }}/vector_config"

Dependencies
------------

None.

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

