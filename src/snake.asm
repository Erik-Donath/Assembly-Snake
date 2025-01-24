bits 16
org 0x7c00

; Interrupts
video equ 0x10
video_set_cursorform equ 0x01
video_set_cursor equ 0x02
video_scroll_up equ 0x06
video_write_char equ 0x0A

system_services equ 0x15
wait_service equ 0x86

start:
; Hide Cursor
mov ah, video_set_cursorform
mov ch, 0x20
mov cl, 0
int video

; Clear screen
mov ah, video_scroll_up
mov al, 0
mov bh, 07h ; fg = white; bg = black
mov cx, 0 ; top left
mov dx, 185Fh ; bottom right
int video

; Set default values
mov byte [snake_x], 0
mov byte [snake_y], 0

loop:

mov ah, wait_service
mov cx, 1
mov dx, 0
int system_services

; Set Cursor pos
mov ah, video_set_cursor
mov bh, 0
mov dh, [snake_y]
mov dl, [snake_x]
int video

; Print head
mov ah, video_write_char
mov al, '*'
mov bh, 0
mov cx, 1
int video

; Move player
inc byte [snake_x]
inc byte [snake_y]

; Check if not in bounds
cmp byte [snake_x], 80
jge gameover
cmp byte [snake_y], 25
jge gameover

jmp loop

gameover:
jmp start

snake_x: db 0
snake_y: db 0

times 510 - ($ - $$) db 0
dw 0xAA55