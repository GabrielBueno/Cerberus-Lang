#include <iostream>
#include <vector>
#include <memory>

#include "lexer/lexer.h"
#include "token/token.h"

int main(int argc, char **argv) {
    Cerberus::Lexer lex("1 + 2 * 896 + (5 * 98)");

    std::unique_ptr<std::vector<Cerberus::Token>> tokens = lex.tokens();

    for (unsigned int i = 0; i < tokens->size(); i++) {
        const Cerberus::Token& token = tokens->at(i);

        std::cout << "(" << token.type() << ", " << "\"" << token.lexeme() << "\"" << ")\n";
    }

    return 0;
}