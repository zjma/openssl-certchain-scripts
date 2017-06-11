#!/bin/bash

function show_usage()
{
    printf "Usage: ./gen-rsa-subca.sh <parent-name> <user-name> [sec-param=2048]\n"
}


parentname=$1
test -z $parentname && show_usage && exit 1

username=$2
test -z $username && show_usage && exit 1

secparam=$3
test -z $secparam && secparam=2048

ParentKeyFile=$parentname-key.pem
ParentChainFile=$parentname-chain.pem
KeyFile=$username-key.pem
ReqFile=$username-req.pem
CertFile=$username-cert.pem
ChainFile=$username-chain.pem

set -e

openssl genrsa -out $KeyFile $secparam
openssl req -new -key $KeyFile -out $ReqFile -subj "/CN=$username"
openssl x509 -req -in $ReqFile -extfile conf/rsa-subca.cnf -days 2000 -set_serial $RANDOM -CA $ParentChainFile -CAkey $ParentKeyFile -out $CertFile
cat $CertFile $ParentChainFile > $ChainFile

