; #FUNCTION# ====================================================================================================================
; Name ..........: CustomBoost.au3
; Description ...: Check one gem boost.
; Author ........: Ahsan Iqbal (2018)
; Modified ......: Boldina (08/2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func OneGemBoost($bDebug = False)
	If $g_bChkOneGemBoostBarracks Or $g_bChkOneGemBoostSpells Or $g_bChkOneGemBoostHeroes Or $g_bChkOneGemBoostWorkshop Or $bDebug Then
		SetLog("Checking 1-Gem Army Event", $COLOR_INFO)
	Else
		Return
	EndIf

	; Schedule boost - Team AIO Mod++
	If Not IsScheduleBoost("One gem boost") Then Return

	Static $aHeroBoostedStartTime[$g_eTotalAcc][$eHeroCount], $aBuildingBoostedStartTime[$g_eTotalAcc][3], $aLastTimeChecked = $g_PreResetZero

	If $aLastTimeChecked[$g_iCurAccount] <> 0 And Not $bDebug Then
		Local $iDateCalc = _DateDiff('n', _NowCalc(), $aLastTimeChecked[$g_iCurAccount])
		If $iDateCalc <= 0 Then
			SetDebugLog("Forcing 1-Gem Event Boost Check After 2 Hours.", $COLOR_INFO)
			$g_bOneGemEventEnded = False
		EndIf
	EndIf

	If $g_bOneGemEventEnded Then
		SetLog("1-Gem Army Boost Event Ended. Skip It!", $COLOR_INFO)
		Return
	EndIf

	If $g_bChkOneGemBoostHeroes Or $bDebug Then
		For $i = 0 To $eHeroCount - 1
			If $g_iHeroUpgrading[$i] <> 1 Then
				Local $iChkIfBoostHero = _DateDiff("s", $aHeroBoostedStartTime[$g_iCurAccount][$i], _NowCalc())
				If $g_bFirstStart Or $aHeroBoostedStartTime[$g_iCurAccount][$i] = "" Or $iChkIfBoostHero > 3600 Or $bDebug Then
					If CheckHeroOneGem($i, $bDebug) Then
						$aHeroBoostedStartTime[$g_iCurAccount][$i] = _NowCalc()
					EndIf
					If $g_bOneGemEventEnded Then ExitLoop
				Else
					SetDebugLog("Skip 1-Gem Boost For " & $g_asHeroNames[$i] & " $aHeroBoostedStartTime=" & $aHeroBoostedStartTime[$g_iCurAccount][$i] & ", $iChkIfBoostHero=" & $iChkIfBoostHero & " sec")
				EndIf
			Else
				SetDebugLog("Skip 1-Gem Boost Check For " & $g_asHeroNames[$i] & " as it's on upgrade.")
			EndIf
		Next
		SetDebugLog("$aHeroBoostedStartTime= " & $aHeroBoostedStartTime[$g_iCurAccount][0] & "|" & $aHeroBoostedStartTime[$g_iCurAccount][1] & "|" & $aHeroBoostedStartTime[$g_iCurAccount][2])
	EndIf
	If ($g_bChkOneGemBoostBarracks Or $g_bChkOneGemBoostSpells Or $g_bChkOneGemBoostWorkshop Or $bDebug) And Not $g_bOneGemEventEnded Then
		Local $aBoostBuildingNames = ["Barracks", "Spell Factory", "Workshop"]
		Local $aChkOneGemBoost = [$g_bChkOneGemBoostBarracks, $g_bChkOneGemBoostSpells, $g_bChkOneGemBoostWorkshop]
		For $i = 0 To 2
			Local $iChkIfBoostBuilding = _DateDiff("s", $aBuildingBoostedStartTime[$g_iCurAccount][$i], _NowCalc())
			If ($g_bFirstStart Or $aBuildingBoostedStartTime[$g_iCurAccount][$i] = "" Or $iChkIfBoostBuilding > 3600) And $aChkOneGemBoost[$i] Or $bDebug Then
				If OpenArmyOverview(False, "BoostTrainBuilding()") Then
					If BoostOneGemBuilding($aBoostBuildingNames[$i], $bDebug) Then
						$aBuildingBoostedStartTime[$g_iCurAccount][$i] = _NowCalc()
					EndIf
				EndIf
			ElseIf $aChkOneGemBoost[$i] Or $bDebug Then
				SetDebugLog("Skip 1-Gem Boost For " & $g_asHeroNames[$i] & " $aBuildingBoostedStartTime=" & $aBuildingBoostedStartTime[$g_iCurAccount][$i] & ", $iChkIfBoostBuilding=" & $iChkIfBoostBuilding & " sec")
			EndIf
		Next
		ClickAway()
		If _Sleep($DELAYBOOSTHEROES4) Then Return

		ClickAway()
		If _Sleep($DELAYBOOSTBARRACKS2) Then Return
		SetDebugLog("$aBuildingBoostedStartTime= " & $aBuildingBoostedStartTime[$g_iCurAccount][0] & "|" & $aBuildingBoostedStartTime[$g_iCurAccount][1] & "|" & $aBuildingBoostedStartTime[$g_iCurAccount][2])
	EndIf
	If $g_bOneGemEventEnded Then SetLog("1-Gem Army Boost Event Ended. Skip It!", $COLOR_INFO)
	$aLastTimeChecked[$g_iCurAccount] = _DateAdd('h', 2, _NowCalc())
EndFunc   ;==>OneGemBoost

Func CheckOneGem()
	If Number(StringStripWS(QuickMIS("OCR", $g_sImgOneGemBoostOCR, 370, 420 + $g_iBottomOffsetYFixed, 500, 470 + $g_iBottomOffsetYFixed), $STR_STRIPALL)) = 1 Then Return True ; Resolution changed ?
	SetLog("The 1 gem event is not available.", $COLOR_ERROR)
	Return False
EndFunc   ;==>CheckOneGem

Func CheckHeroOneGem($iIndex, $bDebug = False)
	Local $bHeroBoosted = False
	Local $aHerosPos[4] = [$g_aiKingAltarPos, $g_aiQueenAltarPos, $g_aiWardenAltarPos, $g_aiChampionAltarPos]

	If $iIndex >= UBound($aHerosPos) Then
		SetLog("CheckHeroOneGem bad index.", $COLOR_ERROR)
		Return $bHeroBoosted
	EndIf

	If $aHerosPos[$iIndex] = "" Or $aHerosPos[$iIndex] = -1 Then
		SetLog("Please Locate " & $g_asHeroNames[$i], $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYBOOSTHEROES4) Then Return

	BuildingClickP($aHerosPos[$iIndex], "#0462")

	If _Sleep($DELAYBOOSTHEROES1) Then Return

	Local $aBoostBtn = findButton("BoostOne")
	If IsArray($aBoostBtn) Then
		SetDebugLog($g_asHeroNames[$iIndex] & " Boost Button X|Y = " & $aBoostBtn[0] & "|" & $aBoostBtn[1], $COLOR_DEBUG)
		ClickP($aBoostBtn)
		If _Sleep($DELAYBOOSTHEROES1) Then Return
		Local $aGemWindowBtn = findButton("GEM")
		If IsArray($aGemWindowBtn) Then
			If Not CheckOneGem() Then

				ClickAway()
				If _Sleep($DELAYBOOSTHEROES4) Then Return

				ClickAway()
				If _Sleep($DELAYBOOSTHEROES4) Then Return

				If Not $bDebug Then $g_bOneGemEventEnded = True
				Return
			EndIf
			If Not $bDebug Then
				ClickP($aGemWindowBtn)
			Else
				ClickAway()
			EndIf
			If _Sleep($DELAYBOOSTHEROES4) Then Return
			If WaitforPixel(360, 347, 500, 405, Hex(0xE5F985, 6), 25, 2) Then ; Fixed resolution
				SetLog("Not enough gems to boost " & $g_asHeroNames[$iIndex], $COLOR_ERROR)
			Else
				$bHeroBoosted = True
				SetLog($g_asHeroNames[$iIndex] & " boosted successfully with 1-Gem", $COLOR_SUCCESS)
				$g_aiTimeTrain[2] = 0
			EndIf
		Else
			SetLog($g_asHeroNames[$iIndex] & " is already Boosted", $COLOR_SUCCESS)
		EndIf
	EndIf

	ClickAway()
	If _Sleep($DELAYBOOSTHEROES4) Then Return

	ClickAway()
	If _Sleep($DELAYBOOSTHEROES4) Then Return

	Return $bHeroBoosted
EndFunc   ;==>CheckHeroOneGem

Func BoostOneGemBuilding($sBoostBuildingNames, $bDebug = False)
	Local $bBuildingBoosted = False
	Local $sIsAre = "are"
	SetLog("Boosting " & $sBoostBuildingNames & " With 1-Gem", $COLOR_INFO)
	Switch $sBoostBuildingNames
		Case "Barracks"
			OpenTroopsTab(True, "BoostOneGemBuilding()")
		Case "Spell Factory"
			OpenSpellsTab(True, "BoostOneGemBuilding()")
			$sIsAre = "is"
		Case "Workshop"
			OpenSiegeMachinesTab(True, "BoostOneGemBuilding()")
			$sIsAre = "is"
		Case Else
			SetDebugLog("BoostOneGemBuilding(): $sName called with a wrong Value.", $COLOR_ERROR)
			ClickAway()
			If _Sleep($DELAYBOOSTBARRACKS2) Then Return
			Return
	EndSwitch

	Local $aBoostBtn = findButton("BoostBarrack")
	If IsArray($aBoostBtn) Then
		SetDebugLog($sBoostBuildingNames & " Boost Button X|Y = " & $aBoostBtn[0] & "|" & $aBoostBtn[1], $COLOR_DEBUG)
		ClickP($aBoostBtn)
		If _Sleep($DELAYBOOSTBARRACKS1) Then Return
		Local $aGemWindowBtn = findButton("GEM")
		If IsArray($aGemWindowBtn) Then
			If Not CheckOneGem() Then
				If _Sleep($DELAYBOOSTHEROES4) Then Return
				ClickAway()
				If _Sleep($DELAYBOOSTHEROES4) Then Return

				ClickAway()
				If _Sleep($DELAYBOOSTHEROES4) Then Return

				If Not $bDebug Then $g_bOneGemEventEnded = True
				Return
			EndIf
			If Not $bDebug Then
				ClickP($aGemWindowBtn)
			Else
				ClickAway()
			EndIf
			If _Sleep($DELAYBOOSTBARRACKS2) Then Return
			If WaitforPixel(360, 347, 500, 405, Hex(0xE5F985, 6), 25, 2) Then ; Fixed resolution
				SetLog("Not enough gems to boost ", $COLOR_ERROR)
			Else
				$bBuildingBoosted = True
				SetLog($sBoostBuildingNames & " " & $sIsAre & " boosted successfully with 1-Gem", $COLOR_SUCCESS)
				If $sBoostBuildingNames = "Barracks" Then
					$g_aiTimeTrain[0] = 0
				ElseIf $sBoostBuildingNames = "Spell Factory" Then
					$g_aiTimeTrain[1] = 0
				ElseIf $sBoostBuildingNames = "Workshop" Then
					$g_aiTimeTrain[3] = 0
				EndIf
			EndIf
		EndIf
	Else
		If IsArray(findButton("BarrackBoosted")) Then
			SetLog($sBoostBuildingNames & " " & $sIsAre & " already boosted", $COLOR_SUCCESS)
		Else
			SetLog($sBoostBuildingNames & "boost button not found", $COLOR_ERROR)
		EndIf
	EndIf
	If _Sleep(250) Then Return
	Return $bBuildingBoosted
EndFunc   ;==>BoostOneGemBuilding

; #FUNCTION# ====================================================================================================================
; Name ..........: CustomBoost.au3
; Description ...: Schedule boost.
; Author ........: Boldina (02/02/2022)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2022
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func TestIsScheduleBoost()
	$g_aiCurrentLoot[$eLootGold] = 1000000
	$g_aiCurrentLoot[$eLootElixir] = 1000000
	$g_aiCurrentLoot[$eLootDarkElixir] = 10000
	If IsScheduleBoost("TestIsScheduleBoost") Then
		SetLog("TestIsScheduleBoost cond ok")
	EndIf
EndFunc   ;==>TestIsScheduleBoost

Func IsScheduleBoost($sCalledFrom = "-")
	Local $bMustBoost = True

	Local $aHours = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
	If Not $g_abBoostBarracksHours[$aHours[0]] Then
		SetLog("Boosting " & $sCalledFrom & " isn't planned, skipping", $COLOR_INFO)
		Return False
	EndIf

	If $g_iCommandStop = 0 Or $g_iCommandStop = 3 Then ;halt attack.. do not boost now
		SetLog("[" & $sCalledFrom & "] " & "Boost skipped, account on halt attack mode.", $COLOR_ACTION)
		Return False
	EndIf

	If $g_iSwitchBoostSchedule[$eLootGold] = 1 Then
		$bMustBoost = ($g_aiCurrentLoot[$eLootGold] >= $g_iMinBoostGold) = False
	ElseIf $g_iSwitchBoostSchedule[$eLootGold] = 2 Then
		$bMustBoost = ($g_aiCurrentLoot[$eLootGold] < $g_iMinBoostGold)
	EndIf

	If $bMustBoost Then
		If $g_iSwitchBoostSchedule[$eLootElixir] = 1 Then
			$bMustBoost = ($g_aiCurrentLoot[$eLootElixir] >= $g_iMinBoostElixir) = False
		ElseIf $g_iSwitchBoostSchedule[$eLootElixir] = 2 Then
			$bMustBoost = ($g_aiCurrentLoot[$eLootElixir] < $g_iMinBoostElixir)
		EndIf

	EndIf

	If $bMustBoost Then
		If StringIsSpace($g_aiCurrentLoot[$eLootDarkElixir]) = 0 Then ; check if the village have a Dark Elixir Storage
			If $g_iSwitchBoostSchedule[$eLootDarkElixir] = 1 Then
				$bMustBoost = ($g_aiCurrentLoot[$eLootDarkElixir] >= $g_iMinBoostDark) = False
			ElseIf $g_iSwitchBoostSchedule[$eLootDarkElixir] = 2 Then
				$bMustBoost = ($g_aiCurrentLoot[$eLootDarkElixir] < $g_iMinBoostDark)
			EndIf
		EndIf
	EndIf

	If $bMustBoost = False Then SetLog("[" & $sCalledFrom & "] " & "Boost skipped, resource condition successfully completed.", $COLOR_SUCCESS)

	Return $bMustBoost
EndFunc   ;==>IsScheduleBoost

; GUI Ctrl
Func CmbSwitchBoostSchedule()
	$g_iSwitchBoostSchedule[$eLootGold] = _GUICtrlComboBox_GetCurSel($g_hCmbSwitchBoostSchedule[0])
	If $g_iSwitchBoostSchedule[$eLootGold] = 0 Then
		GUICtrlSetState($g_hTxtMinBoostGold, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hTxtMinBoostGold, $GUI_ENABLE)
	EndIf

	$g_iSwitchBoostSchedule[$eLootElixir] = _GUICtrlComboBox_GetCurSel($g_hCmbSwitchBoostSchedule[1])
	If $g_iSwitchBoostSchedule[$eLootElixir] = 0 Then
		GUICtrlSetState($g_hTxtMinBoostElixir, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hTxtMinBoostElixir, $GUI_ENABLE)
	EndIf

	$g_iSwitchBoostSchedule[$eLootDarkElixir] = _GUICtrlComboBox_GetCurSel($g_hCmbSwitchBoostSchedule[2])
	If $g_iSwitchBoostSchedule[$eLootDarkElixir] = 0 Then
		GUICtrlSetState($g_hTxtMinBoostDark, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hTxtMinBoostDark, $GUI_ENABLE)
	EndIf
EndFunc   ;==>CmbSwitchBoostSchedule
