@echo off
SET parentname=%1
IF [%parentname%]==[] GOTO :USAGE_THEN_EXIT

SET username=%2
IF [%username%] == [] GOTO :USAGE_THEN_EXIT

SET curvename=%3
IF [%curvename%] == [] SET curvename=prime256v1

SET ParentKeyFile=%parentname%-key.pem
SET ParentChainFile=%parentname%-chain.pem
SET KeyFile=%username%-key.pem
SET ReqFile=%username%-req.pem
SET CertFile=%username%-cert.pem
SET ChainFile=%username%-chain.pem

openssl ecparam -genkey -out %KeyFile% -name %curvename% || EXIT /b 2
openssl req -new -key %KeyFile% -out %ReqFile% -subj "/CN=%username%" || EXIT /b 3
openssl x509 -req -in %ReqFile% -extfile conf/ec-subca.cnf -days 2000 -set_serial %RANDOM% -CA %ParentChainFile% -CAkey %ParentKeyFile% -out %CertFile% || EXIT /b 4
TYPE %CertFile% %ParentChainFile% > %ChainFile% || EXIT /b 5
EXIT /b 0

:USAGE_THEN_EXIT
ECHO Usage: gen-ec-subca.bat ^<parent-name^> ^<user-name^> [curve-name=prime256v1]
EXIT /b 1
