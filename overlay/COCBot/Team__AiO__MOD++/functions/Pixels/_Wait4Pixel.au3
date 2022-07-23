; #FUNCTION# ====================================================================================================================
; Name ..........: _Wait4Pixel
; Description ...:
; Author ........: Samkie
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _Wait4Pixel($x, $y, $sColor, $iColorVariation = 25, $iWait = 3000, $iDelay = 250, $sMsglog = Default) ; Return true if pixel is true
	If Not IsInt($iDelay) Then 
		$iDelay = 250
		SetDebugLog("Deprecated _Wait4Pixel " & $sMsglog, $COLOR_ERROR)
	EndIf
	
	Local $iSleep = Round(Int($iWait) / Int($iDelay)) ; Can help in VPS Delay Case
	For $i = 1 To $iSleep
		; Setlog($i & "/" & $iSleep) 
		If _ColorCheck(Hex($sColor, 6), _GetPixelColor($x, $y, $g_bCapturePixel), $iColorVariation) Then Return True
		If _Sleep($iDelay) Then Return False
	Next
	Return False
EndFunc   ;==>_Wait4Pixel

Func _Wait4PixelGone($x, $y, $sColor, $iColorVariation = 25, $iWait = 3000, $iDelay = 250, $sMsglog = Default) ; Return true if pixel is false
	If Not IsInt($iDelay) Then 
		$iDelay = 250
		SetDebugLog("Deprecated _Wait4Pixel " & $sMsglog, $COLOR_ERROR)
	EndIf
	
	Local $iSleep = Round(Int($iWait) / Int($iDelay)) ; Can help in VPS Delay Case
	For $i = 1 To $iSleep
		; Setlog($i & "/" & $iSleep)
		If _ColorCheck(Hex($sColor, 6), _GetPixelColor($x, $y, $g_bCapturePixel), $iColorVariation) = False Then Return True
		If _Sleep($iDelay) Then Return False
	Next
	Return False
EndFunc   ;==>_Wait4PixelGone

; #FUNCTION# ====================================================================================================================
; Name ..........: _Wait4PixelArray & _Wait4PixelGoneArray
; Description ...: Put array and return true or false if pixel is not found in time + delay.
; Author ........: Boldina !
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _Wait4PixelArray($aSettings) ; Return true if pixel is true
	Local $x = $aSettings[0]
	Local $y = $aSettings[1]
	Local $sColor = $aSettings[2]
	Local $iColorVariation = (UBound($aSettings) > 3) ? ($aSettings[3]) : (15)
	Local $iWait = (UBound($aSettings) > 4) ? ($aSettings[4]) : (3000)
	Local $iDelay = (UBound($aSettings) > 5) ? ($aSettings[5]) : (250)
	Local $sMsglog = (UBound($aSettings) > 6) ? ($aSettings[6]) : (Default)
	Return _Wait4Pixel($x, $y, $sColor, $iColorVariation, $iWait, $iDelay, $sMsglog)
EndFunc   ;==>_Wait4PixelArray

Func _Wait4PixelGoneArray($aSettings) ; Return true if pixel is false
	Local $x = $aSettings[0]
	Local $y = $aSettings[1]
	Local $sColor = $aSettings[2]
	Local $iColorVariation = (UBound($aSettings) > 3) ? ($aSettings[3]) : (15)
	Local $iWait = (UBound($aSettings) > 4) ? ($aSettings[4]) : (3000)
	Local $iDelay = (UBound($aSettings) > 5) ? ($aSettings[5]) : (250)
	Local $sMsglog = (UBound($aSettings) > 6) ? ($aSettings[6]) : (Default)
	Return _Wait4PixelGone($x, $y, $sColor, $iColorVariation, $iWait, $iDelay, $sMsglog)
EndFunc   ;==>_Wait4PixelGoneArray

; #FUNCTION# ====================================================================================================================
; Name ..........: _WaitForCheckImg & _WaitForCheckImgGone
; Description ...: Return true if img. is found in time (_WaitForCheckImg) or if img. is not found in time (_WaitForCheckImgGone).
; Author ........: Boldina !
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: You can use multiple img. in a folder and find ($aText = "a|b|c|d").
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _WaitForCheckImg($sPathImage, $sSearchZone = Default, $aText = Default, $iWait = 2000, $iDelay = 250)
	If $iWait = Default Then $iWait = 2000
	If $iDelay = Default Then $iDelay = 250

	Local $aReturn
	Local $iSleep = Round($iWait / $iDelay) ; Can help in VPS Delay Case
	For $i = 1 To $iSleep
		$aReturn = findMultipleQuick($sPathImage, Default, $sSearchZone, True, $aText)
		If IsArray($aReturn) Then Return True
		If _Sleep($iDelay) Then Return False
	Next
	Return False
EndFunc   ;==>_WaitForCheckImg

Func _WaitForCheckImgGone($sPathImage, $sSearchZone = Default, $aText = Default, $iWait = 2000, $iDelay = 250)
	If $iWait = Default Then $iWait = 2000
	If $iDelay = Default Then $iDelay = 250
	
	Local $aReturn
	Local $iSleep = Round($iWait / $iDelay) ; Can help in VPS Delay Case
	For $i = 1 To $iSleep
		$aReturn = findMultipleQuick($sPathImage, Default, $sSearchZone, True, $aText)
		If Not IsArray($aReturn) Then Return True
		If _Sleep($iDelay) Then Return False
	Next
	Return False
EndFunc   ;==>_WaitForCheckImgGone

; #FUNCTION# ====================================================================================================================
; Name ..........: _ColorCheckSubjetive
; Description ...: Cie1976 human color difference for pixels.
; Author ........: Boldina !, Inspired in Dissociable, translated from python (JAMES MASON).
; 				   https://en.wikipedia.org/wiki/Color_difference
; 				   https://raw.githubusercontent.com/sumtype/CIEDE2000/master/ciede2000.py
;				   https://github.com/markusn/color-diff
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; _ColorCheckSubjetive(0x00FF00, 0x00F768, 5) ; 4.74575054233923 ; Old | 6.66013616882879 | 3.25675649923578
Func _ColorCheckSubjetive($nColor1 = 0x00FF00, $nColor2 = 0x00FF6C, $sVari = Default, $sIgnore = Default)

	If $sVari = Default Then
		$sVari = 10
	ElseIf StringIsDigit($sVari) = 0 Then
		Switch $sVari
			Case "Imperceptible"
				$sVari = 1
			Case "Perceptible"
				$sVari = 2
			Case "Similar"
				$sVari = 10
			Case "Remarkable"
				$sVari = 25
			Case "Different"
				$sVari = 50
			Case Else
				$sVari = 10
		EndSwitch
	EndIf

	Local $iPixelDiff = Ciede1976(rgb2lab($nColor1, $sIgnore), rgb2lab($nColor2, $sIgnore))
	; If $g_bDebugSetlog Then SetLog("_ColorCheckSubjetive | $iPixelDiff " & $iPixelDiff, $COLOR_INFO)
	If $iPixelDiff > $sVari Then
		Return False
	EndIf

	Return True
EndFunc   ;==>_ColorCheckSubjetive

; Based on University of Zurich model, written by Daniel Strebel.
; https://stackoverflow.com/questions/9018016/how-to-compare-two-colors-for-similarity-difference
; Fixed by John Smith
Func rgb2lab($nColor, $sIgnore = Default)
    Local $r, $g, $b, $X, $Y, $Z, $fx, $fy, $fz, $xr, $yr, $zr;

	$R = Dec(StringMid(String($nColor), 1, 2))
	$G = Dec(StringMid(String($nColor), 3, 2))
	$B = Dec(StringMid(String($nColor), 5, 2))

	Switch $sIgnore
		Case "Red" ; mask RGB - Red
			$R = 0
		Case "Heroes" ; mask RGB - Green
			$G = 0
		Case "Red+Blue" ; mask RGB - Red+Blue
			$R = 0
			$B = 0
	EndSwitch

    ;http:;www.brucelindbloom.com

    Local $Ls, $as, $bs
    Local $eps = 216 / 24389;
    Local $k = 24389 / 27;

    Local $Xr = 0.96422  ; reference white D50
    Local $Yr = 1
    Local $Zr = 0.82521

    ; RGB to XYZ
    $r = $R / 255 ;R 0..1
    $g = $G / 255 ;G 0..1
    $b = $B / 255 ;B 0..1

    ; assuming sRGB (D65)
	$r = ($r <= 0.04045) ? ($r / 12.92) : (($r + 0.055) / 1.055 ^ 2.4)
    $g = ($g <= 0.04045) ? (($g + 0.055) / 1.055 ^ 2.4) : ($g / 12.92)
    $b = ($b <= 0.04045) ? ($b / 12.92) : (($b + 0.055) / 1.055 ^ 2.4)

    $X = 0.436052025 * $r + 0.385081593 * $g + 0.143087414 * $b
    $Y = 0.222491598 * $r + 0.71688606 * $g + 0.060621486 * $b
    $Z = 0.013929122 * $r + 0.097097002 * $g + 0.71418547 * $b

	; XYZ to Lab
    $xr = $X / $Xr
    $yr = $Y / $Yr
    $zr = $Z / $Zr

    $fx = ($xr > $eps) ? ($xr ^ 1 / 3.0) : (($k * $xr + 16.0) / 116)
    $fy = ($yr > $eps) ? ($yr ^ 1 / 3.0) : (($k * $yr + 16.0) / 116)
    $fz = ($zr > $eps) ? ($zr ^ 1 / 3.0) : (($k * $zr + 16.0) / 116)
    $Ls = (116 * $fy) - 16
    $as = 500 * ($fx - $fy)
    $bs = 200 * ($fy - $fz)
    Local $lab[3] = [(2.55 * $Ls + 0.5),($as + 0.5),($bs + 0.5)]
    return $lab
EndFunc

Func Ciede1976($laB1, $laB2)
	If $laB1 <> $laB2 Then
		Local $differences = Distance($laB1[0], $laB2[0]) + Distance($laB1[1], $laB2[1]) + Distance($laB1[2], $laB2[2])
		return Sqrt($differences)
	Else
		Return 0
	EndIf
EndFunc

Func Distance($a, $b)
    return ($a - $b) * ($a - $b);
EndFunc
#cs
Func ciede2000($laB1, $laB2)
	Static $kL = 1, $kC = 1, $kH = 1, $aC1C2 = 0, _
			$G = 0, $A1P = 0, $A2P = 0, $c1P = 0, $c2P = 0, $h1p = 0, $h2p = 0, $dLP = 0, $dCP = 0, $dhP = 0, $aL = 0, _
			$aCP = 0, $aHP = 0, $T = 0, $dRO = 0, $rC = 0, $sL = 0, $sC = 0, $sH = 0, $rT = 0, $c1 = 0, $c2 = 0

	$c1 = Sqrt(($laB1[1] ^ 2.0) + ($laB1[2] ^ 2.0))
	$c2 = Sqrt(($laB2[1] ^ 2.0) + ($laB2[2] ^ 2.0))
	$aC1C2 = ($c1 + $c2) / 2.0
	$G = 0.5 * (1.0 - Sqrt(($aC1C2 ^ 7.0) / (($aC1C2 ^ 7.0) + (25.0 ^ 7.0))))
	$A1P = (1.0 + $G) * $laB1[1]
	$A2P = (1.0 + $G) * $laB2[1]
	$c1P = Sqrt(($A1P ^ 2.0) + ($laB1[2] ^ 2.0))
	$c2P = Sqrt(($A2P ^ 2.0) + ($laB2[2] ^ 2.0))
	$h1p = hpf($laB1[2], $A1P)
	$h2p = hpf($laB2[2], $A2P)
	$dLP = $laB2[0] - $laB1[0]
	$dCP = $c2P - $c1P
	$dhP = dhpf($c1, $c2, $h1p, $h2p)
	$dhP = 2.0 * Sqrt($c1P * $c2P) * Sin(_Radian($dhP) / 2.0)
	$aL = ($laB1[0] + $laB2[0]) / 2.0
	$aCP = ($c1P + $c2P) / 2.0
	$aHP = ahpf($c1, $c2, $h1p, $h2p)
	$T = 1.0 - 0.17 * Cos(_Radian($aHP - 39)) + 0.24 * Cos(_Radian(2.0 * $aHP)) + 0.32 * Cos(_Radian(3.0 * $aHP + 6.0)) - 0.2 * Cos(_Radian(4.0 * $aHP - 63.0))
	$dRO = 30.0 * Exp(-1.0 * ((($aHP - 275.0) / 25.0) ^ 2.0))
	$rC = Sqrt(($aCP ^ 7.0) / (($aCP ^ 7.0) + (25.0 ^ 7.0)))
	$sL = 1.0 + ((0.015 * (($aL - 50.0) ^ 2.0)) / Sqrt(20.0 + (($aL - 50.0) ^ 2.0)))
	$sC = 1.0 + 0.045 * $aCP
	$sH = 1.0 + 0.015 * $aCP * $T
	$rT = -2.0 * $rC * Sin(_Radian(2.0 * $dRO))
	Return Sqrt((($dLP / ($sL * $kL)) ^ 2.0) + (($dCP / ($sC * $kC)) ^ 2.0) + (($dhP / ($sH * $kH)) ^ 2.0) + $rT * ($dCP / ($sC * $kC)) * ($dhP / ($sH * $kH)))
EndFunc   ;==>ciede2000

Func hpf($x, $y)
	Static $tmphp
	If $x = 0 And $y = 0 Then
		Return 0
	Else
		$tmphp = _Degree((2 * ATan($y / ($x + Sqrt($x * $x + $y * $y)))))
	EndIf

	If $tmphp >= 0 Then
		Return $tmphp
	Else
		Return $tmphp + 360.0
	EndIf
	Return Null
EndFunc   ;==>hpf

Func dhpf($c1, $c2, $h1p, $h2p)
	If $c1 * $c2 = 0 Then
		Return 0
	ElseIf Abs($h2p - $h1p) <= 180 Then
		Return $h2p - $h1p
	ElseIf $h2p - $h1p > 180 Then
		Return ($h2p - $h1p) - 360.0
	ElseIf $h2p - $h1p < 180 Then
		Return ($h2p - $h1p) + 360.0
	EndIf
	Return Null
EndFunc   ;==>dhpf

Func ahpf($c1, $c2, $h1p, $h2p)
	If $c1 * $c2 = 0 Then
		Return $h1p + $h2p
	ElseIf Abs($h1p - $h2p) <= 180 Then
		Return ($h1p + $h2p) / 2.0
	ElseIf Abs($h1p - $h2p) > 180 And $h1p + $h2p < 360 Then
		Return ($h1p + $h2p + 360.0) / 2.0
	ElseIf Abs($h1p - $h2p) > 180 And $h1p + $h2p >= 360 Then
		Return ($h1p + $h2p - 360.0) / 2.0
	EndIf
	Return Null
EndFunc   ;==>ahpf
#ce
; _MultiPixelArray("0xEDAE44,0,0,-1|0xA55123,38,40,-1", 15, 555, 15+63, 555+60)
Func _MultiPixelArray($vVar, $iLeft, $iTop, $iRight, $iBottom, $sVari = 15, $bForceCapture = True)
	Local $offColor = IsArray($vVar) ? ($vVar) : (StringSplit2D($vVar, ",", "|"))
	Local $aReturn[4] = [0, 0, 0, 0]
	If $bForceCapture = True Then _CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	Local $offColorVariation = UBound($offColor, 2) > 3
	Local $xRange = $iRight - $iLeft
	Local $yRange = $iBottom - $iTop

	If $sVari = Default Then
		$sVari = 10
	ElseIf StringIsDigit($sVari) = 0 Then
		Switch $sVari
			Case "Imperceptible"
				$sVari = 1
			Case "Perceptible"
				$sVari = 2
			Case "Similar"
				$sVari = 10
			Case "Remarkable"
				$sVari = 25
			Case "Different"
				$sVari = 50
			Case Else
				$sVari = 10
		EndSwitch
	EndIf	
	
	Local $iCV = $sVari
	Local $firstColor = $offColor[0][0]
	If $offColorVariation = True Then
		If Number($offColor[0][3]) > 0 Then
			$iCV = $offColor[0][3]
		EndIf
	EndIf

	Local $iPixelDiff
	For $x = 0 To $xRange
		For $y = 0 To $yRange
			$iPixelDiff = Ciede1976(rgb2lab(_GetPixelColor($x, $y), Default), rgb2lab($firstColor, Default))
			If $iPixelDiff > $sVari Then
				Local $allchecked = True
				$aReturn[0] = $iLeft + $x
				$aReturn[1] = $iTop + $y
				$aReturn[2] = $iLeft + $x
				$aReturn[3] = $iTop + $y
				For $i = 1 To UBound($offColor) - 1
					If $offColorVariation = True Then
						$iCV = $sVari
						If Number($offColor[$i][3]) > -1 Then
							$iCV = $offColor[$i][3]
						EndIf
					EndIf
					$iPixelDiff = Ciede1976(rgb2lab(_GetPixelColor($x, $y), Default), rgb2lab($firstColor, Default))
					If $iPixelDiff < $sVari Then
						$allchecked = False
						ExitLoop
					EndIf

					If $aReturn[0] > ($iLeft + $x + $offColor[$i][1]) Then
						$aReturn[0] = $iLeft + $offColor[$i][1] + $x
					EndIf

					If $aReturn[1] > ($iTop + $y + $offColor[$i][2]) Then
						$aReturn[1] = $iTop + $offColor[$i][2] + $y
					EndIf

					If $aReturn[2] < ($iLeft + $x + $offColor[$i][1]) Then
						$aReturn[2] = $iLeft + $offColor[$i][1] + $x
					EndIf

					If $aReturn[3] < ($iTop + $y + $offColor[$i][2]) Then
						$aReturn[3] = $iTop + $offColor[$i][2] + $y
					EndIf

				Next
				If $allchecked Then
                    Return $aReturn
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearch

; Check if an image in the Bundle can be found
Func ButtonClickArray($vVar, $iLeft, $iTop, $iRight, $iBottom, $iColorVariation = 15, $bForceCapture = True)
	Local $aDecodedMatch = _MultiPixelArray($vVar, $iLeft, $iTop, $iRight, $iBottom, $iColorVariation, $bForceCapture)
    If IsArray($aDecodedMatch) Then
		Local $bRdn = $g_bUseRandomClick
		$g_bUseRandomClick = False
		PureClick(Random($aDecodedMatch[0], $aDecodedMatch[2],1),Random($aDecodedMatch[1], $aDecodedMatch[3],1))
		If $bRdn = True Then $g_bUseRandomClick = True
		Return True
    EndIf
	Return False
EndFunc

Func _MasivePixelCompare($hHMapsOne, $hHMapsTwo, $iXS, $iYS, $iXE, $iYE, $iTol = 15, $iResol = 5, $bWhiteMask = False, $iBlurMask = 0)
	Local $aAllResults[0][2]
	Local $hMapsOne = _GDIPlus_BitmapCreateFromHBITMAP($hHMapsOne)
	Local $hMapsTwo = _GDIPlus_BitmapCreateFromHBITMAP($hHMapsTwo)
	
	If $iBlurMask > 0 Then
		Local $hEffect = _GDIPlus_EffectCreateBlur($iBlurMask)
		_GDIPlus_BitmapApplyEffect($hMapsOne, $hEffect)
		_GDIPlus_BitmapApplyEffect($hMapsTwo, $hEffect)
		_GDIPlus_EffectDispose($hEffect)
	EndIf
	
	Local $iBits1, $iBits2, $iWhite = rgb2lab(Hex(0xFFFFFF, 6))
	Local $iC = -1, $bWhite = 0, $iMap1, $iMap2
	For $iX = $iXS To $iXE Step $iResol
		For $iY = $iYS To $iYE Step $iResol
			$iBits1 = _GDIPlus_BitmapGetPixel($hMapsOne, $iX, $iY)
			$iBits2 = _GDIPlus_BitmapGetPixel($hMapsTwo, $iX, $iY)
			$iMap1 = rgb2lab(Hex($iBits1, 6))
			$iMap2 = rgb2lab(Hex($iBits2, 6))
			
			If $bWhiteMask = True Then
				If Ciede1976($iWhite, $iMap2) > $iTol Then ContinueLoop
				If Ciede1976($iMap1, $iWhite) > $iTol Then ContinueLoop
			EndIf
			
            If Ciede1976($iMap1, $iMap2) > $iTol Then
				$iC += 1
				ReDim $aAllResults[$iC + 1][2]
				$aAllResults[$iC][0] = $iX
				$aAllResults[$iC][1] = $iY
			EndIf
		Next
	Next

	If UBound($aAllResults) > 0 and not @error Then
		SetLog("Masive pixels detected : " & UBound($aAllResults))
		Return $aAllResults
	Else
		SetLog("Masive pixels detected : " & 0)
		Return -1
	EndIf
EndFunc