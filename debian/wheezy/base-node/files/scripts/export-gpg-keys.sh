#!/bin/bash

temp_dir=$(mktemp -d --tmpdir=/tmp gpg-XXXXXXXXXX)
temp_name="$(basename ${temp_dir})"

archive_name="${temp_name}.tar"
archive_path="/tmp/${archive_name}"

gpg --export -a -o ${temp_dir}/keys.asc 
gpg --export-secret-keys -a -o ${temp_dir}/secret-keys.asc

tar cf ${archive_path} -C /tmp ${temp_name}

rm -rf ${temp_dir}

echo ${archive_path}
exit 0
