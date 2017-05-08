.globl set_fpu

set_fpu:
    mov %di, -8(%rbp)
    fldcw -8(%rbp)
    ret

