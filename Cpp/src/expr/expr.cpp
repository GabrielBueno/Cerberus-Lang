#include "expr.h"

namespace Cerberus {
    Expr::Expr() {}

    double Expr::eval() {
        return 0.0;
    }

    double Expr::eval(Interpreter* interpreter) {
        return 0.0;
    }

    std::string Expr::print() const {
        return "";
    }
}