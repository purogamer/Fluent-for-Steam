; #FUNCTION# ====================================================================================================================
; Name ..........: _ColorCheck
; Description ...: Checks if the color components exceed $sVari and returns true if they are below $sVari.
; Syntax ........: _ColorCheck($nColor1, $nColor2, $sVari = 5, $Ignore = "")
; Parameters ....: $nColor1, $nColor2: a Hex string color code eg: "FFFFFF", $sVari: a tolerance level, $Ignore : Ignore eg: "Red" to ignore the "Red" RGB component
; Return values .: True or False
; Author ........:
; Modified ......: Hervidero (2015), MonkeyHunter (08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_bActiveCIE76 = False
Func _ColorCheck($nColor1, $nColor2, $sVari = 5, $Ignore = Default)
	
	If $g_bActiveCIE76 = True Then
		Local $iPixelDiff = Ciede1976(rgb2lab($nColor1, $Ignore), rgb2lab($nColor2, $Ignore))
		
		Local $iDetect = ($sVari <= 10 And $sVari > 5) ? (Round($sVari * 0.50)) : (5)
		If $iPixelDiff > $iDetect Then
			Return False
		EndIf
		
		Return True
	EndIf
	
	Local $Red1, $Red2, $Blue1, $Blue2, $Green1, $Green2

	$Red1 = Dec(StringMid(String($nColor1), 1, 2))
	$Blue1 = Dec(StringMid(String($nColor1), 3, 2))
	$Green1 = Dec(StringMid(String($nColor1), 5, 2))

	$Red2 = Dec(StringMid(String($nColor2), 1, 2))
	$Blue2 = Dec(StringMid(String($nColor2), 3, 2))
	$Green2 = Dec(StringMid(String($nColor2), 5, 2))

	Switch $Ignore
		Case "Red" ; mask RGB - Red
			If Abs($Blue1 - $Blue2) > $sVari Then Return False
			If Abs($Green1 - $Green2) > $sVari Then Return False
		Case "Heroes" ; mask RGB - Green
			If Abs($Blue1 - $Blue2) > $sVari Then Return False
			If Abs($Red1 - $Red2) > $sVari Then Return False
		Case "Red+Blue" ; mask RGB - Red+Blue
			If Abs($Green1 - $Green2) > $sVari Then Return False
		Case Else ; compare all color channels
			If Abs($Blue1 - $Blue2) > $sVari Then Return False
			If Abs($Green1 - $Green2) > $sVari Then Return False
			If Abs($Red1 - $Red2) > $sVari Then Return False
	EndSwitch

	Return True
EndFunc   ;==>_ColorCheck
