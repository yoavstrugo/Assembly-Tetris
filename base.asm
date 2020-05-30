IDEAL
MODEL small
P386
STACK 100h
DATASEG

blockPlaceholderArray db 100 dup(?)

; Colors 
colors 	dw 0h	; BG  
		dw 07h	; L
		dw 10h	; J
		dw 0Dh 	; S
		dw 13h 	; I
		dw 16h	; Z
		dw 19h	; O
		dw 0Ah	; T
		dw '#'  ; Border
		dw 1Ch  ; Unsaturated 



screen	 	db 252 dup(0)				

gameFieldBuffer db 36 dup(?)

gameField 	db 252 dup(0)

;gameField 	db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8
;			db 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8


;======= Game Field Constants =======
	gameFieldBufferHeight equ 3
	gameFieldWidth equ 12 ; (Including 2 borders)
	gameFieldHeight equ 21 ; (Including 1 border)
	gameFieldX equ 90
	gameFieldY equ 0
	gameFieldLength equ 252

tetrominoes		db 	0, 	1, 	0, 	0
				db	0, 	1,	0, 	0
				db	0, 	1,	1, 	0
				db	0, 	0,	0,	0 ; L

				db 	0, 	0, 	1, 	0
				db	0, 	0,	1, 	0
				db	0, 	1,	1, 	0
				db	0, 	0,	0,	0 ; J

				db 	0, 	0, 	0, 	0
				db	0, 	1,	1, 	0
				db	1, 	1,	0, 	0
				db	0, 	0,	0,	0 ; S

				db 	0, 	1, 	0, 	0
				db	0, 	1,	0, 	0
				db	0, 	1,	0, 	0
				db	0, 	1,	0,	0 ; I

				db 	0, 	0, 	0, 	0
				db	0, 	1,	1, 	0
				db	0, 	0,	1, 	1
				db	0, 	0,	0,	0 ; Z

				db 	0, 	0, 	0, 	0
				db	0, 	1,	1, 	0
				db	0, 	1,	1, 	0
				db	0, 	0,	0,	0 ; O

				db 	0, 	0, 	0, 	0
				db	0, 	1,	1, 	1
				db	0, 	0,	1, 	0
				db	0, 	0,	0,	0 ; T


;======= Current Tetromino State =======
	tetrominoX dw 6
	tetrominoY dw -3
	tetrominoRotation dw 0 ; 0 = 0º, 1 = 90º, 2 = 180º, 3 = 270º,....
	tetrominoID dw 3 ; 1 = L, 2 = J, 3 = S, 4 = I, 5 = Z, 6 = O, 7 = T
	canRotate db 1 ; 1 = true, 0 = false


BlockSize equ 10
backgroundColor equ 0h

;======= Random =======
	LCGa equ 65535 ; 2^16-1
	LCGc equ 1
	LCGm equ 32767 ; 2^15-1
	prevX dw 1

;======= Game Vars =======
	gameSpeed db 10
	pieceCount dw 0
	gameSpeedCount db 0
	linesToRemove db 4 dup('-')
	pieceToIncreaseDiff db 5
	score dw 0

;====== Numbers =======
 numbers 	db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh

					db 03h, 03h, 1Fh, 1Fh, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 1Fh, 1Fh, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 03h, 03h, 03h, 03h, 1Fh, 1Fh, 03h, 03h, 03h
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh

					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh

					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh

					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh

 					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
 					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
 					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
 					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
 					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
 					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
 					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
 					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
 					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
 					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
 					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
 					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
 					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					 
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 03h, 03h
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh

					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh

					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh

					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh
					db 03h, 03h, 03h, 03h, 03h, 03h, 03h, 1Fh, 1Fh

;======= Text =======
cursor db 18 dup(1Fh)
cursorOff db 18 dup(03h)
showCursor db 1
cursorBlinkCount db 0
cursorBlinkSpeed db 9 


;======= Files =======
	paletteImg db 'palette.bmp', 0
	bgImg db 'gameBG.bmp',0
	openingScreen db 'openScrn.bmp',0
	pressSpace db 'prsSpc.bmp', 0
	filehandle dw ?
	Header db 54 dup (0)
	Palette db 256*4 dup (0)
	ScrLine db 320 dup (0)

;======= Errors =======
	fileNotFoundError db 'Error| File not found.', 13, 10 ,'$'
	pathDoesntExistError db 'Error| Path does not exist.', 13, 10, '$'
	noHandleAvailableError db 'Error| No handle available (too many files).', 13, 10 ,'$'
	accessDeniedError db 'Error| Access denied.', 13, 10, '$'
	accessCodeInvalidError db 'Error| Access code invalid.', 13, 10 ,'$'
	invalidHandleError db 'Error| Invalid handle or not open', 13, 10, '$'
	otherError db 'Error| There was an error', 13, 10, '$'

;======= Keys =======
	spaceDownKey equ 039h
	spaceUpKey equ 0B9h
	escKey equ 1h

	leftKey equ 4Bh
	rightKey equ 4Dh
	downKey equ 50h

	number db 12
	ten db 10

CODESEG
include "file.asm"
; Prints the error. (INT 21) 
; @param errorCode The error code you want to print
proc Error
	; Save BP
	push bp

	; Get access to the stack
	mov bp, sp

	errorCode equ [byte ptr bp+4]

	cmp errorCode, 2
	jmp FileNotFoundErrorLabel

	cmp errorCode, 3
	jmp PathDoesntExistErrorLabel

	cmp errorCode, 4
	jmp NoHandleAvailableErrorLabel

	cmp errorCode, 5
	jmp AccessDeniedErrorLabel

	cmp errorCode, 6
	jmp InvalidHandleErrorLabel

	cmp errorCode, 12
	jmp AccessCodeInvalidErrorLabel

	jmp OtherErrorLabel

	;2
	FileNotFoundErrorLabel:
		mov dx, offset fileNotFoundError ; Set error
		jmp PrintError
	;3
	PathDoesntExistErrorLabel:
		mov dx, offset pathDoesntExistError ; Set error
		jmp PrintError
	;4
	NoHandleAvailableErrorLabel:
		mov dx, offset noHandleAvailableError ; Set error
		jmp PrintError
	;5
	AccessDeniedErrorLabel:
		mov dx, offset accessDeniedError ; Set error
		jmp PrintError
	;6
	InvalidHandleErrorLabel:
		mov dx, offset invalidHandleError ; Set error
		jmp PrintError
	;12
	AccessCodeInvalidErrorLabel:
		mov dx, offset accessCodeInvalidError ; Set error
		jmp PrintError
	; Other - not set
	OtherErrorLabel:
		mov dx, offset otherError ; Set error
		jmp PrintError

	PrintError:
		mov ah, 9h
		int 21h	; Display error

	pop bp
	ret 2
endp Error

; Open a file and moves it into the file handle.
; @param fileName The name od the file
; @param fileHandle The file handle
proc OpenFile
	; Save BP
	push bp

	; Get access to the stack
	mov bp, sp

	; Save all registers
	pusha
	
	; Get parameters
	mov dx, [bp+6] 
	mov si, [bp+4] ; File handler

	; Open the given file
	mov cx, 0
	mov ah, 3Dh	; Open file
	xor al, al	; We want to read the file
	int 21h		; DOS interupt

	; If there was an error then CF will turn on
	jc @@OpenError

	; Move the file to the fileHandle variable
	mov [si], ax

	popa
	pop bp
	ret 4

	@@OpenError:
		push ax
		call Error
			
		popa
		pop bp
		ret 4
endp OpenFile

; Close the current open file in the file handle
; @param fileHandle The file handle
proc CloseFile
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	; Save all registers
	pusha

	mov ah,3Eh ; Close file
	mov bx, [bp+4] ; The file handler
	int 21h
	
	popa
	pop bp
	ret 2
endp CloseFile

; Reads the header of a bmp file.	
; @param fileHandle The file handle
; @param headerOutput Where to store the header		
proc ReadHeader
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	; Save all registers
	pusha

	mov si, [bp+6]
	headerVar equ [bp+4]

	; Read BMP file header, 54 bytes
	mov ah,3fh
	mov bx, [si]
	mov cx,54
	mov dx, headerVar
	int 21h	
	
	; Retrive registers
	popa
	pop bp

	; If there was an error then CF will turn on
	jc @@OpenError
	ret 4

	@@OpenError:
		push ax ; Push the error code
		call Error
		
		ret	4
endp ReadHeader

; Reads the palette of a bmp file.	
; @param fileHandle The file handle
; @param paletteOutput Where to store the palette
proc ReadPalette
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	; Save all registers
	pusha

	; Get parameters
	mov si, [bp+6] ; filehandle
	paletteVar equ [bp+4] ; Palette holder

	; Read BMP file color palette, 256 colors * 4 bytes (400h)
	mov ah,3fh
	mov cx,400h
	mov bx, [si]
	mov dx, paletteVar
	int 21h

	; Retrive registers
	popa
	pop bp

	; If there was an error then CF will turn on
	jc @@OpenError
	ret 4

	@@OpenError:
		push ax ; Push the error code
		call Error
		
		ret	4
endp ReadPalette

; Copies a palette to the video memory.
; @param fileHandle The file handle.
; @param palette The palette.
proc CopyPal
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	; Save all registers
	pusha

	; Get parameters
	mov di, [bp+6] ; filehandle
	paletteVar equ [bp+4] ; Palette holder

	; The number of the first color should be sent to port 3C8h
	; The palette is sent to port 3C9h
	mov bx, [di]
	mov si, paletteVar
	mov cx,256
	mov dx,3C8h
	mov al,0
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h
	inc dx
	PalLoop:
		; Note: Colors in a BMP file are saved as BGR values rather than RGB .
		mov al,[si+2] ; Get red value .
		shr al,2 ; Max. is 255, but video palette maximal
		; value is 63. Therefore dividing by 4.
		out dx,al ; Send it .
		mov al,[si+1] ; Get green value .
		shr al,2
		out dx,al ; Send it .
		mov al,[si] ; Get blue value .
		shr al,2
		out dx,al ; Send it .
		add si,4 ; Point to next color .
		; (There is a null chr. after every color.)
		loop PalLoop
		
	; Retrive registers
	popa
	pop bp
	ret 4
endp CopyPal

; Copies a bmp image to the screen.
; @param width The width of the image.
; @param height The height of the image.
; @param xPos Where to print the image on the X axis.
; @param yPos Where to print the image on the Y axis.
; @param fileHandle The file handle.
; @param palette The palette.
proc CopyBitmap
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	; Save all registers
	pusha
	
	; Get parameters
	mov si, [bp+6]
	mov bx, [si] ; filehandle
	
	xPos equ [bp+10]
	;yPos equ [bp+8]

	imageWidth equ [bp+14]
	imageHeight equ [bp+12]

	scrLineVar equ [bp+4]

	; BMP graphics are saved upside-down .
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.

	mov ax, 0A000h
	mov es, ax

	yPos equ dx
	mov yPos, [bp+8]

	mov cx,imageHeight
	;dec cx
	PrintBMPLoop:
		push cx
		push yPos

		; di = cx*320, point to the correct screen line
		mov di,yPos
		shl yPos,6
		shl di,8
		add di,yPos
		add di, xPos

		; Read one line
		mov ah,3fh
		mov cx, imageWidth
		mov dx, scrLineVar
		int 21h

		jc @@OpenError
		; Copy one line into video memory
		cld ; Clear direction flag, for movsb
		mov cx,imageWidth
		dec cx
		mov si, scrLineVar
		rep movsb ; Copy line to the screen

		pop yPos
		dec yPos
		pop cx
		loop PrintBMPLoop

	; Retrive registers
	popa
	pop bp
	ret 12

	@@OpenError:
		push ax ; Push the error code
		call Error
	popa
	pop bp
	ret 8
endp CopyBitmap

; Draw an array.
; @param array The array you want to draw (matrix).
; @param arrayWidth The width of the array.
; @param arrayHeight The height of the array.
; @param xPos Where to start drawing the array on the X axis.
; @param yPos Where to start drawing the array on the Y axis.
proc Draw
	push bp
	mov bp, sp
	pusha

	mov di, [bp+12]

	mov cx, [bp+8] ; The horizontal length
	DrawVerticalLoop:
		push cx
		push [word ptr bp+6]
		mov cx, [bp+10] ; The horizontal length
		DrawHorizontalLoop:
			push cx

			mov bh, 0h;
			mov al, [di] ; The color pixel to draw
			mov cx, [bp+6] ; X
			mov dx, [bp+4] ; Y
			mov ah, 0ch

			int 10h

			mov ax, [bp+6]
			inc ax
			mov [bp+6], ax

			inc di
			pop cx
			loop DrawHorizontalLoop
		
		inc [word ptr bp+4]
		pop [word ptr bp+6]
		pop cx
		loop DrawVerticalLoop

	popa
	pop bp
	ret 10
endp Draw

; Returns the new index of a rotated cell in 4x4 matrix.
; @param xPos The X position of the cell (in relation to the matrix).
; @param yPos The Y position of the cell (in relation to the matrix).
; @param rotations How many rotation
; @ret ax=newIndex
proc Rotate
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	; Save used registers
	push bx

	; Get parameters
	x equ [bp+8]
	y equ [bp+6]
	rotations equ [bp+4]

	; There are only 4 possible rotations,
	; therefore we dot rotations % 4
	mov ax, rotations
	mov bl, 4
	div bl 
	; ah = rotations % 4
	cmp ah, 0
	je @@case0
	cmp ah, 1
	je @@case1
	cmp ah, 2
	je @@case2
	cmp ah, 3
	je @@case3
	xor al, al ; return 0
	jmp @@Finish

	@@case0:
		; i = y * width + x
		mov ax, y
		mov bl, 4 ; width
		mul bl ; ax/al = y * width
		add al, x 
		jmp @@Finish
	@@case1:
		; i = 12 + y - (x*width)
		mov ax, x
		mov bl, 4 ; width
		mul bl ; ax/al = x*width
		mov bx, 12
		add bx, y ; bx/bl = 12+y
		sub bx, ax ; bx/bl = i
		mov ax, bx
		jmp @@Finish
	@@case2:
		; i = 15 - (y*width) - x
		mov ax, y
		mov bl, 4 ; width
		mul bl ; ax/al = y*width
		mov bx, 15
		sub bx, ax ; bx/bl = 15 - (y*width)
		sub bx, x ; bx/bl = 15 - (y*width)-x
		mov ax, bx
		jmp @@Finish
	@@case3:
		; i = 3 - y+ (x*width)
		mov ax, x
		mov bl, 4 ; width
		mul bl ; ax/al = x*width
		mov bx, 3
		sub bx, y ; bx/bl = 3 - y
		add bx, ax  ; bx/bl = 3 - y + (x*width)
		mov ax, bx
		jmp @@Finish

	@@Finish:
	pop bx
	pop bp
	ret 6
endp Rotate

; Fills a blocks array with it's colors
; @param hightlightColor The color of the highlight of the block
; @param array The array of the block (square)
; @param size The size of the array (N)
proc FillBlock
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	; Save all registers
	pusha

	mov di, [bp+6]
	array equ di

	mov dx, [bp+8]
	color equ dl

	N equ [bp+4]

	xor bx, bx
	index equ bx

	push index
	mov cx, N
	dec cx
	@@HighlightLoop:
		mov [array + index], color ; arr[i] = highlight

		mov al, N
		mul bl ; i * N
		mov si, ax
		add si, array 
		mov [si], color ; arr[i*N] = highlight

		inc index ; i++
		loop @@HighlightLoop
	pop index

	cmp color, backgroundColor
	je @@SkipColor1 ; If background
	inc color

	@@SkipColor1:
	push index
	mov cx, N
	sub cx, 2
	@@NormalLoopI:
		push cx
		mov cx, N
		sub cx, 2
		mov si, 0
		jIndex equ si
		@@NormalLoopJ:
			
			mov al, N
			mul bl ; ax = i*N
			add ax, jIndex ; ax = i*N + j
			push jIndex
			mov si, ax
			inc si
			add si, N

			add si, array
			mov [si], color
			pop jIndex
			inc jIndex
			loop @@NormalLoopJ
		inc index
		pop cx
		loop @@NormalLoopI
	pop index

	cmp color, backgroundColor
	je @@SkipColor2 ; If background
	inc color

	@@SkipColor2:
	mov cx, N
	@@ShadowLoop:
		mov al, N
		mul bl ; ax = i*N
		add ax, N
		dec ax ; ax = N-1 +i*N
		mov si, ax
		add si, array
		mov [si], color

		xor ax, ax ; reset ax
		mov al, N
		dec al
		mov ah, N
		mul ah ; ax = N(N-1)
		add ax, index ; ax = N(N-1) + i
		mov si, ax
		add si, array
		mov [si], color
		inc index
		loop @@ShadowLoop

	popa
	pop bp
	ret 6
endp FillBlock

; Initiallizes the background image. (Static)
proc InitiallizeBackgroundImage
	; Load Background
	push offset bgImg
	push offset filehandle
	call OpenFile

	push offset filehandle
	push offset Header
	call ReadHeader

	push offset filehandle
	push offset Palette
	call ReadPalette

	push 320
	push 200
	push 0
	push 199
	push offset filehandle
	push offset ScrLine
	call CopyBitmap

	push offset filehandle
	call CloseFile
	ret
endp InitiallizeBackgroundImage

; Initiallizes the color palette of the game. (Static)
proc InitiallizeGamePalette
	; Load the games color palette

	push offset paletteImg
	push offset filehandle
	call OpenFile

	push offset filehandle
	push offset Header
	call ReadHeader

	push offset filehandle
	push offset Palette
	call ReadPalette

	push offset filehandle
	push offset Palette
	call CopyPal

	push offset filehandle
	call CloseFile
	ret
endp InitiallizeGamePalette

; Initiallizes the game field array. (Static)
proc InitiallizeGameField
	pusha
	
	index equ di
	xor index, index

	x equ bx
	xor x, x

	y equ dx
	xor y, y

	; Initiallize game field
	mov cx, gameFieldHeight
	@@VerticalLoop:
		push cx
		mov cx, gameFieldWidth
		@@HorizontalLoop:
			cmp x, 0
			je @@Border

			mov si, x
			inc si
			cmp si, gameFieldWidth ; if x+1 is the edge then put border
			je @@Border

			mov si, y
			inc si
			cmp si, gameFieldHeight ; if y+1 is the bottom then put border
			je @@Border

			jmp @@Next
			@@Border:
				; put border
				; get the index: (y*width)+x

				xor ax, ax
				mov al, gameFieldWidth
				mul dl ; ax = (y*width)
				add ax, x ; ax = (y*width)+x
				mov index, ax

				mov [gameField + index], 8

			@@Next:
			inc x
			loop @@HorizontalLoop
		xor x, x
		inc y
		pop cx
		loop @@VerticalLoop

	popa
	ret
endp InitiallizeGameField

; Initiallizes the PRNG, sets x0 (Static)
proc InitiallizeRandom
	pusha 

	; Set pseudo-random x0
	mov ax, 40h
	mov es, ax
	mov ax, [es:6Ch]
	and al, 11111111b ; Get a number between 0-255
	xor ah, ah
	mov [prevX], ax

	popa
	ret
endp InitiallizeRandom

; Renders the screen array. (Static)
proc Render
	pusha

	index equ di
	xor index, index

	x equ bx
	xor x, x

	y equ dx
	xor y, y

	mov cx, gameFieldHeight
	@@VerticalLoop:
		push cx
		mov cx, gameFieldWidth
		push x		
		@@HorizontalLoop:
			; get the index: (y*width)+x

			mov ax, gameFieldWidth
			mul dl ; ax = (y*width)
			add ax, x ; ax = (y*width)+x
			mov index, ax
			mov al, [screen+index] ; get the color at that position in game field

			cmp al, '#'
			je @@Next

			xor ah, ah
			; Fill the block
			push ax
			push offset blockPlaceholderArray
			push 10
			call FillBlock

			; Draw it

			push bx ; bx is used here so save it

			push offset blockPlaceholderArray
			push 10 ; width
			push 10 ; height
			; get X relative to screen
			; (x * 10) + startX
			mov ax, x
			mov bl, 10
			mul bl ; ax = x * 10
			add ax, gameFieldX
			push ax ; x
			; get Y relative to screen
			; (y * 10) + startY
			mov ax, y
			mov bl, 10
			mul bl ; ax = y * 10
			add ax, gameFieldY
			push ax ; y

			call Draw

			pop bx ; retrive bx
			@@Next:
			inc x
			loop @@HorizontalLoop
		inc y
		pop x
		pop cx
		loop @@VerticalLoop

	popa
	ret
endp Render

; Checks if a tetromino fits in a given position.
; @param pieceID The ID of the piece.
; @param pieceRotation The rotation of the piece.
; @param tetrominoX The X position of the piece.
; @param tetrominoY The Y position of the piece.
; @ret ax=0-false,1-true
proc DoesPieceFit
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	tetrominoIDLocal equ [word ptr bp+10]
	tetrominoRotationLocal equ [word ptr bp+8]
	tetrominoXLocal equ [word ptr bp+6]
	tetrominoYLocal equ [word ptr bp+4]

	pieceX equ bx
	xor pieceX, pieceX

	pieceY equ dx
	xor pieceY, pieceY 

	mov cx, 4 ; The height of the tetromino array
	@@VerticalLoop:
		push pieceX 
		push cx ; Save cx
		mov cx, 4 ; The width of the tetromino array
		@@HorizontalLoop:
			; Get index into piece (including rotation)
			push pieceX
			push pieceY
			push tetrominoRotationLocal
			call Rotate ; puts in ax

			indexInPiece equ di
			mov indexInPiece, ax

			; Get index into game field
			; (tetrominoY + pieceY) * gameFieldWidth + (tetrominoX + pieceX)
			mov ax, tetrominoYLocal
			add ax, pieceY
			push bx

			mov bl, gameFieldWidth
			mul bl ; ax = (tetrominoY + pieceY) * gameFieldWidth

			pop bx
			add ax, tetrominoXLocal
			add ax, pieceX ; ax = (tetrominoY + pieceY) * gameFieldWidth + (tetrominoX + pieceX)

			indexInField equ si
			mov indexInField, ax

			; Check bounds
			; Check for x
			mov ax, tetrominoXLocal
			add ax, pieceX
			cmp ax, 0
			jb @@Next

			cmp ax, gameFieldWidth
			ja @@Next

			; Check for y
			mov ax, tetrominoYLocal
			add ax, pieceY
			cmp ax, 0
			jb @@Next

			cmp ax, gameFieldHeight
			ja @@Next

			; Check collision
			push bx ; we use bx here so save it

			xor ax, ax
			push tetrominoIDLocal
			call GetPieceOffset ; bx = offset from array
			cmp [tetrominoes + bx + indexInPiece], 1
			jne @@NoBlockInPieceIndex
			mov ax, 1

			@@NoBlockInPieceIndex:
			pop bx ; retrive bx

			cmp ax, 1
			jne @@Next ; if there isn't a block then we dont need to check

			; Check if there's something in the field at the same place
			cmp [gameField + indexInField], 0
			je @@Next ; There's nothing in that place 

			mov ax, 0 ; The piece is colliding
			; Organize stack
			pop cx ; Retrive CX
			pop pieceX

			pop bp
			ret 8

			@@Next:
			inc pieceX
			loop @@HorizontalLoop
		inc pieceY
		pop cx ; Retrive CX
		pop pieceX

		loop @@VerticalLoop

	mov ax, 1 ; By default, we want to return true
	pop bp
	ret 8
endp DoesPieceFit

; Get the color from the piece id.
; @param pieceID The ID of the piece.
; @ret ax=color
proc GetPieceColor
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp
	
	; Save used registers
	push bx

	pieceID equ [bp+4]

	xor ax, ax
	mov ax, pieceID
	mov bl, 2
	mul bl

	; ax = index of color relative to color arr
	mov bx, ax ; ax cant access memory
	mov ax, [colors+bx] ; put the color in ax

	pop bx
	pop bp
	ret 2
endp GetPieceColor

; Get the offset (relative to array) of the piece
; @param pieceID The ID of the piece.
; @ret bx=offset
proc GetPieceOffset
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	; Save used registers
	push ax

	pieceID equ [word ptr bp+4]
	dec pieceID ; The tetrominoes array is 1 off

	mov ax, pieceID
	mov bl, 16
	mul bl
	mov bx, ax ; we cant access the memory with ax

	pop ax
	pop bp
	ret 2
endp GetPieceOffset

; Get the offset (relative to array) of the cell.
; @param array The array of the cell.
; @param arrayWidth The width of the array.
; @param xPos The X position of the cell (relative to the array).
; @param yPos The Y position of the cell (relative to the array).
; @ret bx=index
proc GetCellOffset
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	; Save used registers
	push ax

	; Get parameters
	arrayOffset equ [bp+10]
	widthh equ [bp+8]
	x equ [bp+6]
	y equ [bp+4]

	mov ax, y
	mov bx, widthh
	mul bl ; ax = y * width

	add ax, x ; ax = y * width + x
	add ax, arrayOffset
	mov bx, ax ; we return it in bx

	pop ax
	pop bp
	ret 8
endp GetCellOffset

; Draws the current piece into the screen array. (Static)
proc DrawCurrentPiece
	pusha

	pieceX equ di
	xor pieceX, pieceX 
	pieceY equ si
	xor pieceY, pieceY

	mov cx, 4
	@@VerticalLoop:
		push cx
		push pieceX 
		mov cx, 4
		@@HorizontalLoop:
			push [tetrominoID]
			call GetPieceOffset ; the result is in bx

			push pieceX
			push pieceY
			push [tetrominoRotation]
			call Rotate ; the result is in ax

			add bx, ax

			cmp [tetrominoes + bx], 0
			je @@Next

			mov ax, [tetrominoY]
			add ax, pieceY
			mov bl, gameFieldWidth
			mul bl ; ax = (currentY + y) * width
			add ax, [tetrominoX]
			add ax, pieceX ; ax = (currentY + y) * width + (currentX + x)
			mov bx, ax ; cant access memory with ax

			push [tetrominoID]
			call GetPieceColor ; color is in ax

			mov [screen+bx], al

			@@Next:
			inc pieceX
			loop @@HorizontalLoop
		pop pieceX
		pop cx
		inc pieceY
		loop @@VerticalLoop

	popa
	ret
endp DrawCurrentPiece

; Draws the game field into the screen array.
proc DrawGameField
	pusha

	index equ di
	xor index, index

	mov cx, gameFieldLength
	@@ArrayLoop:
		pieceId equ bx
		mov bl, [gameField + index] ; get the id at that position

		push pieceId
		call GetPieceColor ; ax has the color

		color equ al

		mov [screen + index], color
		
		inc index
		loop @@ArrayLoop

	popa
	ret
endp DrawGameField

; Add the current piece to the game field so itll lock in place.
proc LockPieceInPlace
	pusha

	pieceX equ bx
	xor pieceX, pieceX
	pieceY equ dx
	xor pieceY, pieceY 
	mov cx, 4 ; The height of the tetromino array
	@@VerticalLoop:
		push pieceX 
		push cx ; Save cx
		mov cx, 4 ; The width of the tetromino array
		@@HorizontalLoop:
			; Get index into piece (including rotation)
			push pieceX
			push pieceY
			push [tetrominoRotation]
			call Rotate ; puts in ax
			indexInPiece equ di
			mov indexInPiece, ax

			; Get index into game field
			; (tetrominoY + pieceY) * gameFieldWidth + (tetrominoX + pieceX)
			mov ax, [tetrominoY]
			add ax, pieceY
			push bx
			mov bl, gameFieldWidth
			mul bl ; ax = (tetrominoY + pieceY) * gameFieldWidth
			pop bx
			add ax, [tetrominoX]
			add ax, pieceX ; ax = (tetrominoY + pieceY) * gameFieldWidth + (tetrominoX + pieceX)
			indexInField equ si
			mov indexInField, ax
			
			; Check if there's a block in the piece in that index
			push bx ; we use bx here so save it

			xor ax, ax
			push [tetrominoID]
			call GetPieceOffset ; bx = offset from array
			cmp [tetrominoes + bx + indexInPiece], 1
			pop bx ; retrive bx
			jne @@Next

			

			; Put the block in the field array
			mov ax, [tetrominoID]
			mov  [gameField + indexInField], al

			@@Next:
			inc pieceX
			loop @@HorizontalLoop
		inc pieceY
		pop cx ; Retrive CX
		pop pieceX
		loop @@VerticalLoop

	popa
	ret
endp LockPieceInPlace

; Get a random number in range.
; @param max The maximum of the random number (0-max).
; @ret ax=randomNumber
proc Random
	; Save BP
	push bp
	; Get access to the stack
	mov bp, sp

	push bx
	push dx

	max equ [bp+4]

	; Formula Xn+1 = (a*Xn+c) mod m
	mov ax, [prevX]
	mov bx, LCGa
	mul bx ; dx:ax = a*Xn

	add ax, LCGc ; ax = (a*Xn+c)
	jnc @@DontAddOne ; if the CF flag turns on then ax has a carry and 
					 ; we need to add one to dx
	inc dx

	@@DontAddOne:

	mov bx, LCGm
	div bx ; dx = (a*Xn+c) mod m

	mov ax, dx ; move the result to ax for later division

	mov [prevX], ax ; Set the previous X to this for the next time

	mov bx, max ; The result is in bl
	div bl ; ah = randNumber % rangeMax

	mov al, ah
	xor ah, ah ; move the result to al
	; the result is in ax because ah = 0

	pop dx
	pop bx

	pop bp
	ret 2
endp Random

; Check for full lines around the current piece. (Static)
proc CheckLines
	pusha
	
	pieceY equ di
	xor pieceY, pieceY
	mov cx, 4 ; The tetromino array height is 4
	@@PieceVerticalLoop:
		push cx
		mov bx, pieceY
		add bx, [tetrominoY] ; Y of block in the field
		mov ax, gameFieldHeight
		dec ax ; fieldHeight - 1

		cmp bx, ax
		jae @@Next ; Check if the block is in the field

		mov cx, gameFieldWidth
		sub cx, 2 ; fieldWidth - 2 (We dont want to check borders)
		fieldX equ si 
		mov fieldX, 1 ; start checking from 1 (We dont want to check borders)
		@@FieldCheckLinesLoop:
			mov ax, [tetrominoY]
			add ax, pieceY ; ax = tetrominoY + pieceY
			mov bl, gameFieldWidth
			mul bl ; ax = (tetrominoY + pieceY) * fieldWidth
			add ax, fieldX ; ax = (tetrominoY + pieceY) * fieldWidth + fieldX

			mov bx, ax ; cant access memory with ax
			cmp [gameField+bx], 0
			je @@DontRemove ; Theres an empty space in that row so we dont need to check it further
			
			inc fieldX
			loop @@FieldCheckLinesLoop
		
		; This row is full, need to remove it
		mov cx, gameFieldWidth
		sub cx, 2 ; fieldWidth - 2 (We dont want to check borders)
		mov fieldX, 1 ; start checking from 1 (We dont want to check borders)
		@@FieldRemoveLineLoop:
			mov ax, [tetrominoY]
			add ax, pieceY ; ax = tetrominoY + pieceY
			mov bl, gameFieldWidth
			mul bl ; ax = (tetrominoY + pieceY) * fieldWidth
			add ax, fieldX ; ax = (tetrominoY + pieceY) * fieldWidth + fieldX
		
			mov bx, ax ; cant access memory with ax
			mov [gameField+bx], 9 ; remove the block in that line
			
			inc fieldX
			loop @@FieldRemoveLineLoop

		; Mark the line for removal
		xor ax, ax
		mov ax, pieceY
		add ax, [tetrominoY] ; al = lineNumber
		mov [linesToRemove + pieceY], al

		jmp @@Next

		@@DontRemove:
		mov [linesToRemove + pieceY], '-'
		@@Next:
		pop cx
		inc pieceY
		loop @@PieceVerticalLoop

	popa
	ret
endp CheckLines

; Moves all the lines above the given line one down.
; @param lineNumber The line.
proc MoveLinesDown
	; Save bp
	push bp
	; Get access to stack 
	mov bp, sp

	pusha

	lineNumber equ [bp+4]

	x equ dx
	y equ si

	mov y, lineNumber
	mov x, 1

	mov cx, lineNumber ; Because y decrease as we go up, we want to do it lineNumber times
	@@VerticalLoop:
		push x
		push cx
		mov cx, gameFieldWidth
		sub cx, 2 ; We dont want to include the borders
		@@HorizontalLoop:
			; next line index formula: (y - 1) * width + x
			mov ax, y ; ax = y
			dec ax ; ax = y - 1
			mov bl, gameFieldWidth
			mul bl ; ax = (y - 1) * width
			add ax, x ; ax = (y - 1) * width + x
			mov di, ax ; cant access memory with ax

			; current line index formula: y * width + x
			mov ax, y ; ax = y
			mov bl, gameFieldWidth
			mul bl ; ax = y * width
			add ax, x ; ax = y * width + x
			mov bx, ax ; cant access memory with ax

			mov al, [gameField + di] ; put the value from the next line in ax

			mov [gameField + bx], al ; put this value in the current line

			inc x
			loop @@HorizontalLoop
		pop cx
		pop x
		dec y
		loop @@VerticalLoop

	popa
	pop bp
	ret 2
endp MoveLinesDown

; Print the score. (Static)
proc PrintScore
	; Save bp
	push bp
	; Get access to stack 
	mov bp, sp

	pusha
	
	xPos equ si
	mov xPos, 278 ; Starting position

	mov ax, [word ptr score]
	mov bx, 10
	mov cx, 5
	@@PrintLoop:	
		xor dx, dx
		div bx ; Modulo is in dx, division in ax

		push ax
		push bx

		; Draw dx
		mov ax, dx
		mov bl, 126 ; arr length
		mul bl
		add ax, offset numbers
		push ax
		push 9 ; width
		push 14 ; height
		push xPos ; X pos
		push 78 ; Y pos
		call Draw

		pop bx
		pop ax

		sub xPos, 11 ; The space between the numbers
		loop @@PrintLoop

	popa
	pop bp
	ret
endp PrintScore

start:
	mov ax, @data
	mov ds, ax
	call TestProc
	@@GameStart:

	mov ax, 13h
	int 10h ; Change to graphics mode
	
	; Load Background
	push offset openingScreen
	push offset filehandle
	call OpenFile

	push offset filehandle
	push offset Header
	call ReadHeader

	push offset filehandle
	push offset Palette
	call ReadPalette

	push offset filehandle
	push offset Palette
	call CopyPal

	push 320
	push 200
	push 0
	push 199
	push offset filehandle
	push offset ScrLine
	call CopyBitmap

	push offset filehandle
	call CloseFile

	; Open press space

	push offset pressSpace
	push offset filehandle
	call OpenFile

	push offset filehandle
	push offset Header
	call ReadHeader

	push offset filehandle
	push offset Palette
	call ReadPalette

	push offset filehandle
	push offset Palette
	call CopyPal

	push 156
	push 14
	push 83
	push 139
	push offset filehandle
	push offset ScrLine
	call CopyBitmap

	push offset filehandle
	call CloseFile
	jmp exit
	; Initiallize Game
	call InitiallizeBackgroundImage
	call InitiallizeGamePalette
	call InitiallizeGameField

	call InitiallizeRandom		

	push 7
	call Random
	add ax, 1
	mov [tetrominoID], ax

	@@GameLoop:

		@@Timing:
			;Before each loop we wait a certain time -> game tick
			xor al, al ; if al won't be 0 then this int will mess with the memory
			mov ah, 86h
			xor cx, cx
			mov dx, 0C350h 	; CX:DX microseconds (=1,000,000ths of a second)
			int 15h			; 0000C350h = 50,000 = 50ms

			; Increase speed count
			inc [gameSpeedCount]
			
		
		@@Input:
			cmp [tetrominoY], -1
			jl @@NothingPressed ; Cant move before the piece enters the field

			in al, 64h
			cmp al, 10b
			je @@NothingPressed
		
			;====== Space (Rotate) ======
				; If space is up
				in al, 60h
				cmp al, spaceUpKey
				jne @@NoSwap

				mov [canRotate], 1

				@@NoSwap:
				; If space is down
				in al, 60h
				cmp al, spaceDownKey
				jne @@NoRotate
				cmp [canRotate], 1
				jne @@NoRotate ; lock space so player need to release it before clicking again

				push [tetrominoID] ; Piece ID
				mov ax, [tetrominoRotation] ; Piece rotation
				add ax, 1
				push ax ; Rotation + 1
				push [tetrominoX]
				push [tetrominoY] ; Piece Y
				call DoesPieceFit ; ax = DoesPieceFit
				cmp ax, 1 ; Check if can move
				jne @@NoRotate

				inc [tetrominoRotation]
				mov [gameSpeedCount], 0

				mov [canRotate], 0

			@@NoRotate:
		
			;====== Arrows (Movement) ======
				; Left
					; Left arrow
					in al, 60h
					cmp al, leftKey
					jne @@NoLeft

					push [tetrominoID] ; Piece ID
					push [tetrominoRotation] ; Piece rotation
					mov ax, [tetrominoX]
					dec ax
					push ax ; Piece X - 1 (Left)
					push [tetrominoY] ; Piece Y

					call DoesPieceFit ; ax = DoesPieceFit

					cmp ax, 1 ; Check if can move
					jne @@NoLeft

					dec [tetrominoX]
					mov [gameSpeedCount], 0

				@@NoLeft:

					; Right arrow
					in al, 60h
					cmp al, rightKey
					jne @@NoRight

					push [tetrominoID] ; Piece ID
					push [tetrominoRotation] ; Piece rotation
					mov ax, [tetrominoX]
					inc ax
					push ax ; Piece X + 1 (Right)
					push [tetrominoY] ; Piece Y
					call DoesPieceFit ; ax = DoesPieceFit
					cmp ax, 1 ; Check if can move
					jne @@NoRight

					inc [tetrominoX]
					mov [gameSpeedCount], 0

				@@NoRight:

					; Down arrow
					in al, 60h
					cmp al, downKey
					jne @@NoDown

					push [tetrominoID] ; Piece ID
					push [tetrominoRotation] ; Piece rotation
					push [tetrominoX] ; Piece X
					mov ax, [tetrominoY]
					inc ax
					push ax ; Piece Y + 1 (Down)
					call DoesPieceFit ; ax = DoesPieceFit
					cmp ax, 1 ; Check if can move
					jne @@NoDown

					inc [tetrominoY]
					mov [gameSpeedCount], 0

				@@NoDown:

				;====== Escape (Exit) ======
					; If escape is pressed
					in al, 60h
					cmp al, escKey
					je exit

				@@NothingPressed:

		@@Logic:
			; Check if force down
			mov al, [gameSpeedCount]
			cmp al, [gameSpeed]
			jne @@AfterForceDown

			mov [gameSpeedCount], 0
			
			; Need to force down
			; first check if piece can go down
			push [tetrominoID] ; Piece ID
			push [tetrominoRotation] ; Piece rotation
			push [tetrominoX] ; Piece X
			mov ax, [tetrominoY]
			inc ax
			push ax ; Piece Y + 1 (Down)
			call DoesPieceFit ; ax = DoesPieceFit
			cmp ax, 1 ; Check if can move
			je @@ForceDown ; piece cant go down then it reached it's final position

			; Lock piece in place
			call LockPieceInPlace
			
			; Check for lines
			call CheckLines

			; Pick new piece
			mov [tetrominoX], 3
			mov [tetrominoY], -3

			push 7
			call Random
			add ax, 1

			mov [tetrominoID], ax
			mov [tetrominoRotation], 0

			inc [pieceCount]
			mov ax, [pieceCount]
			div [pieceToIncreaseDiff]
			cmp ah, 0 ; If the modulu is 0 then increase difficulty
			jne @@DontIncreaseDifficulty

			cmp [gameSpeed], 2
			jbe @@DontIncreaseDifficulty ; Dont make the game impossible

			dec [gameSpeed]; Increase difficulty

			@@DontIncreaseDifficulty:


			; If new piece doesn't fit then game over
			push [tetrominoID] ; Piece ID
			push [tetrominoRotation] ; Piece rotation
			push [tetrominoX] ; Piece X
			mov ax, [tetrominoY]
			inc ax
			push ax ; Piece Y + 1 (Down)
			call DoesPieceFit ; ax = DoesPieceFit
			cmp ax, 0
			je @@GameOver

			jmp @@AfterForceDown
			@@ForceDown:
				inc [tetrominoY]
				mov [gameSpeedCount], 0
			@@AfterForceDown:

		@@Render:
			; Cursor animation
			inc [cursorBlinkCount]
			mov al, [cursorBlinkCount]
			cmp al, [cursorBlinkSpeed]
			jne @@DontBlink
			mov [cursorBlinkCount], 0

			cmp [showCursor], 1
			jne @@HideCursor

			@@ShowCursor:
			push offset cursor
			push 9
			push 2
			push 289
			push 90
			call Draw
			mov [showCursor], 0
			jmp @@DontBlink

			@@HideCursor:
			push offset cursorOff
			push 9
			push 2
			push 289
			push 90
			call Draw
			mov [showCursor], 1 

			@@DontBlink:
			; Send game field to render
			call DrawGameField

			call DrawCurrentPiece

			; Check if there are any lines to remove
			pusha 
			mov cx, 4
			xor bx, bx
			@@LineRemoveCheckLoop:
				cmp [linesToRemove + bx], '-'
				jne @@RemoveLines; There are lines to remove
				inc bx
				loop @@LineRemoveCheckLoop
				jmp @@DontRemoveLines

			@@RemoveLines:
				; First, render the unstaurated bricks
				call Render

				; Wait a bit so the player will see the animation
				xor al, al ; if al won't be 0 then this int will mess with the memory
				mov ah, 86h
				mov cx, 0006h
				mov dx, 1A80h 	; CX:DX microseconds (=1,000,000ths of a second)
				int 15h			; 00061A80h = 400,000 = 400ms

				; Remove lines
				mov cx, 4
				xor bx, bx
				@@RemoveLinesLoop:
					cmp [linesToRemove+bx], '-'
					jne @@RemoveLine
					jmp @@Next

					@@RemoveLine:
						xor ax, ax
						mov al, [linesToRemove+bx]
						push ax
						call MoveLinesDown
						add [score], 100
						mov [linesToRemove+bx], '-'

					@@Next:
					inc bx
					loop @@RemoveLinesLoop

			@@DontRemoveLines:
			popa

			call Render
			call PrintScore
		jmp @@GameLoop

	@@GameOver:	

	mov ah, 1
	int 21h
exit:
	mov ax, 4c00h
	int 21h
END start