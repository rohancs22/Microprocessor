%macro myscanf 1
mov rdi,fsf
mov rax,0
sub rsp,8
mov rsi,rsp
call scanf
mov r8,qword[rsp]
mov qword[%1],r8
add rsp,8
%endmacro

%macro myprintf 1
mov rdi,fpf
sub rsp,8
movsd xmm0,[%1]
mov rax,1
call printf
add rsp,8
%endmacro

%macro scall 4

mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall

%endmacro



section .data

ff1: db "%lf +i %lf",10,0
ff2: db "%lf -i %lf",10,0

fpf: db "%lf",10,0
fsf: db "%lf",0

four: dq 4
two: dq 2

section .bss

extern printf,scanf
a: resq 1
b: resq 1
c: resq 1
b2: resq 1
fac: resq 1
delta: resq 1
rdelta: resq 1
ta: resq 1
r1: resq 1
r2: resq 1
i1: resq 1
realn: resq 1

section .text
global main
main:
	myscanf a
	myscanf b
	myscanf c
	
	finit
	fldz
	
	fld qword[b]
	fmul qword[b]
	fstp qword[b2]									;b square
	
	fild qword[four]
	fmul qword[a]
	fmul qword[c]
	fstp qword[fac]									;4ac
	
	fld qword[b2]	
	fsub qword[fac]
	fstp qword[delta]								;Delta
	
	fild qword[two]
	fmul qword[a]
	fstp qword[ta]									;2a
	
	btr qword[delta],63									
	jc imag
	
	fld qword[delta]
	fsqrt
	fstp qword[rdelta]								;sqrt Delta
		
	fldz
	fsub qword[b]									;-b
	fadd qword[rdelta]								;-b+rdelta
	fdiv qword[ta]									;(-b+rdelta)/2a
	fstp qword[r1]									;r1=real root 1
	myprintf r1

	fldz
	fsub qword[b]									;-b
	fsub qword[rdelta]								;-b-rdelta
	fdiv qword[ta]									;-b-rdelta/2a	
	fstp qword[r2]									;r2=real root 2
	myprintf r2
	
	JMP EXIT
	
imag:	
	fld qword[delta]
	fsqrt
	fstp qword[rdelta]								;sqrt Delta

	fldz
	fsub qword[b]
	fdiv qword[ta]						
	fstp qword[realn]								;real part

	fld qword[rdelta]
	fdiv qword[ta]	
	fstp qword[i1]									;imag part

	mov rdi,ff1										;Print imag1
	sub rsp,8
	movsd xmm0,[realn]
	movsd xmm1,[i1]
	mov rax,2
	call printf
	add rsp,8

	mov rdi,ff2										;Print imag2
	sub rsp,8
	movsd  xmm0, [realn]
	movsd xmm1, [i1]
	mov rax,2
	call printf
	add rsp,8
	
EXIT:
	mov rax,60
	mov rdi,0
	syscall
	
