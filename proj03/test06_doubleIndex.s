
.data

mode:
	.byte   3       # double-index

numStrs:
	.byte   16
strings:
	.word	STR_CONST__alpha
	.word	STR_CONST__alphaLower
	.word	STR_CONST__digits
	.word	STR_CONST__digitsBackwards
	.word	STR_CONST__oneSpace
	.word	STR_CONST__punctuation

STR_CONST__alpha:
	.asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
STR_CONST__alphaLower:
	.asciiz "abcdefghijklmnopqrstuvwxyz"
STR_CONST__digits:
	.asciiz "0123456789"
STR_CONST__digitsBackwards:
	.asciiz "987654321"
STR_CONST__oneSpace:
	.asciiz "thisIsALongStringWith OnlyOneSpaceInTheMiddle"
STR_CONST__punctuation:
	.asciiz "%)(*#%@#^)(*#%@#$^@#^%?>}{}~"


s1:
	.byte   5
s2:
	.byte   0
c:
	.half   20

