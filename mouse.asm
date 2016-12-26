hide_mouse:
	mov ax, 2
	int 33h
ret

show_mouse:
	mov ax, 1
	int 33h
ret

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
