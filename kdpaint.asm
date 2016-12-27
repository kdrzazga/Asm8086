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

	main_draw_loop:
		mov dx, 0a000h
		mov es, dx
		mov ax, 3
		int 33h
		test bx, 1
		;jz dont_draw_point
		
		jnz on_left_mouse_click
		
		dont_draw_point:
			test bx, 2
			jnz on_right_mouse_click
		
	jmp main_draw_loop

	exit:
		call set_text_mode
	mov ax, 4c01h
	int 21h

	include mouse.asm
	include menu.asm
	include graph.asm
	include io.asm

	CODE ENDS

END main
