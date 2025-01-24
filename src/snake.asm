bits 16
org 0x7c00

; Interrupts
video equ 0x10
set_cursorform equ 0x01
set_cursor_pos equ 0x02
scroll_up equ 0x06
write_char equ 0x0A

keyboard equ 0x16
keyboard_read equ 0x00
keystroke_status equ 0x01

system_services equ 0x15
wait_service equ 0x86

debug_port equ 0xE9

; Keyboard scan codes
left_arrow equ 0x4b
right_arrow equ 0x4d
down_arrow equ 0x50
up_arrow equ 0x48

start:
; Debug Start
mov al, 'S'
out debug_port, al

; Hide Cursor
mov ah, set_cursorform
mov ch, 0x20
mov cl, 0
int video

; Set Cursor pos to (0, 0)
mov ah, set_cursor_pos
mov bh, 0
mov dh, 0
mov dl, 0
int video

; Clear screen
mov ah, scroll_up
mov al, 0
mov bh, 07h ; fg = 7 white; bg = 0 black
mov cx, 0 ; top left
mov dx, 185Fh ; bottom right
int video

; Set default values
mov byte [dir_x], 1
mov byte [dir_y], 0

mov byte [snake_x], 40
mov byte [snake_y], 12

loop:
; wait
mov ah, wait_service
mov cx, 1
mov dx, 0
int system_services

; Clear head
mov ah, write_char
mov al, ' '
mov bh, 0
mov cx, 1
int video

; Set Cursor pos
mov ah, set_cursor_pos
mov bh, 0
mov dh, [snake_y]
mov dl, [snake_x]
int video

; Print head
mov ah, write_char
mov al, '*'
mov bh, 0
mov cx, 1
int video

; Move player
call handle_input
mov ah, [dir_x]
add byte [snake_x], ah
mov ah, [dir_y]
add byte [snake_y], ah

; Check if x is out of bounds
cmp byte [snake_x], 0
jl gameover
cmp byte [snake_x], 80
jge gameover

; Check if y is out of bounds
cmp byte [snake_y], 0
jl gameover
cmp byte [snake_y], 25
jge gameover

; Game Loop
jmp loop

gameover:
; Debug game over
mov al, 'G'
out debug_port, al

; wait
mov ah, wait_service
mov cx, 0xA
mov dx, 0
int system_services

; Restart
jmp start

handle_input:
; Check if input is available
mov ah, keystroke_status
int keyboard
jz .end

; Read scan code -> ah
mov ah, keyboard_read
int keyboard

; Set direction based on arrow keys
.check_left:
cmp ah, left_arrow
jne .check_right
mov byte [dir_x], -1
mov byte [dir_y], 0
jmp .end

.check_right:
cmp ah, right_arrow
jne .check_up
mov byte [dir_x], 1
mov byte [dir_y], 0
jmp .end

.check_up:
cmp ah, up_arrow
jne .check_down
mov byte [dir_x], 0
mov byte [dir_y], -1
jmp .end

.check_down:
cmp ah, down_arrow
mov byte [dir_x], 0
mov byte [dir_y], 1

.end:
ret

; Direction
dir_x: db 0
dir_y: db 0

; Snake head
snake_x: db 0
snake_y: db 0

times 510 - ($ - $$) db 0
dw 0xAA55