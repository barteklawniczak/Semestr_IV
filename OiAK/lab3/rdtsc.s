.globl rdtsc

rdtsc:
xor %rax, %rax
xor %rdx, %rdx
cpuid 
rdtsc
ret
