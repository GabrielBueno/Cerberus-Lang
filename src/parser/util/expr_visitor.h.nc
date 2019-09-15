#ifndef CERBERUS_EXPR_VISITOR_H_
#define CERBERUS_EXPR_VISITOR_H_

#include <string>

#include "../expr/expr.h"

namespace Cerberus
{
    class ExprVisitor {
    public:
        ExprVisitor();
        ~ExprVisitor();

        std::string visit(BinaryExpr   *expr);
        std::string visit(UnaryExpr    *expr);
        std::string visit(LiteralExpr  *expr);
        std::string visit(GroupingExpr *expr);

    private:
        std::string print(std::string literal);
        std::string print(std::string expr_operator, Expr *expr);
        std::string print(std::string expr_operator, Expr *left_expr, Expr *right_expr);
    };
}


#endif