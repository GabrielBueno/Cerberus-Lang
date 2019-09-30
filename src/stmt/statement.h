#ifndef CERBERUS_STATEMENT_H_
#define CERBERUS_STATEMENT_H_

#include <memory>
#include <string>

#include "../expr/expr.h"

namespace Cerberus {
	class Statement {
	public:
		virtual std::string describe() const;
	};

	/* --- Variable --- */

	class VariableStatement : public Statement {
	public:
		VariableStatement(std::unique_ptr<Token> identifier, std::unique_ptr<Expr> initial_expr);

		std::string describe() const;

	private:
		std::unique_ptr<Token> _identifier;
		std::unique_ptr<Expr>  _initial_expr;
	};

	/* --- Expression --- */

	class ExpressionStatement : public Statement {
	public:
		ExpressionStatement(std::unique_ptr<Expr> expr);

		std::string describe() const;

	private:
		std::unique_ptr<Expr> _expr;
	};

	/* --- Print --- */

	class PrintStatement : public Statement {
	public:
		PrintStatement(std::unique_ptr<Expr> expr);

		std::string describe() const;

	private:
		std::unique_ptr<Expr> _expr;
	};
}

#endif