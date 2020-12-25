#import "Memory.asm"
#import "C64Constants.asm"
#import "utilities.asm"

gfGameSetUpToStart:
    jsr CreateScreenLayout
    jsr DrawPlayerActiveIndicator
    jsr ResetPlayerActiveIndicator

    lda #0
    sta CurrentCombiCount
    sta CurrentHumanLocation
    sta Score
    sta Score + 1
    sta Score + 2
    sta CurrentDisplayDelay
    sta CurrentFrame

    sta HiScore
    sta HiScore + 1
    sta HiScore + 2

    lda #0
    sta GameLevel

    lda #4
    sta Lives

    ldx #35
    lda PAL_NTSC
    cmp #0
    bne !NotNTSC+
    ldx #40
!NotNTSC:
    stx LevelDisplayDelay

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

    //lda #GM_TitleScreen
    lda #GM_GetCombination
    sta GameMode
    rts

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



 