#ifndef CERBERUS_REPL_H_
#define CERBERUS_REPL_H_

#include <string>

namespace Cerberus {
    class Repl {
    public:
        Repl();
        ~Repl();

        void begin();

    private:
        void read_cmd();
        void exec_cmd();

        std::string _cmd_to_exec;
    };
}

#endif