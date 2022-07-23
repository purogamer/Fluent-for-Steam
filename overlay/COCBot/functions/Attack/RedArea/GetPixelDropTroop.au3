
; #FUNCTION# ====================================================================================================================
; Name ..........: GetPixelDropTroop
; Description ...:
; Syntax ........: GetPixelDropTroop($troop, $number, $slotsPerEdge)
; Parameters ....: $troop               - a dll struct value.
;                  $number              - a general number value.
;                  $slotsPerEdge        - a string value.
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
Func GetPixelDropTroop($Troop, $Number, $slotsPerEdge)
	Local $newPixelTopLeft
	Local $newPixelBottomLeft
	Local $newPixelTopRight
	Local $newPixelBottomRight
	If ($Troop = $eArch Or $Troop = $eWiza Or $Troop = $eMini Or $Troop = $eBarb Or $Troop = $eGobl) Then
		If UBound($g_aiPixelTopLeftFurther) > 0 Then
			$newPixelTopLeft = $g_aiPixelTopLeftFurther
		Else
			$newPixelTopLeft = $g_aiPixelTopLeft
		EndIf
		If UBound($g_aiPixelBottomLeftFurther) > 0 Then
			$newPixelBottomLeft = $g_aiPixelBottomLeftFurther
		Else
			$newPixelBottomLeft = $g_aiPixelBottomLeft
		EndIf
		If UBound($g_aiPixelTopRightFurther) > 0 Then
			$newPixelTopRight = $g_aiPixelTopRightFurther
		Else
			$newPixelTopRight = $g_aiPixelTopRight
		EndIf
		If UBound($g_aiPixelBottomRightFurther) Then
			$newPixelBottomRight = $g_aiPixelBottomRightFurther
		Else
			$newPixelBottomRight = $g_aiPixelBottomRight
		EndIf
	Else
		$newPixelTopLeft = $g_aiPixelTopLeft
		$newPixelBottomLeft = $g_aiPixelBottomLeft
		$newPixelTopRight = $g_aiPixelTopRight
		$newPixelBottomRight = $g_aiPixelBottomRight
	EndIf
	$newPixelTopLeft = GetVectorPixelOnEachSide2($newPixelTopLeft, 0, $slotsPerEdge)
	$newPixelBottomLeft = GetVectorPixelOnEachSide2($newPixelBottomLeft, 1, $slotsPerEdge)
	$newPixelTopRight = GetVectorPixelOnEachSide2($newPixelTopRight, 1, $slotsPerEdge)
	$newPixelBottomRight = GetVectorPixelOnEachSide2($newPixelBottomRight, 0, $slotsPerEdge)
	Local $NumberArray[4] = [$newPixelBottomRight, $newPixelTopLeft, $newPixelBottomLeft, $newPixelTopRight]
	Local $g_aaiEdgeDropPointsPixelToDrop[4]
	For $x = 0 To UBound($g_aaiEdgeDropPointsPixelToDrop) - 1
		$g_aaiEdgeDropPointsPixelToDrop[$x] = $NumberArray[$g_iRandomSides[$x]]
		SetDebugLog("$g_aaiEdgeDropPointsPixelToDrop[" & $x & "] : $g_iRandomSides[$x]: " & $g_iRandomSides[$x] & " name:" & $g_sRandomSidesNames[$x])
	Next
	Return $g_aaiEdgeDropPointsPixelToDrop
EndFunc   ;==>GetPixelDropTroop
#EndRegion - Custom SmartFarm - Team AIO Mod++
