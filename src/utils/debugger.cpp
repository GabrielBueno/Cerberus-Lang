#include "debugger.h"

#include <iostream>

namespace Cerberus {
    void Debugger::print(const std::vector<Token>& tokens) {
        for (unsigned int i = 0; i < tokens.size(); i++) {
            const Cerberus::Token& token = tokens[i];

            std::cout << "(" << token.type() << ", " << "\"" << token.lexeme() << "\"" << ")\n";
        }
    }

    void Debugger::print(const Expr& expr) {
        std::cout << expr.print() << std::endl;
    }

    void Debugger::print(const Statement& stmt) {
    	std::cout << stmt.describe() << std::endl;
    }
}