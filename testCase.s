.globl _main
.text
_main:
push %ebp
movl %esp, %ebp
push $5
push $3
pop %eax
pop %edx
addl %edx, %eax
push %eax 
push $1
pop %eax
pop %edx
addl %edx, %eax
push %eax 
push $.LC0    # display the value calling the function printf 
call _printf
movl $0, %eax
leave
ret
.LC0:
.asciz "%d
"
