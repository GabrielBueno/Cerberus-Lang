#include "expr.h"

namespace cerberus {
    BinaryExpr::BinaryExpr(Expr left, Token exprOperator, Expr right) : 
    _leftExpr(left),
    _operator(exprOperator),
    _rightExpr(right) 
    {
    }
}