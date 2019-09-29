#include "expr.h"

namespace Cerberus {
    LiteralExpr::LiteralExpr(std::unique_ptr<Token> literal) : 
        _literal(std::move(literal)),
        _number(Number(*_literal))
    {
    }

    double LiteralExpr::eval() {
        return _number.get_value();
    }

    std::string LiteralExpr::print() const {
        return _literal->lexeme();
    }

    const Token& LiteralExpr::get_literal() {
        return *_literal.get();
    }
}