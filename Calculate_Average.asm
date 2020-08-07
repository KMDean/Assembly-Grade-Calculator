; Calculate_Average.asm
;
; Author: Kaitlyn Dean
; Purpose:      The purpose of the Calculate_Average_Subroutine is to
;               calculate the average of ANY number of values by dividing
;               the sum of the values by 5 and returning an integer value
;               between 0 and 10

; Precondition:
;
;
; Postcondition:

DIVISOR equ     $05

Calculate_Average

        ldx     #DIVISOR
        idiv
        rts
