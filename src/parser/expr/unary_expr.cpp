#include "expr.h"

namespace cerberus {
    UnaryExpr::UnaryExpr(Token exprOperator, Expr expr) : 
    _operator(exprOperator),
    _expr(expr)
    {
    }
}