#ifndef CERBERUS_DEBUGGER_H_
#define CERBERUS_DEBUGGER_H_

#include <vector>
#include <memory>

#include "../lexer/lexer.h"
#include "../token/token.h"
#include "../parser/expr/expr.h"

namespace Cerberus {
    class Debugger {
    public:
        static void print(const std::vector<Token>&);
        static void print(const Expr&);

    private:
        Debugger();
    };
}

#endif