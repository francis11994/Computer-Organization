#	Author: Francis Kim
#	Class: csc252
#	Project 8
#	Purpose: In this program, you will implement a (very limited) MIPS simulator. I have provided main();
#		 you will implement a execInstruction(), a function which executes a single instruction. 
#		 exeInstruction() function returns two values (which obviously isn’t legal in C or Java). 
#		 However, we’ll do this in this function as a way to handle exceptions. The ?rst return value (in $v0) is the new program counter;
#		 the second return value (in $v1) is the error status 
#


execInstruction:
	# Startup sequence
	addiu $sp, $sp, -28
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	sw $a0, 8($sp)	# parameter 1 (instruction)
	sw $a1, 12($sp)	# parameter 2 (pc)
	sw $a2, 16($sp) # parameter 3 (*regs)
	sw $a3, 20($sp) # parameter 4 (*mem)
	addi $fp, $sp, 24

	lw $t0, 24($sp)
	addi $t0, $t0, 0	# parameter 5 (*memSize)

	
	srl $t1, $a0, 26	# extract opcode	

	beq $a0, 0x0000000c, SyscallPrepare	# jump to SyscallPrepare
	beq $t1, 0x00000000, opcodeZero		# jump to opcodeZero
	beq $t1, 0x00000002, opcodeJ		# jump to opcodeJ
	beq $t1, 0x00000003, opcodeJAL 		# jump to opcodeJAL
	beq $t1, 0x00000004, opcodeBEQ		# jump to opcodeBEQ
	beq $t1, 0x00000005, opcodeBNE		# jump to opcodeBNE
	beq $t1, 0x00000023, opcodeLW		# jump to opcodeLW
	beq $t1, 0x0000002b, opcodeSW		# jump to opcodeSW
	beq $t1, 0x00000008, ADDIandADDIU
	beq $t1, 0x00000009, ADDIandADDIU
	j Else



opcodeJAL:

	add $t3, $a2, 124		# get $ra register
	addi $t4, $a1, 4
	sw $t4, ($t3)			# $t4 = pc + 4, copy $t4 into $ra

	sll $t2, $a0, 2			# $t2 = $t2 * 2
	andi $t2, $t2, 0x0000ffff

	add $v0, $t2, $zero		# jump to $t2
	addi $v1, $zero, 0
	j Exit

Else:
	addi $v0, $a1, 0		# increase pc address by 4 and return pc
	addi $v1, $zero, 1		# error = 0 
	j Exit

opcodeZero:

	srl $t2, $a0, 21			# extract rs
	andi $t2, $t2, 0x0000001f

	srl $t3, $a0, 16			# extract rt
	andi $t3, $t3, 0x0000001f			
	
	srl $t4, $a0, 11			# extract rd
	andi $t4, $t4, 0x0000001f

	andi $t5, $a0, 0x0000003f		# extract function
	
	beq $t5, 0x00000020, ADD		# jump to add
	beq $t5, 0x00000022, Subtract		# jump to subtract
	beq $t5, 0x0000002a, SLT		# jump to slt
	beq $t5, 0x00000008, JR			# jump to JR
	
	j Exit
opcodeJ:
	sll $t2, $a0, 2				# move 2 left
	andi $t2, $t2, 0x0000ffff		# get immed
	add $v0, $t2, $zero			# move to $t2
	addi $v1, $zero, 0
	j Exit

JR:
	srl $t2, $a0, 21			# extract rs
	andi $t2, $t2, 0x0000001f	

	sll $t2, $t2, 2
	add $t2, $a2, $t2
	lw $t2, ($t2) 				# get value of register rs

	add $v0, $t2, $zero			# move to address that point rs
	addi $v1, $zero, 0
	j Exit
opcodeBEQ:
	srl $t2, $a0, 21		# extract rs
	andi $t2, $t2, 0x0000001f

	sll $t2, $t2, 2
	add $t2, $a2, $t2

	lw $t2, ($t2)

	srl $t3, $a0, 16		# extract rt
	andi $t3, $t3, 0x0000001f

	sll $t3, $t3, 2
	add $t3, $a2, $t3
	
	lw $t3, ($t3)

	beq $t2, $t3, BEQ

	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0 
	j Exit
opcodeBNE:
	srl $t2, $a0, 21		# extract rs
	andi $t2, $t2, 0x0000001f

	sll $t2, $t2, 2
	add $t2, $a2, $t2

	lw $t2, ($t2)

	srl $t3, $a0, 16		# extract rt
	andi $t3, $t3, 0x0000001f

	sll $t3, $t3, 2
	add $t3, $a2, $t3
	
	lw $t3, ($t3)

	bne $t2, $t3, BNE

	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0
	j Exit

opcodeLW:

	srl $t2, $a0, 21		# extract rs (second)
	andi $t2, $t2, 0x0000001f
 
	sll $t2, $t2, 2
	add $t2, $a2, $t2
	lw $t2, ($t2)

	srl $t3, $a0, 16		# extract rt (first)
	andi $t3, $t3, 0x0000001f
	sll $t3, $t3, 2
	add $t3, $a2, $t3

	andi $t4, $a0, 0x0000ffff	# extract immid
		
	srl $t5, $t4, 15
	
	beq $t5, 0x00000001, signExtend2
re1:

	add $t5, $t4, $t2
	andi $t6, $t5, 0x00000003
	bne $t6, 0x00000000, alignmentError		# if address is not multiply by 4, then alignmentError
	slt $t7, $t5, 0					# if size is less than 0
	beq $t7, 1, sizeError				# then size error
	slt $t7, $t0, $t5				# if size is larger than memsize
	beq $t7, 1, hugeError1				# then huge size error
	add $t5, $t5, $a3

		
	lw $t5, ($t5)
	sw $t5, ($t3)
	
	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0 

	j Exit

hugeError1:
	addi $v0, $a1, 0		# increase pc address by 4 and return pc
	addi $v1, $zero, 3		# error = 0 
	j Exit

signExtend2:
	add $t4, $t4, 0xffff0000
	j re1
sizeError:
	addi $v0, $a1, 0		# increase pc address by 4 and return pc
	addi $v1, $zero, 3		# error = 0 
	j Exit
opcodeSW:
	srl $t2, $a0, 21		# extract rs (second)
	andi $t2, $t2, 0x0000001f

	sll $t2, $t2, 2
	add $t2, $a2, $t2
	lw $t2, ($t2)

	srl $t3, $a0, 16		# extract rt (first)
	andi $t3, $t3, 0x0000001f
	sll $t3, $t3, 2
	add $t3, $a2, $t3
	lw $t3, ($t3)
	
	andi $t4, $a0, 0x0000ffff	# extract immid
	
	srl $t5, $t4, 15
	beq $t5, 0x00000001, signExtend1
re:	
	
	add $t5, $t4, $t2
	andi $t6, $t5, 0x00000003
	bne $t6, 0x00000000, alignmentError		# if address is not multiply by 4, then alignmentError
	slt $t7, $t5, 0					# if size is less than 0
	beq $t7, 1, sizeError				# then size error
	slt $t7, $t0, $t5				# if size is larger than memsize
	beq $t7, 1, hugeError1				# then huge size error
	add $t5, $t5, $a3
	
	sw $t3, ($t5)
	
	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0 

	j Exit

alignmentError:
	addi $v0, $a1, 0		# increase pc address by 4 and return pc
	addi $v1, $zero, 2		# error = 0 

	j Exit
signExtend1:
	add $t4, $t4, 0xffff0000
	j re
ADD:
	sll $t2, $t2, 2			# rs = rs * 4
	sll $t3, $t3, 2			# rt = rt * 4
	sll $t4, $t4, 2			# rd = rd * 4

	add $t2, $a2, $t2		# address of second registar
	lw $t2, ($t2)

	
	add $t3, $a2, $t3		# address of third registar
	lw $t3, ($t3)
	
	add $t4, $a2, $t4		# $t4 = start address of reg[] + rd

	add $t5, $t2, $t3		# $t5 = value of second registar + value of third registar
	sw $t5, ($t4)			# copy $t5 into first registar

	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0 

	j Exit
Subtract:
	sll $t2, $t2, 2			# rs = rs * 4
	sll $t3, $t3, 2			# rt = rt * 4
	sll $t4, $t4, 2			# rd = rd * 4

	add $t2, $a2, $t2		# address of second registar
	lw $t2, ($t2)

	
	add $t3, $a2, $t3		# address of third registar
	lw $t3, ($t3)
	
	add $t4, $a2, $t4		# $t4 = start address of reg[] + rd

	sub $t5, $t2, $t3		# $t5 = value of second registar + value of third registar
	sw $t5, ($t4)			# copy $t5 into first registar

	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0 

	j Exit

SLT:
	sll $t2, $t2, 2			# rs = rs * 4
	sll $t3, $t3, 2			# rt = rt * 4
	sll $t4, $t4, 2			# rd = rd * 4

	add $t2, $a2, $t2		# address of second registar
	lw $t2, ($t2)

	add $t3, $a2, $t3		# address of third registar
	lw $t3, ($t3)

	add $t4, $a2, $t4		# $t4 = start address of reg[] + rd

	slt $t5, $t2, $t3		# $t5 = value of second registar + value of third registar
	sw $t5, ($t4)			# copy $t5 into first registar

	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0 

	j Exit
BEQ:
	andi $t4, $a0, 0x0000ffff	# $t4 = offset
	sll $t4, $t4, 2
	andi $t4, $t4, 0x0000ffff
	
	add $t4, $t4, $a1		# $t4 = offset + pc 
	addi $t4, $t4, 4
	andi $t4, $t4, 0x0000ffff
	add $v0, $zero, $t4		# jump to $t4
	addi $v1, $zero, 0
	
	j Exit

BNE:

	andi $t4, $a0, 0x0000ffff	# offset
	sll $t4, $t4, 2
	andi $t4, $t4, 0x0000ffff
	
	add $t4, $t4, $a1		# $t4 = offset + pc
	addi $t4, $t4, 4
	andi $t4, $t4, 0x0000ffff
	add $v0, $zero, $t4		# jump to $t4
	addi $v1, $zero, 0
	
	j Exit
	
ADDIandADDIU:
	
	srl $t2, $a0, 21		# extract rs
	andi $t2, $t2, 0x0000001f

	srl $t3, $a0, 16		# extract rt
	andi $t3, $t3, 0x0000001f

	andi $t4, $a0, 0x0000ffff	# extract 16 bit number (immediate field)	

	srl $t7, $t4, 15
	beq $t7, 0x00000001, signExtend	# make sign extend if $t7 is negative
	j calculateAADIandADDIU

calculateAADIandADDIU:

	sll $t2, $t2, 2			# rs = rs * 4	
	sll $t3, $t3, 2			# rt = rt * 4

	add $t5, $a2, $t2		# address of second register
	lw $t5, ($t5)			# get the value of second register 
	add $t5, $t5, $t4		# $t5 = second register + immediate  		

	add $t6, $a2, $t3		# $t6 = address of rt from reg[]
	sw $t5, ($t6)			# store sum of rs and immediate into rt

	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0 	
	j Exit

signExtend:
	add $t4, $t4, 0xffff0000
	j calculateAADIandADDIU

printString:
	addi $t3, $a2, 16
	lw $t3, ($t3)

	addi $v0, $zero, 4
	add $a0, $a3, $t3
	syscall

	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0
	j Exit
SyscallPrepare:

	addi $t7, $a2, 8		# address of v0
	lw $t7, ($t7)			# get value of v0
 
	beq $t7, 10, Terminate		# if v0 is 10, then do terminate
	beq $t7, 4, printString

	addi $t3, $a2, 16		# address of $a0
	lw $t3, ($t3)

	add $v0, $zero, $t7
	addi $a0, $t3, 0
	syscall

	addi $v0, $a1, 4		# increase pc address by 4 and return pc
	addi $v1, $zero, 0		# error = 0

	j Exit

Terminate:
	addi $v0, $a1, 0
	addi $v1, $zero, -1
	j Exit

Exit:
	# Start by creating the "standard" stack
	lw	$a3, 20($sp)
	lw	$a2, 16($sp)
	lw	$a1, 12($sp)
	lw	$a0, 8($sp)
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 28
	jr      $ra
	