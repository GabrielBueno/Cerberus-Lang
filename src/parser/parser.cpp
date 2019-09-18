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
        return equality();
    }

    std::unique_ptr<Expr> Parser::equality() {
        std::unique_ptr<Expr> expr = comparison();

        while (match(EQUAL_EQUAL) || match(NOT_EQUAL)) {
            const Token& equality_operator = consume();

            expr = std::make_unique<BinaryExpr>(std::move(expr), std::make_unique<Token>(equality_operator), comparison());
        }

        return expr;
    }
    
    std::unique_ptr<Expr> Parser::comparison() {
        std::unique_ptr<Expr> expr = addition();

        while (match(GREATER) || match(GREATER_EQUAL) || match(LESSER) || match(LESSER_EQUAL)) {
            const Token& comparison_operator = consume();

            expr = std::make_unique<BinaryExpr>(std::move(expr), std::make_unique<Token>(comparison_operator), addition());
        }

        return expr;
    }
    
    std::unique_ptr<Expr> Parser::addition() {
        std::unique_ptr<Expr> expr = multiplication();

        while (match(PLUS) || match(MINUS)) {
            const Token& addition_operator = consume();

            expr = std::make_unique<BinaryExpr>(std::move(expr), std::make_unique<Token>(addition_operator), multiplication());
        }

        return expr;
    }
    
    std::unique_ptr<Expr> Parser::multiplication() {
        std::unique_ptr<Expr> expr = unary();

        while (match(STAR) || match(SLASH)) {
            const Token& multiplication_operator = consume();

            expr = std::make_unique<BinaryExpr>(std::move(expr), std::make_unique<Token>(multiplication_operator), unary());
        }

        return expr;
    }
    
    std::unique_ptr<Expr> Parser::unary() {
        if (match(NOT) || match(MINUS)) {
            const Token& unary_operator = consume();

            return std::make_unique<UnaryExpr>(std::make_unique<Token>(unary_operator), unary());
        }

        return literal();
    }
    
    std::unique_ptr<Expr> Parser::literal() {
        if (match(LEFT_PAREN)) {
            // Se livra do '('
            consume();
            
            std::unique_ptr<Expr> grouped_expr = expression();

            if (!match(RIGHT_PAREN)) {
                // TODO: Tratamento de erros
                std::cout << "Closing ) expected on expression." << std::endl;
                // exit(1);
            }

            // Se livra do ')'
            consume();

            return grouped_expr;
        }

        std::unique_ptr<Expr> literal_expr = std::make_unique<LiteralExpr>(std::make_unique<Token>(consume()));

        return literal_expr;
    }

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