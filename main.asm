; comment

.ORIG x3000

LEA R0, WELCOME
PUTS

; loop for input
AND R4, R4, #0
ST  R4, i

; i is stored in R4

TEST LD R4, i
	 LD R3, limit
	 NOT R3, R3
	 ADD R3, R3, #1
	 ADD R4, R4, R3
	 BRzp END

AND R1, R1, #0

SCORE_INPUT_LOOP
	GETC
	OUT 
	LD R6, SCORE_INPUT_LC		; load Input Loop Counter into R6
	ADD R6, R6, #-1
	ST R6, INPUTLC
	BRp SCORE_INPUT_LC		; loop until negative

ADD R1, R0, R1 ; add 
ADD R1, R1, #15
ADD R1, R1, #15 ; decimal value conversion


ADD R0, R0, #15 
ADD R0, R0, #15 ; decimal value conversion
ADD R2, R0, R0
ADD R3, R2, R2
ADD R5, R3, R3
ADD R5, R5, R2
ADD R1, R1, R5 ; now it's equal to the second character * 10 + the first character * 10

LEA R0, SCORE_RECORDED
PUTS

INCR LD  R4, i
	 ADD R4, R4, #1
	 ST  R4, i
	 BR TEST
END

HALT

WELCOME .STRINGZ "Enter a test score in the format XXX (ex. 100, 098, 015) \n"
i .FILL #0
limit .FILL #14
ascii .FILL #30
CHARACTER_RECORDED .STRINGZ "Digit has been recorded.\n"
SCORE_RECORDED .STRINGZ "Test score has been recorded.\n"
.end
