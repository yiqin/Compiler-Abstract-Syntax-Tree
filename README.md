Compiler: Abstract Syntax Tree
=======

It's in x86 Assembly/GAS Syntax. The assembly code is directly executable.

1. Type ```make```

2. Type ```./calc <testCase.txt >testCase.s ``` to run the test case.

3. Type ```gcc -m32 testCase.s -o testCase ``` to build the executable file.

4. Type ```./testCase``` to run the executable file.

Type ``` make clean ``` to clean files.


Note:
=========
1. We build the Abstract Syntax Tree first. In the clac.y, we have ```Node* root``` to track the root of the AST. Then we traverse the nodes. During the travering, we generate the assembly code.

2. Node class is in the node.hpp file. function generate_code is to find the subnode recursely. Node 

3. We also make some modifications to the Symbol class. The function get_assembly_code() is to get the addresss of the node. The node can be a constant integer, an intermediate value or a local variable. For the intermediate value and the local variable, we need to know the address or the register, which has been defined in the calc.y.

```
	const std::string get_assembly_code() {
		if (type == Type::CONST_INT) {
			return "$"+std::to_string(int_value);
		}
		if (!address.empty()) {
			return address;
		}
		return "";
	};
```


4. A sepcial case is the depth of AST is 0. For example:
```
a;
1;
```
We have considered this case in the node.hpp.


