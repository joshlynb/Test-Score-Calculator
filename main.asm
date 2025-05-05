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

; don't want to write another loop so just this
AND R1, R1, #0
GETC ; take input
OUT  ; show that it was taken

ADD R1, R0, R1 ; add 
ADD R1, R1, #15
ADD R1, R1, #15 ; decimal value conversion

GETC
OUT

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

WELCOME .STRINGZ "Welcome to the test score calculator. To begin, please enter your five test scores in three digits each, with no spaces in between, for example: 010098100078085\n"
i .FILL #0
limit .FILL #14
ascii .FILL #30
CHARACTER_RECORDED .STRINGZ "Digit has been recorded.\n"
SCORE_RECORDED .STRINGZ "Test score has been recorded.\n"
.end
