@echo off

SET username=%1
IF [%username%] == [] GOTO :USAGE_THEN_EXIT

SET secparam=%2
IF [%secparam%] == [] SET secparam=2048

SET KeyFile=%username%-key.pem
SET ReqFile=%username%-req.pem
SET CertFile=%username%-cert.pem
SET ChainFile=%username%-chain.pem

openssl genrsa -out %KeyFile% %secparam% || EXIT /b 2
openssl req -new -key %KeyFile% -out %ReqFile% -subj "/CN=%username%" || EXIT /b 3
openssl x509 -req -in %ReqFile% -extfile conf/rsa-root.cnf -days 2000 -signkey %KeyFile% -out %CertFile%
TYPE %CertFile% %ParentChainFile% > %ChainFile% || EXIT /b 5
EXIT /b 0

:USAGE_THEN_EXIT
ECHO Usage: gen-rsa-root.bat ^<user-name^> [sec-param=2048]
EXIT /b 1
