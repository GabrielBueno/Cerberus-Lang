#include "parser.h"

namespace Cerberus {
    Parser::Parser(const std::vector<Token>& tokens) : 
        _tokens(tokens), 
        _current(0),
        _eof_token(Token(END_OF_FILE))
    {}

    /* Métodos privados */

    const Token& Parser::consume() {
        if (ended())
            return _eof_token;

        return _tokens[_current++];
    }

    const Token& Parser::peek() {
        if (ended())
            return _eof_token;

        return _tokens[_current];
    }

    bool Parser::match(TokenType type) {
        return peek().type() == type;
    }

    bool Parser::ended() {
        return _tokens.size() <= _current;
    }
}