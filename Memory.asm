#importonce
#import "C64Constants.asm"

* = * "Data Section"

.label Combination          = $033C

// Total Number Of Combinations avaliable
.label NoOfCombination      = $02A7

// What The Current Combination Count the Computer is on
.label CurrentCombiCount    = NoOfCombination + 1
// What The Current Combination Count The Human Is On
.label CurrentHumanLocation = CurrentCombiCount + 1
// What is the game Level (no of combinations)
.label GameLevel            = CurrentHumanLocation + 1
// How Many Lives are left
.label Lives                = GameLevel + 1
// The Current Score
.label Score                = Lives + 1
// The HiScore for this session
.label HiScore              = Score + 3
// The CountDaown Time For Human 
.label Timer                = HiScore + 3

// The number of cycles for the button to be highlighted
.label LevelDisplayDelay    = Timer + 2
// The Current cycle for the highlight
.label CurrentDisplayDelay  = LevelDisplayDelay + 1
// The Actual Frames Per Second
.label FPS                  = CurrentDisplayDelay + 1
// The Current Frame
.label CurrentFrame         = FPS + 1
// The Game Mode
.label GameMode             = CurrentFrame + 1

// The Computer Says Flag
.label ComputerSaysFlag     = GameMode + 1
// The Current Combination Picked
.label CurrentCombination   = ComputerSaysFlag + 1

.label HumanTryToSayFlag    = CurrentCombination + 1
.label HumanCombinationGuess=HumanTryToSayFlag + 1

.label CurrentKeyPress      = HumanCombinationGuess + 1
.label PreviousKeyPress     = CurrentKeyPress + 1
.label FPS_Timer            = PreviousKeyPress + 1
.label LevelBDC             = FPS_Timer + 1
.label BestLevelBDC         = LevelBDC + 1

.label Cell1Loc             = $04A7
.label Cell2Loc             = $04B6
.label Cell3Loc             = $0637
.label Cell4Loc             = $0646

.label TimerLoc             = $04C8
.label ScoreLoc             = $0658
.label LivesLoc             = $04EE
.label HiScoreLoc           = $067A
.label LevelLoc             = $06F8
.label BestLevelLoc         = $071D

CellOnVectors:
.word Cell1On
.word Cell2On
.word Cell3On
.word Cell4On

CellOffVectors:
.word Cell1Off
.word Cell2Off
.word Cell3Off
.word Cell4Off

sidFreq:
.byte 97, 8
.byte 104, 9
.byte 143, 10
.byte 48, 11

// WrongChoice
.byte 12, 1

// Format :
// .byte X, Y
// .text "message"
// .byte 0

// TitleScreen:
// .byte 5,6
// .text "WELCOME TO OLDSKOOLCODER SAYS"
// .byte 0

txtTimer:
.byte 0,4
.text "TIMER:"
.byte CHR_Return
.text "000:0"
.byte 0

txtScore:
.byte 0,14
.text "SCORE:"
.byte CHR_Return
.text "000000"
.byte 0

txtBestScore:
 .byte 34,14
 .text "BEST:"
 .byte CHR_CursorDown, CHR_CursorLeft, CHR_CursorLeft, CHR_CursorLeft, CHR_CursorLeft, CHR_CursorLeft
 .text "000000"
 .byte 0

 txtGetReady:
 .byte 14,24,CHR_Red
 .text "GET READY!!!"
 .byte CHR_White, 0

txtGo:
.byte 18,24,CHR_Green
.text "GO!!!"
.byte CHR_White, 0

txtLives:
 .byte 34,4
 .text "LIVES:"
 .byte CHR_CursorDown, CHR_CursorLeft, CHR_CursorLeft
 .text "00"
 .byte 0

txtVersion:
 .byte 32,24
 .text "V0.0.04"
 .byte 0

txtPressPlayToStart:
 .byte 10,24
 .text "PRESS SPACE TO START"
 .byte 0

txtYouDiedText:
.byte 7,13
.text "YOU MADE TOO MANY MISTAKES"
.byte 0

txtGameTitle:
.byte 15,0
.text "COPY-CAT!!"
.byte 0

txtBestLevel:
.byte 34,18
.text "LEVEL:"
.byte CHR_CursorDown, CHR_CursorLeft, CHR_CursorLeft, CHR_CursorLeft
.text "000"
.byte 0

txtLevel:
.byte 0,18
.text "LEVEL:"
.byte CHR_Return, CHR_CursorUp
.text "000"
.byte 0