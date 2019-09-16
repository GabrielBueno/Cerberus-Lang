#include "token.h"

#include <string>

namespace Cerberus {
    Token::Token(TokenType type) : _type(type) {}
    Token::Token(TokenType type, std::string lexeme) : _type(type), _lexeme(lexeme) {}
    Token::Token(const Token& token) : _type(token.type()), _lexeme(token.lexeme()) {}

    Token::~Token() {}

    void Token::in_line(unsigned int line) {
        _line = line;
    }

    void Token::in_col(unsigned int col) {
        _col = col;
    }

    unsigned int Token::get_line() {
        return _line;
    }

    unsigned int Token::get_col() {
        return _col;
    }

    TokenType Token::type() const {
        return _type;
    }

    std::string Token::lexeme() const {
        return _lexeme;
    }
}