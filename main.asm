.ORIG x3000                                                                                  

;------------------------------MAIN PROGRAM-------------------------------

	JSR SCORE_LOOP
	HALT

;------------------------------END OF MAIN--------------------------------



;--------------------------GLOBAL VARIABLES-------------------------------
SAVE_REG1	.FILL x0
SAVE_REG2	.FILL x0
SAVE_REG3	.FILL x0
SAVE_REG4	.FILL x0
SAVE_REG5	.FILL x0
SAVE_REG6	.FILL x0
SAVE_LOC1	.FILL x0
SAVE_LOC2	.FILL x0
SCORE	.BLKW #40		; Array containing scores
;-------------------------------------------------------------------------





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




;------------------------------GET USER INPUT-----------------------------



SCORE_LOOP
		ST	R7, SAVE_LOC1			; store R7 in SAVE_LOC1 so we can use RET to return to calling program (aka main program)
		JSR	CLEAR_REGISTER			; Clear Registers 0-5
		LEA	R0, PROMPT1
		PUTS					; Output PROMPT1: "Enter a test score in the format XYZ (ex. 100, 098, 015) \n"
		LD	R4, INPUT_LC			; load Input Loop Counter into R4

;--------------------------------------;	
;Subroutine GET_INPUT
;--------------------------------------;
; R4 : INPUT_LC, contains the value of character input loop counter
;--------------------------------------;
GET_INPUT
		GETC					; Get character
		OUT					; Echo character to console
		JSR 	PUSH_CHAR			; Push character into stack
		ADD 	R4, R4, #-1			; Decrement Loop Counter
		BRp 	GET_INPUT			; loop until R4 is zero or negative

;--------------------------------------;	
;Subroutine GET_SCORE
;--------------------------------------;
; R0 : Register that contains popped values from stack
; R3 : Register to temporarily store hexidecimal test score before storing in array
; R4 : Register to temporarily store values that will later be added to R3
; SAVE_REG1: contains ten's place digit	
;--------------------------------------;
GET_SCORE

;-------------------;	
;adding one's place 
; value to score
;-------------------;	
		AND 	R0, R0, #0			; Clear R0
		AND 	R4, R4, #0			; Clear R4
		JSR 	POP_CHAR			; POP character (one's place digit) from stack
		JSR 	ENCODE				; Convert ASCII character to hexidecimal
		ADD	R3, R0, #0			; STORE popped (one's place) value from R0 to R3
		

;-------------------;		
;adding ten's place
; value to score
;-------------------;	
		AND 	R0, R0, #0			; Clear R0
		JSR 	POP_CHAR			; POP character (ten's digit) from stack
		JSR 	ENCODE				; Convert ASCII character to hexidecimal
		ST 	R0, SAVE_REG1			; save R0 value in SAVE_REG1	
		JSR 	MULT_BY_10			; Multiply popped value by 10
		ADD	R3, R3, R0			; Add tens's place value from R0 to R3

;-------------------;		
;adding hundred's place
; value to score
;-------------------;	
		;AND 	R0, R0, #0			; Clear R0
		;JSR 	POP_CHAR			; POP character (hundred's digit) from stack
		;JSR 	ENCODE				; Convert ASCII character to hexidecimal
		


		;ADD	R3, R3, R0			; Add hundreds's place value from R0 to R3
		
		LD 	R7, SAVE_LOC1			; Load SAVE_LOC to R7
		RET					; Return back to calling program

PROMPT1 .STRINGZ "Enter a test score in the format XYZ (ex. 100, 098, 015) \n"
PROMPT2 .STRINGZ "\nScore you entered is: \n"
PROMPT3 .STRINGZ "\nScore successfully converted!"
INPUT_LC	.FILL x3			; initializing GET_INPUT loop counter at x3
CHAR 	.BLKW x3
;-------------------------------------------------------------------------




;------------------------------STACK MANAGEMENT---------------------------
;[INSERT COMMENTS HERE]
;
;
;--------------------------------------;
;Subroutine PUSH_CHAR : Push character into stack
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
POP_CHAR    	LD R1, EMPTY			; EMPTY = -x4000
		ADD R2, R6, R1			; COMPARE STACK POINTER with x3FFF
  		BRz FAIL			; Branch if stack is empty
    		LDR R0, R6, #0			; Load popped value into R0
   		ADD R6, R6, #7			; Adjust stack pointer 
   		AND R5, R5, #0           	; SUCCESS: R5 = 0
   		RET

EMPTY	.FILL xC000

;--------------------------------------;
;Subroutine FAIL
;--------------------------------------;
FAIL    AND R5, R5, #0			;OVERFLOW/UNDERFLOW DETECTED, FAIL: R5 = 1
   	ADD R5, R5, #1			;
   	RET


;-------------------------------------------------------------------------





;--------------------------CONVERT INPUT TO VALUE-------------------------


;--------------------------------------;
;Subroutine ENCODE: (ASCII to Hexadecimal conversion)
;--------------------------------------;
; R1: Contains ASCII digit to value digit offset (
; R0: Contains ASCII value to be converted into hexadecimal value
;--------------------------------------;
ENCODE
	AND R1, R1, #0			; Clear R1
	ADD R1, R1, #15			; Subtracting #48 (ASCII offset) 
	ADD R1, R1, #15
	ADD R1, R1, #15
	ADD R1, R1, #3
	NOT R1, R1
	ADD R1, R1, #1
	ADD R0, R0, R1
	RET

;--------------------------------------;
;Subroutine DECODE: (ASCII to Hexadecimal conversion)
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
	AND 	R0, R0, #0		; Clear R0
	AND 	R4, R4, #0		; Clear R4
	LD 	R4, SAVE_REG1		; Load ten's place value to R4
	LD 	R2, TEN			;load loop counter to R2
MULT_LOOP
	ADD 	R0, R0, R4
	ADD 	R2, R2, #-1		; decrement loop counter
	BRp 	MULT_LOOP
	ST 	R0, SAVE_REG2
	RET

TEN	.FILL xA
;-------------------------------------------------------------------------




;----------------------------CALCULATE MIN & MAX--------------------------
;[INSERT CODE]
;-------------------------------------------------------------------------



;-----------------------------CALCULATE AVG-------------------------------
;[INSERT CODE]
;-------------------------------------------------------------------------



;-------------------------ASSIGN LETTER TO SCORE--------------------------
;[INSERT CODE]
;-------------------------------------------------------------------------

.END
