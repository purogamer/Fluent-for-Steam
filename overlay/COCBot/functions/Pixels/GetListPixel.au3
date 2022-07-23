; #FUNCTION# ====================================================================================================================
; Name ..........: GetListPixel($listPixel), GetListPixel2($listPixel), GetLocationItem($functionName)
; Description ...: Pixel and Locate Image functions
; Author ........: HungLe (april-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetListPixel($listPixel, $sDelim = "-", $sName = "")
	If $sName <> "" Then debugAttackCSV("GetListPixel for " & $sName & ": " & $listPixel)
	Local $listPixelSideStr = StringSplit($listPixel, "|")
	If ($listPixelSideStr[0] > 1) Then
		Local $listPixelSide[UBound($listPixelSideStr) - 1]
		For $i = 0 To UBound($listPixelSide) - 1
			Local $pixel = GetPixel($listPixelSideStr[$i + 1], $sDelim)
			If UBound($pixel) > 1 Then
				$listPixelSide[$i] = $pixel
			EndIf
		Next
		Return $listPixelSide
	Else
		If StringInStr($listPixel, $sDelim) > 0 Then
			Local $pixel = GetPixel($listPixel, $sDelim)
			Local $listPixelHere = [$pixel]
			Return $listPixelHere
		EndIf
		Return -1 ;
	EndIf
EndFunc   ;==>GetListPixel

Func GetPixel($sPixel, $sDelim = "-")
	Local $pixel = StringSplit($sPixel, $sDelim, $STR_NOCOUNT)
	If UBound($pixel) < 2 Then Return $pixel
	$pixel[0] = Int($pixel[0])
	$pixel[1] = Int($pixel[1])
	Return $pixel
EndFunc   ;==>GetPixel

Func GetPixelDistance(Const ByRef $Pixel0, Const ByRef $Pixel1)
	Local $a = $Pixel0[0] - $Pixel1[0]
	Local $b = $Pixel0[1] - $Pixel1[1]
	Local $d = Sqrt($a * $a + $b * $b)
	Return $d
EndFunc   ;==>GetPixelDistance

Func GetPixelListDistance(Const $PixelArray, Const $iMaxAllowedPixelDistance)
	Local $dTotal = 0
	Local $i
	Local $iMax = UBound($PixelArray) - 1
	If $iMax < 1 Then Return $dTotal
	Local $prePixel = $PixelArray[0]
	Local $curPixel
	Local $d
	For $i = 1 To $iMax
		$curPixel = $PixelArray[$i]
		If UBound($prePixel) > 1 And UBound($curPixel) > 1 Then
			$d = GetPixelDistance($prePixel, $curPixel)
			If $d <= $iMaxAllowedPixelDistance Then $dTotal += $d
		EndIf
		$prePixel = $curPixel
	Next
	Return $dTotal
EndFunc   ;==>GetPixelListDistance

; USES OLD OPENCV DETECTION
Func GetLocationItem($functionName)
	If $g_bDebugSetlog Or $g_bDebugBuildingPos Then
		Local $hTimer = __TimerInit()
		SetLog("GetLocationItem(" & $functionName & ")", $COLOR_DEBUG)
	EndIf
	Local $resultHere = DllCall($g_hLibMyBot, "str", $functionName, "ptr", $g_hHBitmap2)
	If UBound($resultHere) > 0 Then
		If $g_bDebugBuildingPos Then SetLog("#*# " & $functionName & ": " & $resultHere[0] & "calc in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG1)
		Return GetListPixel($resultHere[0])
	Else
		If $g_bDebugBuildingPos Then SetLog("#*# " & $functionName & ": NONE calc in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG1)
	EndIf
EndFunc   ;==>GetLocationItem
