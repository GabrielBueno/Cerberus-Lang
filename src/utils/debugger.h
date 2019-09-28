#ifndef CERBERUS_DEBUGGER_H_
#define CERBERUS_DEBUGGER_H_

#include <vector>
#include <memory>

#include "../lexer/lexer.h"
#include "../token/token.h"

namespace Cerberus {
    class Debugger {
    public:
        static void print(const std::vector<Token>&);

    private:
        Debugger();
    };
}

#endif