#!/bin/bash

config_file={{ckan.pyenv_dir}}/src/ckan/config.ini

id_patt='[0-9a-fA-F]\{8\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{4\}-[0-9a-fA-F]\{12\}'

name=

purge_all=no

while getopts "a" opt; do
    case $opt in
        a) purge_all=yes ;;
        ?) echo "Invalid option: ${OPTARG}" ;;
    esac
done
 
shift $((OPTIND-1))

name=${1}

if [ ${purge_all} == 'yes' ]; then
    names=$(paster --plugin=ckan dataset -c ${config_file} list| grep -e "${id_patt}"| cut -d ' ' -f 2)
    echo  "Are you sure you want to delete ALL ($(echo $names| wc -w)) datasets? (yes/no)" && read yes
    if [ ${yes} == 'yes' ]; then
        for name in ${names}
        do
            paster --plugin=ckan dataset -c ${config_file} purge ${name}
        done
    else
        echo 'Purge was cancelled'
    fi
else
    if [ -z "${name}" ]; then
        echo "Usage:"
        echo "  ${0} <dataset-name> (purge a specific dataset)" 
        echo "  ${0} -a (purge all datasets)"
        exit 0
    fi
    paster --plugin=ckan dataset -c ${config_file} purge ${name}
fi 

