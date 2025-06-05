.ORIG x3000                                                                                  

;-------------MAIN PROGRAM-------------;

	JSR	CLEAR_REGISTER			; Clear Registers 0-6
	LEA	R0, PROMPT1
	PUTS					; Output PROMPT1: "Enter a test score in the format XYZ (ex. 100, 098, 015) \n"

;--------------------------------------;
; Collecting user input
;--------------------------------------;
; R4 : INPUT_LC (Character input loop counter = 3)
;--------------------------------------;


		LD	R4, INPUT_LC		; load Input Loop Counter into R4

GET_INPUT
		GETC				; Get character
		OUT				; Echo character to console
		JSR 	PUSH_CHAR		; Push character into stack
		ADD 	R4, R4, #-1		; Decrement Loop Counter
		BRp 	GET_INPUT		; loop until R4 is zero or negative

;--------------------------------------;
; Getting hexadecimal value of score
;--------------------------------------;
; R0 : Register that contains popped values from stack
; R3 : Register to temporarily store hexidecimal test score before storing in array
;--------------------------------------;


GET_SCORE
		AND 	R0, R0, #0		; Clear R0
		JSR 	POP_CHAR		; POP character (one's digit) from stack
		JSR 	ENCODE			; Convert ASCII character to hexidecimal
		ADD	R3, R0, #0		; STORE popped value from R0 to R3
		
		AND 	R0, R0, #0		; Clear R0
		JSR 	POP_CHAR		; POP character (ten's digit) from stack
		JSR 	ENCODE			; Convert ASCII character to hexidecimal

		HALT



PROMPT1 .STRINGZ "Enter a test score in the format XYZ (ex. 100, 098, 015) \n"
PROMPT2 .STRINGZ "\nScore you entered is: \n"
INPUT_LC	.FILL x3			; initializing GET_INPUT loop counter at x3
CHAR 	.BLKW x3
SCORE	.BLKW #40				; 


;-------------END OF MAIN--------------;



;-------------------------------------------------------------------------
;--------------------------------------;
;Subroutine CLEAR_REGISTER
;--------------------------------------;

CLEAR_REGISTER	AND R0, R0, #0
		AND R1, R1, #0
		AND R2, R2, #0
		AND R3, R3, #0
		AND R4, R4, #0
		AND R5, R5, #0
		RET
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------




;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;-----------STACK MANAGEMENT-----------;
;
;
;
;--------------------------------------;
;Subroutine PUSH_CHAR : Push character into stack
;--------------------------------------;
; R1: MAX = 
;--------------------------------------;
PUSH_CHAR  
		LD R1, MAX			; MAX = -x3FFB
       		ADD R2, R6, R1			; compare stack pointer with x3FFF
       		BRz FAIL            		; Branch if stack is full
       		ADD R6, R6, #-7			; Adjust stack pointer (decrement by 7 because ASCII is 7 bits)
       		STR R0, R6, #0			; Store value in R0 to stack
        	AND R5, R5, #0           	; SUCCESS: R5 = 0
        	RET

MAX	.FILL xC005


;--------------------------------------;
;Subroutine POP_CHAR: Pop character from stack
;--------------------------------------;
; R1: EMPTY = 
;--------------------------------------;
POP_CHAR    	LD R1, EMPTY			; EMPTY = -x4000
		ADD R2, R6, R1			; COMPARE STACK POINTER with x3FFF
  		BRz FAIL			; Branch if stack is empty
    		LDR R0, R6, #0			; Load popped value into R0
   		ADD R6, R6, #7			; Adjust stack pointer 
   		AND R5, R5, #0           	; SUCCESS: R5 = 0
   		RET

EMPTY	.FILL xC000


;--------------------------------------;
;Subroutine FAIL; 
;--------------------------------------;
; R5: 
;--------------------------------------;

FAIL    AND R5, R5, #0			;OVERFLOW/UNDERFLOW DETECTED, FAIL: R5 = 1
   	ADD R5, R5, #1			;
   	RET
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------




;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;-SCORE: CHARACTER TO VALUE CONVERSION-;


;--------------------------------------;
;Subroutine ENCODE: (ASCII to Hexadecimal conversion)
;--------------------------------------;
; R1:
; R0:
;--------------------------------------;

ENCODE
	AND R1, R1, #0			; Clear R1
	ADD R1, R1, #15			; Subtracting 48 (ASCII offset) 
	ADD R1, R1, #15
	ADD R1, R1, #15
	ADD R1, R1, #3
	NOT R1, R1
	ADD R1, R1, #1
	ADD R0, R0, R1
	RET

;--------------------------------------;
;Subroutine DECODE: (ASCII to Hexadecimal conversion)
;--------------------------------------;
; [INSERT COMMENTS HERE]
;--------------------------------------;

DECODE

	AND R1, R1, #0			; Clear R1
	ADD R1, R1, #15			; Subtracting 48 (ASCII offset) 
	ADD R1, R1, #15
	ADD R1, R1, #15
	ADD R1, R1, #3
	ADD R0, R0, R1
	RET

;--------------------------------------;
;Subroutine MULT_BY_10: Multiply argument by 10 
;--------------------------------------;
; [INSERT COMMENTS HERE]
;--------------------------------------;

MULT_BY_10
	;[INSERT CODE HERE]
	RET
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------






;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;-----CALCULATE AVG, MIN, AND MAX------;




;-------------------------------------------------------------------------
;-------------------------------------------------------------------------





;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
;-----SCORE TO LETTER CONVERSION------;




;-------------------------------------------------------------------------
;-------------------------------------------------------------------------

.END
