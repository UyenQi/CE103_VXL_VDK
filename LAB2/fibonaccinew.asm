.model small 
.stack 100
.data
    tb1 db 'Nhap so: $'
    tb2 db 10, 13, 'Chuoi fibonaci:$' 
    tb3 db 10, 13, 'Khong ton tai$'
    num db 10 dup('$')
    n dw 0 
    dem dw ?   
    Space db ' $'       
    num1 DB 256 dup('$')  
    num2 DB 256 dup('$')
    lenght db ?   ; do dai cua so
    lenght1 db ?  ; do dai cua so thu nhat
    lenght2 db ?  ; do dai cua so thu hai
    tang db 0
.code          
main proc
    mov ax, @data
    mov ds, ax
    
    ;Hien thi thong bao nhap so
    lea dx, tb1 
    mov ah, 9
    int 21h 
     
    ; Nhap 1 so co 2 chu so
    mov ah, 10 
    lea dx, num
    int 21h
     
    call ChuyenDoi 
    mov n, ax 
    
    cmp n, 0
    jg XuatChuoiFi 
    lea dx, tb3 
    mov ah, 9
    int 21h 
    jmp ENDCT 
    
    XuatChuoiFi:
    lea dx, tb2 
    mov ah, 9
    int 21h 
     
    ;Xuat hai so dau tien trong chuoi fibonacci 
     
    ;Neu n=1
    mov ax, n 
    mov bx, ax
    mov dem, ax
    cmp n, 1
    jne THkhac
    sub bx, 1
    jmp LOOPP
     ;Neu n=2
    Thkhac:
    sub bx, 2
    cmp n, 2
    jle LOOPP
     ; Neu n>2
    LOOPP:
    mov ah, 2
    mov dl, 31h
    int 21h 
    mov dl, Space
    int 21h 
    sub dem, 1
    cmp dem, bx     
    jg LOOPP 
    
    cmp dem, 0
    je ENDCT 
   
    
    ;Vao ham Fibonacci va in tung so
    mov ax, n
    mov dem, ax 
    
    mov cx, 0
    mov dx, 0
    call Fibonacci
    
    ENDCT:
    mov ah,4Ch
    int 21h 
    
endp main 

Fibonacci proc
    So_Fibon_thu_n: 
    lea si, num1+2 ;si luu dia chi num1+2 
    lea di, num2+2 ;di luu dia chi num2+2 
    mov [si], 1
    mov [di], 1
    mov lenght1, 1
    mov lenght2, 1
    mov lenght, 1  
    Laplai:  
        mov cx, 0
        lea si, num1+2
        lea di, num2+2
                       
        mov dx, 0               
        mov dh, lenght1
        call Tinhtong
        sub dem, 1
        cmp dem, 2
       
        jne Laplai
    ret       
endp Fibonacci 

ChuyenDoi proc 
    ; Chuyen chuoi thanh so 
    mov cl, [num+1] ; cl= chieu dai cua chuoi  
    lea si, num+2   ; gan si cho ki tu dau cua chuoi 
    mov ax, 0 
    mov bx, 10 
    chuyenthanhso:
        mul bx
        mov dl, [si]
        sub dx, '0'
        add ax, dx    
        inc si  ; si+=1
        dec cl  ; cl-=1
        cmp cl, 0 ; so sanh cl voi 0
        jne chuyenthanhso  ; dung thi ket thuc
        ret
endp ChuyenDoi 
    
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
    mov cl ,1
     
    Tinhtiep: 
    ; Lua tung so vao trong num1 va num2
    mov bl, [si]
    mov [di], bl      
    mov [si], al

    add si, 1    
    add di, 1  
    add dl, 1
    
    sub lenght1, 1
    sub lenght2, 1   
     
    cmp dl, dh  ; Do dai cua 2 so bang nhau thi nhay toi ham TH1
    je TH1 
    
    cmp lenght2, 0 
    je TH2     
    jmp Tinh
    
    TH1:     ; TH khi 2 so co do dai bang nhau
    cmp cl, 0
    je  Inra   
    
    add [si], 1
    jmp Inra
     
    TH2:     ; Th khi so thu nhat dai hon   
   
    ; Xet al>=10 thi [si+1]+1
    mov al, [si] 
    add al, cl  
    mov cl, 0
    cmp al, 10 
    
    jl TinhtiepTh2
    sub ax, 10
    add cl ,1 
    
    ; Dem nhung so con lai vao mang num1
    TinhtiepTh2: 
    mov bl, [si]
    mov [di], bl      
    mov [si], al
    add dx ,1
    sub di ,1
    sub lenght1, 1
    cmp lenght1, 0 
    jne TH2
   
    jmp Inra
    
        
    Inra: ;In so fibonacci thu n
        mov bl, lenght  
        mov lenght2, bl ; reset lai do dai 
        
        mov ah, 2
        cmp [si], 25h ;ban dau [si]=24 khi do dai cua so tang thi [si+1]+1=25
        jne Tiep      ; neu khong bang thi tiep tuc in neu khong thi [si+n+1]=1
        sub [si], 24h
        add lenght, 1
        Tiep: 
            mov bl, lenght  
            mov lenght1, bl  ; reset lai do dai
            lea si, num1+2
            sub bl, 1
            add si, bx 
        Lap:            ; in tung con so trong mang      
            mov dl, [si] 
            add dl, 30h 
            ; [si]<0 & [si]>9 thi in dau cach va tinh so fibonacci thu n+1
            cmp dl, 30h
            jl EndIn
            cmp dl, 39h  
            jg EndIn
            int 21h   
            sub si, 1
            jmp Lap 
    EndIn: 
        mov dl, Space
        int 21h     
    ret     
endp Tinhtong

