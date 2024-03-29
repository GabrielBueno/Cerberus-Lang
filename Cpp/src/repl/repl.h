#ifndef CERBERUS_REPL_H_
#define CERBERUS_REPL_H_

#include <string>

#include "../interpreter/interpreter.h"

namespace Cerberus {
    class Repl {
    public:
        Repl();
        ~Repl();

        void begin();

    private:
        void read_cmd();
        void exec_cmd();
        void quit();

        std::string _cmd_to_exec;
        bool _is_running;

        Interpreter _interpreter;
    };
}

#endif