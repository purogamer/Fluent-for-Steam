; #FUNCTION# ====================================================================================================================
; Name ..........: _MultiPixelSearch
; Description ...: Uses multiple pixels with coordinates of each color in a certain region, works for memory BMP
; Syntax ........: _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
; 						$xSkip and $ySkip for numbers of pixels skip
;						$offColor[2][COLOR/OFFSETX/OFFSETY] offset relative to firstColor coordination
; Parameters ....: $iLeft               - an integer value.
;                  $iTop                - an integer value.
;                  $iRight              - an integer value.
;                  $iBottom             - an integer value.
;                  $xSkip               - an unknown value.
;                  $ySkip               - an unknown value.
;                  $firstColor          - 1st pixel to find
;                  $offColor            - array of color, pixel location and optional color variation
;                  $iColorVariation     - an integer value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; rotate y first, x second: search in columns

Func _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
	; Reset global if error
	$g_iMultiPixelOffSet[0] = Null
	$g_iMultiPixelOffSet[1] = Null

	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	Local $offColorVariation = UBound($offColor, 2) > 3
	Local $xRange = $iRight - $iLeft
	Local $yRange = $iBottom - $iTop
	If $xSkip < 0 Then
		$xRange = Abs($xSkip)
		$xSkip = 1
	EndIf
	If $ySkip < 0 Then
		$yRange = Abs($ySkip)
		$ySkip = 1
	EndIf

	For $x = 0 To $xRange Step $xSkip
		For $y = 0 To $yRange Step $ySkip
			If _ColorCheck(_GetPixelColor($x, $y), $firstColor, $iColorVariation) Then
				Local $allchecked = True
				Local $iCV = $iColorVariation
				For $i = 0 To UBound($offColor) - 1
					If $offColorVariation = True Then $iCV = $offColor[$i][3]
					If _ColorCheck(_GetPixelColor($x + $offColor[$i][1], $y + $offColor[$i][2]), Hex($offColor[$i][0], 6), $iCV) = False Then
						$allchecked = False
						ExitLoop
					EndIf
				Next
				If $allchecked Then
                    $g_iMultiPixelOffSet[0] = $iLeft + $x
                    $g_iMultiPixelOffSet[1] = $iTop + $y
                    Return $g_iMultiPixelOffSet
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearch

; rotate y first, x second: search in columns WITH Debug log when first point is found to help debug searching
Func _MultiPixelSearchDebug($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	Local $sPixelColor
	Local $offColorVariation = UBound($offColor, 2) > 3
	Local $xRange = $iRight - $iLeft
	Local $yRange = $iBottom - $iTop
	If $xSkip < 0 Then
		$xRange = Abs($xSkip)
		$xSkip = 1
	EndIf
	If $ySkip < 0 Then
		$yRange = Abs($ySkip)
		$ySkip = 1
	EndIf
	For $x = 0 To $xRange Step $xSkip
		For $y = 0 To $yRange Step $ySkip
			$sPixelColor = _GetPixelColor($x, $y, $g_bNoCapturePixel)
			If _ColorCheck($sPixelColor , $firstColor, $iColorVariation) Then
				SetDebugLog("Search At Loc: " & $x+$iLeft & " , " & $y+$iTop & ", MPSDebug Pix#1: " & $sPixelColor)
				Local $allchecked = True
				Local $iCV = $iColorVariation
				For $i = 0 To UBound($offColor) - 1
					If $offColorVariation = True Then $iCV = $offColor[$i][3]
					If _ColorCheck(_GetPixelColor($x + $offColor[$i][1], $y + $offColor[$i][2], $g_bNoCapturePixel, ">>> MPSDebug Pix#" & $i+2), Hex($offColor[$i][0], 6), $iCV) = False Then
						$allchecked = False
						ExitLoop
					EndIf
				Next
				If $allchecked Then
					Local $Pos[2] = [$iLeft + $x, $iTop + $y]
					SetDebugLog("MSPDebug loc found: " & $iLeft + $x & " , " & $iTop + $y, $COLOR_DEBUG)
					Return $Pos
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearchDebug

Func WaitforPixel($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10) ; $maxDelay is in 1/2 second
	For $i = 1 To $maxDelay * 2
		Local $result = _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation)
		If IsArray($result) Then Return True
		If _Sleep(250) Then Return
	Next
	Return False
EndFunc   ;==>WaitforPixel