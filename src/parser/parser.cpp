#include "parser.h"

#include <iostream>
#include <cstdlib>

namespace Cerberus {
    Parser::Parser(const std::vector<Token>& tokens) : 
        _tokens(tokens), 
        _eof_token(Token(END_OF_FILE)),
        _current(0)
    {}

    /* Métodos públicos */

    std::unique_ptr<Expr> Parser::parse() {
        return expression();
    }

    /* Métodos privados */

    std::unique_ptr<Expr> Parser::expression() {
        return sum();
    }

    std::unique_ptr<Expr> Parser::sum() {
        std::unique_ptr<Expr> expr = term();

        while (match(PLUS) || match(MINUS)) {
            Token current_token = consume();

            expr = std::make_unique<BinaryExpr>(std::move(expr), std::make_unique<Token>(current_token), term());
        }

        return expr;
    }

    std::unique_ptr<Expr> Parser::term() {
        std::unique_ptr<Expr> expr = factor();

        while (match(STAR) || match(SLASH)) {
            Token current_token = consume();

            expr = std::make_unique<BinaryExpr>(std::move(expr), std::make_unique<Token>(current_token), factor());
        }

        return expr;
    }

    std::unique_ptr<Expr> Parser::factor() {
        if (match(LEFT_PAREN)) {
            consume();

            std::unique_ptr<GroupingExpr> expr = std::make_unique<GroupingExpr>(expression());

            consume();

            return expr;
        }
        

        return unary();
    }

    std::unique_ptr<Expr> Parser::unary() {
        if (match(MINUS))
            return std::make_unique<UnaryExpr>(std::make_unique<Token>(consume()), literal());

        return literal();
    }

    std::unique_ptr<Expr> Parser::literal() {
        return std::make_unique<LiteralExpr>(std::make_unique<Token>(consume()));
    }

    const Token& Parser::consume() {
        if (ended())
            return _eof_token;

        return _tokens[_current++];
    }

    const Token& Parser::current() {
        if (ended())
            return _eof_token;

        return _tokens[_current];
    }

    const Token& Parser::next() {
        if (ended() || _tokens.size() <= _current + 1)
            return _eof_token;

        return _tokens[_current + 1];
    }

    const Token& Parser::previous() {
        if (_current == 0)
            return _eof_token;

        return _tokens[_current - 1];
    }

    bool Parser::match(TokenType type) {
        return current().type() == type;
    }

    bool Parser::ended() {
        return _tokens.size() <= _current;
    }
}