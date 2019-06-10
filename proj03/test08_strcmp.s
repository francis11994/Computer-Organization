
.data

mode:
	.byte   4       # strcmp

numStrs:
	.byte   16
strings:
	.word	STR_CONST__zero
	.word	STR_CONST__one
	.word	STR_CONST__two
	.word	STR_CONST__three
	.word	STR_CONST__four
	.word	STR_CONST__five
	.word	STR_CONST__six
	.word	STR_CONST__seven
	.word	STR_CONST__eight
	.word	STR_CONST__nine
	.word	STR_CONST__ten
	.word	STR_CONST__eleven
	.word	STR_CONST__twelve
	.word	STR_CONST__thirteen
	.word	STR_CONST__fourteen
	.word	STR_CONST__fifteen

STR_CONST__zero:
	.asciiz "zero"
STR_CONST__one:
	.asciiz "one"
STR_CONST__two:
	.asciiz "two"
STR_CONST__three:
	.asciiz "three"
STR_CONST__four:
	.asciiz "four"
STR_CONST__five:
	.asciiz "five"
STR_CONST__six:
	.asciiz "six"
STR_CONST__seven:
	.asciiz "seven"
STR_CONST__eight:
	.asciiz "eight"
STR_CONST__nine:
	.asciiz "nine"
STR_CONST__ten:
	.asciiz "ten"
STR_CONST__eleven:
	.asciiz "eleven"
STR_CONST__twelve:
	.asciiz "twelve"
STR_CONST__thirteen:
	.asciiz "thirteen"
STR_CONST__fourteen:
	.asciiz "fourteen"
STR_CONST__fifteen:
	.asciiz "fifteen"


s1:
	.byte   0
s2:
	.byte   1
c:
	.half   0

