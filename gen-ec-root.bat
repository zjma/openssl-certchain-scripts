@echo off

SET username=%1
IF [%username%] == [] GOTO :USAGE_THEN_EXIT

SET curvename=%2
IF [%curvename%] == [] SET curvename=prime256v1

SET KeyFile=%username%-key.pem
SET ReqFile=%username%-req.pem
SET CertFile=%username%-cert.pem
SET ChainFile=%username%-chain.pem

SET KeyFile=%username%-key.pem
SET ReqFile=%username%-req.pem
SET CertFile=%username%-cert.pem
SET ChainFile=%username%-chain.pem

openssl ecparam -genkey -out %KeyFile% -name %curvename% || EXIT /b 2
openssl req -new -key %KeyFile% -out %ReqFile% -subj "/CN=%username%" || EXIT /b 3
openssl x509 -req -in %ReqFile% -extfile conf/ec-root.cnf -days 2000 -signkey %KeyFile% -out %CertFile% || EXIT /b 4
TYPE %CertFile% > %ChainFile%
EXIT /b 0

:USAGE_THEN_EXIT
ECHO Usage: gen-ec-root.bat ^<user-name^> [curve-name=prime256v1]
EXIT /b 1
