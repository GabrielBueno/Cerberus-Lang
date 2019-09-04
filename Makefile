COMPILER = g++
OUTPUT   = ./bin/unix/cerberus
SOURCE   = ./src/main.cpp
FLAGS    = -Wall -Wextra -Wno-unused-variable -Wno-unused-parameter

all:
	${COMPILER} ${SOURCE} -o ${OUTPUT} ${FLAGS}