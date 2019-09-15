#include "expr.h"

namespace Cerberus {
    UnaryExpr::UnaryExpr(std::unique_ptr<Token> expr_operator, std::unique_ptr<Expr> expr) : 
        _operator(std::move(expr_operator)),
        _expr(std::move(expr))
    {
    }

    std::string UnaryExpr::print() {
        std::stringstream expr_stream;

        expr_stream << "( " << _operator->lexeme() << " " << _expr->print() << ")";

        return expr_stream.str();
    }

    const Expr& UnaryExpr::get_expr() {
        return *_expr.get();
    }

    const Token& UnaryExpr::get_operator() {
        return *_operator.get();
    }
}