#importonce

#import "Memory.asm"
#import "C64Constants.asm"
#import "utilities.asm"

csJumpVectors:
// Jump Table For all the ComputerSays Modes
.word csComputerSaysStart
.word csComputerSaysGetNext
.word csComputerSaysDisplayOn
.word csComputerSaysDisplayOff

// ========================================================================
csComputerSays:
    lda VIC_RASTER
    cmp #240
    bne csComputerSays

    ldx ComputerSaysFlag        // Load ComputerSays Flag
    cpx #CS_End
    bne !ByPassRTS+
    rts

!ByPassRTS:
    dex
    txa
    asl                         // x2
    tax
    lda csJumpVectors,x        // Get Low Jump Vector
    sta ZeroPageLow
    inx
    lda csJumpVectors,x        // Get Hi Jump Vector
    sta ZeroPageHigh

    jsr csComputerSaysJump
    jmp csComputerSays

csComputerSaysJump:
    jmp (ZeroPageLow)           // Jump To Game Mode Routine

// ========================================================================
csComputerSaysStart:
    lda #0
    sta CurrentCombiCount       // Reset the counter
    inc GameLevel               // Increase the difficulty # Of Combos
    sed
    clc
    lda LevelBDC
    adc #1
    sta LevelBDC
    cld
    jsr DisplayLevel
    lda #CS_GetNext
    sta ComputerSaysFlag        // Goto next CS Stage
    rts

// ========================================================================
csComputerSaysGetNext:
    ldx CurrentCombiCount
    lda Combination,x
    sta CurrentCombination

    lda #0
    sta CurrentDisplayDelay     // Reset Display Delay
    lda #CS_DisplayOn
    sta ComputerSaysFlag        // Goto next CS Stage

    lda CurrentCombination      // Load Current Combination
    jmp TurnOnCell

// ========================================================================
csComputerSaysDisplayOn:
    lda CurrentCombination
    jsr PlaySound
    inc CurrentDisplayDelay
    lda CurrentDisplayDelay
    cmp LevelDisplayDelay
    beq !TurnOffCells+
    rts

!TurnOffCells:
    lda #0
    sta CurrentDisplayDelay     // Reset Display Counter

    lda #CS_DisplayOff
    sta ComputerSaysFlag        // Goto Next CS Stage

    jsr DeActivateSID
    lda CurrentCombination      // Load Current Combination
    jmp TurnOffCell
    
// ========================================================================
csComputerSaysDisplayOff:
    inc CurrentDisplayDelay
    lda CurrentDisplayDelay
    cmp #10
    beq !SetCSEnd+
    rts

!SetCSEnd:
    inc CurrentCombiCount
    lda CurrentCombiCount
    cmp GameLevel
    beq !UpGameLevel+
    lda #CS_GetNext
    sta ComputerSaysFlag
    rts

!UpGameLevel:
    lda #CS_End
    sta ComputerSaysFlag
    
    rts


