.ORIG x3000                                                                                  

;-------------------------------------------------------------------------
;	Output prompt to console 
	
	LEA R0, PROMPT1
	PUTS
	
;-------------------------------------------------------------------------
; Collect user input

	LD	R4, INPUT_LC		; load Input Loop Counter into R6

GET_INPUT
	GETC
	OUT
	JSR PUSH
	ADD 	R4, R4, #-1		; Decrement Loop Counter
	BRp 	GET_INPUT		; loop until R6 is zero or negative



PROMPT1 .STRINGZ "Enter a test score in the format XXX (ex. 100, 098, 015) \n"
INPUT_LC	.FILL x3		; initializing get_input loop counter at x3

HALT

;-------------------------------------------------------------------------
;Subroutine POP: Pop item from stack
;-------------------------------------------------------------------------
POP    	LD R1, EMPTY            ; EMPTY = -x4000
	ADD R2, R6, R1            ; COMPARE STACK POINTER with x3FFF
  	BRz FAIL            ;
    	LDR R0, R6, #0
   	ADD R6, R6, #1
   	AND R5, R5, #0            ; SUCCESS: R5 = 0
   	RET
FAIL    AND R5, R5, #0            ;UNDERFLOW DETECTED, FAIL: R5 = 1
   	ADD R5, R5, #1
   	RET

EMPTY	.FILL xC000

;-------------------------------------------------------------------------
;Subroutine PUSH:Push item into stack
;-------------------------------------------------------------------------
PUSH    LD R1, MAX            ; MAX = 
        ADD R2, R6, R2            ; compare stack pointer with MAX 
        BRz PUSH_FAIL            ; 
        ADD R6, R6, #-1
        STR R0, R6, #0
        AND R5, R5, #0            ; SUCCESS: R5 = 0
        RET
PUSH_FAIL    AND R5, R5, #0            ; OVERFLOW DETECTED, FAIL: R5 = 1
        ADD R5, R5, #1
        RET
MAX    .FILL xC002

.END
