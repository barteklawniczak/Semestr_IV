.data

.text
.globl funkcje

funkcje:
push %rbp
movq %rsp, %rbp
subq $32, %rsp
push %rcx
push %rdx
push %rsi
cvtss2sd %xmm0, %xmm0
push %rdi
movq $1, %rax
call printf
movq %rbp, %rsp
popq %rbp
ret
