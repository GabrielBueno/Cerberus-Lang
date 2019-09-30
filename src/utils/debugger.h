#ifndef CERBERUS_DEBUGGER_H_
#define CERBERUS_DEBUGGER_H_

#include <vector>
#include <memory>

#include "../lexer/lexer.h"
#include "../token/token.h"
#include "../expr/expr.h"
#include "../stmt/statement.h"

namespace Cerberus {
    class Debugger {
    public:
        static void print(const std::vector<Token>&);
        static void print(const Expr&);
        static void print(const Statement&);

    private:
        Debugger();
    };
}

#endif