COMPILER   = g++
OUTPUT     = ./bin/unix/cerberus
MAIN_SRC   = ./src/main.cpp
LEXER_SRC  = ./src/token/token.cpp ./src/lexer/lexer.cpp 
EXPR_SRC   = ./src/parser/expr/binary_expr.cpp  ./src/parser/expr/grouping_expr.cpp ./src/parser/expr/literal_expr.cpp ./src/parser/expr/unary_expr.cpp 
SOURCE     = ${MAIN_SRC} ${LEXER_SRC} ${EXPR_SRC}
FLAGS      = -Wall -Wextra -Wno-unused-variable -Wno-unused-parameter

all:
	${COMPILER} ${SOURCE} -o ${OUTPUT} ${FLAGS}