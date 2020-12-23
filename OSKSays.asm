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

    //jsr GetCombinations

GameLoop:
    lda VIC_RASTER
    cmp #240
    bne GameLoop

    jsr GameFlow

    jmp GameLoop
//     jsr CreateScreenLayout
//     jsr DrawPlayerActiveIndicator

//     lda #30
//     sta NoOfCombination

//     jsr GetCombinations

// ButtonLoop:
//     jsr Cell1On
//     jsr Cell2On
//     jsr Cell3On
//     jsr Cell4On

//     ldx# 254
// !DelayOuter:
//     ldy#254
// !DelayInner:
//     dey
//     bne !DelayInner-
//     dex
//     bne !DelayOuter-

//     jsr Cell1Off
//     jsr Cell2Off
//     jsr Cell3Off
//     jsr Cell4Off
    
//     ldx# 254
// !DelayOuter:
//     ldy#254
// !DelayInner:
//     dey
//     bne !DelayInner-
//     dex
//     bne !DelayOuter-

//     jmp ButtonLoop

Cell1Off:
    lda #<Cell1Loc
    ldy #>Cell1Loc
    ldx #GREEN
    jsr FillCell
    rts

Cell1On:
    lda #<Cell1Loc
    ldy #>Cell1Loc
    ldx #LIGHT_GREEN
    jsr FillCell
    rts

Cell2Off:
    lda #<Cell2Loc
    ldy #>Cell2Loc
    ldx #RED
    jsr FillCell
    rts

Cell2On:
    lda #<Cell2Loc
    ldy #>Cell2Loc
    ldx #LIGHT_RED
    jsr FillCell
    rts

Cell3Off:
    lda #<Cell3Loc
    ldy #>Cell3Loc
    ldx #ORANGE
    jsr FillCell
    rts

Cell3On:
    lda #<Cell3Loc
    ldy #>Cell3Loc
    ldx #YELLOW
    jsr FillCell
    rts

Cell4Off:
    lda #<Cell4Loc
    ldy #>Cell4Loc
    ldx #BLUE
    jsr FillCell
    rts

Cell4On:
    lda #<Cell4Loc
    ldy #>Cell4Loc
    ldx #CYAN
    jsr FillCell
    rts























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

    rts

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
    rts

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
    sta $0450,x
    inx
    cpx NoOfCombination
    bcc !Looper-
    rts

#import "gameFlow.asm"