#!/bin/bash

# Use get-k8s-credentials.sh to get endpoint, cert and token

set -eo pipefail


if [[ $# -lt 4 ]]; then
    echo "Usage: $0 release chart namespace service-account [helm args]"
    exit 1
fi

RELEASE=$1
CHART=$2
NAMESPACE=$3
SERVICE_ACCOUNT=$4
shift 4
HELM_ARGS=$@

count=0
for var in B64_CA_CRT SERVICE_ACCOUNT_TOKEN CLUSTER_ENDPOINT; do
    if [[ -z "${!var}" ]]; then
        echo "$var not defined"
        count=$((count + 1))
    fi
done

[[ $count > 0 ]] && exit 1

KUBECONFIG=$(mktemp)
trap "rm -f $KUBECONFIG" EXIT
cat > $KUBECONFIG <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $B64_CA_CRT
    server: $CLUSTER_ENDPOINT
  name: k8s-cluster
contexts:
- context:
    cluster: k8s-cluster
    namespace: $NAMESPACE
    user: $SERVICE_ACCOUNT
  name: helm
current-context: helm
kind: Config
preferences: {}
users:
- name: $SERVICE_ACCOUNT
  user:
    as-user-extra: {}
    token: $SERVICE_ACCOUNT_TOKEN
EOF

export KUBECONFIG
helm init --client-only
helm upgrade "$RELEASE" "$CHART" --install $HELM_ARGS
