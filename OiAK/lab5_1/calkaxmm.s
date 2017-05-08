.data

.text
.globl calkaxmm

calkaxmm:
	.type calkaxmm, @function

calkaxmm:
push %rbp		#ramka stosu
movq %rsp, %rbp
a:
movsd %xmm3, %xmm7

petla:
divsd %xmm0, %xmm3
mulsd %xmm2, %xmm3
addsd %xmm3, %xmm4
movsd %xmm7, %xmm3
dec %rdi
cmp $0, %rdi
jle exit
addsd %xmm2, %xmm0
jmp petla

exit:
movsd %xmm4, %xmm0
pop %rbp
ret
