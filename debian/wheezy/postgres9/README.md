## Setup a master-standby cluster

Note that the following is, of course, not the only way to organize our groups and variables. 

Assume we have a `database` group of hosts. It's quite straightforward to further divide this group into 2 subgroups: `database-master` (with only 1 member) and `database-standby` (with the rest of `database` members). So, we have an inventory excerpt like this:
```ini
[database:children]

database-master
database-standby

[database-master]

postgres-n1.localdomain

[database-standby]

postgres-n2.localdomain
postgres-n3.localdomain
```

Create the following group variable files:
 *  `group_vars/database.yml`: common configuration shared by both master and standby servers
 *  `group_vars/database-master.yml`: master-specific configuration (overrides or additions)
 *  `group_vars/database-standby.yml`: standby-specific (overrides or additions)

Suppose we know that all servers should listen to a specific ipv4 (or ipv6) interface, say `eth1`, most probably this would be an interface to a private network (say 10.0.2.0/24). In the following var files we will use references to `ansible_eth1`, assuming that previously all host facts have been gathered successfully. 

An example `group_vars/database.yml` would be:
```yaml
postgres:
  pgtune: true
  
  service:
    listen_addresses:
    - '127.0.0.1'
    - '{{ansible_eth1.ipv4.address}}'
    port: 5432

  # Define users
  users:
  - name: tester
    allowed_addresses: [samenet]
  - name: nowhere-man
    options: [LOGIN]
    allowed_addresses: [samenet]
  - name: collectd
    trusted: true
  
  credentials:
  - username: tester
    password: test
  - username: replicator
    password: replicate

  # Additional tablespaces to be created
  tablespaces:
  - name: tablespace_1
    path: /var/local/lib/postgresql/tablespace_1

  # Databases to be created
  databases:
  - name: scratch1
    tablespace: tablespace_1
    owner: tester
    extensions: [hstore, postgis]
    readers: [nowhere-man]
    writers: []
    initialize: 
    - local_path: files/database/setup-scripts/scratch1/1.sql
      single_transaction: yes
```

An example `group_vars/database-master.yml` would be:
```yaml
postgres:
  replication:
    role: master
    master:   
      num_wal_segments: 32
      clients:
        max_num: '{{groups["database-standby"]|length + 1}}'
        allowed_addresses: 
        - '127.0.0.1/8' 
        - '{{ansible_eth1.ipv4.network| ipv4_to_cidr(netmask=ansible_eth1.ipv4.netmask)}}'
```

An example `group_vars/database-standby.yml` would be:
```yaml
 postgres:
   replication:
     standby: 
       master_host: '{{groups["database-master"]| first}}'
```

Finally, an example playbook would simply be:
```yaml
- hosts: database
  remote_user: root
  pre_tasks:
  - debug: var=postgres.service
  - debug: var=postgres.replication
  - pause: # verify everything is ok!
  roles:
  - postgres9
```

**Note: hostnames as allowed addresses**

It is possible to give hostnames as `allowed_addresses` for user connections or for replication connections to master. If you do so, ensure that name resolution works properly (see pg_hba.conf documentation!), either locally via `/etc/hosts` or via normal (both forward and reverse) DNS queries!

So, if names are resolved properly, it's fine if you pass something like (in `group_vars/database-master.yml`):
```yaml
postgres:
  replication:
    role: master
    master:   
      num_wal_segments: 32
      clients:
        max_num: '{{groups["database-standby"]|length + 1}}'
        allowed_addresses: # list will be flattened
        - '127.0.0.1/8'
        - '{{groups["database-standby"]}}'
```
