section .data

menu: db "1. Successive addition" , 0x0A
      db "2. Arithmetic add and shift" , 0x0A
      db "3. Exit" , 0x0A
      db "Enter your choice: "
len: equ $-menu
msg1: db "Enter the multiplicand: "
len1: equ $-msg1
msg2: db "Enter the multiplier: "
len2: equ $-msg2
msg3: db " ",0x0A
len3: equ $-msg3

count: db 00H
count1: db 08H

section .bss

choice: resb 2
num1: resb 3
num2: resb 3
result: resb 4
result1: resb 4

%macro sycall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global _start

_start:
  sycall 1,1,menu,len
  sycall 0,0,choice,2

cmp byte[choice],31H
 je next1
cmp byte[choice],32H
 je next2
cmp byte[choice],33H
 je down


next1:
   sycall 1,1,msg3,len3
   sycall 1,1,msg1,len1
   sycall 0,0,num1,3
   sycall 1,1,msg2,len2
   sycall 0,0,num2,3
   sycall 1,1,msg3,len3
   mov dx,00H
   mov cx,00H
   mov rsi,num1
   call atoh
   mov dx,bx
   mov rsi,num2
   call atoh
   mov cx,bx
   mov ax,00H
   up1:
     add ax,dx
     sub cx,01H
     jnz up1
     mov [result],ax
     call htoa
     sycall 1,1,msg3,len3
     jmp _start



next2:
   sycall 1,1,msg3,len3
   sycall 1,1,msg1,len1
   sycall 0,0,num1,3
   sycall 1,1,msg2,len2
   sycall 0,0,num2,3
   sycall 1,1,msg3,len3
   mov dx,00H
   mov cx,00H
   mov rsi,num1
   call atoh
   mov dx,bx
   mov rsi,num2
   call atoh
   mov cx,bx
   mov ax,00H
up2:
   shr cx,1
   jc down1
   shl dx,1
   jmp n1
   down1:
     add ax,dx
     shl dx,1
     n1:
      dec byte[count1]
      jnz up2
     mov [result],ax
     call htoa
     sycall 1,1,msg3,len3
     jmp _start



down:
  sycall 60,0,0,0

atoh:
  mov bx,00H
  mov byte[count],02H
  up:
   rol bx,04
   mov al,byte[rsi]
   sub al,30H
   add bl,al
   inc rsi
   dec byte[count]
   jnz up
ret

htoa:
  mov byte[count],04H
  mov rdi,result
  mov bx,[rdi]
  mov rsi,result1
  up5:
    rol bx,04H
    mov cl,bl
    and cl,0FH
    cmp cl,09H
    jbe next5
    add cl,07H
    next5:
      add cl,30H
      mov [rsi],cl
      inc rsi
      dec byte[count]
      jnz up5
   sycall 1,1,result1,04H      
ret
  
  
  


