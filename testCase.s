.globl _main
.text
_main:
push %ebp
movl %esp, %ebp
movl $300, -4(%ebp)    # assign a
push -4(%ebp)
push $.LC0    # display the value calling the function printf 
call _printf
movl $1, %eax
movl $2, %eax
movl -4(%ebp), %eax
movl $2, %ecx
imul -4(%ebp), %ecx
movl %ecx, %eax
movl $1, %ecx
addl %eax, %ecx
movl %ecx, %eax
push %eax
push $.LC0    # display the value calling the function printf 
call _printf
movl $1, -8(%ebp)    # assign b
push -8(%ebp)
push $.LC0    # display the value calling the function printf 
call _printf
movl -8(%ebp), %eax
push %eax
push $.LC0    # display the value calling the function printf 
call _printf
movl $100, %eax
push %eax
push $.LC0    # display the value calling the function printf 
call _printf
movl $0, %eax
leave
ret
.LC0:
.asciz "%d
"
