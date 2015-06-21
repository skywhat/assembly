 SetScreen macro
         Scroll 0,0,0,24,79,02h
         Scroll 19,3,4,21,75,50h 
         Scroll 15,5,6,19,73,2fh 
         Curse  5,7 
      endm          			
SCROLL    MACRO     N,ULR,ULC,LRR,LRC,ATT	
          MOV       AH,6				
          MOV       AL,N		
          MOV       CH,ULR		
          MOV       CL,ULC		
          MOV       DH,LRR		
          MOV       DL,LRC		
          MOV       BH,ATT		
          INT       10H
          ENDM  
CURSE     MACRO     CURY,CURX    
          MOV       AH,2		     	
          MOV       DH,CURY			
          MOV       DL,CURX			
          MOV       BH,0			
          INT       10H
ENDM
push5    macro
    push ax
    push bx
    push cx
    push dx
    push si
endm

pop5  macro
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
endm


 STACK SEGMENT PARA STACK 'STACK'
	DB 20 DUP('STACK   ')
 STACK ENDS
DATASG SEGMENT 
 str1 db "----------------------------------------------------",10,13 
      ;db "          simple dictionary                         ",10,13 
      db "          please input the numerical instruction:   ",10,13
      db "          1.add a new word                          ",10,13
      db "          2.change a word                           ",10,13 
      db "          3.delete a word                           ",10,13 
      db "          4.search a word                           ",10,13 
      db "          0.exit                                    ",10,13
      db "----------------------------------------------------",10,13,"$"
 sub_1 db "      add a new word!$"
 sub_2 db "      change a word$"
 sub_3 db "      delete a word$"  
 sub_4 db "      search a word$"  
 error db "      this is an error!$" 
 explainstr db "interpretation:$"
 synonymstr db "synonym:$"
 autonymstr db "autonym:$" 
 nowordstr db "this word is not existed!$"
    
 word  db 'again$',4 dup(0)
       db 'agree$',4 dup(0) 
       db 'born$',5 dup(0)
       db 'cat$', 6 dup(0)
      db 'dog$',6 dup(0)
      db 'eat$',6 dup(0)
      db 'fish$',5 dup(0)
      db 'graduate$',1 dup(0)
       db 'hot$',6 dup(0) 
       db 'ill$',6 dup(0)
       db 'joke$',5 dup(0)
       db 'king$',5 dup(0) 
       db 'look$',5 dup(0) 
       db 'milk$',5 dup(0)  
       db 'nurse$',4 dup(0) 
      db 'orange$',3 dup(0)       
       db 'play$',5 dup(0)
      db 'queen$',4 dup(0) 
      db 'rule$',5 dup(0)
      db 'sky$',6 dup(0)
      db 'think$',4 dup(0)
       db 'unite$',4 dup(0)
       db 'vitory$',3 dup(0)
      db 'window$',3 dup(0)
      db 'xray$',5 dup(0)
       db 'year$',5 dup(0)
      db 'zoo$',6 dup(0) 
       db  10 dup(0)
       db  10 dup(0)
       db  10 dup(0)
       db  '$',9 dup(0)
       db 100 dup(0) 
num dw 5 
wordlen dw 10
explainlen dw 30
synonymlen dw 10     
wordh db 10 dup(0) 
explainh db 30 dup(0)  
synonymh db 10 dup(0)  
autonymh db 10 dup(0)    
n db 100 dup(0)      
cnt dw 100 dup(0)     
flag db 10 dup(0)     
explain  db 'one more time$',16 dup(0)
         db 'you think somebody is right$',2 dup(0) 
         db 'the completion of a course$',3 dup(0)
         db "to draw one's first breath$",3 dup(0)
         db 'one kind of cute animal$',6 dup(0) 
         db 300 dup(0)
         db '$'
                              
synonym  db 'once more$' 
         db 'favour$',3 dup(0)
         db 'finish$',3 dup(0)
         db 'birth$',4 dup(0)
         db 'kitty$',4 dup(0)
         db 100 dup(0) 
         db '$'  

autonym db 'never$',4 dup(0)
        db 'disagree$',1 dup(1)
        db 'study$',4 dup(0)
        db 'unborn$',3 dup(0)
        db 'n autonym$' 
        db 100 dup(0) 
        db '$'
DATASG ENDS
; *********************
EXTRA SEGMENT                                   
; DATA GOES HEAR 
EXTRA ENDS
; *********************
CODESG SEGMENT                  
;----------------------
MAIN PROC FAR
  ASSUME CS:CODESG,DS:DATASG,ES:EXTRA,SS:STACK
 PUSH DS
 MOV AX,0
 PUSH AX
 MOV  AX,DATASG
 MOV  DS,AX
 MOV  AX,EXTRA
 MOV  ES,AX
; MAIN PART OF PROGRAM GOES HEAR    
 SetScreen  
START:    LEA DX,STR1
      MOV AH,9H
      INT 21H
      MOV AH,1
      INT 21H
      MOV CL, AL


      MOV AL, CL
      CMP AL, 31H
      JZ SUB1
      CMP AL,32H
      JZ SUB2 
      CMP AL,33H
      JZ SUB3
      CMP AL,34H
      JZ SUB4  
      CMP AL,30H
      JZ EXIT
      LEA DX, ERROR
      MOV AH, 9
      INT 21H
      MOV AH, 1
      INT 21H
      JMP START
SUB1: push5        
      SetScreen      
      pop5 
      lea dx,sub_1
      mov ah,09h
      int 21h 
      curse 0,0
      call new_word
      MOV AH, 1
      INT 21H
      push5
      SetScreen
      pop5
      JMP START
SUB2: push5  
      SetScreen
      pop5 
      LEA DX, SUB_2
	  MOV AH, 9
	  INT 21H 
	  curse 0,0 
      call change
      MOV AH, 1
      INT 21H  
      push5
      SetScreen
      pop5
      JMP START       
SUB3: push5  
      SetScreen
      pop5  
      LEA DX, SUB_3
	  MOV AH, 9
	  INT 21H 
	  curse 0,0
	  call deletew
      MOV AH, 1
      INT 21H  
      push5
      SetScreen
      pop5
      JMP START
SUB4: push5  
      SetScreen
      pop5
      LEA DX, SUB_4
	  MOV AH, 9
	  INT 21H 
      curse 0,0
      mov n,0 
      call search_ex 
      mov ah,1
      int 21h
      push5
      SetScreen
      pop5
      JMP START 

 EXIT:  RET
	MAIN ENDP     
;*****************************************
;???? 
change proc near 
    push5
    push di
    curse 0,0
    call search_ex
    cmp flag,0
    jz exitchan 
    mov ax,cnt 
    mov cx,3
    mul cx
    mov si,ax 
    Scroll 2,5,6,19,73,2fh 
    curse 19,6
    lea dx,explainstr
    mov ah,09
    int 21h    
    dec si
    inputec:
    inc si
    mov ah,01
    int 21h
    mov explain[si],al
    cmp al,'$'
    jnz inputec  
    exitchan:
    pop di
    pop5 
    ret
change endp


deletew proc near
   push5
   push di
   curse 0,0
   call search_ex
   mov cx,wordlen
   mov si,cnt  
   mov di,si 
   mov ax,cnt
   mov cl,10
   div cl
   mov cx,num
   sub cx,ax 
   mov dx,cx;???????
   cmp flag,0
   jz exitdel  
   dela:
   mov ax,cx
   add di,wordlen 
   push si
   push di
   mov cx,wordlen
   de:
   mov bl,byte ptr word[di]
   mov byte ptr word[si],bl
   mov bl,byte ptr synonym[di]
   mov byte ptr synonym[si],bl
   mov bl,byte ptr autonym[di]
   mov byte ptr autonym[si],bl
   inc di
   inc si
   loop de
   pop di
   pop si
   add si,wordlen
   mov cx,ax
   loop dela
   
   mov ax,cnt
   mov cl,3
   mul cl
   mov si,ax
   mov di,si
  
   mov cx,dx  
   deex:
   mov ax,cx
   add di,explainlen
   push si
   push di
   mov cx,explainlen
   dxeex:
   mov bl,byte ptr explain[di]
   mov byte ptr explain[si],bl
   inc di
   inc si
   loop dxeex
   pop di
   pop si
   add si,explainlen
   mov cx,ax
   loop deex 
   
   dec num
   exitdel:    
   pop di
   pop5  
    ret 
deletew   endp 

  
new_word  proc near   
    push5  
    push di
    curse 19,6
    mov di,-1
    inputw:                            
    inc di
    mov ah,01
    int 21h
    mov byte ptr wordh[di],al
    cmp al,'$'
    jnz inputw 
    
    Scroll 2,5,6,19,73,2fh
    curse 19,6 
    mov di,-1
    inpute:
    inc di
    mov ah,01
    int 21h
    mov explainh[di],al
    cmp al,'$'
    jnz inpute 
    
    Scroll 2,5,6,19,73,2fh
    curse 19,6
    mov di,-1
    inputs:
    inc di
    mov ah,01   
    int 21h
    mov synonymh[di],al
    cmp al,'$'
    jnz inputs
    
    Scroll 2,5,6,19,73,2fh
    curse 19,6
    mov di,-1
    inputa:
    inc di
    mov ah,01
    int 21h
    mov autonymh[di],al
    cmp al,'$'
    jnz inputa    

    mov ax,num
    dec ax
    mov si,0
    mov cx,wordlen
    mul cx 
    mov si,ax
    mov di,0 
    lp:
    mov bl,byte ptr word[si]
    cmp bl,wordh[di]
    ja loop1 
    jz loop2
    add si,cx
    call insert
    jmp exit_n
    
    loop1:
    call pushnext
    sub si,wordlen
    cmp si,0
    jb exitin
    jmp lp 
    
    loop2:
    call check
    cmp flag,0
    sub si,wordlen
    jmp lp
    
    exitin:call insert
    exit_n:           
    Scroll 0,5,6,19,73,02h   
    Scroll 15,5,6,19,73,2fh 
    curse 0,0
     
   
;**************************************    
    inc num;????1 
    pop di 
    pop5  
    ret
new_word  endp 
;*****************************************
;??????????????
check proc near
    push5 
    push di
    mov cx,si
    check0:
    inc si
    inc di
    cmp byte ptr word[si],'$'
    jz  check1 ;??????
    cmp byte ptr wordh[di],'$'
    jz check2  ;???????
    mov al,byte ptr word[si]
    cmp al,byte ptr wordh[di]
    jz check0
    jb check1
    check2:
    mov si,cx 
    mov flag,0
    call pushnext
    mov si,cx
    jmp check3
       
    check1:
    mov si,cx
    mov flag,1
    call insert
    check3:
    pop di
    pop5 
    ret
check endp 

pushnext proc near
    push di
    push ax
    push si
    push cx
    mov cx,wordlen
    mov di,si
    add di,wordlen
    push si
    LNEXT:
    mov al,byte ptr word[si]
    mov byte ptr word[di],al
    mov al,byte ptr synonym[si]
    mov byte ptr synonym[di],al
    mov al,byte ptr autonym[si]
    mov byte ptr autonym[di],al
    inc si
    inc di
    loop lnext
     
    pop si
    mov ax,si
    mov cx,3
    mul cx
    mov si,ax
    mov di,si
    add di,explainlen
    mov cx,explainlen
    lenext:
    mov al,byte ptr explain[si]
    mov byte ptr explain[di],al
    inc si
    inc di
    loop lenext 
    
    
    pop cx
    pop si
    pop ax
    pop di
    ret
pushnext endp

insert proc near
    mov di,0
    push cx 
    push si
    mov cx,10
    L:  
    mov bl,byte ptr wordh[di]
    mov byte ptr word[si],bl
    mov bl,byte ptr synonymh[di]
    mov byte ptr synonym[si],bl
    mov bl,byte ptr autonymh[di]
    mov byte ptr autonym[si],bl
    inc si
    inc di
    loop L
     
    pop si
    mov ax,si
    mov cx,3
    mul cx
    mov si,ax
    mov di,0
    mov cx,30
    lin:
    mov bl,byte ptr explainh[di]
    mov byte ptr explain[si],bl
    inc si
    inc di
    loop lin
    
   
    pop cx 
    
    ret
insert endp  

    
search_ex  proc near  
    push5    
    mov di,-1
    mark1:
    inc di
    mov ah,1
    int 21h  
    push5
    Scroll 0,5,6,19,73,02h ;??  
    Scroll 15,5,6,19,73,2fh ;?????????
    pop5
    mov wordh[di],al
    cmp al,'$'
    jz exits
    call compare
    push5      
    Scroll 1,5,6,19,73,2fh            
    inc n
    curse 0,n
    pop5   
    jmp mark1 
    
    exits:
    call found  
    cmp flag,0
    jz last0
    Scroll 1,5,6,19,73,2fh    
    curse 19,6
    mov dx,cnt
    mov ah,09h
    int 21h
    Scroll 2,5,6,19,73,2fh
    curse 19,6 
    lea dx,explainstr
    mov ah,09
    int 21h
    Scroll 1,5,6,19,73,2fh
    curse 19,6 
    mov ax,cnt
    lea dx,word
    sub ax,dx 
    mov cnt,ax
    mov cx,wordlen
    div cl
    mov cx,explainlen
    mul cx
    lea dx,explain
    add dx,ax
    mov ah,09h
    int 21h  
    Scroll 2,5,6,19,73,2fh
    curse 19,6
    lea dx,synonymstr
    mov ah,09h
    int 21h  
    Scroll 1,5,6,19,73,2fh
    curse 19,6
    lea dx,synonym
    add dx,cnt
    mov ah,09
    int 21h 
    Scroll 2,5,6,19,73,2fh
    curse 19,6 
    lea dx,autonymstr
    mov ah,09h
    int 21h
    Scroll 1,5,6,19,73,2fh
    curse 19,6 
    lea dx,autonym
    add dx,cnt
    mov ah,09
    int 21h 
    call found
    jmp last
    last0:
    Scroll 7,5,6,19,73,2fh
    curse 19,6
    lea dx,nowordstr
    mov ah,09
    int 21h
    last:
    mov n,0      
    pop5 
    ret               
search_ex endp

compare proc near 
    push si
    push bx
    push di
    mov ah,0 
    mov cx,di
    inc cx
    mov bx, cx
    mov di,-1
    mov si,-10 
    mov bp,si 
    again:  
    mov si,bp
    add si,wordlen 
    mov bp,si   
    mov di,-1 
    mov cx,bx
    mov ah,byte ptr word[si] 
    cmp ah,'$'
    jz exit_c
   again1:      
    inc di 
    mov al,byte ptr word[si] 
    cmp al,wordh[di]
    jnz again 
    inc si
    loop again1 
    push5
    curse 19,6
    pop5 
    lea dx,word
    add dx,bp  
    mov cnt,dx
    mov ah,09
    int 21h   
    push5
    Scroll 1,5,6,19,73,2fh 
    pop5
    mov si,bp 
    mov cx,bx
    jmp again
    
    exit_c: 
    pop di
    pop bx
    pop si 
    ret
compare endp
    

 found proc near
    push5
    mov si,-10
    mov cx,si
    fagainb:
    mov si,cx
    mov di,-1
    fagain:
    inc di
    add si,wordlen 
    mov cx,si
    mov al,byte ptr word[si] 
    cmp al,'$'
    jz exit_nf
    cmp al,wordh[di]
    jz next
    jmp fagainb
    
    next:
    inc di
    inc si
    mov al,byte ptr word[si]
    cmp al,wordh[di]
    jnz fagainb
    cmp di,9
    jz exit_f
    jmp next
    
    exit_f:
    mov flag,1
    jmp exitf
    exit_nf:
    mov flag,0
    exitf:
    pop5   
    ret    
 found endp
 
enter proc near   
      push dx
      push ax
      MOV DL, 10
      MOV AH, 2
      INT 21H
      MOV DL, 13
      MOV AH, 2
      INT 21H 
      pop ax
      pop dx
      ret
enter endp

CRLF proc
      MOV DL, 10		;carriage return 
      MOV AH, 2
      INT 21H
      MOV DL, 13	 ;line feed
      MOV AH, 2
INT 21H 
    ret
CRLF endp

CODESG ENDS

END MAIN

