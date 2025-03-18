#!/bin/bash

TERRAFORM_VERSION=1.10.3
AWS_PROVIDER_VERSION=5.84.0

SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

cd ${SCRIPT_DIR}
cd ../environment
find -name versions.tf | while read line; do
    tfupdate terraform -v ${TERRAFORM_VERSION} ${line}
    tfupdate provider aws -v ${AWS_PROVIDER_VERSION} ${line}
done

cd ${SCRIPT_DIR}
cd ../modules
find -name versions.tf | while read line; do
    tfupdate terraform -v ">= ${TERRAFORM_VERSION}" ${line}
    tfupdate provider aws -v ">= ${AWS_PROVIDER_VERSION}" ${line}
done
