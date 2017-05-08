.globl set_sse

set_sse:
    mov %edi, -16(%rbp)
    ldmxcsr -16(%rbp)
    ret

