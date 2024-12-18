BITS 16
CPU 8086


section .data                   ;section declaration

tempbuffer:
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

new_line:	db 10, 0
new_space:  db " ", 0

msg_banner:	db "ROM Fonts Checker by Rafael Diniz",10,0
msg_vgain:	db "Entering GFX Mode",10,0
msg_vgaout:	db "Leaving GFX Mode",10,0


section .text                   ;section declaration
align   2

global _main

    ;; some auxiliary functions
strlen:
    push di
    push cx
    mov al,0
    mov cx,-1
    cmp cx,cx
    cld
    repnz
    scasb
    neg cx
    dec cx
    dec cx
    xchg ax,cx
    pop cx
    pop di
    ret
strpos:
    push di
    push cx
    push ax
    call strlen
    xchg cx,ax
    pop ax
    mov cx,-1
    cld
    repnz
    scasb
    neg cx
    dec cx
    dec cx
    xchg ax,cx
    pop cx
    pop di
    ret
strnpos:
    push di
    push cx
    push ax
    call strlen
    xchg cx,ax
    pop ax
    mov cx,-1
    cld
    repz
    scasb
    neg cx
    dec cx
    dec cx
    xchg ax,cx
    pop cx
    pop di
    ret
strrev:
    push si
    push di
    push ax
    mov si,di
    call strlen
    dec ax
    add si,ax
___strrev:
    mov al,[di]
    mov ah,[si]
    mov [si],al
    mov [di],ah
    inc di
    dec si
    cmp di,si
    jl ___strrev
    pop ax
    pop di
    pop si
    ret
printnum:
    push di
    push bx
    mov di,tempbuffer
    mov bx,10
    call ntos
    call prints
    pop bx
    pop di
    ret
prints:
    push ax
    push bx
    push cx
    push dx
    call strlen
    mov cx,di
    mov dx,ax
    mov bx,1                    ; printing to stdout
    mov ax,4                    ; write
    int 80h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ntos: ;(ax=num,bx=base,di=string)
    push ax
    push bx
    push cx
    push dx
    push di
___ntos:
    xor dx,dx
    div bx
    xchg ax,cx
    mov al,dl
    cmp al,9
    jle ___notalpha
    add al,7
___notalpha:
    add al,48
    mov [di],al
    inc di
    xchg cx,ax
    cmp ax,0
    jne ___ntos
    mov word [di],0
    pop di
    call strrev
    pop dx
    pop cx
    pop bx
    pop ax
    ret

_main:
    push    bp
    mov     bp, sp
    sub     sp, 4

    mov di, msg_banner
    call prints

    mov di,msg_vgain
    call prints

    mov ax,0x12                 ;  640x480
    int 0x10

    mov     ax,0x1130               ; function to address the charactor tables
    mov     bh,0x02                 ;  get addr of ROM 8x14 font
    int     0x10
    call print_info

    mov     ax,0x1130               ; function to address the charactor tables
    mov     bh,0x03                 ;  get addr of ROM 8x8 font
    int     0x10
    call print_info

    mov     ax,0x1130               ; function to address the charactor tables
    mov     bh,0x04                 ;  get addr of ROM 8x8 font (2nd half)
    int     0x10
    call print_info

    mov     ax,0x1130               ; function to address the charactor tables
    mov     bh,0x05                 ;  get addr of ROM 9x14 alternate font
    int     0x10
    call print_info

    mov     ax,0x1130               ; function to address the charactor tables
    mov     bh,0x06                 ;  get addr of ROM 8x16 font (VGA)
    int     0x10
    call print_info

    mov     ax,0x1130               ; function to address the charactor tables
    mov     bh,0x07                 ;  get addr of ROM 8x16 alternate font (VGA)
    int     0x10
    call print_info

    mov     ax,0x1130               ; function to address the charactor tables
    mov     bh,0x08                 ; wrong function (to see what happens)
    int     0x10
    call print_info

    mov di,msg_vgaout
    call prints

    mov ax,0x3                 ;  text mode
    int 0x10


exit:
    mov     bx,0
    mov     ax,1
    int     0x80

print_info:
    push    dx
    push    cx
    push    bp

    mov     ax,es
    call    printnum
    call    printspc

    pop bp

    mov     ax,bp
    call    printnum
    call    printspc

    pop cx

    mov     ax,cx
    call    printnum
    call    printspc

    pop     dx
    mov     dh, 0
    mov     ax,dx
    call    printnum
    call    printnl
    ret

printnl:
    push    ax
    push    bx
    push    cx
    push    dx

    mov     dx, 1
    mov     cx, new_line
    mov     bx,1
    mov     ax,4
    int     0x80

    pop     dx
    pop     cx
    pop     bx
    pop     ax
    ret

printspc:
    push    ax
    push    bx
    push    cx
    push    dx

    mov     dx, 1
    mov     cx, new_space
    mov     bx,1
    mov     ax,4
    int     0x80

    pop     dx
    pop     cx
    pop     bx
    pop     ax
    ret
