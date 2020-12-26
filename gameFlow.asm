#import "Memory.asm"
#import "C64Constants.asm"
#import "utilities.asm"

// ========================================================================
gfGameSetUpToStart:
    jsr CreateScreenLayout
    lda #0
    sta CurrentCombiCount
    sta CurrentHumanLocation
    sta Score
    sta Score + 1
    sta Score + 2
    sta CurrentDisplayDelay
    sta CurrentFrame
    sta GameLevel

    lda #4
    sta Lives

    ldx #50
    ldy #5
    lda PAL_NTSC
    cmp #0
    bne !NotNTSC+
    ldx #60
    ldy #6
!NotNTSC:
    stx FPS
    sty FPS_Timer

    lda FPS
    lsr
    sta LevelDisplayDelay

    lda #GM_GetCombination
    sta GameMode
    rts

// ========================================================================
gfGetCombinations:
    jsr GetCombinations

    lda #GM_ComputerSays
    sta GameMode

    lda #CS_Start
    sta ComputerSaysFlag

    lda #0
    sta CurrentCombiCount
    sta GameLevel
    rts
// ========================================================================
// Prints Text at a certain point on the screen
// Inputs   : Acc = Low Byte of Target Text
//          : Y = Hi Byte of Target Text
// ========================================================================
gfPrintAtPoint:
    sta ZeroPageLow2
    sty ZeroPageHigh2
    ldy #0
    lda (ZeroPageLow2),y
    pha
    iny
    lda (ZeroPageLow2),y
    tax
    pla
    tay
    clc
    jsr krljmp_PLOT
    clc
    lda ZeroPageLow2
    adc #2
    sta ZeroPageLow2
    bcc !ByPassInc+
    inc ZeroPageHigh2
!ByPassInc:
    lda ZeroPageLow2
    ldy ZeroPageHigh2
    jmp bas_PrintString

// ========================================================================
gfTimerText:
    lda #<txtTimer
    ldy #>txtTimer
    jmp gfPrintAtPoint

// ========================================================================
gfScoreText:
    lda #<txtScore
    ldy #>txtScore
    jmp gfPrintAtPoint

// ========================================================================
gfLivesText:
    lda #<txtLives
    ldy #>txtLives
    jmp gfPrintAtPoint

// ========================================================================
gfBestScoreText:
    lda #<txtBestScore
    ldy #>txtBestScore
    jmp gfPrintAtPoint

// ========================================================================
gfVersionText:
    lda #<txtVersion
    ldy #>txtVersion
    jmp gfPrintAtPoint

// ========================================================================
gfGetReadyText:
    lda #<txtGetReady
    ldy #>txtGetReady
    jmp gfPrintAtPoint

// ========================================================================
gfGoText:
    lda #<txtGo
    ldy #>txtGo
    jmp gfPrintAtPoint

// ========================================================================
gfClearGoText:
    ldy #0
    ldx #24
    clc
    jsr krljmp_PLOT
    ldx #0
!Looper:
    lda #CHR_Space
    jsr krljmp_CHROUT
    inx
    cpx #32
    bcc !Looper-
    rts

// ========================================================================
gfPressSpaceToStartText:
    lda #<txtPressPlayToStart
    ldy #>txtPressPlayToStart
    jmp gfPrintAtPoint

// ========================================================================
gfPressSpaceToStart:
    jsr gfPressSpaceToStartText
    lda krljmpLSTX
    cmp #scanCode_SPACEBAR
    beq !Exit+
    ldx #1
    jsr RasterDelaySecs
    jsr gfClearGoText
    lda krljmpLSTX
    cmp #scanCode_SPACEBAR
    beq !Exit+
    ldx #1
    jsr RasterDelaySecs
    jmp gfPressSpaceToStart

!Exit:
    jmp gfClearGoText
    //rts

// ========================================================================
gfYouDiedText:
    lda #<txtYouDiedText
    ldy #>txtYouDiedText
    jmp gfPrintAtPoint

// ========================================================================
gfGameTitleText:
    lda #<txtGameTitle
    ldy #>txtGameTitle
    jmp gfPrintAtPoint

// ========================================================================
gfBestLevelText:
    lda #<txtBestLevel
    ldy #>txtBestLevel
    jmp gfPrintAtPoint

// ========================================================================
gfLevelText:
    lda #<txtLevel
    ldy #>txtLevel
    jmp gfPrintAtPoint

// ========================================================================
gfClearScreen:
    lda #CHR_White
    jsr krljmp_CHROUT
    lda #CHR_ClearScreen
    jmp krljmp_CHROUT

