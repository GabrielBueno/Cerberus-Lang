COMPILER   = g++
OUTPUT     = ./bin/unix/cerberus
FLAGS      = -Wall -Wextra -Wno-unused-variable -Wno-unused-parameter

MAIN_SRC   = ./src/main.cpp
LEXER_SRC  = ./src/token/token.cpp ./src/lexer/lexer.cpp 
PARSER_SRC = ./src/parser/parser.cpp
EXPR_SRC   = ./src/expr/expr.cpp ./src/expr/binary_expr.cpp  ./src/expr/grouping_expr.cpp ./src/expr/literal_expr.cpp ./src/expr/unary_expr.cpp
STMT_SRC   = ./src/stmt/statement.cpp
REPL_SRC   = ./src/repl/repl.cpp
DATA_SRC   = ./src/data/number.cpp
UTILS_SRC  = ./src/utils/debugger.cpp

SOURCE     = ${MAIN_SRC} ${LEXER_SRC} ${PARSER_SRC} ${EXPR_SRC} ${STMT_SRC} ${DATA_SRC} ${REPL_SRC} ${UTILS_SRC}

all:
	${COMPILER} ${SOURCE} -g -o ${OUTPUT} ${FLAGS}