@Echo off
SETLOCAL

SET COMPILER=g++
SET OUTPUT=./bin/win/cerberus.exe
SET SOURCE=./src/main.cpp
SET FLAGS=-Wall -Wextra -Wno-unused-variable -Wno-unused-parameter

@Echo on

%COMPILER% %SOURCE% -o %OUTPUT% %FLAGS%

@Echo off

ENDLOCAL