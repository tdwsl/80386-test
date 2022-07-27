; print numbers in assembly

section .text
global _start

_start:
	mov eax,printHex
	call printOpOnArr
	mov eax,printInt
	call printOpOnArr
	mov eax,printSigned
	call printOpOnArr

	mov eax,1
	int 80h

printOpOnArr:
	mov ecx,[numNumbers]
	mov edx,numbers

printOpOnArrL:
	pusha
	mov ebx,eax
	mov eax,[edx]
	call ebx
	popa

	cmp ecx,1
	jz printOpOnArrNoC

	pusha
	mov al,','
	call printChar
	mov al,' '
	call printChar
	popa
printOpOnArrNoC:

	add edx,4
	loop printOpOnArrL

	mov al,10
	call printChar
	ret

printSigned:
	mov ebx,eax
	and ebx,80000000h
	jz printSignedPos
	neg eax
	push eax
	mov al,'-'
	call printChar
	pop eax
printSignedPos:
	call printInt
	ret

printInt:

	or eax,eax
	jnz printIntNZ
	mov al,'0'
	call printChar
	ret
printIntNZ:

	mov edi,work
	mov ebx,10
printIntL:
	mov edx,0
	div ebx
	push eax
	mov eax,edx
	add al,'0'
	stosb
	pop eax
	cmp eax,edx
	jz printIntFin
	jmp printIntL

printIntFin:
	dec edi
	dec edi
	mov esi,edi
	std

printIntPL:
	lodsb
	call printChar
	cmp esi,work
	jnb printIntPL
	cld
	ret

printHex:
	push eax
	mov al,'0'
	call printChar
	mov al,'x'
	call printChar
	pop eax

	mov ecx,8
printHexL:
	push ecx
	push eax
	and al,0fh
	cmp al,10
	jb printHexB10
	add al,'a'-10
	jmp printHexA10
printHexB10:
	add al,'0'
printHexA10:

	mov ecx,[esp+4]
	add ecx,work
	dec ecx
	mov [ecx],al

	pop eax
	pop ecx
	shr eax,4
	loop printHexL

	mov eax,4
	mov ebx,1
	mov ecx,work
	mov edx,8
	int 80h

	ret

printChar:
	mov [cbuf],al
	mov eax,4
	mov ebx,1
	mov ecx,cbuf
	mov edx,1
	int 80h
	ret

section .data

numbers:
	dd 0,12,-357,2001,-3,0ffffffffh
numNumbers:
	dd 6

section .bss

cbuf:
	resb 1
work:
	resb 28
