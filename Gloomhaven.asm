# CS 3340.005 Semester Project
# Kristofer Sanchez krs170530
# The first scenario of Gloomhaven By: Isaac Childres text 
# based adventure
# 
###########################################################
#			MACROS          
###########################################################

# Exit/Done
.macro exit
	li $v0, 10
	syscall
.end_macro

# Print dialogue and recieve input integer in box
# $a0 contains the integer
.macro input_dialog_int
	li $v0, 51
	syscall
.end_macro

# Print dialogue and recieve input in box
# $a0 = message to user
# $a1 = address of input buffer
# $a2 = max number of characters
.macro input_dialog_string
	li $v0, 54
	syscall
.end_macro

# Print Dialogue from register
.macro print_msg
	li $v0, 55
	syscall
.end_macro 

# Print dialogue and integer from register
# first argument is the integer wanting to print register
# second argument is the string wanting to print register
.macro msg_dialog_int
	li $v0, 56
	syscall
.end_macro

# Print Dialogue with response, 0: yes 1:no 2:cancel (yes/no questions)
# $a0 will contain the users answer
.macro conf_dial
	li $v0, 50
	syscall
.end_macro


###########################################################
#		BEGIN PROGRAM				     
###########################################################


	.data
two:		.word		2	# variable to check if user input cancel on dialogues
negTwo:		.word		-2	# variable to check if user input cancel on dialogues
sizeOfParty:	.word		1	# holds user input party size (1-4)

intro:		.ascii		"Everyone needs to eat. \nWhatever your reason for coming to Gloomhaven, out here on the edge of the world, that simple fact is never going to change. \n"
		.ascii		"A mercenary can't fight on an empty stomach. \n" 
		.ascii		"So when Jekserah, a Valrath woman wearing a red cloak and enough gold jewelry to keep you fed for a decade,\n" 
		.ascii		"approaches you in the Sleeping Lion and offers to pay you ten gold coins to track down a thief and retrieve some stolen goods...\n"
		.asciiz		"well, it seems like as good an excuse as any to sober up and start paying off your tab. \n"

prompt_Black_Barrow:	.asciiz	"Will you accept Jekserah's quest or continue with the festivities at the Sleeping Lion?\n"

decline_quest:	.ascii		"You continue on with your drinking until you fall into a drunken slumber.\n"
		.asciiz		"Having missed out on your opportunity for adventure and fame, you continue on in life wondering what could have been.\n"

accept_quest:	.ascii		"\"This thief has taken some important documents,\" says the red-skinned merchant, her tail whipping about in agitation.\n"
		.ascii		"\"I don't care what you do to him. Just bring back what is mine.\" \n"
		.ascii		"Based on Jekserah's description, it was easy enough to knock around a few alley thugs and get a location of the thieves' hideout.\n"
		.ascii		"You don't find yourself as a mercenary way out in Gloomhaven without knowing how to crack a few skulls. \n"
		.asciiz		"So your target is the Black Barrow. Sounds like a lovely place. \n"

find_friends:	.asciiz		"Now that your quest has begun maybe you would like to find some mercenaries to assist you in Gloomhaven?"

on_own:		.asciiz		"So you don't want to split the loot, you must be a skilled mercenary."

party_size:	.asciiz		"Choose the size of your party(1 - 4): "

select_hero:	.asciiz		"Select the hero(s) you would like in your party.\n"

leave_Gloomhaven:	.asciiz	"Now it's time to leave Gloomhaven and begin your journey, out here time is money."


####Black Barrow Entrance Prompts####						
intro_Black_Barrow:	.ascii		"The hill is easy enough to find-a short journey past the New Market Gate and you see it jutting out on the edge of the Corpsewood, looking like a rat under a rug.\n"
			.ascii		"Moving closer you see the mound is formed from a black earth. Its small, overgrown entrance presents a worn set of stone stairs leading down into the darkness.\n"
			.asciiz		"You're unsure of what waits ahead of you, should you find another way?"
			
search_for_entrances:	.ascii		"You begin to search around the mound in hopes of finding a back entrance.\n"
			.asciiz		"After searching around you find yourself back at the entrance, it must be the only way in."		
				
Black_Barrow_1:		.asciiz		"As you descend, you gratefully notice light emanating from below. Unfortunately, the light is accompanied by the unmistakable stench of death."

Black_Barrow_2:		.asciiz		"You contemplate what kind of thieves would make their camp in such a horrid place as you reach the bottom of the steps."

Black_Barrow_3:		.ascii		"Here you find your answer-a rough group of cutthroats who don't seem to have taken very kindly to your sudden appearance.\n"
			.asciiz		"One in the back matches the description of your quarry."

Black_Barrow_4:		.ascii		"\"Take care of these unfortunates,\" he says, backing out of the room.\n"
			.asciiz		"You can vaguely make out his silhouette as he retreats down a hallway and through a door to his left."

Black_Barrow_5:		.ascii		"\"Well, it's not every day we get people stupid enough to hand-deliver their valuables to us,\"\n"
			.asciiz		"grins one of the larger bandits, unsheathing a rusty blade. \"We'll be killing you now.\""
			
Black_Barrow_6:		.asciiz		"Joke's on them. If you had any valuables, you probably wouldn't be down here in the first place."
		
####Black Barrow Room1 Prompts####
BB_rm1_01:		.ascii		"You enter into the first room of the bandit hide out, and are met by two bandit guards.\n"
			.asciiz		"The guards are blocking the entry to the rest of the rooms."
			
BB_rm1_02:		.asciiz		"You're going to need to defeat them in order to pursue the target you came for." 	 																				 																				 																				 																				

BB_rm1_03:		.ascii		"The guards ready their weapons and begin to advance.\n"
			.asciiz		"It's time to battle. Your objective is to defeat all enemies."
			
####Black Barrow Room2 Prompts####
BB_rm2_01:		.asciiz		"Now that the dust has settled and the room is cleared, you can take a moment to tend to your wounds."

BB_rm2_02:		.ascii		"It's time to continue, theres more enemies to clear.\n"
			.asciiz		"You can either flea like a coward(1) or you can continue to the second room(0)?"
	
BB_rm2_03:		.ascii		"Continuing on, knowing you must eliminate all of the enemies in order to escape this place. \n"
			.asciiz		"You proceed through the door into the next room, not knowing what awaits you."

BB_rm2_04:		.asciiz		"Upon entering the room you look around to see what was on the other side of the door."

BB_rm2_05:		.ascii		"You are met by more Bandit Guards and they definitely aren't happy.\n"
			.asciiz		"You notice in the back of the room a Bandit Archer as well."
BB_rm2_06:		.asciiz		"You ready your weapons and charge the bandit guards. Hoping to get the jump on them."

BB_rm2_07:		.asciiz		"Now that the guards have been taken care of it's time to handle the archer!"

####Black Barrow Room3 Prompts####
BB_rm3_01:		.ascii		"After the fight you turn your attention to the last room.\n"
			.asciiz		"You ready yourself for what lies behind the door."

BB_rm3_02:		.ascii		"Kicking through the door, you find yourself face-to-face with the reason these bandits chose this particular hole to nest in:\n"
			.asciiz 		"animate bones-unholy abominations of necromantic power."
	
BB_rm3_03:		.asciiz		"Nothing more to do but lay them to rest along with the remainder of this troublesome rabble."

BB_rm3_04:		.asciiz		"All that remains between you and mission success is two Bandit Archers. Time to finish this!"

####Black Barrow End Prompts####
BB_end_01:		.ascii		"With the last bandit dead, you take a moment to catch your breath and steel yourself\n"
			.asciiz		"against the visions of living remains ripping at your flesh."
			
BB_end_02:		.asciiz		"Your target is not among the dead, and you shudder to think what horrors still await you in the catacombs below."

BB_end_03:		.asciiz		"The next step is to go into Barrow Lair after your target."

BB_end_04:		.asciiz		"To be continued!!" 

###########################################################
# 	Begin the Adventure
###########################################################
	.text
main:
	# load and print initial intro
	la 	$a0, intro	
	la 	$a1, 1	
	print_msg
	
	# prompt user to either accept/decline adventure
	la 	$a0, prompt_Black_Barrow
	conf_dial			# user response is in $a0
	lw	$t1, two			# load 2 to $t1
	beq 	$a0, $t1, cancelSelected		# user selected cancel so exit program
	# user begins or ends before adventure starts
	bgtz 	$a0, declineQuest	# if greater than zero jump to decline quest
	la 	$a0, accept_quest	# else adventure begins load acceptance prompt for quest
	print_msg
	
	# give user option to find friends or go solo
	la	$a0, find_friends
	conf_dial			# user response is in $a0
	beq	$a0, $t1, cancelSelected		# user selected cancel, exit program
selectPartySize:	
	bgtz	$a0, declineFriends	# if playing solo go to declineFriends
	la	$a0, party_size		# otherwise select the number of mercenaries in party
	input_dialog_int		# input party size will be in $a0
	blez 	$a0, selectPartySize	# negative input party size reloop
	bgt	$a0, 4, selectPartySize# input party size greater than 4 reloop
	sw	$a0, sizeOfParty	# store input party size	
	jal	chooseHero		# jump to choosing heros
	
###########################################################	
#      Leave Gloomhaven go to road event
###########################################################	
leaveGloomhaven:	# prompt for leaving Gloomhaven and do a road event.
	la	$a0, leave_Gloomhaven		# prompt to leave Gloomhaven
	la	$a1, 1				# info message
	print_msg
	
	#jump to road event
	jal	randomRoad

###########################################################
#    The Black Barrow Mission
###########################################################	
BlackBarrowArrive:	#arrive at Black Barrow
	la	$a0, intro_Black_Barrow	# prompt and give option of going down stairs
	conf_dial				# user response is in $a0, 0 = find another way, 1 = stairs in
	lw	$t1, two				# load 2 to $t1
	beq	$a0, $t1, cancelSelected		# user selected cancel, exit program
	beqz 	$a0, search			# if user chooses jump to searching for entrance
	j	BlackBarrowEntrance		# user chose to enter, jump to entrance
		
search:
	la 	$a0, search_for_entrances	# print dialogue
	la 	$a1, 1				# as information
	print_msg				# syscall

BlackBarrowEntrance:
	la	$a0, Black_Barrow_1		# going down into the barrow prompt
	la	$a1, 1				# as info
	print_msg				# syscall
	la	$a0, Black_Barrow_2		# more prompt/storyline
	la	$a1, 1				# as info
	print_msg				# syscall
	la	$a0, Black_Barrow_3		# more prompt/storyline
	la	$a1, 1				# as info
	print_msg				# syscall
	la	$a0, Black_Barrow_4		# more prompt/storyline
	la	$a1, 1				# as info
	print_msg				# syscall
	la	$a0, Black_Barrow_5		# more prompt/storyline
	la	$a1, 1				# as info
	print_msg				# syscall
	la	$a0, Black_Barrow_6		# more prompt/storyline
	la	$a1, 1				# as info
	print_msg				# syscall
	j	BlackBarrowRoom1
	
	# made it into Black Barrow and are now into first room
BlackBarrowRoom1:
	la	$a0, BB_rm1_01			# load message upon entry into room1
	la	$a1, 2				# print as warning
	print_msg				# syscall
	la	$a0, BB_rm1_02			# load second message
	la	$a2, 2				# print as warning
	print_msg				# syscall
	la	$a0, BB_rm1_03
	la	$a2, 2
	print_msg
	jal	GuardBattle
	
	# Completed room 1 time to move to room two
BlackBarrowRoom1Fin:	
	la	$a0, BB_rm2_01		# load message to offer recovery
	la	$a1, 1			# info message
	print_msg			# syscall
	la	$a0, BB_rm2_02		# load message to flea(1) or continue to room 2(0)
	input_dialog_int		# syscall, response is in $a0
	la	$t1, negTwo		# load negative two to check for cancel
	beq	$a1, $t1, BlackBarrowRoom1Fin	# reloop if cancel was selected
	bnez 	$a0, leftWithoutComp	# if user selects to leve we branch to gameover
	j	BlackBarrowRoom2
BlackBarrowRoom2:
	la 	$a0, BB_rm2_03		# user chose to stay so load next prompt
	la	$a1, 1			# info message
	print_msg			# syscall
	la	$a0, BB_rm2_04		# more messages
	la	$a1, 1
	print_msg			# syscall
	la	$a0, BB_rm2_05		# bandit guards are found
	la	$a1, 2			# warning message
	print_msg			# syscall
	la	$a0, BB_rm2_06		# just before battle
	la	$a1, 1
	print_msg
	jal	GuardBattle		# jump to fighting guards
	la	$a0, BB_rm2_07		# prepare to fight the archer
	la	$a1, 1			
	print_msg			# syscall
	jal	ArcherBattle		# fight the archer
	j	BlackBarrowRoom2Fin	# jump to get ready for next room
	
BlackBarrowRoom2Fin:
	la	$a0, BB_rm3_01		# message after beating the archer and prepare for final room
	la	$a1, 2
	print_msg			# syscall
	j	BlackBarrowRoom3
	
BlackBarrowRoom3:
	la	$a0, BB_rm3_02		# bust into the final room
	la	$a1, 1
	print_msg			# syscall
	la	$a0, BB_rm3_03		# met with living bones and get ready to fight
	la	$a1, 1
	print_msg			# syscall
	jal	BonesBattle		# fight the living bones
	la	$a0, BB_rm3_04		# message to fight the archers
	la	$a1, 1
	print_msg
	jal	ArcherBattle		# fight remaining archers
	j	BlackBarrowEnd		# end of Black Barrow
	
BlackBarrowEnd:
	la	$a0, BB_end_01		# end game prompt
	la	$a1, 2
	print_msg			# syscall
	la	$a0, BB_end_02		# end game prompt
	la	$a1, 2
	print_msg			# syscall
	la	$a0, BB_end_03		# end game prompt
	la	$a1, 2
	print_msg			# syscall
	la	$a0, BB_end_04		# To be continued
	la	$a1, 2
	print_msg			# syscall
	exit				# exit the program

	
		
###########################################################
#	Left Black Barrow without completion
###########################################################
	.data
abandon1:	.asciiz		"Scared you turn towards the door in a mad dash. Ready to be out of this pit of dispair."

abandon2:	.asciiz		"You escape Black Barrow and head back to Gloomhaven. Feeling good about being alive."

abandon3:	.asciiz		"Arriving at Gloomhaven you're met with looks of disgust and shame. In a world of mercenaries it is not taken lightly to wear the mark of a coward."

abandon4:	.asciiz		"You have no choice but to leave Gloomhaven... banished."

abandon5:	.asciiz		"Gameover!"	
	
	.text
leftWithoutComp:
	la	$a0, abandon1		# load message of abandonment 1
	la	$a1, 2
	print_msg			# syscall
	la	$a0, abandon2		# load message of abandonment 2
	la	$a1, 2
	print_msg			# syscall
	la	$a0, abandon3		# load message of abandonment 3
	la	$a1, 2
	print_msg			# syscall
	la	$a0, abandon4		# load message of abandonment 4
	la	$a1, 2
	print_msg			# syscall
	la	$a0, abandon5		# gameover
	la	$a1, 0
	print_msg			# syscall
	exit				# exit program
	
###########################################################
#	End of Left Black Barrow without completion
###########################################################

###########################################################
#        function for fighting a Bandit Guard
###########################################################	
GuardBattle:
	.data
two1:		.word		-2	# variable to check if user input cancel on dialogues
attackTMP:	.word		0	# for temporarily holding attack value to print
guardHP:		.word		6	# Hit points for the guards
guardAP:		.word		1	# attack power for guards
guardTmpHP:	.word		0	# variable to hold tmp HP of guards
numGuard:	.word		2	# number of guards (default 2)
bruteHP:		.word		10	# Hit points for the brute
bruteAP1:	.word		3	# attack power of brute ability 1
bruteAP2:	.word		3	# attack power of brute ability 2
####Combat Text####
playersTurn:	.asciiz		"It's your turn, would you like to use (1)Leaping Cleave or (0)Spare Dagger?"
enemAttVal:	.asciiz		"Enemy's Attack Value:   "
attackValue:	.asciiz		"Your Attack Value:  "
battleWon:	.asciiz		"All guards have been defeated."
guardRemHP:	.asciiz		"Guards HP:   "
guardKilled:	.asciiz		"You defeated a guard!"
guardRemain:	.asciiz		"Guards Remaining: "
bruteRemHP:	.asciiz		"Your remaining HP:  "


	.text
	addi	$sp, $sp, -4		# allocate space on stack to hold where $ra was 
	sw	$ra, ($sp)		# store location of jal call on stack
	lw	$s3, guardHP		# guard HP in $s3
	lw	$s4, guardAP		# guard AP in $s4
	lw	$s6, numGuard		# number of guards remaining in $s6
	lw	$s0, bruteHP		# brute HP in $s0
	lw	$s1, bruteAP1		# brute AP1 in $s1
	lw	$s2, bruteAP2		# brute AP2 in $s2

attackOuterLoop:	# outer loop for number of guards remaining
	blez	$s6, endGuardBattle	# if number of guards is <= 0 then end battle otherwise loop combat

attackInnerLoop:
	# loop for combat with guards
	blez 	$s3, GuardDefeated	# if guards health is <= 0 then a gaurd has been defeated jump to notify user
	# Users turn to attack
	la	$a0, playersTurn	# give player attack options
	input_dialog_int		# syscall and players choice is in $a0
	lw	$t1, two1				# load 2 to $t1
	beq	$a1, $t1, cancelSelected		# user selected cancel, exit program
	bge	$a0, 2, attackInnerLoop	# not valid input loop again
	bltz	$a0, attackInnerLoop		# not valid input loop again
	move	$a1, $a0		# move players choice to $a1
	jal	selectAttack		# jump to function to determine selected attack
	jal	attack			# jump to function to determine attack's power
	sub	$s3, $s3, $v1		# subtract the attack's power from the guards HP
	move	$a1, $s3
	la	$a0, guardRemHP		# load Guard HP text into $a0
	msg_dialog_int			# print guards remaining health
	move	$s3, $a1		# move guards HP back to $s3 for loop checking
	blez 	$s3, attackInnerLoop	# if guards HP is less than or equal to zero jump to beginning of loop
	# Guards turn to attack		# so the guard doesn't have a turn
	jal	GuardAttack		# jump to function to get guard attack avlue
	sub	$s0, $s0, $v0		# subtract guard attack from the brutes HP
	move	$a1, $s0		# move remaining HP to $a1 to print
	la	$a0, bruteRemHP		# load remaining HP message
	msg_dialog_int			# syscall
	move	$s0, $a1		# move HP back for loop checking
	blez	$s0, gameover		# you have no HP gameover
	j	attackOuterLoop		# jump back to beginning of loop
	
	
	

selectAttack:	# determining what attack was selected and load attack power
	#lw	$v1, 0			# set attack register to zero
	beqz	$a1, ability1
	add	$v1, $zero, 3		# ability 2 was selected so put ability attack power in $v1
	jr	$ra
	
	ability1:	# ability 1 was chosen so put ability attack power in $v1
		add	$v1, $zero, 3
		jr	$ra
		
attack:		# RNG for attack multiplier generate a number between 0 and 4 then subtract 2
	la	$a1, 4		# upper bound of RNG
	li	$v0, 42		# syscall for RNG
	syscall			# random number is in $a0
	sub	$t2, $a0, 2	# subtract 2 from RNG and store in $t2
	add	$v1, $v1, $t2	# add attack multiplier to ability attack power and store in $v1
	la	$a0, attackValue	# load attack value msg
	move	$a1, $v1		# load attack value to $a1 to print
	msg_dialog_int			# print the attacks value
	jr	$ra		# jump back to battle loop

GuardAttack:	# function for guards turn to attack
	la	$a1, 2		# upper bound of RNG for guard attack
	li	$v0, 42		# RNG
	syscall			
	move	$v0, $a0		# move value from RNG to $v0
	la	$a0, enemAttVal		# load attack value msg
	move	$a1, $v0		# load attack value to $a1 to print
	msg_dialog_int			# print the attacks value
	move	$v0, $a1		# move the attack value back to $v0
	jr	$ra			# jump back to battle loop
	
GuardDefeated:	# Function for when a guard has been defeated
	la	$a0, guardKilled	# message saying guard was killed
	la	$a1, 2			# warning message
	print_msg			# syscall
	subi	$s6, $s6, 1		# subtract 1 from number of guards
	la	$a0, guardRemain	# inform user of guards remaining
	move	$a1, $s6		# load number of guards to $a1 for printing
	msg_dialog_int
	lw	$s3, guardHP		# reload guards HP to fight the next guard
	j	attackOuterLoop		# return back to the battle loop
	
endGuardBattle:	# Battle has been won, print success and jump back to main story
	la	$a0, battleWon
	la	$a1, 2
	print_msg
	lw	$ra, ($sp)		# load the location of where jal was initially called
	addi	$sp, $sp, 4		# reallocate space on stack
	jr	$ra			# jump back to location of call to funciton
	#j	BlackBarrowRoom1Fin	# jump back to the story after battle

###########################################################
#     End of Bandit Guard Combat	
###########################################################	

###########################################################
#        function for fighting a Bandit Archer
###########################################################	
ArcherBattle:
	.data
two2:		.word		-2	# variable to check if user input cancel on dialogues
attackTMP2:	.word		0	# for temporarily holding attack value to print
archerHP:		.word		6	# Hit points for the archers
archerAP:		.word		1	# attack power for archers
archerTmpHP:	.word		0	# variable to hold tmp HP of archers
numArcher:	.word		1	# number of archerss (default 1)
bruteHP2:		.word		10	# Hit points for the brute
bruteAP12:	.word		3	# attack power of brute ability 1
bruteAP22:	.word		3	# attack power of brute ability 2
####Combat Text####
playersTurn2:	.asciiz		"It's your turn, would you like to use (1)Leaping Cleave or (0)Spare Dagger?"
enemAttVal2:	.asciiz		"Enemy's Attack Value:   "
attackValue2:	.asciiz		"Your Attack Value:  "
battleWon2:	.asciiz		"All Archers have been defeated."
archerRemHP:	.asciiz		"Archers HP:   "
archerKilled:	.asciiz		"You defeated an Archer!"
archerRemain:	.asciiz		"Archers Remaining: "
bruteRemHP2:	.asciiz		"Your remaining HP:  "


	.text
	addi	$sp, $sp, -4		# allocate space on stack to hold where $ra was 
	sw	$ra, ($sp)		# store location of jal call on stack
	lw	$s3, archerHP		# archer HP in $s3
	lw	$s4, archerAP		# archer AP in $s4
	lw	$s6, numArcher		# number of archers remaining in $s6
	lw	$s0, bruteHP2		# brute HP in $s0
	lw	$s1, bruteAP12		# brute AP1 in $s1
	lw	$s2, bruteAP22		# brute AP2 in $s2

attackOuterLoop2:	# outer loop for number of archers remaining
	blez	$s6, endArcherBattle	# if number of archerss is <= 0 then end battle otherwise loop combat

attackInnerLoop2:
	# loop for combat with archers
	blez 	$s3, ArcherDefeated	# if archers health is <= 0 then a archer has been defeated jump to notify user
	# Users turn to attack
	la	$a0, playersTurn2	# give player attack options
	input_dialog_int		# syscall and players choice is in $a0
	lw	$t1, two2				# load 2 to $t1
	beq	$a1, $t1, cancelSelected		# user selected cancel, exit program
	bge	$a0, 2, attackInnerLoop2	# not valid input loop again
	bltz	$a0, attackInnerLoop2		# not valid input loop again
	move	$a1, $a0		# move players choice to $a1
	jal	selectAttack2		# jump to function to determine selected attack
	jal	attack2			# jump to function to determine attack's power
	sub	$s3, $s3, $v1		# subtract the attack's power from the archers HP
	move	$a1, $s3
	la	$a0, archerRemHP		# load archer HP text into $a0
	msg_dialog_int			# print archers remaining health
	move	$s3, $a1		# move archers HP back to $s3 for loop checking
	blez 	$s3, attackInnerLoop2	# if archers HP is less than or equal to zero jump to beginning of loop
	# Archers turn to attack		# so the archer doesn't have a turn
	jal	ArcherAttack		# jump to function to get archer attack avlue
	sub	$s0, $s0, $v0		# subtract archer attack from the brutes HP
	move	$a1, $s0		# move remaining HP to $a1 to print
	la	$a0, bruteRemHP2		# load remaining HP message
	msg_dialog_int			# syscall
	move	$s0, $a1		# move HP back for loop checking
	blez	$s0, gameover		# you have no HP gameover
	j	attackOuterLoop2		# jump back to beginning of loop
	
	
	

selectAttack2:	# determining what attack was selected and load attack power
	#lw	$v1, 0			# set attack register to zero
	beqz	$a1, ability12
	add	$v1, $zero, 3		# ability 2 was selected so put ability attack power in $v1
	jr	$ra
	
	ability12:	# ability 1 was chosen so put ability attack power in $v1
		add	$v1, $zero, 3
		jr	$ra
		
attack2:		# RNG for attack multiplier generate a number between 0 and 4 then subtract 2
	la	$a1, 4		# upper bound of RNG
	li	$v0, 42		# syscall for RNG
	syscall			# random number is in $a0
	sub	$t2, $a0, 2	# subtract 2 from RNG and store in $t2
	add	$v1, $v1, $t2	# add attack multiplier to ability attack power and store in $v1
	la	$a0, attackValue2	# load attack value msg
	move	$a1, $v1		# load attack value to $a1 to print
	msg_dialog_int			# print the attacks value
	jr	$ra		# jump back to battle loop

ArcherAttack:	# function for archers turn to attack
	la	$a1, 5		# upper bound of RNG for archer attack
	li	$v0, 42		# RNG
	syscall			
	move	$v0, $a0		# move value from RNG to $v0
	la	$a0, enemAttVal2		# load attack value msg
	move	$a1, $v0		# load attack value to $a1 to print
	msg_dialog_int			# print the attacks value
	move	$v0, $a1		# move the attack value back to $v0
	jr	$ra			# jump back to battle loop
	
ArcherDefeated:	# Function for when an archer has been defeated
	la	$a0, archerKilled	# message saying archer was killed
	la	$a1, 2			# warning message
	print_msg			# syscall
	subi	$s6, $s6, 1		# subtract 1 from number of archers
	la	$a0, archerRemain	# inform user of archers remaining
	move	$a1, $s6		# load number of archers to $a1 for printing
	msg_dialog_int
	lw	$s3, archerHP		# reload archers HP to fight the next archer
	j	attackOuterLoop2		# return back to the battle loop
	
endArcherBattle:	# Battle has been won, print success and jump back to main story
	la	$a0, battleWon2
	la	$a1, 2
	print_msg
	lw	$ra, ($sp)		# load the location of where jal was initially called
	addi	$sp, $sp, 4		# reallocate space on stack
	jr	$ra			# jump back to location of call to funciton
	#j	BlackBarrowRoom1Fin	# jump back to the story after battle

###########################################################
#     End of Bandit Archer Combat	
###########################################################

###########################################################
#        function for fighting Living Bones
###########################################################	
BonesBattle:
	.data
two3:		.word		-2	# variable to check if user input cancel on dialogues
attackTMP3:	.word		0	# for temporarily holding attack value to print
bonesHP:		.word		4	# Hit points for the Living Bones
bonesAP:		.word		1	# attack power for Living Bones
bonesTmpHP:	.word		0	# variable to hold tmp HP of Living Bones
numBones:	.word		2	# number of Living Bones (default 2)
bruteHP3:		.word		10	# Hit points for the brute
bruteAP13:	.word		3	# attack power of brute ability 1
bruteAP23:	.word		3	# attack power of brute ability 2
####Combat Text####
playersTurn3:	.asciiz		"It's your turn, would you like to use (1)Leaping Cleave or (0)Spare Dagger?"
enemAttVal3:	.asciiz		"Living Bone's Attack Value:   "
attackValue3:	.asciiz		"Your Attack Value:  "
battleWon3:	.asciiz		"All Living Bones have been defeated."
bonesRemHP:	.asciiz		"Living Bones HP:   "
bonesKilled:	.asciiz		"You defeated a Living Bones!"
bonesRemain:	.asciiz		"Living Bones Remaining: "
bruteRemHP3:	.asciiz		"Your remaining HP:  "


	.text
	addi	$sp, $sp, -4		# allocate space on stack to hold where $ra was 
	sw	$ra, ($sp)		# store location of jal call on stack
	lw	$s3, bonesHP		# Living Bones HP in $s3
	lw	$s4, bonesAP		# Living Bones AP in $s4
	lw	$s6, numBones		# number of Living Bones remaining in $s6
	lw	$s0, bruteHP3		# brute HP in $s0
	lw	$s1, bruteAP1		# brute AP1 in $s1
	lw	$s2, bruteAP23		# brute AP2 in $s2

attackOuterLoop3:	# outer loop for number of Living Bones remaining
	blez	$s6, endBonesBattle	# if number of Living Bones is <= 0 then end battle otherwise loop combat

attackInnerLoop3:
	# loop for combat with Living Bones
	blez 	$s3, BonesDefeated	# if Living Bones health is <= 0 then a archer has been defeated jump to notify user
	# Users turn to attack
	la	$a0, playersTurn3	# give player attack options
	input_dialog_int		# syscall and players choice is in $a0
	lw	$t1, two3				# load 2 to $t1
	beq	$a1, $t1, cancelSelected		# user selected cancel, exit program
	bge	$a0, 2, attackInnerLoop3	# not valid input loop again
	bltz	$a0, attackInnerLoop3		# not valid input loop again
	move	$a1, $a0		# move players choice to $a1
	jal	selectAttack3		# jump to function to determine selected attack
	jal	attack3			# jump to function to determine attack's power
	sub	$s3, $s3, $v1		# subtract the attack's power from the Living Bones HP
	move	$a1, $s3
	la	$a0, bonesRemHP		# load Living Bones HP text into $a0
	msg_dialog_int			# print Living Bones remaining health
	move	$s3, $a1		# move Living Bones HP back to $s3 for loop checking
	blez 	$s3, attackInnerLoop3	# if Living Bones HP is less than or equal to zero jump to beginning of loop
	# Living Bones turn to attack		# so the Living Bones doesn't have a turn
	jal	BonesAttack		# jump to function to get Living Bones attack avlue
	sub	$s0, $s0, $v0		# subtract Living Bones attack from the brutes HP
	move	$a1, $s0		# move remaining HP to $a1 to print
	la	$a0, bruteRemHP3		# load remaining HP message
	msg_dialog_int			# syscall
	move	$s0, $a1		# move HP back for loop checking
	blez	$s0, gameover		# you have no HP gameover
	j	attackOuterLoop3		# jump back to beginning of loop
	
selectAttack3:	# determining what attack was selected and load attack power
	#lw	$v1, 0			# set attack register to zero
	beqz	$a1, ability13
	add	$v1, $zero, 3		# ability 2 was selected so put ability attack power in $v1
	jr	$ra
	
	ability13:	# ability 1 was chosen so put ability attack power in $v1
		add	$v1, $zero, 3
		jr	$ra
		
attack3:		# RNG for attack multiplier generate a number between 0 and 4 then subtract 2
	la	$a1, 4		# upper bound of RNG
	li	$v0, 42		# syscall for RNG
	syscall			# random number is in $a0
	sub	$t2, $a0, 2	# subtract 2 from RNG and store in $t2
	add	$v1, $v1, $t2	# add attack multiplier to ability attack power and store in $v1
	la	$a0, attackValue3	# load attack value msg
	move	$a1, $v1		# load attack value to $a1 to print
	msg_dialog_int			# print the attacks value
	jr	$ra		# jump back to battle loop

BonesAttack:	# function for Living Bones turn to attack
	la	$a1, 6		# upper bound of RNG for Living Bones attack
	li	$v0, 42		# RNG
	syscall			
	move	$v0, $a0		# move value from RNG to $v0
	la	$a0, enemAttVal3		# load attack value msg
	move	$a1, $v0		# load attack value to $a1 to print
	msg_dialog_int			# print the attacks value
	move	$v0, $a1		# move the attack value back to $v0
	jr	$ra			# jump back to battle loop
	
BonesDefeated:	# Function for when an Living Bones has been defeated
	la	$a0, bonesKilled	# message saying Living Bones was killed
	la	$a1, 2			# warning message
	print_msg			# syscall
	subi	$s6, $s6, 1		# subtract 1 from number of Living Bones
	la	$a0, bonesRemain	# inform user of Living Bones remaining
	move	$a1, $s6		# load number of Living Bones to $a1 for printing
	msg_dialog_int
	lw	$s3, bonesHP		# reload Living Bones HP to fight the next Living Bones
	j	attackOuterLoop3		# return back to the battle loop
	
endBonesBattle:	# Battle has been won, print success and jump back to main story
	la	$a0, battleWon3
	la	$a1, 2
	print_msg
	lw	$ra, ($sp)		# load the location of where jal was initially called
	addi	$sp, $sp, 4		# reallocate space on stack
	jr	$ra			# jump back to location of call to funciton
	#j	BlackBarrowRoom1Fin	# jump back to the story after battle

###########################################################
#     End of Living Bones Combat	
###########################################################

###########################################################
#	function for when user declines adventure
###########################################################
declineQuest:
	la $a0, decline_quest		# load prompt for output
	la $a1, 0			# print as error message
	print_msg			# syscall 55
	exit

###########################################################
#	function for finding friends(user chose solo mode)
###########################################################
declineFriends:
	la $a0, on_own			# load solo play prompt
	la $a1, 2			# as warning
	print_msg			# syscall
	j	chooseHero		# jump to choosing hero

###########################################################
#	choosing a hero(s)
###########################################################
chooseHero:
	.data
characterTable:		.word		C1, C2, C3, C4, C5, C6


partyFormed:	.asciiz		"Now that your party is formed lets get back to our journey."
	
characters:	.ascii		"------Class------------HP-------------AP----------------Ability 1--------------Ability 2-----\n"
		.ascii		"(1)Brute------------------10-------------10------------Leaping Cleave 3-------Spare Dagger 3\n"
		.ascii		"(2)Scoundrel-------------8--------------9-------------Thief's Knack 3--------Swift Bow 3\n"
		.ascii		"(3)Spellweaver-----------6--------------8-------------Fire Orbs 3------------Mana Bolt 4\n"
		.ascii		"(4)Cragheart-------------10-------------11------------Crater 3---------------Dirt Tornado 1\n"
		.asciiz		"(5)Mindthief--------------6--------------10------------Into the Night 2-------Fearsome Blade 2\n"
		#.asciiz		"(6)Tinkerer---------------8--------------12------------Ink Bomb 4-------------Net Shooter 3\n"
	.text
# for loop for picking characters in your party

	lw	$t0, sizeOfParty	# load size of party to $t0 (max picks)
	li	$t1, 0			# $t1 is the counter
CharLoop:	
	beq	$t1, $t0, PartyMade	# when count = size of party break out of loop to continue to roaad event
	###Prompt to pick characters using number labels###
	la	$a0, characters
	input_dialog_int
	blt	$a0, 1, CharLoop	# user input is incorrect reloop
	bgt	$a0, 5, CharLoop	# user input is incorrect reloop
	move	$s0, $a0		# move user input selection from $a0 to $s0
	###Body of For loop###
	###Pick character using jump table###
	sll	$s0, $s0, 2		# $s0 = index * 4
	la	$t2, characterTable	# load base address of jump table to $t0
	add	$s0, $s0, $t2		# $s0 is now the address of jump label
	lw 	$s0, ($s0)		# load the target address
	jalr	$s0			# jump to the label
	addi	$t1, $t1, 1		# increment counter
	j	CharLoop		# loop again
	
	# Brute was selected
	C1:
		jr	$ra
	
	# Scoundrel was selected
	C2:
		jr	$ra
		
	# Spellweaver was selected
	C3:
		jr	$ra
		
	# Cragheart was selected
	C4:
		jr	$ra
	
	# Mindthief was selected
	C5: 
		jr	$ra
	
	# Tinkerer was selected
	C6:
		jr	$ra
		
PartyMade:		
		la	$a0, partyFormed
		la	$a1, 1
		print_msg
		j	leaveGloomhaven

###########################################################
#      End of Choosing Hero(s)
###########################################################	

###########################################################
#	Function for road events
#	use a RNG and jump table to keep road events random
###########################################################
randomRoad:
	.data
two4:		.word		-2	# variable to check if user selected cancel on dialogues
	####Road Events Table####
	roadTable:	.word	R1, R2, R3, R4, R5
	
	#randUpper:	.word		5		# variable to hold upper bound of RNG based on number of road events available
	
	####Road Events####
	road1:		.asciiz		"As you leave Gloomhaven you hear chatter in the distance, do you ignore it (0) or follow the chatter (1)?"
		road10:		.asciiz		"Unsure of what is making the chatter and knowing time is precious you continue toward your mission."
		road11:		.ascii		"You follow the noises which lead to a strange hideout where you find a group of street children.\n"
				.asciiz		"Unaware of your approach, you startle them and are met by mud to the eyes. After clearing the mud you find an empty hideout."
				
	road2:		.asciiz		"You hear the howling of wolves on the path ahead, do you continue on the path (0) or reroute away from the howling (1)?"
		road20:		.asciiz		"The howling gets louder and louder as the distance between closes in. You're met by a pack of wolves. Feeling threatnened by your presence, the wolves attack. \n"
		road20cont:	.ascii		"You begin to fight off the wolves but there numbers are many. Eventually you strike a blow to the alpha and the pack begins to break.\n"
				.asciiz		"You manage to survive but not without sustaining deep wounds... with no help insight you hope for the best."
		road21:		.asciiz		"Taking the long way around you continue to hear the howls in the distance until they are no more, wolves out in the wilderness are no welcome sight."
		
	road3:		.ascii		"You are feeling a little hungry as you walk down the road. You are considering stopping for a meal when you come across a thicket of bushes covered in green berries.\n"
			.asciiz		"The berries look delicious, but you hesitate. They could be poisonous. Do you eat the berries(0) or pass and eat a meal later(1)?"
		road30:		.asciiz		"You grab a handful of berries and to stuff in your mouth. They are incredibly sweet and just the right amount of tart. You couldn't feel better about your decision."
		road31:		.asciiz		"Not wanting to regret a poor decision, you refrain from eating the berries and continue on down the road... hungry."
	
	road4:		.asciiz		"Stumbling through the woods you are alarmed to hear the sudden sounds of a large animal rummaging through the underbrush. You crouch down gauging the grunts and growls.\n"
	road4cont:	.ascii		"Through the trees you see a large bear approaching your location. It has not noticed you yet, but you imagine it will soon.\n"
			.asciiz		"Take the opportunity to run from the bear before it gets any closer(0) or Attack the bear, hopefully catching it by surprise(1)?"
		road40:		.asciiz		"You bolt from hiding as fast as you can."
		road40cont:	.asciiz		"Luckily the bear was a ways off, and it gets bored with the chase before it can catch you. Still you keep running until you can't catch your breath."
		road41:		.asciiz		"The bear roars as you approach making powerful swipes with its claws. Still, with the surprise and the commotion the bear is not at all that committed to the fight."
		road41cont:	.asciiz		"After a bit of back and forth, the animal grunts and runs off into the trees. You've sustained some pretty heavy wounds but survive the fight."
	
	road5:		.asciiz		"You come to a fork in the road. One path looks clear and easy, but the other path is overgrown with thorns and nettles. Either one will likely get you to where you are going."
	road5cont:	.ascii		"The whole situation feels off, though--as if someone or something is watching you. Still, a decision must be made.\n"
			.asciiz		"Take the clear path(0) or take the overgrown path(1)?"
		road50:		.asciiz		"You walk down the clear path for a few minutes and just when you think the whole weird feeling was your imagination, a group of bandits jumps out at you from the nearby brush."
		road50cont:	.ascii		"Before they can engage, however, an arrow suddenly spears the chest of the closest bandit, followed very quickly by a second.\n"
				.ascii		"The bandits have paused to look around in panic when a third arrow flies into another bandit's skull.\n"
				.asciiz		"The bandits scatter and run off. You look around for the shooter, but no trace is found."
		road51:		.asciiz		"The trek through the overgrown path is unpleasant. You are constantly getting pricked by sharp thorns covered in a strange sap."
		road51cont:	.ascii		"You think you recognize them from a previous foray into harsh, unforgiving foliage.\n"
				.asciiz		"Sure enough you start feeling sick pretty soon after you emerge from the bushes."
			
	.text
	li 	$v0, 42			# load syscall for RNG
	li	$a1, 5			# set upper bound for RNG
	syscall				# random number will be in $a0
	
	# "Switch" for picking the random road event
	move	$s0, $a0		# move rand number to $s0
	sll	$s0, $s0, 2		# $s0 = index * 4
	la	$t0, roadTable		# load base address of jump table to $t0
	add	$s0, $s0, $t0		# $s0 is now the address of jump label
	lw 	$s0, ($s0)		# load the target address
	jr	$s0			# jump to the label
	
	# road event 1
	R1:	la	$a0, road1	# load text for event
		input_dialog_int	# print and get response in $a0
		lw	$t1, two4				# load 2 to $t1
		beq	$a1, $t1, cancelSelected		# user selected cancel, exit program
		
		bgtz	$a0, R11	# did user pick option 0 or 1
		la	$a0, road10	# chose 0 prompt event
		la	$a1, 2
		print_msg		# print syscall
		jr	$ra		# go back to main story
		
		R11:	la	$a0, road11	# user chose 1 so prompt event
			la	$a1, 2
			print_msg		# print syscall
			jr	$ra		# go back to main story
	
	# road event 2
	R2:	la	$a0, road2	# load text for event
		input_dialog_int	# print and get response in $a0
		lw	$t1, two4				# load 2 to $t1
		beq	$a1, $t1, cancelSelected		# user selected cancel, exit program
		
		bgtz	$a0, R21	# did user pick option 0 or 1
		la	$a0, road20	# chose 0 prompt event
		la	$a1, 2
		print_msg		# print syscall
		la	$a0, road20cont	# long text print twice
		la	$a1, 2
		print_msg
		jr	$ra		# go back to main story
		
		R21:	la	$a0, road21	# user chose 1 so prompt event
			la	$a1, 2
			print_msg		# print syscall
			jr	$ra		# go back to main story
			
	# road event 3
	R3:	la	$a0, road3	# load text for event
		input_dialog_int	# print and get response in $a0
		lw	$t1, two4				# load 2 to $t1
		beq	$a1, $t1, cancelSelected		# user selected cancel, exit program
		
		bgtz	$a0, R31	# did user pick option 0 or 1
		la	$a0, road30	# chose 0 prompt event
		la	$a1, 2
		print_msg		# print syscall
		jr	$ra		# go back to main story
		
		R31:	la	$a0, road31	# user chose 1 so prompt event
			la	$a1, 2
			print_msg		# print syscall
			jr	$ra		# go back to main story
	
	# road event 4
	R4:	la	$a0, road4	# load text for event
		la	$a1, 2
		print_msg		# print first half of event
		la	$a0, road4cont	# load second half of event and get response
		input_dialog_int	# print and get response in $a0
		lw	$t1, two4				# load 2 to $t1
		beq	$a1, $t1, cancelSelected		# user selected cancel, exit program
		
		bgtz	$a0, R41	# did user pick option 0 or 1
		la	$a0, road40	# chose 0 prompt event
		la	$a1, 2
		print_msg		# print syscall
		la	$a0, road40cont
		la	$a1, 2
		print_msg
		jr	$ra		# go back to main story
		
		R41:	la	$a0, road41	# user chose 1 so prompt event
			la	$a1, 2
			print_msg		# print syscall
			la	$a0, road41cont
			la	$a1, 2
			print_msg
			jr	$ra		# go back to main story
	
	# road event 5
	R5:	la	$a0, road5	# load text for event
		la	$a1, 2
		print_msg		# print first half of event
		la	$a0, road5cont	# load second half of event and get response
		input_dialog_int	# print and get response in $a0
		lw	$t1, two4				# load 2 to $t1
		beq	$a1, $t1, cancelSelected		# user selected cancel, exit program
		
		bgtz	$a0, R51	# did user pick option 0 or 1
		la	$a0, road50	# chose 0 prompt event
		la	$a1, 2
		print_msg		# print syscall
		la	$a0, road50cont
		la	$a1, 2
		print_msg
		jr	$ra		# go back to main story
		
		R51:	la	$a0, road51	# user chose 1 so prompt event
			la	$a1, 2
			print_msg		# print syscall
			la	$a1, 2
			la	$a0, road51cont
			print_msg
			jr	$ra		# go back to main story	
	
###########################################################
#     End of Road Events
###########################################################

###########################################################
#	GameOver Defeat
###########################################################
	.data
battleDefeat:		.ascii		"You have been defeated in battle!\n"
			.asciiz		"GAMEOVER!!"
			
	.text
gameover:
	la	$a0, battleDefeat		# load defeat message
	la	$a1, 0				# error message
	print_msg
	exit
	
###########################################################
# 	End of Gameover from defeat
###########################################################

###########################################################
#	GameOver on cancel
###########################################################
	.data
selectCancel:		.ascii		"You have selected cancel, leaving the game."

	.text
cancelSelected:
	la	$a0, selectCancel
	la	$a1, 2
	print_msg
	exit
###########################################################
# 	End of Gameover on cancel
###########################################################

