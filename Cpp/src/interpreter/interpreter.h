#ifndef CERBERUS_INTERPRETER_H_
#define CERBERUS_INTERPRETER_H_

#include "../memory/memory.h"

namespace Cerberus {
	class Interpreter {
	public:
		Interpreter();

		void interpret(std::string);

		void put_in_memory(std::string key, double val);
		double get_in_memory(std::string key);

		std::string print_memory();
	private:
		Memory _memory;
	};
}

#endif