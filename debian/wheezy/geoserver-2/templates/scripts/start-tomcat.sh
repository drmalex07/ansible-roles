#!/bin/bash

export CATALINA_OPTS="-server -Xms{{tomcat.min_heap_size}} -Xmx{{tomcat.max_heap_size}} -XX:+UseParallelGC -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=512m"

cd /opt/tomcat7 && ./bin/catalina.sh start
