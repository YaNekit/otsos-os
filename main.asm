org 0x7C00
bits 16

%define newline 13, 10
%define end 0

jmp main

clear_screen:
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 01h
    mov ch, 0
    mov cl, 7
    int 0x10

    ret

movement:
    mov ah, 00h
    int 0x16

    cmp ah, 4dh
    je moveRight

    cmp ah, 4bh
    je moveLeft

    cmp ah, 48h
    je moveUp

    cmp ah, 50h
    je moveDown

    cmp al, 13
    je checkEnter

    jmp movement

checkEnter:
    mov ah, 03h
    mov bh, 0
    int 10h

    cmp dl, 10
    je checkReboot

    call movement

checkReboot:
    cmp dh, 10
    je checkReboot2
    
    call movement

checkReboot2:
    cmp dl, 10
    je reboot

    call movement

moveCursor:
    mov dl, byte[cursorX]
    mov dh, byte[cursorY]
    mov ah, 02h
    int 0x10

    call movement

moveRight:
    inc byte[cursorX]
    call moveCursor

moveLeft:
    dec byte[cursorX]
    call moveCursor

moveDown:
    inc byte[cursorY]
    call moveCursor

moveUp:
    dec byte[cursorY]
    call moveCursor

print_string:
    mov al, [si]
    inc si

    or al, al
    jz exit

    mov ah, 0eh
    int 0x10

    jmp print_string

    exit:
        mov ah, 0eh
        mov al, 13
        int 0x10

        mov al, 10
        int 0x10

        ret

reboot:
    int 19h

data:
    tutorial: db 'Welcome to otsOS tutorial!', newline, newline, newline, newline, newline,
              db 'Up Arrow - move cursor up', newline,
              db 'Down Arrow - move cursor down', newline,
              db 'Left Arrow - move cursor left', newline,
              db 'Right Arrow - move cursor right', newline, newline, newline, newline,
              db newline, newline, newline, newline, newline, newline, newline, newline,
              db newline, newline, newline,
              db 'Press any key to continue...', end

    logo: db 'otsOS Test Build 2.1', end
    rebootApp: db 'Reboot', end

    cursorX dw 0
    cursorY dw 1

main:
    ; Tutorial
    call clear_screen

    mov si, tutorial
    call print_string

    mov ah, 00h
    int 16h

    ; After tutorial
    call clear_screen

    mov si, logo
    call print_string

    ; Add Reboot Icon
    mov dl, 10
    mov dh, 10
    mov ah, 02h
    int 0x10

    mov ah, 0eh
    mov al, '!'
    int 0x10

    mov dl, 7
    mov dh, 12
    mov ah, 02h
    int 0x10

    mov si, rebootApp
    call print_string

    call movement

times 510-($-$$) db 0
dw 0AA55h