#include "expr.h"

namespace Cerberus {
    GroupingExpr::GroupingExpr(std::unique_ptr<Expr> expr) :
         _expr(std::move(expr)) {
    }

    double GroupingExpr::eval() {
        return _expr->eval();
    }

    double GroupingExpr::eval(Interpreter* interpreter) {
        return _expr->eval(interpreter);
    }

    std::string GroupingExpr::print() const {
        std::stringstream expr_stream;

        expr_stream << "(" << _expr->print() << ")";

        return expr_stream.str();
    }

    const Expr& GroupingExpr::get_expr() {
        return *_expr.get();
    }
}