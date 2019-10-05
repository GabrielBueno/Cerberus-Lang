#ifndef CERBERUS_EXPR_H_
#define CERBERUS_EXPR_H_

#include <string>
#include <sstream>
#include <memory>

#include "../token/token.h"
#include "../data/number.h"
#include "../interpreter/interpreter.h"

namespace Cerberus {
    class Expr {
    public:
        Expr();

        virtual double eval();
        virtual double eval(Interpreter*);
        virtual std::string print() const;
    };

    class BinaryExpr : public Expr {
    public:
        BinaryExpr(std::unique_ptr<Expr> left, std::unique_ptr<Token> expr_operator, std::unique_ptr<Expr> right);

        const Expr& get_left_expr();
        const Expr& get_right_expr();
        const Token& get_operator();

        double eval();
        double eval(Interpreter*);
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

        double eval();
        double eval(Interpreter*);
        std::string print() const;

    private:
        std::unique_ptr<Token> _operator;
        std::unique_ptr<Expr> _expr;
    };

    class GroupingExpr : public Expr {
    public:
        GroupingExpr(std::unique_ptr<Expr> expr);

        const Expr& get_expr();

        double eval();
        double eval(Interpreter*);
        std::string print() const;

    private:
        std::unique_ptr<Expr> _expr;
    };

    class LiteralExpr : public Expr {
    public:
        LiteralExpr(std::unique_ptr<Token> literal);

        const Token& get_literal();

        double eval();
        double eval(Interpreter*);
        std::string print() const;

    private:
        std::unique_ptr<Token> _literal;
        Number _number;
    };
}

#endif