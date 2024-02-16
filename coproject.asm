.data segment


    state db 32h, 88h, 31h, 0e0h, 43h, 5ah, 31h, 37h, 0f6h, 30h, 98h, 07h, 0a8h, 8dh, 0a2h, 34h 
    ;state db 16 dup(?)
    
    sTable db 63h, 7ch, 77h, 7bh, 0f2h, 6bh, 6fh, 0c5h, 30h, 01h, 67h, 2bh, 0feh, 0d7h, 0abh, 76h
    db 0cah, 82h, 0c9h, 7dh, 0fah, 59h, 47h, 0f0h, 0adh, 0d4h, 0a2h, 0afh, 9ch, 0a4h, 72h, 0c0h
    db 0b7h, 0fdh, 93h, 26h, 36h, 3fh, 0f7h, 0cch, 34h, 0a5h, 0e5h, 0f1h, 71h, 0d8h, 31h, 15h
    db 04h, 0c7h, 23h, 0c3h, 18h, 96h, 05h, 9ah, 07h, 12h, 80h, 0e2h, 0ebh, 27h, 0b2h, 75h
    db 09h, 83h, 2ch, 1ah, 1bh, 6eh, 5ah, 0a0h, 52h, 3bh, 0d6h, 0b3h, 29h, 0e3h, 2fh, 84h
    db 53h, 0d1h, 00h, 0edh, 20h, 0fch, 0b1h, 5bh, 6ah, 0cbh, 0beh, 39h, 4ah, 4ch, 58h, 0cfh
    db 0d0h, 0efh, 0aah, 0fbh, 43h, 4dh, 33h, 85h, 45h, 0f9h, 02h, 7fh, 50h, 3ch, 9fh, 0a8h
    db 51h, 0a3h, 40h, 8fh, 92h, 9dh, 38h, 0f5h, 0bch, 0b6h, 0dah, 21h, 10h, 0ffh, 0f3h, 0d2h
    db 0cdh, 0ch, 13h, 0ech, 5fh, 97h, 44h, 17h, 0c4h, 0a7h, 7eh, 3dh, 64h, 5dh, 19h, 73h
    db 60h, 81h, 4fh, 0dch, 22h, 2ah, 90h, 88h, 46h, 0eeh, 0b8h, 14h, 0deh, 5eh, 0bh, 0dbh
    db 0e0h, 32h, 3ah, 0ah, 49h, 06h, 24h, 5ch, 0c2h, 0d3h, 0ach, 62h, 91h, 95h, 0e4h, 79h
    db 0e7h, 0c8h, 37h, 6dh, 8dh, 0d5h, 4eh, 0a9h, 6ch, 56h, 0f4h, 0eah, 65h, 7ah, 0aeh, 08h
    db 0bah, 78h, 25h, 2eh, 1ch, 0a6h, 0b4h, 0c6h, 0e8h, 0ddh, 74h, 1fh, 4bh, 0bdh, 8bh, 8ah
    db 70h, 3eh, 0b5h, 66h, 48h, 03h, 0f6h, 0eh, 61h, 35h, 57h, 0b9h, 86h, 0c1h, 1dh, 9eh
    db 0e1h, 0f8h, 98h, 11h, 69h, 0d9h, 8eh, 94h, 9bh, 1eh, 87h, 0e9h, 0ceh, 55h, 28h, 0dfh
    db 8ch, 0a1h, 89h, 0dh, 0bfh, 0e6h, 42h, 68h, 41h, 99h, 2dh, 0fh, 0b0h, 54h, 0bbh, 16h
    
    rcon db 01h, 02h, 04h, 08h, 10h, 20h, 40h, 80h, 1bh, 36h
     
    key db 2bh, 28h, 0abh, 09h, 7eh, 0aeh, 0f7h, 0cfh, 15h, 0d2h, 15h, 4fh, 16h, 0a6h, 88h, 3ch 
    ;key db 16 dup(0ffh)
    
    col db 4 dup(00h) 

    numbers db "0123456789ABCDEF"
ends    

.code segment

   
subbyte macro dt
    mov ax, 0000H
    mov al, dt
    mov di, ax
    mov al, sTable[di]
    mov dt, al    
endm


subrows macro
    push cx
    mov cx, 0010h
    L1: mov si,cx 
        subbyte state[si][-1]
    loop L1
    pop cx
endm


rotate macro t1, t2, t3, t4
    mov ah, t4
    mov al, t3
    mov t4, al
    mov al, t2
    mov t3, al
    mov al, t1
    mov t2, al
    mov t1, ah
endm


shufflerows macro
    push cx
    mov cx, 0003h
    mov di, 0000H
    mov bx, 0000H
    L2: add di, 0004h 
        push cx
        inc bx
        mov cx, bx
        L3: rotate state[di][3], state[di][2], state[di][1], state[di][0]
        loop L3
        pop cx   
    loop L2
    pop cx
endm


prod2 macro t
    mov al, t
    mov ah, al
    and ah, 80h
    rol ah, 1
    dec ah
    not ah
    and ah, 1bh
    shl al, 1
    xor al, ah
    mov t, al
endm


prod3 macro t
    mov dl, t
    prod2 dl
    xor dl, t
    mov t, dl
endm


mix macro t1, t2, t3, t4, dst
    mov bl, t1
    prod2 bl
    mov bh, t2
    prod3 bh
    xor bl, bh
    xor bl, t3
    xor bl, t4
    mov dst, bl 
endm
  

mix4 macro t1, t2, t3, t4
    mov dl, t1
    mov col[0], dl
    mov dl, t2
    mov col[1], dl
    mov dl, t3
    mov col[2], dl
    mov dl, t4
    mov col[3], dl
    mix col[0], col[1], col[2], col[3], dh
    mov t1, dh
    mix col[1], col[2], col[3], col[0],  dh
    mov t2, dh
    mix col[2], col[3], col[0], col[1], dh
    mov t3, dh
    mix col[3], col[0], col[1], col[2], dh
    mov t4, dh
endm


mixcolumns macro
    push cx
    mov cx, 0004h
    mov di, 0004h
    L4: dec di
        mix4  state[di], state[di][4], state[di][8], state[di][12]   
    loop L4
    pop cx
endm


xor2 macro t1, t2
    mov al, t1
    xor al, t2
    mov t1, al
endm


addkeyI macro
    mov cx, 0010h
    L5: mov si, cx
        xor2 state[si][-1], key[si][-1]
    loop L5
endm


addkey macro
    push cx
    mov cx, 0010h
    L6: mov si, cx
        xor2 state[si][-1], key[si][-1]
    loop L6
    pop cx
endm


createkey macro n
    push cx
    mov bl, key[3][4]
    mov bh, key[3][8]
    mov dl, key[3][12]
    mov dh, key[3][0]
    subbyte bl
    subbyte bh
    subbyte dl
    subbyte dh    
    xor bl, key[0]
    xor bh, key[0][4]
    xor dl, key[0][8]
    xor dh, key[0][12]
    xor bl, rcon[n - 1]
    mov key[0], bl
    mov key[0][4], bh
    mov key[0][8], dl
    mov key[0][12], dh
    mov cx, 0003H
    mov si, 0001H
    L7: xor2 key[si], key[si][-1]
        xor2 key[si][4], key[si][4][-1]
        xor2 key[si][8], key[si][8][-1]
        xor2 key[si][12], key[si][12][-1]
        inc si
    loop L7
    pop cx
endm


macro printbyte t
    mov dl, t
    mov ah, 02
    int 21h   
endm


macro newline
    printbyte 0ah
    printbyte 0dh
endm


macro printhexval t
    push bx
    mov bl, t;
    and bx, 000f0h;
    shr bl, 4
    printbyte numbers[bx]
    mov bl, t;
    and bx, 000fh;
    printbyte numbers[bx]
    pop bx
endm


macro output
    push cx
    mov cx, 4
    mov bp, 0
    L8:
        push cx
        mov cx, 4
        mov si, 0
        L9:   
            printhexval ds:state[bp][si]
            printbyte ' '
            inc si
        loop L9
        newline
        pop cx
        inc bp
    loop L8
    pop cx
endm


inchar macro
    mov ah, 1
    int 21h
endm


getval macro t
    cmp t, 61h
    jb let
    sub t, 27h
    let: sub t, 30h
endm


getval2 macro t
    cmp t, 61h
    jb let2
    sub t, 27h
    let2: sub t, 30h
endm


input macro
    mov cx, 16
    mov bx, 0
    L10:
        inchar
        mov dh, al
        getval dh
        shl dh, 4
        inchar
        mov dl, al
        getval2 dl
        add dl, dh
        mov state[bx], dl
        inchar
        inc bx
    loop L10
endm


main proc
    mov ax, @data
    mov ds, ax
    addkeyI
    mov cx, 000AH
    L: subrows
        shufflerows
        cmp cx, 0001H
        je J 
        mixcolumns
        J: mov bp, 0BH
        sub bp, cx
        createkey bp
        addkey    
    loop L
    output    
    hlt
endp
end main
ends