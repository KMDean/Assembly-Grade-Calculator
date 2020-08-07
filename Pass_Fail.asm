; Pass_Fail.asm
; Pass_Fail Subroutine
; Is it a Pass or Fail ?

; Author: Kaitlyn Dean
; Purpose:      The purpose of the Pass_Fail_Subroutine is to
;               determine if the supplied integer is a Pass or a Fail, given:
;               - a Pass is >= 5
;               - a Fail is < 5
;               and return a Pass or Fail indication

; Precondition:
;
;
;
;
; Postcondition:

Pass_Fail

        ; if b >=5
        cmpb    #5
        blo     Else3
        ; pass
        ldab    #1
        bra     EndIf3
Else3
        ;fail
        ldab    #0
EndIf3

        rts
