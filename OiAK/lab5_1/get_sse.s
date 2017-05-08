    .globl	get_sse
	.type	get_sse, @function
get_sse:
	pushq	%rbp
	movq	%rsp, %rbp
	stmxcsr	-8(%rbp)
    movw    -8(%rbp), %ax
	popq	%rbp
	ret
