#include "interpreter.h"

#include <iostream>
#include <sstream>

#include "../lexer/lexer.h"
#include "../parser/parser.h"
#include "../stmt/statement.h"
#include "../utils/debugger.h"

namespace Cerberus {
	Interpreter::Interpreter() {}

	void Interpreter::interpret(std::string code) {
		Lexer lexer(code);
        std::unique_ptr<std::vector<Token>> tokens = lexer.tokens();

        Parser parser(*tokens);
        std::unique_ptr<Statement> stmt = parser.parse();

        // Debug
        std::cout << "Tokens: " << std::endl;
        Debugger::print(*tokens);
        std::cout << std::endl;
        // Debugger::print(*stmt);
        // std::cout << std::endl;

        stmt->run(this);
	}

	void Interpreter::put_in_memory(std::string key, double val) {
		_memory.put(key, val);
	}

	double Interpreter::get_in_memory(std::string key) {
		return _memory.get_double(key);
	}

	std::string Interpreter::print_memory() {
		return _memory.print();
	}
}