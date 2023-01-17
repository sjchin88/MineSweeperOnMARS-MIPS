#Author; Chin Shiang Jin
.data
stack_beg:	.word   0 : 60
stack_end:
ColorTable:	.word	0x000000	#black
		.word	0x0000ff	#blue
		.word	0x00ff00	#green
		.word	0xff0000	#red
		.word	0x00ffff	#blue + green (cyan)
		.word	0xff00ff	#red + green
		.word	0xffff00	#red + blue
		.word	0xffffff	#white
Mine_Array:	.word	0:100		#Create array to hold mine value
Numtiles:	.word	8		#Number of tiles in one row/column, Default is 8
SizeTiles:	.word	32		#Size of one square tile on the bit map display, Default is 32 pixels
LayoutSize:	.word	64		#Total number of tiles, Default is 64
NumMines:	.word	6		#Total number of mines, Default is 6
GameCount:	.word	58		#GameCount = TotalTiles - NumMines, Default is 58

DifficultyTable:
		.word	6, 42, 36, 3	#From left to right Numtiles, SizeTiles, LayoutSize, NumMines
		.word	8, 32, 64, 6	#From left to right Numtiles, SizeTiles, LayoutSize, NumMines
		.word	10, 25, 100, 10	#From left to right Numtiles, SizeTiles, LayoutSize, NumMines

# Input Buffer & Pointer for queue
BEGIN_POINTER_OUTPUT:		.word	0		#initialize to zero
END_POINTER_OUTPUT:		.word	0
BUFFER_OUTPUT:			.word	0:100		#Need to allocate a lot of buffer this way. 

TileVisited:	.byte	0:100				#hold value in corresponding index to avoid repeated entry of tile number

TileContentArray:
		.byte	'0',0
		.byte	'1',0
		.byte	'2',0
		.byte	'3',0
		.byte	'4',0
		.byte	'5',0
		.byte	'6',0
		.byte	'7',0
		.byte	'8',0
		.byte	'*',0			#This is symbol of mine
		
TileNumberArray:	#Store the tile number
		.byte	'0','1',0, '0','2',0, '0','3',0, '0','4',0, '0','5',0, '0','6',0, '0','7',0, '0','8',0, '0','9',0, '1','0',0
		.byte	'1','1',0, '1','2',0, '1','3',0, '1','4',0, '1','5',0, '1','6',0, '1','7',0, '1','8',0, '1','9',0, '2','0',0
		.byte	'2','1',0, '2','2',0, '2','3',0, '2','4',0, '2','5',0, '2','6',0, '2','7',0, '2','8',0, '2','9',0, '3','0',0
		.byte	'3','1',0, '3','2',0, '3','3',0, '3','4',0, '3','5',0, '3','6',0, '3','7',0, '3','8',0, '3','9',0, '4','0',0
		.byte	'4','1',0, '4','2',0, '4','3',0, '4','4',0, '4','5',0, '4','6',0, '4','7',0, '4','8',0, '4','9',0, '5','0',0
		.byte	'5','1',0, '5','2',0, '5','3',0, '5','4',0, '5','5',0, '5','6',0, '5','7',0, '5','8',0, '5','9',0, '6','0',0
		.byte	'6','1',0, '6','2',0, '6','3',0, '6','4',0, '6','5',0, '6','6',0, '6','7',0, '6','8',0, '6','9',0, '7','0',0
		.byte	'7','1',0, '7','2',0, '7','3',0, '7','4',0, '7','5',0, '7','6',0, '7','7',0, '7','8',0, '7','9',0, '8','0',0
		.byte	'8','1',0, '8','2',0, '8','3',0, '8','4',0, '8','5',0, '8','6',0, '8','7',0, '8','8',0, '8','9',0, '9','0',0
		.byte	'9','1',0, '9','2',0, '9','3',0, '9','4',0, '9','5',0, '9','6',0, '9','7',0, '9','8',0, '9','9',0, '0','0',0
		
#Table storing the conversion to bitmap display
DigitTable:	
        	.byte   ' ', 0,0,0,0,0,0,0,0,0,0,0,0
        	.byte   '0', 0x7e,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7e
       		.byte   '1', 0x38,0x78,0xf8,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
        	.byte   '2', 0x7e,0xff,0x83,0x06,0x0c,0x18,0x30,0x60,0xc0,0xc1,0xff,0x7e
        	.byte   '3', 0x7e,0xff,0x83,0x03,0x03,0x1e,0x1e,0x03,0x03,0x83,0xff,0x7e
        	.byte   '4', 0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7f,0x03,0x03,0x03,0x03,0x03
        	.byte   '5', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0x7f,0x03,0x03,0x83,0xff,0x7f
        	.byte   '6', 0xc0,0xc0,0xc0,0xc0,0xc0,0xfe,0xfe,0xc3,0xc3,0xc3,0xff,0x7e
        	.byte   '7', 0x7e,0xff,0x03,0x06,0x06,0x0c,0x0c,0x18,0x18,0x30,0x30,0x60
        	.byte   '8', 0x7e,0xff,0xc3,0xc3,0xc3,0x7e,0x7e,0xc3,0xc3,0xc3,0xff,0x7e
       		.byte   '9', 0x7e,0xff,0xc3,0xc3,0xc3,0x7f,0x7f,0x03,0x03,0x03,0x03,0x03
        	.byte   '+', 0x00,0x00,0x00,0x18,0x18,0x7e,0x7e,0x18,0x18,0x00,0x00,0x00
        	.byte   '-', 0x00,0x00,0x00,0x00,0x00,0x7e,0x7e,0x00,0x00,0x00,0x00,0x00
        	.byte   '*', 0x18,0x18,0xdb,0x7e,0x3c,0xff,0xff,0x3c,0x7e,0xdb,0x18,0x18
        	.byte   '/', 0x00,0x00,0x18,0x18,0x00,0x7e,0x7e,0x00,0x18,0x18,0x00,0x00
        	.byte   '=', 0x00,0x00,0x00,0x00,0x7e,0x00,0x7e,0x00,0x00,0x00,0x00,0x00
        	.byte   'A', 0x18,0x3c,0x66,0xc3,0xc3,0xc3,0xff,0xff,0xc3,0xc3,0xc3,0xc3
        	.byte   'B', 0xfc,0xfe,0xc3,0xc3,0xc3,0xfe,0xfe,0xc3,0xc3,0xc3,0xfe,0xfc
        	.byte   'C', 0x7e,0xff,0xc1,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc1,0xff,0x7e
        	.byte   'D', 0xfc,0xfe,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xfe,0xfc
        	.byte   'E', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xff,0xff
        	.byte   'F', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xc0,0xc0
        	.byte   'Y', 0xc3,0xc3,0xc3,0xc3,0x66,0x3c,0x18,0x18,0x18,0x18,0x18,0x18
		.byte   'O', 0x7e,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0x7e
		.byte   'U', 0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0x7e
		.byte   'W', 0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xdb,0xdb,0xff,0x66
		.byte   'I', 0xff,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0xff
		.byte   'N', 0xc3,0xe3,0xe3,0xf3,0xd3,0xdb,0xdb,0xcb,0xcf,0xc7,0xc7,0xc3
		# add additional characters here....
		# first byte is the ascii character
		# next 12 bytes are the pixels that are "on" for each of the 12 lines
#Example
#  0x80----  ----0x08
#  0x40--- || ---0x04
#  0x20-- |||| --0x02
#  0x10- |||||| -0x01
#       ||||||||
#       84218421

#   1   ...xx...      0x18
#   2   ..xxxx..      0x3c
#   3   .xx..xx.      0x66
#   4   xx....xx      0xc3
#   5   xx....xx      0xc3
#   6   xx....xx      0xc3
#   7   xxxxxxxx      0xff
#   8   xxxxxxxx      0xff
#   9   xx....xx      0xc3
#  10   xx....xx      0xc3
#  11   xx....xx      0xc3
#  12   xx....xx      0xc3

#Message Prompts and Errors
Msg_start:	.asciiz "MineSweeper Game, enter number representing difficulty level\n (0-easy : 36 Tiles, 3 mines \n  1-normal : 64 Tiles, 6 mines \n 2-hard : 100 Tile, 10 mines\n"
Msg_input:	.asciiz "MineSweeper Game, enter tilenumber to reveal with reference grid as shown one by one \n"
Msg_repeated:	.asciiz "Input number repeated, enter another number \n"
Msg_overange:	.asciiz "Input number outside range, enter another number \n"
Msg_loose:	.asciiz	"You Lose"
Msg_win:	.asciiz	"YOU WIN"
Msg_replay:	.asciiz "\nReplay Game? Enter 1 for yes\n"

.text
Main:
	#Begin of main program
	la	$sp, stack_end		#Set the stack address
	la	$t0, BUFFER_OUTPUT	#Load base starting affress of BUFFER_OUTPUT
	sw	$t0, BEGIN_POINTER_OUTPUT		#Store it in BEGIN_POINTER_OUTPUT
	sw	$t0, END_POINTER_OUTPUT			#and END_POINTER_OUTPUT		
	la	$a0, Msg_start
	jal	Print_msg
	li	$v0, 5			#specify read integer service
	syscall				#$v0 contains integer read
	bltz	$v0, MainInputOverange
	bgt	$v0, 2, MainInputOverange
	la	$t0, DifficultyTable
	sll	$v0, $v0, 4		#Multiply $v0 by 16 (4 words, 4 bytes each word)
	addu	$t0, $t0, $v0		#Add back to $t0 += $v0
	lw	$t1, 0($t0)		#Load first value Numtiles, 
	sw	$t1, Numtiles		#store it to Numtiles
	lw	$t2, 4($t0)		#Load second value SizeTiles, 
	sw	$t2, SizeTiles		#store it
	lw	$t3, 8($t0)		#Load third value LayoutSize, 
	sw	$t3, LayoutSize		#store it
	lw	$t4, 12($t0)		#Load fourth value  NumMines
	sw	$t4, NumMines		#store it
	subu	$t5, $t3, $t4		#Gamecount = layoutSize - NumMines
	sw	$t5, GameCount		#store it
	lw	$a0, NumMines		#load number of mines to $a0
	la	$a1, Mine_Array		#Load the Mine_Array address
	lw	$a2, LayoutSize		#load layoutsize
	jal	GenerateRandomMine	#populate the mine
	jal	DrawGrid		#draw the grid layout
	jal	DisplayTileNumbers	#and display tile number
	jal	AutoRevealInput		#Get the input and auto reveal adjacent tiles nearby if value is 0
	la	$a0, Msg_replay
	jal	Print_msg		#Print it
	li	$v0, 5			#specify read integer service
	syscall				#Integer read in $v0
	beq	$v0, 1, ResetGame	#Reset the game for next play
	li	$v0, 10			#Exit the program
	syscall		

MainInputOverange:
	la	$a0, Msg_overange
	jal	Print_msg		#print the message
	j	Main

#Procedure ResetGame
ResetGame:
	jal	ClearDisplay		#call ClearDisplayProcedure
	li	$t0, 100		#Set counter = 100
	li	$t1, 0			#load value zero
	la	$t2, Mine_Array		
	la	$t3, TileVisited
	la	$t4, BUFFER_OUTPUT
ResetGameLoop:
	sw	$t1, ($t2)		#store zero to ($t2) to reset its content
	sb	$t1, ($t3)		#store zero to ($t3) to reset its content
	sw	$t1, ($t4)
	addiu	$t2, $t2, 4		#Mine_array move to next index (word)
	addiu	$t3, $t3, 1		#TileVisited move to next index (byte)
	addiu	$t4, $t4, 4
	addiu	$t0, $t0, -1		#Decrease the counter
	beqz	$t0, Main		#Jump to main if counter = 0
	j	ResetGameLoop		#else repeat the loop
	
#Procedure GenerateRandomMine
#Generate n random number, and store a special character to index represented by the random number onto the Mine_array
#Input $a0: number of random number to be generated (number of mines)
#Input $a1: starting address of the Mine_Array to put in the symbol
#Input $a2: Size of the Mine_Array
#Output: symbol of * was put into Mine_array address for corresponding n random tile numbers generated 
GenerateRandomMine:
	# Save value of $ra, to the stack 
	addiu	$sp, $sp, -12		#adjust space for three words to store $ra, $t1, $t0
	sw	$ra, 8($sp)

	#Start of procedure
	move	$t0, $a0		#Move counter value to $t0
	move	$t1, $a1		#Move array starting address to $t1
	li	$v0, 30			#Get System Time
	syscall				#low order 32 bits of System time in $a0
	move 	$a1, $a0		#Move system time to $a1
	li	$a0, 0			
	li	$v0, 40			#set the seed for random number generator
	syscall
	
	
Randomloop:
	move	$a1, $a2		#Set bound for random number to be 0 to Size of Mine_Array
	li	$v0, 42			#Generate the random number 
	syscall				#in $a0
	sll	$t2, $a0, 2		#Multiple $a0 by 4 by shifting  left 2 bits, store in $t2
	addu	$t2, $t1, $t2		#Move array address to $t1(Array starting address) + $t2( offset for the index) and store in $t2
	lw	$t3, ($t2)		#Retrieve the content at the target array index, store in $t3
	beq	$t3, 9, Randomloop	#Repeat the random number generation if $t3 already has the symbol value of 9
	li	$t3, 9			#Else load the value for mine
	sw	$t3, ($t2)		#save the value to address at $t2	
	sw	$t1, 4($sp)		#store value of $t1 - array address to stack
	sw	$t0, 0($sp)		#store value of $t0 - counter value to stack
	addiu	$a0, $a0, 1		#adjust $a0 from 0 to (Mine_Array Size -1) to 1 to Mine_Array Size
	jal	ConstructHint		#Jump to procedure to construct the hint
	lw	$t0, 0($sp)		#Retrieve counter value from stack
	lw	$t1, 4($sp)		#Retrieve array address from stack
	subi	$t0, $t0, 1		#decrement the counter
	bnez	$t0, Randomloop		#repeat the loop to generate next random number if counter != zero
	#else restore $ra from stack and jump back to where procedure is call
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra

#Procedure ConstructHint
#Input $a0 (number): Tile number generated by random number generator which will contain mine
#Input Numtiles (variable): Total number of tiles in one row 
#Output: content of adjacent tiles of mines all increment by 1 (special case for corners/edges)
ConstructHint:
	# Save value of $ra, to the stack 
	addiu	$sp, $sp, -8			#adjust stack for two word registers
	sw	$ra, 4($sp)

#first If check if the number is on the top left corner
	bne	$a0, 1, ConstructHintTopRight	#If the number is not at top left corner, jump to next condition check
	#Else the tile is at top left corner
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddHint2Tile		#Add 1 to array[number] (adjacent tile on the right)  
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles
	sw	$a0, 0($sp)			#save $a0 to the stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles]( adjacent tile on bottom right corner)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	addi	$a0, $a0, -1			#$a0 = number + Numtiles -1
	#sw	$a0, 0($sp)			#save $a0 to the stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -1] (adjacent tile on bottom)
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	j	ConstructHintExit		#Done adding hints, jump to exit
	
ConstructHintTopRight:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	bne	$a0, $t0, ConstructHintBottomLeft	#If number!= Numtiles, not in top right corner, jump to next condition check
	addi	$a0, $a0, -2			#Else continue check, $a0 = number -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number -2] ( adjacent tile on the left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -2] (Adjacent tile on bottom left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	 
	addiu	$a0, $a0, 1			#$a0 = number + Numtiles -1
	#sw	$a0, 0($sp)			#save $a0 to the stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -1] (Adjacent tile on bottom)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	j	ConstructHintExit		#Done adding hints, jump to exit
	
ConstructHintBottomLeft:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addiu	$t1, $t0, -1			#$t1 = Numtiles -1
	mul	$t0, $t0, $t1			#$t0 = $t0 (Numtiles) * $t1 (Numtiles -1)
	addiu	$t0, $t0, 1			#$t0 = $t0 ((Numtiles * (Numtiles -1)) + 1
	bne	$a0, $t0, ConstructHintBottomRight	#If $a0(number)!= $t0 ((Numtiles * (Numtiles -1) + 1), jump to next check
	#Else the tile is at bottom left corner
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddHint2Tile			#Add 1 to array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles] (Adjacent tile on top right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, -1			# $a0 = number - Numtiles - 1
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles - 1] (Adjacent tile on top)
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	j	ConstructHintExit		#Done adding hints, jump to exit
	
ConstructHintBottomRight:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	mul	$t0, $t0, $t0			#$t0 = $t0 * $t0 (Numtiles*Numtiles)
	bne	$a0, $t0, ConstructHintTopRow	#If $a0(number)!= $t0 ((Numtiles * Numtiles), jump to next check
	#Else the tile is at bottom right corner
	addiu	$a0, $a0, -2			#$a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles -2] (Adjacent tile on top left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, 1			# $a0 = number - Numtiles -1
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles -1] (Adjacent tile on top)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack			
	j	ConstructHintExit		#Done adding hints, jump to exit
	
ConstructHintTopRow:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	bgtu	$a0, $t0, ConstructHintBottomRow # if(number< Numtiles) is false. jump to next check
	#Else this is border case: Top row (Note top corners will be captured by previous if/else statement

	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddHint2Tile			#Add 1 to array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	addiu	$a0, $a0, -2			#$a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -2] (Adjacent tile on bottom left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	 		
	addiu	$a0, $a0, 1			# $a0 = number + Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -1] (Adjacent tile on bottom)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, 1			# $a0 = number + Numtiles 
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles] (Adjacent tile on bottom right)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	j	ConstructHintExit		#Done adding hints, jump to exit
	
ConstructHintBottomRow:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addiu	$t1, $t0, -1			#$t1 = Numtiles -1
	mul	$t0, $t0, $t1			#$t0 = Numtiles * (Numtiles -1)
	bleu	$a0, $t0, ConstructHintLeftColumn  # if (number > (Numtiles * (Numtiles -1)) is false, jump to next check
	#Else this Border case: Bottom row (Note bottom corners will be captured by previous if/else statement
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddHint2Tile			#Add 1 to array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	addiu	$a0, $a0, -2			#$a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles -2] (Adjacent tile on top left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, 1			# $a0 = number - Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles -1] (Adjacent tile on top)	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, 1			# $a0 = number - Numtiles
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles] (Adjacent tile on top right)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	j	ConstructHintExit		#Done adding hints, jump to exit
	
ConstructHintLeftColumn:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	div	$a0, $t0			#$a0/$t0, save remainder in HI (same as number % Numtiles)
	mfhi	$t0				#Set $t0 be the remainder from previous division
	beqz	$t0, ConstructHintRightColumn	#if $t0 = 0, the tile is at edge of rightcolumn
	bne	$t0, 1, ConstructHintMiddle	#if $t0 !=1, the tile is not at edge of left column
	#Else the tile is at the edge of left column. Note top and bottom corner will be captured by previous if/else statement
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddHint2Tile			#Add 1 to array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles] (Adjacent tile on top right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, -1			# $a0 = number - Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles -1] (Adjacent tile on top)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	sll	$t0, $t0, 1			#$t0 = Numtiles * 2
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles - 1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -1] (Adjacent tile on bottom)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, 1			# $a0 = number + Numtiles 
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles] (Adjacent tile on bottom right)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	j	ConstructHintExit		#Done adding hints, jump to exit
	
ConstructHintRightColumn:
	#Border case: right column (Note top #and bottom corner will be captured by #previous if/else statement
	addiu	$a0, $a0, -2			#$a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles -2] (Adjacent tile on top left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, 1			# $a0 = number - Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles -1] (Adjacent tile on top)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	sll	$t0, $t0, 1			#$t0 = Numtiles * 2
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles - 1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -1] (Adjacent tile on bottom)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack			
	addiu	$a0, $a0, -1			# $a0 = number + Numtiles -2
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -2] (Adjacent tile on bottom left)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack				
	j	ConstructHintExit		#Done adding hints, jump to exit
	
ConstructHintMiddle:
	#Rest of the case: for tile in the middle
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddHint2Tile			#Add 1 to array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles] (Adjacent tile on top right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, -1			# $a0 = number - Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles -1] (Adjacent tile on top)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, -1			# $a0 = number - Numtiles -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number - Numtiles -2] (Adjacent tile on top left)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			# $a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			# $a0 = number + Numtiles - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -2] (Adjacent tile on bottom left)
		
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, 1			#$a0 = number + Numtiles - 1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles -1] (Adjacent tile on bottom)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, 1			# $a0 = number + Numtiles 
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddHint2Tile			#Add 1 to array[number + Numtiles] (Adjacent tile on bottom right)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	j	ConstructHintExit		#Done adding hints, jump to exit
	
ConstructHintExit:
	#restore $ra from stack and jump back to where procedure is call
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra

#Procedure AddHint2Tile
#Output: Increment the content inside the selected tile number by 1
#Input $a0: Corresponding index number for selected tile in the Mine_array
AddHint2Tile:
	la	$t0, Mine_Array		#Load base address of Mine_array
	sll	$a0, $a0, 2		#Multiply index number by 4, Each array_position is 4 bytes apart
	addu	$t0, $t0, $a0		# $t0 (new address) = $t0 (Base address) + $a0 (index_offset)
	lw	$t1, ($t0)		# Retrieve content in the address, store in $t1
	beq	$t1, 9, AddHint2TileExit	#Skip to exit if the content is a mine
	addi	$t1, $t1, 1		# Else, Increment $t1 by 1
	sw	$t1, ($t0)		# Put the content back to the address
AddHint2TileExit:
	jr	$ra

#Procedure AutoRevealInput
#Read the input from a Queue BUFFER_OUTPUT one by one
#Use the BEGIN_POINTER_OUTPUT & END_POINTER_OUTPUT to perform QUEUE operation.
#If there is no input in Queue, prompt for user input of selected tile number
#If the content of the tile number selected is 0, add adjacent tile numbers into the Queue
AutoRevealInput:
	# Save value of $ra, to the stack 
	addiu	$sp, $sp, -4			#adjust stack for $ra
	sw	$ra, 0($sp)

AutoRevealLoop:
	lw	$t0, BEGIN_POINTER_OUTPUT	#Load the begin_pointer address of the queue
	lw	$t1, END_POINTER_OUTPUT		#Load the end_pointer address of the queue
	subu	$t2, $t1, $t0			#End pointer address - begin pointer address
	bnez	$t2, AutoRevealExtract		#If not zero, go to extract contents in the queue
						
						#Else reset the Buffer Pointer
	la	$t0, BUFFER_OUTPUT		#Load base starting affress of BUFFER_OUTPUT
	sw	$t0, BEGIN_POINTER_OUTPUT	#Store it in BEGIN_POINTER_OUTPUT
	sw	$t0, END_POINTER_OUTPUT		#and END_POINTER_OUTPUT	
	jal	GetInput			#Jump to Procedure GetInput
	j	AutoRevealLoop			#Repeat the AutoRevealLoop
AutoRevealExtract:
	lw	$t2, ($t0)			#$t2 to load content(tile number selected) in BEGIN_POINTER_OUTPUT address
	addiu	$t0, $t0, 4			#Move BEGIN_POINTER to next word
	sw	$t0, BEGIN_POINTER_OUTPUT 	#Store address back to the variable
	move	$a0, $t2			#Move tile number from BEGIN_POINTER_OUTPUT to $a0		
	jal	RevealTileMain			#Jump to RevealTile Procedure
	j	AutoRevealLoop			#Jump back
AutoRevealExit:	
	lw	$ra, 0($sp)			#Retrieve $ra from stack
	addiu	$sp, $sp, 4		
	jr	$ra				#Jump back to main
	
#Procedure GetInput
#Display a message prompt
#read integer input from user 
#Check if the input was entered to queue before
#and store the input into the queue if havent 
GetInput:
	addiu	$sp, $sp, -4		#make room for three words, to store $ra, %t0 (counter), $t3 (content of tile)
	sw	$ra, 0($sp)		#store return address
	la	$a0, Msg_input		#load address of input message to $a0
	jal	Print_msg		#Print it
	
GetInputloop:
	li	$v0, 5				#specify read integer service
	syscall					#$v0 contains integer read
	ble	$v0, $zero, GetInputOverange	#if $v0 < 0, skip to overange message
	lw	$t0, LayoutSize			#load the total number of tiles
	bgt	$v0, $t0, GetInputOverange	#if $v0 > total number of tiles, skip to overange message
	
	la	$t1, TileVisited
	subi	$t2, $v0, 1			#adjust the integer read to array index by -1, store in $t2
	addu	$t1, $t1, $t2			#$t1 += $t2
	lb	$t3, ($t1)			#Load byte of $t1
	beq	$t3, 1, GetInputRepeated	#skip to GetInputRepeated if content = 1 (visited)
	#v0 contain integer read
	#else fall through and 
	li	$t3, 1			#Load immediate 1
	sb	$t3, ($t1)		#Store it back to $t1
	
	lw	$t4, END_POINTER_OUTPUT		#Load the end_pointer address of the queue
	sw	$v0, ($t4)			#Store user input into End_pointer Address
	addiu	$t4, $t4, 4			#Move END_POINTER_OUTPUT value by 4 bytes (1 word)
	sw	$t4, END_POINTER_OUTPUT 	#Store it back to END_POINTER_OUTPUT	
	
	lw	$ra, 0($sp)		# retrieve return address from stack
	addiu	$sp, $sp, 4
	jr	$ra			#and jump back to AutoReveal procedure
	
GetInputRepeated:
	la	$a0, Msg_repeated
	jal	Print_msg		#print the message
	j	GetInputloop

GetInputOverange:
	la	$a0, Msg_overange
	jal	Print_msg		#print the message
	j	GetInputloop

#Procedure to print String message
# $a0 = address of String message to print
Print_msg:
	li   	$v0, 4          	# specify Print String service
        syscall              		# print the string
        jr	$ra			# jump back to where procedure is being called
        
#Procedure RevealTileMain
#RevealTile content of selected tile
#and add the adjacent tile numbers to the Queue if the content of tile is 0
#Check for Gameloose and Gamewin condition as well
#Input $a0 : Tile number selected
RevealTileMain:
	addiu	$sp, $sp, -12		#make room for three words, to store $ra, $a0, $t2 (content of tile)
	sw	$ra, 8($sp)		#store return address
	sw	$a0, 4($sp)
	subi	$t0, $a0, 1		#adjust the integer read to array index by -1, store in $t0
	la	$t1, Mine_Array		#Load base address of the Mine_Array
	sll	$t0, $t0, 2		#Multiply $t0 by 4 (4 bytes apart for one index)
	addu	$t1, $t1, $t0		#Move to address pointed by the array index
	lw	$t2, ($t1)		#Retrieve content store in the array address
	sw	$t2, 0($sp)		#temporary save the content to stack first
	bnez	$t2, RevealTileCont	#Skip getting adjacent tile if $t2 not equal to zero
	jal	GetAdjacentTileNums	###Get Adjacent Tile Numbers
	
RevealTileCont:
	lw	$t2, 0($sp)		#Retrieve value for $t2
	lw	$a0, 4($sp)		#Retrieve value for $a0
	#Integer Read is  in #$a0
	la	$a1, TileContentArray	#Load the base address of TileContentArray
	sll	$t3, $t2, 1		#Multiply $t2 by 2 as each index in TileContentArray is 2 bytes apart
	addu	$a1, $a1, $t3		#add the offset into $a1
	jal	RevealTile		#x-offset @ $v0, y-offset @ $v1
	lw	$t2, 0($sp)		#retrieve content from stack	
	beq	$t2, 9, Gameloose	#jump to Gameloose if $t2 = 9 (got mine)
	lw	$t0, GameCount		#else retrieve counter from variable GameCount
	addi	$t0, $t0, -1		#decrease the counter by 1
	sw	$t0, GameCount		#store it back to variable GameCount
	beqz	$t0, Gamewin		#if counter equal to zero, Gamewin
	#else restore $ra from stack and jump back to where procedure is call (from AutoReveal)
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra
				
Gamewin:
	li	$a0, 70			#load the pitch value
	li	$a1, 500		#load duration in 500 ms
	li	$a2, 45			#load the instrument - String
	li	$a3, 75			#load volume = 75
	li	$v0, 33			#specify play MIDI sound service
	syscall
	
	la	$a0, Msg_win		#Load address of win message
	jal	Print_msg		#print the message
	
	li	$a0, 96			#Load x-coordinate
	li	$a1, 116		#Load y-coordinate
	la	$a2, Msg_win		#load message address
	li	$a3, 3
	jal	OutText			#draw the message on bit map
	
	li	$a0, 126		#Load x-coordinate
	li	$a1, 140		#Load y-coordinate
	li	$a2, 3			#load color index
	li 	$a3, 10			#Size of box = 10
	jal	DrawBox
	
	li	$a0, 96			#Load initial x-coordinate
	li	$a1, 156		#Load y-coordinate
	li	$a2, 3			#load color index
	li	$a3, 8			#Size of box = 8
	jal	DrawBox
	
	li	$a0, 160		#Load initial x-coordinate
	li	$a1, 156		#Load y-coordinate
	li	$a2, 3			#load color index
	li	$a3, 8			#Size of box = 8
	jal	DrawBox
	
	li	$a0, 96			#Load initial x-coordinate

Fun_Loop:
	addi	$sp, $sp, -4
	sw	$a0, 0($sp)		#save initial x-coordinate to stack
	li	$a1, 164		#Load y-coordinate
	li	$a2, 3			#load color index
	li	$a3, 8			#Size of box = 8
	jal	DrawBox
	lw	$a0, 0($sp)		#Retrieve initial x-coordinate from stack
	addi	$sp, $sp, 4
	addi	$a0, $a0, 8		#Increment x-coordinate by 8
	blt	$a0, 167, Fun_Loop	#if $a0 < 180, continue to draw the box
	j	RevealTileExit		#jump to exit
	
Gameloose:
	li	$a0, 60			#load the pitch value
	li	$a1, 500		#load duration in 500 ms
	li	$a2, 60			#load the instrument - brass
	li	$a3, 100		#load volume = 100
	li	$v0, 33			#specify play MIDI sound service
	syscall
	la	$a0, Msg_loose		#Load address of loose message
	jal	Print_msg		#print the message
	j	RevealTileExit		#jump to exit
	
RevealTileExit:
	#restore $ra from stack and jump back to where procedure is call
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
	j	AutoRevealExit		#jump back to AutoRevealExit

#Procedure GetAdjacentTileNums
#Input $a0 (number): Tile number selected
#Input Numtiles (variable): Total number of tiles in one row 
#Output: adjacent tile numbers added to Queue if havent added before
GetAdjacentTileNums:
	# Save value of $ra, to the stack 
	addiu	$sp, $sp, -8			#adjust stack for two word registers
	sw	$ra, 4($sp)

#first If check if the number is on the top left corner
	bne	$a0, 1, GetAdjacentTileNumsTopRight	#If the number is not at top left corner, jump to next condition check
	#Else the tile is at top left corner
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddNum2Queue			#Add number to queue from to array[number] (adjacent tile on the right)  
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles
	sw	$a0, 0($sp)			#save $a0 to the stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles]( adjacent tile on bottom right corner)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	addi	$a0, $a0, -1			#$a0 = number + Numtiles -1
	#sw	$a0, 0($sp)			#save $a0 to the stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles -1] (adjacent tile on bottom)
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	j	GetAdjacentTileNumsExit		#Done adding hints, jump to exit
	
GetAdjacentTileNumsTopRight:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	bne	$a0, $t0, GetAdjacentTileNumsBottomLeft	#If number!= Numtiles, not in top right corner, jump to next condition check
	addi	$a0, $a0, -2			#Else continue check, $a0 = number -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number -2] ( adjacent tile on the left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles -2] (Adjacent tile on bottom left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	 
	addiu	$a0, $a0, 1			#$a0 = number + Numtiles -1
	#sw	$a0, 0($sp)			#save $a0 to the stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles -1] (Adjacent tile on bottom)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	j	GetAdjacentTileNumsExit		#Done adding hints, jump to exit
	
GetAdjacentTileNumsBottomLeft:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addiu	$t1, $t0, -1			#$t1 = Numtiles -1
	mul	$t0, $t0, $t1			#$t0 = $t0 (Numtiles) * $t1 (Numtiles -1)
	addiu	$t0, $t0, 1			#$t0 = $t0 ((Numtiles * (Numtiles -1)) + 1
	bne	$a0, $t0, GetAdjacentTileNumsBottomRight	#If $a0(number)!= $t0 ((Numtiles * (Numtiles -1) + 1), jump to next check
	#Else the tile is at bottom left corner
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddNum2Queue			#Add number to queue from array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles] (Adjacent tile on top right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, -1			# $a0 = number - Numtiles - 1
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles - 1] (Adjacent tile on top)
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	j	GetAdjacentTileNumsExit		#Done adding hints, jump to exit
	
GetAdjacentTileNumsBottomRight:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	mul	$t0, $t0, $t0			#$t0 = $t0 * $t0 (Numtiles*Numtiles)
	bne	$a0, $t0, GetAdjacentTileNumsTopRow	#If $a0(number)!= $t0 ((Numtiles * Numtiles), jump to next check
	#Else the tile is at bottom right corner
	addiu	$a0, $a0, -2			#$a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles -2] (Adjacent tile on top left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, 1			# $a0 = number - Numtiles -1
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles -1] (Adjacent tile on top)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack			
	j	GetAdjacentTileNumsExit		#Done adding hints, jump to exit
	
GetAdjacentTileNumsTopRow:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	bgtu	$a0, $t0, GetAdjacentTileNumsBottomRow # if(number< Numtiles) is false. jump to next check
	#Else this is border case: Top row (Note top corners will be captured by previous if/else statement

	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddNum2Queue			#Add number to queue from array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	addiu	$a0, $a0, -2			#$a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles -2] (Adjacent tile on bottom left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	 		
	addiu	$a0, $a0, 1			# $a0 = number + Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from to array[number + Numtiles -1] (Adjacent tile on bottom)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, 1			# $a0 = number + Numtiles 
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles] (Adjacent tile on bottom right)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	j	GetAdjacentTileNumsExit		#Done adding hints, jump to exit
	
GetAdjacentTileNumsBottomRow:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addiu	$t1, $t0, -1			#$t1 = Numtiles -1
	mul	$t0, $t0, $t1			#$t0 = Numtiles * (Numtiles -1)
	bleu	$a0, $t0, GetAdjacentTileNumsLeftColumn  # if (number > (Numtiles * (Numtiles -1)) is false, jump to next check
	#Else this Border case: Bottom row (Note bottom corners will be captured by previous if/else statement
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddNum2Queue			#Add number to queue from array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	addiu	$a0, $a0, -2			#$a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles -2] (Adjacent tile on top left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, 1			# $a0 = number - Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles -1] (Adjacent tile on top)	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, 1			# $a0 = number - Numtiles
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles] (Adjacent tile on top right)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	j	GetAdjacentTileNumsExit		#Done adding hints, jump to exit
	
GetAdjacentTileNumsLeftColumn:
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	div	$a0, $t0			#$a0/$t0, save remainder in HI (same as number % Numtiles)
	mfhi	$t0				#Set $t0 be the remainder from previous division
	beqz	$t0, GetAdjacentTileNumsRightColumn	#if $t0 = 0, the tile is at edge of rightcolumn
	bne	$t0, 1, GetAdjacentTileNumsMiddle	#if $t0 !=1, the tile is not at edge of left column
	#Else the tile is at the edge of left column. Note top and bottom corner will be captured by previous if/else statement
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddNum2Queue			#Add number to queue from array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles] (Adjacent tile on top right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, -1			# $a0 = number - Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles -1] (Adjacent tile on top)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	sll	$t0, $t0, 1			#$t0 = Numtiles * 2
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles - 1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles -1] (Adjacent tile on bottom)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, 1			# $a0 = number + Numtiles 
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles] (Adjacent tile on bottom right)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	j	GetAdjacentTileNumsExit		#Done adding hints, jump to exit
	
GetAdjacentTileNumsRightColumn:
	#Border case: right column (Note top #and bottom corner will be captured by #previous if/else statement
	addiu	$a0, $a0, -2			#$a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles -2] (Adjacent tile on top left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, 1			# $a0 = number - Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles -1] (Adjacent tile on top)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	sll	$t0, $t0, 1			#$t0 = Numtiles * 2
	addu	$a0, $a0, $t0			#$a0 = number + Numtiles - 1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles -1] (Adjacent tile on bottom)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack			
	addiu	$a0, $a0, -1			# $a0 = number + Numtiles -2
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles -2] (Adjacent tile on bottom left)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack				
	j	GetAdjacentTileNumsExit		#Done adding hints, jump to exit
	
GetAdjacentTileNumsMiddle:
	#Rest of the case: for tile in the middle
	sw	$a0, 0($sp)			# $a0 = number, save to stack
	jal	AddNum2Queue			#Add number to queue from array[number] (adjacent tile on the right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	subu	$a0, $a0, $t0			# $a0 = number - Numtiles
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles] (Adjacent tile on top right)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack	
	addiu	$a0, $a0, -1			# $a0 = number - Numtiles -1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles -1] (Adjacent tile on top)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, -1			# $a0 = number - Numtiles -2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number - Numtiles -2] (Adjacent tile on top left)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			# $a0 = number - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number-2] (Adjacent tile on  left)
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
	addu	$a0, $a0, $t0			# $a0 = number + Numtiles - 2
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles -2] (Adjacent tile on bottom left)
		
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, 1			#$a0 = number + Numtiles - 1
	sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles -1] (Adjacent tile on bottom)	
	
	lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	addiu	$a0, $a0, 1			# $a0 = number + Numtiles 
	#sw	$a0, 0($sp)			#save $a0 to stack
	jal	AddNum2Queue			#Add number to queue from array[number + Numtiles] (Adjacent tile on bottom right)	
	#lw	$a0, 0($sp)			#retrieve value of $a0 from the stack		
	j	GetAdjacentTileNumsExit		#Done adding hints, jump to exit
	
GetAdjacentTileNumsExit:
	#restore $ra from stack and jump back to where procedure is call
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra

#Procedure AddNum2Queue
#Add selected tile number into the Queue if havent entered before
#Input $a0: Corresponding index number for selected tile in the TileVisited
AddNum2Queue:
	la	$t0, TileVisited		#Load base address of TileVisited
	addu	$t0, $t0, $a0			#$t0 += $a0
	lb	$t1, ($t0)			#Load byte of $t0
	beq	$t1, 1, AddNum2QueueExit	#skip to exit if content = 1 (visited)
	#else fall through and  $a0 still contain the adjacent tile number
	lw	$t2, END_POINTER_OUTPUT		#Load the end_pointer address of the queue
	addiu	$a0, $a0, 1			#Adjust back from index to tile number
	sw	$a0, ($t2)			#Store adjacent tile number into End_pointer Address
	addiu	$t2, $t2, 4			#Move END_POINTER_OUTPUT value by 4 bytes (1 word)
	sw	$t2, END_POINTER_OUTPUT 	#Store it back to END_POINTER_OUTPUT		
	li	$t1, 1				#Set $t1 = 1
	sb	$t1, ($t0)			#store $t1 back to TileVisited
AddNum2QueueExit:
	jr	$ra

# Procedure RevealTile
# Reveal the tile selected and the content inside
# Input $a0 = tile number
# Input $a1 = pointer to asciiz text (to be displayed)
# Input Numtiles (variable): Total number of tiles in one row 
# Input SizeTiles (variable): Size of square tile on the bitmap display
RevealTile:
	addiu	$sp, $sp, -20		#make room for five words, to store $ra at 16($sp), 
					#pointer to asciiz text at 12($sp), tile number at 8($sp),
					#temporary  y-coordinate at 4($sp) and x-coordinate at 0($sp) 
	sw	$ra, 16($sp)		#store return address
	sw	$a1, 12($sp)		#store the pointer to stack
	sw	$a0, 8($sp)		#store the selected number to stack
	lw	$t0, Numtiles			#load value of Number of tiles per row/column
 	lw	$t1, SizeTiles			#Load size of tile
 	div	$a0, $t0			#Divide $a0 (tile number) / Numtiles, Hi store remainder (X-coordinate), Lo store quotioent (Y-coordinate)
 	mfhi	$a0				#Retrieve remainder (x-coordinate) from Hi
 	mflo	$a1				#Retrieve remainder (y-coordinate) from lo	
 	bnez	$a0,  CalcOffsetCon		#skip next instructions if $a0 != 0 
 	addu	$a0, $a0, $t0		#Else add Numtiles to $a0
 	addiu	$a1, $a1, -1			#and minus 1 from $a1
CalcOffsetCon:
 	addiu	$a0, $a0, -1			#Convert $a0 from 1- Numtiles to range of 0- (Numtiles-1) (index value)
 	mul	$a0, $a0, $t1			#multiply $a0 by $t1
 	mul	$a1, $a1, $t1			#multiply $a1 by $t1
 	sw	$a1, 4($sp)			#store the y-coordinate to stack
 	sw	$a0, 0($sp)			#store the x-coordinate to stack
	li	$a2, 7				#set $a2 = index of white color
	move	$a3, $t1			#move the size of tile to $a3
	jal	DrawBox
	
	lw	$a0, 0($sp)		#Retrieve x-coordinate previously calculated
	lw	$t1, SizeTiles		#Reload the size of tiles
	addiu	$t2, $t1, -8		#Calculate offset required to center the digit displayed horizontally
	srl	$t2, $t2, 1		#By (Size of tile - horizontal size of digit) / 2
	addu	$a0, $a0, $t2		#add the offset to x-coordinate
	
	lw	$a1, 4($sp)		#Retrieve y-coordinate previously calculated
	#lw	$t1, SizeTiles		#Reload the size of tiles
	addiu	$t3, $t1, -12		#Calculate offset required to center the digit displayed vertically
	srl	$t3, $t3, 1		#By (Size of tile - vertical size of digit) / 2
	addu	$a1, $a1, $t2		#add the offset to y-coordinate
	lw	$a2, 12($sp)		#Retrieve the pointer from stack and put into $a2
	li	$a3, 1
	jal	OutText
	lw	$ra, 16($sp)		#retrieve return address
	addiu	$sp, $sp, 20		#adjust back the stack
 	jr	$ra			#return to where the procedure is called

#Procedure DrawGrid
#Will draw the grid lines on the display
#Input $a0: number of tiles in one row/column
DrawGrid:
	addiu	$sp, $sp, -24	#adjust stack
	sw	$ra, 20($sp)	#store return address to stack
	lw	$t0, Numtiles	#Set counter = Number of tiles per column/row
	lw	$t1, SizeTiles	#load distance of tile 
	
	li	$a0, 0		#set x-coordinate to start @ 0
	li	$a1, 0		#set y-coordinate to start @ 0
	li	$a2, 7		#set color = white
	mul	$a3, $t0, $t1	#set line size = Numtiles * SizeTiles

DrawGridloopHor:
	sw	$t0, 16($sp)	#store counter to stack
	#Save a regs to stack
	sw	$a3, 12($sp)
	sw	$a2, 8($sp)
	sw	$a1, 4($sp)
	sw	$a0, 0($sp)
	jal	HorzLine
	
	#Restore a regs & counter from stack
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)
	lw	$t0, 16($sp)
	lw	$t1, SizeTiles	#load distance of tile 
	addu	$a1, $a1, $t1	#increment y-coordinate by the distance between tiles
	addi	$t0, $t0, -1	#decrement the counter value by 1
	bnez	$t0, DrawGridloopHor	#repeat the loop if counter != zero

#else fall through 
	lw	$t0, Numtiles	#
	lw	$t1, SizeTiles
	li	$a0, 0		#reset x-coordinate to start @ 0
	li	$a1, 0		#reset y-coordinate to start @ 0
	li	$a2, 7		#reset color = white
	mul	$a3, $t0, $t1	#set line size = Numtiles * SizeTiles
DrawGridloopVer:
	#Save a regs to stack
	sw	$t0, 16($sp)
	sw	$a3, 12($sp)
	sw	$a2, 8($sp)
	sw	$a1, 4($sp)
	sw	$a0, 0($sp)
	jal	VertLine
	
	#Restore a regs from stack
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)
	lw	$t0, 16($sp)
	lw	$t1, SizeTiles	
	addu	$a0, $a0, $t1	#increment x-coordinate by the distance between tiles
	addiu	$t0, $t0, -1	#decrement the counter value by 1
	bnez	$t0, DrawGridloopVer	#repeat the loop if counter != zero

	#else fall through
	#retrieve #ra from stack
	lw	$ra, 20($sp)
	addiu	$sp, $sp, 24	#adjust stack back
	jr	$ra		#jump back to where procedure is called

#Procedure DisplayTileNumbers
#Display the Tile Numbers for reference
#Input Numtiles:#Number of tiles in one row/column
#Input SizeTiles:Size of one square tile on the bit map display
#Input LayoutSize:#Total number of tiles
#Input TileNumberArray: Array storing the two digits tile numbers, each index are 3 bytes apart
DisplayTileNumbers:
	addiu	$sp, $sp, -12	#adjust stack
	sw	$ra, 8($sp)	#store return address to stack
	li	$t0, 1		#Start with tile number 1
	la	$t1, TileNumberArray	#load address of TileNumberArray

DisplayTileNumLoop:
	lw	$t2, Numtiles
	div	$t0, $t2	#Divide $t0 (tile number) / Numtiles, Hi store remainder (X-coordinate), Lo store quotioent (Y-coordinate)
 	mfhi	$a0				#Retrieve remainder (x-coordinate) from Hi
 	mflo	$a1				#Retrieve remainder (y-coordinate) from lo	
 	bnez	$a0,  DisplayTileNumCalc	#skip next instructions if $a0 != 0 
 	addu	$a0, $a0, $t2			#Else add Numtiles to $a0
 	addiu	$a1, $a1, -1			#and minus 1 from $a1
DisplayTileNumCalc:
 	addiu	$a0, $a0, -1			#Convert $a0 from 1- Numtiles to range of 0- (Numtiles-1) (index value)
 	lw	$t3, SizeTiles	
 	mul	$a0, $a0, $t3			#multiply $a0 by $t1
 	mul	$a1, $a1, $t3			#multiply $a1 by $t1
	addiu	$t4, $t3, -16		#Calculate offset required to center the two digits displayed horizontally
	srl	$t4, $t4, 1		#By (Size of tile - horizontal size of two digits) / 2
	addu	$a0, $a0, $t4		#add the offset to x-coordinate
	
	addiu	$t5, $t3, -12		#Calculate offset required to center the digit displayed vertically
	srl	$t5, $t5, 1		#By (Size of tile - vertical size of digit) / 2
	addu	$a1, $a1, $t5		#add the offset to y-coordinate
	move	$a2, $t1 
	li	$a3, 7			#specify $a3 to be index 1 (color blue)
	sw	$t1, 4($sp)
	sw	$t0, 0($sp)
	
	jal	OutText
	lw	$t0, 0($sp)		#retrieve tile number
	lw	$t1, 4($sp)		#retrieve digit address
	lw	$t2, LayoutSize
	beq	$t0, $t2, DisplayTileNumExit
	addiu	$t0, $t0, 1	#increment tile numbers
	addiu	$t1, $t1, 3	#move to next digit address
	j	DisplayTileNumLoop
	

DisplayTileNumExit:
	#retrieve #ra from stack
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12	#adjust stack back
	jr	$ra		#jump back to where procedure is called	

#Procedure ClearDisplay 
#will draw a large black box cover the entire display
ClearDisplay:
	addiu	$sp, $sp, -4	#adjust stack
	sw	$ra, 0($sp)	#store return address to stack
	li	$a0, 0		#set x-coordinate to start @ 0
	li	$a1, 0		#set y-coordinate to start @ 0
	li	$a2, 0		#set color = black
	li	$a3, 256		#set box size = 256 (full screen size)
	jal	DrawBox
	lw	$ra, 0($sp)	#Retrieve return address from stack
	addi	$sp, $sp, 4	#adjust stack back
	jr	$ra

# OutText: display ascii characters on the bit mapped display
# $a0 = horizontal pixel co-ordinate (0-255)
# $a1 = vertical pixel co-ordinate (0-255)
# $a2 = pointer to asciiz text (to be displayed)
# $a3 = color number (0-7)
OutText:
        addiu   $sp, $sp, -24
        sw      $ra, 20($sp)

        li      $t8, 1          # line number in the digit array (1-12)
_text1:
        la      $t9, 0x10040000 # get the memory start address
        sll     $t0, $a0, 2     # assumes mars was configured as 256 x 256
        addu    $t9, $t9, $t0   # and 1 pixel width, 1 pixel height
        sll     $t0, $a1, 10    # (a0 * 4) + (a1 * 4 * 256)
        addu    $t9, $t9, $t0   # t9 = memory address for this pixel

        move    $t2, $a2        # t2 = pointer to the text string
_text2:
        lb      $t0, 0($t2)     # character to be displayed
        addiu   $t2, $t2, 1     # last character is a null  
        beq     $t0, $zero, _text9

        la      $t3, DigitTable # find the character in the table
_text3:
        lb      $t4, 0($t3)     # get an entry from the table
        beq     $t4, $t0, _text4
        beq     $t4, $zero, _text4
        addiu   $t3, $t3, 13    # go to the next entry in the table
        j       _text3
_text4:
        addu    $t3, $t3, $t8   # t8 is the line number
        lb      $t4, 0($t3)     # bit map to be displayed

#        sw      $zero, 0($t9)   # first pixel is black
        addiu   $t9, $t9, 4	# t9 = memory address for this pixel

        li      $t5, 8          # 8 bits to go out
_text5:
        la      $t7, ColorTable
        lw      $t7, 28($t7)     # assume white
        andi    $t6, $t4, 0x80  # mask out the bit (0= background color, 1= color selected)
        beq     $t6, $zero, _text6
        la      $t7, ColorTable     # else it is Color selected
        sll	$t6, $a3, 2	#multiply $a3 by 4
        addu	$t7, $t7, $t6	#$t7 += $t6
        lw      $t7, 0($t7)
        sw      $t7, 0($t9)     # write the pixel color    
_text6:
        #sw      $t7, 0($t9)     # write the pixel color
        addiu   $t9, $t9, 4     # go to the next memory position
        sll     $t4, $t4, 1     # and line number
        addiu   $t5, $t5, -1    # and decrement down (8,7,...0)
        bne     $t5, $zero, _text5

#        sw      $zero, 0($t9)   # last pixel is black
        addiu   $t9, $t9, 4
        j       _text2          # go get another character #test code

_text9:
        addiu   $a1, $a1, 1     # advance to the next line
        addiu   $t8, $t8, 1     # increment the digit array offset (1-12)
        bne     $t8, 13, _text1

        lw      $ra, 20($sp)
        addiu   $sp, $sp, 24
        jr      $ra
		
#Procedure DrawBox
#$a0 = x coordinate(0-31)
#$a1 = y coordinate(0-31)
#$a2 = color number (0-7)
#$a3 = size of the box(1-32)
DrawBox:
	addiu	$sp, $sp, -24	#Make room in stack
	sw	$ra, 20($sp)	#store return address to stack
	sw	$s0, 16($sp)	#store previous value of $s0 to stack
	move	$s0, $a3	# Copy $a3 to $s0
BoxLoop:
	#Save a regs to stack
	sw	$a3, 12($sp)
	sw	$a2, 8($sp)
	sw	$a1, 4($sp)
	sw	$a0, 0($sp)
	jal	HorzLine
	
	#Restore a regs from stack
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)
	
	addi	$a1, $a1, 1		#increment y coord by 1
	addiu	$s0, $s0, -1		#decrement counter by 1
	bne	$s0, $zero, BoxLoop	#if counter != 0, repeatly draw the horizontal line
	lw	$s0, 16($sp)		#else retrieve $s0 from stack
	lw	$ra, 20($sp)		#and $ra from stack
	addi	$sp, $sp, 24		#adjust stack back
	jr	$ra			

#Procedure HorzLine - draw the horizontal line
#$a0 = x coordinate(0-255)
#$a1 = y coordinate(0-255)
#$a2 = color number (0-7)
#$a3 = length of the line(1-256)
HorzLine:
	#save $ra to stack
	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)

HorzLoop:
	#save a registers to stack
	sw	$a3, 12($sp)
	sw	$a2, 8($sp)
	sw	$a1, 4($sp)
	sw	$a0, 0($sp)
	jal	DrawDot			#draw the dot 
	#retrieve #ra and a registers from stack
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)	
	addi	$a0, $a0, 1		#increment x coord in $a0
	subi	$a3, $a3, 1		#decrement line left in $a3
	bne	$a3, $zero, HorzLoop	#repeat loop if $a3 > 0
	
	#retrieve #ra from stack
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20	#adjust stack back
	jr	$ra		#jump back to where procedure is called

#Procedure VertLine - draw the Vertical line
#$a0 = x coordinate(0-255)
#$a1 = y coordinate(0-255)
#$a2 = color number (0-7)
#$a3 = length of the line(1-256)
VertLine:
	#save $ra to stack
	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)

VertLoop:
	#save a-registers to stack
	sw	$a3, 12($sp)
	sw	$a2, 8($sp)
	sw	$a1, 4($sp)
	sw	$a0, 0($sp)
	jal	DrawDot			#draw the dot 
	
	#Retrieve a registers from stack
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)
	addi	$a1, $a1, 1		#increment y coord in $a1
	subi	$a3, $a3, 1		#decrement line left in $a3
	bne	$a3, $zero, VertLoop	#repeat loop if $a3 > 0
	
	#else retrieve #ra from stack
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20		#adjust stack back
	jr	$ra			#jump back to where the procedure is called

#Procedure DrawDot
#$a0 = x coordinate(0-255)
#$a1 = y coordinate(0-255)
#$a2 = color number (0-7)
DrawDot:
addiu	$sp, $sp, -8		#Make room on stack for 2 words
sw	$ra, 4($sp)		#store $ra
sw	$a2, 0($sp)		#store $a2
jal	CalcAddr		#$v0 has address for pixel
lw	$a2, 0($sp)		#retrieve $a2 from stack
sw	$v0, 0($sp)		#store $v0 into stack
jal	GetColor		#$v1 has the color code
lw	$v0, 0($sp)		#retrieve $v0 from stack
sw	$v1, 0($v0)		#save the color code to the address of pixel => draw the dot
lw	$ra, 4($sp)		#retrieve $ra from stack
addiu	$sp, $sp, 8		#adjust stack
jr	$ra			#jump back to the return address

#Procedure CalcAddress
#$a0 = x coordinate(0-255)
#$a1 = y coordinate(0-255)
#returns $v0 = memory address
CalcAddr:
	li	$v0, 0x10040000		#Set $v0 to base address
	sll	$t0, $a0, 2		#Multiply $a0 by 4, store in $t0
	addu	$v0, $v0, $t0		#$v0 = $v0 + $t0
	sll	$t0, $a1, 10		#Multiply $a1 by 10, y-coordinate*256*4, store in $t0
	addu	$v0, $v0, $t0 		#$v0 = $v0 + $t0(y-coordinate)
	jr	$ra			#jump back to the return address
	
#Procedure GetColor
#$a2 = color number (0-7)
#returns $v1 = actual number to write to display
GetColor:
	la	$t0, ColorTable		#Load base address
	sll	$t1, $a2, 2		#multiply index($a2) by 4 to get the offset required, store in $t1
	addu	$t0, $t0, $t1		#$t0 = $t0(base address) + $t1 (offset for color array)
	lw	$v1, 0($t0)		#Get the actual color and store in $v1
	jr	$ra
