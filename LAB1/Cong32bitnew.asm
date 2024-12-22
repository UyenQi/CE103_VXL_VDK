.model small
.stack 100
.data
    tb1  DB 'Nhap so thu nhat: $'
    tb2  DB 13,10,'Nhap so thu hai: $'
    tb3  DB 13,10,'Tong:$'
    num1 DB 256 dup('$')
    num2 DB 256 dup('$')
    dem  DB 0       ; luu do dai cua so dai hon
    dem1 DB 0
    dem2 DB 0
.code
main proc
        mov ax, @data
        mov ds, ax
        ;Thong bao nhap so thu nhat
        lea dx, tb1
        mov ah, 9
        int 21h
        
        ;Nhap va luu so thu nhat
        lea si, num1+2 
        mov cl, 0
        call Nhapso 
        mov dem1, cl
        
        ;Tuong tu voi so thu hai
        lea dx, tb2
        mov ah, 9
        int 21h 
        
        lea si, num2+2
        mov cl, 0
        call Nhapso 
        mov dem2, cl 
        
        ;So sanh so nao dai hon 
        mov al, dem1
        mov bl, dem2
        sub al, 1
        sub bl, 1
        
        cmp al, bl
        jge Tieptuc
        mov dem ,bl
        jmp Continue
        
        Tieptuc:
        mov dem, al
        
        Continue:
        mov cx, 0 
        mov ax,0
        
        lea si, num1
        mov al, dem1
        add si, ax
        
        lea di, num2
        mov al, dem2
        add di, ax    
        mov dx, 0
        mov dh, dem 
        
        call Tinhtong
endp main
Nhapso proc    ; ham nhap va bien chuoi thanh so 
    mov ah, 1
    int 21h 
    sub al, 30h
    mov [si], al 
    add cl, 1
    add si, 1
    add al, 30h
    cmp al,13 
    jne Nhapso
    ret
endp Nhapso 

Tinhtong proc    ; tinh tong hai so
    Tinh:     
    mov al, [si] ; lay gia tri tu num1
    mov bl, [di] ; //             num2
    
    add al, bl 
    add al, cl   ; cl=1 khi al >= 10
    mov cl, 0
    cmp al, 10 
    
    jl Tinhtiep
    sub ax, 10
    add cl ,1
    Tinhtiep:
    push ax      ; dua al vao stack
    sub si, 1    
    sub di, 1  
    add dl, 1
    sub dem1, 1
    sub dem2, 1   
    
    cmp dl, dh
    je TH1
   
    cmp dem1, 1 
    jne Xettiep
    jmp TH2     
    
    Xettiep:
    cmp dem2, 1
    je TH3                          
    
    jmp Tinh
    
    TH1:     ; TH khi 2 so co do dai bang nhau
    push cx
    add dl, 1
    jmp Inra
     
    TH2:     ; Th khi so thu nhat dai hon
    mov al, [di]
    add al, cl  
    mov cl, 0
    cmp al, 10 
    
    jl TinhtiepA
    sub ax, 10
    add cl ,1 
    TinhtiepA:
    push ax 
    add dx ,1
    sub di ,1
    sub dem2, 1
    cmp dem2, 1 
    jne TH2
    jmp Inra
    
    TH3:    ; Th khi so thu hai dai hon
    mov al, [si]
    add al, cl
    mov cl, 0
    cmp al, 10 
    
    jl TinhtiepB
    sub ax, 10
    add cl ,1 
    TinhtiepB:
    push ax
    add dx, 1
    sub si, 1
    sub dem1, 1
    cmp dem1, 1 
    jne TH3
    jmp Inra
    
    Inra:
        mov bl, dl
        lea dx, tb3
        mov ah, 9
        int 21h    
        Lap:
            mov ah, 2  
            pop dx 
            add dl, 30h
            int 21h
            sub bl, 1
            cmp bx, 0
            jne Lap
    ret     
endp Tinhtong 