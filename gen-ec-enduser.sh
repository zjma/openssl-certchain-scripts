#!/bin/bash

function show_usage()
{
    printf "Usage: ./gen-ec-enduser.sh <parent-name> <user-name> [curve-name=prime256v1]\n"
}


parentname=$1
test -z $parentname && show_usage && exit 1

username=$2
test -z $username && show_usage && exit 1

curvename=$3
test -z $curvename && curvename=prime256v1

ParentKeyFile=$parentname-key.pem
ParentChainFile=$parentname-chain.pem
KeyFile=$username-key.pem
ReqFile=$username-req.pem
CertFile=$username-cert.pem
ChainFile=$username-chain.pem

set -e

openssl ecparam -genkey -out $KeyFile -name $curvename
openssl req -new -key $KeyFile -out $ReqFile -subj "/CN=$username"
openssl x509 -req -in $ReqFile -extfile conf/ec-enduser.cnf -days 2000 -set_serial $RANDOM -CA $ParentChainFile -CAkey $ParentKeyFile -out $CertFile
cat $CertFile $ParentChainFile > $ChainFile

