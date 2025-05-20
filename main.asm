;

.ORIG x3000

; Clear registers
	AND R0, R0, x0	
	AND R1, R1, x0	
	AND R2, R2, x0
	AND R3, R3, x0
	AND R4, R4, x0
	AND R5, R5, x0
	AND R6, R6, x0                                                                                     

;/////////////////////////////////////////////
;	Output prompt to console 
	
	LEA R0, PROMPT1
	PUTS
	AND R0, R0, x0	

;/////////////////////////////////////////////
; Collect user input
SCORE_INPUT_LOOP
	GETC
	OUT 
	LD R6, SCORE_INPUT_LC		; load Input Loop Counter into R6
	ADD R6, R6, #-1			; Decrement Loop Counter
	ST R6, INPUTLC
	BRp SCORE_INPUT_LC		; loop until zero/negative

HALT






PROMPT1 .STRINGZ "Enter a test score in the format XXX (ex. 100, 098, 015) \n"
SCORE_INPUT_LC	.FILL #3

.END
