; #FUNCTION# ====================================================================================================================
; Name ..........: Train Revamp Oct 2016
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Mr.Viper(10-2016), ProMac(10-2016), CodeSlinger69 (01-2018)
; Modified ......: ProMac (11-2016), Boju (11-2016), MR.ViPER (12-2016), CodeSlinger69 (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#include <Array.au3>
#include <MsgBoxConstants.au3>
Func TrainSystem()
	If Not $g_bTrainEnabled Then ; check for training disabled in halt mode
		If $g_bDebugSetlogTrain Then SetLog("Halt mode - training disabled", $COLOR_DEBUG)
		$g_bForceDoubleTrain = False ; Custom train - Team AIO Mod++
		Return
	EndIf

	$g_sTimeBeforeTrain = _NowCalc()
	StartGainCost()
	
	; Custom BoostSuperTroop - Team AIO Mod++
	If $g_bQuickTrainEnable Then
		BoostSuperTroop()
		If _Sleep(1000) Then Return
		
		CheckMainScreen(False, False)
	EndIf
	
	If $g_bQuickTrainEnable Then CheckQuickTrainTroop() ; update values of $g_aiArmyComTroops, $g_aiArmyComSpells

	CheckIfArmyIsReady()
	
	#Region - Custom train - Team AIO Mod++
	If $g_bQuickTrainEnable Then
		Local $bPreTrainFlag = $g_bDoubleTrain
		If $g_bChkPreTrainTroopsPercent And $g_bForceDoubleTrain = False Then
			$bPreTrainFlag = ($g_iArmyCapacity >= $g_iInpPreTrainTroopsPercent)
			SetLog("Double train condition ? " & $bPreTrainFlag, $COLOR_INFO)
		ElseIf $g_bForceDoubleTrain = True Then
			SetLog("Force double train before switch account.", $COLOR_SUCCESS)
			$g_bForceDoubleTrain = False
			$bPreTrainFlag = True
		EndIf
		QuickTrain($bPreTrainFlag)
	Else
		TrainCustomArmy()
	EndIf
	#EndRegion - Custom train - Team AIO Mod++

	TrainSiege()

	If $g_bDonationEnabled And $g_bChkDonate Then ResetVariables("donated")
	
	#Region - Custom train - Team AIO Mod++
	; Inspired in Samkie
	; Stick to Army page when time left - Team AIO Mod++
	If $g_iStickToTrainWindow = 0 Or (ProfileSwitchAccountEnabled() And (Abs($g_aiAttackedCountSwitch[$g_iCurAccount]) <= 2)) Then
		SetDebugLog("Not enabled waiting.")
	ElseIf OpenArmyTab(False, "TrainSystem()") Then 

		Local $iLoop = 0
		Do
			$iLoop += 1
			
			Local $iCount = 0, $iStickDelay = 0
			While 1
				
				If Not $g_bRunState Then Return
				getArmyTroopTime(False, False, True, ($iCount = 0))
				
				If $g_aiTimeTrain[0] <= 0 Then
					Local $sResultTroops = getRemainTrainTimer(468, 169 + $g_iMidOffsetYFixed)
					If StringRight($sResultTroops, 1) = "s" And StringLen($sResultTroops) < 4 Then
						$g_aiTimeTrain[0] = Number("0." & Number($sResultTroops))
						$g_aiTimeTrain[0] = Int($g_aiTimeTrain[0] * Random(1.10, 1.25, 1))
					EndIf
				EndIf
				
				If _Sleep($DELAYRESPOND) Then Return
				If $g_aiTimeTrain[0] > $g_iStickToTrainWindow Or $g_aiTimeTrain[0] <= 0 Then
					If $iLoop <> 1 Then
						ExitLoop
					Else
						ContinueLoop 2
					EndIf
				Else
					If $g_aiTimeTrain[0] < 1 Then
						$iStickDelay = Round($g_aiTimeTrain[0] * 1000)
						$g_aiTimeTrain[0] = 0
					ElseIf $g_aiTimeTrain[0] >= 2 Then
						$iStickDelay = 60000
					Else
						$iStickDelay = 30000
					EndIf
					SetLog("[" & $iCount & "] Waiting for troops to be ready.", $COLOR_INFO)
					If _Sleep($iStickDelay) Then Return
				EndIf
				$iCount += 1
				If $iCount > (10 + $g_iStickToTrainWindow) Then ExitLoop
			WEnd
		Until True
	EndIf
	#EndRegion - Custom train - Team AIO Mod++

	ClickAway() ; ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

	EndGainCost("Train")

	checkAttackDisable($g_iTaBChkIdle) ; Check for Take-A-Break after opening train page
EndFunc   ;==>TrainSystem

Func TrainCustomArmy() ; Custom train - Team AIO Mod++
	If Not $g_bRunState Then Return

	If $g_bDebugSetlogTrain Then SetLog(" == Initial Custom Train == ", $COLOR_ACTION)

	;If $bDonateTrain = -1 Then SetbDonateTrain()
	If $g_iActiveDonate = -1 Then PrepareDonateCC()

	DoubleTrain(False)
	
	#cs
	If Not $g_bRunState Then Return

	If Not $g_bFullArmy Then
		Local $rWhatToTrain = WhatToTrain(True) ; r in First means Result! Result of What To Train Function

		RemoveExtraTroops($rWhatToTrain)
	EndIf

	If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop

	Local $bEmptyTroopQueue = IsQueueEmpty("Troops")
	Local $bEmptySpellQueue = IsQueueEmpty("Spells")

	If $bEmptyTroopQueue Or $bEmptySpellQueue Then
		If Not $g_bRunState Then Return
		If Not OpenArmyTab(False, "TrainCustomArmy()") Then Return
		Local $rWhatToTrain = WhatToTrain()

		If $bEmptyTroopQueue And DoWhatToTrainContainTroop($rWhatToTrain) Then TrainUsingWhatToTrain($rWhatToTrain)
		If $bEmptySpellQueue And DoWhatToTrainContainSpell($rWhatToTrain) Then BrewUsingWhatToTrain($rWhatToTrain)
	EndIf

	If _Sleep(250) Then Return
	If Not $g_bRunState Then Return
	#ce
EndFunc   ;==>TrainCustomArmy

Func CheckIfArmyIsReady()

	If Not $g_bRunState Then Return

	Local $bFullArmyCC = False
	Local $iTotalSpellsToBrew = 0
	Local $bFullArmyHero = False
	Local $bFullSiege = False
	$g_bWaitForCCTroopSpell = False ; reset for waiting CC in SwitchAcc

	If Not OpenArmyOverview(False, "CheckIfArmyIsReady()") Then Return
	If _Sleep(250) Then Return

	CheckArmyCamp(False, False, True, True)

	If $g_bDebugSetlogTrain Then
		SetLog(" - $g_CurrentCampUtilization : " & $g_CurrentCampUtilization)
		SetLog(" - $g_iTotalCampSpace : " & $g_iTotalCampSpace)
		SetLog(" - $g_bFullArmy : " & $g_bFullArmy)
		SetLog(" - $g_bPreciseArmy : " & $g_bPreciseArmy)
	EndIf

	$g_bFullArmySpells = False
	; Local Variable to check the occupied space by the Spells to Brew ... can be different of the Spells Factory Capacity ( $g_iTotalSpellValue )
	For $i = 0 To $eSpellCount - 1
		$iTotalSpellsToBrew += $g_aiArmyCompSpells[$i] * $g_aiSpellSpace[$i]
	Next

	If Number($g_iCurrentSpells) >= Number($g_iTotalSpellValue) Or Number($g_iCurrentSpells) >= Number($iTotalSpellsToBrew) Then $g_bFullArmySpells = True

	If (Not $g_bFullArmy And Not $g_bFullArmySpells) Or $g_bPreciseArmy Then
		Local $avWrongTroops = WhatToTrain(True)
		Local $rRemoveExtraTroops = RemoveExtraTroops($avWrongTroops)
		If $rRemoveExtraTroops = 1 Or $rRemoveExtraTroops = 2 Then
			CheckArmyCamp(False, False, False, False)
			$g_bFullArmySpells = Number($g_iCurrentSpells) >= Number($g_iTotalSpellValue) Or Number($g_iCurrentSpells) >= Number($iTotalSpellsToBrew)
		EndIf
	EndIf

	$g_bCheckSpells = CheckSpells()

	; add to the hereos available, the ones upgrading so that it ignores them... we need this logic or the bitwise math does not work out correctly
	$g_iHeroAvailable = BitOR($g_iHeroAvailable, $g_iHeroUpgradingBit)
	$bFullArmyHero = (BitAND($g_aiSearchHeroWaitEnable[$DB], $g_iHeroAvailable) = $g_aiSearchHeroWaitEnable[$DB] And $g_abAttackTypeEnable[$DB]) Or _
			(BitAND($g_aiSearchHeroWaitEnable[$LB], $g_iHeroAvailable) = $g_aiSearchHeroWaitEnable[$LB] And $g_abAttackTypeEnable[$LB]) Or _
			($g_aiSearchHeroWaitEnable[$DB] = $eHeroNone And $g_aiSearchHeroWaitEnable[$LB] = $eHeroNone)

	If $g_bDebugSetlogTrain Then
		Setlog("Heroes are Ready: " & String($bFullArmyHero))
		Setlog("Heroes Available Num: " & $g_iHeroAvailable) ;  	$eHeroNone = 0, $eHeroKing = 1, $eHeroQueen = 2, $eHeroWarden = 4, $eHeroChampion = 5
		Setlog("Search Hero Wait Enable [$DB] Num: " & $g_aiSearchHeroWaitEnable[$DB]) ; 	what you are waiting for : 1 is King , 3 is King + Queen , etc etc
		Setlog("Search Hero Wait Enable [$LB] Num: " & $g_aiSearchHeroWaitEnable[$LB])
		Setlog("Dead Base BitAND: " & BitAND($g_aiSearchHeroWaitEnable[$DB], $g_iHeroAvailable))
		Setlog("Live Base BitAND: " & BitAND($g_aiSearchHeroWaitEnable[$LB], $g_iHeroAvailable))
		Setlog("Are you 'not' waiting for Heroes: " & String($g_aiSearchHeroWaitEnable[$DB] = $eHeroNone And $g_aiSearchHeroWaitEnable[$LB] = $eHeroNone))
		Setlog("Is Wait for Heroes Active : " & IsWaitforHeroesActive())
	EndIf

	$bFullArmyCC = IsFullClanCastle()
	$bFullSiege = CheckSiegeMachine()

	; If Drop Trophy with Heroes is checked and a Hero is Available or under the trophies range, then set $g_bFullArmyHero to True
	If Not IsWaitforHeroesActive() And $g_bDropTrophyUseHeroes Then $bFullArmyHero = True
	If Not IsWaitforHeroesActive() And Not $g_bDropTrophyUseHeroes And Not $bFullArmyHero Then
		If $g_iHeroAvailable > 0 Or Number($g_aiCurrentLoot[$eLootTrophy]) <= Number($g_iDropTrophyMax) Then
			$bFullArmyHero = True
		Else
			SetLog("Waiting for Heroes to drop trophies!", $COLOR_ACTION)
		EndIf
	EndIf

	If $g_bFullArmy And $g_bCheckSpells And $bFullArmyHero And $bFullArmyCC And $bFullSiege Then
		$g_bIsFullArmywithHeroesAndSpells = True
	Else
		If $g_bDebugSetlog Then
			SetDebugLog(" $g_bFullArmy: " & String($g_bFullArmy), $COLOR_DEBUG)
			SetDebugLog(" $g_bCheckSpells: " & String($g_bCheckSpells), $COLOR_DEBUG)
			SetDebugLog(" $bFullArmyHero: " & String($bFullArmyHero), $COLOR_DEBUG)
			SetDebugLog(" $bFullSiege: " & String($bFullSiege), $COLOR_DEBUG)
			SetDebugLog(" $bFullArmyCC: " & String($bFullArmyCC), $COLOR_DEBUG)
		EndIf
		$g_bIsFullArmywithHeroesAndSpells = False
	EndIf
	If $g_bFullArmy And $g_bCheckSpells And $bFullArmyHero Then ; Force Switch while waiting for CC in SwitchAcc
		If Not $bFullArmyCC Then $g_bWaitForCCTroopSpell = True
	EndIf

	Local $sLogText = ""
	If Not $g_bFullArmy Then $sLogText &= " Troops,"
	If Not $g_bCheckSpells Then $sLogText &= " Spells,"
	If Not $bFullArmyHero Then $sLogText &= " Heroes,"
	If Not $bFullSiege Then $sLogText &= " Siege Machine,"
	If Not $bFullArmyCC Then $sLogText &= " Clan Castle,"
	If StringRight($sLogText, 1) = "," Then $sLogText = StringTrimRight($sLogText, 1) ; Remove last "," as it is not needed

	If $g_bIsFullArmywithHeroesAndSpells Then
		If ($g_bNotifyTGEnable Or $g_bNotifyDSEnable) And $g_bNotifyAlertCampFull Then PushMsg("CampFull")
		SetLog("Chief, is your Army ready? Yes, it is!", $COLOR_SUCCESS)
	Else
		SetLog("Chief, is your Army ready? No, not yet!", $COLOR_ACTION)
		If $sLogText <> "" Then SetLog(@TAB & "Waiting for " & $sLogText, $COLOR_ACTION)
	EndIf

	; Force to Request CC troops or Spells
	If Not $bFullArmyCC Then $g_bCanRequestCC = True
	If $g_bDebugSetlog Then
		SetDebugLog(" $g_bFullArmy: " & String($g_bFullArmy), $COLOR_DEBUG)
		SetDebugLog(" $bCheckCC: " & String($bFullArmyCC), $COLOR_DEBUG)
		SetDebugLog(" $g_bIsFullArmywithHeroesAndSpells: " & String($g_bIsFullArmywithHeroesAndSpells), $COLOR_DEBUG)
		SetDebugLog(" $g_iTownHallLevel: " & Number($g_iTownHallLevel), $COLOR_DEBUG)
	EndIf

EndFunc   ;==>CheckIfArmyIsReady

Func CheckSpells()
	If Not $g_bRunState Then Return

	Local $bToReturn = False

	If (Not $g_abSearchSpellsWaitEnable[$DB] And Not $g_abSearchSpellsWaitEnable[$LB]) Or ($g_bFullArmySpells And ($g_abSearchSpellsWaitEnable[$DB] Or $g_abSearchSpellsWaitEnable[$LB])) Then
		Return True
	EndIf

	If (($g_abAttackTypeEnable[$DB] And $g_abSearchSpellsWaitEnable[$DB]) Or ($g_abAttackTypeEnable[$LB] And $g_abSearchSpellsWaitEnable[$LB])) And $g_iTownHallLevel >= 5 Then
		$bToReturn = $g_bFullArmySpells
	Else
		$bToReturn = True
	EndIf

	Return $bToReturn
EndFunc   ;==>CheckSpells

Func CheckSiegeMachine()

	If Not $g_bRunState Then Return

	Local $bToReturn = True

	If IsWaitforSiegeMachine() Then
		For $i = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			If $g_aiCurrentSiegeMachines[$i] < $g_aiArmyCompSiegeMachines[$i] Then $bToReturn = False
			If $g_bDebugSetlogTrain Then
				SetLog("$g_aiCurrentSiegeMachines[" & $g_asSiegeMachineNames[$i] & "]: " & $g_aiCurrentSiegeMachines[$i])
				SetLog("$g_aiArmyCompSiegeMachine[" & $g_asSiegeMachineNames[$i] & "]: " & $g_aiArmyCompSiegeMachines[$i])
			EndIf
		Next
	Else
		$bToReturn = True
	EndIf

	Return $bToReturn
EndFunc   ;==>CheckSiegeMachine

Func TrainUsingWhatToTrain($rWTT, $bQueue = $g_bIsFullArmywithHeroesAndSpells)
	If Not $g_bRunState Then Return

	If UBound($rWTT) = 1 And $rWTT[0][0] = "Arch" And $rWTT[0][1] = 0 Then Return True ; If was default Result of WhatToTrain

	If Not OpenTroopsTab(True, "TrainUsingWhatToTrain()") Then Return

	; Loop through needed troops to Train
	For $i = 0 To (UBound($rWTT) - 1)
		If Not $g_bRunState Then Return
		If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
			If IsSpellToBrew($rWTT[$i][0]) Then ContinueLoop
			Local $iTroopIndex = TroopIndexLookup($rWTT[$i][0], "TrainUsingWhatToTrain()")

			If $iTroopIndex >= $eBarb And $iTroopIndex <= $eBarb + $eTroopCount - 1 Then
				Local $NeededSpace = $g_aiTroopSpace[$iTroopIndex] * $rWTT[$i][1]
			EndIf

			Local $aLeftSpace = GetOCRCurrent(48, 160 + $g_iMidOffsetYFixed)
			Local $LeftSpace = $bQueue ? ($aLeftSpace[1] * 2) - $aLeftSpace[0] : $aLeftSpace[2]


			If $NeededSpace > $LeftSpace Then
				If $iTroopIndex >= $eBarb And $iTroopIndex <= $eBarb + $eTroopCount - 1 Then
					$rWTT[$i][1] = Int($LeftSpace / $g_aiTroopSpace[$iTroopIndex])
				EndIf
			EndIf

			If $rWTT[$i][1] > 0 Then
				If Not DragIfNeeded($rWTT[$i][0]) Then Return False

				If $iTroopIndex >= $eBarb And $iTroopIndex <= $eBarb + $eTroopCount - 1 Then
					Local $sTroopName = ($rWTT[$i][1] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
				EndIf

                SetLog("Training " & $rWTT[$i][1] & "x " & $sTroopName, $COLOR_SUCCESS)
                TrainIt($iTroopIndex, $rWTT[$i][1], $g_iTrainClickDelay)
			EndIf
		EndIf
		If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
	Next

	Return True
EndFunc   ;==>TrainUsingWhatToTrain

Func BrewUsingWhatToTrain($rWTT, $bQueue = $g_bIsFullArmywithHeroesAndSpells)
	If Not $g_bRunState Then Return

	If UBound($rWTT) = 1 And $rWTT[0][0] = "Arch" And $rWTT[0][1] = 0 Then Return True ; If was default Result of WhatToTrain

	If Not OpenSpellsTab(True, "BrewUsingWhatToTrain()") Then Return

	; Loop through needed troops to Train
	For $i = 0 To (UBound($rWTT) - 1)
		If Not $g_bRunState Then Return
		If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
			If Not IsSpellToBrew($rWTT[$i][0]) Then ContinueLoop
			Local $iSpellIndex = TroopIndexLookup($rWTT[$i][0], "BrewUsingWhatToTrain")
			Local $NeededSpace = $g_aiSpellSpace[$iSpellIndex - $eLSpell] * $rWTT[$i][1]

			Local $aLeftSpace = GetOCRCurrent(43, 160 + $g_iMidOffsetYFixed)
			Local $LeftSpace = $bQueue ? ($aLeftSpace[1] * 2) - $aLeftSpace[0] : $aLeftSpace[2]

			If $NeededSpace > $LeftSpace Then $rWTT[$i][1] = Int($LeftSpace / $g_aiSpellSpace[$iSpellIndex - $eLSpell])
			If $rWTT[$i][1] > 0 Then
				Local $sSpellName = $g_asSpellNames[$iSpellIndex - $eLSpell]
                SetLog("Brewing " & $rWTT[$i][1] & "x " & $sSpellName & ($rWTT[$i][1] > 1 ? " Spells" : " Spell"), $COLOR_SUCCESS)
                TrainIt($iSpellIndex, $rWTT[$i][1], $g_iTrainClickDelay)
			EndIf
		EndIf
		If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
	Next
EndFunc   ;==>BrewUsingWhatToTrain

Func TotalTroopsToTrainInGUI()
	Local $iTotalTroopsInGUI = 0
	If $g_iTotalCampSpace = 0 Then Return $iTotalTroopsInGUI
	If Not $g_bRunState Then Return
	For $i = 0 To $eTroopCount - 1
		$iTotalTroopsInGUI += $g_aiArmyCompTroops[$i] * $g_aiTroopSpace[$i]
	Next
	Return $iTotalTroopsInGUI
EndFunc   ;==>TotalSpellsToBrewInGUI

Func TotalSpellsToBrewInGUI()
	Local $iTotalSpellsInGUI = 0
	If $g_iTotalSpellValue = 0 Then Return $iTotalSpellsInGUI
	If Not $g_bRunState Then Return
	For $i = 0 To $eSpellCount - 1
		$iTotalSpellsInGUI += $g_aiArmyCompSpells[$i] * $g_aiSpellSpace[$i]
	Next
	Return $iTotalSpellsInGUI
EndFunc   ;==>TotalSpellsToBrewInGUI

Func DragIfNeeded($Troop)

	If Not $g_bRunState Then Return
	Local $bCheckPixel = False

	If IsDarkTroop($Troop) Then
		If _ColorCheck(_GetPixelColor(834, 403 + $g_iMidOffsetYFixed, True), Hex(0xD3D3CB, 6), 5) Then $bCheckPixel = True
		If $g_bDebugSetlogTrain Then SetLog("DragIfNeeded Dark Troops: " & $bCheckPixel)
		For $i = 1 To 3
			If Not $bCheckPixel Then
				ClickDrag(715, 445 + $g_iMidOffsetY, 220, 445 + $g_iMidOffsetY, 2000)
				If _Sleep(1500) Then Return
				If _ColorCheck(_GetPixelColor(834, 403, True), Hex(0xD3D3CB, 6), 5) Then $bCheckPixel = True
			Else
				Return True
			EndIf
		Next
	Else
		If _ColorCheck(_GetPixelColor(22, 403 + $g_iMidOffsetYFixed, True), Hex(0xD3D3CB, 6), 5) Then $bCheckPixel = True
		If $g_bDebugSetlogTrain Then SetLog("DragIfNeeded Normal Troops: " & $bCheckPixel)
		For $i = 1 To 3
			If Not $bCheckPixel Then
				ClickDrag(220, 445 + $g_iMidOffsetY, 725, 445 + $g_iMidOffsetY, 2000)
				If _Sleep(1500) Then Return
				If _ColorCheck(_GetPixelColor(22, 403 + $g_iMidOffsetYFixed, True), Hex(0xD3D3CB, 6), 5) Then $bCheckPixel = True
			Else
				Return True
			EndIf
		Next
	EndIf
	SetLog("Failed to Verify Troop " & $g_asTroopNames[TroopIndexLookup($Troop, "DragIfNeeded")] & " Position or Failed to Drag Successfully", $COLOR_ERROR)
	Return False
EndFunc   ;==>DragIfNeeded

Func DoWhatToTrainContainTroop($rWTT)
	If UBound($rWTT) = 1 And $rWTT[0][0] = "Arch" And $rWTT[0][1] = 0 Then Return False ; If was default Result of WhatToTrain
	For $i = 0 To (UBound($rWTT) - 1)
		If (IsElixirTroop($rWTT[$i][0]) Or IsDarkTroop($rWTT[$i][0])) And $rWTT[$i][1] > 0 Then Return True
	Next
	Return False
EndFunc   ;==>DoWhatToTrainContainTroop

Func DoWhatToTrainContainSpell($rWTT)
	For $i = 0 To (UBound($rWTT) - 1)
		If Not $g_bRunState Then Return
		If IsSpellToBrew($rWTT[$i][0]) Then
			If $rWTT[$i][1] > 0 Then Return True
		EndIf
	Next
	Return False
EndFunc   ;==>DoWhatToTrainContainSpell

Func IsElixirTroop($Troop)
	Local $iIndex = TroopIndexLookup($Troop, "IsElixirTroop")
	If $iIndex >= $eBarb And $iIndex <= $eRDrag Then Return True
	Return False
EndFunc   ;==>IsElixirTroop

Func IsDarkTroop($Troop)
	Local $iIndex = TroopIndexLookup($Troop, "IsDarkTroop")
	If $iIndex >= $eMini And $iIndex <= $eBarb + $eTroopCount - 1 Then Return True
	Return False
EndFunc   ;==>IsDarkTroop

Func IsElixirSpell($Spell)
	Local $iIndex = TroopIndexLookup($Spell, "IsElixirSpell")
	If $iIndex >= $eLSpell And $iIndex <= $eISpell Then Return True
	Return False
EndFunc   ;==>IsElixirSpell

Func IsDarkSpell($Spell)
	Local $iIndex = TroopIndexLookup($Spell, "IsDarkSpell")
	If $iIndex >= $ePSpell And $iIndex <= $eBtSpell Then Return True
	Return False
EndFunc   ;==>IsDarkSpell

Func IsSpellToBrew($sName)
	Local $iIndex = TroopIndexLookup($sName, "IsSpellToBrew")
	If $iIndex >= $eLSpell And $iIndex <= $eBtSpell Then Return True
	Return False
EndFunc   ;==>IsSpellToBrew

Func RemoveExtraTroops($toRemove)
	Local $CounterToRemove = 0, $iResult = 0
	; Army Window should be open and should be in Tab 'Army tab'

	; 1 Means Removed Troops without Deleting Troops Queued
	; 2 Means Removed Troops And Also Deleted Troops Queued
	; 3 Means Didn't removed troop... Everything was well

	If UBound($toRemove) = 1 And $toRemove[0][0] = "Arch" And $toRemove[0][1] = 0 Then Return 3

	If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And Not $g_iActiveDonate Then Return 3

	If UBound($toRemove) > 0 Then ; If needed to remove troops

		; Check if Troops to remove are already in Train Tab Queue!! If was, Will Delete All Troops Queued Then Check Everything Again...
		If DoWhatToTrainContainTroop($toRemove) And Not IsQueueEmpty("Troops", True, False) Then
			SetLog("Clear troop queue before removing unexpected troops in army", $COLOR_INFO)
			DeleteQueued("Troops")
			$iResult = 2
		EndIf

		If DoWhatToTrainContainSpell($toRemove) And Not IsQueueEmpty("Spells", True, False) Then
			SetLog("Clear spell queue before removing unexpected spells in army", $COLOR_INFO)
			DeleteQueued("Spells")
			$iResult = 2
		EndIf

		If $iResult = 2 Then $toRemove = WhatToTrain(True) ; Check Everything Again...

		Local $rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		Local $rGetSlotNumberSpells = GetSlotNumber(True)

		SetLog("Troops To Remove: ", $COLOR_INFO)
		$CounterToRemove = 0
		; Loop through Troops needed to get removed Just to write some Logs
		For $i = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
			$CounterToRemove += 1
			SetLog(" - " & $g_asTroopNames[TroopIndexLookup($toRemove[$i][0])] & ": " & $toRemove[$i][1] & "x", $COLOR_SUCCESS)
		Next

		If $CounterToRemove <= UBound($toRemove) Then
			SetLog("Spells To Remove: ", $COLOR_INFO)
			For $i = $CounterToRemove To (UBound($toRemove) - 1)
				SetLog(" - " & $g_asSpellNames[TroopIndexLookup($toRemove[$i][0]) - $eLSpell] & ": " & $toRemove[$i][1] & "x", $COLOR_SUCCESS)
			Next
		EndIf
		
		; Custom multilanguaje support - Team AIO Mod++
		If Not WaitforPixel($aButtonEditArmy[0], $aButtonEditArmy[1], $aButtonEditArmy[0] + 34, $aButtonEditArmy[1] + 24, Hex($aButtonEditArmy[2], 6), $aButtonEditArmy[3], 3) Then ; If no 'Edit Army' Button found in army tab to edit troops
			SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_WARNING)
			Return False ; Exit function
		EndIf

		ClickP($aButtonEditArmy, 1) ; Click Edit Army Button
		If _Sleep(500) Then Return

		; Loop through troops needed to get removed
		$CounterToRemove = 0
		For $j = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$j][0]) Then ExitLoop
			$CounterToRemove += 1
			For $i = 0 To (UBound($rGetSlotNumber) - 1) ; Loop through All available slots
				; $toRemove[$j][0] = Troop name, E.g: Barb, $toRemove[$j][1] = Quantity to remove
				If $toRemove[$j][0] = $rGetSlotNumber[$i] Then ; If $toRemove Troop Was the same as The Slot Troop
					Local $pos = GetSlotRemoveBtnPosition($i + 1) ; Get positions of - Button to remove troop
					ClickRemoveTroop($pos, $toRemove[$j][1], $g_iTrainClickDelay) ; Click on Remove button as much as needed
				EndIf
			Next
		Next

		For $j = $CounterToRemove To (UBound($toRemove) - 1)
			For $i = 0 To (UBound($rGetSlotNumberSpells) - 1) ; Loop through All available slots
				; $toRemove[$j][0] = Troop name, E.g: Barb, $toRemove[$j][1] = Quantity to remove
				If $toRemove[$j][0] = $rGetSlotNumberSpells[$i] Then ; If $toRemove Troop Was the same as The Slot Troop
					Local $pos = GetSlotRemoveBtnPosition($i + 1, True) ; Get positions of - Button to remove troop
					ClickRemoveTroop($pos, $toRemove[$j][1], $g_iTrainClickDelay) ; Click on Remove button as much as needed
				EndIf
			Next
		Next

		If _Sleep(500) Then Return
		If Not _CheckPixel($aButtonRemoveTroopsOK1, True) Then ; If no 'Okay' button found in army tab to save changes
			SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_WARNING)
			ClickP($aAway, 2, 0, "#0346") ; Click Away, Necessary! due to possible errors/changes
			If _Sleep(400) Then OpenArmyOverview(True, "RemoveExtraTroops()") ; Open Army Window AGAIN
			Return False ; Exit Function
		EndIf

		If Not $g_bRunState Then Return
		ClickP($aButtonRemoveTroopsOK1, 1) ; Click on 'Okay' button to save changes
		If _Sleep(1200) Then Return
		If Not _CheckPixel($aButtonRemoveTroopsOK2, True) Then ; If no 'Okay' button found to verify that we accept the changes
			SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_WARNING)
			ClickAway() ; ClickP($aAway, 2, 0, "#0346") ;Click Away
			Return False ; Exit function
		EndIf

		ClickP($aButtonRemoveTroopsOK2, 1) ; Click on 'Okay' button to Save changes... Last button

		SetLog("All Extra troops removed", $COLOR_SUCCESS)
		If _Sleep(200) Then Return
		If $iResult = 0 Then $iResult = 1
	Else ; If No extra troop found
		SetLog("No extra troop to remove, great", $COLOR_SUCCESS)
		$iResult = 3
	EndIf

	Return $iResult
EndFunc   ;==>RemoveExtraTroops

Func DeleteInvalidTroopInArray(ByRef $aTroopArray)
	Local $iCounter = 0

	Switch (UBound($aTroopArray, 2) > 0) ; If Array Is 2D Array
		Case True
			Local $bIsValid = True, $i2DBound = UBound($aTroopArray, 2)
			For $i = 0 To (UBound($aTroopArray) - 1)
				If $aTroopArray[$i][0] Then
					If TroopIndexLookup($aTroopArray[$i][0], "DeleteInvalidTroopInArray#1") = -1 Or $aTroopArray[$i][0] = "" Then $bIsValid = False

					If $bIsValid Then
						For $j = 0 To (UBound($aTroopArray, 2) - 1)
							$aTroopArray[$iCounter][$j] = $aTroopArray[$i][$j]
						Next
						$iCounter += 1
					EndIf
				EndIf
			Next
			ReDim $aTroopArray[$iCounter][$i2DBound]
		Case Else
			For $i = 0 To (UBound($aTroopArray) - 1)
				If TroopIndexLookup($aTroopArray[$i], "DeleteInvalidTroopInArray#2") = -1 Or $aTroopArray[$i] = "" Then
					$aTroopArray[$iCounter] = $aTroopArray[$i]
					$iCounter += 1
				EndIf
			Next
			ReDim $aTroopArray[$iCounter]
	EndSwitch
EndFunc   ;==>DeleteInvalidTroopInArray

Func RemoveExtraTroopsQueue() ; Will remove All Extra troops in queue If there's a Low Opacity red color on them
	;Local Const $DecreaseBy = 70
	;Local $x = 834

	Local Const $y = 186 + $g_iMidOffsetYFixed, $yRemoveBtn = 200 + $g_iMidOffsetYFixed, $xDecreaseRemoveBtn = 10
	Local $bColorCheck = False, $bGotRemoved = False, $iRandomCS = $g_iTrainClickDelay
	For $x = 834 To 58 Step -70
		If Not $g_bRunState Then Return
		$bColorCheck = _ColorCheck(_GetPixelColor($x, $y, True), Hex(0xD7AFA9, 6), 20)
		If $bColorCheck Then
			$bGotRemoved = True
			Do
				$iRandomCS = Random(2, 5)
				Click($x - $xDecreaseRemoveBtn, $yRemoveBtn, Round($iRandomCS), Abs(Round($g_iTrainClickDelay / $iRandomCS)))
				; If _Sleep(20) Then Return
				$bColorCheck = _ColorCheck(_GetPixelColor($x, $y, True), Hex(0xD7AFA9, 6), 20)
			Until $bColorCheck = False

		ElseIf Not $bColorCheck And $bGotRemoved Then
			ExitLoop
		EndIf
	Next

	Return True
EndFunc   ;==>RemoveExtraTroopsQueue

Func IsQueueEmpty($sType = "Troops", $bSkipTabCheck = False, $removeExtraTroopsQueue = True)
	Local $iArrowX, $iArrowY

	If Not $g_bRunState Then Return

	If $sType = "Troops" Then
		$iArrowX = $aGreenArrowTrainTroops[0] ; aada82  170 218 130    | y + 3 = 6ab320 106 179 32
		$iArrowY = $aGreenArrowTrainTroops[1]
	ElseIf $sType = "Spells" Then
		$iArrowX = $aGreenArrowBrewSpells[0] ; a0d077  160 208 119    | y + 3 = 74be2c 116 190 44
		$iArrowY = $aGreenArrowBrewSpells[1]
	ElseIf $sType = "SiegeMachines" Then
		$iArrowX = $aGreenArrowTrainSiegeMachines[0]
		$iArrowY = $aGreenArrowTrainSiegeMachines[1]
	Else
		Return
	EndIf

	If Not _ColorCheck(_GetPixelColor($iArrowX, $iArrowY, True), Hex(0xa0d077, 6), 30) And Not _ColorCheck(_GetPixelColor($iArrowX, $iArrowY + 4, True), Hex(0x6ab320, 6), 30) Then
		Return True ; Check Green Arrows at top first, if not there -> Return
	ElseIf _ColorCheck(_GetPixelColor($iArrowX, $iArrowY, True), Hex(0xa0d077, 6), 30) And _ColorCheck(_GetPixelColor($iArrowX, $iArrowY + 4, True), Hex(0x6ab320, 6), 30) And Not $removeExtraTroopsQueue Then
		If Not WaitforPixel($iArrowX - 11, $iArrowY - 1, $iArrowX - 9, $iArrowY + 1, Hex(0xa0d077, 6), 30, 2) Then Return False  ; check if boost arrow
	EndIf

	If Not $bSkipTabCheck Or $removeExtraTroopsQueue Then
		If $sType = "Troops" Then
			If Not OpenTroopsTab(True, "IsQueueEmpty()") Then Return
		ElseIf $sType = "Spells" Then
			If Not OpenSpellsTab(True, "IsQueueEmpty()") Then Return
		Else
			If Not OpenSiegeMachinesTab(True, "IsQueueEmpty()") Then Return
		EndIf
	EndIf

	If Not $g_bIsFullArmywithHeroesAndSpells Then
		If $removeExtraTroopsQueue Then
			If Not _ColorCheck(_GetPixelColor(230, 208 + $g_iMidOffsetYFixed, True), Hex(0x677CB5, 6), 30) Then RemoveExtraTroopsQueue()
		EndIf
	EndIf

	If $removeExtraTroopsQueue Then
		If _ColorCheck(_GetPixelColor(230, 208 + $g_iMidOffsetYFixed, True), Hex(0x677CB5, 6), 20) Then Return True ; If No troops were in Queue Return True
	Else
		If _ColorCheck(_GetPixelColor(820, 208 + $g_iMidOffsetYFixed, True), Hex(0xD0D0C8, 6), 20) Then Return True ; check gray background at 1st training slot
	EndIf

	Return False
EndFunc   ;==>IsQueueEmpty

Func ClickRemoveTroop($pos, $iTimes, $iSpeed)
	$pos[0] = Random($pos[0] - 3, $pos[0] + 10, 1)
	$pos[1] = Random($pos[1] - 5, $pos[1] + 5, 1)
	If Not $g_bRunState Then Return
	If _Sleep(400) Then Return
	If $iTimes <> 1 Then
		If FastCaptureRegion() Then
			For $i = 0 To ($iTimes - 1)
				PureClick($pos[0], $pos[1], 1, $iSpeed) ;Click once.
				If _Sleep($iSpeed, False) Then ExitLoop
			Next
		Else
			PureClick($pos[0], $pos[1], $iTimes, $iSpeed) ;Click $iTimes.
			If _Sleep($iSpeed, False) Then Return
		EndIf
	Else
		PureClick($pos[0], $pos[1], 1, $iSpeed)

		If _Sleep($iSpeed, False) Then Return
	EndIf
EndFunc   ;==>ClickRemoveTroop

Func GetSlotRemoveBtnPosition($iSlot, $bSpells = False)
	Local $iRemoveY = Not $bSpells ? 270 : 417
	$iRemoveY += $g_iMidOffsetYFixed
	Local $iRemoveX = Number((74 * $iSlot) - 4)

	Local Const $aResult[2] = [$iRemoveX, $iRemoveY]
	Return $aResult
EndFunc   ;==>GetSlotRemoveBtnPosition

Func GetSlotNumber($bSpells = False)
	Select
		Case $bSpells = False
			Local Const $Orders = [$eBarb, $eSBarb, $eArch, $eSArch, $eGiant, $eSGiant, $eGobl, $eSGobl, $eWall, $eSWall, $eBall, $eRBall, $eWiza, $eSWiza, $eHeal, $eDrag, $eSDrag, $eYeti, $eRDrag, $ePekk, $eBabyD, $eInfernoD, $eMine, $eEDrag, _
					$eMini, $eSMini, $eHogs, $eValk, $eSValk, $eGole, $eWitc, $eSWitc, $eLava, $eIceH, $eBowl, $eSBowl, $eIceG, $eHunt] ; Set Order of troop display in Army Tab

			Local $allCurTroops[UBound($Orders)]

			; Code for Elixir Troops to Put Current Troops into an array by Order
			For $i = 0 To $eTroopCount - 1
				If Not $g_bRunState Then Return
				If $g_aiCurrentTroops[$i] > 0 Then
					For $j = 0 To (UBound($Orders) - 1)
						If TroopIndexLookup($g_asTroopShortNames[$i], "GetSlotNumber#1") = $Orders[$j] Then
							$allCurTroops[$j] = $g_asTroopShortNames[$i]
						EndIf
					Next
				EndIf
			Next

			;_ArrayDisplay($allCurTroops, "$allCurTroops")

			_ArryRemoveBlanks($allCurTroops)

			Return $allCurTroops
		Case $bSpells = True

			; Set Order of Spells display in Army Tab
			Local Const $SpellsOrders = [$eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $eISpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell, $eBtSpell]

			Local $allCurSpells[UBound($SpellsOrders)]

			; Code for Spells to Put Current Spells into an array by Order
			For $i = 0 To $eSpellCount - 1
				If Not $g_bRunState Then Return
				If $g_aiCurrentSpells[$i] > 0 Then
					For $j = 0 To (UBound($SpellsOrders) - 1)
						If TroopIndexLookup($g_asSpellShortNames[$i], "GetSlotNumber#2") = $SpellsOrders[$j] Then
							$allCurSpells[$j] = $g_asSpellShortNames[$i]
						EndIf
					Next
				EndIf
			Next

			_ArryRemoveBlanks($allCurSpells)

			Return $allCurSpells
	EndSelect
EndFunc   ;==>GetSlotNumber

Func WhatToTrain($ReturnExtraTroopsOnly = False, $bFullArmy = $g_bIsFullArmywithHeroesAndSpells)
	OpenArmyTab(False, "WhatToTrain()")
	Local $ToReturn[1][2] = [["Arch", 0]] ; 2 element dynamic list [troop, quantity]

	If $bFullArmy And Not $ReturnExtraTroopsOnly Then
		If Not $g_bFullArmySpells Then getArmySpells(False, False, False, False) ; in case $g_bIsFullArmywithHeroesAndSpells but not $g_bFullArmySpells

		Local $bHaltAttack = $g_iCommandStop = 3 Or $g_iCommandStop = 0 Or ($g_abDonateOnly[$g_iCurAccount] And ProfileSwitchAccountEnabled())
		If Not $bHaltAttack And $g_bTrainBeforeAttack Then ; Custom Train - Team AIO Mod++
			SetLog(" - Your Army is Full, let's make troops before Attack!", $COLOR_INFO)
			; Elixir Troops
			For $i = 0 To $eTroopCount - 1
				Local $troopIndex = $g_aiTrainOrder[$i]
				If $g_aiArmyCompTroops[$troopIndex] > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompTroops[$troopIndex]
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next

			; Spells
			For $i = 0 To $eSpellCount - 1
				Local $BrewIndex = $g_aiBrewOrder[$i]
				If $g_aiArmyCompSpells[$BrewIndex] > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$BrewIndex] - ($g_bFullArmySpells ? 0 : $g_aiCurrentSpells[$BrewIndex])
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next
		Else
			If $g_iCommandStop = 3 Or $g_iCommandStop = 0 Then
				SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_INFO)
			Else
				SetLog("Donate Only mode and your Army is prepared!", $COLOR_INFO)
			EndIf
			If Not $g_bFullArmySpells Then
				For $i = 0 To $eSpellCount - 1
					Local $BrewIndex = $g_aiBrewOrder[$i]
					If $g_aiArmyCompSpells[$BrewIndex] > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
						$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$BrewIndex] - $g_aiCurrentSpells[$BrewIndex]
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				Next
			EndIf
		EndIf
		Return $ToReturn
	EndIf

	; Get Current available troops
	getArmyTroops(False, False, False, False)
	getArmySpells(False, False, False, False)

	Switch $ReturnExtraTroopsOnly
		Case False
			; Check Elixir Troops needed quantity to Train
			For $ii = 0 To $eTroopCount - 1
				Local $troopIndex = $g_aiTrainOrder[$ii]
				If $g_aiArmyCompTroops[$troopIndex] > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompTroops[$troopIndex] - $g_aiCurrentTroops[$troopIndex]
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next

			; Check Spells needed quantity to Brew
			For $i = 0 To $eSpellCount - 1
				Local $BrewIndex = $g_aiBrewOrder[$i]
				If $g_aiArmyCompSpells[$BrewIndex] > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$BrewIndex] - $g_aiCurrentSpells[$BrewIndex]
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next
		Case Else
			; Check Elixir Troops Extra Quantity
			For $ii = 0 To $eTroopCount - 1
				Local $troopIndex = $g_aiTrainOrder[$ii]
				If $g_aiCurrentTroops[$troopIndex] > 0 Then
					If $g_aiArmyCompTroops[$troopIndex] - $g_aiCurrentTroops[$troopIndex] < 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
						$ToReturn[UBound($ToReturn) - 1][1] = Abs($g_aiArmyCompTroops[$troopIndex] - $g_aiCurrentTroops[$troopIndex])
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			Next

			; Check Spells Extra Quantity
			For $i = 0 To $eSpellCount - 1
				Local $BrewIndex = $g_aiBrewOrder[$i]
				If $g_aiCurrentSpells[$BrewIndex] > 0 Then
					If $g_aiArmyCompSpells[$BrewIndex] - $g_aiCurrentSpells[$BrewIndex] < 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
						$ToReturn[UBound($ToReturn) - 1][1] = Abs($g_aiArmyCompSpells[$BrewIndex] - $g_aiCurrentSpells[$BrewIndex])
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			Next
	EndSwitch
	DeleteInvalidTroopInArray($ToReturn)
	Return $ToReturn
EndFunc   ;==>WhatToTrain

Func CheckQueueTroops($bGetQuantity = True, $bSetLog = True, $x = 839, $bQtyWSlot = False)
	Local $aResult[1] = [""]
	If $bSetLog Then SetLog("Checking Troops Queue", $COLOR_INFO)

	Local $Dir = @ScriptDir & "\imgxml\ArmyOverview\TroopsQueued"

	Local $aSearchResult = SearchArmy($Dir, 18, 182 + $g_iMidOffsetYFixed, $x, 261 + $g_iMidOffsetYFixed, $bGetQuantity ? "Queue" : "")

	ReDim $aResult[UBound($aSearchResult)]


	If $aSearchResult[0][0] = "" Then
		Setlog("No Troops detected!", $COLOR_ERROR)
		Return
	EndIf

	For $i = 0 To (UBound($aSearchResult) - 1)
		If Not $g_bRunState Then Return
		$aResult[$i] = $aSearchResult[$i][0]
	Next

	If $bGetQuantity Then
		Local $aQuantities[UBound($aResult)][2]
		Local $aQueueTroop[$eTroopCount]
		For $i = 0 To (UBound($aQuantities) - 1)
			$aQuantities[$i][0] = $aSearchResult[$i][0]
			$aQuantities[$i][1] = $aSearchResult[$i][3]
			Local $iTroopIndex = TroopIndexLookup($aQuantities[$i][0])
			If $iTroopIndex >= 0 And $iTroopIndex < $eTroopCount Then
				If $bSetLog Then SetLog("  - " & $g_asTroopNames[TroopIndexLookup($aQuantities[$i][0], "CheckQueueTroops")] & ": " & $aQuantities[$i][1] & "x", $COLOR_SUCCESS)
				$aQueueTroop[$iTroopIndex] += $aQuantities[$i][1]
			Else
				; TODO check what to do with others
				SetDebugLog("Unsupport troop index: " & $iTroopIndex)
			EndIf
		Next
		If $bQtyWSlot Then Return $aQuantities
		Return $aQueueTroop
	EndIf

	_ArrayReverse($aResult)
	Return $aResult
EndFunc   ;==>CheckQueueTroops

Func CheckQueueSpells($bGetQuantity = True, $bSetLog = True, $x = 839, $bQtyWSlot = False)
	Local $avResult[$eSpellCount]
	Local $sImageDir = @ScriptDir & "\imgxml\ArmyOverview\SpellsQueued"

	If $bSetLog Then SetLog("Checking Spells Queue", $COLOR_INFO)
	Local $avSearchResult = SearchArmy($sImageDir, 18, 213 + $g_iMidOffsetYFixed, $x, 230 + $g_iMidOffsetYFixed, $bGetQuantity ? "Queue" : "")

	If $avSearchResult[0][0] = "" Then
		Setlog("No Spells detected!", $COLOR_ERROR)
		Return
	EndIf

	For $i = 0 To (UBound($avSearchResult) - 1)
		If Not $g_bRunState Then Return
		$avResult[$i] = $avSearchResult[$i][0]
	Next

	;Trim length to number of returned values
	ReDim $avResult[UBound($avSearchResult)][1]

	If $bGetQuantity Then
		Local $aiQuantities[UBound($avResult)][2]
		Local $aQueueSpell[$eSpellCount]
		For $i = 0 To (UBound($aiQuantities) - 1)
			If Not $g_bRunState Then Return
			$aiQuantities[$i][0] = $avSearchResult[$i][0]
			$aiQuantities[$i][1] = $avSearchResult[$i][3]
			If $bSetLog Then SetLog("  - " & $g_asSpellNames[TroopIndexLookup($aiQuantities[$i][0], "CheckQueueSpells") - $eLSpell] & ": " & $aiQuantities[$i][1] & "x", $COLOR_SUCCESS)
			$aQueueSpell[TroopIndexLookup($aiQuantities[$i][0]) - $eLSpell] += $aiQuantities[$i][1]
		Next
		If $bQtyWSlot Then Return $aiQuantities
		Return $aQueueSpell
	EndIf

	_ArrayReverse($avResult)
	Return $avResult
EndFunc   ;==>CheckQueueSpells

Func SearchArmy($sImageDir = "", $x = 0, $y = 0, $x1 = 0, $y1 = 0, $sArmyType = "", $bSkipReceivedTroopsCheck = False)
	; Setup arrays, including default return values for $return
	Local $aResult[1][4], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue

	For $iCount = 0 To 10  ;Why is this loop here?
		If Not $g_bRunState Then Return $aResult
		If Not getReceivedTroops(162, 200 + $g_iMidOffsetYFixed, $bSkipReceivedTroopsCheck) Then
			; Perform the search
			_CaptureRegion2($x, $y, $x1, $y1)
			Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $sImageDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)

			If $res[0] <> "" Then
				; Get the keys for the dictionary item.
				Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

				; Redimension the result array to allow for the new entries
				ReDim $aResult[UBound($aKeys)][4]
				Local $iResultAddDup = 0

				; Loop through the array
				For $i = 0 To UBound($aKeys) - 1
					; Get the property values
					$aResult[$i + $iResultAddDup][0] = RetrieveImglocProperty($aKeys[$i], "objectname")
					; Get the coords property
					$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
					$aCoords = decodeMultipleCoords($aValue, 50) ; dedup coords by x on 50 pixel
					$aCoordsSplit = $aCoords[0]
					If UBound($aCoordsSplit) = 2 Then
						; Store the coords into a two dimensional array
						$aCoordArray[0][0] = $aCoordsSplit[0] + $x ; X coord.
						$aCoordArray[0][1] = $aCoordsSplit[1] + $y ; Y coord.
					Else
						$aCoordArray[0][0] = -1
						$aCoordArray[0][1] = -1
					EndIf
					; Store the coords array as a sub-array
					$aResult[$i + $iResultAddDup][1] = Number($aCoordArray[0][0])
					$aResult[$i + $iResultAddDup][2] = Number($aCoordArray[0][1])
					SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
					; If 1 troop type appears at more than 1 slot
					Local $iMultipleCoords = UBound($aCoords)
					If $iMultipleCoords > 1 Then
						SetDebugLog($aResult[$i + $iResultAddDup][0] & " detected " & $iMultipleCoords & " times!")
						For $j = 1 To $iMultipleCoords - 1
							Local $aCoordsSplit2 = $aCoords[$j]
							If UBound($aCoordsSplit2) = 2 Then
								; add slot
								$iResultAddDup += 1
								ReDim $aResult[UBound($aKeys) + $iResultAddDup][4]
								$aResult[$i + $iResultAddDup][0] = $aResult[$i + $iResultAddDup - 1][0] ; same objectname
								$aResult[$i + $iResultAddDup][1] = $aCoordsSplit2[0] + $x
								$aResult[$i + $iResultAddDup][2] = $aCoordsSplit2[1]
								SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aResult[$i + $iResultAddDup][1] & "-" & $aResult[$i + $iResultAddDup][2])
							EndIf
						Next
					EndIf
				Next
				ExitLoop
			EndIf
			ExitLoop
		Else
			If $iCount = 1 Then SetLog("You have received castle troops! Wait 5's...")
			If _Sleep($DELAYTRAIN8) Then Return $aResult
		EndIf
	Next

	_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

	While 1
		If UBound($aResult) < 2 Then ExitLoop
		For $i = 1 To UBound($aResult) - 1
			If $aResult[$i][0] = $aResult[$i - 1][0] And Abs($aResult[$i][1] - $aResult[$i - 1][1]) <= 50 Then
				SetDebugLog("Double detection " & $aResult[$i][0] & " at " & $i - 1 & ": " & $aResult[$i][1] & " & " & $aResult[$i - 1][1])
				_ArrayDelete($aResult, $i)
				ContinueLoop 2
			EndIf
		Next
		ExitLoop
	WEnd

	If $sArmyType = "Troops" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "troop"), 196 + $g_iMidOffsetYFixed)) ; coc-newarmy
		Next
	EndIf
	If $sArmyType = "Spells" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "spells"), 341 + $g_iMidOffsetYFixed)) ; coc-newarmy
			;SetLog("$aResult: " & $aResult[$i][0] & "|" & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & $aResult[$i][3])
		Next
	EndIf
	If $sArmyType = "CCSpells" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "troop"), 498 + $g_iMidOffsetYFixed)) ; coc-newarmy
		Next
	EndIf
	If $sArmyType = "Heroes" Then ; CheckThis
		For $i = 0 To UBound($aResult) - 1
			If StringInStr($aResult[$i][0], "Kingqueued") Then
				$aResult[$i][3] = getRemainTHero(620, 414 + $g_iMidOffsetYFixed)
			ElseIf StringInStr($aResult[$i][0], "Queenqueued") Then
				$aResult[$i][3] = getRemainTHero(695, 414 + $g_iMidOffsetYFixed)
			ElseIf StringInStr($aResult[$i][0], "Wardenqueued") Then
				$aResult[$i][3] = getRemainTHero(775, 414 + $g_iMidOffsetYFixed)
			ElseIf StringInStr($aResult[$i][0], "Championqueued") Then
				$aResult[$i][3] = getRemainTHero(850, 414 + $g_iMidOffsetYFixed) ; Custom fix - Team AIO Mod++
			Else
				$aResult[$i][3] = 0
			EndIf
		Next
	EndIf

	If $sArmyType = "Queue" Then
		_ArraySort($aResult, 1, 0, 0, 1) ; reverse the queued slots from right to left
		Local $xSlot
		For $i = 0 To UBound($aResult) - 1
			$xSlot = Int(Number($aResult[$i][1]) / 71) * 71 - 6
			$aResult[$i][3] = Number(getQueueTroopsQuantity($xSlot, 192 + $g_iMidOffsetYFixed))
			SetDebugLog($aResult[$i][0] & " (" & $xSlot & ") x" & $aResult[$i][3])
		Next
	EndIf

	If $sArmyType = "Quick Train" Then
		Local $xSlot
		For $i = 0 To UBound($aResult) - 1
			$xSlot = Int((Number($aResult[$i][1]) - 25) / 71)
			$aResult[$i][3] = Number(getQueueTroopsQuantity(25 + $xSlot * 71, 190 + $g_iMidOffsetYFixed))
			SetDebugLog($aResult[$i][0] & " (" & $xSlot & ") x" & $aResult[$i][3])
		Next
	EndIf

	Return $aResult
EndFunc   ;==>SearchArmy

Func ResetVariables($sArmyType = "")

	If $sArmyType = "troops" Or $sArmyType = "all" Then
		For $i = 0 To $eTroopCount - 1
			If Not $g_bRunState Then Return
			$g_aiCurrentTroops[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $sArmyType = "Spells" Or $sArmyType = "all" Then
		For $i = 0 To $eSpellCount - 1
			If Not $g_bRunState Then Return
			$g_aiCurrentSpells[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $sArmyType = "SiegeMachines" Or $sArmyType = "all" Then
		For $i = 0 To $eSiegeMachineCount - 1
			If Not $g_bRunState Then Return
			$g_aiCurrentSiegeMachines[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $sArmyType = "donated" Or $sArmyType = "all" Then
		For $i = 0 To $eTroopCount - 1
			If Not $g_bRunState Then Return
			$g_aiDonateTroops[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
		For $i = 0 To $eSpellCount - 1 ; fixed making wrong donated spells
			If Not $g_bRunState Then Return
			$g_aiDonateSpells[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return
		Next
		For $i = 0 To $eSiegeMachineCount - 1
			If Not $g_bRunState Then Return
			$g_aiDonateSiegeMachines[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return
		Next
	EndIf

EndFunc   ;==>ResetVariables

Func TrainArmyNumber($abQuickTrainArmy)
	Local $iDistanceBetweenArmies = 110
	Local $aiTrainButton, $aiSearchArea[4] = [750, 270 + $g_iMidOffsetYFixed, 815, 380 + $g_iMidOffsetYFixed]

	For $iArmyNumber = 0 To 2
		If $abQuickTrainArmy[$iArmyNumber] Then
			$aiTrainButton = decodeSingleCoord(findImage("QuickTrainButton", $g_sImgQuickTrain, GetDiamondFromArray($aiSearchArea), 1, True))
			If UBound($aiTrainButton, 1) = 2 Then
				ClickP($aiTrainButton)
				SetLog(" - Making the Army " & $iArmyNumber + 1, $COLOR_INFO)
				If _Sleep(500) Then Return
			Else
				SetLog(" - Army: " & $iArmyNumber + 1 & " is already trained.")
			EndIf
		EndIf
		$aiSearchArea[1] = ($aiSearchArea[1] + $iDistanceBetweenArmies)
		$aiSearchArea[3] = ($aiSearchArea[3] + $iDistanceBetweenArmies)
	Next

EndFunc   ;==>TrainArmyNumber

Func DeleteQueued($sArmyTypeQueued, $iOffsetQueued = 802)

	If $sArmyTypeQueued = "Troops" Then
		If Not OpenTroopsTab(True, "DeleteQueued()") Then Return
	ElseIf $sArmyTypeQueued = "Spells" Then
		If Not OpenSpellsTab(True, "DeleteQueued()") Then Return
	ElseIf $sArmyTypeQueued = "SiegeMachines" Then
		If Not OpenSiegeMachinesTab(True, "DeletQueued()") Then Return
	Else
		Return
	EndIf
	If _Sleep(500) Then Return
	Local $x = 0

	While Not _ColorCheck(_GetPixelColor(820, 208 + $g_iMidOffsetYFixed, True), Hex(0xD0D0C8, 6), 20) ; check gray background at 1st training slot
		If $x = 0 Then SetLog(" - Delete " & $sArmyTypeQueued & " Queued!", $COLOR_INFO)
		If Not $g_bRunState Then Return
		Click($iOffsetQueued + 24, 202 + $g_iMidOffsetYFixed, 10, 50)
		$x += 1
		If $x = 270 Then ExitLoop
	WEnd
EndFunc   ;==>DeleteQueued

Func MakingDonatedTroops($sType = "All")
	Local $avDefaultTroopGroup[$eTroopCount][6]
	For $i = 0 To $eTroopCount - 1
		$avDefaultTroopGroup[$i][0] = $g_asTroopShortNames[$i]
		$avDefaultTroopGroup[$i][1] = $i
		$avDefaultTroopGroup[$i][2] = $g_aiTroopSpace[$i]
		$avDefaultTroopGroup[$i][3] = $g_aiTroopTrainTime[$i]
		$avDefaultTroopGroup[$i][4] = 0
		$avDefaultTroopGroup[$i][5] = $i >= $eMini ? "d" : "e"
	Next

	; notes $avDefaultTroopGroup[19][5]
	; notes $avDefaultTroopGroup[19][0] = TroopName | [1] = TroopNamePosition | [2] = TroopHeight | [3] = Times | [4] = qty | [5] = marker for DarkTroop or ElixerTroop]
	; notes ClickDrag(616, 445 + $g_iMidOffsetY, 400, 445 + $g_iMidOffsetY, 2000) ; Click drag for dark Troops
	; notes	ClickDrag(400, 445 + $g_iMidOffsetY, 616, 445 + $g_iMidOffsetY, 2000) ; Click drag for Elixer Troops
	; notes $RemainTrainSpace[0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army

	Local $RemainTrainSpace
	Local $Plural = 0
	Local $areThereDonTroop = 0
	Local $areThereDonSpell = 0
	Local $areThereDonSiegeMachine = 0

	For $j = 0 To $eTroopCount - 1
		If $sType <> "Troops" And $sType <> "All" Then ExitLoop
		If Not $g_bRunState Then Return
		$areThereDonTroop += $g_aiDonateTroops[$j]
	Next

	For $j = 0 To $eSpellCount - 1
		If $sType <> "Spells" And $sType <> "All" Then ExitLoop
		If Not $g_bRunState Then Return
		$areThereDonSpell += $g_aiDonateSpells[$j]
	Next

	For $j = 0 To $eSiegeMachineCount - 1
		If $sType <> "Siege" And $sType <> "All" Then ExitLoop
		If Not $g_bRunState Then Return
		$areThereDonSiegeMachine += $g_aiDonateSiegeMachines[$j]
	Next
	If $areThereDonSpell = 0 And $areThereDonTroop = 0 And $areThereDonSiegeMachine = 0 Then Return

	SetLog("  making donated troops", $COLOR_ACTION1)
	If $areThereDonTroop > 0 Then
		; Load $g_aiDonateTroops[$i] Values into $avDefaultTroopGroup[19][5]
		For $i = 0 To UBound($avDefaultTroopGroup) - 1
			For $j = 0 To $eTroopCount - 1
				If $g_asTroopShortNames[$j] = $avDefaultTroopGroup[$i][0] Then
					$avDefaultTroopGroup[$i][4] = $g_aiDonateTroops[$j]
					$g_aiDonateTroops[$j] = 0
				EndIf
			Next
		Next

		If Not OpenTroopsTab(True, "MakingDonatedTroops()") Then Return

		For $i = 0 To UBound($avDefaultTroopGroup, 1) - 1
			If Not $g_bRunState Then Return
			$Plural = 0
			If $avDefaultTroopGroup[$i][4] > 0 Then
				$RemainTrainSpace = GetOCRCurrent(48, 160 + $g_iMidOffsetYFixed)
				If $RemainTrainSpace[2] < 0 Then $RemainTrainSpace[2] = $RemainTrainSpace[1] * 2 - $RemainTrainSpace[0] ; remain train space to full double army
				If $RemainTrainSpace[2] = 0 Then ExitLoop ; army camps full

				Local $iTroopIndex = TroopIndexLookup($avDefaultTroopGroup[$i][0], "MakingDonatedTroops")

				If $avDefaultTroopGroup[$i][2] * $avDefaultTroopGroup[$i][4] <= $RemainTrainSpace[2] Then ; Troopheight x donate troop qty <= avaible train space
					;Local $pos = GetTrainPos(TroopIndexLookup($avDefaultTroopGroup[$i][0]))
					Local $howMuch = $avDefaultTroopGroup[$i][4]
					If $avDefaultTroopGroup[$i][5] = "e" Then
						TrainIt($iTroopIndex, $howMuch, $g_iTrainClickDelay)
						;PureClick($pos[0], $pos[1], $howMuch, 500)
					Else
						ClickDrag(715, 445 + $g_iMidOffsetY, 220, 445 + $g_iMidOffsetY, 2000) ; Click drag for dark Troops
						TrainIt($iTroopIndex, $howMuch, $g_iTrainClickDelay)
						;PureClick($pos[0], $pos[1], $howMuch, 500)
						ClickDrag(220, 445 + $g_iMidOffsetY, 725, 445 + $g_iMidOffsetY, 2000) ; Click drag for Elixer Troops
					EndIf
					If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
					Local $sTroopName = ($avDefaultTroopGroup[$i][4] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
					SetLog(" - Trained " & $avDefaultTroopGroup[$i][4] & " " & $sTroopName, $COLOR_ACTION)
					$avDefaultTroopGroup[$i][4] = 0
					If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
				Else
					For $z = 0 To $RemainTrainSpace[2] - 1
						$RemainTrainSpace = GetOCRCurrent(48, 160 + $g_iMidOffsetYFixed)
						If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ; army camps full
							;Camps Full All Donate Counters should be zero!!!!
							For $j = 0 To UBound($avDefaultTroopGroup, 1) - 1
								$avDefaultTroopGroup[$j][4] = 0
							Next
							ExitLoop (2) ;
						EndIf
						If $avDefaultTroopGroup[$i][2] <= $RemainTrainSpace[2] And $avDefaultTroopGroup[$i][4] > 0 Then
							;TrainIt(TroopIndexLookup($g_asTroopShortNames[$i]), 1, $g_iTrainClickDelay)
							;Local $pos = GetTrainPos(TroopIndexLookup($avDefaultTroopGroup[$i][0]))
							Local $howMuch = 1
							If $iTroopIndex >= $eBarb And $iTroopIndex <= $eMine Then ; elixir troop
								TrainIt($iTroopIndex, $howMuch, $g_iTrainClickDelay)
								;PureClick($pos[0], $pos[1], $howMuch, 500)
							Else ; dark elixir troop
								ClickDrag(715, 445 + $g_iMidOffsetY, 220, 445 + $g_iMidOffsetY, 2000) ; Click drag for dark Troops
								TrainIt($iTroopIndex, $howMuch, $g_iTrainClickDelay)
								;PureClick($pos[0], $pos[1], $howMuch, 500)
								ClickDrag(220, 445 + $g_iMidOffsetY, 725, 445 + $g_iMidOffsetY, 2000) ; Click drag for Elixer Troops
							EndIf
							If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
							Local $sTroopName = ($avDefaultTroopGroup[$i][4] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
							SetLog(" - Trained " & $avDefaultTroopGroup[$i][4] & " " & $sTroopName, $COLOR_ACTION)
							$avDefaultTroopGroup[$i][4] -= 1
							If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
						Else
							ExitLoop
						EndIf
					Next
				EndIf
			EndIf
		Next
		;Top Off any remianing space with archers
		If $sType = "All" Then
			$RemainTrainSpace = GetOCRCurrent(48, 160 + $g_iMidOffsetYFixed)
			If $RemainTrainSpace[0] < $RemainTrainSpace[1] Then ; army camps full
				Local $howMuch = $RemainTrainSpace[2]
				TrainIt($eTroopArcher, $howMuch, $g_iTrainClickDelay)
				;PureClick($TrainArch[0], $TrainArch[1], $howMuch, 500)
				If $RemainTrainSpace[2] > 0 Then $Plural = 1
				SetLog(" - Trained " & $howMuch & " archer(s)!", $COLOR_ACTION)
				If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
			EndIf
		EndIf
	EndIf

	If $areThereDonSpell > 0 Then
		;Train Donated Spells
		If Not OpenSpellsTab(True, "MakingDonatedTroops()") Then Return

		For $i = 0 To $eSpellCount - 1
			If Not $g_bRunState Then Return
			If $g_aiDonateSpells[$i] > 0 Then
				Local $pos = GetTrainPos($i + $eLSpell)
				Local $howMuch = $g_aiDonateSpells[$i]
				TrainIt($eLSpell + $i, $howMuch, $g_iTrainClickDelay)
				;PureClick($pos[0], $pos[1], $howMuch, 500)
				If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
				SetLog(" - Brewed " & $howMuch & " " & $g_asSpellNames[$i] & ($howMuch > 1 ? " Spells" : " Spell"), $COLOR_ACTION)
				$g_aiDonateSpells[$i] -= $howMuch

				If _Sleep(1000) Then Return
				$RemainTrainSpace = GetOCRCurrent(48, 160 + $g_iMidOffsetYFixed)
				SetLog(" - Current Capacity: " & $RemainTrainSpace[0] & "/" & ($RemainTrainSpace[1]))
			EndIf
		Next
	EndIf

	If $areThereDonSiegeMachine > 0 Then
		;Train Donated Sieges
		If Not OpenSiegeMachinesTab(True, "MakingDonatedTroops()") Then Return

		For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			If Not $g_bRunState Then Return
			If $g_aiDonateSiegeMachines[$iSiegeIndex] > 0 Then
				Local $aCheckIsAvailableSiege[4] = [58, 556 + $g_iMidOffsetYFixed, 0x47717E, 10]
				Local $aCheckIsAvailableSiege1[4] = [229, 556 + $g_iMidOffsetYFixed, 0x47717E, 10]
				Local $aCheckIsAvailableSiege2[4] = [400, 556 + $g_iMidOffsetYFixed, 0x47717E, 10]
				Local $aCheckIsAvailableSiege3[4] = [576, 556 + $g_iMidOffsetYFixed, 0x47717E, 10]
				Local $aCheckIsAvailableSiege4[4] = [750, 556 + $g_iMidOffsetYFixed, 0x47717E, 10]
				Local $checkPixel
				If $iSiegeIndex = $eSiegeWallWrecker Then $checkPixel = $aCheckIsAvailableSiege
				If $iSiegeIndex = $eSiegeBattleBlimp Then $checkPixel = $aCheckIsAvailableSiege1
				If $iSiegeIndex = $eSiegeStoneSlammer Then $checkPixel = $aCheckIsAvailableSiege2
				If $iSiegeIndex = $eSiegeBarracks Then $checkPixel = $aCheckIsAvailableSiege3
				If $iSiegeIndex = $eSiegeLogLauncher Then $checkPixel = $aCheckIsAvailableSiege4
				Local $HowMany = $g_aiDonateSiegeMachines[$iSiegeIndex]
				If _CheckPixel($checkPixel, True, Default, $g_asSiegeMachineNames[$iSiegeIndex]) Then
					;PureClick($pos[0], $pos[1], $howMuch, 500)
					If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
					PureClick($checkPixel[0], $checkPixel[1], $HowMany, $g_iTrainClickDelay)
					Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""
					SetLog(" - Trained " & $HowMany & " " & $g_asSiegeMachineNames[$iSiegeIndex] & ($HowMany > 1 ? " SiegeMachines" : " SiegeMachine"), $COLOR_ACTION)
					$g_aiDonateSiegeMachines[$iSiegeIndex] -= $HowMany
				EndIf
			EndIf
		Next
		; Get Siege Capacities
		Local $sSiegeInfo = getArmyCapacityOnTrainTroops(57, 160 + $g_iMidOffsetYFixed) ; OCR read Siege built and total
		If $g_bDebugSetlogTrain Then SetLog("OCR $sSiegeInfo = " & $sSiegeInfo, $COLOR_DEBUG)
		Local $aGetSiegeCap = StringSplit($sSiegeInfo, "#", $STR_NOCOUNT) ; split the built Siege number from the total Siege number
		SetLog("Total Siege Workshop Capacity: " & $aGetSiegeCap[0] & "/" & $aGetSiegeCap[1])
		If Number($aGetSiegeCap[0]) = 0 Then Return
	EndIf

	Return True

EndFunc   ;==>MakingDonatedTroops

Func GetOCRCurrent($x_start, $y_start)

	Local $aResult[3] = [0, 0, 0]
	If Not $g_bRunState Then Return $aResult

	; [0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army
	Local $iOCRResult = getArmyCapacityOnTrainTroops($x_start, $y_start)

	If StringInStr($iOCRResult, "#") Then
		Local $aTempResult = StringSplit($iOCRResult, "#", $STR_NOCOUNT)
		$aResult[0] = Number($aTempResult[0])
		$aResult[1] = Number($aTempResult[1])
		; Case to use this function os Spells will be <= 22 , 11*2
		If $aResult[1] <= 22 Then
			If $g_bDebugSetlogTrain Then SetLog("$g_iTotalSpellValue: " & $g_iTotalSpellValue, $COLOR_DEBUG)
			$aResult[1] = $g_iTotalSpellValue
			$aResult[2] = $g_iTotalSpellValue - $aResult[0]
			; May 2018 Update the Army Camp Value on Train page is DOUBLE Value
		ElseIf $aResult[1] <> $g_iTotalCampSpace Then
			If $g_bDebugSetlogTrain Then SetLog("$g_iTotalCampSpace: " & $g_iTotalCampSpace, $COLOR_DEBUG)
			$aResult[1] = $g_iTotalCampSpace
			$aResult[2] = $g_iTotalCampSpace - $aResult[0]
		EndIf
		$aResult[2] = $aResult[1] - $aResult[0]
	Else
		SetLog("DEBUG | ERROR on GetOCRCurrent", $COLOR_ERROR)
	EndIf

	Return $aResult

EndFunc   ;==>GetOCRCurrent

Func getReceivedTroops($x_start, $y_start, $bSkipCheck = False) ; Check if 'you received Castle Troops from' , will proceed with a Sleep until the message disappear
	If $bSkipCheck Or Not $g_bRunState Then Return False
	Local $iOCRResult = ""

	$iOCRResult = getOcrAndCapture("coc-DonTroops", $x_start, $y_start, 120, 27, True) ; X = 162  Y = 200

	If IsString($iOCRResult) <> "" Or IsString($iOCRResult) <> " " Then
		If StringInStr($iOCRResult, "you") Then ; If exist Minutes or only Seconds
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf

EndFunc   ;==>getReceivedTroops

Func _ArryRemoveBlanks(ByRef $aArray)
	Local $iCounter = 0
	For $i = 0 To UBound($aArray) - 1
		If $aArray[$i] <> "" Then
			$aArray[$iCounter] = $aArray[$i]
			$iCounter += 1
		EndIf
	Next
	ReDim $aArray[$iCounter]
EndFunc   ;==>_ArryRemoveBlanks

Func ValidateSearchArmyResult($aSearchResult, $iIndex = 0)
	If IsArray($aSearchResult) Then
		If UBound($aSearchResult) > 0 Then
			If StringLen($aSearchResult[$iIndex][0]) > 0 Then Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>ValidateSearchArmyResult

Func getArmyResources($bSetLog = True, $bNeedCapture = True)

	If $bSetLog Then SetDebugLog("getArmyResources():", $COLOR_DEBUG)
	Local $sResourceDiamond = GetDiamondFromRect("11,539,848,579") ; Resolution changed
	Local $aCurrentResources = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Resources", $sResourceDiamond, $sResourceDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
	Local $aTempResourceArray, $aResourceCoords, $iResourceIndex = -1
	Local $aResources[4] = [0, 0, 0, 0] ; Gold, Elixir, Dark Elixir, Gems

	If $bSetLog Then SetDebugLog("Current Resources: " & UBound($aCurrentResources, 1), $COLOR_SUCCESS)
	If IsArray($aCurrentResources) And UBound($aCurrentResources, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentResources, 1) - 1
			$aTempResourceArray = $aCurrentResources[$i]
			$aResourceCoords = StringSplit($aTempResourceArray[1], ",", $STR_NOCOUNT)
			$iResourceIndex = ResourceIndex($aTempResourceArray[0])
			If $iResourceIndex = -1 Then ContinueLoop
			$aResources[$iResourceIndex] = Number(getResourcesValueTrainPage($aResourceCoords[0] + 10, $aResourceCoords[1] - 5))
			If $bSetLog Then SetDebugLog($aTempResourceArray[0] & ": " & $aResources[$iResourceIndex], $COLOR_INFO)
		Next
	EndIf

	Return $aResources
EndFunc   ;==>getArmyResources

Func ResourceIndex(Const $sName)
	Local $asResourceNames[4] = ["Gold", "Elixir", "DarkElixir", "Gems"]
	For $i = 0 To UBound($asResourceNames) - 1
		If $sName = $asResourceNames[$i] Then
			Return $i
		EndIf
	Next

	Return -1
EndFunc   ;==>ResourceIndex