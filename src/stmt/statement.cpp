#include "statement.h"

#include <sstream>

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

	std::string Statement::describe() const {
		return "Abstract statement";
	}

	std::string VariableStatement::describe() const {
		std::stringstream stream;

		stream << "Declarando variável " << _identifier->lexeme();

		if (_initial_expr)
			stream << " com valor " << _initial_expr->eval() << std::endl;
		else
			stream << std::endl;

		return stream.str();
	}

	std::string ExpressionStatement::describe() const {
		std::stringstream stream;

		stream << "Executando expressão... Com valor final " << _expr->eval();

		return stream.str();
	}

	std::string PrintStatement::describe() const {
		std::stringstream stream;

		stream << "Exibindo na tela expressão... Com valor final " << _expr->eval();

		return stream.str();
	}
}