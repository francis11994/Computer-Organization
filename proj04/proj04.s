# Name: Francis Kim
# File of Name: proj04.s
# Due: 10/28/2016 9:00 pm (Late submit)
# Project 4 : In this project, we’ll be using functions for the first time.
#	      There are three main functions to make by ourself
#	1. int printRev(char*)
#	Prints out the characters of the string, but in reverse order.
#	2. int nibbleScan(int)
#	Has a single parameter, which is an integer. Your function will check
#	all 8 of the nibbles of this word (remember, a “nibble” is 4 bits).
#	3. int multiply(int, int)
#	You will multiply the two values, and return the product. Your
#	function will not print out anything.

.text
# printRev($a0) -- This is the printRev function
printRev:
	# Startup sequence
	addiu $sp, $sp, -24
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	sw $a0, 8($sp)	# parameter 1
	addi $fp, $sp, 20

	# load s0 to s7 in the new stack
	addiu $sp, $sp, -32
 	sw $s7, 28($sp)
	sw $s6, 24($sp)
 	sw $s5, 20($sp)
 	sw $s4, 16($sp)
 	sw $s3, 12($sp)
 	sw $s2, 8($sp)
 	sw $s1, 4($sp)
 	sw $s0, 0($sp)
	
	addi $s0, $zero, 0 # i = 0
	
	j countLength

# Count length
countLength:
	add $s1, $a0, $s0	#save $s1 = address of $a0
	lb $s2, 0($s1)		#save character into $s2
	beq $s2, $zero, endCountLength	#if $s2 goes to null, then go to endCountLength

	addi $s0, $s0, 1		#i++
	j countLength
# Count the length of string
endCountLength:
	addi $s4, $s0, 0 # return length of string
	addiu $sp, $sp, -60	# make a black stack to register each character
	addi $s3, $sp, 0		# $s3 is pointer of $sp
	sub $s0, $s0, 1		# length - 1
	addi $s6, $a0, 0		# $s6 = address of $a0
	sub $a0, $a0, 1		# address - 1
	j saveCharInStack

saveCharInStack:
	add $s7, $s6, $s0	# from end of string to beginning of string
	lb $s2, 0($s7)
	beq $s7, $a0, saveCharInStackEnd
	sb  $s2, 0($s3)		
	addi $s3, $s3, 1		# increase pointer
	sub $s0, $s0, 1		# address - 1
	j saveCharInStack
	
saveCharInStackEnd:
	sb $zero, 0($s3)		
	addi $s3, $sp, 0		
		
	addi $a0, $sp, 0		# $a0 is the start of pointer in the stack
	jal printStr
	add $v0, $s4, $zero	# save number of non-zero into $v0

	# Restore the $s registers we wish to save
	lw $s7, 88($sp)
	lw $s6, 84($sp)
 	lw $s5, 80($sp)
 	lw $s4, 76($sp)
 	lw $s3, 72($sp)
 	lw $s2, 68($sp)
 	lw $s1, 64($sp)
 	lw $s0, 60($sp)
	addiu $sp, $sp, 92

	# Start by creating the "standard" stack
	lw	$a0, 8($sp)
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra


#nibbleScan($a) -- Has a single parameter, which is an integer. Your function will check all 8 of the nibbles of this word (remember, a “nibble” is 4 bits).
nibbleScan:
	# Startup sequence
	addiu $sp, $sp, -24
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 20

	# load s0 to s7 in the new stack
	addiu $sp, $sp, -32
 	sw $s7, 28($sp)
	sw $s6, 24($sp)
 	sw $s5, 20($sp)
 	sw $s4, 16($sp)
 	sw $s3, 12($sp)
 	sw $s2, 8($sp)
 	sw $s1, 4($sp)
 	sw $s0, 0($sp)

	la $s7, ($a0)	# load address into $s7
	
	addi $s2, $zero, 8 # number of nibbles
	addi $s3, $zero, 0 # index
	addi $s5, $zero, 0 # digit position number
	addi $s4, $zero, 0 # $v0 = number of non zero
	j nibbleLoopBegin

nibbleLoopBegin:
	srl $s1, $s7, $s3	# move right to read each digit value
	andi $s6, $s1, 0x0000000f	# get a 1 to 4 digit value and save into $s6
	beq $s2, $zero, End	# if number of nibbles 0, then finish function
	addi $a0, $s5, 0		# save digit position number into $a0
	addi $a1, $s6, 0		# save each digit number into $a1
	beq $a1, $zero, skip	# if digit number is 0, then skip
	jal printNibble		# print $a0 and $a1
	addi $s4, $s4, 1		# count how many number is non-zero
	sub $s2, $s2, 1		# number of nibbles - 1
	addi $s5, $s5, 1		# increase digit position number
	addi $s3, $s3, 4		# increase 4 bits to move $s7
	j nibbleLoopBegin
skip:
	sub $s2, $s2, 1		# number of nibbles - 1
	addi $s5, $s5, 1		# increase digit position number
	addi $s3, $s3, 4		# increase 4 bits to move $s7
	j nibbleLoopBegin	# loop begin again
End:
	addi $v0, $s4, 0
	# Restore the $s registers we wish to save
	lw $s7, 28($sp)
	lw $s6, 24($sp)
 	lw $s5, 20($sp)
 	lw $s4, 16($sp)
 	lw $s3, 12($sp)
 	lw $s2, 8($sp)
 	lw $s1, 4($sp)
 	lw $s0, 0($sp)
	addiu $sp, $sp, 32
	# Start by creating the "standard" stack
	lw	$a0, 8($sp)
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



# multiply($a0, $a1) -- You will multiply the two values, and return the product. Your function will not print out anything
multiply:
	# Startup sequence
	addiu $sp, $sp, -24
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	sw $a0, 8($sp)
	sw $a1, 12($sp)
	addi $fp, $sp, 20

	# load s0 to s7 in the new stack
	addiu $sp, $sp, -32
 	sw $s7, 28($sp)
	sw $s6, 24($sp)
 	sw $s5, 20($sp)
 	sw $s4, 16($sp)
 	sw $s3, 12($sp)
 	sw $s2, 8($sp)
 	sw $s1, 4($sp)
 	sw $s0, 0($sp)

	addi $s2, $zero, 0	# $s2 = 0 means it is positive

	addi $s6, $a0, 0 	# copy $a0(first arg num) into $s0, so $s0 = $a0
	
	slt $s1, $s6, $zero 	# is value < 0?
	beq $s1, $zero, checkSecondArgument
	sub $s6, $zero, $s6 	# $s0 = 0 - $s0
	add $a0, $s6, $zero
	addi $s2, $s2, 1		# $s2 = 1 means it is negative

checkSecondArgument:
	addi $s4, $zero, 1	 #$s4 = 0000 0000 0000 0000 0000 0000 0000 0001 and will shipt it
	addu $s5, $zero, 0	 #$s5 = 0 will use to decide n of 2^n
	addi $s3, $a1, 0 
	slt $s1, $s3, $zero	# is value < 0?
	beq $s1, $zero, getTwoToTheNum
	sub $s3, $zero, $s3	# $s3 = 0 - $a1
	addi $s2, $s2, 1		# $s2 = 2 means positive, $s2 = 1 means negative

getTwoToTheNum:
	sll $s0, $s4, $s5	# $s6 is shift left $s4 to $s5
	beq $s3, $s0, calculate
	slt $s1, $s0, $s3	# if 2^n < arg2
	beq $s1, $zero, reduceS5
	addi $s5, $s5, 1		# $s5 = $s5 + 1
	jal getTwoToTheNum


reduceS5:
	srl $s0, $s0, 1
	sub $s5, $s5, 1
calculate:
	
	sll $s6, $s6, $s5	# shift left $s0 to $s5
	sub $s7, $s3, $s0	# $s7 = arg2 - shifting value
	addi $s0, $zero, 0

calculate2:
	
	slt $s1, $s0, $s7	# $s8 < arg2 - shifting value
	beq $s1, $zero, positiveOrNegative
	add $s6, $s6, $a0
	addi $s0, $s0, 1
	jal calculate2

positiveOrNegative:
	addi $v0, $s6, 0
	sub $s2, $s2, 1
	beq $s2, $zero, negate
	j End2
negate: 
	sub $s6, $zero, $s6
	addi $v0, $s6, 0		# negate
	

End2:
	# Restore the $s registers we wish to save
	lw $s7, 28($sp)
	lw $s6, 24($sp)
 	lw $s5, 20($sp)
 	lw $s4, 16($sp)
 	lw $s3, 12($sp)
 	lw $s2, 8($sp)
 	lw $s1, 4($sp)
 	lw $s0, 0($sp)
	addiu $sp, $sp, 32
	# Start by creating the "standard" stack
	lw	$a0, 8($sp)
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra




	 



