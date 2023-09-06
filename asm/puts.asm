;;; asm/puts --- puts

;;; Code:
mov rdi,someString
extern puts
call puts
ret

section .data
someString:
	db "hello world",0
