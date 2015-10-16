#!/bin/bash

archive_path=$1
[ -f ${archive_path} ] || exit 1

temp_name="$(tar t --exclude '*/*' -f ${archive_path})"
[ $? = "0" ] || exit 1
temp_name="${temp_name%/}"
temp_dir="/tmp/${temp_name}"

tar xvf ${archive_path} -C /tmp

gpg --import ${temp_dir}/keys.asc
gpg --import ${temp_dir}/secret-keys.asc

rm -vrf ${temp_dir}
exit 0
