######################
#Author: Austin Crapo
#Date: June 2017
#
#A demo meant to show off GLIM's basic functions
######################
.data
char:
	.asciiz " "	#stores 2 bytes, second is 0x00 so we can alter the first when we want
printList:
	.align 2
	.space 24	#4*3*2 bytes because only using 1 job at a time
.text
main:
#############
# update: used to track game updates
# action: used to track action requests
#############
	# Stack Adjustments
	addi	$sp, $sp, -4		# Adjust the stack to save $fp
	sw	$fp, 0($sp)		# Save $fp
	add	$fp, $zero, $sp		# $fp <= $sp
	addi	$sp, $sp, -24		# Adjust stack to save variables
	sw	$ra, -4($fp)		# Save $ra
	sw	$s0, -8($fp)		
	sw	$s1, -12($fp)
	sw	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw	$s3, -24($fp)
	
	li	$a0, 30
	li	$a1, 60
	jal	startGLIM
	
	#This section shows off batch printing. It prints a single job at
	#a time, but in theory you could add all the jobs to the list
	#at once and have all of them print at the same time. It's slowed
	#here so you have a chance to see it
	
	li	$s0, 0	#row
	li	$s1, 0	#col
	li	$s2, 0	#fgcolor, valid colors are between 0 and 255
	li	$s4, 100	#bgcolor, valid colors are between 0 and 255
	li	$s3, 0x20	#char, printable chars are between 0x20 and 0x7e
	loop:
	beq	$s0, 20, lend
		la	$a0, printList	#create a print job by adding to the list
		sh	$s0, 0($a0)		# halfword row
		sh	$s1, 2($a0)		# halfword col
		sh	$s1, 2($a0)		# halfword col
		li	$t0, 4
		sb	$t0, 4($a0)		# print code 4 (both forground and background colors)
		sb	$s2, 5($a0)		# forground color
		sb	$s3, 6($a0)		# background color
		#7th byte is empty
		la	$t0, char
		sb	$s3, 0($t0)		# update the char string 
		sw	$t0, 8($a0)		# then provide it to the job
		li	$t0, 0xFFFF
		sh	$t0, 12($a0)	#terminate the job list
		jal	batchPrint
		
		li	$a0, 1		#wait 0.001 seconds
		jal	sleep
		
		addi	$s3, $s3, 1		#goto next bgcolor
		li	$t0, 255
		bne	$s3, $t0, lfgColor
			li	$s3, 0
		lfgColor:
		addi	$s2, $s2, 1		#goto next fgcolor
		li	$t0, 255
		bne	$s2, $t0, lchar
			li	$s2, 0
		lchar:
		addi	$s3, $s3, 1		#goto next char
		li	$t0, 0x7e
		bne	$s3, $t0, lcont
			li	$s3, 0x20
			
			
		lcont:
		addi 	$s1, $s1, 1
		li	$t0, 60
		bne	$s1, $t0, loop
		li	$s1, 0
		addi	$s0, $s0, 1
		j	loop
	lend:
	
	#wait
	li	$a0, 1000
	jal	sleep
	
	#then carve out a message
	#This section shows off printString, just simply printing the
	#string we want directly to a location using the current settings
	jal	restoreSettings		#restore default color settings
						#since they probably are messed up from
						#the earlier demo
	
	
	#The goal is to print
	#	@  @ @@@@   @
	#	@  @  @@    @
	#	@@@@  @@    @
	#	@  @  @@    
	#	@  @ @@@@   @
	#	
	la	$a0, char
	li	$t1, 0x20	#print using spaces (it's black background white text)
	sw	$t1, 0($a0)
	#We're going to be hacky to save space. printString doesn't overwrite $a0
	#so lets not redefine it between calls.
	li	$a1, 0
	li	$a2, 4
	jal	printString
	li	$a1, 1
	li	$a2, 4
	jal	printString
	li	$a1, 2
	li	$a2, 4
	jal	printString
	li	$a1, 3
	li	$a2, 4
	jal	printString
	li	$a1, 4
	li	$a2, 4
	jal	printString
	li	$a1, 2
	li	$a2, 5
	jal	printString
	li	$a1, 2
	li	$a2, 6
	jal	printString
	li	$a1, 0
	li	$a2, 7
	jal	printString
	li	$a1, 1
	li	$a2, 7
	jal	printString
	li	$a1, 2
	li	$a2, 7
	jal	printString
	li	$a1, 3
	li	$a2, 7
	jal	printString
	li	$a1, 4
	li	$a2, 7
	jal	printString		#done printing H
	
	li	$a0, 500
	jal	sleep
	
	la	$a0, char
	li	$a1, 0
	li	$a2, 9
	jal	printString
	li	$a1, 4
	li	$a2, 9
	jal	printString

	li	$a1, 0
	li	$a2, 10
	jal	printString
	li	$a1, 1
	li	$a2, 10
	jal	printString
	li	$a1, 2
	li	$a2, 10
	jal	printString
	li	$a1, 3
	li	$a2, 10
	jal	printString
	li	$a1, 4
	li	$a2, 10
	jal	printString
	li	$a1, 0
	li	$a2, 11
	jal	printString
	li	$a1, 1
	li	$a2, 11
	jal	printString
	li	$a1, 2
	li	$a2, 11
	jal	printString
	li	$a1, 3
	li	$a2, 11
	jal	printString
	li	$a1, 4
	li	$a2, 11
	jal	printString
	
	li	$a1, 0
	li	$a2, 12
	jal	printString
	li	$a1, 4
	li	$a2, 12
	jal	printString		#done printing "I"
	
	li	$a0, 500
	jal	sleep
	
	la	$a0, char
	li	$a1, 0
	li	$a2, 15
	jal	printString
	li	$a1, 1
	li	$a2, 15
	jal	printString
	li	$a1, 2
	li	$a2, 15
	jal	printString
	li	$a1, 4
	li	$a2, 15
	jal	printString		#done printing "!"
	
	li	$a0, 1000
	jal	sleep
	
	
	
	#Print circles! 2 pixels wide, and only 3 on screen at a time
	li	$a0, 15
	li	$a1, 30
	li	$a2, 0
	li	$a3, 0x00130003	#REMEMBER this is little endian so now it's [empty] [bgcolor] [fgcolor] [printing code]
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 1
	li	$a3, 0x00130003
	jal	printCircle
	
	li	$a0, 1000
	jal	sleep
	
	li	$a0, 15
	li	$a1, 30
	li	$a2, 0
	li	$a3, 0x00120003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 1
	li	$a3, 0x00120003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 2
	li	$a3, 0x00130003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 3
	li	$a3, 0x00130003
	jal	printCircle
	
	li	$a0, 1000
	jal	sleep
	
	li	$a0, 15
	li	$a1, 30
	li	$a2, 0
	li	$a3, 0x00110003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 1
	li	$a3, 0x00110003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 2
	li	$a3, 0x00120003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 3
	li	$a3, 0x00120003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 4
	li	$a3, 0x00130003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 5
	li	$a3, 0x00130003
	jal	printCircle
	
	li	$a0, 1000
	jal	sleep
	
	li	$a0, 15
	li	$a1, 30
	li	$a2, 0
	li	$a3, 0x00100003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 1
	li	$a3, 0x00100003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 2
	li	$a3, 0x00110003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 3
	li	$a3, 0x00110003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 4
	li	$a3, 0x00120003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 5
	li	$a3, 0x00120003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 6
	li	$a3, 0x00130003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	li	$a2, 7
	li	$a3, 0x00130003
	jal	printCircle
	
	li	$a0, 1000
	jal	sleep
	
	li	$s0, 2	#radius = 2 (0 and 1 already covered)
	li	$s1, 0	#counter = 0
	li	$s3, 15	#max = 30
	
	mainCircleLoop:
	beq	$s1, $s3, mCLend
	
	li	$a0, 15
	li	$a1, 30
	add	$a2, $s0, $s1
	li	$a3, 0x00100003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	add	$a2, $s0, $s1
	addi	$a2, $a2, 1
	li	$a3, 0x00100003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	add	$a2, $s0, $s1
	addi	$a2, $a2, 2
	li	$a3, 0x00110003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	add	$a2, $s0, $s1
	addi	$a2, $a2, 3
	li	$a3, 0x00110003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	add	$a2, $s0, $s1
	addi	$a2, $a2, 4
	li	$a3, 0x00120003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	add	$a2, $s0, $s1
	addi	$a2, $a2, 5
	li	$a3, 0x00120003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	add	$a2, $s0, $s1
	addi	$a2, $a2, 6
	li	$a3, 0x00130003
	jal	printCircle
	li	$a0, 15
	li	$a1, 30
	add	$a2, $s0, $s1
	addi	$a2, $a2, 7
	li	$a3, 0x00130003
	jal	printCircle
	
	li	$a0, 1000
	jal	sleep
	
	addi	$s0, $s0, 1
	addi	$s1, $s1, 1
	j	mainCircleLoop
	
	mCLend:
	
	jal	restoreSettings
	jal	clearScreen
	li	$a0, 1000
	jal	sleep
	
	
	mainEnd:
	
	#MUST BE CALLED BEFORE ENDING PROGRAM
	jal	endGLIM
	
	#Stack Restore
	lw	$ra, -4($fp)
	lw	$s0, -8($fp)
	lw	$s1, -12($fp)
	lw	$s2, -16($fp)
	lw	$s3, -20($fp)
	lw	$s4, -24($fp)
	addi	$sp, $sp, 24
	lw	$fp, 0($sp)
	addi	$sp, $sp, 4
	
	jr	$ra
	
	
	
sleep:
	#############################################
	# Waits the specified number of milliseconds by doing nothing
	# $a0 = the number of seconds to sleep
	#############################################
	wSoutLoop:
	beq	$a0, $zero, wSoLend
		addi	$a0, $a0, -1
		li	$t0, 185
		wSloop:
		beq	$t0, $zero, wSlend
			nop
			addi	$t0, $t0, -1
			j	wSloop
		wSlend:
		j	wSoutLoop
	wSoLend:
	jr	$ra