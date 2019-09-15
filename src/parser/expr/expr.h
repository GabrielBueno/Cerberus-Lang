#ifndef CERBERUS_EXPR_H_
#define CERBERUS_EXPR_H_

#include <string>
#include <sstream>

#include "../../token/token.h"
// #include "../util/expr_visitor.h"

namespace Cerberus {
    class Expr {
    public:
        virtual std::string print();
        Expr();
    };

    class BinaryExpr : public Expr {
    public:
        BinaryExpr(Expr* left, Token* expr_operator, Expr* right);

        Expr* get_left_expr();
        Expr* get_right_expr();
        Token* get_operator();

        std::string print();

    private:
        Expr* _left_expr;
        Token* _operator;
        Expr* _right_expr;
    };

    class UnaryExpr : public Expr {
    public:
        UnaryExpr(Token* expr_operator, Expr* expr);

        Expr* get_expr();
        Token* get_operator();

        std::string print();

    private:
        Token* _operator;
        Expr* _expr;
    };

    class GroupingExpr : public Expr {
    public:
        GroupingExpr(Expr* expr);

        Expr* get_expr();

        std::string print();

    private:
        Expr* _expr;
    };

    class LiteralExpr : public Expr {
    public:
        LiteralExpr(Token* literal);

        Token* get_literal();

        std::string print();

    private:
        Token* _literal;
    };
}

#endif