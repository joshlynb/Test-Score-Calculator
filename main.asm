.ORIG x3000     

                                                                             
;--------------------------GLOBAL VARIABLES-------------------------------
SaveONES	.FILL x0		; Save one's place - temporarily saves one's place digit
SaveTENS	.FILL x0		; temporarily saves ten's place digit
SaveHUND	.FILL x0		; temporarily saves hundred's place digit

SaveScore	.FILL x0		; temporarily saves score value 
SCORES		.BLKW #5		; Array containing scores
SaveArrAdd	.FILL x0		; SaveArrAdd: Save array address - temporarily saves [SCORES address + array index]

SaveReg1	.FILL x0		
SaveReg2	.FILL x0
SaveReg3	.FILL x0

SaveLoc1	.FILL x0		; save location address 1
SaveLoc2	.FILL x0		; save location address 2
SaveLoc3	.FILL x0		; save location address 3
SaveLoc4	.FILL x0		; save location address 4

MAX_GRADE	.FILL x0		;holds maximum grade
MIN_GRADE	.FILL x0		;holds minimum grade

;-------------------------------------------------------------------------

;------------------------------MAIN PROGRAM-------------------------------
;-------------------;		
; Initialize SaveArrAdd 
;-------------------;
	JSR CLEAR_REGISTER
	LEA 	R6, SCORES			; save address of SCORES memory location to R6
	ST	R6, SaveArrAdd			; initializing SaveArrAdd with address of SCORES

;-------------------;		
; Collecting user input for a total of 5 iterations
;-------------------;
	JSR GET_INPUT
	JSR GET_SCORE
	JSR 	STORE_SCORES
	;[Insert JSR subroutine responsible for letter grade assignment]

	JSR 	GET_INPUT
	JSR 	GET_SCORE
	JSR 	STORE_SCORES
	;[Insert JSR subroutine responsible for letter grade assignment]

	JSR 	GET_INPUT
	JSR 	GET_SCORE
	JSR 	STORE_SCORES
	;[Insert JSR subroutine responsible for letter grade assignment]

	JSR 	GET_INPUT
	JSR 	GET_SCORE
	JSR 	STORE_SCORES
	;[Insert JSR subroutine responsible for letter grade assignment]

	JSR 	GET_INPUT
	JSR 	GET_SCORE
	JSR 	STORE_SCORES
	;[Insert JSR subroutine responsible for letter grade assignment]

;-------------------;		
; Reinitialize SaveArrAdd 
;-------------------;
	LEA 	R6, SCORES			; save address of SCORES memory location to R6
	ST	R6, SaveArrAdd			; initializing SaveArrAdd with address of SCORES
	;call Max function
	JSR CALCULATE_MAX
	;call Min function
	JSR CALCULATE_MIN	
	
		HALT


;------------------------------END OF MAIN--------------------------------



	
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
;--------------------------------------;	
;Subroutine GET_INPUT
;--------------------------------------;
; R4 : INPUT_LC, contains the value of character input loop counter
;--------------------------------------;
GET_INPUT
		ST	R7, SaveLoc1			; store R7 in SaveLoc1 so we can use RET to return to calling program (aka main program)
		JSR	CLEAR_REGISTER			; Clear Registers 0-5
		LEA	R0, PROMPT1
		PUTS					; Output PROMPT1: "\nEnter a test score in the format XYZ (ex. 100, 098, 015) \n"
		LD	R4, INPUT_LC			; load Input Loop Counter into R4

INPUT_LOOP
		GETC					; Get character
		OUT					; Echo character to console
		JSR 	PUSH_CHAR			; Push character into stack
		ADD 	R4, R4, #-1			; Decrement Loop Counter
		BRp 	INPUT_LOOP			; loop until R4 is zero or negative
		LD 	R7, SaveLoc1			; Load SaveLoc1 to R7
		RET					; Return back to calling program

PROMPT1 .STRINGZ "\nEnter a test score in the format XYZ (ex. 100, 098, 015) \n"
INPUT_LC	.FILL x3				; initializing GET_INPUT loop counter at x3
;-------------------------------------------------------------------------




;---------------------------------GET SCORE-------------------------------
;--------------------------------------;	
;Subroutine GET_SCORE
;--------------------------------------;
; R0 : Register that contains popped values from stack
; R3 : Register to temporarily store hexidecimal test score before storing in array
; R4 : Register to temporarily store values that will later be added to R3
; SAVE_REG1: contains ten's place digit	
;--------------------------------------;
GET_SCORE
		ST	R7, SaveLoc2			; store R7 in SaveLoc2 so we can use RET to return to calling program (aka main program)
;-------------------;	
;adding one's place 
; value to score
;-------------------;	
		AND 	R0, R0, #0			; Clear R0
		AND 	R4, R4, #0			; Clear R4
		JSR 	POP_CHAR			; POP character (one's place digit) from stack
		JSR 	ENCODE				; Convert ASCII character to hexidecimal
		ST 	R0, SaveONES			; save one's place value in SaveONES
		ADD	R3, R0, #0			; STORE popped (one's place) value from R0 to R3
		

;-------------------;		
;adding ten's place
; value to score
;-------------------;	
		AND 	R0, R0, #0			; Clear R0
		JSR 	POP_CHAR			; POP character (ten's digit) from stack
		JSR 	ENCODE				; Convert ASCII character to hexidecimal	
		JSR 	MULT_BY_10			; Multiply R0 value by 10
		ADD	R3, R3, R0			; Add tens's place value from R0 to R3

;-------------------;		
;adding hundred's place
; value to score
;-------------------;	
		AND 	R0, R0, #0			; Clear R0
		JSR 	POP_CHAR			; POP character (hundred's digit) from stack
		JSR 	ENCODE				; Convert ASCII character to hexidecimal
		JSR 	MULT_BY_100			; Multiply R0 value by 100
		ADD	R3, R3, R0			; Add hundreds's place value from R0 to R3
		ST 	R3, SaveScore			; Add score to temporary address
		LD 	R7, SaveLoc2			; Load SaveLoc2 to R7
		RET					; Return back to calling program

;--------------------------------------;
;Subroutine MULT_BY_10: Multiply argument by 10 
;--------------------------------------;
; [INSERT COMMENTS HERE]
;--------------------------------------;
MULT_BY_10
	ST 	R0, SaveTENS		; save ten's place value in SaveReg1
	AND 	R0, R0, #0		; Clear R0
	AND 	R4, R4, #0		; Clear R4
	LD 	R4, SaveTENS		; Load ten's place value  value to R4
	LD 	R2, TEN			;load loop counter to R2
MULT10_LOOP
	ADD 	R0, R0, R4
	ADD 	R2, R2, #-1		; decrement loop counter
	BRp 	MULT10_LOOP
	RET

;--------------------------------------;
;Subroutine MULT_BY_100: Multiply argument by 100 
;--------------------------------------;
; [INSERT COMMENTS HERE]
;--------------------------------------;
MULT_BY_100
	ST 	R0, SaveHUND		; save hundred's place value in SaveReg2
	AND 	R0, R0, #0		; Clear R0
	AND 	R4, R4, #0		; Clear R4
	LD 	R4, SaveHUND		; Load hundred's place value to R4
	LD 	R2, HUNDRED		; load loop counter to R2
MULT100_LOOP
	ADD 	R0, R0, R4
	ADD 	R2, R2, #-1		; decrement loop counter
	BRp 	MULT100_LOOP
	RET

TEN	.FILL xA
HUNDRED	.FILL x64
;-------------------------------------------------------------------------


;---------------------------------STORE SCORE-----------------------------
;--------------------------------------;
;Subroutine STORE_SCORES: Store score value into SCORES array 
;--------------------------------------;
; [INSERT COMMENTS HERE]
;--------------------------------------;
STORE_SCORES	
		LD	R6, SaveArrAdd
		LD	R3, SaveScore			; load score from SaveScore address to R3
		STR	R3, R6, #0			; Store score (saved in R3) into SCORES memory location
		ADD 	R6, R6, #1			; point to next address in SCORE
		ST	R6, SaveArrAdd			; saves SCORE address 
		RET					; Return back to calling program
;-------------------------------------------------------------------------


;------------------------------STACK MANAGEMENT---------------------------
;[INSERT COMMENTS HERE]
;
;
;--------------------------------------;
;Subroutine PUSH_CHAR : Push character into stack
;--------------------------------------;
; R1:
; R2:
; R5:
; R6:
;--------------------------------------;
PUSH_CHAR  
		LD	R6, SaveStackAdd		; load stack address into R6
		LD 	R1, MAX				; MAX = -x3FFB
       		ADD 	R2, R6, R1			; compare stack pointer with x3FFF
       		BRz	FAIL            		; Branch if stack is full
       		ADD 	R6, R6, #-7			; Adjust stack pointer (decrement by 7 because ASCII is 7 bits)
		ST	R6, SaveStackAdd		; store R6 into stack address
       		STR 	R0, R6, #0			; Store value in R0 to stack
        	AND 	R5, R5, #0           		; SUCCESS: R5 = 0
        	RET

MAX	.FILL xC005


;--------------------------------------;
;Subroutine POP_CHAR: Pop character from stack
;--------------------------------------;
; R1:
; R2:
; R5:
; R6:
;--------------------------------------;
POP_CHAR    	LD	R6, SaveStackAdd	; load stack address into R6
		LD R1, EMPTY			; EMPTY = -x4000
		ADD R2, R6, R1			; COMPARE STACK POINTER with x3FFF
  		BRz FAIL			; Branch if stack is empty
    		LDR R0, R6, #0			; Load popped value into R0
   		ADD R6, R6, #7			; Adjust stack pointer 
		ST	R6, SaveStackAdd		; store R6 into stack address
   		AND R5, R5, #0           	; SUCCESS: R5 = 0
   		RET

EMPTY	.FILL xC000

;--------------------------------------;
;Subroutine FAIL
;--------------------------------------;
FAIL    AND R5, R5, #0			;OVERFLOW/UNDERFLOW DETECTED, FAIL: R5 = 1
   	ADD R5, R5, #1			;
   	RET

SaveStackAdd	.FILL x0
;-------------------------------------------------------------------------





;--------------------------CONVERT INPUT TO VALUE-------------------------


;--------------------------------------;
; Subroutine ENCODE: (ASCII to Hexadecimal conversion)
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
; R1: Contains ASCII digit to value digit offset (
; R0: Contains ASCII value to be converted into hexadecimal value
;--------------------------------------;
DECODE

	AND R1, R1, #0			; Clear R1
	ADD R1, R1, #15			; Subtracting 48 (ASCII offset) 
	ADD R1, R1, #15
	ADD R1, R1, #15
	ADD R1, R1, #3
	ADD R0, R0, R1
	RET
;-------------------------------------------------------------------------




;----------------------------CALCULATE MIN & MAX--------------------------
;MAXIMUM
;Max score stored in R5

CALCULATE_MAX	;Calculate MAX score
	
	ST R7, SaveLoc3		;Save return address so it does not get overwritten

	LD R1, SaveArrAdd	;Load address of SCORES in R1
	LDR R5, R1, #0		;Set R5 to first score, first score = MAX
	ADD R2, R1, #1		;R2 moves to next score
	AND R0, R0, #0		;Loop counter in R0
	ADD R0, R0, #4		;Counter = 4 

	
MAX_LOOP
	LDR R3, R2, #0		;LOAD R2 (NEXT SCORE) INTO R3
	NOT R4, R5
	ADD R4, R4, #1		;2S COMP R4 = -R5
	ADD R4, R3, R4		;R4 = R3 - R5
	BRn SKIP		;IF R3 < R5, SKIP
	ADD R5, R3, #0		;else, update MAX 
	
SKIP
	ADD R2, R2, #1		;R2 move to next score in array
	ADD R0, R0, #-1		;Decrement loop
	BRp MAX_LOOP		;Loop until 5 scores

	ST R5, MAX_GRADE
	LD R7, SaveLoc3		;restore return address
	RET

;display max
LEA R0, MAXIMUM
PUTS
MAXIMUM .STRINGZ	"Maximum Score: "

;MINIMUM
;MIN STORED IN R5	

CALCULATE_MIN

	ST R7, SaveLoc4		;store
	
	LD R1, SaveArrAdd	;Load address of SCORES into R1
	LDR R5, R1, #0		;Set R5 to first score, first score = MIN
	ADD R2, R1, #1		;Next 
	AND R0, R0, #0		;Loop counter in R0
	ADD R0, R0, #4		;Counter =4

MIN_LOOP
	LDR R3, R2, #0		;Load next score to R3
	NOT R4, R3
	ADD R4, R4, #1		;2S COMP R4 = -R3
	ADD R4, R5, R4		;R4 = R5 - R3
	BRn SKIP_MIN		;IF R5 < R3, SKIP
	ADD R5, R3, #0		;Else update MIN
	

SKIP_MIN
	ADD R2, R2, #1		;Next score
	ADD R0, R0, #-1		;Decrement Loop
	BRp MIN_LOOP		;Loop until done
	ST R5, MIN_GRADE
	
	LD R7, SaveLoc4		;return
	RET
	
	
;Display Min
LEA R0, MINIMUM
PUTS
MINIMUM .STRINGZ	"Minimum Score: "


;-------------------------------------------------------------------------



;-----------------------------CALCULATE AVG-------------------------------
;[INSERT CODE]
;-------------------------------------------------------------------------



;----------------------ASSIGN LETTER GRADE TO SCORE-----------------------
;[INSERT CODE]
;-------------------------------------------------------------------------

.END
