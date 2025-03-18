#!/bin/bash

REPOSITORY_TOP_PATH=$(git rev-parse --show-toplevel)
echo ${REPOSITORY_TOP_PATH}

check_gen_doc() {
    while IFS= read -r path; do
        MODULE_NAME=$(echo ${path} | sed -E 's#.*/modules/##; s#/#_#g')
        cd ${path}
        terraform-docs markdown --config ${REPOSITORY_TOP_PATH}/.terraform-docs.yml --output-file ${REPOSITORY_TOP_PATH}/doc/module/${MODULE_NAME}.md --output-mode inject --hide providers --hide modules .
    done
}

find ${REPOSITORY_TOP_PATH}/modules/ -type f -name "versions.tf" -exec dirname {} \; | check_gen_doc
