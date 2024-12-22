.model small 
.stack 100
.data
    tb1 db 'Nhap so: $'
    tb2 db 10, 13, 'Chuoi fibonaci:$' 
    tb3 db 10, 13, 'Khong ton tai$'
    num db 10 dup(' $')
    n db ?     
    i db ?
    t db 0  
    x dw 0 
    y dw 0
    z dw 0
    dem db ?   
    Space db ' $'
.code          
main:
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
    mov n, al       ; Luu so vua nhap vao n
    
    cmp n, 0
    jg Chuoifibi
    
    lea dx, tb3 
    mov ah, 9
    int 21h    
    jmp ENDCT 
    Chuoifibi:
    lea dx, tb2
    mov ah, 9
    int 21h
    mov al, n
         ; Luu dem= n
    
    cmp n, 0
    jg ChayCT
    
    lea dx, tb3 
    mov ah, 9
    int 21h    
    jmp ENDCT
    ;Chay chuong trinh 
    ChayCT:
    ; t+=1 moi khi quay lai vong lap t<n thi ket thuc
    add t, 1
    mov dx,0
    mov dl, t
    cmp dl, n
    jg ENDCT  
    
    mov x, 0
    mov y, 0
    call Fibonacci
    ;Xuat n Chuoi fibonacci
    Laplai:
        mov cx, 0
        mov bx, 10
        Lappush:
            mov dx, 0 
            div bx ;chia cho 10
            add dx, '0' 
            push dx
            inc cx ;increase : tang cx 1 don vi
            cmp ax,0
            jne Lappush
        
        Hienthi: ;hien thi tuwng ky tu o trong ngan xep
            pop dx ;lay 1 so o dau ngan xep*  
            mov ah, 2
            int 21h 
            Loop HienThi
    
    ; In dau cach
    lea dx, Space
    mov ah , 9
    int 21h
    
    jmp ChayCT
    
    ENDCT:
    mov ah, 4Ch       
    int 21h      
    

            
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

Fibonacci proc
  
    mov i, dl     ; luu i=dl de reset lai gia tri dl
    
    cmp dl, 2
    jg TH2
       
    mov ax, 1
    mov bx, 1
    ret
 
    TH2:
    sub dl, 1 

    call Fibonacci    ; F(n-1)
    
     
    mov x, ax
    mov y, bx
    mov dl, i
    sub dl, 2
    call Fibonacci    ; F(n-2)
    
    ; F(x)= F(x-1)+ F(x-2) voi x<=n  
    mov ax, x
    mov bx, y
    mov z, ax
    add ax, bx
    mov bx, z
   
    endtinh:
    ret       ; ket thuc de quy va in so fibo thu n

endp Fibonacci 

             
    
    
    
    
                   
    
    
    
    





