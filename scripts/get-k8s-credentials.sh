#!/bin/bash

set -eo pipefail

if [[ $# != 2 ]]; then
    echo "Usage: $0 service_account namespace"
    exit 1
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
    BASE64_DECODE="base64 -D"
else
    BASE64_DECODE="base64 -d"
fi


SERVICE_ACCOUNT="${1}"
NAMESPACE="${2}"
SECRET_NAME=$(kubectl get sa ${SERVICE_ACCOUNT} --namespace ${NAMESPACE} -o json | jq -r .secrets[].name)
B64_CA_CRT=$(kubectl get secret $SECRET_NAME --namespace ${NAMESPACE} -o json | jq -r '.data["ca.crt"]')
SERVICE_ACCOUNT_TOKEN=$(kubectl get secret $SECRET_NAME --namespace ${NAMESPACE} -o json | jq -r '.data["token"]' | ${BASE64_DECODE})
CONTEXT=`kubectl config current-context`
CLUSTER_NAME=`kubectl config get-contexts $CONTEXT | awk '{print $3}' | tail -n 1`
CLUSTER_ENDPOINT=`kubectl config view -o jsonpath="{.clusters[?(@.name == \"$CLUSTER_NAME\")].cluster.server}"`

echo "CLUSTER_ENDPOINT=${CLUSTER_ENDPOINT}"
echo "B64_CA_CRT=${B64_CA_CRT}"
echo "SERVICE_ACCOUNT_TOKEN=${SERVICE_ACCOUNT_TOKEN}"
