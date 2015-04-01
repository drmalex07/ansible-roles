# README


## Provide configuration for a Solr core

A minimal configuration for a (Solr) core named `core1` can be provided with the following files:

* `files/etc/solr/core1/conf/schema.xml`
* `files/etc/solr/core1/conf/elevate.xml`

Remember to add the core inside your host/group variables or directly at role's  `defaults/main.yml`. For example:

```yaml
solr:
  # ... other Solr-related settings
  cores:
  - name: core1
```
