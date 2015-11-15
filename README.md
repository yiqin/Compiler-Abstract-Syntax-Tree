Question 2
=======

It's in x86 Assembly/GAS Syntax.

Type
```
./calc <testCase.txt
```
to run the test case.

Type ``` make clean ``` to clean files.


Assumptions
=======
1. When a variable is instantiate and is assigned with an int, the compiler push the int to the stack, and the stack machine pops the int out and assign it to the variable.

For example
```
a := 1;

push const int 1
assign variable a with 1
```

2. The code is based on the exercise 1 in the Assignment 4.


3. right operand pushed to stack first and thus is at the bottom when pop

4. The instruction set is x86.

