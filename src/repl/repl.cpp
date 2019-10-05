#include "repl.h"

#include <iostream>
#include <memory>

#include "../lexer/lexer.h"
#include "../parser/parser.h"
#include "../expr/expr.h"
#include "../stmt/statement.h"
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

        std::cout << "Expressão: " << _cmd_to_exec << "\n\n";

        _interpreter.interpret(_cmd_to_exec);
        std::cout << "\nMemória: \n" << _interpreter.print_memory() << std::endl;

        // std::cout << expr->eval() << std::endl;
    }

    void Repl::quit() {
        std::cout << "\nBye.";

        _is_running = false;
    }
}