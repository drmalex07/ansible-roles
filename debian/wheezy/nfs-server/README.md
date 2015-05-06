## README

Setup an NFS server, configure exported directories.

### Examples

A minimal example would be:
```yaml
- hosts: nfs.local 
  remote_user: root
  
  vars:     
    nfs:
      exports:
      - path: '/var/local/data-1'
        clients:
        - hostname: 'venus.local'
          options: {}
        - hostname: 'mars.local'
          options:
            squash: 'all'
            anon_user: 'martian'
            anon_group: 'martian'

  roles:
  - nfs-server
```
