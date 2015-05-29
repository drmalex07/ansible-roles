#!/bin/bash

PYENV_DIR={{ckan.pyenv_dir}}

. ${PYENV_DIR}/bin/activate
cd ${PYENV_DIR}/src/ckan && paster serve --reload config.ini

