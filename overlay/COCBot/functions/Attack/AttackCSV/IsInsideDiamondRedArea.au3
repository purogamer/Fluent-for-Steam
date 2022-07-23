; #FUNCTION# ====================================================================================================================
; Name ..........: isInsideDiamondRedArea
; Description ...:
; Syntax ........: isInsideDiamondRedArea($aCoords)
; Parameters ....: $aCoords             - an array
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func isInsideDiamondRedArea($aCoords)
	Return True ; Inside Village
	#cs
	Local $Left = $ExternalArea[0][0], $Right = $ExternalArea[1][0], $Top = $ExternalArea[2][1], $Bottom = $ExternalArea[3][1] ; set the diamond shape 860x780
	Local $aDiamond[2][2] = [[$Left, $Top], [$Right, $Bottom]]
	Local $aMiddle = [($aDiamond[0][0] + $aDiamond[1][0]) / 2, ($aDiamond[0][1] + $aDiamond[1][1]) / 2]
	Local $aSize = [$aMiddle[0] - $aDiamond[0][0], $aMiddle[1] - $aDiamond[0][1]]

	Local $DX = Abs($aCoords[0] - $aMiddle[0])
	Local $DY = Abs($aCoords[1] - $aMiddle[1])

	; allow additional 5 pixels
	If $DX >= 5 Then $DX -= 5
	If $DY >= 5 Then $DY -= 5

	If ($DX / $aSize[0] + $DY / $aSize[1] <= 1) And $aCoords[0] > $g_aiDeployableLRTB[0] And $aCoords[0] <= $g_aiDeployableLRTB[1] And $aCoords[1] >= $g_aiDeployableLRTB[2] And $aCoords[1] <= $g_aiDeployableLRTB[3] Then
		Return True ; Inside Village
	Else
		;debugAttackCSV("isInsideDiamondRedArea outside: " & $aCoords[0] & "," & $aCoords[1])
		Return False ; Outside Village
	EndIf
	#ce
EndFunc   ;==>isInsideDiamondRedArea
