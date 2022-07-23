; #FUNCTION# ====================================================================================================================
; Name ..........: StartClockTowerBoost
; Description ...:
; Syntax ........: StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False)
; Parameters ....: $bSwitchToBB: Switch from Normal Village to Builder Base - $bSwitchToNV: Switch back to normal Village after Function ran
; Return values .: None
; Author ........: Fliegerfaust (06-2017), MMHK (07-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TestStartClockTowerBoost()
	Setlog("** TestStartClockTowerBoost START**", $COLOR_DEBUG)
	; Local $iAvailableAttacksBB = $g_iAvailableAttacksBB
	Local $DebugSetlog = $g_bDebugSetlog
	$g_bDebugSetlog = True
	; $g_iAvailableAttacksBB = 2
	Local $Status = $g_bRunState
	$g_bRunState = True
	StartClockTowerBoost()
	; $g_iAvailableAttacksBB = $iAvailableAttacksBB
	$g_bDebugSetlog = $DebugSetlog
	$g_bRunState = $Status
	Setlog("** TestStartClockTowerBoost END**", $COLOR_DEBUG)
EndFunc   ;==>TestStartClockTowerBoost

Func StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False)

	If $g_bChkStartClockTowerBoost = False And $g_bChkClockTowerPotion = False Then Return ; Custom BB - Team AIO Mod++
	If Not $g_bRunState Then Return

	If $bSwitchToBB Then
		ClickAway()
		If Not SwitchBetweenBases() Then 
			Return ; Switching to Builders Base
		EndIf
	EndIf
	
	#Region - Custom BB - Team AIO Mod++
	Local $bLabOn = False, $bCanBoost = False, $bCanUsePotion = False, $iTimeDiff = 0
	If $g_sStarLabUpgradeTime <> "" Then 
		$iTimeDiff = _DateDiff("n", _NowCalc(), $g_sStarLabUpgradeTime)
		$bLabOn = $iTimeDiff <= 0
	EndIf
	
	Local $bBuildersOn = False
	getBuilderCount(True, True)
	$bBuildersOn = ($g_iFreeBuilderCountBB <> $g_iTotalBuilderCountBB)
	
	If Not $g_bRunState Then Return

	If $g_bChkStartClockTowerBoost = True Then
		Switch $g_iCmbStartClockTowerBoost
			Case 0 ; Always.
				$bCanBoost = True
			Case 1 ; Lab or builder active.
				If $bLabOn = True Or $bBuildersOn = True Then $bCanBoost = True
			Case 2 ; Lab and builder active.
				If $bLabOn = True And $bBuildersOn = True Then $bCanBoost = True
			Case 3 ; Builder active.
				If $bBuildersOn = True Then $bCanBoost = True
			Case 4 ; Lab active.
				If $bLabOn = True Then $bCanBoost = True
		EndSwitch
	EndIf

	If Not $g_bRunState Then Return

	If $g_bChkClockTowerPotion = True Then
		Switch $g_iCmbClockTowerPotion
			Case 0 ; Lab or builder active.
				If $bLabOn = True Or $bBuildersOn = True Then $bCanUsePotion = True
			Case 1 ; Lab and builder active.
				If $bLabOn = True And $bBuildersOn = True Then $bCanUsePotion = True
			Case 2 ; Builder active.
				If $bBuildersOn = True Then $bCanUsePotion = True
			Case 3 ; Lab active.
				If $bLabOn = True Then $bCanUsePotion = True
		EndSwitch
	EndIf
	
	If Not $g_bRunState Then Return

	If $bCanBoost = True Or $bCanUsePotion = True Then
		SetLog("Boosting Clock Tower", $COLOR_ACTION)
		If _Sleep($DELAYCOLLECT2) Then Return
	
		Local $sCTCoords, $aCTCoords, $aCTBoost
		$sCTCoords = findImage("ClockTowerAvailable", $g_sImgStartCTBoost, "FV", 1, True) ; Search for Clock Tower
		If $sCTCoords <> "" Then
			$aCTCoords = StringSplit($sCTCoords, ",", $STR_NOCOUNT)
			ClickP($aCTCoords)
			If _Sleep($DELAYCLOCKTOWER1) Then Return
			
			#Region - Custom BB - Team AIO Mod++
			If $bCanBoost = True Then
				$aCTBoost = findButton("BoostCT") ; Search for Start Clock Tower Boost Button
				If IsArray($aCTBoost) Then
					ClickP($aCTBoost)
					If _Sleep($DELAYCLOCKTOWER1) Then Return
		
					$aCTBoost = findButton("BOOSTBtn") ; Search for Boost Button
					If IsArray($aCTBoost) Then
						ClickP($aCTBoost)
						If _Sleep($DELAYCLOCKTOWER2) Then Return
						SetLog("Boosted Clock Tower successfully!", $COLOR_SUCCESS)
					Else
						SetLog("Failed to find the BOOST window button", $COLOR_ERROR)
					EndIf
				Else
					SetLog("Cannot find the Boost Button of Clock Tower", $COLOR_ERROR)
				EndIf
			EndIf
		
			If $bCanUsePotion = True Then
				BoostPotionMod("ClockTowerPotion") ; Custom BB - Team AIO Mod++
			EndIf
			#EndRegion - Custom BB - Team AIO Mod++
	
		Else
			SetLog("Clock Tower boost is not available!", $COLOR_INFO)
		EndIf
	Else
		SetLog("The conditions to accelerate the tower are not met.", $COLOR_INFO)
	EndIf
	#EndRegion - Custom BB - Team AIO Mod++

	ClickAway()

	If $bSwitchToNV Then SwitchBetweenBases() ; Switching back to the normal Village if true
EndFunc   ;==>StartClockTowerBoost
