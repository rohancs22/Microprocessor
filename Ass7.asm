%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro accept 2
mov rax,0
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
fname db 'Num.txt', 0
openmsg db "file open ok!!",10
openlen equ $-openmsg
errmsg db "Error while opening",10
errlen equ $-errmsg
msg1 db "1.Ascending",10
     db "2.Descending",10
     db "Enter your choice:",10
len1 equ $-msg1

section .bss
	buffer resb 200
	buffercpy resb 200
	length resb 8
	fd resb 8
	cnt1 resb 8
	cnt2 resb 8
	choice resb 2

section .text
	global main
	main:
	
		mov rax,2     ;open file
        mov rdi,fname    
        mov rsi,02
        mov rdx,0777
        syscall

        mov qword[fd],rax
		bt rax,63
		jnc program
		print errmsg,errlen
		jmp close

program:
	print openmsg,openlen
	print msg1,len1
	accept choice,2
	
	mov rax,0     ;read file
	mov rdi,[fd]
	mov rsi,buffer
	mov rdx,100
	syscall	

	mov qword[length],rax
	mov qword[cnt1],rax
	mov qword[cnt2],rax

BUBBLESORT:
	mov al,byte[cnt2]
	mov byte[cnt1],al
	dec byte[cnt1]

	mov rsi,buffer
	mov rdi,buffer+1
l1:	
	mov bl,byte[rsi]
	mov cl,byte[rdi]

	
	cmp byte[choice],31h
	je ac
	cmp byte[choice],32h
	je dc
     ac:
    	 cmp bl,cl
		 ja SWAP
		
		 jmp i
     dc:
     	cmp bl,cl
		jb SWAP

      	i:inc rsi
		inc rdi
		dec byte[cnt1]
	
		jnz l1

	dec byte[length]
	jnz BUBBLESORT
	jmp l2    

SWAP:
	mov byte[rsi],cl
	mov byte[rdi],bl
	inc rsi 
	inc rdi
	dec byte[cnt1]
	jnz l1
	dec byte[length]
	jnz BUBBLESORT

l2:
    mov rax,1    ;print sorted buffer
	mov rdi,1
	mov rsi,buffer
	mov rdx,qword[cnt2]
	syscall	
	
    mov rax,1    ;write to file
	mov rdi,[fd]
	mov rsi,buffer
	mov rdx,qword[cnt2]
	syscall	
	

close:	
	mov rax,3
	mov rdi,fname
	syscall

EXIT:
	mov rax,60
	mov rdi,0
	syscall	
