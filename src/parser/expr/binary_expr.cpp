#include "expr.h"

namespace Cerberus {
    BinaryExpr::BinaryExpr(Expr* left, Token* expr_operator, Expr* right) : 
    _left_expr(left),
    _operator(expr_operator),
    _right_expr(right) 
    {
    }

    std::string BinaryExpr::print() {
        std::stringstream expr_stream;

        expr_stream << "(" << _operator->lexeme() << " " << _left_expr->print() << " " << _right_expr->print() << ")";

        return expr_stream.str();
    }

    Expr* BinaryExpr::get_left_expr() {
        return _left_expr;
    }

    Expr* BinaryExpr::get_right_expr() {
        return _right_expr;
    }

    Token* BinaryExpr::get_operator() {
        return _operator;
    }
}