#import "C64Constants.asm"

BasicUpstart2(start)

#import "Memory.asm"

 * = * "Code Section"
// =======================================================================================================
start:
    ldx #0
    sta VIC_BGCOL0
    sta VIC_EXTCOL

    jsr gfClearScreen

    lda #180
    sta NoOfCombination

    lda #$99
    sta HiScore
    sta HiScore + 1
    sta HiScore + 2

GameLoop:
    jsr gfGameSetUpToStart
    jsr DisplayLives
    jsr DisplayHiScore

    jsr gfPressSpaceToStart

    jsr gfGetCombinations
    jsr GetReadyGo

LevellingCycle:
    lda #CS_Start
    sta ComputerSaysFlag

    jsr csComputerSays

    lda #HTS_Start
    sta HumanTryToSayFlag
    
    jsr htsHumanTrysToSay

    lda Lives
    bne LevellingCycle

    jsr gfYouDiedText
    ldy GameLevel
    cpy #10
    bcc !MissBestScore+
    jsr BestScore
!MissBestScore:
    ldx #10
    jsr RasterDelaySecs
    jsr gfClearScreen
    jmp GameLoop

#import "utilities.asm"
#import "gameFlow.asm"
#import "ComputerSays.asm"
#import "HumanTrysToSay.asm"