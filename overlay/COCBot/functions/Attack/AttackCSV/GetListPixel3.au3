; #FUNCTION# ====================================================================================================================
; Name ..........: GetListPixel3
; Description ...:
; Syntax ........: GetListPixel3($listPixel)
; Parameters ....: $listPixel           - an unknown value.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetListPixel3($listPixel)
	Local $listPixelSideStr = StringSplit($listPixel, "|")
	If ($listPixelSideStr[0] > 1) Then
		Local $listPixelSide[UBound($listPixelSideStr) - 1]
		For $i = 0 To UBound($listPixelSide) - 1
			Local $pixelStr = StringSplit($listPixelSideStr[$i + 1], "-")
			If ($pixelStr[0] > 2) Then
				Local $pixel = [Int($pixelStr[1]), Int($pixelStr[2]), Int($pixelStr[3])]
				$listPixelSide[$i] = $pixel
			EndIf
		Next
		Return $listPixelSide
	Else
		If StringInStr($listPixel, "-") > 0 Then
			Local $pixelStrHere = StringSplit($listPixel, "-")
			Local $pixelHere = [Int($pixelStrHere[1]), Int($pixelStrHere[2]), Int($pixelStrHere[3])]
			Local $listPixelHere = [$pixelHere]
			Return $listPixelHere
		EndIf
		Return -1 ;
	EndIf
EndFunc   ;==>GetListPixel3
