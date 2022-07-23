; #FUNCTION# ====================================================================================================================
; Name ..........: Tab
; Description ...:
; Syntax ........: Tab($a, $b)
; Parameters ....: $a                   - a string
;                  $b                   - an unknown value
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Tab($a, $b)
	Local $Tab = ""
	For $i = StringLen($a) To $b Step 1
		$Tab &= " "
	Next
	Return $Tab
EndFunc   ;==>Tab
