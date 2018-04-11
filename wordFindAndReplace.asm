.data
    para:       .space 1000                     # Pre allocate space for the input paragraph
    copypara:   .space 1000                         #copy the original paragraph
    input:      .space 30                       # Pre allocate space for the input word
    copy:       .space 30                       # Duplicate string to store the word
    replace:    .space 30                       # The alternative word
    replacemsg: .asciiz "Enter the word you want to replace with the word you want to find: \n" #display the msg to enter the alternative word
    ask:        .asciiz "Enter the paragraph:\n"            # Display msg to enter the paragraph
    askwd:      .asciiz "Enter the word you want to find:\n"    # Display msg to enter the word you want to find
    nomatch:    .asciiz "Sorry...The word is not present in the given paragraph.\n"
    match:      .asciiz "Number of times the word present in the paragraph is :-\n"
    line:       .asciiz "\n"
    origpar:    .asciiz "\nTHE ORIGINAL PARAGRAPH IS:- \n-----------------------------------------------------------------------------\n"
    result:     .asciiz "-----------------------------------------------------------------------------\nTHE MODIFIED PARAGRAPH IS:-\n-----------------------------------------------------------------------------\n"
    error:      .asciiz "Sorry...The word you you want to replace with is not the same size of the word you want to find.\n"
#======================================================================================================================================================================



#-----------------------------------------------------------------------------------------------------
# USE OF REGISTERS:
# 
# $s5- Stores characters of copypara
# $t5- Stores ascii value of new line
# $s2- Stores characters of word to find
# $s4- Stores characters of word to replace
# $s0- Stores characters of copy,.i.e , the extracted word
# $s1- Stores characters of the entered paragraph
# $t4- Counts the number of characters in the word to find and also acts as a counter
# $t7- Stores the number of times the find word is found
# $t6- Counts the number of characters in the extracted word
# $t0- Stores the characters of the input paragraph and is also used in the case comparison
# $t8- Stores the characters of the input paragraph
# $t2- Stores the characters of the word to find and the extracted word
# $t3- Stores the characters of the extracted word and also used in case comparison
# $s7- Stores the number of characters of the word to find and the extracted word that are equal
#
#----------------------------------------------------------------------------------------------------






.text
main:

# print the msg to enter the paragraph
    li $v0,4    
    la $a0,ask
    syscall



# Take the input paragraph
    la $a0,para
    li $a1,1000                 # allocate 1000 empty space
    li $v0,8
    syscall

la $s5,copypara                 #load the the base address of the copypara




# print the msg to enter the word you want to find
    li $v0,4
    la $a0,askwd
    syscall



# take the word
    la $a0,input
    li $a2,30                   # create 30 empty spaces
    li $v0,8
    syscall
    move $s2,$a0                # move the address of the input word from $a0 to $s2



# print the msg to enter the word you want to replace
    li $v0,4
    la $a0,replacemsg
    syscall



# take the word
    la $a0,replace
    li $a2,30
    li $v0,8
    syscall
    move $s4,$a0                # the alternative word address is on $s4




# Assign the recquired ascii values in registers and load the  base address of the required variables in their respective registers
    li $t5,10               # ascii value of new line
    la $s0,copy             # loading the addresses of copy of extracted word and the original para
    la $s1,para             # loading the address of the paragraph
    li $t4,1                # count the number of letters present in input word
    li $t7,0                # count the number of times the word present



# Count the number of letters prsent in the input word
    lb $t6,0($s2)               
    count:
        beq $t6,10,countreplace
        addiu $s2,$s2,1
        lb $t6,0($s2)
        addi $t4,$t4,1
    j count



# This block count the number of letters present in replace word
    countreplace :
        la $s4,replace
        li $t1,1
        lb $t3,0($s4)               
            counting:
        beq $t3,10,minor
        addiu $s4,$s4,1
        lb $t3,0($s4)
        addi $t1,$t1,1
            j counting 



# This minor restores the variable contents in their respective registers   
    minor:
    li $t6,1                # count the number of letters present in the extracted word
    la $s2,input            # load the base address of the input word
    lb $t0,0($s1)           # loading the first character of the para

    j extract



# This block stores the the replace word in place of the input word iff the word is found
    store2:             
        la $s4,replace
        li $t0,1
    storing2:
        beq $t0,$t4,intr
            lb $t2,0($s4)
            sb $t2,0($s5)
            addiu $t0,$t0,1
            addiu $s4,$s4,1
            addiu $s5,$s5,1
    j storing2
    j intr



# This block is used to restore the original word present in the paragraph if the input word is not found
    store1:
        li $t0,1
        la $s0,copy
    storing1:
        beq $t0,$t6,intr
            lb $t2,0($s0)
            sb $t2,0($s5)
            addiu $t0,$t0,1
            addiu $s0,$s0,1
            addiu $s5,$s5,1
        j storing1



# This block is used to reinitialise the register content after one iteration        
    intr:

        la $s4,replace
        lb $t0,0($s1)
        beq $t0,10,Display
        la $s0,copy
        li $t6,1
        addiu $s1,$s1,1
        lb $t0,0($s1)
        sb $t8,0($s5)
        addiu $s5,$s5,1


# This block is used to extract each word from the paragraph and store it in another variable called copy
    extract:
        lb $t8,0($s1)
        beq $t0,32,compare
        beq $t0,46,compare
        beq $t0,10,compare
        beq $t0,44,compare
        beq $t0,40,compare
        beq $t0,41,compare
        beq $t0,39,compare
        beq $t0,34,compare
        beq $t0,45,compare
        beq $t0,58,compare
        beq $t0,59,compare
        beq $t0,63,compare
        beq $t0,33,compare
        beq $t0,123,compare
        beq $t0,125,compare
        beq $t0,91,compare
        beq $t0,93,compare
        beq $t0,96,compare
        beq $t0,95,compare
        sb $t0,0($s0)
        addi $t6,$t6,1
        addiu $s0,$s0,1
        addiu $s1,$s1,1
        lb $t0,0($s1)
    j extract



#Compare the extracted word and the input word
    compare:
        sb $t5,0($s0)
        la $s2,input
        la $s0,copy
        lb $t2,0($s2)
        lb $t3,0($s0)
        bne $t6,$t4,store1
        li $s7,0
    check:
        bne $t2,$t3,checkagain
        backagain:
        addi $s7,$s7,1
        beq $s7,$t4,success
        addiu $s2,$s2,1
        addiu $s0,$s0,1
        lb $t2,0($s2)
        lb $t3,0($s0)

    j check


# This block is used to handle the case sensitiveness of the program
    checkagain:
        addi $t3,$t3,32
        addi $t0,$t3,-64
        beq $t2,$t3,backagain
        beq $t2,$t0,backagain
        j store1


# This block is used to count the number of times the word is present in the paragraph      
    success:

    addi $t7,$t7,1
    j store2    



# This block display the messages according to their results
Display:
bne $t4,$t1,errormsg
beq $t7,0,msg
    li $v0,4
    la $a0,match
    syscall
    li $v0,1
    la $a0,($t7)
    syscall
    li $v0,4
    la $a0,line
    syscall
    li $v0,4
    la $a0,origpar
    syscall
    li $v0,4
    la $a0,para
    syscall
    li $v0,4
    la $a0,result
    syscall
    li $v0,4
    la $a0,copypara
    syscall
    j exit


msg:
    li $v0,4
    la $a0,nomatch
    syscall
    li $v0,4
    la $a0,origpar
    syscall
    li $v0,4
    la $a0,para
    syscall
    j exit


errormsg:
    li $v0,4
    la $a0,match
    syscall
    li $v0,1
    la $a0,($t7)
    syscall
    li $v0,4
    la $a0,line
    syscall
    li $v0,4
    la $a0,error
    syscall
    li $v0,4
    la $a0,origpar
    syscall
    li $v0,4
    la $a0,para
    syscall


# The exit block
    exit:
    li $v0,10
    syscall