## README

Setup an NFS server, configure exported directories.

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
        - host: 'venus.local'
          options: {}
        - host: 'mars.local'
          options:
            squash: 'all'
            anon_user: 'martian'
            anon_group: 'martian'

  roles:
  - nfs-server

```
