ASSUME cs:CODE
CODE SEGMENT

current_color db 1
PICBUFFER db 57600 dup(?)

main:
mov ax,0013h
int 10h

call set_colors                      ;in colors.asm

mov ax,  1
int 33h

call set_mouse_movement_bounds
call set_mouse_movement_speed

draw:
mov dx, 0a000h
mov es, dx
mov ax, 3
int 33h
test bx, 1
jz no_point
push bx
mov ax, dx
mov bx, 320
mul bx
shr cx, 1
add ax, cx
mov di, ax
sub di, 321
mov bl, current_color
mov es:[di], bl
pop bx

no_point:
	test bx, 2
	jnz keypress
	jmp draw

exit:
	mov ax, 3
	int 10h         ;tryb tekstowy
	mov ax, 4c01h    ;do DOSa
	int 21h

set_mouse_movement_bounds:
	mov ax, 8
	mov cx, 180
	mov dx, 1
	int 33h
ret

set_mouse_movement_speed:
	mov ax, 0fh
	mov cx, 85                       ;horizontal speed
	mov dx, 50                       ;vertical speed
	int 33h
ret

keypress:
	call show_menu
	mov ah,8
	int 21h
	cmp al,27                       ;jesli ESC to koncz
	je exit
	cmp al,'1'                      ;jesli 1 to current_color 
	jne k2
	mov current_color,1
	k2:
	cmp al,'2'
	jne k3
	mov current_color,2
	k3:
	cmp al,'3'
	jne k4
	mov current_color,3
	k4:
	cmp al, '4'
	jne k5
	mov current_color,4
	k5:
	cmp al, '5'
	jne k6
	mov current_color,5
	k6:
	cmp al, '6'
	jne k7
	mov current_color,6
	k7:
	cmp al, '7'
	jne k8
	mov current_color,7
	k8:
	cmp al, '8'
	jne k9
	mov current_color,8
	k9:
	cmp al, '9'
	jne s
	mov current_color,9
	s:
	cmp al, 's'
	jne l
	call save_drawing
	l:
	cmp al,'l'
	jne c
	call load_drawing
	c:
	cmp al,'c'
	jne exit_menu
	call clrscr

exit_menu:
	call hide_menu
	jmp draw

show_menu:
	;ustaw wspolrzedne
	mov ah, 2
	mov dh, 23       ;wiersz
	mov dl, 0        ;kolumna
	mov bh, 0
	int 10h
	;pisz
	mov ah, 9
	mov al, 4
	mov dx, seg menu_tekst
	mov ds, dx
	lea dx, menu_tekst
	int 21h
ret

hide_menu:
	mov cx, 6400
	mov al, 3        ;current_color czarny-kasowanie
	mov dx, 0a000h
	mov es, dx
	mov di, 57600
	cld
	rep stosb
ret

;od tego miejsca praktycznie do konca listingu znajduje sie procedura
;wczytujaca obrazek na ekran

load_drawing:
	mov ah, 3dh              ;otwarcie fileu
	mov dx, seg file_name
	mov ds, dx
	lea dx, file_name
	mov al, 0
	int 21h
	jc error

	mov bx, ax               ;uchwyt do bx
	mov ah, 3fh              ;odczyt z fileu
	mov cx, 57600            ;tylu bajtow
	mov dx, 0a000h
	mov ds, dx
	mov dx, 0
	int 21h
	jc error
ret

error:
	mov dx, seg error_message
	mov ds, dx
	lea dx, error_message
	mov ah, 9
	int 21h
	jmp exit_menu

save_drawing:

	mov ax, 2
	int 33h         ;skasuj kursor myszy

	;przerzuc dane do PICBUFFERa
	mov ax, 0a000h
	mov es, ax
	mov dx, seg PICBUFFER
	mov ds, dx
	lea dx, PICBUFFER        
	mov di, 0
	mov cx, 57600
	copy_memory:
	mov bl, es:[di]
	mov ds:[di], bl
	inc di
	loop copy_memory

	;file creation
	mov ah, 3ch
	mov dx, seg file_name
	mov ds, dx
	lea dx, file_name
	mov cx, 0
	int 21h
	jc error

	;write to file
	xchg bx, ax               ;teraz bx zawiera uchwyt fileu
	mov ah, 40h
	mov dx, seg PICBUFFER
	mov ds, dx
	lea dx, PICBUFFER
	mov cx, 57600            ;ilosc bajtow do zapisu
	int 21h
	mov ax, 1
	int 33h
	jc error

ret

include colors.asm
include clrscr.asm

file_name db "grafika.nfg",0
error_message db "IO error$"
menu_tekst db "1red 2blu 3blk 4wht 5pur 6grn 7yel 8tur 9gray s-save l-load c-clear ESC-exit$"
CODE ENDS

END main