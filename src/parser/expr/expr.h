#ifndef CERBERUS_EXPR_H_
#define CERBERUS_EXPR_H_

#include "../../token/token.h"

namespace cerberus {
    class Expr {};

    class BinaryExpr : Expr {
    public:
        BinaryExpr(Expr left, Token exprOperator, Expr right);

    private:
        Expr _leftExpr;
        Token _operator;
        Expr _rightExpr;
    };

    class UnaryExpr : Expr {
    public:
        UnaryExpr(Token exprOperator, Expr expr);

    private:
        Token _operator;
        Expr _expr;
    };

    class GroupingExpr : Expr {
    public:
        GroupingExpr(Expr expr);

    private:
        Expr _expr;
    };

    class LiteralExpr : Expr {
    public:
        LiteralExpr(Token literal);

    private:
        Token _literal;
    };
}

#endif