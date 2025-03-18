#!/bin/sh

REPOSITORY_TOP_PATH=${1:-$(pwd)}
echo ${REPOSITORY_TOP_PATH}

check_validation() {
    while IFS= read -r path; do
        MODULE_NAME=$(echo ${path} | sed -E 's#.*/modules/##; s#/#_#g')
        cd ${path}
        echo ${MODULE_NAME}
        # terraform init -backend=false &>/dev/null
        terraform validate
    done
}

find ${REPOSITORY_TOP_PATH}/modules/ -type f -name "versions.tf" -exec dirname {} \; | check_validation
