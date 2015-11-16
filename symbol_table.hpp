#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <string>
#include <map>

enum class Type {
	LOCAL_VARIABLE_INT,
	CONST_INT,
};

class Symbol
{
public:
	const std::string get_name() {
		return name;
	}
	const void set_name(std::string value) {
		name = value;
	}

	const Type get_type() {
		return type;
	}
	const void set_type(Type value) {
		type = value;
	}
	const std::string get_type_str() {
		if (type == Type::LOCAL_VARIABLE_INT || type == Type::CONST_INT) {
			return "int";
		}
	}

	const int get_int_value() {
		return int_value;
	}
	const void set_int_value(int value) {
		int_value = value;
	}

	const std::string get_address() {
		return address;
	}
	const void set_address(std::string value) {
		address = value;
	}

	const std::string get_assembly_code() {
		if (type == Type::CONST_INT) {
			return "$"+std::to_string(int_value);
		}
		if (!address.empty()) {
			return address;
		}
		return "";
	};

protected:
	int int_value;
	std::string name;
	Type type;
	std::string address;
};

// change value to symbol...

class Symbol_Table
{
public:
	const void add (std::string key, Symbol* value) {
		m[key] = value;
	};
	Symbol* get_symbol (std::string key) {
		return m[key];
	};
	const bool is_variable_defined (std::string key) {
		if (m.find(key) != m.end()) {
			return true;
		} else {
			return false;
		}
	};
protected:
	std::map<std::string, Symbol*> m;
};

#endif