.globl _start
.align	2

_start:

init:
	nop
	li		sp, 13312 # 12288 (== 0x3000) for the code section plus another 1k for the data section
	j		main
