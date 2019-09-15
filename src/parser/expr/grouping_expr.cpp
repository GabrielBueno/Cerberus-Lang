#include "expr.h"

namespace Cerberus {
    GroupingExpr::GroupingExpr(Expr* expr) : _expr(expr) {
    }

    std::string GroupingExpr::print() {
        std::stringstream expr_stream;

        expr_stream << "(" << _expr->print() << ")";

        return expr_stream.str();
    }

    Expr* GroupingExpr::get_expr() {
        return _expr;
    }
}