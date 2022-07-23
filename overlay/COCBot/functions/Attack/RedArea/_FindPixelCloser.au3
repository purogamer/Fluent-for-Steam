; #FUNCTION# ====================================================================================================================
; Name ..........: _FindPixelCloser
; Description ...: Search the closer aay of pixel in the aay of pixel
; Syntax ........: _FindPixelCloser($aPixel, $aPixel[, $eNb = 1])
; Parameters ....: $aPixel           		- an array of unknowns.
;                  $aVillageCenter     		- a pointer value.
;                  $eNb                 	- [optional] a general number value. Default is 1.
; Return values .: None
; Author ........: didipe, Team AIO Mod++ (2021)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func _FindPixelCloser($aPixel, $aVillageCenter, $eNb = 1)

	Local $aPixelCloser[0]

	If UBound($aPixel) > 0 And not @error Then 
		Local $bAlreadyExist = False, $bFound = False, $aTemp, $aPixelToCompare

		For $j = 0 To $eNb
			$aPixelToCompare = $aPixel[0]
			For $i = 0 To UBound($aPixel) - 1
				$aTemp = $aPixel[$i]
				$bAlreadyExist = False
				$bFound = False
				; Search closer only on y
				If ($aVillageCenter[0] = -1) Then
					If (Abs($aTemp[1] - $aVillageCenter[1]) < Abs($aPixelToCompare[1] - $aVillageCenter[1])) Then
						$bFound = True
					EndIf
					; Search closer only on x
				ElseIf ($aVillageCenter[1] = -1) Then
					If (Abs($aTemp[0] - $aVillageCenter[0]) < Abs($aPixelToCompare[0] - $aVillageCenter[0])) Then
						$bFound = True
					EndIf
					; Search closer on x/y
				Else
					If ((Abs($aTemp[0] - $aVillageCenter[0]) + Abs($aTemp[1] - $aVillageCenter[1])) < (Abs($aPixelToCompare[0] - $aVillageCenter[0]) + Abs($aPixelToCompare[1] - $aVillageCenter[1]))) Then
						$bFound = True
					EndIf
				EndIf
				If ($bFound = True) Then
					For $k = 0 To UBound($aPixelCloser) - 1
						Local $aTemp2 = $aPixelCloser[$k]
						If ($aTemp[0] = $aTemp2[0] And $aTemp[1] = $aTemp2[1]) Then
							$bAlreadyExist = True
							ExitLoop
						EndIf
					Next
					If ($bAlreadyExist = False) Then
						$aPixelToCompare = $aTemp
					EndIf
				EndIf
			Next
			ReDim $aPixelCloser[UBound($aPixelCloser) + 1]
			$aPixelCloser[UBound($aPixelCloser) - 1] = $aPixelToCompare
	
		Next
	EndIf
	Return $aPixelCloser
EndFunc   ;==>_FindPixelCloser