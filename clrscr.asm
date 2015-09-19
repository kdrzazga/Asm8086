clrscr:
mov ax,0a000h
mov es,ax
mov di,0
mov cx,57600
czysc:
mov byte ptr es:[di],3          ;3 to kolor czarny
inc di
loop czysc
ret


