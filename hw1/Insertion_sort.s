.data
Array: .word 9, 2, 8, 1, 6, 5, 4, 10, 3, 7 # you can change the element of array

.text
main:
	addi    $t0, $zero, 4097	# $t0 = 0x00001001
	sll     $t0, $t0, 16		# set the base address of your array into $t0 = 0x10010000

loop1:
	sll     $t1, $t1, 2			# $t1 = index i from 0 to length of Array, i *= 4 to create address of Array[i]
	add     $t6, $t0, $t1		# $t6 = address of Array[i]
	lw      $t7, 0($t6)			# $t7 = Array[i]
	beq     $t7, $zero, exit	# if Array[i] == 0 then exit
	srl     $t1, $t1, 2			# i /= 4 to recover i
	add     $t2, $t1, $zero		# j = i
	addi    $t1, $t1, 1			# i++
	j       loop2				# run loop2

loop2:
	beq     $t2, $zero, loop1	# loop when j > 0
	sll     $t2, $t2, 2			# j *= 4 to create address of Array[j]
	add     $t3, $t0, $t2		# $t3 = address of Array[j]
	addi    $t4, $t3, -4		# $t4 = address of Array[j-1]
	srl     $t2, $t2, 2			# j /= 4, recover j
	addi    $t2, $t2, -1		# j--
	lw      $t8, 0($t4)			# $t8 = Array[j-1]
	lw      $t9, 0($t3)			# $t9 = Array[j]
	slt     $t5, $t8, $t9		# if(Array[j-1] < Array[j]) $t5 = 1, else $t5 = 0
	bne     $t5, $zero, loop2	# if(Array[j-1] < Array[j]) ($t5 == 1) then no need to swap so continue loop2
	sw      $t8, 0($t3)			# swap if Array[j-1] > Array[j] ($t5 == 0)
	sw      $t9, 0($t4)			# swap
	j       loop2				# continue loop2

exit:
	li      $v0, 10               # program stop
	syscall
