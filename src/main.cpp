#include <iostream>
#include <memory>
#include <vector>

#include "lexer/lexer.h"
#include "parser/parser.h"
#include "parser/expr/expr.h"

int main(int argc, char **argv) {
    if (argc >= 2) {
        Cerberus::Lexer lexer(argv[1]);

        std::vector<Cerberus::Token> tokens = lexer.tokenize();

        Cerberus::Parser parser(std::move(tokens));

        std::unique_ptr<Cerberus::Expr> expr = parser.parse();

        std::cout << expr->print() << std::endl;
    } else {
        std::cout << "cerberus <expression>";
    }

    return 0;
}