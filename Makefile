COMPILER = g++
OUTPUT   = ./bin/unix/cerberus
SOURCE   = ./src/main.cpp ./src/token/token.cpp ./src/lexer/lexer.cpp
FLAGS    = -Wall -Wextra -Wno-unused-variable -Wno-unused-parameter

all:
	${COMPILER} ${SOURCE} -o ${OUTPUT} ${FLAGS}