PUSH4 MACRO
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
ENDM
POP4 MACRO
    POP DX
    POP CX
    POP BX
    POP AX
ENDM
; multi-segment executable file template.
data segment
; add your data here!
pkey db "press any key...$"
STU0 DB "00",95,0,100,0,81,0,4 DUP(0)    ;number,chinese score,ranking,maths score,ranking,english score,ranking
;total score,ranking,average score
STU1 DB "01",55,0,94,0,45,0,4 DUP(0)
STU2 DB "02",68,0,83,0,90,0,4 DUP(0)
STU3 DB "03",85,0,76,0,55,0,4 DUP(0)
STU4 DB "04",100,0,30,0,90,0,4 DUP(0)
STU5 DB "05",100,0,100,0,100,0,4 DUP(0)
STU6 DB "06",40,0,70,0,80,0,4 DUP(0)
STU7 DB "07",50,0,40,0,20,0,4 DUP(0)
STU8 DB "08",90,0,95,0,80,0,4 DUP(0)
STU9 DB "09",40,0,70,0,70,0,4 DUP(0)

SORTZONE DB  10 DUP(0)
TOTAL EQU $-SORTZONE
SORTZONE_DW DW 10 DUP(0)

AVER_SCORE DB 3 DUP(0); average score for chinese,maths,english
AVER_TOTAL_SCORE DB 2 DUP(0) ; average score for total score

NUM_CH DB 5 DUP(0)   ; <60,60~70,70~80,80~90,90~100  the amount of students in different ranges
NUM_MA DB 5 DUP(0)
NUM_EN DB 5 DUP(0)

FAILED_CH 20 DUP('F'); collect the student failed the subject
FAILED_MA 20 DUP('F')
FAILED_EN 20 DUP('F')

caption db 10,13,"do not have the numerical instruction, please try it again.",10,13,"$"
caption_wel db 10,13,"input the numerical instruction:",10,13,"$"
caption1 db "1. get the information of a student",10,13,"$"
caption1next db 10,13,"please input the id of this student:",10,13,"$"
caption1items db 10,13,"1. chinese",10,13,"2. maths",10,13,"3. english",10,13,"4. total score",10,13,"5. back to the previous level",10,13,"$"
captionscore db 10,13,"score: $"
captionranking db "ranking: ","$"
student_num db 5,0,5 dup('$')
caption2 db "2. check the student who are failed",10,13,"$"
caption2ch db 10,13,"chinese:",10,13,"$"
caption2ma db 10,13,"maths:",10,13,"$"
caption2en db 10,13,"english:",10,13,"$"
caption2to db 10,13,"total:",10,13,"$"
caption2no db "none.$"
caption3 db "3. show the amount of students in different ranges.",10,13,"$"
caption3_state db 10,13,"<60,60~70,70~80,80~90,90~100.",10,13,"$"
caption4 db "4. show the average score.",10,13,"$"
caption4next db "average score:$"
caption5 db "5. record the students' data.",10,13,"$"
record_state1 db "please input 10 students' score of 3 subjects.",10,13,"$"
caption6 db "6. modify the students' data.",10,13,"$"
caption6items db 10,13,"1. chinese",10,13,"2. maths",10,13,"3. english",10,13,"$"
caption6input db 10,13,"please input the score.",10,13,"$"
tbuff db 5 dup(0)

ends


stack segment
dw   128  dup(0)
ends

code segment
start:
; set segment registers:
mov ax, data
mov ds, ax
mov es, ax

begin:

MOV BX,02H
CALL SORTSUBJECT
CALL RANK
MOV BX,04H
CALL SORTSUBJECT
CALL RANK
MOV BX,06H
CALL SORTSUBJECT
CALL RANK
CALL STATISTIC
CALL SORTSUBJECT_DW
CALL RANK_DW
CALL AVER          ; average score for everyone
CALL AVER_SUBJECT  ; average score for every subject and total score
CALL RANGE  ;


operate:
lea dx,caption_wel
mov ah,09h
int 21h
lea dx,caption1
mov ah,09h
int 21h
lea dx,caption2
mov ah,09h
int 21h
lea dx,caption3
mov ah,09h
int 21h
lea dx,caption4
mov ah,09h
int 21h
lea dx,caption5
mov ah,09h
int 21h
lea dx,caption6
mov ah,09h
int 21h

mov ah,01h
int 21h

cmp al,31h
jz check
cmp al,32h
jz  check_who_are_failed
cmp al,33h
jz check_range
cmp al,34h
jz check_average
cmp al,35h
jz record_data
cmp al,36h
jz check_modify
jmp operate
check:

call get_id

lea dx,caption1items
mov ah,9
int 21h
call stdin
push ax
cmp al,31h
jz check_chinese
jmp check_maths
check_chinese:
lea dx,captionscore
mov ah,9
int 21h
mov dh,0
mov dl,[di]
call dec16out
lea dx,captionranking
mov ah,9
int 21h
inc di
mov dh,0
mov dl,[di]
dec di
call dec16out
call CRLF
jmp check_stuend

check_maths:
pop ax
push ax
cmp al,32h
jz check_maths1
jmp check_english
check_maths1:
lea dx,captionscore
mov ah,9
int 21h
add di,2
mov dh,0
mov dl,[di]
call dec16out
lea dx,captionranking
mov ah,9
int 21h
inc di
mov dh,0
mov dl,[di]
sub di,3
call dec16out
call CRLF
jmp check_stuend

check_english:
pop ax
push ax
cmp al,33h
jz check_english1
jmp check_sum
check_english1:
lea dx,captionscore
mov ah,9
int 21h
mov dh,0
add di,4
mov dl,[di]
call dec16out
lea dx,captionranking
mov ah,9
int 21h
inc di
mov dh,0
mov dl,[di]
sub di,5
call dec16out
call CRLF

check_sum:
pop ax
push ax
cmp al,34h
jz check_sum1
jmp check_subback
check_sum1:
lea dx,captionscore
mov ah,9
int 21h
mov dh,0
add di,6
mov dh,[di]
inc di
mov dl,[di]
call dec16out
lea dx,captionranking
mov ah,9
int 21h
inc di
mov dh,0
mov dl,[di]
sub di,8
call dec16out
call CRLF

check_subback:
pop ax
push ax
cmp al,35h
jz check_subback1
jmp check_stuend
check_subback1:
pop ax
jmp operate

check_stuend:
pop ax
jmp operate
check_who_are_failed:
call show_who_are_failed
jmp operate

check_range:
call show_range
jmp operate

check_average:
call show_average
jmp operate

check_modify:
call modify_data

;clear what have done
lea di,NUM_CH
mov cx,15
clear_num:
mov [di],0
inc di
loop clear_num

mov cx,60
clear_failed:
mov [di],"F"
inc di
loop clear_failed

jmp begin

record_data:
lea dx,record_state1
mov ah,9
int 21h

lea di,STU0
mov cx,TOTAL
stu_10:
add di,2
call dec2hex
add di,2
call dec2hex
add di,2
call dec2hex
add di,6
loop stu_10


lea di,STU0
mov cx,TOTAL
stu_10_:
add di,2
mov dh,0
mov dl,[di]
call dec16out
add di,2
mov dh,0
mov dl,[di]
call dec16out
add di,2
mov dh,0
mov dl,[di]
call dec16out
add di,2
mov dh,[di]
inc di
mov dl,[di]
dec di
call dec16out

add di,4

loop stu_10_
lea di,STU0

jmp operate

lea dx, pkey
mov ah, 9
int 21h        ; output string at ds:dx

; wait for any key....
mov ah, 1
int 21h

mov ax, 4c00h ; exit to operating system.
int 21h
ends

stdin proc
mov ah,1
int 21h
ret
stdin endp

stdout proc
push dx
mov dl,al
mov ah,2
int 21h
pop dx
ret
stdout endp

dec2hex proc
PUSH4
mov cl,0ah
mov ch,0
mov bx,0
mov dx,0
input_dec2hex:          ;input decimal number, [di] store it
call stdin
cmp al,' '

jz input_dec2hex_1
cmp ch,0
JG record_tmp
jmp nrecord_tmp
record_tmp:
mov bx,dx
nrecord_tmp:

inc ch
sub al,30h
cbw
add dx,ax
mov bx,dx
mul cl
mov dx,ax
jmp input_dec2hex

input_dec2hex_1:
cmp ch,3
jz input_dec2hex100
jmp input_dec2hex_2
input_dec2hex100:
mov [di],100
jmp input_dec2hex_end
input_dec2hex_2:
mov [di],bl
input_dec2hex_end:
POP4

ret
dec2hex endp

dec16out proc     ;display the value of dx
PUSH4 
PUSH DI
mov cx,0
lea di,tbuff

dec1:push cx
mov ax,dx
mov dx,0
mov cx,10
div cx
xchg ax,dx
add al,30h
mov [di],al
inc di
pop cx
inc cx
cmp dx,0
jnz dec1

dec2:dec di
mov al,[di]
call stdout
loop dec2

mov dl,20h
mov ah,2
int 21h 
POP DI
POP4
ret
dec16out endp

SORTSUBJECT PROC
;sort the score
LEA DI,STU0
LEA SI,SORTZONE
MOV AH,0
MOV CX,TOTAL          ;the total amount
SORT:
ADD DI,BX      ;parameter  bx
SORT_1:
MOV AL,[DI]
MOV [SI],AL
INC SI
ADD DI,12
LOOP SORT_1

MOV CX,TOTAL
LEA DI,SORTZONE
LEA SI,SORTZONE
INC SI
DEC CX
SORT_2:
PUSH CX
SORT_3:
MOV AL,[DI]
MOV AH,[SI]
CMP AL,AH
JL SWAP
JMP NSWAP
SWAP:
MOV [DI],AH
MOV [SI],AL

NSWAP:
INC DI
INC SI
LOOP SORT_3
POP CX
LEA DI,SORTZONE
LEA SI,SORTZONE
INC SI
LOOP SORT_2               ;bubble sort  outer circulation:sort_2  inner circulation:sort_3
RET
SORTSUBJECT  ENDP

;generate ranking
RANK PROC
LEA SI,SORTZONE
PLACE1:
MOV DL,1             ;ranking counter
MOV CX,TOTAL
PLACE2:
LEA DI,STU0
ADD DI,BX             ;parameter bx
PUSH CX
MOV CX,TOTAL
PLACE3:
inc di                ;if it has been ranked?
mov al,[di]
dec di
cmp al,0
jz PLACE3_GO
jmp SETIT2
PLACE3_GO:
MOV AL,[DI]
MOV AH,[SI]
CMP AL,AH
JZ SETIT1
JMP SETIT2
SETIT1:
INC DI
MOV [DI],DL
DEC DI          ;back to previous place
INC SI          ;go to next student
INC DL          ;increase ranking
JMP SETIT3
SETIT2:
ADD DI,12
LOOP PLACE3
SETIT3:             ;go to the next round
POP CX
LOOP PLACE2
RET
RANK ENDP

STATISTIC PROC
LEA DI,STU0
ADD DI,2
MOV CX,TOTAL
S1:
MOV AX,0
ADD AL,[DI]
ADC AH,0
ADD DI,2
ADD AL,[DI]
ADC AH,0
ADD DI,2
ADD AL,[DI]
ADC AH,0
ADD DI,2
MOV [DI],AH
INC DI
MOV [DI],AL
ADD DI,5
LOOP S1
RET
ENDP

SORTSUBJECT_DW PROC
;sort the score
LEA DI,STU0
LEA SI,SORTZONE_DW
MOV CX,TOTAL          ;the total amount
SORT_DW:
ADD DI,8      ; go to the place of total score
SORT_1_DW:
MOV AH,[DI]
INC DI
MOV AL,[DI]
DEC DI
MOV [SI],AH
INC SI
MOV [SI],AL
INC SI
ADD DI,12
LOOP SORT_1_DW

MOV CX,TOTAL
LEA DI,SORTZONE_DW
LEA SI,SORTZONE_DW
ADD SI,2
DEC CX
SORT_2_DW:
PUSH CX
SORT_3_DW:
MOV AH,[DI]
INC DI
MOV AL,[DI]
DEC DI
MOV BH,[SI]
INC SI
MOV BL,[SI]
DEC SI
CMP AX,BX
JL SWAP_DW
JMP NSWAP_DW
SWAP_DW:
MOV [DI],BH
INC DI
MOV [DI],BL
DEC DI
MOV [SI],AH
INC SI
MOV [SI],AL
DEC SI

NSWAP_DW:
ADD DI,2
ADD SI,2
LOOP SORT_3_DW
POP CX
LEA DI,SORTZONE_DW
LEA SI,SORTZONE_DW
ADD SI,2
LOOP SORT_2_DW               ;bubble sort  outer circulation:sort_2  inner circulation:sort_3
RET
SORTSUBJECT_DW  ENDP

RANK_DW PROC
LEA SI,SORTZONE_DW
PLACE1_DW:
MOV DL,1             ;ranking counter
MOV CX,TOTAL
PLACE2_DW:
LEA DI,STU0
ADD DI,8             ;
PUSH CX
MOV CX,TOTAL
PLACE3_DW:
MOV AX,[DI]
MOV BX,[SI]
CMP AX,BX
JZ SETIT1_DW
JMP SETIT2_DW
SETIT1_DW:
ADD DI,2
MOV [DI],DL
SUB DI,2          ;back to previous place
ADD SI,2          ;go to next student
INC DL          ;increase ranking
JMP SETIT3_DW
SETIT2_DW:
ADD DI,12
LOOP PLACE3_DW
SETIT3_DW:             ;go to the next round
POP CX
LOOP PLACE2_DW
RET
RANK_DW ENDP

AVER PROC
LEA DI,STU0
ADD DI,8
MOV CX,TOTAL
MOV BL,3
AVER1:
MOV AH,[DI]
INC DI
MOV AL,[DI]
DIV BL
ADD DI,2
MOV [DI],AL
ADD DI,9

LOOP AVER1
RET
AVER ENDP

AVER_SUBJECT PROC
LEA SI,AVER_SCORE
MOV BL,TOTAL

LEA DI,STU0
MOV AX,0
ADD DI,2
MOV CX,TOTAL
AVER_SUBJECT_1:
ADD AL,[DI]
ADC AH,0
ADD DI,12
LOOP AVER_SUBJECT_1
DIV BL
MOV [SI],AL
INC SI

LEA DI,STU0
MOV AX,0
ADD DI,4
MOV CX,TOTAL
AVER_SUBJECT_2:
ADD AL,[DI]
ADC AH,0
ADD DI,12
LOOP AVER_SUBJECT_2
DIV BL
MOV [SI],AL
INC SI

LEA DI,STU0
MOV AX,0
ADD DI,6
MOV CX,TOTAL
AVER_SUBJECT_3:
ADD AL,[DI]
ADC AH,0
ADD DI,12
LOOP AVER_SUBJECT_3
DIV BL
MOV [SI],AL
INC SI

LEA DI,STU0
MOV AX,0
ADD DI,8
MOV CX,TOTAL
MOV BX,TOTAL
AVER_SUBJECT_TOTAL:
MOV DH,[DI]
INC DI
MOV DL,[DI]
DEC DI
ADD AX,DX
ADD DI,12
LOOP AVER_SUBJECT_TOTAL
MOV DX,0
DIV BX
MOV [SI],AH
INC SI
MOV [SI],AL
RET
AVER_SUBJECT ENDP

RANGE PROC

LEA DI,STU0
ADD DI,2
MOV CX,TOTAL

R_CH:
CMP [DI],90
JGE R1
JMP R2
R1:LEA SI,NUM_CH
ADD SI,4
ADD [SI],1
JMP R9
R2:CMP [DI],80
JGE R3
JMP R4
R3:LEA SI,NUM_CH
ADD SI,3
ADD [SI],1
JMP R9
R4:CMP [DI],70
JGE R5
JMP R6

R5:LEA SI,NUM_CH
ADD SI,2
ADD [SI],1
JMP R9
R6:CMP [DI],60
JAE R7
JMP R8

R7:LEA SI,NUM_CH
ADD SI,1
ADD [SI],1
JMP R9

R8:LEA SI,NUM_CH
ADD [SI],1

LEA SI,FAILED_CH   ; collect the student failed the subject
NEXT_FAILED_ZONE:

CMP [SI],'F'
JZ FAILED_FF
ADD SI,2
JMP NEXT_FAILED_ZONE
FAILED_FF:
SUB DI,2
MOV AL,[DI]
MOV [SI],AL
INC SI
INC DI
MOV AL,[DI]
MOV [SI],AL
ADD DI,1

R9:
ADD DI,12
LOOP R_CH


LEA DI,STU0
ADD DI,4
MOV CX,TOTAL

R_MA:
CMP [DI],90
JGE R1_MA
JMP R2_MA
R1_MA:LEA SI,NUM_MA
ADD SI,4
ADD [SI],1
JMP R9_MA
R2_MA:CMP [DI],80
JGE R3_MA
JMP R4_MA
R3_MA:LEA SI,NUM_MA
ADD SI,3
ADD [SI],1
JMP R9_MA
R4_MA:CMP [DI],70
JGE R5_MA
JMP R6_MA

R5_MA:LEA SI,NUM_MA
ADD SI,2
ADD [SI],1
JMP R9_MA
R6_MA:CMP [DI],60
JGE R7_MA
JMP R8_MA



R7_MA:LEA SI,NUM_MA
ADD SI,1
ADD [SI],1
JMP R9_MA

R8_MA:LEA SI,NUM_MA
ADD [SI],1

LEA SI,FAILED_MA   ; collect the student failed the subject
NEXT_FAILED_ZONE_MA:

CMP [SI],'F'
JZ FAILED_FF_MA
ADD SI,2
JMP NEXT_FAILED_ZONE_MA
FAILED_FF_MA:
SUB DI,4
MOV AL,[DI]
MOV [SI],AL
INC SI
INC DI
MOV AL,[DI]
MOV [SI],AL
ADD DI,3

R9_MA:
ADD DI,12
LOOP R_MA

LEA DI,STU0
ADD DI,6
MOV CX,TOTAL

R_EN:
CMP [DI],90
JGE R1_EN
JMP R2_EN
R1_EN:LEA SI,NUM_EN
ADD SI,4
ADD [SI],1
JMP R9_EN
R2_EN:CMP [DI],80
JGE R3_EN
JMP R4_EN
R3_EN:LEA SI,NUM_EN
ADD SI,3
ADD [SI],1
JMP R9_EN
R4_EN:CMP [DI],70
JGE R5_EN
JMP R6_EN

R5_EN:LEA SI,NUM_EN
ADD SI,2
ADD [SI],1
JMP R9_EN
R6_EN:CMP [DI],60
JAE R7_EN
JMP R8_EN



R7_EN:LEA SI,NUM_EN
ADD SI,1
ADD [SI],1
JMP R9_EN

R8_EN:LEA SI,NUM_EN
ADD [SI],1

LEA SI,FAILED_EN   ; collect the student failed the subject
NEXT_FAILED_ZONE_EN:

CMP [SI],'F'
JZ FAILED_FF_EN
ADD SI,2
JMP NEXT_FAILED_ZONE_EN
FAILED_FF_EN:
SUB DI,6
MOV AL,[DI]
MOV [SI],AL
INC SI
INC DI
MOV AL,[DI]
MOV [SI],AL
ADD DI,5

R9_EN:
ADD DI,12
LOOP R_EN

RET
RANGE ENDP

CRLF PROC
PUSH DX
MOV DL,0DH
MOV AH,2
INT 21H
MOV DL,0AH
MOV AH,2
INT 21H
POP DX
RET
CRLF ENDP

show_who_are_failed proc


lea di,FAILED_CH
show_who_are_failed_ch:
cmp [di],'F'
jz output_show_who_are_failed_ch1:
jmp output_show_who_are_failed_ch2_desc:

output_show_who_are_failed_ch1:
lea dx,caption2ch
mov ah,9
int 21h

lea dx,caption2no
mov ah,9
int 21h
jmp show_who_are_failed_ma:
output_show_who_are_failed_ch2_desc:
lea dx,caption2ch
mov ah,9
int 21h
output_show_who_are_failed_ch2:
mov al,[di]
call stdout
inc di
mov al,[di]
call stdout
mov al,' '
call stdout
inc di
cmp [di],'F'
jz show_who_are_failed_ma
jmp output_show_who_are_failed_ch2

show_who_are_failed_ma:
lea di,FAILED_MA
cmp [di],'F'
jz output_show_who_are_failed_ma1:
jmp output_show_who_are_failed_ma2_desc:

output_show_who_are_failed_ma1:
lea dx,caption2ma
mov ah,9
int 21h
lea dx,caption2no
mov ah,9
int 21h
jmp show_who_are_failed_en:
output_show_who_are_failed_ma2_desc:
lea dx,caption2ma
mov ah,9
int 21h
output_show_who_are_failed_ma2:
mov al,[di]
call stdout
inc di
mov al,[di]
call stdout
mov al,' '
call stdout
inc di
cmp [di],'F'
jz show_who_are_failed_en
jmp output_show_who_are_failed_ma2


show_who_are_failed_en:
lea di,FAILED_EN
cmp [di],'F'
jz output_show_who_are_failed_en1:
jmp output_show_who_are_failed_en2_desc:

output_show_who_are_failed_en1:
lea dx,caption2en
mov ah,9
int 21h
lea dx,caption2no
mov ah,9
int 21h
jmp show_who_are_failed_end:

output_show_who_are_failed_en2_desc:
lea dx,caption2en
mov ah,9
int 21h
output_show_who_are_failed_en2:
mov al,[di]
call stdout
inc di
mov al,[di]
call stdout
mov al,' '
call stdout
inc di
cmp [di],'F'
jz show_who_are_failed_end
jmp output_show_who_are_failed_en2

show_who_are_failed_end:

ret
show_who_are_failed endp


show_range proc
lea dx,caption3_state
mov ah,9
int 21h
lea dx,caption2ch
mov ah,9
int 21h
lea di,NUM_CH
mov cx,5

show_range_ch:

mov al,[di]
add al,30h
call stdout
mov al," "
call stdout
inc di
loop show_range_ch

lea dx,caption2ma
mov ah,9
int 21h

mov cx,5
show_range_ma:

mov al,[di]
add al,30h
call stdout
mov al," "
call stdout
inc di
loop show_range_ma

lea dx,caption2en
mov ah,9
int 21h
mov cx,5
show_range_en:

mov al,[di]
add al,30h
call stdout
mov al," "
call stdout
inc di
loop show_range_en

ret
show_range endp

show_average proc
lea dx,caption4next
mov ah,09h
int 21h

lea dx,caption2ch
mov ah,09h
int 21h

lea di,AVER_SCORE
mov dh,0
mov dl,[di]
call dec16out

inc di
lea dx,caption2ma
mov ah,09h
int 21h

mov dh,0
mov dl,[di]
call dec16out

inc di

lea dx,caption2en
mov ah,09h
int 21h

mov dh,0
mov dl,[di]
call dec16out
inc di
lea dx,caption2to
mov ah,09h
int 21h

mov dh,[di]
inc di
mov dl,[di]

call dec16out

ret
show_average endp

modify_data proc
PUSH4
modify1:

call get_id

mov si,di
lea dx,caption6items
mov ah,9
int 21h
call stdin
cmp al,31h
jz modify_chinese
cmp al,32h
jz modify_maths
cmp al,33h
jz modify_english
jmp modify1

modify_chinese:
lea dx,caption6input
mov ah,9
int 21h

lea di,tbuff
call dec2hex
mov al,[di]
mov [si],al
jmp modify_end

modify_maths:
lea dx,caption6input
mov ah,9
int 21h

lea di,tbuff
add si,2
call dec2hex
mov al,[di]
mov [si],al
jmp modify_end

modify_english:
lea dx,caption6input
mov ah,9
int 21h

lea di,tbuff
add si,4
call dec2hex
mov al,[di]
mov [si],al
modify_end:
POP4
ret
modify_data endp

get_id proc     ; input the id, di store the address of chinese of that student
    
    lea dx,caption1next
    mov ah,09h
    int 21h

    lea dx,student_num
    mov ah,0ah
    int 21h

    lea di,student_num+2
    mov ah,[di]
    inc di
    mov al,[di]

    get_stu:
    sub ax,3030h
    mov cx,ax
    lea di,STU0+2
    cmp cx,0
    jz reach_get_stu_not0
    reach_get_stu:
    add di,12
    loop reach_get_stu
    reach_get_stu_not0:
    call CRLF
    ret
get_id endp
end start ; set entry point and stop the assembler.
