#include "repl.h"

#include <iostream>
#include <memory>

#include "../lexer/lexer.h"
#include "../parser/parser.h"
#include "../expr/expr.h"
#include "../utils/debugger.h"

namespace Cerberus {
    Repl::Repl() : _cmd_to_exec("") , _is_running(false)
    {
    }

    Repl::~Repl() {}

    void Repl::begin() {
        _is_running = true;

        while (_is_running) {
            read_cmd();
            exec_cmd();
        }
    }

    void Repl::read_cmd() {
        std::cout << ">> ";
        std::getline(std::cin, _cmd_to_exec);
    }

    void Repl::exec_cmd() {
        if (_cmd_to_exec == "quit") {
            quit();
            return;
        }

        std::cout << "Parsing expression: " << _cmd_to_exec << std::endl;

        Lexer lexer(_cmd_to_exec);
        std::unique_ptr<std::vector<Token>> tokens = lexer.tokens();

        Parser parser(*tokens);
        std::unique_ptr<Expr> expr = parser.parse();

        // Debug
        std::cout << std::endl;
        Debugger::print(*tokens);
        std::cout << std::endl;
        Debugger::print(*expr);
        std::cout << std::endl;

        std::cout << expr->eval() << std::endl;
    }

    void Repl::quit() {
        std::cout << "\nBye.";

        _is_running = false;
    }
}