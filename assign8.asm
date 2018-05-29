section .data

msg1: db "File opened successfully",10
len1 equ $-msg1

error: db "File opened successfully",10
lerror equ $-error

msgc: db "Copying contents of file",10
lenc equ $-msgc

msgd: db "Deleting contents of file",10
lend equ $-msgd

msgt: db "Printing contents of file",10
lent equ $-msgt

section .bss

choice resb 2
fname resb 100
fd resq 2
fname2 resb 100
fd2 resq 2
buffer resb 100
bufflen resb 100
buffer2 resb 100
bufflen2 resb 100

%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global _start
_start:

pop rbx
pop rbx
pop rbx

	mov [choice],rbx
	mov rsi,[choice]

	cmp byte[rsi],'C'
	je COPY
	cmp byte[rsi],'D'
	je DELETE
	cmp byte[rsi],'T'
	je TYPE
	jmp exit

COPY:
	scall 1,1,msgc,lenc
	pop rbx
	mov rsi,fname
	lg:
	mov al,byte[rbx]
	mov byte[rsi],al
	inc rsi
	inc rbx
	cmp byte[rbx],0h
	jne lg
	scall 1,1,fname,100

	pop rbx
	mov rsi,fname2
	lq:
	mov al,byte[rbx]
	mov byte[rsi],al
	inc rsi
	inc rbx
	cmp byte[rbx],0h
	jne lq
	scall 1,1,fname2,100

	scall 2,fname,02,0777
	mov qword[fd],rax
	bt rax,63
	jc check
        scall 1,1,msg1,len1
        
	scall 0,[fd],buffer,40
	
	mov qword[bufflen],rax
	scall 1,1,buffer,bufflen

	scall 2,fname2,02,0777
	mov qword[fd2],rax
	bt rax,63
	jc check
        scall 1,1,msg1,len1
        
	scall 01,[fd2],buffer,40
	scall 0,[fd2],buffer2,40

	mov qword[bufflen2],rax
	scall 1,1,buffer2,100

	scall 3,[fd],0,0
	scall 3,[fd2],0,0
	jmp exit
DELETE:
	scall 1,1,msgd,lend
	pop rbx
	mov rsi,fname
	lm:
	mov al,byte[rbx]
	mov byte[rsi],al
	inc rsi
	inc rbx
	cmp byte[rbx],0h
	jne lm
	scall 1,1,fname,100
	scall 87,fname,0,0
	
	jmp exit
TYPE:
	scall 1,1,msgt,lent
	pop rbx
	mov rsi,fname
	l:
	mov al,byte[rbx]
	mov byte[rsi],al
	inc rsi
	inc rbx
	cmp byte[rbx],0h
	jne l

	scall 2,fname,02,0777
	mov qword[fd],rax
	bt rax,63
	jc check
        scall 1,1,msg1,len1
        
	scall 0,[fd],buffer,40
	
	mov qword[bufflen],rax
	scall 1,1,buffer,bufflen
	scall 3,[fd],0,0
	jmp exit
check:
	scall 1,1,error,lerror
exit:
scall 60,0,0,0

