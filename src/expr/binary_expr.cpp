#include "expr.h"

namespace Cerberus {
    BinaryExpr::BinaryExpr(std::unique_ptr<Expr> left, std::unique_ptr<Token> expr_operator, std::unique_ptr<Expr> right) : 
        _left_expr(std::move(left)),
        _operator(std::move(expr_operator)),
        _right_expr(std::move(right)) 
    {
    }

    double BinaryExpr::eval() {
        TokenType type              = _operator->type();
        double left_expr_evaluated  = _left_expr->eval();
        double right_expr_evaluated = _right_expr->eval();

        if (type == PLUS)
            return left_expr_evaluated + right_expr_evaluated;

        if (type == MINUS)
            return left_expr_evaluated - right_expr_evaluated;

        if (type == STAR)
            return left_expr_evaluated * right_expr_evaluated;

        if (type == SLASH)
            return left_expr_evaluated / right_expr_evaluated;

        return left_expr_evaluated;
    }

    double BinaryExpr::eval(Interpreter* interpreter) {
        TokenType type              = _operator->type();
        double left_expr_evaluated  = _left_expr->eval(interpreter);
        double right_expr_evaluated = _right_expr->eval(interpreter);

        if (type == PLUS)
            return left_expr_evaluated + right_expr_evaluated;

        if (type == MINUS)
            return left_expr_evaluated - right_expr_evaluated;

        if (type == STAR)
            return left_expr_evaluated * right_expr_evaluated;

        if (type == SLASH)
            return left_expr_evaluated / right_expr_evaluated;

        return left_expr_evaluated;
    }

    std::string BinaryExpr::print() const {
        std::stringstream expr_stream;

        expr_stream << "(" << _operator->lexeme() << " " << _left_expr->print() << " " << _right_expr->print() << ")";

        return expr_stream.str();
    }

    const Expr& BinaryExpr::get_left_expr() {
        return *_left_expr.get();
    }

    const Expr& BinaryExpr::get_right_expr() {
        return *_right_expr.get();
    }

    const Token& BinaryExpr::get_operator() {
        return *_operator.get();
    }
}