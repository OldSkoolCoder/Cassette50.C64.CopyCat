#importonce

* = * "Data Section"

.label Combination          = $033C

.label NoOfCombination      = $02A7
.label CurrentCombiCount    = NoOfCombination + 1
.label CurrentHumanLocation = CurrentCombiCount + 1
.label GameLevel            = CurrentHumanLocation + 1
.label Lives                = GameLevel + 1
.label Score                = Lives + 1
.label HiScore              = Score + 3
.label Timer                = HiScore + 3

.label LevelDisplayDelay    = Timer + 2
.label CurrentDisplayDelay  = LevelDisplayDelay + 1
.label FPS                  = CurrentDisplayDelay + 1
.label CurrentFrame         = FPS + 1
.label GameMode             = CurrentFrame + 1

.label ComputerSaysFlag     = GameMode + 1
.label CurrentCombination   = ComputerSaysFlag + 1



.label Cell1Loc             = $04A7
.label Cell2Loc             = $04B6
.label Cell3Loc             = $0637
.label Cell4Loc             = $0646

// Format :
// .byte X, Y
// .text "message"
// .byte 0

TitleScreen:
.byte 5,6
.text "WELCOME TO OLDSKOOLCODER SAYS"
.byte 0

DifficultyLevelScreen:
.byte 1,9
.text "PLEASE PRESS (H)ARD (N)ORMAL or (E)EASY"
.byte 0

InGameDisplay:
.byte 1,0
.text "SCORE: 000000 HISCORE: 000000 LEVEL:00"
.byte 0

InGameDisplay2:
.byte 1,23
.text "LIVES : 00"
