#ifndef CERBERUS_STATEMENT_H_
#define CERBERUS_STATEMENT_H_

#include <memory>

#include "../expr/expr.h"

namespace Cerberus {
	class Statement {};

	/* --- Variable --- */

	class VariableStatement : public Statement {
	public:
		VariableStatement(std::unique_ptr<Token> identifier, std::unique_ptr<Expr> initial_expr);

	private:
		std::unique_ptr<Token> _identifier;
		std::unique_ptr<Expr>  _initial_expr;
	};

	/* --- Expression --- */

	class ExpressionStatement : public Statement {
	public:
		ExpressionStatement(std::unique_ptr<Expr> expr);

	private:
		std::unique_ptr<Expr> _expr;
	};

	/* --- Print --- */

	class PrintStatement : public Statement {
	public:
		PrintStatement(std::unique_ptr<Expr> expr);

	private:
		std::unique_ptr<Expr> _expr;
	};
}

#endif