%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro exit 0
mov rax,60
mov rdi,0	
syscall
%endmacro

section .data

menu db "1.BCD to HEX",10
     db "2.HEX to BCD",10
     db "3.Exit",10
     db "Enter Choice:",10
len equ $-menu

msg db "Enter 4-digit HEX Number:",10
len1 equ $-msg
msg2 db "Enter BCD Number:",10
len2 equ $-msg2
blank:  db "",10
blen: equ $-blank

section .bss

num1 resw 5
num2 resw 5
temp resw 1
count resb 1
choice resb 1
ascii resb 4
bcd resb 5

section .code

global _start
_start:
MENU:	print menu,len
	read choice,2
	cmp byte[choice],31h
	je c1
	cmp byte[choice],32h 
	je c2
	cmp byte[choice],33h
	je c3

c1:		
doh:   	print msg2,len2				;BCD TO HEX
	read bcd,5

	mov rbx,10
	mov rdx,0
	mov rax,0
	mov byte[count],5
	mov rsi,bcd

unpack:	mul rbx					;Decimal No.
	sub byte[rsi],30h
	movsx cx,byte[rsi] 			;Move using Sign Extended
	add ax,cx
	inc rsi
	dec byte[count]
	jnz unpack
	mov byte[count],4
	mov rsi,ascii
again:
	rol ax,4
	mov bl,al
	and bl,0Fh
	cmp bl,9
	jbe nocorr
	add bl,7
	
nocorr:
	add bl,30h
	mov byte[rsi],bl
	inc rsi
	dec byte[count]
	jnz again
	print ascii,4
	print blank,blen
	
	jmp MENU
	
	
c2:	print msg,len1				;HEX to BCD
	read num1,4
	call ASCIITOHEX	
	

L5:	mov cx,00
	mov bx,0AH
	xor rdx,rdx

	div bx 					; DIV BY 0A
		
	push dx 				; PUSH ON STACK

	mov cx,ax
	inc byte[count]
	xor rdx,rdx
	xor rax,rax
	mov ax,cx

	cmp ax,0H
	jnz L5	

M1:						; PRINT BCD No.
	pop ax
	add ax,30H	
	mov [temp],ax

	print temp,1
	
	dec byte[count]
	jnz M1	
	
	jmp MENU

c3: 	exit 

ASCIITOHEX:	
	mov rcx,04H				;ASCII to HEX
	mov rsi,num1
	xor rbx,rbx
	L3:	rol bx,04H
		mov al,byte[rsi]
		cmp al,39H
		jbe L4
	   	sub al,07H
	L4:   	sub al,30H
          	add bl,al
	  	inc rsi
	  	LOOP L3
	mov byte[count],0
	mov ax,bx	
	ret
		
