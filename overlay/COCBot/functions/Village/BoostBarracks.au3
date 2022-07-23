; #FUNCTION# ====================================================================================================================
; Name ..........: BoostBarracks.au3
; Description ...:
; Syntax ........: BoostBarracks(), BoostSpellFactory(), BoostWorkshop(), BoostTrainingPotion()
; Parameters ....:
; Return values .: None
; Author ........: MR.ViPER (9/9/2016)
; Modified ......: MR.ViPER (17/10/2016), Fliegerfaust (21/12/2017), Boldina (29/1/2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BoostBarracks()
	Return BoostTrainBuilding("Barracks", $g_iCmbBoostBarracks, $g_hCmbBoostBarracks)
EndFunc   ;==>BoostBarracks

Func BoostSpellFactory()
	Return BoostTrainBuilding("Spell Factory", $g_iCmbBoostSpellFactory, $g_hCmbBoostSpellFactory)
EndFunc   ;==>BoostSpellFactory

Func BoostWorkshop()
	Return BoostTrainBuilding("Workshop", $g_iCmbBoostWorkshop, $g_hCmbBoostWorkshop)
EndFunc   ;==>BoostWorkshop

Func BoostTrainBuilding($sName, $iCmbBoost, $iCmbBoostCtrl)
	Local $bBoosted = False

	; Schedule boost - Team AIO Mod++
	If Not $g_bTrainEnabled Or $iCmbBoost <= 0 Then Return $bBoosted
	
	If Not IsScheduleBoost($sName) Then Return $bBoosted
	; ===============================
	
	; Safe logic
	If $iCmbBoost <= 0 Then
		Return
	ElseIf $iCmbBoost >= 1 And $iCmbBoost <= 24 Then
		$iCmbBoost -= 1
		_GUICtrlComboBox_SetCurSel($iCmbBoostCtrl, $iCmbBoost)
		SetLog("Remaining " & $sName & " Boosts: " & $iCmbBoost, $COLOR_SUCCESS)
	ElseIf $iCmbBoost = 25 Then
		SetLog("Remain " & $sName & " Boosts: Unlimited", $COLOR_SUCCESS)
	EndIf
	
	Local $sIsAre = "are"
	SetLog("Boosting " & $sName, $COLOR_INFO)
	
	If OpenArmyOverview(True, "BoostTrainBuilding()") Then
		If $sName = "Barracks" Then
			If Not OpenTroopsTab(True, "BoostTrainBuilding()") Then Return
		ElseIf $sName = "Spell Factory" Then
			If Not OpenSpellsTab(True, "BoostTrainBuilding()") Then Return
			$sIsAre = "is"
		ElseIf $sName = "Workshop" Then
			If Not OpenSiegeMachinesTab(True, "BoostTrainBuilding()") Then Return
			$sIsAre = "is"
		Else
			SetDebugLog("BoostTrainBuilding(): $sName called with a wrong Value.", $COLOR_ERROR)
			ClickAway()
			If _Sleep($DELAYBOOSTBARRACKS2) Then Return ; Custom fix - Team AIO Mod++
			Return $bBoosted
		EndIf
		Local $aBoostBtn = findButton("BoostBarrack")
		If IsArray($aBoostBtn) Then
			ClickP($aBoostBtn)
			If _Sleep($DELAYBOOSTBARRACKS1) Then Return ; Custom fix - Team AIO Mod++
			Local $aGemWindowBtn = findButton("GEM")
			If IsArray($aGemWindowBtn) Then
				ClickP($aGemWindowBtn)
				If _Sleep($DELAYBOOSTBARRACKS2) Then Return ; Custom fix - Team AIO Mod++
				If IsArray(findButton("EnterShop")) Then
					SetLog("Not enough gems to boost " & $sName, $COLOR_ERROR)
				Else
					$bBoosted = True
					; Force to get the Remain Time
					If $sName = "Barracks" Then
						$g_aiTimeTrain[0] = 0 ; reset Troop remaining time
					Else
						$g_aiTimeTrain[1] = 0 ; reset Spells remaining time
					EndIf
				EndIf
			EndIf
		Else
			If IsArray(findButton("BarrackBoosted")) Then
				SetLog($sName & " " & $sIsAre & " already boosted", $COLOR_SUCCESS)
			Else
				SetLog($sName & "boost button not found", $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	ClickAway() ; ClickP($aAway, 1, 0, "#0161")
	If _Sleep($DELAYBOOSTBARRACKS2) Then Return ; Custom fix - Team AIO Mod++
	Return $bBoosted
EndFunc   ;==>BoostTrainBuilding

Func BoostEverything()
	; Custom fix - Team AIO Mod++
	#Region - Dates - Team AIO Mod++
	If _DateIsValid($g_sBoostEverythingTime) Then
		Local $iDateDiff = _DateDiff('s', _NowCalc(), $g_sBoostEverythingTime)
		If $iDateDiff > 0 And $g_sConstBoostEverything > $iDateDiff Then
			SetLog("Boost everything: We will return when the boost is neccessary.", $COLOR_INFO)
			Return
		EndIf
	EndIf
	#EndRegion - Dates - Team AIO Mod++

	; Verifying existent Variables to run this routine
	If Not AllowBoosting("Everything", $g_iCmbBoostEverything) Then Return

	SetLog("Boosting Everything", $COLOR_INFO)
	If $g_aiTownHallPos[0] = "" Or $g_aiTownHallPos[0] = -1 Then
		LocateTownHall()
		SaveConfig()
		If _Sleep($DELAYBOOSTBARRACKS2) Then Return
	EndIf
	
	; Custom fix - Team AIO Mod++
	; Local $bReturn = BoostPotion("Everything", "Town Hall", $g_aiTownHallPos, $g_iCmbBoostEverything, $g_hCmbBoostEverything) = _NowCalc() ??????? 
	Local $bReturn = BoostPotion("Everything", "Town Hall", $g_aiTownHallPos, $g_iCmbBoostEverything, $g_hCmbBoostEverything)
	
	If $bReturn Then
	
		; Custom boost - Team AIO Mod++ 
		$g_sBoostEverythingTime = _DateAdd('n', 60, _NowCalc()) ; Very important save this in config, it is better than others things

		; Reset troops
		$g_aiTimeTrain[0] = 0

		; Reset spells
		$g_aiTimeTrain[1] = 0

		; Reset heros
		$g_aiTimeTrain[2] = 0
		
		; Reset sieges
		$g_aiTimeTrain[3] = 0
	EndIf

	If _Sleep($DELAYBOOSTBARRACKS3) Then Return
	checkMainScreen(False) ; Check for errors during function
	Return $bReturn ; Custom fix - Team AIO Mod++
EndFunc   ;==>BoostEverything
