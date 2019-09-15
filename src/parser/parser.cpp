#include "parser.h"

namespace Cerberus {
    Parser::Parser(const std::vector<Token>& tokens) : 
        _tokens(tokens), 
        _current(0),
        _eof_token(Token(END_OF_FILE))
    {}

    /* Métodos públicos */

    std::unique_ptr<Expr> Parser::parse() {
        return expression();
    }

    std::unique_ptr<Expr> Parser::expression() {
        return equality();
    }

    std::unique_ptr<Expr> Parser::equality() {
        std::unique_ptr<Expr> expr = comparison();

        if (match(EQUAL_EQUAL) || match(NOT_EQUAL)) {
            
        }

        return expr;
    }
    
    std::unique_ptr<Expr> Parser::comparison() {

    }
    
    std::unique_ptr<Expr> Parser::addition() {

    }
    
    std::unique_ptr<Expr> Parser::multiplication() {

    }
    
    std::unique_ptr<Expr> Parser::unary() {

    }
    
    std::unique_ptr<Expr> Parser::literal() {

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