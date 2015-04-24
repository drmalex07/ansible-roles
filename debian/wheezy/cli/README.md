## README

### Notes

#### Keys

All referenced key files (public or private) must exist locally under `files/keys` relative to the active playbook.
Hence, this location should better be excluded from version-control.

A key file named `id_rsa-foo` expects a public (OpenSSH-compatible) part named as `id_rsa-foo.pub`

For example, suppose that you provide the following variables: 

```yaml
private_keys:
- name: Foo
  key_file: id_rsa-foo
```

Then, a private key will be looked up under `files/keys/id_rsa-foo` and a corresponding public key under `files/keys/id_rsa-foo.pub``


### Prerequisites

Here, we describe the minimal requirements for applying this role.

1. All referenced keys must exist under `files/keys`. If you only specify the `authorized_keys` variable, then
   only the public parts (*.pub) are required.

2. More ... 
