; #FUNCTION# ====================================================================================================================
; Name ..........: OldDropTroop
; Description ...:
; Syntax ........: OldDropTroop($troop, $position, $nbperspot)
; Parameters ....: $troop               - a dll struct value.
;                  $position            - a pointer value.
;                  $nbperspot           - a general number value.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func OldDropTroop($troop, $position, $nbperspot)
	SelectDropTroop($troop) ;Select Troop
	If _Sleep($DELAYOLDDROPTROOP1) Then Return
	For $i = 0 To 4
		Click($position[$i][0], $position[$i][1], $nbperspot, 1, "#0110")
		If _Sleep($DELAYOLDDROPTROOP2) Then Return
	Next
EndFunc   ;==>OldDropTroop
