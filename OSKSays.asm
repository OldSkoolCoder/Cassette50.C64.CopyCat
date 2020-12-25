#import "C64Constants.asm"

BasicUpstart2(start)

#import "Memory.asm"

 * = * "Code Section"
// =======================================================================================================
start:
    ldx #0
    sta VIC_BGCOL0
    sta VIC_EXTCOL

    lda #CHR_White
    jsr krljmp_CHROUT
    lda #CHR_ClearScreen
    jsr krljmp_CHROUT

    lda #30
    sta NoOfCombination

GameLoop:
    jsr gfGameSetUpToStart
    jsr gfGetCombinations

LevellingCycle:
    lda #CS_Start
    sta ComputerSaysFlag

    jsr csComputerSays

    lda #HTS_Start
    sta HumanTryToSayFlag
    
    jsr htsHumanTrysToSay
    jmp LevellingCycle

#import "utilities.asm"
#import "gameFlow.asm"
#import "ComputerSays.asm"
#import "HumanTrysToSay.asm"