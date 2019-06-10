.data

printString: .asciiz "Printing the four values:\n"
sumString: .asciiz "Running totals:\n"
mulString: .asciiz "\"Multiplying\" each value by 7:"
minimumString: .asciiz "Minimum: "
space: .asciiz "  "
newline: .asciiz "\n"


y: .word 7
x: .word 4
turn: .word 1
turn1: .word 2
turn2: .word 3
turn3: .word 4

.text

main:
	# Prologue: set up stack and frame pointers for main
    	addiu   $sp, $sp, -24    # allocate stack space -- default of 24 here
      	sw      $fp, 0($sp)      # save caller's frame pointer
     	sw      $ra, 4($sp)      # save return address
      	addi    $fp, $sp, 20     # setup main's frame pointer

# If print is equal to 1 then jump to Print
selectP:
	la $t0, print
	lw $s0, 0($t0)
	slt $t0, $zero, $s0
	beq $t0, $zero, selectS
	j Print
# If print is equal to 1 then jump to Sum
selectS:
	la $t0, sum
	lw $s0, 0($t0)
	slt $t0, $zero, $s0
	beq $t0, $zero, selectM
	j Sum
# If print is equal to 1 then jump to MultiplyFoo
selectM:
	la $t0, multiply
	lw $s0, 0($t0)
	slt $t0, $zero, $s0
	beq $t0, $zero, selectMin
	j MultiplyFoo
# If print is equal to 1 then jump to Minimum
selectMin:
	la $t0, minimum
	lw $s0, 0($t0)
	slt $t0, $zero, $s0
	beq $t0, $zero, done
	j MinimumFoo

# This is print only numbers
Print:
	# set up and print the string "printString"
	la $a0, printString
	addi $v0, $zero, 4
	syscall

	la $t0, foo
	lb $s0, 0($t0)

	la $t0, print
	sw $s0, 0($t0)

	# print foo
	add $a0, $s0, $zero  
	addi $v0, $zero, 1
	syscall

	# print newline
	la   $a0, newline
        addi $v0, $zero, 4
        syscall

	la $t0, bar
	lw $s0, 0($t0)

	la $t0, print
	sw $s0, 0($t0)

	# print bar
	add $a0, $s0, $zero
	addi $v0, $zero, 1
	syscall

	# print newline
	la   $a0, newline
        addi $v0, $zero, 4
        syscall

	la $t0, baz
	lw $s0, 0($t0)

	la $t0, print
	sw $s0, 0($t0)

	# print baz
	add $a0, $s0, $zero
	addi $v0, $zero, 1
	syscall	
	
	# print newline
	la   $a0, newline
        addi $v0, $zero, 4
        syscall

	la $t0, fred
	lh $s0, 0($t0)
	
	la $t0, print
	sw $s0, 0($t0)

	# print fred
	add $a0, $s0, $zero
	addi $v0, $zero, 1
	syscall
	
	# print newline
	la   $a0, newline
        addi $v0, $zero, 4
        syscall

	# print newline
	la   $a0, newline
        	addi $v0, $zero, 4
        	syscall

	# make print = 0
	j selectS

#This is only print Sum of numbers
Sum:
	# Print the sum values
	
	# set up and print the string "printString"
	la $a0, sumString
	addi $v0, $zero, 4
	syscall

	# save each data to s0~s3
	la $t0, foo
	lb $s0, 0($t0)
	la $t0, bar
	lw $s1, 0($t0)
	la $t0, baz
	lw $s2, 0($t0)
	la $t0, fred
	lh $s3, 0($t0)

	# first sum
	add $s4, $s0, $zero

	la $t0, sum
	sw $s4, 0($t0)

	# Print first sum
	add $a0, $s4, $zero
	addi $v0, $zero, 1
	syscall

	# print newline
	la   $a0, newline
        addi $v0, $zero, 4
        syscall
	
	# second sum
	add $s4, $s4, $s1
	
	la $t0, sum
	sw $s4, 0($t0)

	# Print second sum
	add $a0, $s4, $zero
	addi $v0, $zero, 1
	syscall
	
	# print newline
	la   $a0, newline
        	addi $v0, $zero, 4
        	syscall

	# third sum
	add $s4, $s4, $s2

	la $t0, sum
	sw $s4, 0($t0)

	# Print second sum
	add $a0, $s4, $zero
	addi $v0, $zero, 1
	syscall

	# print newline
	la   $a0, newline
        	addi $v0, $zero, 4
        	syscall

	# last sum
	add $s4, $s4, $s3
	
	la $t0, sum
	sw $s4, 0($t0)

	# Print second sum
	add $a0, $s4, $zero
	addi $v0, $zero, 1
	syscall

	# print newline
	la   $a0, newline
        addi $v0, $zero, 4
        syscall

	# print newline
	la   $a0, newline
        	addi $v0, $zero, 4
        	syscall

	# make sum = 0
	j selectM
# Multiply foo by 7
MultiplyFoo:
	
	# set up and print the string "mulString"
	la $a0, mulString
	addi $v0, $zero, 4
	syscall
	# print newline
	la   $a0, newline
        	addi $v0, $zero, 4
        	syscall

	la $t0, foo
	lb $s0, 0($t0)

	la $t0, y
	lw $s1, 0($t0)

	add $s2, $zero, $zero # sum=0
	add $t0, $zero, $zero # i=0

	#loop begin to multiply 7
	j LoopBeginFoo

# Multiply bar by 7
MultiplyBar:

	la $t0, bar
	lb $s0, 0($t0)
	
	la $t0, y
	lw $s1, 0($t0)

	add $s2, $zero, $zero # sum=0
	add $t0, $zero, $zero # i=0

	#loop begin to multiply 7
	j LoopBeginBar

# Multiply baz by 7
MultiplyBaz:

	la $t0, baz
	lb $s0, 0($t0)
	
	la $t0, y
	lw $s1, 0($t0)

	add $s2, $zero, $zero # sum=0
	add $t0, $zero, $zero # i=0
	
	#loop begin to multiply 7
	j LoopBeginBaz
# Multiply fred by 7
MultiplyFred:

	la $t0, fred
	lb $s0, 0($t0)
	
	la $t0, y
	lw $s1, 0($t0)

	add $s2, $zero, $zero # sum=0
	add $t0, $zero, $zero # i=0
	
	#loop begin to multiply 7
	j LoopBeginFred

# foo * 7
LoopBeginFoo:

	# for loop
	slt $t2, $t0, $s1
	beq $t2, $zero, LoopEndFoo
	
	# loop body
	add $s2, $s2, $s0 #sum = sum + x

	#increment loop index
	addi $t0, $t0, 1 # i++

	j LoopBeginFoo

# bar * 7
LoopBeginBar:

	# for loop
	slt $t2, $t0, $s1
	beq $t2, $zero, LoopEndBar
	
	# loop body
	add $s2, $s2, $s0 #sum = sum + x

	#increment loop index
	addi $t0, $t0, 1 # i++

	j LoopBeginBar

# baz * 7
LoopBeginBaz:

	# for loop
	slt $t2, $t0, $s1
	beq $t2, $zero, LoopEndBaz
	
	# loop body
	add $s2, $s2, $s0 #sum = sum + x

	#increment loop index
	addi $t0, $t0, 1 # i++

	j LoopBeginBaz

# fred * 7
LoopBeginFred:

	# for loop
	slt $t2, $t0, $s1
	beq $t2, $zero, LoopEndFred
	
	# loop body
	add $s2, $s2, $s0 #sum = sum + x

	#increment loop index
	addi $t0, $t0, 1 # i++

	j LoopBeginFred


#print out result and print space
LoopEndFoo:
	add $a0, $s2, $zero
	addi $v0, $zero, 1
	syscall

	# print space
	la   $a0, space
       	addi $v0, $zero, 4
      	syscall
	j MultiplyBar

#print out result and print space
LoopEndBar:
	add $a0, $s2, $zero
	addi $v0, $zero, 1
	syscall

	# space
	la   $a0, space
       	addi $v0, $zero, 4
      	syscall
	j MultiplyBaz

#print out result and print space
LoopEndBaz:
	add $a0, $s2, $zero
	addi $v0, $zero, 1
	syscall

	# print space
	la   $a0, space
       	addi $v0, $zero, 4
      	syscall
	j MultiplyFred

#print out result and print space
LoopEndFred:
	add $a0, $s2, $zero
	addi $v0, $zero, 1
	syscall

	# space
	la   $a0, newline
       	addi $v0, $zero, 4
      	syscall
	
	# print newline
	la   $a0, newline
       	addi $v0, $zero, 4
      	syscall

	j selectMin

# print out minimumString and save foo value into s0
MinimumFoo:
	# set up and print the string "minimumString"
	la $a0, minimumString
	addi $v0, $zero, 4
	syscall

	la $t0, foo
	lb $s0, 0($t0)

# save bar value and compare with previous value
MinimumBar:
	la $t0, bar
	lw $s1, 0($t0)

	slt $t0, $s0, $s1
	beq $t0, $zero, setBar

# save baz value and compare with previous value
MinimumBaz:
	la $t0, baz
	lw $s2, 0($t0)

	slt $t0, $s0, $s2
	beq $t0, $zero, setBaz
	
# save fred value and compare with previous value
MinimumFred:
	la $t0, fred
	lh $s3, 0($t0)

	slt $t0, $s0, $s3
	beq $t0, $zero, setFred
	j PrintMin
	
# bar is most big number	
setBar:
	add $s0, $s1, $zero
	j MinimumBaz

# baz is most big number
setBaz:
	add $s0, $s2, $zero
	j MinimumFred

# fred is most big number, and print out final value if it is not jump to printMin
setFred:
	add $s0, $s3, $zero
	add $a0, $s0, $zero
	addi $v0, $zero, 1
	syscall

	# print newline
	la   $a0, newline
        	addi $v0, $zero, 4
        	syscall
	
	# print newline
	la   $a0, newline
        	addi $v0, $zero, 4
        	syscall

	j done
#Print minimum value
PrintMin:
	add $a0, $s0, $zero
	addi $v0, $zero, 1
	syscall
	
	# print newline
	la   $a0, newline
        	addi $v0, $zero, 4
        	syscall

	# print newline
	la   $a0, newline
        	addi $v0, $zero, 4
        	syscall

	j done

done:    # Epilogue for main -- restore stack & frame pointers and return
         lw    $ra, 4($sp)    # get return address from stack
         lw    $fp, 0($sp)    # restore the caller's frame pointer
         addiu $sp, $sp, 24   # restore the caller's stack pointer
         jr    $ra            # return to caller's code
