; #FUNCTION# ====================================================================================================================
; Name ..........: GetSlotIndexFromXPos
; Description ...:
; Syntax ........: GetSlotIndexFromXPos($xPos)
; Parameters ....: $xPos                - an unknown value.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetSlotIndexFromXPos($xPos)
	For $slot = 0 To 11
		If $xPos < 68 + ($slot * 72) Then
			Return $slot
		EndIf
	Next
EndFunc   ;==>GetSlotIndexFromXPos
