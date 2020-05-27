.globl _start
.align	2

_start:

init:
	nop
	li		sp, 9216 	# 8192 (== 0x2000) for the code section plus another 1k for the data section
	j		main
