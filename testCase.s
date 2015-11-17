.globl _main
.text
_main:
push %ebp
movl %esp, %ebp
movl $1, %ecx
addl $4, %ecx
movl %ecx, %edx
movl $2, %ecx
imul %edx, %ecx
movl %ecx, %edx
movl $1, %ecx
addl %edx, %ecx
movl %ecx, %ecx
addl $5, %ecx
movl %ecx, %ecx
subl $10, %ecx
movl %ecx, %eax
movl $3, %ecx
cltd
idivl %ecx    # %eax <- %eax / %ecx, %edx <- %eax % %ecx
movl %eax, %ecx
movl %ecx, %edx
movl $1, %ecx
addl %edx, %ecx
movl %ecx, %eax
push %eax
push $.LC0    # display the value calling the function printf 
call _printf
movl $0, %eax
leave
ret
.LC0:
.asciz "%d
"
