;nie funkcjonuje jako samodzielny program ale raczej jako biblioteka
set_colors:
	mov ax, 13h
	int 10h

	mov ax, 01ffh            ;01 kolor R=ff
	mov bx, 0202h            ;G=2   B=2
	call set_rgb_color

	mov ax, 0202h            ;02 kolor
	mov bx, 02ffh           
	call set_rgb_color

	mov ax, 0300h            ;3 kolor-czarny
	mov bx, 0
	call set_rgb_color

	mov ax, 04ffh
	mov bx, 0ffffh           ;4 kolor-bialy
	call set_rgb_color

	mov ax, 05ffh
	mov bx, 0ffh           ;5 kolor-fiolet
	call set_rgb_color

	mov ax, 0600h
	mov bx, 0ff00h           ;6 kolor-zielony
	call set_rgb_color

	mov ax, 07ffh
	mov bx, 0ff00h           ;7 kolor-zolty
	call set_rgb_color

	mov ax, 0800h
	mov bx, 0ffffh           ;8 kolor-turkus
	call set_rgb_color

	mov ax, 09a0h            ;9 kolor-szary
	mov bx, 0a0a0h
	call set_rgb_color

	;reszte kolorow ustawiam na odcienie szarosci
	mov cx, 244
	mov ax, 0ffffh
	mov bx, 0ffffh
	set_gray_colors:
			dec ax
			dec bx
			call set_rgb_color
	loop set_gray_colors

ret                     ;wyjscie z podprogramu

set_rgb_color:
	xchg ah,al              ;teraz al=numer koloru  ah=skladowa R
	mov dx,3c8h
	out dx,al               ;nr koloru
	inc dx
	mov al,ah              ;R
	out dx,al
	mov al,bh              ;G
	out dx,al
	mov al,bl               ;B
	out dx,al
ret
