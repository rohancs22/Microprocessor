section .data

array dq 0x8005678901234000, 0x1123436543487901, 0x2345123456744345, 0x1234123412341234, 0x4567456745674567, 0x7890789078907890, 0x8021523625415263, 0x9234123412341234, 0x4567456745674567, 0x7890789078907890
pos: db 0h
neg: db 0h
msg: db "Positive Numbers are:",10
len equ $-msg
msg1: db "Negative Numbers are:",10
len1 equ $-msg1

section .bss
result resb 2

section .code

global _start
_start:
	mov rsi,array	
	mov rcx,0x0A
	
	L0:
	mov rax,qword[rsi]
	bt rax,63
	jc L1
		inc byte[pos]
		jmp L3
	L1:
		inc byte[neg]
	L3:
		add rsi,08
		LOOP L0

	
	mov dl,byte[pos]
		
	;HEX TO ASCII FOR POS
		mov rcx,02H
		mov rdi,result
	L5:	rol dl,04H
		mov al,dl
		and al,0FH
		cmp al,09H
		jbe L6
		add al,07H
	L6:
		add al,30H
		mov byte[rdi],al
		inc rdi
		LOOP L5

	;PRINT MSG
	mov rax,1
	mov rdi,1
	mov rsi,msg
	mov rdx,len
	syscall

	;PRINT POS
	mov rax,1
	mov rdi,1
	mov rsi,result
	mov rdx,2
	syscall
	
	mov dl,byte[neg]
	
	;HEX TO ASCII FOR NEG
		mov rcx,02H
		mov rdi,result
	L7:	rol dl,04H
		mov al,dl
		and al,0FH
		cmp al,09H
		jbe L8
		add al,07H
	L8:
		add al,30H
		mov byte[rdi],al
		inc rdi
		LOOP L7

	;PRINT MSG1
	mov rax,1
	mov rdi,1
	mov rsi,msg1
	mov rdx,len1
	syscall
	
	;PRINT NEG
	mov rax,1
	mov rdi,1
	mov rsi,result
	mov rdx,2
	syscall

mov rax,60
mov rdi,0
syscall
