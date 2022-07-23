
; #FUNCTION# ====================================================================================================================
; Name ..........: _PixelSearch
; Description ...: PixelSearch a certain region, works for memory BMP
; Syntax ........: _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $sColor, $iColorVariation)
; Parameters ....: $iLeft               - an integer value.
;                  $iTop                - an integer value.
;                  $iRight              - an integer value.
;                  $iBottom             - an integer value.
;                  $sColor              - an string value with hex color to search
;                  $iColorVariation     - an integer value.
;                  $bNeedCapture        - [optional] a boolean flag to get new screen capture, when False full screen must have been captured wuth _CaptureRegion() !!!
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Custom - Team AIO Mod++
Func _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $sColor, $iColorVariation, $bNeedCapture = True, $bCIE76 = False)
	Local $x1, $x2, $y1, $y2
	If $bNeedCapture = True Then
		_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
		$x1 = $iRight - $iLeft
		$x2 = 0
		$y1 = 0
		$y2 = $iBottom - $iTop
	Else
		$x1 = $iRight
		$x2 = $iLeft
		$y1 = $iTop
		$y2 = $iBottom
	EndIf
	Local $Pos[2]
	If $bCIE76 = False Then
		For $x = $x1 To $x2 Step -1
			For $y = $y1 To $y2
				If _ColorCheck(_GetPixelColor($x, $y), $sColor, $iColorVariation) Then
					$Pos[0] = $iLeft + $x - $x2
					$Pos[1] = $iTop + $y - $y1
					Return $Pos
				EndIf
			Next
		Next
	Else
		For $x = $x1 To $x2 Step -1
			For $y = $y1 To $y2
				If _ColorCheckSubjetive(_GetPixelColor($x, $y), $sColor, $iColorVariation) Then
					$Pos[0] = $iLeft + $x - $x2
					$Pos[1] = $iTop + $y - $y1
					Return $Pos
				EndIf
			Next
		Next
	EndIf
	Return 0
EndFunc   ;==>_PixelSearch
#EndRegion - Custom - Team AIO Mod++