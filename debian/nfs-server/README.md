## README

Setup an NFS server, configure exported directories.

### Requirements 

This role depends on the `nfs_export` module which can be found under https://github.com/drmalex07/ansible-modules.

### Examples

A example playbook would be:
```yaml

- hosts: nfs.local 
  remote_user: root
  
  vars:     
    nfs:
      exports:
      - path: '/var/local/data-1'
        clients:
        - hosts: 
          - 'venus.local' 
          - 'mars.local'
          options: {}
        - hosts: ['tape.local']
          options:
            squash: 'all'
            anon_user: 'backup'
            anon_group: 'backup'

  roles:
  - nfs-server

```
