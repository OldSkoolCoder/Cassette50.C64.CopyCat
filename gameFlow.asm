#import "Memory.asm"
#import "C64Constants.asm"

// Jump Table For all the Game Modes
gfStatusJumpTable:
    // Game SetUp
.word gfGameSetUp
.word 0000
.word gfGetCombination
.word gfComputerSays
.word 0000
.word 0000
.word 0000
.word 0000

GameFlow:
    lda GameMode              // Load Game Mode
    asl                         // x2
    tax
    lda gfStatusJumpTable,x     // Get Low Jump Vector
    sta ZeroPageLow
    inx
    lda gfStatusJumpTable,x     // Get Hi Jump Vector
    sta ZeroPageHigh

    jmp (ZeroPageLow)           // Jump To Game Mode Routine

gfGameSetUp:
    jsr CreateScreenLayout
    jsr DrawPlayerActiveIndicator

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

    lda #1
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
    lda PAL_NTSC
    cmp #0
    bne !NotNTSC+
    ldx #60
!NotNTSC:
    stx FPS

    //lda #GM_TitleScreen
    lda #GM_GetCombination
    sta GameMode
    rts

gfGetCombination:
    jsr GetCombinations

    lda #GM_ComputerSays
    sta GameMode

    lda #CS_Start
    sta ComputerSaysFlag

    lda #1
    sta CurrentCombiCount
    sta GameLevel
    rts

gfComputerSays:
    lda ComputerSaysFlag
    cmp #CS_Start
    bne gfCSGetNext
    lda #0
    sta CurrentCombiCount
    lda #CS_GetNext
    sta ComputerSaysFlag
    rts

gfCSGetNext:
    cmp #CS_GetNext
    bne gfDisplayOn
    ldx CurrentCombiCount
    lda Combination,x
    sta CurrentCombination

    lda #0
    sta CurrentDisplayDelay
    lda #CS_DisplayOn
    sta ComputerSaysFlag

    lda CurrentCombination
    //cmp #0
    bne !gotoCell2+
    jsr Cell1On
    jmp !End+

!gotoCell2:
    cmp #1
    bne !gotoCell3+
    jsr Cell2On
    jmp !End+

!gotoCell3:
    cmp #2
    bne !gotoCell4+
    jsr Cell3On
    jmp !End+

!gotoCell4:
    cmp #3
    bne !End+
    jsr Cell4On
    
!End:
    rts

gfDisplayOn:
    cmp #CS_DisplayOn
    bne gfDisplayOff
    inc CurrentDisplayDelay
    lda CurrentDisplayDelay
    cmp LevelDisplayDelay
    beq !TurnOffCells+
    rts

!TurnOffCells:
    lda #0
    sta CurrentDisplayDelay
    lda CurrentCombination
    //cmp #0
    bne !gotoCell2+
    jsr Cell1Off
    jmp !End+

!gotoCell2:
    cmp #1
    bne !gotoCell3+
    jsr Cell2Off
    jmp !End+

!gotoCell3:
    cmp #2
    bne !gotoCell4+
    jsr Cell3Off
    jmp !End+

!gotoCell4:
    cmp #3
    bne !End+
    jsr Cell4Off
    
!End:
    lda #CS_DisplayOff
    sta ComputerSaysFlag
    rts

gfDisplayOff:
    cmp #CS_DisplayOff
    bne gfEnd
    inc CurrentDisplayDelay
    lda CurrentDisplayDelay
    cmp #10
    beq !SetCSEnd+
gfEnd:
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
    //lda #GM_HumanCopies
    //sta GameMode
    inc GameLevel

    lda #CS_Start
    sta ComputerSaysFlag

    ldx#254
!DelayOuter:
    ldy#254
!DelayInner:
    dey
    bne !DelayInner-
    dex
    bne !DelayOuter-

    ldx#254
!DelayOuter:
    ldy#254
!DelayInner:
    dey
    bne !DelayInner-
    dex
    bne !DelayOuter-

    // lda GameLevel
    // and #%00000011
    // cmp #3
    // bne !Exit+
    dec LevelDisplayDelay
!Exit:    
    rts




 