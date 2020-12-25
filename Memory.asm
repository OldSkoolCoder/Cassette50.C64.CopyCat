#importonce

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

.label Cell1Loc             = $04A7
.label Cell2Loc             = $04B6
.label Cell3Loc             = $0637
.label Cell4Loc             = $0646

// Format :
// .byte X, Y
// .text "message"
// .byte 0

// TitleScreen:
// .byte 5,6
// .text "WELCOME TO OLDSKOOLCODER SAYS"
// .byte 0

// DifficultyLevelScreen:
// .byte 1,9
// .text "PLEASE PRESS (H)ARD (N)ORMAL or (E)EASY"
// .byte 0

// InGameDisplay:
// .byte 1,0
// .text "SCORE: 000000 HISCORE: 000000 LEVEL:00"
// .byte 0

// InGameDisplay2:
// .byte 1,23
// .text "LIVES : 00"

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
