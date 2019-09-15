#include <iostream>
#include <memory>

#include "lexer/lexer.h"
#include "parser/expr/expr.h"

int main(int argc, char **argv) {
    // if (argc >= 2) {
    //     cerberus::Lexer lexer(argv[1]);

    //     lexer.tokenize();
    //     lexer.show_tokens();
    // }

    Cerberus::Token t1 = Cerberus::Token(Cerberus::INTEGER_LITERAL, "5");
    Cerberus::Token t2 = Cerberus::Token(Cerberus::INTEGER_LITERAL, "6");
    Cerberus::Token t3 = Cerberus::Token(Cerberus::PLUS);

    Cerberus::LiteralExpr l1 = Cerberus::LiteralExpr(std::make_unique<Cerberus::Token>(Cerberus::INTEGER_LITERAL, "5"));
    Cerberus::LiteralExpr l2 = Cerberus::LiteralExpr(std::make_unique<Cerberus::Token>(Cerberus::INTEGER_LITERAL, "6"));

    Cerberus::BinaryExpr b1 = Cerberus::BinaryExpr(
        std::make_unique<Cerberus::LiteralExpr>(std::make_unique<Cerberus::Token>(Cerberus::INTEGER_LITERAL, "5")),
        std::make_unique<Cerberus::Token>(Cerberus::PLUS),
        std::make_unique<Cerberus::LiteralExpr>(std::make_unique<Cerberus::Token>(Cerberus::INTEGER_LITERAL, "6"))
    );
    
    std::cout << b1.print();

    return 0;
}