.data
    prompt: .asciiz "Enter the number of disks "
    movee:  .asciiz "\n move disk from "
    to: .asciiz "To" 
.text
.ent main
.globl main
main:
    #use se input ley  rha hoon yahan 
    li $v0 , 4  
    la $a0 , prompt
    syscall

    li $v0 , 5
    syscall
    add $a0 , $v0 , $0   #user ka diya huwa input $a0 me store kar liya hai

    addi	$a1, $0, 1   #temp value store karai hai
    addi	$a2, $0, 3   #temp value store karai hai
    addi	$a3, $0, 2  #temp value store karai hai

    jal		hanoi				# jump to hanoi and save position to $ra

    jr		$ra					# jump to $ra
    

hanoi:
    addi $t0 , $a0 , 0    #use ka input ab a0 se t0 me agaya hai
    addi $t1 , $0 , 1
    bne $a0 , $t1 , target    #agar user 1 enter karta hai tou disk ek dafa hi move hogi aur wo else k portion me jaega hi nahi
    li $v0 , 4  
    la $a0 , movee           #move ki statement print kar rhay hain 
    syscall

    li $v0 , 1
    move $a0 , $a1     #ab 1 print hojaega
    syscall

    li $v0, 4			# print to
    la $a0, to
    syscall

    li $v0 , 1
    move $a0, $a2   #user ne 1 enter kia tha tou wo disk 1 dafa hi move hogi

    addi $a0 , $t0, 0    # a0 ko wapis restore kara dia maine



else:           #ab yahan se azaab shuru hoga agar user 1 se zyada disk deta hai tou

    addi $sp , $sp , -20    # stack me maine jagah banai hai 

    #ab stack me ra reg ka address aur phir a0,a1,a2 ki value ko store karata hoon
    sw	$ra, 16($sp)	# yahan tw address agaya	 
    sw	$a3, 12($sp)	#yahan last disk agai
    sw	$a2, 8($sp)		 # yahan middle disk agai
    sw	$a1, 4($sp)		  # yahan first disk agai  
    sw	$a0, 0($sp)		# user ki enter ki hui disk ka number agaya
    

    #now setting up the recursive call 

    addi $t3, $a3, 0		#copy value  into temp
    addi $a3, $a2, 0		#B = C
    addi $a2, $t3, 0		#C = B
    addi $a0, $a0, -1		#num of disk me ek ka decreament kar rhay hain   		
    #recursive call
    jal hanoi      # ab ye yahan se wapis hanoi k func par chala jaega


    #ab stack ko load karwa rhay hain 
    	lw $ra, 16($sp)
    	lw $a3, 12($sp)		#load a3(which is B)
    	lw $a2, 8($sp)		#load a2(which is c)
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


        #setTING args for subsequent recursive call
    		addi $t3, $a3, 0		#copy var into temp
    		addi $a3, $a1, 0		#B = A
    		addi $a1, $t3, 0		#A = B
    		addi $a0, $a0, -1		#num of disk ME decreament

            jal hanoi


            #load params off stack
    		lw $ra, 16($sp)
    		
    #clear stack
    	addi $sp, $sp, 20

    #return
    	add $v0, $zero, $t5
    	jr $ra    