Ansible-Role Lighthouse for CentOS 7
=========

Role install Lighthouse on CentOS 7 

Requirements
------------

Only YUM installs

Role Variables
--------------

Available variables `defaults/main.yml` and `vars/main.yml`
```
  lighthouse_port: "80"
```

Dependencies
------------

None.

Example Playbook
----------------

The simpliest example:
```yaml
- name: Install Vector
  hosts: lighthouse
  roles:
    - lighthouse
```

License
-------

MIT

Author Information
------------------

Oleg Dyachenko



