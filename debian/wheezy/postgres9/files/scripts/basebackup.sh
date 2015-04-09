#!/bin/bash

master_host=$1

pg_basebackup -h $master_host -U replicator -Ft -R -P -v -D backup

