CATALINA_OPTS="-server -Xms{{tomcat.min_heap_size}} -Xmx{{tomcat.max_heap_size}} -XX:+UseParallelGC -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=512m"
CATALINA_PID="/var/local/tomcat7/{{tomcat_instance_name}}.pid"
