#!/bin/sh

REPOSITORY_TOP_PATH=${1:-$(pwd)}
echo ${REPOSITORY_TOP_PATH}

check_gen_doc() {
    while IFS= read -r path; do
        MODULE_NAME=$(echo ${path} | sed -E 's#.*/modules/##; s#/#_#g')
        cd ${path}
        terraform-docs markdown --config ${REPOSITORY_TOP_PATH}/.terraform-docs.yml --output-file ${REPOSITORY_TOP_PATH}/doc/module/${MODULE_NAME}.md --output-mode inject --output-check --hide providers --hide modules .
    done
}

find ${REPOSITORY_TOP_PATH}/modules/ -type f -name "versions.tf" -exec dirname {} \; | check_gen_doc
