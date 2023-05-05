	processor 6502 ; set processor type for the assembler
	
	seg code
	org $F000		; define the code origin at $F000 that's immediately after ROM.


Start:
; we always start atari cartridges with these insturctions
	sei 		; disable interrupts 6507 doesn't have interrupts, but nevertheless we still do it
	cld			; disable binary decimal mode. (clears the bit)
	ldx  #$FF	; load X register with FF, to use instruction t txs
	txs 		; transfer X register to the stack pointer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; clear the page zero region , addresses from $00 to $FF
; meaning the entire RAM and TIA registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; we start from the end and decrement, can still do with inx and set x 0

	lda #0 		;	 A=0 , will be used to zero out in each mem pos
	ldx #$FF	;    X=#$FF

MemLoop:
	sta  $0,X   ; store value of A register inside memaddr $0 + X
	dex 		; X--
	bne MemLoop	; loop until X is set to zero (Z-flag = 1), dex changes flags
	sta $0  	; because we won't reach the first memaddr while decrementing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; fill the ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	org $FFFC 		; jump and set the origin to the end of our cartridge
	.word Start		; reset vector at $FFFC, where the program starts
	.word Start		; interrupt vector at $FFFE, unused in the VCS; requirement


;; dasm cleanmem.asm -f3 -v0 -ocart.bin
;; then run with stellar emulator