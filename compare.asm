; comparing pascal-style strings

section .text
global _start

_start:
	mov esi,string1
	mov edi,string1_1
	call printCpStrings
	mov esi,string1
	mov edi,string2
	call printCpStrings
	mov esi,string1
	mov edi,string3
	call printCpStrings

	mov eax,1
	int 80h

printCpStrings:
	; "(string1) = (string2) ?"
	push esi
	call printStr
	mov esi,equalMsg
	call printStr
	mov esi,edi
	call printStr
	mov esi,questionMsg
	call printStr
	mov esi,eol
	call printStr
	pop esi

	mov dl,[esi]
	cmp dl,[edi]
	jnz printCpStringsF

	lodsb
	mov ecx,0
	mov cl,al
	inc edi

	repnz cmpsb
	jnz printCpStringsF

	; true
	mov esi,trueMsg
	call printStr
	mov esi,eol
	call printStr
	ret

printCpStringsF:
	; false
	mov esi,falseMsg
	call printStr
	mov esi,eol
	call printStr
	ret

printStr:
	lodsb
	mov edx,eax
	mov eax,4
	mov ebx,1
	mov ecx,esi
	int 80h
	ret

section .data

equalMsg:
	db 3," = "
questionMsg:
	db 2," ?"
trueMsg:
	db 4,"true"
falseMsg:
	db 5,"false"
eol:
	db 2,0ah,0dh

string1:
	;      12345678901234567890
	db 13,"Hello, world!"
string1_1:
	db 13,"Hello, world!"
string2:
	db 14,"Hello, world!!"
string3:
	db 16,"This is a string"
