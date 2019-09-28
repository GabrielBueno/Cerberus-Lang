#ifndef CERBERUS_PARSER_H_
#define CERBERUS_PARSER_H_

#include <vector>
#include <memory>

#include "../token/token.h"
#include "./expr/expr.h"

namespace Cerberus {
    class Parser {
    public:
        Parser(const std::vector<Token>& tokens);

        std::unique_ptr<Expr> parse();

    private:
        std::unique_ptr<Expr> expression();
        std::unique_ptr<Expr> sum();
        std::unique_ptr<Expr> term();
        std::unique_ptr<Expr> factor();
        std::unique_ptr<Expr> unary();
        std::unique_ptr<Expr> literal();

        /**
         * Retorna o Token atual, e avança uma posição na lista de Tokens
         */
        const Token& consume();

        /**
         * Retorna o Token atual, sem alterar a posição de leitura da lista de Tokens
         */
        const Token& current();

        /**
         * Retorna o Token anterior na lista
         */
        const Token& previous();

        /**
         * Retorna o próximo Token na lista
         */
        const Token& next();

        /**
         * Verifica se o Token apontado é de um tipo específico
         */
        bool match(TokenType type);

        /**
         * Verifica se a lista de Tokens já acabou
         */
        bool ended();

        const std::vector<Token>& _tokens;
        const Token _eof_token;

        unsigned int _current;
    };
}

#endif