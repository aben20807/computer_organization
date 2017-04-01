.data
Array: .word 9, 2, 8, 1, 6, 5, 4, 10, 3, 7 # you can change the element of array

.text
main:
	addi 	$t0, $zero, 4097	# $t0 = 0x00001001
	sll 	$t0, $t0, 16		# set the base address of your array into $t0 = 0x10010000
	addi	$s0, $zero, 10

loop1:
	beq		$t1, $s0, exit		# loop when i from 0 to 9
	add 	$t2, $t1, $zero		# j = i
	addi 	$t1, $t1, 1			# i++
	j		loop2

loop2:
	beq		$t2, $zero, loop1	# loop when j > 0
	sll		$t2, $t2, 2
	add 	$t3, $t0, $t2		# $t3 = pointer to Array[j]
	addi 	$t4, $t3, -4		# $t4 = pointer to Array[j-1]
	srl		$t2, $t2, 2
	addi 	$t2, $t2, -1		# j--
	lw		$t8, 0($t4)			# Array[j-1]
	lw		$t9, 0($t3)			# Array[j]
	slt		$t5, $t8, $t9		# $t5 = ($t8 < $t9)? 1: 0
	bne		$t5, $zero, loop2	# if Array[j-1] > Array[j] then swap
	addi	$sp, $sp, -32		# reserve(backup) a, t, ra
	sw		$a0, 0($sp)
	sw		$a1, 4($sp)
	sw		$t0, 8($sp)
	sw		$t1, 12($sp)
	sw		$t2, 16($sp)
	sw		$t3, 20($sp)
	sw		$t4, 24($sp)
	sw		$ra, 28($sp)
	add		$a0, $t3, $zero		# pass parameters
	add		$a1, $t4, $zero
	jal		swap				# call procedure
	lw		$a0, 0($sp)			# restore a, t, ra
	lw		$a1, 4($sp)
	lw		$t0, 8($sp)
	lw		$t1, 12($sp)
	lw		$t2, 16($sp)
	lw		$t3, 20($sp)
	lw		$t4, 24($sp)
	lw		$ra, 28($sp)
	addi	$sp, $sp, 32
	j		loop2

exit:
	li   $v0, 10               # program stop
	syscall

swap:
	lw		$t0, 0($a0)
	lw		$t1, 0($a1)
	sw		$t1, 0($a0)
	sw		$t0, 0($a1)
	jr		$ra



	#--------------------------------------#
	#  \^o^/   Write your code here~  \^o^/#
	#--------------------------------------#
