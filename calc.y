%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
Symbol_Table symbol_table;

vector<Symbol*> stack_machine;

int local_variable_offset = -4;

%}

%union{
  int		int_val;
  string*	op_val;
}

%start	input 

%token	<int_val>	INTEGER_LITERAL
%token <op_val> VARIABLE

%type <op_val> input
%type <int_val> intermediate
%type	<int_val>	exp
%type <int_val> term
%type <int_val> final_state


%left	PLUS
%left MINUS
%left	MULT
%left DIVIDE
%left SEMICOLON
%left LEFT_PARENTHESIS
%left RIGHT_PARENTHESIS

%left ASSIGN

%%

input:
		| intermediate SEMICOLON input	{ 
        // cout << $1 << "; "  << endl;
      }
    | {}
		;

intermediate:
      VARIABLE ASSIGN exp { 
        $$ = $3; 

        stack_machine.pop_back();
        cout << "pop %eax" << endl;
        cout << "movl %eax, " << local_variable_offset << "(%ebp)" << "    # " << "assign " << *$1 << endl;
        
        // Create a new symbol and put it into the symbol table.
        Symbol* new_symbol = new Symbol();
        new_symbol->set_name(*$1);
        new_symbol->set_type(Type::LOCAL_VARIABLE_INT);
        new_symbol->set_int_value($3);
        // set the address
        string address = to_string(local_variable_offset);
        new_symbol->set_address(address+"(%ebp)");

        symbol_table.add(*$1, new_symbol);

        // Update the offset
        local_variable_offset += -4;
      }
    | exp { 
      $$ = $1;

      // printf function.
      cout << "pop %eax" << "    # display the value calling the function printf "<< endl;
      cout << "movl %eax, %esi" << endl;
      cout << "$.LCO, %edi" << endl;
      cout << "movl $0, %eax" << endl;
      cout << "call printf" << endl;

    }
    | {}
    ;

exp:		
		  exp PLUS term	{ 
        // Pop two symbol from the stack machine
        Symbol* symbol_2 = stack_machine.back();
        stack_machine.pop_back();
        cout << "pop %eax" << endl;

        Symbol* symbol_1 = stack_machine.back();
        stack_machine.pop_back();
        cout << "pop %edx" << endl;

        Symbol* symbol_result = new Symbol();
        symbol_result->set_type(Type::CONST_INT);

        int int_value_result = symbol_1->get_int_value() + symbol_2->get_int_value();
        symbol_result->set_int_value(int_value_result);

        stack_machine.push_back(symbol_result);

        cout << "addl %edx, %eax" << endl;
        cout << "push %eax " << endl;

        $$ = $1 + $3;
      }
		| exp MINUS term	{ 
        // Pop two symbol from the stack machine
        Symbol* symbol_2 = stack_machine.back();
        stack_machine.pop_back();
        cout << "pop %eax" << endl;
        
        Symbol* symbol_1 = stack_machine.back();
        stack_machine.pop_back();
        cout << "pop %edx" << endl;

        Symbol* symbol_result = new Symbol();
        symbol_result->set_type(Type::CONST_INT);
        
        int int_value_result = symbol_1->get_int_value() - symbol_2->get_int_value();
        symbol_result->set_int_value(int_value_result);

        stack_machine.push_back(symbol_result);

        cout << "subl %edx, %eax" << endl;
        cout << "push %eax" << endl;

        $$ = $1 - $3; 
      }
    | term { $$ = $1; }
		;

term:
      term MULT final_state { 
        // Pop two symbol from the stack machine
        Symbol* symbol_2 = stack_machine.back();
        stack_machine.pop_back();
        cout << "pop %eax" << endl;

        Symbol* symbol_1 = stack_machine.back();
        stack_machine.pop_back();
        cout << "pop %edx" << endl;

        Symbol* symbol_result = new Symbol();
        symbol_result->set_type(Type::CONST_INT);
        
        int int_value_result = symbol_1->get_int_value() * symbol_2->get_int_value();
        symbol_result->set_int_value(int_value_result);

        stack_machine.push_back(symbol_result);

        cout << "imul %edx %eax" << endl;
        cout << "push %eax" << endl;

        $$ = $1 * $3; 
      }
    | term DIVIDE final_state {
        // Pop two symbol from the stack machine
        Symbol* symbol_2 = stack_machine.back();
        stack_machine.pop_back();
        cout << "pop %ecx" << endl;

        Symbol* symbol_1 = stack_machine.back();
        stack_machine.pop_back();
        cout << "pop %eax" << endl;

        Symbol* symbol_result = new Symbol();
        symbol_result->set_type(Type::CONST_INT);
        
        int int_value_result = symbol_1->get_int_value() / symbol_2->get_int_value();
        symbol_result->set_int_value(int_value_result);

        stack_machine.push_back(symbol_result);

        cout << "cltd" << endl;
        cout << "idivl %ecx" << "    # %eax <- %eax / %ecx, %edx <- %eax % %ecx" <<endl;
        cout << "push %eax" << endl;

        $$ = $1 / $3; 
      }
    | final_state { $$ = $1; }
    ;

final_state:
      VARIABLE {
        // get the local variable fromt the symbol table
        if (symbol_table.is_variable_defined(*$1)) {

          Symbol *tmp_symbol; 
          tmp_symbol = symbol_table.get_symbol(*$1);

          $$ = tmp_symbol->get_int_value();

          stack_machine.push_back(tmp_symbol);
          cout << "push " << tmp_symbol->get_address() << "    # get " << tmp_symbol->get_name()<< endl;

        } else {
          cout << "ERROR: " <<*$1 << " has not been initialized." << endl;
          exit(1);
        }
        
      }
    | INTEGER_LITERAL { 
        $$ = $1; 

        // Push it to the stack machine
        Symbol *new_symbol = new Symbol();
        new_symbol->set_type(Type::CONST_INT);
        new_symbol->set_int_value($1);

        stack_machine.push_back(new_symbol);
        cout << "push $" << $1 << endl;
    }
    | LEFT_PARENTHESIS exp RIGHT_PARENTHESIS { $$ = $2; }
    ;

%%

int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int yyerror(char *s)
{
  return yyerror(string(s));
}


