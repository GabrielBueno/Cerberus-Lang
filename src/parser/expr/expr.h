#ifndef CERBERUS_EXPR_H_
#define CERBERUS_EXPR_H_

#include <string>
#include <sstream>
#include <memory>

#include "../../token/token.h"
// #include "../util/expr_visitor.h"

namespace Cerberus {
    class Expr {
    public:
        virtual std::string print() const;
        Expr();
    };

    class BinaryExpr : public Expr {
    public:
        BinaryExpr(std::unique_ptr<Expr> left, std::unique_ptr<Token> expr_operator, std::unique_ptr<Expr> right);

        const Expr& get_left_expr();
        const Expr& get_right_expr();
        const Token& get_operator();

        std::string print() const;

    private:
        std::unique_ptr<Expr> _left_expr;
        std::unique_ptr<Token> _operator;
        std::unique_ptr<Expr> _right_expr;
    };

    class UnaryExpr : public Expr {
    public:
        UnaryExpr(std::unique_ptr<Token> expr_operator, std::unique_ptr<Expr> expr);

        const Expr& get_expr();
        const Token& get_operator();

        std::string print() const;

    private:
        std::unique_ptr<Token> _operator;
        std::unique_ptr<Expr> _expr;
    };

    class GroupingExpr : public Expr {
    public:
        GroupingExpr(std::unique_ptr<Expr> expr);

        const Expr& get_expr();

        std::string print() const;

    private:
        std::unique_ptr<Expr> _expr;
    };

    class LiteralExpr : public Expr {
    public:
        LiteralExpr(std::unique_ptr<Token> literal);

        const Token& get_literal();

        std::string print() const;

    private:
        std::unique_ptr<Token> _literal;
    };
}

#endif