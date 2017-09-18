@echo off

SET parentname=%1
IF [%parentname%]==[] GOTO :USAGE_THEN_EXIT

SET username=%2
IF [%username%] == [] GOTO :USAGE_THEN_EXIT

SET secparam=%3
IF [%secparam%] == [] SET secparam=2048

SET ParentKeyFile=%parentname%-key.pem
SET ParentChainFile=%parentname%-chain.pem
SET KeyFile=%username%-key.pem
SET ReqFile=%username%-req.pem
SET CertFile=%username%-cert.pem
SET ChainFile=%username%-chain.pem

openssl genrsa -out %KeyFile% %secparam% || EXIT /b 2
openssl req -new -key %KeyFile% -out %ReqFile% -subj "/CN=%username%" || EXIT /b 3
openssl x509 -req -in %ReqFile% -extfile conf/rsa-enduser.cnf -days 2000 -set_serial %RANDOM% -CA %ParentChainFile% -CAkey %ParentKeyFile% -out %CertFile% || EXIT /b 3
TYPE %CertFile% %ParentChainFile% > %ChainFile% || EXIT /b 5
EXIT /b 0

:USAGE_THEN_EXIT
ECHO Usage: gen-rsa-enduser.bat ^<parent-name^> ^<user-name^> [sec-param=2048]
EXIT /b 1
