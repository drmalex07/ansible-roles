README
------

This role depends on `tomcat-7` role. It can be applied multiple times (just as the underlying `tomcat-7`) creating multiple server instances.
An example would be:

```yaml
 - hosts: geoserver
   remote_user: root

   pre_tasks:

   - set_fact:
       tomcat:
         secrets_dir: '{{"files/secrets/groups/geoserver/tomcat"| realpath}}'
   
   roles:
   - role: geoserver-2
     tomcat:
       instance_id: 1 
       shutdown: 
         port: 8091
       connector: 
         port: 8081
       ajp_connector:
         port: 9001
   - role: geoserver-2
     tomcat:
       instance_id: 2 
       shutdown: 
         port: 8092
       connector: 
         port: 8082
       ajp_connector:
         port: 9002

```
