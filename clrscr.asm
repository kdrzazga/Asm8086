clrscr:

	mov ax, 0a000h
	mov es, ax
	mov di, 0
	mov cx, 57600
	
	black_fill:
	
		mov byte ptr es:[di], 3          ;3 to kolor czarny
		inc di
	loop black_fill
ret


