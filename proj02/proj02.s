
# Name: Francis Kim
# File of Name: proj02.s
# Due: 09/22/2016 9:00 pm
# Project 2 : In this project, you will be using loops to iterate over arrays and strings. You
#	      will practice how to build loops, modeling both for() loops and while() loops.
#             You’ll also practice with reading integers and characters, and learn about a new syscall.

.data
newline: .asciiz "\n"	# print new line
at: .asciiz "@"		# this is right before 'A' in ascii code
brek: .asciiz "["	# This is right after 'Z' in ascii code

.text
main:
	# Prologue: set up stack and frame pointers for main
    	addiu   $sp, $sp, -24    # allocate stack space -- default of 24 here
      	sw      $fp, 0($sp)      # save caller's frame pointer
     	sw      $ra, 4($sp)      # save return address
      	addi    $fp, $sp, 20     # setup main's frame pointer

	#Start program
	la $t0, integers	
	lb $s0, 0($t0)		# save integers into $s0

	la $t0, forward
	lb $s1, 0($t0)		# save forward into #s1

	slt $t0, $zero, $s0
	beq $t0, $zero, printStr	# if integer is bigger than 0 then, print integer, if not print string
	j printInt	
# decide print integer forward or backward
printInt:
	slt $t0, $zero, $s1
	beq $t0, $zero, printIntBack		# if forward is bigger than 0, then print integer forward, if not print backward
	j printIntForward

# decide print String forward or backward
printStr:
	slt $t0, $zero, $s1
	beq $t0, $zero, printStrBack		# if forward is bigger than 0, then print integer forward, if not print backward
	j printStrForward

# Print integer forward way
printIntForward:
	addi $s1, $zero, 0 	# i = 0
	la $t0, numInts		
	lw $s2, 0($t0) # $s2 = numInts		# save number of integers into $s2		
	la $t0, ints 		# save address of elements into #t0
	j loopBeginPrintIntForward		# jump to loopBeginPrintIntForward
	
# Print integer backard way
printIntBack:
	la $t0, numInts
	lw $s0, 0($t0)
	sub $s0, $s0, 1 	# $s0 = numInts - 1
	la $t0, ints 		# save address of elements into $t0
	sub $s1, $zero, 1 	# i = -1
	j loopBeginPrintIntBack # jump to loopBeginPrintIntBack

# Print String forward way
printStrForward:
	la $t0, str		# save address of String into $t0
	addi $s1, $zero, 0 # i = 0;
	j  loopBeginPrintStrForward	# jump to loopBeginPrintStrForward

# Print String backward way
printStrBack:
	la $t0, str 		# save address of String into $t0	
	addi $s1, $zero, 0 	# i = 0;	
	j  endOfString		# jump to endOfString

# loop for foward int
loopBeginPrintIntForward:
	# test if for loop is done
	slt $t1, $s1, $s2 	# $t1 = i < numInts
	beq $t1, $zero, loopEnd		
	# Compute address of elements[i] foward to back
	add $t1, $s1, $s1
	add $t1, $t1, $t1 	# $t1 = 4 * 1
	add $t2, $t0, $t1	# $t2 = address of elements[i]
	
	lw $s0, 0($t2)		# $s0 = $t2
	
	bne $s0, $zero, continue	# if $s0 != 0, then go to continue (this ignore 0)
	addi $s1, $s1, 1 	# i++
	j loopBeginPrintIntForward	# Jump to loopBeginPrintIntForward (loop)

# continue, if elements [i] is not zero, then print out value
continue:
	# print elements[i]
	lw $a0, 0($t2) # $a0 = elements[i]
	addi $v0, $zero, 1
	syscall

	# print newline
	la $a0, newline
	addi $v0, $zero, 4
	syscall
	addi $s1, $s1, 1 # i++
	j loopBeginPrintIntForward

#loop for backward int
loopBeginPrintIntBack:
	# test if for loop is done
	slt $t1, $s1, $s0
	beq $t1, $zero, loopEnd
	#compute address of elements[i] back to forward
	add $t1, $s0, $s0
	add $t1, $t1, $t1 # $t1 = 4 * (numInts - 1)
	add $t2, $t0, $t1 # $t2 = address of elements[numInts - 1]

	# Print integer
	lw $a0, 0($t2) # $a0 = elements[numInts - 1]
	addi $v0, $zero, 1
	syscall
	
	# print newline
	la $a0, newline
	addi $v0, $zero, 4
	syscall

	sub $s0, $s0, 1 # numInts--
	j loopBeginPrintIntBack

#loop for foward str
loopBeginPrintStrForward:
	
	
	add $t2, $t0, $s1
	lb $t1, 0($t2)

	beq $t1, $zero, loopEnd 	# end if str point to \0

	la $t4, at
	lb $s2, 0($t4)		# $s2 = '@' right before 'A'
	
	la $t4, brek
	lb $s3, 0($t4)		# $s3 = '[' right after 'Z'

	# This two slt is ignore the small letter of alphabet
	slt $t4, $s2, $t1	# if '@' < $t1
	beq $t4, $zero, strForwardPrint1


	slt $t4, $t1, $s3	# if $t1 < '[' 
	beq $t4, $zero, strForwardPrint2

	add $s1, $s1, 1
	j loopBeginPrintStrForward

# Print String forward if there is no capital letter
strForwardPrint1:
	# Print str[i]
	lb $a0, 0($t2) 	# $a0 = str[i]
	addi $v0, $zero, 11
	syscall

	# print newline
	la $a0, newline
	addi $v0, $zero, 4
	syscall
	add $s1, $s1, 1
	j loopBeginPrintStrForward

# Print String forward if there is no capital letter
strForwardPrint2:
	# Print str[i]
	lb $a0, 0($t2) # $a0 = str[i]
	addi $v0, $zero, 11
	syscall

	# print newline
	la $a0, newline
	addi $v0, $zero, 4
	syscall

	add $s1, $s1, 1
	j loopBeginPrintStrForward

# make *t2 goes to end of String which is '\0'
endOfString:
	
	add $t2, $t0, $s1 # at the end t2 is point to null
	lb $t1, 0($t2)
	beq $t1, $zero, setT0minus1	# if value of $t2 = t1 point to '\0', then jump to setT0minus1

	addi $s1, $s1, 1	# i++
	j endOfString

# $t0 = $t0 - 1 ($t0 = address of str)
setT0minus1:
	sub $t0, $t0, 1
	j loopBeginPrintStrBackward

# loop for backward str
loopBeginPrintStrBackward:

	
	add $t2, $t0, $s1
	lb $t1, 0($t2)
	beq $t2, $t0, loopEnd		# if $t2 = str, then loop end

	# Print String each charcter
	lb $a0, 0($t2)
	addi $v0, $zero, 11
	syscall

	# print newline
	la $a0, newline
	addi $v0, $zero, 4
	syscall
	sub $s1, $s1, 1		# i--

	j loopBeginPrintStrBackward

# loop is End
loopEnd:
	

done:    # Epilogue for main -- restore stack & frame pointers and return
         lw    $ra, 4($sp)    # get return address from stack
         lw    $fp, 0($sp)    # restore the caller's frame pointer
         addiu $sp, $sp, 24   # restore the caller's stack pointer
         jr    $ra            # return to caller's code