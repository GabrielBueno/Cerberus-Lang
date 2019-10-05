#ifndef CERBERUS_LEXER_H_
#define CERBERUS_LEXER_H_

#include <vector>
#include <unordered_map>
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

        void load_reserved_keywords_map();
        TokenType identifier_type(const std::string& identifier);

        unsigned int _current_char;
        std::string _input;
        std::unordered_map<std::string, TokenType> _reserved_keywords;
        std::unique_ptr<std::vector<Token>> _tokens;
    };
}

#endif
