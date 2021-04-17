.data

#for menu
	welcome_text:	.asciiz "Welcome to our MIPS project!"
	menu_text:	.asciiz "\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\nPlease select an option: "
	exit_text:	.asciiz "\nProgram ends. Bye :)\n"
	default_text:	.asciiz "\nPlease enter a valid option.\n"
	
#for question 1
	text1:		.asciiz "Enter the String: "
	outtext1:	.asciiz "Character\tOccurrence\n"
	bufferq1:	.space 1024
	bufferNumberq1:	.word 0:26	# This array includes 26 integer zeros as [0, ..., 0]
	newLineq1:	.asciiz "\n"
	spaceq1:	.asciiz " "
	tab:		.asciiz "\t"

#for question 2
	text2:		.asciiz "Input: "
	outtext2: 	.asciiz "Output: "
	bufferq2:	.space 1024
	bufferNumberq2:	.space 104
	newLineq2:	.asciiz "\n"
	minusSignq2:	.asciiz "-"
	spaceq2:	.asciiz " "

#for question 3
	text3:		.asciiz "Please enter an integer number for num_prime(N):\n"
	outprompt1:	.asciiz "prime("
	outprompt2:	.asciiz ") is "
	dot:		.asciiz "."

#for question 4
	text4:	.asciiz "This part is not available, sorry. :(\n"

.text
.globl main

#coding part
main:
    li $v0, 4
    la $a0, welcome_text
    syscall

	while:
		#printing the menu
		li $v0, 4
		la $a0, menu_text
		syscall
		
		#getting input from user
		li $v0, 5
		syscall
		move $t0, $v0
	
		#case statements
		case_1: bne $t0, 1, case_2
				jal q1		# go to q1
				j while
        
        	case_2: bne $t0, 2, case_3
				jal q2		# go to q2
				j while
        
        	case_3: bne $t0, 3, case_4
				jal q3		# go to q3
				j while
		
		case_4: bne $t0, 4, case_5
				jal q4    	# go to q4			
    				j while
        
        	case_5: bne $t0, 5, default
				#checks whether the user's choise is 5
				beq $t0, 5, exit

        	default: 
				li $v0, 4
				la $a0, default_text
				syscall
				j while

	exit:
		li $v0, 4           
		la $a0, exit_text
		syscall		#prints bye
		
		li $v0, 10
		syscall     #ending program


q1:
	# Print message to the user
	li $v0, 4
	la $a0, text1
	syscall
		
	# Initialize arrays into registers
	la $t0, bufferq1
	la $t1, bufferNumberq1
	add $s4, $t1, $zero
		
	# Initialize newline char into a register
	la $t7, newLineq1
	lb $t7, 0($t7)
		
	# Take the user input string to the array
	li $v0, 8
	la $a0, bufferq1
	li $a1, 1024
	syscall
		
	whileq1:# This loop calculates the occurrence of the letters of the user input string.
		lb $t2, 0($t0)
		add $t0, $t0, 1
		
		beq $t2, $t7, outwhileq1
		
		# This if condition determines the character whether uppercase or not.
		sge $t3, $t2, 65
		sle $t4, $t2, 90
		and $t3, $t3, $t4
		beq $t3, $zero, elseif
		
		# Make uppercase letter -> lowercase letter
		addi $t2, $t2, 32
		
		j outif
		
	elseif:	
		# If first if condition is false, then this elseif condition determines the character whether lowercase or not.
		sge $t3, $t2, 97
		sle $t4, $t2, 122
		and $t3, $t3, $t4
		beq $t3, $zero, whileq1
		
	outif:	
		# Adding character's occurrence into the integer array.
		addi $t2, $t2, -97
		sll $t2, $t2, 2
		add $t2, $t1, $t2
		lw $t5, 0($t2)
		addi $t5, $t5, 1
		sw $t5, 0($t2)
		
		j whileq1
		
	outwhileq1:
		# Initializing two registers an occurrence limit to print large number to small number and a base character as 'a' = 97.
		addi $s3, $zero, 1000
		add $t8, $zero, 97
		
		li $v0, 4
    		la $a0, outtext1
    		syscall
		
	while2q1: # This nested loops perform printing the occurrences larger to smaller way.
		beq $s3, 0, outwhile2q1
		addi $s3, $s3, -1
		addi $s0, $zero, 0
		la $t1, bufferNumberq1
	
	nestedloop:	
		beq $s0, 26, while2q1
		lw $t2, 0($t1)
		addi $t1, $t1, 4
		addi $s0, $s0, 1
		beq $t2, $zero, nestedloop
		bne $t2, $s3, nestedloop
		
		addi $s1, $s0, -1
		
		# Print character
		add $t9, $t8, $s1
		li $v0, 11
		move $a0, $t9
		syscall
		
		# Print tab
		li $v0, 4
		la $a0, tab
		syscall
		
		# Print tab
		li $v0, 4
		la $a0, tab
		syscall
		
		# Print occurrence
		li $v0, 1
		move $a0, $t2
		syscall
		
		# Print newline
		li $v0, 4
		la $a0, newLineq1
		syscall
		
		j nestedloop
	
	outwhile2q1:
		addi $s0, $zero, 0
		
	makeemptoccurs:	# This loop performs making the occurrence array's elements all 0s due to reutilizing
		beq $s0, 26, endq1
		sw $zero, 0($s4)
		addi $s4, $s4, 4
		addi $s0, $s0, 1
		
		j makeemptoccurs
		
	endq1:
		jr $ra

q2:
	# Print message to the user
	li $v0, 4
	la $a0, text2
	syscall
		
	# Initialize arrays into registers
	la $t0, bufferq2
	la $t1, bufferNumberq2
		
	# Initialize some characters into registers
	la $t5, newLineq2
	lb $t5, 0($t5)
	la $t6, minusSignq2
	lb $t6, 0($t6)
	la $t7, spaceq2
	lb $t7, 0($t7)
		
	# Take the user input to the array
	li $v0, 8
	la $a0, bufferq2
	li $a1, 1024
	syscall
		
	# Adding newline character to the stack pointer register to control the stack pointer's ending
	addi $sp, $sp, -1
	sb $t5, 0($sp)
		
	# Initializing a register with 0 value to count the number of integers in the user input and copying the array's address into a register
	addi $s2, $zero, 0
	add $t3, $t1, $zero
	
	while1:	# This loop performs storing each character of the user input into the stack.
		lb $t2, 0($t0)
		add $t0, $t0, 1
		
		beq $t2, $t5, do
		
		seq $s3, $t2, $t7
		
		addi $sp, $sp, -1
		sb $t2, 0($sp)
		
		j while1
	
	do:	# This is the beginning of do-while loop and here, do part performs initializing a digit value into a register and a number calculater register
		addi $s0, $zero, 1
		addi $s1, $zero, 0
	
	while2:	# While part performs calculating each integer in the string whether it is negative or positive and store into a new array.
		lb $t2, 0($sp)
		addi $sp, $sp, 1
		
		beq $t2, $t5, outdowhile
		beq $t2, $t6, makeneg
		beq $t2, $t7, store
		
		add $t4, $t2, -48
		mul $t2, $s0, $t4
		add $s1, $s1, $t2
		mul $s0, $s0, 10
		
		j while2
	
	makeneg:# If the number has a minus sign, here, the number will be negative.
		sub $s1, $zero, $s1
		
		j while2
	
	store:	# Each integer in the user input is stored here.
		sb $s1, 0($t3)
		addi $t3, $t3, 4
		addi $s2, $s2, 1
		
		j do
	
	outdowhile:# Here, outside of the do-while part performs storing last integer of the user input, copying the array's address into a register again and initializing a counter to control the next for loop's count.
		sb $s1, 0($t3)
		addi $s2, $s2, 1
		
		add $s4, $t1, $zero
		addi $s3, $zero, 0
		
		la $a0, bufferNumberq2
		li $t1, 0	# lenght = t1 = 0
		li $t0, -1	# initial i value
			
	# Beginning of the Bubble Sorting
	Calculate_Lenght:
        	lb $t2, 0($a0)
        	beq $t2, $0, outer
        	addi $t1, $t1, 1
        	addi $a0, $a0, 4
		
		j   Calculate_Lenght
		
	outer:
		add	$t0,$t0,1
		bge	$t0,$t1,outsort
		
		sub	$t4,$t1,$t0
		sub	$t4,$t4,1	# t4 = n-i-1
		li	$t3,-1		# j
	
		j	inner
	
	inner:
		add	$t3,$t3,1 	# t3 = j
		bge	$t3,$t4,outer
	
		mul	$t5,$t3,4
	
		add	$a2,$t5,4	# a2 = arr[j+1]
	
		lb	$t9,bufferNumberq2($a2) # t9 = arr[j+1]
		lb	$t6,bufferNumberq2($t5) # t6 = arr[j]
		
		bgt	$t6,$t9,swap_procedure
		
		j	inner
		
	swap_procedure:
		add	$t7,$t9,0
		add	$t8,$t6,0
	
		add	$t6,$t7,0
		add	$t9,$t8,0
	
		sb	$t9,bufferNumberq2($a2)
		sb	$t6,bufferNumberq2($t5)
	
		j	inner
	
	jmp_outer:
		la	$a0,bufferNumberq2	
		j	outer
	
	outsort:
		# Print message to the user
		li $v0, 4
		la $a0, outtext2
		syscall
		
	for:	# This loop performs printing the integers smaller to larger way.
		beq $s3, $s2, endq2
		lb $t2, 0($s4)
		addi $s4, $s4, 4
		addi $s3, $s3, 1
		
		# Print each integer
		li $v0, 1
		move $a0, $t2
		syscall
		
		# Print a space between each integer
		li $v0, 4
		la $a0, spaceq2
		syscall
		
		j for
		
	endq2:
		jr $ra
	
q3:
	addi 	$s1,$zero,1
	addi	$t2,$zero,1
	addi	$t0,$zero,0 # set counter variable to 2
	addi 	$a2, $zero, 0
	
	# Print message to the user
	li $v0, 4
	la $a0, text3
	syscall
	
	li $v0,	5
	syscall		#read integer
	move $s5, $v0
	
	addi $s2, $sp, 0	# backup bottom of stack address in $s2
	add $t4, $s5, $zero	# find prime numbers from 2 to $t4 (entry)w

	init:	
		sw	$s1, ($sp)	# write ones to the stackpointer's address
		addi	$t0, $t0, 1	# increment counter variable
		addi	$sp, $sp, -4	# subtract 4 bytes from stackpointer (push) (allocating memory for the stack)
		ble	$t0, $t4, init	# take loop while $t0 <= $t4 ##we are creating 4*5 empty place in the stack. (loop runs 4 times.) and writing ones to stack
	
		li	$t0, 1		# reset counter variable to 2 #WE WILL USE T0 as a counter everytime.

	outerq3:	
		add	$t0,$t0,1
		
		mul	$t5,$t0,$t0
		add	$t8,$t5,0 ##p*p=t8.(i	)
		
		li	$a3,0
		
		mul	$t9,$t0,$t0
		bgt	$t9,$t4,count #(goes to counting)
		
		mul	$t1,$t0,4
		sub 	$t3,$s2,$t1
		lw	$s3,($t3)
	
	
		beq	$s3,1,innerq3
	
		j	outerq3
	
	innerq3:	
		add	$t8,$t8,$a3
	
		addi	$t6,$t4,1
		bge	$t8, $t6, outerq3	# calculate the number of bytes to jump over	
		
		mul	$t9,$t8,4
		sub	$s3,$s2,$t9
		li	$s4,0
		sw	$s4,($s3)
	
		add	$a3,$t0,0
		j	innerq3
	
	count:	
		add	$t2,$t2,1	#p=2
	
		add	$t7,$t4,1	#t7=n+1
		bgt	$t2,$t7,print_number	#if p>t7, exit.
	
		mul	$v1,$t2,4	#t7=4*t2
		sub	$s6,$s2,$v1	#s6=s2-t7
		lw	$s7,($s6)		#s7=stack[s6]
	
		add	$a1,$t2,0
		beq	$s7,1,count_number
	
		j	count

	count_number:
		addi $a2, $a2, 1
	
		j count
	
	print_number:
		li $v0, 4
		la $a0, outprompt1
		syscall
	
		li $v0, 1
		move $a0, $s5
		syscall
	
		li $v0, 4
		la $a0, outprompt2
		syscall
	
		li $v0, 1
		move $a0, $a2
		syscall
	
		li $v0, 4
		la $a0, dot
		syscall
	
		jr $ra

q4:
	li $v0, 4
    	la $a0, text4
    	syscall
    	jr $ra
