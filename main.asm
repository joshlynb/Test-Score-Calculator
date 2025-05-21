.ORIG x3000                                                                                  

;/////////////////////////////////////////////
;	Output prompt to console 
	
	LEA R0, PROMPT1
	PUTS
	

;/////////////////////////////////////////////
; Collect user input

	LD	R1, INPUT_LC		; load Input Loop Counter into R6

GET_INPUT
	GETC
	PUTC
	ADD 	R1, R1, #-1		; Decrement Loop Counter
	BRp 	GET_INPUT		; loop until R6 is zero or negative

HALT


PROMPT1 .STRINGZ "Enter a test score in the format XXX (ex. 100, 098, 015) \n"
INPUT_LC	.FILL x3		; initializing get_input loop counter at x3

.END
