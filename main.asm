.ORIG x3000                                                                                  

;-------------------------------------------------------------------------
;	Output prompt to console 
	
	LEA R0, PROMPT1
	PUTS
	
;-------------------------------------------------------------------------
; Collect user input

	LD	R4, INPUT_LC		; load Input Loop Counter into R4

GET_INPUT
	GETC
	JSR PUSH
	ADD 	R4, R4, #-1		; Decrement Loop Counter
	BRp 	GET_INPUT		; loop until R4 is zero or negative

	LEA R0, PROMPT2
	PUTS

DISPLAY_INPUT
	JSR POP
	ST R0, CHAR
	OUT
	ADD 	R4, R4, #-1		; Decrement Loop Counter
	BRp 	GET_INPUT		; loop until R4 is zero or negative


PROMPT1 .STRINGZ "Enter a test score in the format XXX (ex. 100, 098, 015) \n"
PROMPT2 .STRINGZ "\nScore you entered is: \n"
INPUT_LC	.FILL x3		; initializing get_input loop counter at x3
CHAR 	.BLKW x1


HALT

;-------------------------------------------------------------------------
;Subroutine CLEAR_REGISTER

CLEAR_REGISTER	AND R0, R0, #0
		AND R1, R1, #0
		AND R2, R2, #0
		AND R3, R3, #0
		AND R4, R4, #0
		AND R5, R5, #0
		AND R6, R6, #0
		RET
;-------------------------------------------------------------------------




;-------------------------------------------------------------------------
;Subroutine POP: Pop item from stack

POP    	LD R1, EMPTY			; EMPTY = -x4000
	ADD R2, R6, R1			; COMPARE STACK POINTER with x3FFF
  	BRz FAIL			; Branch if stack is empty
    	LDR R0, R6, #0			; Load popped value into R0
   	ADD R6, R6, #1			; Adjust stack pointer 
   	AND R5, R5, #0           	; SUCCESS: R5 = 0
   	RET

EMPTY	.FILL xC000
;-------------------------------------------------------------------------



;-------------------------------------------------------------------------
;Subroutine PUSH:Push item into stack

PUSH  
	LD R1, MAX			; MAX = -x3FFB
        ADD R2, R6, R1			; compare stack pointer with x3FFF
        BRz FAIL            		; Branch if stack is full
        ADD R6, R6, #-1			; Adjust stack pointer	
        STR R0, R6, #0			; Store value in R0 to stack
        AND R5, R5, #0           	; SUCCESS: R5 = 0
        RET

MAX	.FILL xC005
;-------------------------------------------------------------------------



;-------------------------------------------------------------------------
;Subroutine FAIL; 

FAIL    AND R5, R5, #0			;OVERFLOW/UNDERFLOW DETECTED, FAIL: R5 = 1
   	ADD R5, R5, #1			;
   	RET
;-------------------------------------------------------------------------





.END
