#include "expr.h"

namespace Cerberus {
    LiteralExpr::LiteralExpr(Token* literal) : _literal(literal) {
    }

    std::string LiteralExpr::print() {
        return _literal->lexeme();
    }

    Token* LiteralExpr::get_literal() {
        return _literal;
    }
}