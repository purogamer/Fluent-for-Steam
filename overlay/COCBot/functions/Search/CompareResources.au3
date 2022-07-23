; #FUNCTION# ====================================================================================================================
; Name ..........: CompareResources
; Description ...: Compaires Resources while searching for a village to attack
; Syntax ........: CompareResources()
; Parameters ....:
; Return values .: True if compaired resources match the search conditions, False if not
; Author ........: (2014)
; Modified ......: AtoZ, Hervidero (2015), kaganus (June 2015, August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: VillageSearch, GetResources
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CompareResources($pMode) ;Compares resources and returns true if conditions meet, otherwise returns false
	#Region - Legend trophy protection - Team AIO Mod++
	If (($g_bLeagueAttack Or $g_bForceProtectLL) And $g_bProtectInLL) Then
		SetLog("Legend League protection: Skipped Compare Resources.", $COLOR_ACTION)
		Return True
	EndIf
	#EndRegion - Legend trophy protection - Team AIO Mod++

	#Region - Custom Search Reduction - Team AIO Mod++
	If $g_bSearchReductionEnable And ($g_bSearchReductionByCount Or $g_bSearchReductionByMin) Then
		Local $bSearchRedByCountAllowed = False, $bSearchRedByMinAllowed = False, $iHowManyTime = 1
		If $g_bSearchReductionByCount Then
			$bSearchRedByCountAllowed = $g_bSearchReductionByCount And $g_iSearchCount <> 0 And Mod(Number($g_iSearchCount), Number($g_iSearchReductionCount)) = 0
			SetDebugLog("CompareResources Search Reduction By Count = " & $bSearchRedByCountAllowed)
		EndIf
		If $g_bSearchReductionByMin Then
			Local $iSearchTimePassedInMin = Round(_DateDiff("s", $g_iSearchTotalSearchTime, _NowCalc()) / 60, 2)
			$bSearchRedByMinAllowed = $g_bSearchReductionByMin And Number($g_iSearchReductionByMin) > 0 And $iSearchTimePassedInMin >= Number($g_iSearchReductionByMin)
			If $bSearchRedByMinAllowed Then
				$iHowManyTime = Int(Number($iSearchTimePassedInMin) / Number($g_iSearchReductionByMin))
				If $iHowManyTime < 1 Then $iHowManyTime = 1
				$g_iSearchRedByMinHowManyTime = $iHowManyTime
			EndIf
			SetDebugLog("CompareResources Search Reduction By Time, Search Time '" & $iSearchTimePassedInMin & "/" & $g_iSearchReductionByMin & "' = " & $bSearchRedByMinAllowed)
		EndIf
		If $bSearchRedByCountAllowed Or $bSearchRedByMinAllowed Then
			For $i = 1 To $iHowManyTime
				If $g_iAimGold[$pMode] - $g_iSearchReductionGold >= 0 Then $g_iAimGold[$pMode] -= $g_iSearchReductionGold
				If $g_iAimElixir[$pMode] - $g_iSearchReductionElixir >= 0 Then $g_iAimElixir[$pMode] -= $g_iSearchReductionElixir
				If $g_iAimDark[$pMode] - $g_iSearchReductionDark >= 0 Then $g_iAimDark[$pMode] -= $g_iSearchReductionDark
				If $g_iAimTrophy[$pMode] - $g_iSearchReductionTrophy >= 0 Then $g_iAimTrophy[$pMode] -= $g_iSearchReductionTrophy
				If $g_iAimTrophyMax[$pMode] + $g_iSearchReductionTrophy < 99 Then $g_iAimTrophyMax[$pMode] += $g_iSearchReductionTrophy
				If $g_iAimGoldPlusElixir[$pMode] - $g_iSearchReductionGoldPlusElixir >= 0 Then $g_iAimGoldPlusElixir[$pMode] -= $g_iSearchReductionGoldPlusElixir
			Next
			Local $txtTrophies = "", $txtShieldTrophies = "", $txtTownhall = ""
			If $g_abFilterMeetTrophyEnable[$pMode] Then $txtTrophies = " [T]:" & StringFormat("%2s", $g_iAimTrophy[$pMode]) & "-" & StringFormat("%2s", $g_iAimTrophyMax[$pMode])
			If $g_abFilterMeetTH[$pMode] Then $txtTownhall = " [TH]:" & StringFormat("%2s", $g_aiMaxTH[$pMode])
			If $g_abFilterMeetTHOutsideEnable[$pMode] Then $txtTownhall &= ", Out"
			If $g_aiFilterMeetGE[$pMode] = 2 Then
				SetLog("Aim:           [G+E]:" & StringFormat("%7s", $g_iAimGoldPlusElixir[$pMode]) & " [D]:" & StringFormat("%5s", $g_iAimDark[$pMode]) & $txtTrophies & $txtShieldTrophies & $txtTownhall & " for: " & $g_asModeText[$pMode], $COLOR_SUCCESS, "Lucida Console", 7.5)
			Else
				SetLog("Aim: [G]:" & StringFormat("%7s", $g_iAimGold[$pMode]) & " [E]:" & StringFormat("%7s", $g_iAimElixir[$pMode]) & " [D]:" & StringFormat("%5s", $g_iAimDark[$pMode]) & $txtTrophies & $txtShieldTrophies & $txtTownhall & " for: " & $g_asModeText[$pMode], $COLOR_SUCCESS, "Lucida Console", 7.5)
			EndIf
		EndIf
	EndIf
	#EndRegion - Custom Search Reduction - Team AIO Mod++
	Local $bGoldMet = (Number($g_iSearchGold) >= Number($g_iAimGold[$pMode])), $bElixirMet = (Number($g_iSearchElixir) >= Number($g_iAimElixir[$pMode]))
    Local $bDarkElixirMet = (Number($g_iSearchDark) >= Number($g_iAimDark[$pMode]))
    Local $bTrophiesMet = (Number($g_iSearchTrophy) >= Number($g_iAimTrophy[$pMode])) And (Number($g_iSearchTrophy) <= Number($g_iAimTrophyMax[$pMode]))
    Local $bGoldPlusElxirMet = ((Number($g_iSearchGold) + Number($g_iSearchElixir)) >= Number($g_iAimGoldPlusElixir[$pMode]))

	If $g_abFilterMeetOneConditionEnable[$pMode] Then
		If $g_aiFilterMeetGE[$pMode] = 0 Then
			If $bGoldMet And $bElixirMet Then Return True
		EndIf

		If $g_abFilterMeetDEEnable[$pMode] Then
			If $bDarkElixirMet Then Return True
		EndIf

		If $g_abFilterMeetTrophyEnable[$pMode] Then
			If $bTrophiesMet Then Return True
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 1 Then
			If $bGoldMet Or $bElixirMet Then Return True
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 2 Then
			If $bGoldPlusElxirMet Then Return True
		EndIf

		Return False
	Else
		If $g_aiFilterMeetGE[$pMode] = 0 Then
			If Not $bGoldMet Or Not $bElixirMet Then Return False
		EndIf

		If $g_abFilterMeetDEEnable[$pMode] Then
			If Not $bDarkElixirMet Then Return False
		EndIf

		If $g_abFilterMeetTrophyEnable[$pMode] Then
			If Not $bTrophiesMet Then Return False
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 1 Then
			If Not $bGoldMet And Not $bElixirMet Then Return False
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 2 Then
			If Not $bGoldPlusElxirMet Then Return False
		EndIf
	EndIf

	Return True
EndFunc   ;==>CompareResources

Func CompareTH($pMode)
	Local $THL = -1, $THLO = -1
	Local $Modetext[3] = ["DB", "LB", "DT"]
	If $g_iSearchTH = 6 Then $g_iSearchTH = "4-6"
	For $i = 0 To UBound($g_asTHText) - 1
		If $g_iSearchTH = $g_asTHText[$i] Then $THL = $i
	Next
	; SetDebugLog("CompareTH| $pMode: " & $Modetext[$pMode])
	; SetDebugLog("CompareTH| $g_sTHLoc: " & $g_sTHLoc)
	; SetDebugLog("CompareTH| $THL: " & $THL)
	; SetDebugLog("CompareTH| $g_abFilterMeetOneConditionEnable: " & $g_abFilterMeetOneConditionEnable[$pMode])
	; SetDebugLog("CompareTH| $g_abFilterMeetTH: " & $g_abFilterMeetTH[$pMode])
	; SetDebugLog("CompareTH| $g_abFilterMeetTHOutsideEnable: " & $g_abFilterMeetTHOutsideEnable[$pMode])
	; SetDebugLog("CompareTH| $g_aiFilterMeetTHMin: " & $g_aiFilterMeetTHMin[$pMode])
	Switch $g_sTHLoc
		Case "In"
			$THLO = 0
		Case "Out"
			$THLO = 1
	EndSwitch
	$g_iSearchTHLResult = 0
	If $THL > -1 And $g_iSearchTH <> "-" Then $g_iSearchTHLResult = 1
	If $g_abFilterMeetOneConditionEnable[$pMode] Then
		If $g_abFilterMeetTH[$pMode] Then
			If $THL <> -1 And $THL <= $g_aiFilterMeetTHMin[$pMode] Then
				SetDebugLog("CompareTH| case 1")
				Return True
			EndIf
		EndIf
		If $g_abFilterMeetTHOutsideEnable[$pMode] Then
			If $THLO = 1 Then
				SetDebugLog("CompareTH| case 2 True")
				Return True
			EndIf
		EndIf
		SetDebugLog("CompareTH| case 3 False")
		Return False
	Else
		If $g_abFilterMeetTH[$pMode] Then
			If $THL = -1 Or $THL > $g_aiFilterMeetTHMin[$pMode] Then
				SetDebugLog("CompareTH| case 4 False")
				Return False
			EndIf
		EndIf
		If $g_abFilterMeetTHOutsideEnable[$pMode] Then
			If $THLO <> 1 Then
				SetDebugLog("CompareTH| case 5 False")
				Return False
			EndIf
		EndIf
	EndIf
	SetDebugLog("CompareTH| case 6 True")
	Return True
EndFunc   ;==>CompareTH