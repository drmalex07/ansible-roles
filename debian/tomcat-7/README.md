README
------


This role may be used to create multiple Tomcat instances running on the same host.
A simple example would be:

```yaml
 
 - hosts: web-server
   remote_user: root

   pre_tasks:

   - set_fact:
       tomcat:
         secrets_dir: '{{"files/secrets/groups/web-server/tomcat"| realpath}}'
   
   roles:
   - role: tomcat-7
     tomcat:
       instance_id: 1
       shutdown:
         port: 8001 
       connector: 
         port: 8081
       ajp_connector:
         port: 9001
   - role: tomcat-7
     tomcat:
       instance_id: 2
       shutdown:
         port: 8002 
       connector: 
         port: 8082
       ajp_connector:
         port: 9002


```
