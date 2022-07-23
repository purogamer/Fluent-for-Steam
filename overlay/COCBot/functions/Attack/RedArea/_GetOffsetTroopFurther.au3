
; #FUNCTION# ====================================================================================================================
; Name ..........: _GetOffsetTroopFurther
; Description ...:
; Syntax ........: _GetOffsetTroopFurther($pixel, $eVectorType, $offset)
; Parameters ....: $pixel               - a pointer value.
;                  $eVectorType         - an unknown value.
;                  $offset              - an object.
; Return values .: None
; Author ........: didipe
; Modified ......: ProMac (12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _GetOffsetTroopFurther($pixel, $eVectorType, $offset)
	debugRedArea("_GetOffsetTroopFurther IN")
	Local $xMin, $xMax, $yMin, $yMax, $xStep, $yStep, $xOffset, $yOffset
	Local $vectorRedArea[0]
	Local $pixelOffset = GetOffestPixelRedArea2($pixel, $eVectorType, $offset)
	If ($eVectorType = $eVectorLeftTop) Then

		$xMin = $InternalArea[0][0] + 2
		$yMin = $InternalArea[0][1]
		$xMax = $InternalArea[2][0]
		$yMax = $InternalArea[2][1] + 2

		$xStep = 4
		$yStep = -3
		$yOffset = -1 * $offset
		$xOffset = Floor($yOffset)
	ElseIf ($eVectorType = $eVectorRightTop) Then

		$xMin = $InternalArea[2][0]
		$yMin = $InternalArea[2][1] + 2
		$xMax = $InternalArea[1][0] - 2
		$yMax = $InternalArea[1][1]


		$xStep = 4
		$yStep = 3
		$yOffset = -1 * $offset
		$xOffset = Floor($yOffset) * -1
	ElseIf ($eVectorType = $eVectorLeftBottom) Then

		$xMin = $InternalArea[0][0] + 2
		$yMin = $InternalArea[0][1]
		$xMax = $InternalArea[3][0]
		$yMax = $InternalArea[3][1] - 2

		$xStep = 4
		$yStep = 3
		$yOffset = $offset
		$xOffset = Floor($yOffset) * -1
	Else

		$xMin = $InternalArea[3][0]
		$yMin = $InternalArea[3][1] - 2
		$xMax = $InternalArea[1][0] - 2
		$yMax = $InternalArea[1][1]

		$xStep = 4
		$yStep = -3
		$yOffset = $offset
		$xOffset = Floor($yOffset)
	EndIf



	Local $y = $yMin
	Local $found = False
	For $x = $xMin To $xMax Step $xStep
		If ($eVectorType = $eVectorRightBottom And $y > $yMax And $pixelOffset[0] > $x And $pixelOffset[1] > $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset
			$found = True
		ElseIf ($eVectorType = $eVectorLeftBottom And $y < $yMax And $pixelOffset[0] < $x And $pixelOffset[1] > $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset
			$found = True
		ElseIf ($eVectorType = $eVectorLeftTop And $y > $yMax And $pixelOffset[0] < $x And $pixelOffset[1] < $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset

			$found = True
		ElseIf ($eVectorType = $eVectorRightTop And $y < $yMax And $pixelOffset[0] > $x And $pixelOffset[1] < $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset
			$found = True
		EndIf

		$y += $yStep
		If ($found) Then ExitLoop
	Next
	; Not select pixel in menu of troop
	If $pixelOffset[1] > 555 + $g_iBottomOffsetY Then
		$pixelOffset[1] = 555 + $g_iBottomOffsetY
	EndIf
	debugRedArea("$pixelOffset x : [" & $pixelOffset[0] & "] / y : [" & $pixelOffset[1] & "]")

	Return $pixelOffset
EndFunc   ;==>_GetOffsetTroopFurther
