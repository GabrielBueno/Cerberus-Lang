#include "debugger.h"

#include <iostream>

namespace Cerberus {
    void Debugger::print(const std::vector<Token>& tokens) {
        for (unsigned int i = 0; i < tokens.size(); i++) {
            const Cerberus::Token& token = tokens[i];

            std::cout << "(" << token.type() << ", " << "\"" << token.lexeme() << "\"" << ")\n";
        }
    }
}