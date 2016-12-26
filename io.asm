load_drawing:
	call open_file
	call read_from_file
ret

error:
	mov dx, seg error_message
	mov ds, dx
	lea dx, error_message
	mov ah, 9
	int 21h
	jmp exit_menu

save_drawing:

	call hide_mouse

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

	call create_file
	call write_to_file

ret

create_file:
	mov ah, 3ch
	mov dx, seg file_name
	mov ds, dx
	lea dx, file_name
	mov cx, 0
	int 21h
	jc error
ret

write_to_file:
	xchg bx, ax               ;teraz bx zawiera uchwyt fileu
	mov ah, 40h
	mov dx, seg PICBUFFER
	mov ds, dx
	lea dx, PICBUFFER
	mov cx, 57600            ;ilosc bajtow do zapisu
	int 21h
	call show_mouse
	jc error
ret

open_file:
	mov ah, 3dh              ;otwarcie fileu
	mov dx, seg file_name
	mov ds, dx
	lea dx, file_name
	mov al, 0
	int 21h
	jc error
ret

read_from_file:
	mov bx, ax               ;uchwyt do bx
	mov ah, 3fh              ;odczyt z fileu
	mov cx, 57600            ;tylu bajtow
	mov dx, 0a000h
	mov ds, dx
	mov dx, 0
	int 21h
	jc error
ret

file_name db "grafika.nfg", 0
error_message db "IO error$"
