#include "number.h"

#include <string>

namespace Cerberus {
    Number::Number(const Token& token) : _value(0.0) {
        parse(token);
    }

    void Number::parse(const Token& token) {
        std::string lexeme          = token.lexeme();
        bool found_decimal          = false;
        unsigned int decimal_digits = 0;
        double parsed_value         = 0.0;

        for (unsigned int i = 0; i < lexeme.length(); i++) {
            char current_ch = lexeme[i];
            int digit       = current_ch - '0';    

            if (current_ch == '.') {
                found_decimal = true;
                continue;
            }

            if (found_decimal) {
                decimal_digits += 1;

                parsed_value += (digit / (10 * decimal_digits));
            } else {
                parsed_value = (parsed_value * 10) + digit;
            }
        }

        _value = parsed_value;
    }
}