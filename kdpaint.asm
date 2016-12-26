ASSUME cs:CODE
CODE SEGMENT

current_color db 1
PICBUFFER db 57600 dup(?)

main:
call set_graphical_mode
call set_colors                      
call show_mouse						 
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
		jnz on_keypressed
	
jmp draw

exit:
	call set_text_mode
	mov ax, 4c01h
	int 21h

on_keypressed:
	call show_menu
	mov ah, 8
	int 21h
	cmp al, 27                       ;ESC
	je exit
	cmp al, '1'                      
	jne k2
	mov current_color,1
	k2:
	cmp al, '2'
	jne k3
	mov current_color,2
	k3:
	cmp al, '3'
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
	cmp al, 'l'
	jne c
	call load_drawing
	c:
	cmp al, 'c'
	jne exit_menu
	call clrscr

exit_menu:
	call hide_menu
	jmp draw

show_menu:
	;set menu coordinates
	mov ah, 2
	mov dh, 23       ;row
	mov dl, 0        ;column
	mov bh, 0
	int 10h
	;display menu
	mov ah, 9
	mov al, 4
	mov dx, seg menu_content
	mov ds, dx
	lea dx, menu_content
	int 21h
ret

hide_menu:
	mov cx, 6400
	mov al, 3        ;current_color BLK
	mov dx, 0a000h
	mov es, dx
	mov di, 57600
	cld
	rep stosb
ret

include graph.asm
include mouse.asm
include io.asm

menu_content db "1red 2blu 3blk 4wht 5pur 6grn 7yel 8tur 9gray s-save l-load c-clear ESC-exit$"
CODE ENDS

END main