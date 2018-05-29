%macro print 2

mov rax,01
mov rdi,00h
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

;macros ends


section .data
msg1:  db "Program for Data transfer:",10
       db "1.Non-overlapping with string instructions",10
       db "2.Non-overlapping without string instructions",10
       db "3.Overlapping with string instructions",10
       db "4.Overlapping without string insturctions",10
       db "5.Exit",10
db "Enter ur choice",10
len1: equ $-msg1

msg2: db "The source array is",10
len2:equ $-msg2

msg3: db "The destination array is",10
len3:equ $-msg3

data: db 0x11,0x22,0x33,0x44,0x55,0x00,0x00,0x00,0x00,0x00,0x00
blank: db "",10
blen equ $-blank

section .bss
	address resb 16 ;to store ascii value of address
	choice resw 1

	count resb 1  ;this variable is used as counter
	count2 resb 1
	num resb 2

section .text

global _start:
_start:


print msg1,len1  ;display msg 

read choice,2  ;accept the choice
cmp byte[choice],35h
je exit

cmp byte[choice],31h
je oop

cmp byte[choice],32h
je oop2

cmp byte[choice],33h
je oop3

cmp byte[choice],34h
je oop4
jmp _start  ;if invalid choice is entered show message again


oop:
	print msg2,len2  ; non overlapping with string instructions
	mov rbx,data
	mov r8,data  ; to display the address of the data array
	mov byte[count2],5h

printloop:
	mov rbx,r8
	call addconvert
	print address,16
	print blank,blen ;
	mov dl,byte[r8]  
	call numconvert
print num,2
print blank,blen
inc r8
dec byte[count2]
jnz printloop
     
mov rsi,data  ;data transfer begins
mov rdi,data
add rdi,5
mov rcx,5h
CLD
back:
	movsb
	loop back
	sub rdi,5
	mov r8,rdi  ;data transfer over
	print msg3,len3


 mov byte[count2],5h
 printloop2:
 mov rbx,r8
 call addconvert
 print address,16
 print blank,blen ; 
mov dl,byte[r8]  
call numconvert
print num,2
print blank,blen
inc r8
dec byte[count2]
jnz printloop2
jmp _start

oop2:
	print msg2,len2  ; non overlapping without string instructions
	mov rbx,data
	mov r8,data  ; to display the address of the data array
	mov byte[count2],5h
	printloop3:
	mov rbx,r8
	call addconvert
	print address,16
	print blank,blen ;print \n character
	mov dl,byte[r8]  
	call numconvert
	print num,2
	print blank,blen
	inc r8
	dec byte[count2]
	jnz printloop3
     
 mov rsi,data  ;data transfer begins
 mov rdi,data
 add rdi,5
 mov rcx,5h
 back2:
 mov al,[rsi]
 mov [rdi],al
 inc rsi
 inc rdi
 loop back2
 sub rdi,5
 mov r8,rdi  ;data transfer over
 print msg3,len3

mov byte[count2],5h
printloop4:
mov rbx,r8
call addconvert
print address,16
print blank,blen ;print \n character
mov dl,byte[r8]  
call numconvert
print num,2
print blank,blen
inc r8
dec byte[count2]
jnz printloop4

jmp _start

oop3:
	print msg2,len2  ; overlapping with string instructions
	mov rbx,data
	mov r8,data  ;
	mov byte[count2],5h
	printloop5:
	mov rbx,r8
	call addconvert
	print address,16
	print blank,blen ;print \n character
	mov dl,byte[r8]  
	call numconvert
	print num,2
	print blank,blen
	inc r8
	dec byte[count2]
	jnz printloop5

mov rsi,data  ;data transfer begins
add rsi,4
mov rdi,rsi
add rdi,2
mov rcx,5h
STD
back3:
movsb
loop back3
add rdi,1
mov r8,rdi  ;data transfer over
print msg3,len3

mov byte[count2],5
printloop6:
mov rbx,r8
call addconvert
print address,16
print blank,blen ;print \n character
mov dl,byte[r8]  
call numconvert
print num,2
print blank,blen
inc r8
dec byte[count2]
jnz printloop6
jmp _start

oop4:

print msg2,len2  ; overlapping without string instructions
mov rbx,data
mov r8,data  ; to display the address of the data array
mov byte[count2],5h
printloop7:
mov rbx,r8
call addconvert
print address,16
print blank,blen ;print \n character
mov dl,byte[r8]  
call numconvert
print num,2
print blank,blen
inc r8
dec byte[count2]
jnz printloop7


mov rsi,data  ;data transfer begins
add rsi,4
mov rdi,rsi
add rdi,2
mov rcx,5h
STD
back4:
mov al,[rsi]
mov [rdi],al
dec rsi
dec rdi
loop back4

add rdi,1
mov r8,rdi  ;data transfer over
print msg3,len3

mov byte[count2],5
printloop8:
mov rbx,r8
call addconvert
print address,16
print blank,blen ;print \n character
mov dl,byte[r8]  
call numconvert
print num,2
print blank,blen
inc r8
dec byte[count2]
jnz printloop8
jmp _start


exit:
mov rax,60  ;exit system call
mov rdx,0
syscall


addconvert:  ;converts a 8bit hex value in rbx to ascii in address
mov rsi,address
mov byte[count],16
moredigit:
rol rbx,4
mov al,bl
and al,0Fh  ;al now has a value of a digit in hex
cmp al,09h
jbe nocorrection
add al,09
nocorrection:
add al,30h
mov byte[rsi],al
inc rsi
dec byte[count]
jnz moredigit 
ret

numconvert:
mov rsi,num
mov byte[count],2
moredigit2:
rol dl,4
mov al,dl
and al,0Fh  ;al now has a value of a digit in hex
cmp al,09h
jbe nocorrection2
add al,09
nocorrection2:
add al,30h
mov byte[rsi],al
inc rsi
dec byte[count]
jnz moredigit2
ret
