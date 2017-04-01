.data
Array: .word 9, 2, 8, 1, 6, 5, 4, 10, 3, 7 # you can change the element of array

.text
main:
	addi 	$t0, $zero, 4097	# $t0 = 0x00001001
	sll 	$t0, $t0, 16		# set the base address of your array into $t0 = 0x10010000

countLengthOfArray:
	sll		$t6, $t6, 2
	add		$t7, $t0, $t6
	srl		$t6, $t6, 2
	addi 	$t6, $t6, 1
	lw		$t8, 0($t7)
	addi	$s0, $s0, 1			# if element != 0 then $s0 += 1
	bne 	$t8, $zero, countLengthOfArray
	addi	$s0, $s0, -1		# $s0 = end condition, $s0 = length of Array

loop1:
	beq		$t1, $s0, exit		# loop when i from 0 to 9
	add 	$t2, $t1, $zero		# j = i
	addi 	$t1, $t1, 1			# i++
	j		loop2				# run loop2

loop2:
	beq		$t2, $zero, loop1	# loop when j > 0
	sll		$t2, $t2, 2			# j *= 4, use j to create address of Array[j]
	add 	$t3, $t0, $t2		# $t3 = pointer to Array[j]
	addi 	$t4, $t3, -4		# $t4 = pointer to Array[j-1]
	srl		$t2, $t2, 2			# j /= 4, recover j
	addi 	$t2, $t2, -1		# j--
	lw		$t8, 0($t4)			# Array[j-1]
	lw		$t9, 0($t3)			# Array[j]
	slt		$t5, $t8, $t9		# $t5 = (Array[j-1] < Array[j])? 1: 0
	bne		$t5, $zero, loop2	# if Array[j-1] < Array[j] ($t5 == 1)then continue loop2
	sw		$t8, 0($t3)			# if Array[j-1] > Array[j] ($t5 == 0)then swap
	sw		$t9, 0($t4)
	j		loop2				# continue loop2

exit:
	li   $v0, 10               # program stop
	syscall
