%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

Section .data
reg: db 0x0A,"=====Contents of Register====="
reg_len: equ $-reg

gmsg: db 0x0A,"Contents of GDTR : "
gmsg_len: equ $-gmsg

lmsg: db 0x0A,"Contents of LDTR : "
lmsg_len: equ $-lmsg

imsg: db 0x0A,"Contents of IDTR : "
imsg_len: equ $-imsg

tmsg: db 0x0A,"Contents of TR   : "
tmsg_len: equ $-tmsg

mmsg: db 0x0A,"Contents of MSW  : "
mmsg_len: equ $-mmsg

real: db "=====In Real mode====="
real_len: equ $-real

protect: db "=====In Protected Mode====="
protect_len: equ $-protect

cnt:db 04H
newline: db 0x0A
msg db ":"

Section .bss
gdtr: resd 1
     ; resw 1
ldtr: resw 1
idtr: resd 1
      ;resw 1
msw: resd 1
tr: resw 1
value:resb 4

Section .text
global _start
_start:

	smsw [msw]
	mov ax,word[msw]
	bt ax,0
	jc next
	scall 1,1,real,real_len
	jmp EXIT

next:
	scall 1,1,protect,protect_len
	scall 1,1,reg,reg_len

	scall 1,1,gmsg,gmsg_len					;CONTENTS OF GDTR
	SGDT [gdtr]
	mov bx, word[gdtr+4]
	call HtoA
	mov bx,word[gdtr+2]
	call HtoA
	scall 1,1,msg,1
	mov bx, word[gdtr]
	call HtoA

	scall 1,1, lmsg,lmsg_len				;CONTENTS OF LDTR
	SLDT [ldtr]
	mov bx,word[ldtr]
	call HtoA

	scall 1,1,imsg,imsg_len					;CONTENTS OF IDTR
	SIDT [idtr]
	mov bx, word[idtr+4]
	call HtoA
	mov bx,word[idtr+2]
	call HtoA
	scall 1,1,msg,1
	mov bx, word[idtr]
	call HtoA

	scall 1,1, tmsg,tmsg_len
	STR [tr]								;CONTENTS OF TR
	mov bx,word[tr]
	call HtoA

	scall 1,1,mmsg,mmsg_len					;CONTENTS OF MSW
	SMSW [msw]
	mov bx, word[msw+2]
	call HtoA
	mov bx, word[msw]
	call HtoA
	scall 1,1,newline,1

EXIT:
	mov rax,60
	mov rdi,0
	syscall

HtoA: 								;HEX TO ASCII
	mov rdi,value
	mov byte[cnt],4H
up:
	rol bx,04
	mov cl,bl
	and cl,0FH
	cmp cl,09H
	jbe NEXT
	ADD cl,07H
NEXT: 
	add cl, 30H
	mov byte[rdi],cl
	INC rdi
	dec byte[cnt]
	JNZ up
	scall 1,1,value,4
	ret
