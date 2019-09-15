#include "expr.h"

namespace Cerberus {
    UnaryExpr::UnaryExpr(Token* exprOperator, Expr* expr) : 
    _operator(exprOperator),
    _expr(expr)
    {
    }

    std::string UnaryExpr::print() {
        std::stringstream expr_stream;

        expr_stream << "( " << _operator->lexeme() << " " << _expr->print() << ")";

        return expr_stream.str();
    }

    Expr* UnaryExpr::get_expr() {
        return _expr;
    }

    Token* UnaryExpr::get_operator() {
        return _operator;
    }
}