#########################################################################
########################################################################
#######################################################################

# The code begins from here

.data
    prompt: .asciiz "Enter the number of disks "
    movee:  .asciiz "\n move disk from "
    to: .asciiz "To" 
.text
.ent main
.globl main
main:
    #taking input from the user
    li $v0 , 4  
    la $a0 , prompt
    syscall
    #storing that input into a reg $a0
    li $v0 , 5
    syscall
    add $a0 , $v0 , $0 

    addi	$a1, $0, 1   #temp value store to be stored
    addi	$a2, $0, 3   #temp value store to be stored
    addi	$a3, $0, 2  #temp value store  to be stored

    jal		hanoi				# jump to hanoi and save position to $ra

    jr		$ra					# jump to $ra
    
################################################################################
##########################################################################
###########################################################################
hanoi:
    addi $t0 , $a0 , 0    #user's input has been placed from $a0 to $t0
    addi $t1 , $0 , 1
    bne $a0 , $t1 , target    #if user enters 1 then then will not go into else part
    li $v0 , 4  
    la $a0 , movee           #printing the statement of move
    syscall

    li $v0 , 1
    move $a0 , $a1     #printing 1
    syscall

    li $v0, 4			# print to
    la $a0, to
    syscall

    li $v0 , 1
    move $a0, $a2   #user had entered 1 so the disk has moved only once

    addi $a0 , $t0, 0    #restoring the value of $a0

##################################################################################
###################################################################################
##########################################################################

else:           #now the else part starts if the user has entered more than 1 value as input

    addi $sp , $sp , -20    # emptying the stack now 

    sw	$ra, 16($sp)	# address of $ra reg	 
    sw	$a3, 12($sp)	#here comes the last disk that is C
    sw	$a2, 8($sp)		 # here comes the middle disk that is B
    sw	$a1, 4($sp)		  # here comes the first disk that is A 
    sw	$a0, 0($sp)		# the number of disks user has entered
    

    #now setting up the recursive call 

    addi $t3, $a3, 0		#copy value  into temp reg
    addi $a3, $a2, 0		#B = C
    addi $a2, $t3, 0		#C = B
    addi $a0, $a0, -1		#num of disk decreament by 1  		
    #recursive call
    jal hanoi      # now from here it will go to the hanoi function

#########################################################
#####################################################
#######################################################

    #loading the stack now
    	lw $ra, 16($sp)
    	lw $a3, 12($sp)		#load a3(which is B)
    	lw $a2, 8($sp)		#load a2(which is C)
    	lw $a1, 4($sp)		#load a1(which is A)
    	lw $a0, 0($sp)		#load a0(num_of_disks)


        #move a disk from A to C
    	addi $t0, $a0, 0		# temp save $a0
    	addi $t1, $zero, 1
    	li $v0, 4			# print move
    	la $a0, Move
    	syscall
    	li $v0, 1 			# print A
    	move $a0, $a1
    	syscall
    	li $v0, 4			# print to
    	la $a0, To
    	syscall
    	li $v0, 1 			# print C
    	move $a0, $a2
    	syscall
    	addi $a0, $t0, 0		# restore $a0

#######################################
######################################
########################################


        #setTING args for subsequent recursive call
    		addi $t3, $a3, 0		#copy var into temp
    		addi $a3, $a1, 0		#B = A
    		addi $a1, $t3, 0		#A = B
    		addi $a0, $a0, -1		#num of disk decreament

            jal hanoi


            #load params off stack
    		lw $ra, 16($sp)
    		
    #clear stack
    	addi $sp, $sp, 20

    #return
    	add $v0, $zero, $t5
    	jr $ra    

#########################################################
#########################################################
########################################################
#########################################################