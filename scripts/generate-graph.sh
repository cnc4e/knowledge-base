#!/bin/bash

REPOSITORY_TOP_PATH=$(git rev-parse --show-toplevel)
echo ${REPOSITORY_TOP_PATH}

check_gen_graph() {
    while IFS= read -r path; do
        MODULE_NAME=$(echo ${path} | sed -E 's#.*/modules/##; s#/#_#g')
        cd ${path}
        echo ${MODULE_NAME}
        # terraform init -backend=false &>/dev/null
        terraform graph | dot -Tpng > ${REPOSITORY_TOP_PATH}/doc/module/graph/${MODULE_NAME}.png
    done
}

find ${REPOSITORY_TOP_PATH}/modules/ -type f -name "versions.tf" -exec dirname {} \; | check_gen_graph
