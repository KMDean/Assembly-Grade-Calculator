; Pass_Fail_Calc.asm

#include c:\68hcs12\registers.inc

; Author: Kaitlyn Dean
; Purpose:      Calculate if a student has passed both the Theory and Practical
;               portions of the course. Display a 'P' if both portions passed;
;               otherwise, display an 'F'. Display the values for 1 second each
;               (e.g. 4 delay cycles of 250 ms each) Then, blank the display for
;               the same amount of time and then continue on with the values.
;                Once all of the result are displayed, blank the display
;
;               Note that there is only ONE 'P' or 'F' displayed per student

; Program Constants
DELAY_VALUE     equ     #250     ;set delay value
THEORY_MARKS    equ     #5       ;set the amount of theory marks
PRACT_MARKS     equ     #3       ;set the amount of pratical marks
NUM_STUDENTS    equ     #10      ;set the number of students

; data section
                org     $1000         ;set start point to memory location 1000
START           equ     $1000         ;set start variable to memory location 1000
; Read in Data File
Start_Course_Data
; place a comment symbol (;) in front of "#include Demo.txt" and then
; remove the comment symbol (;) to unmask your lab section's include statement
Students                          ;start of array
#include "Demo.txt"               ;Result = P F P P F P -> same data as in Video
EndStudents                       ;end of array

Length                equ     EndStudents-Students       ; find the amount of marks
TOTAL_STUDENTS        equ     $1000+#Length              ;set end point of marks                                        
; where P = Pass, F = Fail

End_Course_Data
STACK   equ     $2000                          ;set stack to memory location 2000
Results equ     #STACK-#NUM_STUDENTS           ;set start pointer of pass fail results
; code section
        org     $2000                     ; RAM address for Code
        jsr     Config_Hex_Displays       ;set up display
        lds     #STACK                    ; Stack
        ldy     #START                    ;load y to the start of the program

        ldaa    #0                        ;clear accumulator a
LoopStud                                  ;start of loop through students
        
        ldx     #0                        ;clear x register

LoopP   addb    1,y+                      ;add B because it makes up  00XX of D
        inx                               ;increment x because it loops through the grades
        cpx     #PRACT_MARKS              ;check is x has gone through all of the practical grades
        blo     LoopP                     ;if it hasnt, go back to the top of the practical loop

        jsr     Calculate_Average         ;calculate the average of the practical grades
        tfr     x,b                       ;move the answer to b
        jsr     Pass_Fail                 ;test if they passed or failed
        pshb                              ;push p/f to stack
        ldx     $0                        ;clear x
        ldab    $0                        ;clear b

LoopT   addb    1,y+                      ;add B because it makes up  00XX of D
        inx                               ;increment x because it loops through the grades
        cpx     #THEORY_MARKS             ;check is x has gone through all of the theory grades
        blo     LoopT                     ;if it hasnt, go back to the top of the theory loop
        
        jsr     Calculate_Average         ;calculate the average of the theory grades
        tfr     x,b                       ;move the answer to b
        jsr     Pass_Fail                 ;test if they passed or failed
        pshb                              ;push p/f to stack
        
        ; check both answers to decide if pass fail
        pula                              ;load theory p/f to a
        pulb                              ;load practical p/f to b
        ;if a and b are pass, store pass
        cmpa    #1                        ;checks if student passed theory marks
        blo     Else                      ;if they didnt, go to Else
        
        
        cmpb    #1                        ;checks if student passed practical marks
        blo     Else2                     ;if they didnt, go to Else2
        ldab    #1                        ;they passed both, load b with pass
        pshb                              ;push pass to stack
        bra     EndIf2                    ;end the if statement
Else2
        ldab    #0                        ;they didnt pass practical so load b with fail
        pshb                              ;push fail onto stack
EndIf2                                    ;end of if statement

        
        bra     EndIf
Else
        ldab    #0                       ;they didnt pass theory, load b with fail
        pshb                             ;push fail onto stack
EndIf                                    ;end of if
        ldab    #2                       ;load a break to b
        pshb                             ;push the break onto the stack
        ; loop for each student
        cpy    #TOTAL_STUDENTS           ;did it calculate for all of the students?
        bne    LoopStud                  ;if not, loop back to the top of the students loop


        ; get grades from stack

        ldab    #0       ;clear b
        
LoopR
        ldy     #Results-1              ;load y with the start of the results
        aby                             ;add b incrementer to y
        pshb                            ;store increment on the stack
        ldaa    0,y                     ;load a with the results using y pointer
        ldab    #%1110                  ;select the first port
        jsr     PF_HEX_Display          ;display the result
        jsr     Delay_ms                ;delay the results display
        pulb                            ;pull the incrementer from the stack
        ldy     #Results-1              ;load y with the start if the results again
        aby                             ;add b incrementer to y
        incb                            ;increment the incrementer
        cpy     #STACK-1                ;gone through all results?
        bne     LoopR                   ;if not, go back to top of results loop
        


        swi

#include Calculate_Average.asm
#include Pass_Fail.asm
#include PF_HEX_Display.asm
#include C:\68HCS12\Lib\Config_Hex_Displays.asm
#include C:\68HCS12\Lib\Delay_ms.asm
        end
