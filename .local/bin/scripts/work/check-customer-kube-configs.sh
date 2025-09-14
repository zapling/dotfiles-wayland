#!/usr/bin/env bash

set -euo pipefail # Exit on error, unset variable and pipe failure.

output="\n"
for dir in ~/.kube/customer-configs/*/
do
    customer=$(basename "$dir")
    for file in $dir*
    do
        fileName=$(basename $file)
        result=$(cat $file | grep client-certificate-data | cut -f2 -d : | tr -d ' ' | base64 -d | openssl x509 -enddate -dateopt iso_8601 -out - | grep -o "notAfter=.*" | sed 's/notAfter=//')
        # printf "%s\t%s\n" "$fileName" "$result" | column -s, -t
        #
        output="${output} ${customer},${fileName},${result}\n"
    done
done

echo -e "CUSTOMER,FILE,EXPIRY\n$output" | column -s, -t
