	.arch armv8-a
	.file	"hello_world.c"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	sub	sp, sp, #16   // sp = sp - 16
	str	wzr, [sp, 12] // sp + 12 assign 0
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12] // wo value store sp+12
	mov	w0, 0
	add	sp, sp, 16
	ret
	.size	main, .-main
	.ident	"GCC: (Linaro GCC 7.4-2019.02) 7.4.1 20181213 [linaro-7.4-2019.02 revision 56ec6f6b99cc167ff0c2f8e1a2eed33b1edc85d4]"
	.section	.note.GNU-stack,"",@progbits
