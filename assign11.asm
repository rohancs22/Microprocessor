%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

Section .data

dot:db "."
meanmsg: db 0x0A,"Mean is: ",0x0A
meanmsg_len:equ $-meanmsg
varmsg:db 0x0A, "Variance is : ",0x0A
varmsg_len: equ $-varmsg
sdmsg: db 0x0A,"Standard Deviation is :", 0x0A
sdmsg_len: equ $-sdmsg
array: dd 102.56,104.25,235.26,205.04,326.01
arraycnt: dw 05
hesc: dq 100
cnt2: db 02H

Section .bss

buffer: rest 1 
dispbuff: resb 2
mean:resd 1
variance:resd 1

Section .text
global _start
_start:


	mov rcx, 00
	mov cx, word[arraycnt]					;MEAN
	FINIT		
	FLDZ		
	mov rsi,array	
UP:
	FADD dword[rsi]
	add rsi,4	
	loop UP

	FIDIV word[arraycnt] 
	FST dword[mean]		
	scall 1,1,meanmsg,meanmsg_len
	CALL DISPLAY


	scall 1,1,varmsg,varmsg_len				;VARIANCE

	FLDZ						
	mov rcx,00
	mov cx, word[arraycnt]
	mov rsi,array
VUP:
	FLD dword[rsi]	
	FSUB  dword[mean] 	
	FST ST1			
	FMUL ST0,ST1		
	FADD dword[variance]	
	FST dword[variance]
	add rsi,4		
	loop VUP
	FLD dword[variance]
	FIDIV word[arraycnt]

	FST dword[variance]
	CALL DISPLAY


	scall 1,1, sdmsg,sdmsg_len				;STANDARD DEVIATION
	FLD dword[variance]
	FSQRT	
	CALL DISPLAY

EXIT:
	mov rax,60
	mov rdi,0
	syscall


DISPLAY:
	FIMUL dword[hesc] 
	FBSTP [buffer] 
	xor rcx,rcx 	
	mov cx,9 	
	mov rsi,buffer+9
TOP:
	push rcx 
	push rsi

	mov bl,byte[rsi] 
	call HtoA	
	pop rsi
	dec rsi
	pop rcx
	dec rcx
	jnz TOP
	scall 1,1,dot,1 


	mov rsi,buffer
	mov bl,byte[rsi]	
	call HtoA
	ret


HtoA:	
	mov rdi,dispbuff
	mov byte[cnt2],2H
aup:
	rol bl,04
	mov cl,bl
	and cl,0FH
	cmp cl,09H
	jbe ANEXT
	ADD cl,07H
ANEXT: 
	add cl, 30H
	mov byte[rdi],cl
	INC rdi
	dec byte[cnt2]
	JNZ aup
	scall 1,1,dispbuff,2
	ret
	
