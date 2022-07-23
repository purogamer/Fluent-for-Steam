; #FUNCTION# ====================================================================================================================
; Name ..........: easyPreySearch
; Description ...: Searches for easy targets in the base, and returns; X, Y location, and Weight/Count
; Syntax ........: easyPreySearch()
; Parameters ....: None
; Return values .: Array with data on easy targets found in search
; Author ........: TripleM (04-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func easyPreySearch()
	Local $aReturnResult[0][3]
	Local $pixelerror = 10, $iMaxCombDist = 60

	For $iLoop = 1 To 3 ; Search 3 times
		If $iLoop > 1 Then ; with 5 sec pause inbetween, so whole search covers a time intervall of around 10 sec
			If _Sleep(5000) Then Return
		EndIf

		Local $aResult = multiMatches($g_sImgEasyBuildings, 0, $CocDiamondECD, $CocDiamondECD)
		If $g_bDebugSmartZap = True Then
			If UBound($aResult) = 2 Then
				SetLog("1 target type found in " & $iLoop & ". searchround.", $COLOR_DEBUG)
			Else
				SetLog(UBound($aResult) - 1 & " target types found in " & $iLoop & ". searchround.", $COLOR_DEBUG)
			EndIf
		EndIf

		For $iResult = 1 To UBound($aResult) - 1 ; Loop through all resultrows, skipping first row, which is searcharea, each matched img has its own row, if no resultrow, for is skipped
			If _Sleep(10) Then Return
			Local $aTemp[0][2]
			_ArrayAdd($aTemp, $aResult[$iResult][5], 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING) ; Copy Positionarray to temp array
			_ArrayColInsert($aTemp, 2) ; Adding Weight Column
			For $iRow = 0 To UBound($aTemp) - 1
				$aTemp[$iRow][2] = 1 ; Setting Weight Column to 1
			Next
			_ArrayAdd($aReturnResult, $aTemp, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING) ; Adding temp array to return array
		Next
	Next

	; Removing Duplicate Targets
	Local $iResult = 0
	While $iResult < UBound($aReturnResult)
		If _Sleep(10) Then Return
		Local $jResult = $iResult + 1
		While $jResult < UBound($aReturnResult)
			If Abs($aReturnResult[$iResult][0] - $aReturnResult[$jResult][0]) <= $pixelerror And Abs($aReturnResult[$iResult][1] - $aReturnResult[$jResult][1]) <= $pixelerror Then
				If $g_bDebugSmartZap = True Then
					SetLog("Found Duplicate Target: [" & $aReturnResult[$jResult][0] & "," & $aReturnResult[$jResult][1] & "]", $COLOR_DEBUG)
				EndIf
				_ArrayDelete($aReturnResult, $jResult)
			Else
				$jResult += 1
			EndIf
		WEnd
		$iResult += 1
	WEnd

	; Consolidating Targets
	Local $iResult = 0
	While $iResult < UBound($aReturnResult)
		If _Sleep(10) Then Return
		Local $jResult = $iResult + 1
		While $jResult < UBound($aReturnResult)
			If Abs($aReturnResult[$iResult][0] - $aReturnResult[$jResult][0]) + Abs($aReturnResult[$iResult][1] - $aReturnResult[$jResult][1]) <= $iMaxCombDist Then
				If $g_bDebugSmartZap = True Then
					SetLog("Found Targets for consolidation: [" & $aReturnResult[$iResult][0] & "," & $aReturnResult[$iResult][1] & "," & $aReturnResult[$iResult][2] & "] & [" & $aReturnResult[$jResult][0] & "," & $aReturnResult[$jResult][1] & "," & $aReturnResult[$jResult][2] & "]", $COLOR_DEBUG)
				EndIf
				Local $iNewWeight = $aReturnResult[$iResult][2] + $aReturnResult[$jResult][2]
				$aReturnResult[$iResult][0] = Ceiling(Number(($aReturnResult[$iResult][0] * $aReturnResult[$iResult][2] + $aReturnResult[$jResult][0] * $aReturnResult[$jResult][2]) / $iNewWeight))
				$aReturnResult[$iResult][1] = Ceiling(Number(($aReturnResult[$iResult][1] * $aReturnResult[$iResult][2] + $aReturnResult[$jResult][1] * $aReturnResult[$jResult][2]) / $iNewWeight))
				$aReturnResult[$iResult][2] = $iNewWeight
				_ArrayDelete($aReturnResult, $jResult)
				ContinueLoop 2
			EndIf
			$jResult += 1
		WEnd
		$iResult += 1
	WEnd

	If UBound($aReturnResult) > 1 Then _ArraySort($aReturnResult, 1, 0, 0, 2)

	Return $aReturnResult
EndFunc   ;==>easyPreySearch
