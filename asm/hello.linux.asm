;;; asm/hello.linux.asm --- nasm example -*- mode:nasm -*-

;; nasm -f elf hello.linux.asm && ld -m elf_i386 hello.linux.o -o hello.linux && hello.linux

;;; Code:
global _start

section .data
msg:	db	"Hello, world!", 10
.len:	equ	$ - msg

section .text
_start:
	mov	eax, 4 ; write
	mov	ebx, 1 ; stdout
	mov	ecx, msg
	mov	edx, msg.len
	int	0x80   ; write(stdout, msg, strlen(msg));

	xor	eax, msg.len ; invert return value from write()
	xchg eax, ebx ; value for exit()
	mov	eax, 1 ; exit
	int	0x80   ; exit(...)
