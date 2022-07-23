
; #FUNCTION# ====================================================================================================================
; Name ..........: GetVectorPixelOnEachSide
; Description ...:
; Syntax ........: GetVectorPixelOnEachSide($arrPixel, $vectorDirection)
; Parameters ....: $arrPixel            - an array of unknowns.
;                  $vectorDirection     - a variant value.
; Return values .: None
; Author ........:
; Modified ......: ProMac (07-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Custom SmartFarm - Team AIO Mod++
Func GetVectorPixelOnEachSide2($arrPixel, $vectorDirection, $slotsPerEdge)
	#Region - Custom SmartFarm - Team AIO Mod++
	If $g_bUseSmartFarmAndRandomQuant Then
		Local $minAdd = Random(0, Ceiling(($slotsPerEdge / 100) * 20), 1)
		$slotsPerEdge += $minAdd
	EndIf
	#EndRegion - Custom SmartFarm - Team AIO Mod++

	Local $vectorPixelEachSide[$slotsPerEdge]
	If (UBound($arrPixel) > 1) Then
		Local $pixelSearch[2] = [-1, -1]
		Local $minPixel = $arrPixel[0]
		Local $maxPixel = $arrPixel[UBound($arrPixel) - 1]
		Local $min = $minPixel[$vectorDirection]
		Local $max = $maxPixel[$vectorDirection]
		If $g_bDebugSmartFarm Then SetLog("Min pixel coord: " & $min & ", Max Pixel coord: " & $max)
		Local $posSide = Floor(($max - $min) / $slotsPerEdge)
		For $i = 0 To $slotsPerEdge - 1
			$pixelSearch[$vectorDirection] = $min + Floor(($posSide * ($i + 1)) - ($posSide / 2))
			Local $Coordinate = ($vectorDirection = 0) ? "X" : "Y"
			If $g_bDebugSmartFarm Then SetLog("Deploy point number[" & $i + 1 & "] at " & $Coordinate & ": " & $min + Floor(($posSide * ($i + 1)) - ($posSide / 2)))
			Local $arrPixelCloser = _FindPixelCloser($arrPixel, $pixelSearch, 1)
			If $g_bDebugSmartFarm Then SetLog("Deploy point Closer[" & $i + 1 & "] at: " & _ArrayToString($arrPixelCloser[0]))
			$vectorPixelEachSide[$i] = $arrPixelCloser[0]
		Next
	 EndIf 

	#Region - Randomize points along the line - Team AIO Mod++
	If $g_bUseSmartFarmAndRandomDeploy = True And IsArray($vectorPixelEachSide) Then
		_ArrayShuffle($vectorPixelEachSide)
	EndIf
	#EndRegion - Randomize points along the line - Team AIO Mod++
	Return $vectorPixelEachSide
EndFunc   ;==>GetVectorPixelOnEachSide2
#EndRegion - Custom SmartFarm - Team AIO Mod++
