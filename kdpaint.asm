ASSUME cs:CODE
CODE SEGMENT

current_color db 1
PICBUFFER db 57600 dup(?)

main:
call set_graphical_mode
call init_colors                      
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

include menu.asm
include graph.asm
include mouse.asm
include io.asm

CODE ENDS

END main