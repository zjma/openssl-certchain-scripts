#!/bin/bash

function show_usage()
{
    printf "Usage: ./gen-ec-root.sh <user-name> [curve-name=prime256v1]\n"
}


username=$1
test -z $username && show_usage && exit 1

curvename=$2
test -z $curvename && curvename=prime256v1

KeyFile=$username-key.pem
ReqFile=$username-req.pem
CertFile=$username-cert.pem
ChainFile=$username-chain.pem

set -e

openssl ecparam -genkey -out $KeyFile -name $curvename
openssl req -new -key $KeyFile -out $ReqFile -subj "/CN=$username"
openssl x509 -req -in $ReqFile -extfile conf/ec-root.cnf -days 2000 -signkey $KeyFile -out $CertFile
cat $CertFile > $ChainFile

