#importonce
#import "C64Constants.asm"
#import "Memory.asm"

Cell1Off:
    lda #<Cell1Loc
    ldy #>Cell1Loc
    ldx #GREEN
    jmp FillCell
    //rts

Cell1On:
    lda #<Cell1Loc
    ldy #>Cell1Loc
    ldx #LIGHT_GREEN
    jmp FillCell
    //rts

Cell2Off:
    lda #<Cell2Loc
    ldy #>Cell2Loc
    ldx #RED
    jmp FillCell
    //rts

Cell2On:
    lda #<Cell2Loc
    ldy #>Cell2Loc
    ldx #LIGHT_RED
    jmp FillCell
    ///rts

Cell3Off:
    lda #<Cell3Loc
    ldy #>Cell3Loc
    ldx #ORANGE
    jmp FillCell
    //rts

Cell3On:
    lda #<Cell3Loc
    ldy #>Cell3Loc
    ldx #YELLOW
    jmp FillCell
    //rts

Cell4Off:
    lda #<Cell4Loc
    ldy #>Cell4Loc
    ldx #BLUE
    jmp FillCell
    //rts

Cell4On:
    lda #<Cell4Loc
    ldy #>Cell4Loc
    ldx #CYAN
    jmp FillCell
    //rts

// =============================================================================
// Input Register : Acc = Which Cell
// =============================================================================
TurnOnCell:
    asl                         // x2
    tax
    lda CellOnVectors,x       // Get Low Jump Vector
    sta ZeroPageLow
    inx
    lda CellOnVectors,x       // Get Hi Jump Vector
    sta ZeroPageHigh

    jmp (ZeroPageLow)           // Jump To Cell On Routine

// =============================================================================
// Input Register : Acc = Which Cell
// =============================================================================
TurnOffCell:
    asl                         // x2
    tax
    lda CellOffVectors,x       // Get Low Jump Vector
    sta ZeroPageLow
    inx
    lda CellOffVectors,x       // Get Hi Jump Vector
    sta ZeroPageHigh

    jmp (ZeroPageLow)           // Jump To Cell On Routine

//*******************************************************************************
//*                                                                             *
//* G^Ray Defender - Randomiser Code from G-Pac Clone Game                      *
//*                                                                             *
//*******************************************************************************

//============================================================
Init_Random:
    lda #$FF                // maximum frequency value
    sta $D40E               // voice 3 frequency low byte
    sta $D40F               // voice 3 frequency high byte
    lda #$80                // noise SIRENform, gate bit off
    sta $D412               // voice 3 control register
    rts

Rand:
    lda $D41B               // get random value from 0-255
    rts
//============================================================

// ========================================================================
FillCell:
    sta ZeroPageLow
    sty ZeroPageHigh
    stx ZeroPageLow2

    clc
    lda ZeroPageLow
    adc #40
    sta ZeroPageLow
    bcc !ByPassInc+
    inc ZeroPageHigh
!ByPassInc:
    clc
    lda ZeroPageHigh
    adc #$D4
    sta ZeroPageHigh

    ldx #0
    ldy #1
!HorizLooper:
    lda ZeroPageLow2
    sta (ZeroPageLow),y
    iny
    cpy #10
    bcc !HorizLooper-
    inx
    cpx #7
    beq !CellFilled+    
    clc
    lda ZeroPageLow
    adc #40
    sta ZeroPageLow
    bcc !ByPassInc+
    inc ZeroPageHigh
!ByPassInc:
    ldy #1
    jmp !HorizLooper-

 !CellFilled:
    rts

// ========================================================================
CreateScreenLayout:
    lda #<Cell1Loc
    ldy #>Cell1Loc
    ldx #1 // Letter A
    jsr DrawCell

    lda #<Cell2Loc
    ldy #>Cell2Loc
    ldx #11 // Letter K
    jsr DrawCell

    lda #<Cell3Loc
    ldy #>Cell3Loc
    ldx #26 // Letter Z
    jsr DrawCell

    lda #<Cell4Loc
    ldy #>Cell4Loc
    ldx #13 // Letter M
    jsr DrawCell

    jsr Cell1Off
    jsr Cell2Off
    jsr Cell3Off
    jsr Cell4Off

    jsr gfGameTitleText
    jsr gfTimerText
    jsr gfScoreText
    jsr gfLivesText
    jsr gfBestScoreText
    jsr gfVersionText
    jsr gfBestLevelText
    jsr gfLevelText
    jsr DrawPlayerActiveIndicator
    jmp ResetPlayerActiveIndicator

    //rts

// ========================================================================
DrawCell:
    sta ZeroPageLow
    sty ZeroPageHigh
    stx ZeroPageLow2

    ldy #0
    lda #85
    sta (ZeroPageLow),y

    ldy #1
    lda #64
!HorizLooper:
    sta (ZeroPageLow),y
    iny
    cpy #10
    bcc !HorizLooper-
    lda # 73
    sta (ZeroPageLow),y
    ldx #0
!VerticlLooper:
    clc
    lda ZeroPageLow
    adc #40
    sta ZeroPageLow
    bcc !ByPassInc+
    inc ZeroPageHigh
!ByPassInc:
    lda #66
    ldy #0
    sta (ZeroPageLow),y

    iny
!FillLooper:
    lda #160
    sta (ZeroPageLow),y
    iny
    cpy #10
    bcc !FillLooper-
    lda #66
    ldy #10
    sta (ZeroPageLow),y
    inx
    cpx #4
    bne !ByPassLetterPoke+
    lda ZeroPageLow2
    ora #128
    ldy #5
    sta (ZeroPageLow),y
!ByPassLetterPoke:
    cpx #7
    bcc !VerticlLooper-

    clc
    lda ZeroPageLow
    adc #40
    sta ZeroPageLow
    bcc !ByPassInc+
    inc ZeroPageHigh
!ByPassInc:

    ldy #0
    lda #74
    sta (ZeroPageLow),y

    ldy #1
    lda #64
!HorizLooper:
    sta (ZeroPageLow),y
    iny
    cpy #10
    bcc !HorizLooper-
    lda #75
    sta (ZeroPageLow),y
    rts

// ========================================================================
DrawPlayerActiveIndicator:
    lda #112
    sta $05F2
    lda #64
    sta $05F3
    sta $05F4
    sta $066B
    sta $066C
    lda #66
    sta $061A
    sta $0642
    sta $061D
    sta $0645
    lda #110
    sta $05F5
    lda #109
    sta $066A
    lda #125
    sta $066D
    lda #160
    sta $061B
    sta $061C
    sta $0643
    sta $0644
    rts

// ========================================================================
ResetPlayerActiveIndicator:
    lda #BLACK
    jmp PlayerIndicator
    //rts

// ========================================================================
PlayerCorrectIndicator:
    lda #GREEN
    jmp PlayerIndicator

// ========================================================================
PlayerWrongIndicator:
    lda #RED
PlayerIndicator:
    sta $DA1B
    sta $DA1C
    sta $DA43
    sta $DA44
    rts

// ========================================================================
GetCombinations:
    ldx #0
    jsr Init_Random

!Looper:
    jsr Rand
    and #%00000011
    sta ZeroPageLow
    jsr Rand
    lsr
    lsr
    and #%00000011
    eor ZeroPageLow
    sta Combination,x
    //sta $0450,x
    inx
    cpx NoOfCombination
    bcc !Looper-
    rts

// ========================================================================
// Inputs : Accumulator : Byte Value To Extract
// Outputs: XReg : Hi Nibble
//        : Acc : Lo Nibble
// ========================================================================
ExtractSingleByteDisplay:
    pha
    and #$F0        // hundred-thousands
    lsr
    lsr
    lsr
    lsr
    ora #$30        // -->ascii
    tax             // print on screen
    pla
    and #$0F        // ten-thousands
    ora #$30        // -->ascii
    rts        // print on next screen position

// ========================================================================
// Inputs : Accumulator : Byte Value To Extract
// Outputs: XReg : Hi Nibble
//        : Acc : Lo Nibble
// ========================================================================
ExtractSingleByte:
    pha
    and #$F0        // hundred-thousands
    lsr
    lsr
    lsr
    lsr
    tax             // print on screen
    pla
    and #$0F        // ten-thousands
    rts        // print on next screen position


// ========================================================================
// Inputs : Accumulator : Amount To Add Lo
//        : XReg : Amount To Add Hi
//        : ZP Used : ZeroPageLow2
// ========================================================================
UpdateTimer:
    pha
    txa
    pha
    lda #<Timer
    sta ZeroPageLow2
    lda #>Timer
    sta ZeroPageHigh2
    pla
    tax
    pla
    ldy #0
    sed                         //  set decimal mode
    clc
    adc (ZeroPageLow2),y     //  tenths and seconds
    sta (ZeroPageLow2),y
    iny
    txa
    adc (ZeroPageLow2),y     //  tens secs and hundreds
    sta (ZeroPageLow2),y
    cld
    rts

// ========================================================================
DisplayTimer:
    lda Timer
    jsr ExtractSingleByteDisplay
    sta TimerLoc + 4
    stx TimerLoc + 2

    lda Timer + 1
    jsr ExtractSingleByteDisplay
    sta TimerLoc + 1
    stx TimerLoc + 0
    rts

// ========================================================================
DisplayScore:
    lda Score
    jsr ExtractSingleByteDisplay
    sta ScoreLoc + 5
    stx ScoreLoc + 4

    lda Score + 1
    jsr ExtractSingleByteDisplay
    sta ScoreLoc + 3
    stx ScoreLoc + 2

    lda Score + 2
    jsr ExtractSingleByteDisplay
    sta ScoreLoc + 1
    stx ScoreLoc + 0
    rts

// ========================================================================
DisplayHiScore:
    lda HiScore
    jsr ExtractSingleByteDisplay
    sta HiScoreLoc + 5
    stx HiScoreLoc + 4

    lda HiScore + 1
    jsr ExtractSingleByteDisplay
    sta HiScoreLoc + 3
    stx HiScoreLoc + 2

    lda HiScore + 2
    jsr ExtractSingleByteDisplay
    sta HiScoreLoc + 1
    stx HiScoreLoc + 0

    jmp DisplayBestLevel
    //rts

// ========================================================================
UpdateTimerCycle:
    inc CurrentFrame
    lda CurrentFrame
    cmp FPS_Timer
    bne !ByPassReset+
    ldx #0
    stx CurrentFrame
    lda #1
    jsr UpdateTimer
    jsr DisplayTimer
    
!ByPassReset:
    rts

DisplayLives:
    lda Lives
    jsr ExtractSingleByteDisplay
    sta LivesLoc + 1
    stx LivesLoc + 0
    rts

// ========================================================================
// Inputs : Accumulator : Hi Freq
//        : XReg : Lo Freq
// ========================================================================
ActivateSID:
    stx SID_FRELO1
    sta SID_FREHI1
    lda #128
    sta SID_PWLO1
    lda #8
    sta SID_PWHI1
    lda #53
    sta SID_ATDCY1
    lda #197
    sta SID_SUREL1
    lda #15
    sta SID_SIGVOL
    lda #65
    sta SID_VCREG1
    rts

// ========================================================================
DeActivateSID:
    lda #0
    sta SID_VCREG1
    lda #0
    sta SID_SIGVOL
    rts

// ========================================================================
// Inputs : Accumulator : Combination Number
// ========================================================================
PlaySound:
    asl                         // x2
    tay
    lda sidFreq,y        // Get Low Jump Vector
    tax
    iny
    lda sidFreq,y        // Get Hi Jump Vector
    jmp ActivateSID

// ========================================================================
RasterDelaySecs:
    stx CurrentDisplayDelay
!LoopBackSec:
    lda FPS
    sta CurrentFrame
!LoopBack:
    lda VIC_RASTER
    cmp #240
    bne !LoopBack-
    dec CurrentFrame
    bpl !LoopBack-
    dec CurrentDisplayDelay
    bpl !LoopBackSec-
    rts

// ========================================================================
GetReadyGo:
    jsr gfGetReadyText
    ldx #4
    jsr RasterDelaySecs
    jsr gfClearGoText
    jsr gfGoText
    ldx #2
    jsr RasterDelaySecs
    jmp gfClearGoText
    //rts

BestScore:
    lda Score
    cmp HiScore
    beq !NextStage+
    bcs !Exit+
    jmp NewBestScore

!NextStage:
    lda Score + 1
    cmp HiScore + 1
    beq !NextStage+
    bcs !Exit+
    jmp NewBestScore

!NextStage:
    lda Score + 2
    cmp HiScore + 2
    bcs !Exit+

NewBestScore:
    lda Score
    sta HiScore
    lda Score + 1
    sta HiScore + 1
    lda Score + 2
    sta HiScore + 2

    lda LevelBDC
    sta BestLevelBDC
!Exit:
    rts

// ========================================================================
DisplayLevel:
    lda LevelBDC
    jsr ExtractSingleByteDisplay
    sta LevelLoc + 2
    stx LevelLoc + 1
    rts

// ========================================================================
DisplayBestLevel:
    lda BestLevelBDC
    jsr ExtractSingleByteDisplay
    sta BestLevelLoc + 2
    stx BestLevelLoc + 1
    rts
