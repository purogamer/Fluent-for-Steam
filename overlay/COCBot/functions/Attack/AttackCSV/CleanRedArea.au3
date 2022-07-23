; #FUNCTION# ====================================================================================================================
; Name ..........: CleanRedArea
; Description ...: Remove pixels that are outside diamond
; Syntax ........: CleanRedArea($InputVect, $side)
; Parameters ....: $InputVect - an array
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CleanRedArea(ByRef $InputVect, $side = "")
	Local $TempVectStr = ""
	For $i = 0 To UBound($InputVect) - 1
		Local $pixel = $InputVect[$i]
		For $iatan2 = 0 To UBound($InputVect) -1
			Local $a = $InputVect[$iatan2]
			Local $aiPoint = Abs(atan2($a[1] - $pixel[1], $a[0] - $pixel[0]) * 180 / 3.14)
			If Abs($aiPoint - 37) < 13 Then
				$TempVectStr &= $pixel[0] & "-" & $pixel[1] & "|"
				ContinueLoop 2
			EndIf
		Next
	Next

	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		$InputVect = GetListPixel($TempVectStr)
	EndIf
EndFunc   ;==>CleanRedArea
