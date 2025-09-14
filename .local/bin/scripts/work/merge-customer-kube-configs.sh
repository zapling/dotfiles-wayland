#!/usr/bin/env bash

set -euo pipefail # Exit on error, unset variable and pipe failure.

for dir in ~/.kube/customer-configs/*/
do
    customer=$(basename "$dir")
    kubeConfigs=""
    for file in $dir*
    do
        if [[ "$kubeConfigs" == "" ]]; then
            kubeConfigs="$file"
        else
            kubeConfigs="$kubeConfigs:$file"
        fi
    done

    filePath=~/.kube/${customer}-kube.conf
    KUBECONFIG="$kubeConfigs" kubectl config view --flatten > $filePath
    echo "$customer => $filePath"
done
