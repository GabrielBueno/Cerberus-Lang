#include "expr_visitor.h"

#include <sstream>

namespace Cerberus {
    ExprVisitor::ExprVisitor()  {}
    ExprVisitor::~ExprVisitor() {}

    std::string ExprVisitor::visit(BinaryExpr *expr) {
        return print(expr->get_operator()->lexeme(), expr->get_left_expr(), expr->get_right_expr());
    }

    std::string ExprVisitor::visit(UnaryExpr *expr) {
        return print(expr->get_operator()->lexeme(), expr->get_expr());
    }

    std::string ExprVisitor::visit(LiteralExpr *expr) {
        return print(expr->get_literal()->lexeme());
    }

    std::string ExprVisitor::visit(GroupingExpr *expr) {
        return print("group", expr->get_expr());
    }

    std::string ExprVisitor::print(std::string literal) {
        std::stringstream expr_stream;

        expr_stream << "( " << literal << " )";

        return expr_stream.str();
    }

    std::string ExprVisitor::print(std::string expr_operator, Expr *expr) {
        std::stringstream expr_stream;

        expr_stream << "(" << expr_operator << " " << expr->accept(this) << ")";

        return expr_stream.str();
    }

    std::string ExprVisitor::print(std::string expr_operator, Expr *left_expr, Expr *right_expr) {
        std::stringstream expr_stream;

        expr_stream << "(" << expr_operator << " " << left_expr->accept(this) << " " << right_expr->accept(this) << ")";

        return expr_stream.str();
    }
}