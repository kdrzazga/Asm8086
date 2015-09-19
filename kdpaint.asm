ASSUME cs:CODE
CODE SEGMENT

kolor db 1
BUFOR db 57600 dup(?)

start:
mov ax,0013h
int 10h

call ustaw_kolory                      ;procedura w pliku kolory.asm

mov ax,1
int 33h

mov ax,8                        ;ustalenie granic dla kursora  myszy
mov cx,180
mov dx,1
int 33h

mov ax,0fh                      ;ustalenie szybkosci ruchu kursora
mov cx,85                       ;w poziomie
mov dx,50                       ;w pionie
int 33h

rysuj:
mov dx,0a000h
mov es,dx
mov ax,3
int 33h
test bx,1
jz Nie_stawiaj_punktu
push bx
mov ax,dx
mov bx,320
mul bx
shr cx,1
add ax,cx
mov di,ax
sub di,321
mov bl,kolor
mov es:[di],bl
pop bx

Nie_stawiaj_punktu:
test bx,2
jnz keypress
jmp rysuj


KONIEC:
mov ax,3
int 10h         ;tryb tekstowy
mov ax,4c01h    ;do DOSa
int 21h


keypress:
call show_menu
mov ah,8
int 21h
cmp al,27                       ;jesli ESC to koncz
je koniec
cmp al,'1'                      ;jesli 1 to kolor 
jne k2
mov kolor,1
k2:
cmp al,'2'
jne k3
mov kolor,2
k3:
cmp al,'3'
jne k4
mov kolor,3
k4:
cmp al,'4'
jne k5
mov kolor,4
k5:
cmp al,'5'
jne k6
mov kolor,5
k6:
cmp al,'6'
jne k7
mov kolor,6
k7:
cmp al,'7'
jne k8
mov kolor,7
k8:
cmp al,'8'
jne k9
mov kolor,8
k9:
cmp al,'9'
jne s
mov kolor,9
s:
cmp al,'s'
jne l
call zapisz_obrazek
l:
cmp al,'l'
jne c
call wczytaj_obrazek
c:
cmp al,'c'
jne back
call clrscr


back:
call hide_menu
jmp rysuj

show_menu:
;ustaw wspolrzedne
mov ah,2
mov dh,23       ;wiersz
mov dl,0        ;kolumna
mov bh,0
int 10h
;pisz
mov ah,9
mov al,4
mov dx,seg menu_tekst
mov ds,dx
lea dx,menu_tekst
int 21h
ret

hide_menu:
mov cx,6400
mov al,3        ;kolor czarny-kasowanie
mov dx,0a000h
mov es,dx
mov di,57600
cld
rep stosb
ret

;od tego miejsca praktycznie do konca listingu znajduje sie procedura
;wczytujaca obrazek na ekran

wczytaj_obrazek:
mov ah,3dh              ;otwarcie pliku
mov dx,seg plik
mov ds,dx
lea dx,plik
mov al,0
int 21h
jc error

mov bx,ax               ;uchwyt do bx
mov ah,3fh              ;odczyt z pliku
mov cx,57600            ;tylu bajtow
mov dx,0a000h
mov ds,dx
mov dx,0
int 21h
jc error
ret

error:
mov dx,seg blad
mov ds,dx
lea dx,blad
mov ah,9
int 21h
jmp back


zapisz_obrazek:

mov ax,2
int 33h         ;skasuj kursor myszy

;przerzuc dane do BUFORa
mov ax,0a000h
mov es,ax
mov dx,seg BUFOR
mov ds,dx
lea dx,BUFOR        
mov di,0
mov cx,57600
skok_rzut:
mov bl,es:[di]
mov ds:[di],bl
inc di
loop skok_rzut

;stworzenie pliku
mov ah,3ch
mov dx,seg plik
mov ds,dx
lea dx,plik
mov cx,0
int 21h
jc error

;zapis do pliku
xchg bx,ax               ;teraz bx zawiera uchwyt pliku
mov ah,40h
mov dx,seg BUFOR
mov ds,dx
lea dx,BUFOR
mov cx,57600            ;ilosc bajtow do zapisu
int 21h
mov ax,1
int 33h
jc error

ret

include kolory.asm
include clrscr.asm

plik db "grafika.nfg",0
blad db "Jakis blad i/o$"
menu_tekst db "1red 2blu 3blk 4wht 5pur 6grn 7yel 8tur 9gray s-save l-load c-clear ESC-exit$"
CODE ENDS

END start

