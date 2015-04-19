## README

### Prerequisites

Here, we describe the minimal requirements for applying this role.

1. The following files must be available (locally):
 * `files/etc/ssh/authorized_keys`: List of public keys to be authorized at target machine

2. If you provide a non-empty `user.private_keys` variable (array of private-key descriptors, see `defaults/main.yml`), 
   all referenced keys must be available (locally) under `~/.ssh`.

