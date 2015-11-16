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
	bool is_operation;

	OPERATION operation;
	Symbol* symbol;
	Node* left_operand;
	Node* right_operand;

	void generate_code() {
		if (!left_operand || !right_operand) {
			// left_operand->generate_code();
		} else {
			left_operand->generate_code();
			

			if (operation == OPERATION::plus) {
				std::cout << "movl " << left_operand->symbol->get_assembly_code() << " %eax" << std::endl;
				std::cout << "addl " << right_operand->symbol->get_assembly_code() << " %eax" <<std::endl;
			}

			right_operand->generate_code();
			std::cout << "movl %eax %ecx" <<std::endl;
		}
		
	}
};

#endif