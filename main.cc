/* main.cc */

#include "heading.h"

// prototype of bison-generated parser function
int yyparse();

int main(int argc, char **argv)
{
  if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  {
    cerr << argv[0] << ": File " << argv[1] << " cannot be opened.\n";
    exit( 1 );
  }
  

  cout << ".globl _main" << endl;
  cout << ".text" << endl;
  cout << "_main:" << endl;
  cout << "push %ebp" << endl;
  cout << "movl %esp, %ebp" << endl;
  
  yyparse();

  cout << "movl $0, %eax" << endl;
  cout << "leave" << endl;
  cout << "ret" << endl;

  cout << ".LC0:\n.asciz \"%d\n\"" << endl;

  return 0;
}
