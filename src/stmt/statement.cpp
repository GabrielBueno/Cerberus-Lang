#include "statement.h"

namespace Cerberus {
	VariableStatement::VariableStatement(std::unique_ptr<Token> identifier, std::unique_ptr<Expr> expr) :
		_identifier(std::move(identifier)),
		_initial_expr(std::move(expr))
	{}

	ExpressionStatement::ExpressionStatement(std::unique_ptr<Expr> expr) :
		_expr(std::move(expr))
	{}

	PrintStatement::PrintStatement(std::unique_ptr<Expr> expr) :
		_expr(std::move(expr))
	{}
}