#include "parser.h"

namespace Cerberus {
    Parser::Parser(const std::vector<Token>& tokens) : 
        _tokens(tokens), 
        _current(0),
        _eof_token(Token(END_OF_FILE))
    {}

    /* Métodos públicos */

    Expr Parser::parse() {
        return expression();
    }

    Expr Parser::expression() {
        return equality();
    }

    Expr Parser::equality() {
        Expr expr = comparison();

        if (match(EQUAL_EQUAL) || match(NOT_EQUAL)) {
            
        }

        return expr;
    }
    
    Expr Parser::comparison() {

    }
    
    Expr Parser::addition() {

    }
    
    Expr Parser::multiplication() {

    }
    
    Expr Parser::unary() {

    }
    
    Expr Parser::literal() {

    }

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