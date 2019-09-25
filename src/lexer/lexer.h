#ifndef CERBERUS_LEXER_H_
#define CERBERUS_LEXER_H_

#include <vector>
#include <memory>
#include <string>

#include "../token/token.h"
#include "../token/token_type.h"

namespace Cerberus {
    class Lexer {
    public:
        Lexer(std::string input);
        ~Lexer();

        std::unique_ptr<std::vector<Token>> tokens();

    private:
        void tokenize_input();

        char current();
        char previous();
        char next();
        char consume();

        bool current_is(char);
        bool previous_is(char);
        bool next_is(char);

        bool is_alpha(char);
        bool is_numeric(char);
        bool is_alphanumeric(char);

        bool input_ended();

        void add_number();
        void add_identifier();

        void add_token(Token);
        void add_token(TokenType);
        void add_token(TokenType, std::string);

        unsigned int _current_char;
        std::string _input;
        std::unique_ptr<std::vector<Token>> _tokens;
    };
}

#endif
