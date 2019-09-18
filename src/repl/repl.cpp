#include "repl.h"

#include <iostream>
#include <memory>

#include "../lexer/lexer.h"
#include "../parser/parser.h"
#include "../parser/expr/expr.h"

namespace Cerberus {
    Repl::Repl() : _cmd_to_exec("") 
    {
    }

    Repl::~Repl() {}

    void Repl::begin() {
        while (true) {
            read_cmd();
            exec_cmd();
        }
    }

    void Repl::read_cmd() {
        std::cout << ">> ";
        std::getline(std::cin, _cmd_to_exec);

        std::cout << "Parsing expression: " << _cmd_to_exec << std::endl;
    }

    void Repl::exec_cmd() {
        Lexer lexer(_cmd_to_exec);
        Parser parser(lexer.tokenize());

        // DEBUG

        std::unique_ptr<Expr> expr = parser.parse();

        std::cout << expr->print();
    }
}