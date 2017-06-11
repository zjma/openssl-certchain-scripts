#!/bin/bash

function show_usage()
{
    printf "Usage: ./gen-rsa-root.sh <user-name> [sec-param=2048]\n"
}


username=$1
test -z $username && show_usage && exit 1

secparam=$2
test -z $secparam && curvename=2048

KeyFile=$username-key.pem
ReqFile=$username-req.pem
CertFile=$username-cert.pem
ChainFile=$username-chain.pem

set -e

openssl genrsa -out $KeyFile $secparam
openssl req -new -key $KeyFile -out $ReqFile -subj "/CN=$username"
openssl x509 -req -in $ReqFile -extfile conf/rsa-root.cnf -days 2000 -signkey $KeyFile -out $CertFile
cat $CertFile > $ChainFile

