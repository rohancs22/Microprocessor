section .data

	msg1 db "Factorial="
	len1 equ $-msg1
	msg2 db "Enter num:"
	len2 db $-msg2

section .bss
	
	no resb 8
	result resb 16

%macro accept 2
	mov rax,0
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall 
%endmacro

%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall 
%endmacro

section .text

global main:
main:
	pop rbx
	pop rbx
	pop rbx
	mov dx,word[rbx]
	mov word[no],dx
	mov rsi,no
	call asciitohex
	xor rax,rax
	mov al,bl
	mov [rsi],rbx
	cmp qword[rsi],00h
	je s1	
	call fact
	mov rdx,rax
	jmp s2
s1:
	mov rdx,01h
     s2:call hextoascii
	print msg1,len1
	print result,16

exit:
	mov rax,60
	mov rdi,0
	syscall
	
	
fact:
	
	mov [rsi],rbx
	cmp qword[rsi],1h
	je return
	dec rbx
	mul rbx
	call fact
return:
	ret


asciitohex:
		mov rcx,02h
		xor rbx,rbx
	     l3:rol bl,04h
		mov al,byte[rsi]
		cmp al,39h
		jbe l4
		sub al,07h
	     l4:sub al,30h
		add bl,al
		inc rsi
		loop l3
		ret

hextoascii:	
		mov rcx,0x10
		mov rdi,result
	     l1:rol rdx,4
		mov al,dl
		and al,0Fh
		cmp al,09h
		jbe l2
		add al,07h

	     l2:add al,30h
		mov byte[rdi],al
		inc rdi
		loop l1
		ret	

	
	
