; split string in assembly

section .text
global _start

; entry point
_start:
	cld
	mov esi,string1
	call printStr
	mov esi,nlStr
	call printStr

	mov esi,string1
	call splitString

	mov ecx,[stringNum]
	mov edx,stringPtrs
printStrings:
	push ecx
	push edx

	mov esi,[edx]
	mov al,'['
	call printCh
	call printStr
	mov al,']'
	call printCh

	pop edx
	pop ecx
	add edx,4
	loop printStrings

	mov esi,nlStr
	call printStr

	; exit
	mov eax,1
	int 80h

splitString:
	mov dword [stringNum],0
	mov dword [stringNext],stringData

splitString0:
	mov edi,esi
splitStringFW:
	lodsb
	cmp al,32
	ja splitStringFW

	mov ecx,esi
	sub ecx,edi
	dec ecx
	jnz splitStringAdd

	or al,al
	jz splitStringEnd
	jmp splitString0
splitStringAdd:

	xchg esi,edi
	mov edi,[stringNext]

	mov edx,[stringNum]
	shl edx,2
	add edx,stringPtrs
	mov [edx],edi

	rep movsb
	mov al,0
	stosb

	mov [stringNext],edi
	inc dword [stringNum]

	mov al,[esi]
	or al,al
	jnz splitString0

splitStringEnd:
	ret

printStr:
	mov edi,esi
	mov al,0
	mov ecx,-1
	repnz scasb
	sub edi,esi
	mov edx,edi
	mov ecx,esi
	mov eax,4
	mov ebx,1
	int 80h
	ret

printCh:
	mov [cbuf],al
	mov eax,4
	mov ebx,1
	mov ecx,cbuf
	mov edx,1
	int 80h
	ret

section .data

string1:
	db "Hello, world!   This  is   a  test.",0
nlStr:
	db 10,0

section .bss

cbuf:
	resb 1

stringNum:
	resd 1
stringNext:
	resd 1
stringPtrs:
	resd 100
stringData:
	resb 5000
