	.ORIG	X3000

	AND	R0, R0, #0
	LEA	R7, Read
	ST	R7, invR7
Read	LEA	R0, ToH
	PUTS
	GETC	
	LD	R2, int0
	ADD	R1, R0, R2
	BRn	INVALID
	LD	R2, int9
	ADD	R1, R0, R2
	BRp	INVALID
;; Turning value into a number
	OUT
	ST	R0, PrnV
	LD	R2, int0
	ADD	R0, R0, R2
	ST	R0, Count ;;Stores value
;; Printing Instruction message
	LEA	R0, Inst
	PUTS
	LD	R0, PrnV
	OUT
	LEA	R0, Inst2
	PUTS
;; Loading Disk count and  inital post locations
	LD	R0, Count
	AND	R1, R1, #0
	ADD	R1, R1, #1 ;; Start post
	AND	R2, R2, #0
	ADD	R2, R2, #3 ;; End post
	AND	R3, R3, #0
	ADD	R3, R3, #2 ;; Mid Post
	LD	R5, BtmStk
	LD	R6, BtmStk
	LEA	R7, #2
	ST	R7, True7
	JSR MvDisk
	BRnzp DONE



DONE	HALT


ToH	.STRINGZ "--Towers of Hanoi--\nHow many disks? "
inv	.STRINGZ "\nInvalid value!\n"
invR7	.BLKW 1
Inst	.STRINGZ "\nInstructions to move "
Inst2	.STRINGZ " disks from post 1 to post 3:\n"
int0	.FILL	#-48
int9	.FILL	#-57
Count	.BLKW 1  ;; INT n
PrnV	.BLKW 1
Prn	.FILL	#48
BtmStk	.FILL	x4FFF
True7	.BLKW 1

;; Move Disk subroutine
MvDisk	ST	R0, R0Save
	ST	R4, R4Save 
	ADD	R4, R0, #-1
	BRz	OneDisk
	
;; Saving the Information to stack
	STR	R0, R6, #0
	ADD	R6, R6, #-1
	STR	R1, R6, #0
	ADD	R6, R6, #-1
	STR	R2, R6, #0
	ADD	R6, R6, #-1
	STR	R3, R6, #0
	ADD	R6, R6, #-1
	STR	R7, R6, #0
	ADD	R6, R6, #-1
;; Swapping R2 and R3, (End post and mid post)
	ADD	R0, R0, #-1 ;; Decreasing disk number by 1
	AND	R4, R4, #0 
	ADD	R4, R2, R4 ;; Adding R2 (initally end post) to R4
	AND	R2, R2, #0
	ADD	R2, R3, R2 ;; Adding R3 (initally mid post) to R2 (initally end post)
	AND	R3, R3, #0
	ADD	R3, R4, R3 ;; Adding R4 (R2) to R3 (initally mid post)
;; first recurrsive step
	JSR	MvDisk
;; Returning information from stack
	ADD	R6, R6, #1	
	LDR 	R7, R6, #0
	ADD	R6, R6, #1	
	LDR 	R3, R6, #0
	ADD	R6, R6, #1	
	LDR 	R2, R6, #0
	ADD	R6, R6, #1	
	LDR 	R1, R6, #0
	ADD	R6, R6, #1	
	LDR 	R0, R6, #0
;; Printing message
	ST	R0, R0Save
	ST	R7, R7Save
	LEA	R0, Disks
	PUTS
	LD	R4, Prn
	LD	R0, R0Save
	ADD	R0, R4, R0
	OUT
	LEA	R0, Disks2
	PUTS
	ADD	R0, R1, R4
	OUT
	LEA	R0, Disks3
	PUTS
	ADD	R0, R2, R4
	OUT
	LEA	R0, Fin
	PUTSP
	LD	R0, R0Save
	LD	R7, R7Save
;; Readding information to stack
	STR	R0, R6, #0
	ADD	R6, R6, #-1
	STR	R1, R6, #0
	ADD	R6, R6, #-1
	STR	R2, R6, #0
	ADD	R6, R6, #-1
	STR	R3, R6, #0
	ADD	R6, R6, #-1
	STR	R7, R6, #0
	ADD	R6, R6, #-1
;; Swapping R1 and R3, (Start post and mid post)
	ADD	R0, R0, #-1 ;; Decreasing disk number by 1
	AND	R4, R4, #0 
	ADD	R4, R1, R4 ;; Adding R2 (initally end post) to R4
	AND	R1, R1, #0
	ADD	R1, R3, R1 ;; Adding R3 (initally mid post) to R2 (initally end post)
	AND	R3, R3, #0
	ADD	R3, R4, R3 ;; Adding R4 (R2) to R3 (initally mid post)
;; second recurrsive step
	JSR	MvDisk
;; Returning information from stack
	ADD	R6, R6, #1	
	LDR 	R7, R6, #0
	ADD	R6, R6, #1	
	LDR 	R3, R6, #0
	ADD	R6, R6, #1	
	LDR 	R2, R6, #0
	ADD	R6, R6, #1	
	LDR 	R1, R6, #0
	ADD	R6, R6, #1	
	LDR 	R0, R6, #0
	RET
;; Return	
	BRnzp	Finish
;; =< 1 disk
OneDisk	ST	R0, R0Save
	ST	R7, R7Save
	LEA	R0, Disks
	PUTS
	LD	R4, Prn
	LD	R0, R0Save
	ADD	R0, R4, R0
	OUT
	LEA	R0, Disks2
	PUTS
	ADD	R0, R1, R4
	OUT
	LEA	R0, Disks3
	PUTS
	ADD	R0, R2, R4
	OUT
	LEA	R0, Fin
	PUTSP
	LD	R0, R0Save
	LD	R7, R7Save
	RET

Finish	LD	R4, R4Save
	LD	R7, True7
	RET


INVALID	OUT
	LEA 	R0, inv
	PUTS
	LD	R7, invR7
	RET

R7Save	.BLKW 1
Disks	.STRINGZ "Move disk "
Disks2	.STRINGZ " from post "
Disks3	.STRINGZ " to post "
Fin	.STRINGZ ".\n"
R0Save	.BLKW 1
R4Save	.BLKW 1

	.END