#ifndef CERBERUS_MEMORY_H_
#define CERBERUS_MEMORY_H_

#include <unordered_map>
#include <string>

namespace Cerberus {
	class Memory {
	public:
		Memory();

		void put(std::string, double);
		void put(std::string, std::string);

		double get_double(std::string);
		void get_string(std::string);

		std::string print();

	private:
		bool has(std::string);

		std::unordered_map<std::string, double> _double_memory;
		std::unordered_map<std::string, std::string> _string_memory;
	};
}

#endif