; #FUNCTION# ====================================================================================================================
; Name ..........: drillSearch
; Description ...: Searches for the DE Drills in the base, and returns; X, Y location, and Level
; Syntax ........: drillSearch()
; Parameters ....: None
; Return values .: Array with data on Dark Elixir Drills found in search
; Author ........: TripleM (01-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func drillSearch()
	Local $aReturnResult[0][5]
	Local $pixelerror = 15

	Local $Maxpositions = 0 ; Return all found Positions
	Local $aResult = multiMatches($g_sImgSearchDrill, $Maxpositions, $CocDiamondECD, $CocDiamondECD)

	For $iResult = 1 To UBound($aResult) - 1 ; Loop through all resultrows, skipping first row, which is searcharea, each matched img has its own row, if no resultrow, for is skipped
		If _Sleep(10) Then Return
		Local $aTemp[0][2]
		_ArrayAdd($aTemp, $aResult[$iResult][5], 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING) ; Copy Positionarray to temp array
		_ArrayColInsert($aTemp, 2) ; Adding Level Column
		_ArrayColInsert($aTemp, 3) ; Adding Hold Column
		_ArrayColInsert($aTemp, 4) ; Adding Last Zap Column
		For $iRow = 0 To UBound($aTemp) - 1
			$aTemp[$iRow][2] = $aResult[$iResult][2] ; Setting Level Column to Result Level
			$aTemp[$iRow][4] = 0 ; Set Last Zap to 0
		Next
		_ArrayAdd($aReturnResult, $aTemp, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING) ; Adding temp array to return array
	Next

	Local $iResult = 0
	While $iResult < UBound($aReturnResult)
		If _Sleep(10) Then Return
		; Removing Duplicate Drills
		Local $jResult = $iResult + 1
		While $jResult < UBound($aReturnResult)
			If Abs($aReturnResult[$iResult][0] - $aReturnResult[$jResult][0]) <= $pixelerror And Abs($aReturnResult[$iResult][1] - $aReturnResult[$jResult][1]) <= $pixelerror Then
				$aReturnResult[$iResult][2] = _Min(Number($aReturnResult[$iResult][2]), Number($aReturnResult[$jResult][2]))
				If $g_bDebugSmartZap = True Then
					SetLog("Found Duplicate Dark Elixir Drill: [" & $aReturnResult[$jResult][0] & "," & $aReturnResult[$jResult][1] & "], Level: " & $aReturnResult[$jResult][2], $COLOR_DEBUG)
				EndIf
				_ArrayDelete($aReturnResult, $jResult)
			Else
				$jResult += 1
			EndIf
		WEnd
		; Correcting Drilllevel
		Local $iDrillLevel = CheckDrillLvl($aReturnResult[$iResult][0], $aReturnResult[$iResult][1])
		If $iDrillLevel > 0 And $aReturnResult[$iResult][2] <> $iDrillLevel Then
			If $g_bDebugSmartZap = True Then SetLog("Correcting Drill Level, old = " & $aReturnResult[$iResult][2] & ", new = " & $iDrillLevel, $COLOR_DEBUG)
			$aReturnResult[$iResult][2] = $iDrillLevel
		EndIf
		; Adjusting Hold
		$aReturnResult[$iResult][3] = Ceiling(Number($g_aDrillLevelTotal[$aReturnResult[$iResult][2] - 1] * $g_fDarkStealFactor))
		If $g_bDebugSmartZap = True Then
			SetLog(($iResult + 1) & ". Valid Drill: [" & $aReturnResult[$iResult][0] & "," & $aReturnResult[$iResult][1] & "], Level: " & $aReturnResult[$iResult][2] & ", Hold: " & $aReturnResult[$iResult][3], $COLOR_DEBUG)
		EndIf
		$iResult += 1
	WEnd

	Return $aReturnResult
EndFunc   ;==>drillSearch

Func CheckDrillLvl($x, $y)
	_CaptureRegion2($x - 25, $y - 25, $x + 25, $y + 25)

	Local $aResult = multiMatches($g_sImgSearchDrillLevel, 1, "FV", "FV", "", 0, 1000, False)

	If $g_bDebugSmartZap = True Then SetLog("CheckDrillLvl: UBound($aresult) = " & UBound($aResult), $COLOR_DEBUG)
	If UBound($aResult) > 1 Then
		If $g_bDebugSmartZap = True Then SetLog("CheckDrillLvl: $aresult[" & (UBound($aResult) - 1) & "][2] = " & $aResult[UBound($aResult) - 1][2], $COLOR_DEBUG)
		Return $aResult[UBound($aResult) - 1][2]
	EndIf
	Return 0
EndFunc   ;==>CheckDrillLvl

Func getDrillCluster(Const ByRef $aDarkDrills)
	Local $iMaxMedianDist = 26
	Local $aBestCluster[4] = [0, 0, 0, -1]

	If UBound($aDarkDrills) < 2 Then Return -1

	If UBound($aDarkDrills) > 2 Then
		Local $iMedianX = Ceiling(Number(($aDarkDrills[0][0] + $aDarkDrills[1][0] + $aDarkDrills[2][0]) / 3))
		Local $iMedianY = Ceiling(Number(($aDarkDrills[0][1] + $aDarkDrills[1][1] + $aDarkDrills[2][1]) / 3))
		If $g_bDebugSmartZap = True Then SetLog("TripleDrill Unweighted Median Point: x = " & $iMedianX & ", y = " & $iMedianY, $COLOR_DEBUG)
		For $i = 0 To 2
			If Abs($aDarkDrills[$i][0] - $iMedianX) > $iMaxMedianDist Or Abs($aDarkDrills[$i][1] - $iMedianY) > $iMaxMedianDist Then
				$aBestCluster[3] = -1
				ExitLoop
			Else
				Local $aTemp[3] = [0, 1, 2]
				$aBestCluster[3] = $aTemp
			EndIf
		Next
		If $g_bDebugSmartZap = True And $aBestCluster[3] <> -1 Then SetLog("TripleDrill Cluster found." & $aBestCluster[3], $COLOR_DEBUG)
	EndIf

	If $aBestCluster[3] = -1 Then
		Local $iMaxHold = 0
		For $i = 0 To UBound($aDarkDrills) - 1
			Local $iMedianX = Ceiling(Number(($aDarkDrills[$i][0] + $aDarkDrills[Mod($i + 1, UBound($aDarkDrills))][0]) / 2))
			Local $iMedianY = Ceiling(Number(($aDarkDrills[$i][1] + $aDarkDrills[Mod($i + 1, UBound($aDarkDrills))][1]) / 2))
			If $g_bDebugSmartZap = True Then SetLog("[" & $i & "," & Mod($i + 1, UBound($aDarkDrills)) & "] DoubleDrill Unweighted Median Point: x = " & $iMedianX & ", y = " & $iMedianY, $COLOR_DEBUG)
			If $aDarkDrills[$i][3] + $aDarkDrills[Mod($i + 1, UBound($aDarkDrills))][3] > $iMaxHold Then
				If Abs($aDarkDrills[$i][0] - $iMedianX) <= $iMaxMedianDist And Abs($aDarkDrills[$i][1] - $iMedianY) <= $iMaxMedianDist _
						And Abs($aDarkDrills[Mod($i + 1, UBound($aDarkDrills))][0] - $iMedianX) <= $iMaxMedianDist And Abs($aDarkDrills[Mod($i + 1, UBound($aDarkDrills))][1] - $iMedianY) <= $iMaxMedianDist Then
					$iMaxHold = $aDarkDrills[$i][3] + $aDarkDrills[Mod($i + 1, UBound($aDarkDrills))][3]
					Local $aTemp[2] = [$i, Mod($i + 1, UBound($aDarkDrills))]
					$aBestCluster[3] = $aTemp
				EndIf
			EndIf
		Next
		If $g_bDebugSmartZap = True And $aBestCluster[3] <> -1 Then SetLog("DoubleDrill Cluster found: [" & ($aBestCluster[3])[0] & "," & ($aBestCluster[3])[1] & "]", $COLOR_DEBUG)
	EndIf

	If $aBestCluster[3] = -1 Then
		Return -1
	Else
		Local $iWeightedMedianX = 0
		Local $iWeightedMedianY = 0
		Local $iWeightedMedianDiv = 0
		Local $iTotalHold = 0
		For $i = 0 To UBound($aBestCluster[3]) - 1
			$iWeightedMedianX += $aDarkDrills[($aBestCluster[3])[$i]][0] * $g_aDrillLevelHP[$aDarkDrills[($aBestCluster[3])[$i]][2] - 1]
			$iWeightedMedianY += $aDarkDrills[($aBestCluster[3])[$i]][1] * $g_aDrillLevelHP[$aDarkDrills[($aBestCluster[3])[$i]][2] - 1]
			$iWeightedMedianDiv += $g_aDrillLevelHP[$aDarkDrills[($aBestCluster[3])[$i]][2] - 1]
			$iTotalHold += $aDarkDrills[($aBestCluster[3])[$i]][3]
		Next
		$aBestCluster[0] = Ceiling(Number($iWeightedMedianX / $iWeightedMedianDiv))
		$aBestCluster[1] = Ceiling(Number($iWeightedMedianY / $iWeightedMedianDiv))
		$aBestCluster[2] = $iTotalHold
		If $g_bDebugSmartZap = True Then SetLog("Best Cluster: weighted x = " & $aBestCluster[0] & ", weighted y = " & $aBestCluster[1] & ", hold = " & $aBestCluster[2], $COLOR_DEBUG)
		Return $aBestCluster
	EndIf
EndFunc   ;==>getDrillCluster
