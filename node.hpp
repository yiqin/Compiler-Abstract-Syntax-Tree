#ifndef NODE_H
#define NODE_H

enum class OPERATION {
	plus,
	minus,
	mult,
	divide,
};

class Node
{
public:
	OPERATION operation;
	Symbol* symbol;
	Node* left_operand;
	Node* right_operand;

	int depth = 0;

	// Generate assembly code.
	void generate_code() {
		if (!left_operand || !right_operand) {
			// special case
			if (depth == 0) {
				std::cout << "movl " << symbol->get_assembly_code() << ", %eax" << std::endl;
			}
		} else {
			depth++;

			left_operand->generate_code();
			right_operand->generate_code();

			if (operation == OPERATION::plus) {
				std::cout << "movl " << left_operand->symbol->get_assembly_code() << ", %ecx" << std::endl;
				std::cout << "addl " << right_operand->symbol->get_assembly_code() << ", %ecx" <<std::endl;
			}

			if (operation == OPERATION::minus) {
				std::cout << "movl " << left_operand->symbol->get_assembly_code() << ", %ecx" << std::endl;
				std::cout << "subl " << right_operand->symbol->get_assembly_code() << ", %ecx" <<std::endl;
			}

			if (operation == OPERATION::mult) {
				std::cout << "movl " << left_operand->symbol->get_assembly_code() << ", %ecx" << std::endl;
				std::cout << "imul " << right_operand->symbol->get_assembly_code() << ", %ecx" <<std::endl;
			}

			if (operation == OPERATION::divide) {
				std::cout << "movl " << left_operand->symbol->get_assembly_code() << ", %eax" << std::endl;
				std::cout << "imul " << right_operand->symbol->get_assembly_code() << ", %ecx" <<std::endl;
				std::cout << "cltd" << std::endl;
        		std::cout << "idivl %ecx" << "    # %eax <- %eax / %ecx, %edx <- %eax % %ecx" <<std::endl;
        		std::cout << "push %eax" << std::endl;
			}

			std::cout << "movl %ecx, %eax" <<std::endl;
			symbol->set_address("%eax");
		}
		
	}
};

#endif