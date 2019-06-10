
.data

val1:	.word	-100
val2:	.word	-50

init_regs:
	.word	0xdeadbeef
	.word	0xc0d4f00d
	.word	0x01010101
	.word	0xF0F0F0F0
	.word	0x12345678
	.word	0
	.word	-1
	.word	init_regs

sp_save:	.word   0    # will be *WRITTEN TO*
fp_save:        .word   0    # will be *WRITTEN TO*



.text

main:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# preload every s register with a value, to confirm that the student
	# code preserved it.
	#
	# UPDATE: Don't do this to s0 or s1, since we'll use them as loop
	# variables below!
	la      $t0, init_regs     # t0 = &init_regs[0]
   #	lw      $s0,  0($t0)       # s0 =  init_regs[0]
   #	lw      $s1,  4($t0)       # s1 =  init_regs[1]
	lw      $s2,  8($t0)       # s2 =  init_regs[2]
	lw      $s3, 12($t0)       # s3 =  init_regs[3]
	lw      $s4, 16($t0)       # s4 =  init_regs[4]
	lw      $s5, 20($t0)       # s5 =  init_regs[5]
	lw      $s6, 24($t0)       # s6 =  init_regs[6]
	lw      $s7, 28($t0)       # s7 =  init_regs[7]

	# save the current $sp and $fp for later comparison
	la      $t0, sp_save       # t0 = &sp_save
	sw      $sp, 0($t0)        # sp_save = $sp
	la      $t0, fp_save       # t0 = &fp_save
	sw      $fp, 0($t0)        # fp_save = $fp


	# load val1,val2 into s registers
	la      $s0, val1
	lw      $s0, 0($s0)
	la      $s1, val2
	lw      $s1, 0($s1)

main_LOOP:
	# call multiply(s0, s1)
	add     $a0, $s0, $zero
	add     $a1, $s1, $zero
	jal     multiply

	# save the return value for later comparison.
	add     $t0, $v0, $zero

	# print out the return value
	add     $a0, $v0, $zero
	addi    $v0, $zero, 1
	syscall

	# print_char('\n')
	addi    $v0, $zero, 11     # print_char
	addi    $a0, $zero, 0xa    # ASCII '\n'
	syscall

	# loop back if he product was kind of small.
	addi    $s0, $s0, 1
	addi    $s1, $s1, 1
	slti    $t1, $t0, 10000
	bne     $t1, $zero, main_LOOP


	# do comparison of all of the registers
	la      $t0, init_regs     # we'll use this base over and over

   #	lw      $t1,  0($t0)
   #	beq     $t1, $s0, main_DO_COMPARE_1

	# if we get here, then we had a MISCOMPARE on s0.  We need to report
	# it.
   #	addi	$a0, $zero, 0
   #	add 	$a1, $t1, $zero
   #	add 	$a2, $s0, $zero
   #	jal     reportMismatch

	# after we call the reporting function, we have to restore the $t1
	# variable, which might not be valid anymore.
   #	la      $t0, init_regs

	# NOTE: From here on, we'll not comment; we'll just do the same thing
	#       over and over, once for each s register.

main_DO_COMPARE_1:
   #	lw      $t1,  4($t0)
   #	beq     $t1, $s1, main_DO_COMPARE_2

   #	addi	$a0, $zero, 1
   #	add 	$a1, $t1, $zero
   #	add 	$a2, $s1, $zero
   #	jal     reportMismatch

   #	la      $t0, init_regs

main_DO_COMPARE_2:
	lw      $t1,  8($t0)
	beq     $t1, $s2, main_DO_COMPARE_3

	addi	$a0, $zero, 2
	add 	$a1, $t1, $zero
	add 	$a2, $s2, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_3:
	lw      $t1, 12($t0)
	beq     $t1, $s3, main_DO_COMPARE_4

	addi	$a0, $zero, 3
	add 	$a1, $t1, $zero
	add 	$a2, $s3, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_4:
	lw      $t1, 16($t0)
	beq     $t1, $s4, main_DO_COMPARE_5

	addi	$a0, $zero, 4
	add 	$a1, $t1, $zero
	add 	$a2, $s4, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_5:
	lw      $t1, 20($t0)
	beq     $t1, $s5, main_DO_COMPARE_6

	addi	$a0, $zero, 5
	add 	$a1, $t1, $zero
	add 	$a2, $s5, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_6:
	lw      $t1, 24($t0)
	beq     $t1, $s6, main_DO_COMPARE_7

	addi	$a0, $zero, 6
	add 	$a1, $t1, $zero
	add 	$a2, $s6, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_7:
	lw      $t1, 28($t0)
	beq     $t1, $s7, main_COMPARISONS_DONE

	addi	$a0, $zero, 7
	add 	$a1, $t1, $zero
	add 	$a2, $s7, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_COMPARISONS_DONE:

main_DONE:
	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



.data

mismatch_str1:	.asciiz "MISMATCH: register s"
mismatch_str2:	.asciiz                   " was not saved during a function call.  Orig value: "
mismatch_str3:	.asciiz " after the call: "

.text

reportMismatch:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20

	# save the three parameters.  We do this because we make heavy use of
	# syscalls in this function.
	sw      $a0,  8($sp)
	sw      $a1, 12($sp)
	sw      $a2, 16($sp)


	# print the leading part of the string...
	addi    $v0, $zero, 4        # print_str
	la	$a0, mismatch_str1
	syscall

	# register number - essentially this is %d
	addi    $v0, $zero, 1        # print_int
	lw      $a0, 8($sp)
	syscall

	# print the second part of the string...
	addi    $v0, $zero, 4        # print_str
	la	$a0, mismatch_str2
	syscall

	# original value - again, this is %d
	addi    $v0, $zero, 1        # print_int
	lw      $a0, 12($sp)
	syscall

	# print the second part of the string...
	addi    $v0, $zero, 4        # print_str
	la	$a0, mismatch_str3
	syscall

	# actual value - again, this is %d
	addi    $v0, $zero, 1        # print_int
	lw      $a0, 16($sp)
	syscall

	# ending newline
	addi    $v0, $zero, 11       # print_char
	addi    $a0, $zero, 0xa      # ASCII '\n'
	syscall


	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



.data
printStr_msg:
	.asciiz	"This message only exists to make sure that you don't hard code the output.  Call printStr() instead!\n"

.text
printStr:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# print_str(a0)
	addi 	$v0, $zero, 4
	syscall

	# print_char('\n')
	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa
	syscall

	# print_str(msg)
	addi    $v0, $zero, 4
	la      $a0, printStr_msg
	syscall


	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



.data
printNibble_msg:
	.asciiz " is the value at nibble "

.text
printNibble:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20

	# save a0, a1
	sw      $a0,  8($sp)
	sw      $a1, 12($sp)


	# printf("%d is the value at nibble %d\n", a1, a0);

	add     $a0, $a1, $zero     # print_int(a1)
	addi    $v0, $zero, 1
	syscall

	addi    $v0, $zero, 4       # print_string
	la      $a0, printNibble_msg
	syscall

	addi 	$v0, $zero, 1       # print_int
	lw      $a0, 8($sp)         # print_int(1st arg)
	syscall

	addi    $v0, $zero, 11      # print_char
	addi    $a0, $zero, 0xa     # ASCII '\n'
	syscall


	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra


