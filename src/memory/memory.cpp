#include "memory.h"

#include <iostream>
#include <sstream>

namespace Cerberus {
	void Memory::put(std::string key, double value) {
		if (has(key)) {
			std::cout << "Variable " << key << " already defined" << std::endl;
			return;
		}

		_double_memory[key] = value;
	}

	void Memory::put(std::string key, std::string value) {

	}

	double Memory::get_double(std::string key) {
		if (!has(key)) {
			std::cout << "Variable " << key << " don't exists" << std::endl;
			return 0.0;
		}

		return _double_memory[key];
	}

	void Memory::get_string(std::string key) {

	}


	bool Memory::has(std::string key) {
		return _double_memory.find(key) == _double_memory.end();
	}

	std::string Memory::print() {
		std::unordered_map<std::string, double>::iterator it;
		std::stringstream str;

		for (it = _double_memory.begin(); it != _double_memory.end(); it++) {
			str << "(" << it->first << ", " << it->second << ")\n";
		}

		return str.str();
	}
}