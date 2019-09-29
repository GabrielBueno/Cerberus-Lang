#ifndef CERBERUS_NUMBER_H_
#define CERBERUS_NUMBER_H_

#include "../token/token.h"

namespace Cerberus {
    class Number {
    public:
        Number(const Token&);

        double get_value();
        double operate(const Token& operation);
        double operate(const Token& operation, double operand);
    private:
        void parse(const Token&);

        double _value;
    };
}

#endif