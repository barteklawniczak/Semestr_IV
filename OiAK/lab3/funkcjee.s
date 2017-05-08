.data
a: .long
b: .float 
c: .int
d: .int
format: .ascii "%d %f %c %s"

.text
.globl funkcjes

funkcjes:
push %rbp
mov %rsp, %rbp
push $d
push $c
cvtss2sd %xmm0, %xmm0
push $b
push $a
push $format
call scanf
mov %rbp, %rsp
pop %rbp
ret
