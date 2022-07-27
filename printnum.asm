; print numbers

section .text
global _start

_start:
	mov eax,127
	call printH
	mov al,10
	call printC

	mov eax,1
	int 80h

printH:
	push eax
	mov al,'0'
	call printC
	mov al,'x'
	call printC
	pop eax

	mov ecx,8
printHL:
	push ecx
	push eax
	and al,0fh
	cmp al,10
	jb printHB10
	add al,'a'-10
	jmp printHA10
printHB10:
	add al,'0'
printHA10:

	mov ecx,[esp+4]
	add ecx,work
	dec ecx
	mov [ecx],al

	pop eax
	pop ecx
	shr eax,4
	loop printHL

	mov eax,4
	mov ebx,1
	mov ecx,work
	mov edx,8
	int 80h

	ret

printC:
	mov [cbuf],al
	mov eax,4
	mov ebx,1
	mov ecx,cbuf
	mov edx,1
	int 80h
	ret

section .bss

cbuf:
	resb 1
work:
	resb 28
