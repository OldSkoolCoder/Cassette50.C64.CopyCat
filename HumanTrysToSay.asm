#importonce

#import "Memory.asm"
#import "C64Constants.asm"
#import "utilities.asm"

htsJumpVectors:
// Jump Table For all the Human Says Modes
.word htsHumanSaysStart
.word htsHumanSaysGetNext
.word htsHumanSaysWaitingForInput
.word htsHumanEvaluateAnswer
.word htsHumanDisplayon
.word htsHumanDisplayOff
.word htsHumanGotItWrong

// ========================================================================
htsHumanTrysToSay:
    lda VIC_RASTER
    cmp #240
    bne htsHumanTrysToSay

    ldx HumanTryToSayFlag
    cpx #HTS_Completed
    bne !ByPassRTS+
    rts

!ByPassRTS:
    txa
    asl                         // x2
    tax
    lda htsJumpVectors,x        // Get Low Jump Vector
    sta ZeroPageLow
    inx
    lda htsJumpVectors,x        // Get Hi Jump Vector
    sta ZeroPageHigh

    jsr htsHumanTryToSayJump
    jmp htsHumanTrysToSay

htsHumanTryToSayJump:
    jmp (ZeroPageLow)           // Jump To Game Mode Routine

// ========================================================================
htsHumanSaysStart:
    lda #0
    sta CurrentHumanLocation    // Reset the counter
    sta Timer
    sta Timer + 1

    lda #255
    sta HumanCombinationGuess

    lda #HTS_GetNext
    sta HumanTryToSayFlag       // Goto next HTS Stage
    rts

// ========================================================================
htsHumanSaysGetNext:
    ldx CurrentHumanLocation
    lda Combination,x
    sta CurrentCombination

    lda #255
    sta CurrentKeyPress
    sta PreviousKeyPress

    lda #HTS_WaitingInput
    sta HumanTryToSayFlag       // Goto next HTS Stage

    rts

// ========================================================================
htsHumanSaysWaitingForInput:
    jsr UpdateTimerCycle
    lda krljmpLSTX
    //sta $0428
    cmp PreviousKeyPress
    bne !ByPassRTS+
    rts

!ByPassRTS:
    sta CurrentKeyPress
    cmp #scanCode_NO_KEY
    bne !ByPassRTS+
    sta PreviousKeyPress
    rts

!ByPassRTS:
    cmp #scanCode_A
    bne !NotThe_A_Key+
    ldx #0
    jmp !InputMoveToNextStage+
    //rts

!NotThe_A_Key:
    cmp #scanCode_K
    bne !NotThe_K_Key+
    ldx #1
    jmp !InputMoveToNextStage+
    //rts

!NotThe_K_Key:
    cmp #scanCode_Z
    bne !NotThe_Z_Key+
    ldx #2
    jmp !InputMoveToNextStage+
    //rts

!NotThe_Z_Key:
    cmp #scanCode_M
    bne !NotThe_M_Key+
    ldx #3
    jmp !InputMoveToNextStage+
    //rts

!NotThe_M_Key:
    sta PreviousKeyPress
    rts

!InputMoveToNextStage:
    sta PreviousKeyPress
    stx HumanCombinationGuess

    lda #HTS_EvaluateAnswer
    sta HumanTryToSayFlag
    rts

// ========================================================================
htsHumanEvaluateAnswer: //// <--- im here
    lda HumanCombinationGuess
    cmp CurrentCombination
    beq !HumanGuessedRight+
    jsr PlayerWrongIndicator
    lda #0
    sta CurrentDisplayDelay
    lda #HTS_GotItWrong
    sta HumanTryToSayFlag
    rts

!HumanGuessedRight:
    lda #0
    sta CurrentDisplayDelay
    lda #HTS_DisplayOn
    sta HumanTryToSayFlag
    jsr PlayerCorrectIndicator
    lda CurrentCombination
    jmp TurnOnCell

// ========================================================================
htsHumanDisplayon:
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

    lda #HTS_DisplayOff
    sta HumanTryToSayFlag        // Goto Next CS Stage

    jsr ResetPlayerActiveIndicator

    jsr DeActivateSID
    lda CurrentCombination      // Load Current Combination
    jmp TurnOffCell
    
// ========================================================================
htsHumanDisplayOff:
    inc CurrentDisplayDelay
    lda CurrentDisplayDelay
    cmp #10
    beq !SetHTSEnd+
    rts

!SetHTSEnd:
    inc CurrentHumanLocation
    lda CurrentHumanLocation
    cmp GameLevel
    beq !UpGameLevel+

    lda #HTS_GetNext
    sta HumanTryToSayFlag
    rts

!UpGameLevel:
    sed
    clc
    lda Timer
    adc Score
    sta Score
    lda Timer + 1
    adc Score + 1
    sta Score + 1
    lda #0
    adc Score + 2
    sta Score + 2
    cld
    jsr DisplayScore

    lda #HTS_Completed
    sta HumanTryToSayFlag
    lda #GREEN
    sta VIC_EXTCOL
    ldx #3
    jsr RasterDelaySecs
    lda #BLACK
    sta VIC_EXTCOL
    rts

// ========================================================================
htsHumanGotItWrong:
    lda #4                      // Wrong Combination
    jsr PlaySound
    inc CurrentDisplayDelay
    lda CurrentDisplayDelay
    cmp #10
    beq !SetHTSEnd+
    jmp UpdateTimerCycle
    //rts

!SetHTSEnd:
    jsr ResetPlayerActiveIndicator
    jsr DeActivateSID

    // Write Loss Of Live Code
    dec Lives
    jsr DisplayLives

    lda Lives
    beq htsDead
    lda #HTS_WaitingInput
    sta HumanTryToSayFlag
    rts

htsDead:
    lda #HTS_Completed
    sta HumanTryToSayFlag
    rts


