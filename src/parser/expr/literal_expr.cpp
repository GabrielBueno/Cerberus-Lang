#include "expr.h"

namespace Cerberus {
    LiteralExpr::LiteralExpr(std::unique_ptr<Token> literal) : 
        _literal(std::move(literal)) {
    }

    std::string LiteralExpr::print() {
        return _literal->lexeme();
    }

    const Token& LiteralExpr::get_literal() {
        return *_literal.get();
    }
}