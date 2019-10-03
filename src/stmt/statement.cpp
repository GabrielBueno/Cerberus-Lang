#include "statement.h"

#include <sstream>
#include <iostream>

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

	/* -------------------------------------------------- */

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


	/* -------------------------------------------------- */

	void Statement::run(Interpreter*) const {}

	void VariableStatement::run(Interpreter* interpreter) const {
		if (interpreter == nullptr)
			return;

		interpreter->put_in_memory(_identifier->lexeme(), _initial_expr->eval());
	}

	void ExpressionStatement::run(Interpreter* interpreter) const {
		if (interpreter == nullptr)
			return;

		
	}

	void PrintStatement::run(Interpreter* interpreter) const {
		if (interpreter == nullptr)
			return;

		std::cout << _expr->eval() << std::endl;
	}
}