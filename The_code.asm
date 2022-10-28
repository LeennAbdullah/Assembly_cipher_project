; Welcome to the shift cipher program   
data segment
    ; add your data here!  
    Enter   db 0AH,0DH,"$"
    welcome db "Welcome to the shifting program $" 
    choice  db "if you want to encrypt, type E or type D for decryption $"  
    Error_M db  "That is an illegal character. Please try again :) " 
    wrong   db   0AH,0DH,"Wrong choice please try again $"
    key     db 0ah,0dh,"Enter the shifting key (a single digit from 1 to 9) :  $"
    text    db "Enter the message of no more than 20 char when done, press <Enter>: $"
    cipher  db "The ciphertext: $"
    plain   db "The plaintext: $"  
    res     db  20        ;MAX NUMBER OF CHARACTERS ALLOWED (20).
            db  ?         ;NUMBER OF CHARACTERS ENTERED BY USER.
            db  20 dup(0) ;CHARACTERS ENTERED BY USER.
                    
ends

stack segment
    dw   128  dup(0)
ends

code segment 
globalization:
                mov ax, data
                mov ds, ax
                mov es, ax 
                ret                 
program_info:                                    
                ;only for displaying the output, input and string so that the user can understand 
                call NewL     
                mov ah, 9 
                mov dx, offset welcome
                int 21h 
                call NewL
                ret  
choicee:
                mov ah, 9 
                mov dx, offset choice
                int 21h 
                mov AH,1
                int 21h  
                cmp al,'E'
                JE Read ; if staetment 
                cmp al,'D'
                JE Read ; if else 
                call NewL  
                mov ah, 9
                mov dx, offset Error_M 
                int 21h 
                call NewL    
                mov ah, 9
                mov dx, offset Wrong 
                int 21h 
                JMP choicee;to enter a valid choice which is the else staetment 
                ret
       







                       
Read:           
                     
                mov [3100h],al ; save the choice as the question wants
                mov ah, 9 
                mov dx, offset key
                int 21h 
                mov ah,1 
                int 21h 
                sub al,30h  
                mov [3101h],al
                cmp [3100h], 'D'
                JE Decode   
                call NewL
                mov ah,9 
                mov dx, offset text
                int 21h 
                mov ah, 0Ah ;SERVICE TO CAPTURE STRING FROM KEYBOARD.
                mov dx, offset res
                mov [3102h],dx
                int 21h
                call NewL
                call encrypt  
                ret    
                 
Encrypt:
                mov si, offset res
                add si, 1
                mov ch, 0 
                mov cl,[si] 
                ;push cx 
   
                call Repeat
                ret      ; we will use it in the decryption 












Repeat:
                inc si
                mov al,[si]         ;GET THE CHAR FROM BUFFER
                add al,[3101H]      ;ADD KEY  
                mov [si-2],al       ;STORE IT TO THE BEGINING OF THE BUFFER
                loop Repeat          ;REPEAT         
                mov [si],'$'        ;ADD END OF STRING TO THE LAST 2 LOCATIONS
                mov [si-1],'$'
                mov ah, 09h
                mov ah,9
                mov ah,09h
            	mov bl,9
            	mov cx, 14  ; mov to cx number of char 
            	int 10h
                mov dx,offset cipher
                int 21h  
                mov ah,9 
                mov dx, offset res   ;DISPLAY THE STRING AFTER ENCRYPTION
                int 21h 
                ret
  
Decode:         
                call NewL
                mov ah,9 
                mov dx, offset text
                int 21h 
                mov ah, 0Ah ;SERVICE TO CAPTURE STRING FROM KEYBOARD.
                mov dx, offset res
                mov [3102h],dx
                int 21h
                call NewL
                mov si, offset res
                add si, 1
                mov ch, 0 
                mov cl,[si]   
                call looping 
                ret ;LOAD CHAR COUNT INTO CX





  
Looping:
                inc si
                mov al,[si]         ;GET THE CHAR FROM BUFFER
                sub al,[3101H]      ;ADD KEY  
                mov [si-2],al       ;STORE IT TO THE BEGINING OF THE BUFFER
                loop Looping          ;REPEAT         
                mov [si],'$'        ;ADD END OF STRING TO THE LAST 2 LOCATIONS
                mov [si-1],'$'
                mov ah, 09h
                mov ah,9
                mov ah,09h
            	mov bl,9
            	mov cx, 14  ; mov to cx number of char 
            	int 10h
                mov dx,offset plain
                int 21h  
                mov ah,9 
                mov dx, offset res   ;DISPLAY THE STRING AFTER ENCRYPTION
                int 21h 
                ret
                                  
                   
NewL:           mov ah,9
                mov dx,offset Enter
                int 21h
                ret         
         
            
ENDD:
                mov AH,4ch
                int 21h   
start: 
       call globalization ;to make code segment local
       call program_info  ;welcoming message for the code    
       call choicee
       call ENDD                                   
ends
end start
