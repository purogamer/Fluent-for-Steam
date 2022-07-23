; #FUNCTION# ====================================================================================================================
; Name ..........: Quick Train
; Description ...: New and a complete quick train system
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func QuickTrain($bPreTrainFlag = $g_bDoubleTrain) ; Custom train - Team AIO Mod++
	Local $bDebug = $g_bDebugSetlogTrain Or $g_bDebugSetlog
	Local $bNeedRecheckTroop = False, $bNeedRecheckSpell = False, $bNeedRecheckSiegeMachine = False
	Local $iTroopStatus = -1, $iSpellStatus = -1, $iSiegeStatus = -1 ; 0 = empty, 1 = full camp, 2 = full queue

	If $bDebug Then SetLog(" == Quick Train == ", $COLOR_ACTION)

	; Troop
	If Not $g_bDonationEnabled Or Not $g_bChkDonate Or Not MakingDonatedTroops("Troops") Then ; No need OpenTroopsTab() if MakingDonatedTroops() returns true
		If Not OpenTroopsTab(False, "QuickTrain()") Then Return
		If _Sleep(250) Then Return
	EndIf

	Local $iStep = 1
	While 1
		Local $avTroopCamp = GetCurrentArmy(48, 160 + $g_iMidOffsetYFixed)
		SetLog("Checking Troop tab: " & $avTroopCamp[0] & "/" & $avTroopCamp[1] * 2)
		If $avTroopCamp[1] = 0 Then ExitLoop

		If $avTroopCamp[0] <= 0 Then ; 0/280
			$iTroopStatus = 0
			If $bDebug Then SetLog("No troop", $COLOR_DEBUG)

		ElseIf $avTroopCamp[0] < $avTroopCamp[1] Then ; 1-279/280
			If Not IsQueueEmpty("Troops", True, False) Then DeleteQueued("Troops")
			$bNeedRecheckTroop = True
			If $bDebug Then SetLog("$bNeedRecheckTroop for at Army Tab: " & $bNeedRecheckTroop, $COLOR_DEBUG)

		ElseIf $avTroopCamp[0] = $avTroopCamp[1] Then ; 280/280
			$iTroopStatus = 1
			If $bDebug Then SetLog($bPreTrainFlag ? "ready to make double troop training" : "troops are training perfectly", $COLOR_DEBUG)

		ElseIf $avTroopCamp[0] <= $avTroopCamp[1] * 1.5 Then ; 281-420/560
			RemoveExtraTroopsQueue()
			If $bDebug Then SetLog($iStep & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
			If _Sleep(250) Then Return
			$iStep += 1
			If $iStep = 6 Then ExitLoop
			ContinueLoop

		ElseIf $avTroopCamp[0] <= $avTroopCamp[1] * 2 Then ; 421-560/560
			If CheckQueueTroopAndTrainRemain($avTroopCamp, $bDebug) Then
				$iTroopStatus = 2
				If $bDebug Then SetLog($iStep & ". CheckQueueTroopAndTrainRemain()", $COLOR_DEBUG)
			Else
				RemoveExtraTroopsQueue()
				If $bDebug Then SetLog($iStep & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
				If _Sleep(250) Then Return
				$iStep += 1
				If $iStep = 6 Then ExitLoop
				ContinueLoop
			EndIf
		EndIf
		ExitLoop
	WEnd

	; Spell
	If $g_iTotalQuickSpells = 0 Then
		$iSpellStatus = 2
	Else
		If Not $g_bDonationEnabled Or Not $g_bChkDonate Or Not MakingDonatedTroops("Spells") Then ; No need OpenSpellsTab() if MakingDonatedTroops() returns true
			If Not OpenSpellsTab(False, "QuickTrain()") Then Return
			If _Sleep(250) Then Return
		EndIf

		Local $Step = 1, $iUnbalancedSpell = 0
		While 1
			Local $aiSpellCamp = GetCurrentArmy(43, 160 + $g_iMidOffsetYFixed)
			SetLog("Checking Spell tab: " & $aiSpellCamp[0] & "/" & $aiSpellCamp[1] * 2)
			If $aiSpellCamp[1] > $g_iTotalQuickSpells Then
				SetLog("Unbalance total quick spell vs actual spell capacity: " & $g_iTotalQuickSpells & "/" & $aiSpellCamp[1])
				$iUnbalancedSpell = $aiSpellCamp[1] - $g_iTotalQuickSpells
				$aiSpellCamp[1] = $g_iTotalQuickSpells
			EndIf

			If $aiSpellCamp[0] <= 0 Then ; 0/22
				If $iTroopStatus >= 1 And $g_bQuickArmyMixed Then
					BrewFullSpell()
					$iSpellStatus = 1
					If $iTroopStatus = 2 And $bPreTrainFlag Then
						BrewFullSpell(True)
						TopUpUnbalancedSpell($iUnbalancedSpell)
						$iSpellStatus = 2
					EndIf
				Else
					$iSpellStatus = 0
					If $bDebug Then SetLog("No Spell", $COLOR_DEBUG)
				EndIf

			ElseIf $aiSpellCamp[0] < $aiSpellCamp[1] Then ; 1-10/11
				If Not IsQueueEmpty("Spells", True, False) Then DeleteQueued("Spells")
				$bNeedRecheckSpell = True
				If $bDebug Then SetLog("$bNeedRecheckSpell at Army Tab: " & $bNeedRecheckSpell, $COLOR_DEBUG)

			ElseIf $aiSpellCamp[0] = $aiSpellCamp[1] Or $aiSpellCamp[0] <= $aiSpellCamp[1] + $iUnbalancedSpell Then  ; 11/22
				If $iTroopStatus = 2 And $g_bQuickArmyMixed And $bPreTrainFlag Then
					BrewFullSpell(True)
					TopUpUnbalancedSpell($iUnbalancedSpell)
					If $bDebug Then SetLog("$iTroopStatus = " & $iTroopStatus & ". Brewed full queued spell", $COLOR_DEBUG)
					$iSpellStatus = 2
				Else
					$iSpellStatus = 1
					If $bDebug Then SetLog($bPreTrainFlag ? "ready to make double spell brewing" : "spells are brewing perfectly", $COLOR_DEBUG)
				EndIf

			Else ; If $aiSpellCamp[0] <= $aiSpellCamp[1] * 2 Then ; 12-22/22
				If ($iTroopStatus = 2 Or Not $g_bQuickArmyMixed) And CheckQueueSpellAndTrainRemain($aiSpellCamp, $bDebug, $iUnbalancedSpell) Then
					If $aiSpellCamp[0] < ($aiSpellCamp[1] + $iUnbalancedSpell) * 2 Then TopUpUnbalancedSpell($iUnbalancedSpell)
					$iSpellStatus = 2
				Else
					RemoveExtraTroopsQueue()
					If _Sleep(500) Then Return
					$Step += 1
					If $Step = 6 Then ExitLoop
					ContinueLoop
				EndIf

			EndIf
			ExitLoop
		WEnd
	EndIf

	If $g_iTotalQuickSiegeMachines = 0 Then
		$iSiegeStatus = 2
	Else
		If Not $g_bDonationEnabled Or Not $g_bChkDonate Or Not MakingDonatedTroops("Siege") Then ; No need OpenSiegeMachinesTab() if MakingDonatedTroops() returns true
			If Not OpenSiegeMachinesTab(False, "QuickTrain()") Then Return
			If _Sleep(250) Then Return
		EndIf

		Local $iStep = 0
		While 1
			Local $aiSiegeMachineCamp = GetCurrentArmy(56, 160 + $g_iMidOffsetYFixed)
			SetLog("Checking siege machine tab: " & $aiSiegeMachineCamp[0] & "/" & $aiSiegeMachineCamp[1] * 2)

			If $aiSiegeMachineCamp[0] <= 0 Then ;0/6
				TrainSiege()
			ElseIf $aiSiegeMachineCamp[0] < $aiSiegeMachineCamp[1] Then  ;1-2/6
				If Not IsQueueEmpty("SiegeMachines", True, False) Then DeleteQueued("SiegeMachines")
				$bNeedRecheckSiegeMachine = True
				If $bDebug Then SetLog("$bNeedRecheckSiegeMachine at Army Tab: " & $bNeedRecheckSiegeMachine, $COLOR_DEBUG)
			ElseIf $aiSiegeMachineCamp[0] = $aiSiegeMachineCamp[1] Then ; 3/6
				TrainSiege(True)
			Else ; 4-5/6
				RemoveExtraTroopsQueue()
				If _Sleep(500) Then Return
				$iStep += 1
				If $iStep = 6 Then ExitLoop
				ContinueLoop

			EndIf
			ExitLoop
		WEnd
	EndIf

	; check existing army then train missing troops, spells, sieges
	If $bNeedRecheckTroop Or $bNeedRecheckSpell Or $bNeedRecheckSiegeMachine Then

		Local $aWhatToRemove = WhatToTrain(True)

		RemoveExtraTroops($aWhatToRemove)

		Local $bEmptyTroop = _ColorCheck(_GetPixelColor(30, 205 + $g_iMidOffsetYFixed, True), Hex(0xCAC9C1, 6), 20) ; remove all troops ; Fixed resolution
		Local $bEmptySpell = _ColorCheck(_GetPixelColor(30, 350 + $g_iMidOffsetYFixed, True), Hex(0xCAC9C1, 6), 20) ; remove all spells ; Fixed resolution

		Local $aWhatToTrain = WhatToTrain(False, False) ; $g_bIsFullArmywithHeroesAndSpells = False

		If DoWhatToTrainContainTroop($aWhatToTrain) Then
			If $bEmptyTroop And $bEmptySpell Then
				$iTroopStatus = 0
			ElseIf $bEmptyTroop And ($iSpellStatus >= 1 And Not $g_bQuickArmyMixed) Then
				$iTroopStatus = 0
			Else
				If $bDebug Then SetLog("Topping up troops", $COLOR_DEBUG)
				TrainUsingWhatToTrain($aWhatToTrain) ; troop
				$iTroopStatus = 1
			EndIf
		EndIf

		If DoWhatToTrainContainSpell($aWhatToTrain) Then
			If $bEmptySpell And $bEmptyTroop Then
				$iSpellStatus = 0
			ElseIf $bEmptySpell And ($iTroopStatus >= 1 And Not $g_bQuickArmyMixed) Then
				$iSpellStatus = 0
			Else
				If $bDebug Then SetLog("Topping up spells", $COLOR_DEBUG)
				BrewUsingWhatToTrain($aWhatToTrain) ; spell
				$iSpellStatus = 1
			EndIf
		EndIf

		TrainSiege()
	EndIf

	If _Sleep(250) Then Return

	SetDebugLog("$iTroopStatus = " & $iTroopStatus & ", $iSpellStatus = " & $iSpellStatus & ", $iSiegeStatus = " & $iSiegeStatus)
	If $iTroopStatus = -1 And $iSpellStatus = -1  And $iSiegeStatus = -1 Then
		SetLog("Quick Train failed. Unable to detect training status.", $COLOR_ERROR)
		Return
	EndIf
	
	Switch _Min($iTroopStatus, $iSpellStatus)
		Case 0
			If Not OpenQuickTrainTab(False, "QuickTrain()") Then Return
			If _Sleep(750) Then Return
			TrainArmyNumber($g_bQuickTrainArmy)
			If $bPreTrainFlag Then TrainArmyNumber($g_bQuickTrainArmy)
		Case 1
			If $g_bIsFullArmywithHeroesAndSpells Or $bPreTrainFlag And $g_bTrainBeforeAttack Then ; Custom Train - Team AIO Mod++
				If $g_bIsFullArmywithHeroesAndSpells Then SetLog(" - Your Army is Full, let's make troops before Attack!", $COLOR_INFO)
				If Not OpenQuickTrainTab(False, "QuickTrain()") Then Return
				If _Sleep(750) Then Return
				TrainArmyNumber($g_bQuickTrainArmy)
			EndIf
	EndSwitch
	If _Sleep(500) Then Return

EndFunc   ;==>QuickTrain

Func CheckQuickTrainTroop()

	Local $bResult = True


	Local Static $asLastTimeChecked[8]
	If $g_bFirstStart Then $asLastTimeChecked[$g_iCurAccount] = ""

	If _DateIsValid($asLastTimeChecked[$g_iCurAccount]) Then
		Local $iLastCheck = _DateDiff('n', $asLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Latest CheckQuickTrainTroop() at: " & $asLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck & " min" & @CRLF & _
		"_ArrayMax($g_aiArmyQuickTroops) = " & _ArrayMax($g_aiArmyQuickTroops))
		If $iLastCheck <= 360 And _ArrayMax($g_aiArmyQuickTroops) > 0 Then Return ; A check each 6 hours [6*60 = 360]
	EndIf

	If Not OpenArmyOverview(False, "CheckQuickTrainTroop()") Then Return
	If _Sleep(250) Then Return



	If Not OpenQuickTrainTab(False, "CheckQuickTrainTroop()") Then Return
	If _Sleep(500) Then Return

	SetLog("Reading troops/spells/siege in quick train army")

	; reset troops/spells in quick army
	Local $aEmptyTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aEmptySpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aEmptySiegeMachine[$eSiegeMachineCount] = [0, 0, 0, 0, 0]
	$g_aiArmyQuickTroops = $aEmptyTroop
	$g_aiArmyQuickSpells = $aEmptySpell
	$g_aiArmyQuickSiegeMachines = $aEmptySiegeMachine
	$g_iTotalQuickTroops = 0
	$g_iTotalQuickSpells = 0
	$g_iTotalQuickSiegeMachines = 0
	$g_bQuickArmyMixed = False

	Local $iTroopCamp = 0, $iSpellCamp = 0, $iSiegeMachineCamp = 0, $sLog = ""

	Local $aSaveButton[4] = [808, 300 + $g_iMidOffsetYFixed, 0xdcf684, 20] ; green ; Resolution changed
	Local $aCancelButton[4] = [650, 300 + $g_iMidOffsetYFixed, 0xff8c91, 20] ; red ; Resolution changed
	Local $aRemoveButton[4] = [535, 300 + $g_iMidOffsetYFixed, 0xff8f94, 20] ; red ; Resolution changed

	local $iDistanceBetweenArmies = 108 ; pixels
	local $aArmy1Location = [758, 265] ; first area of quick train army buttons ; Resolution changed

	; findImage needs filename and path
	Local $avEditQuickTrainIcon = _FileListToArrayRec($g_sImgEditQuickTrain, "*", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)

	If Not IsArray($avEditQuickTrainIcon) Or UBound($avEditQuickTrainIcon, $UBOUND_ROWS) <= 0 Then
		SetLog("Can't find EditQuickTrainIcon");
		Return False
	EndIf

	For $i = 0 To UBound($g_bQuickTrainArmy) - 1 ; check all 3 army combo
		If Not $g_bQuickTrainArmy[$i] Then ContinueLoop ; skip unchecked quick train army

		; calculate search area for EditQuickTrainIcon
		Local $sSearchArea = $aArmy1Location[0] & ", " & ($aArmy1Location[1] + ($iDistanceBetweenArmies * $i)) & ", 815, " & ($aArmy1Location[1] + ($iDistanceBetweenArmies * ($i + 1)))

		; search for EditQuickTrainIcon
		Local $aiEditButton = decodeSingleCoord(findImage("EditQuickTrain", $avEditQuickTrainIcon[1], GetDiamondFromRect($sSearchArea), 1, True, Default)) ; Resolution changed

		If IsArray($aiEditButton) And UBound($aiEditButton, 1) >= 2 Then
			ClickP($aiEditButton)
			If _Sleep(1000) Then Return

			Local $TempTroopTotal = 0, $TempSpellTotal = 0, $TempSiegeTotal = 0

			Local $Step = 0
			While 1
				; read troops
				Local $aSearchResult = SearchArmy(@ScriptDir & "\imgxml\ArmyOverview\QuickTrain", 18, 182, 829, 261, "Quick Train") ; return Name, X, Y, Q'ty

				If $aSearchResult[0][0] = "" Then
					If Not $g_abUseInGameArmy[$i] Then
						$Step += 1
						SetLog("No troops/spells detected in Army " & $i + 1 & ", let's create quick train preset", $Step > 3 ? $COLOR_ERROR : $COLOR_BLACK)
						If $Step > 3 Then
							SetLog("Some problems creating army preset", $COLOR_ERROR)
							Click($aCancelButton[0], $aCancelButton[1]) ; Close editing
							ContinueLoop 2
						EndIf
						CreateQuickTrainPreset($i)
						ContinueLoop
					Else
						SetLog("No troops/spells/sieges detected in Quick Army " & $i + 1, $COLOR_ERROR)
						Click($aCancelButton[0], $aCancelButton[1]) ; Close editing
						If _Sleep(1000) Then Return
						ContinueLoop 2
					EndIf
				EndIf

				; get quantity
				Local $aiInGameTroop = $aEmptyTroop
				Local $aiInGameSpell = $aEmptySpell
				Local $aiInGameSiegeMachine = $aEmptySiegeMachine
				Local $aiGUITroop = $aEmptyTroop
				Local $aiGUISpell = $aEmptySpell
				Local $aiGUISiegeMachine = $aEmptySiegeMachine

				SetLog("Quick Army " & $i + 1 & ":", $COLOR_SUCCESS)
				For $j = 0 To (UBound($aSearchResult) - 1)
					Local $iTroopIndex = TroopIndexLookup($aSearchResult[$j][0])
					If $iTroopIndex >= 0 And $iTroopIndex < $eTroopCount Then
						SetLog("  - " & $g_asTroopNames[$iTroopIndex] & ": " & $aSearchResult[$j][3] & "x", $COLOR_SUCCESS)
						$aiInGameTroop[$iTroopIndex] = $aSearchResult[$j][3]
					ElseIf $iTroopIndex >= $eLSpell And $iTroopIndex <= $eBtSpell Then
						SetLog("  - " & $g_asSpellNames[$iTroopIndex - $eLSpell] & ": " & $aSearchResult[$j][3] & "x", $COLOR_SUCCESS)
						$aiInGameSpell[$iTroopIndex - $eLSpell] = $aSearchResult[$j][3]
					ElseIf $iTroopIndex >= $eWallW And $iTroopIndex <= $eFlameF Then
						SetLog("  - " & $g_asSiegeMachineNames[$iTroopIndex - $eWallW] & ": " & $aSearchResult[$j][3] & "x", $COLOR_SUCCESS)
						$aiInGameSiegeMachine[$iTroopIndex - $eWallW] = $aSearchResult[$j][3]
					Else
						SetLog("  - Unsupport troop/spell/siege index: " & $iTroopIndex)
					EndIf
				Next

				; cross check with GUI qty
				If Not $g_abUseInGameArmy[$i] Then
					If $Step <= 3 Then
						For $j = 0 To 6
							If $g_aiQuickTroopType[$i][$j] >= 0 Then $aiGUITroop[$g_aiQuickTroopType[$i][$j]] = $g_aiQuickTroopQty[$i][$j]
							If $g_aiQuickSpellType[$i][$j] >= 0 Then $aiGUISpell[$g_aiQuickSpellType[$i][$j]] = $g_aiQuickSpellQty[$i][$j]
							If $g_aiQuickSiegeMachineType[$i][$j] >= 0 Then $aiGUISiegeMachine[$g_aiQuickSiegeMachineType[$i][$j]] = $g_aiQuickSiegeMachineQty[$i][$j]
						Next
						For $j = 0 To $eTroopCount - 1
							If $aiGUITroop[$j] <> $aiInGameTroop[$j] Then
								Setlog("Wrong troop preset, let's create again. (" & $g_asTroopNames[$j] & ": " & $aiGUITroop[$j] & "/" & $aiInGameTroop[$j] & ")" & ($g_bDebugSetlog ? " - Retry: " & $Step : ""))
								$Step += 1
								CreateQuickTrainPreset($i)
								ContinueLoop 2
							EndIf
						Next
						For $j = 0 To $eSpellCount - 1
							If $aiGUISpell[$j] <> $aiInGameSpell[$j] Then
								Setlog("Wrong spell preset, let's create again (" & $g_asSpellNames[$j] & ": " & $aiGUISpell[$j] & "/" & $aiInGameSpell[$j] & ")" & ($g_bDebugSetlog ? " - Retry: " & $Step : ""))
								$Step += 1
								CreateQuickTrainPreset($i)
								ContinueLoop 2
							EndIf
						Next
						For $j = 0 To $eSiegeMachineCount - 1
							If $aiGUISiegeMachine[$j] <> $aiInGameSiegeMachine[$j] Then
								SetLog("Wrong siege machine preset, let's create again (" & $g_asSiegeMachineNames[$j] & ": " & $aiGUISiegeMachine[$j] & "/" & $aiInGameSiegeMachine[$j] & ")" & ($g_bDebugSetlog ? " - Retry: " & $Step : ""))
								$Step += 1
								CreateQuickTrainPreset($i)
								ContinueLoop 2
							EndIf

						Next
					Else
						SetLog("Some problems creating troop preset", $COLOR_ERROR)
					EndIf
				EndIf

				; If all correct (or after 3 times trying to preset QT army), add result to $g_aiArmyQuickTroops & $g_aiArmyQuickSpells
				For $j = 0 To $eTroopCount - 1
					$g_aiArmyQuickTroops[$j] += $aiInGameTroop[$j]
					$TempTroopTotal += $aiInGameTroop[$j] * $g_aiTroopSpace[$j]              ; tally normal troops

					If $j > $eSpellCount - 1 Then ContinueLoop
					$g_aiArmyQuickSpells[$j] += $aiInGameSpell[$j]
					$TempSpellTotal += $aiInGameSpell[$j] * $g_aiSpellSpace[$j]              ; tally spells

					If $j > $eSiegeMachineCount - 1 Then ContinueLoop
					$g_aiArmyQuickSiegeMachines[$j] += $aiInGameSiegeMachine[$j]
					$TempSiegeTotal += $aiInGameSiegeMachine[$j] * $g_aiSiegeMachineSpace[$j] 		 ; tally sieges
				Next

				ExitLoop
			WEnd

			; check if an army has troops , spells
			If Not $g_bQuickArmyMixed And $TempTroopTotal > 0 And $TempSpellTotal > 0 Then $g_bQuickArmyMixed = True
			SetDebugLog("$g_bQuickArmyMixed: " & $g_bQuickArmyMixed)
			
			If _Sleep(1500) Then Return
			
			; cross check with army camp
			If _ArrayMax($g_aiArmyQuickTroops) > 0 Then
				Local $TroopCamp = GetCurrentArmy(48, 160 + $g_iMidOffsetYFixed)
				$iTroopCamp = $TroopCamp[1] * 2
				If $TempTroopTotal <> $TroopCamp[0] Then
					SetLog("Error reading troops in army setting (" & $TempTroopTotal & " vs " & $TroopCamp[0] & ")", $COLOR_ERROR)
					$bResult = False
				Else
					$g_iTotalQuickTroops += $TempTroopTotal
					SetDebugLog("$g_iTotalQuickTroops: " & $g_iTotalQuickTroops)
				EndIf
			EndIf
			If _ArrayMax($g_aiArmyQuickSpells) > 0 Then
				Local $aiSpellCamp = GetCurrentArmy(146, 160 + $g_iMidOffsetYFixed)
				$iSpellCamp = $aiSpellCamp[1] * 2
				If $TempSpellTotal <> $aiSpellCamp[0] Then
					SetLog("Error reading spells in army setting (" & $TempSpellTotal & " vs " & $aiSpellCamp[0] & ")", $COLOR_ERROR)
					$bResult = False
				Else
					$g_iTotalQuickSpells += $TempSpellTotal
					SetDebugLog("$g_iTotalQuickSpells: " & $g_iTotalQuickSpells)
				EndIf
			EndIf
			If _ArrayMax($g_aiArmyQuickSiegeMachines) > 0 Then
				Local $aiSiegeCamp = GetCurrentArmy(236, 160 + $g_iMidOffsetYFixed)
				$iSiegeMachineCamp = $aiSiegeCamp[1] * 2
				If $TempSiegeTotal <> $aiSiegeCamp[0] Then
					SetLog("Error reading siege machines in army setting (" & $TempSiegeTotal & " vs " & $aiSiegeCamp[0] & ")", $COLOR_ERROR)
					$bResult = False
				Else
					$g_iTotalQuickSiegeMachines += $TempSiegeTotal
					SetDebugLog("$g_iTotalQuickSiegeMachines: " & $g_iTotalQuickSiegeMachines)
				EndIf
			EndIf

			$sLog &= $i + 1 & " "

			ClickP($g_abUseInGameArmy[$i] ? $aCancelButton : $aSaveButton)

			If _Sleep(1000) Then Return

		Else
			SetLog('Cannot find "Edit" button for Army ' & $i + 1, $COLOR_ERROR)
			$bResult = False
		EndIf
   Next

	$g_aiArmyCompTroops = $g_aiArmyQuickTroops
	$g_aiArmyCompSpells = $g_aiArmyQuickSpells
	$g_aiArmyCompSiegeMachines = $g_aiArmyQuickSiegeMachines

	If $g_iTotalQuickTroops > $iTroopCamp Then SetLog("Total troops in combo army " & $sLog & "exceeds your camp capacity (" & $g_iTotalQuickTroops & " vs " & $iTroopCamp & ")", $COLOR_ERROR)
	If $g_iTotalQuickSpells > $iSpellCamp Then SetLog("Total spells in combo army " & $sLog & "exceeds your camp capacity (" & $g_iTotalQuickSpells & " vs " & $iSpellCamp & ")", $COLOR_ERROR)
	If $g_iTotalQuickSiegeMachines > $iSiegeMachineCamp Then SetLog("Total siege machines in combo army " & $sLog & "exceeds your camp capacity (" & $g_iTotalQuickSiegeMachines & " vs " & $iSiegeMachineCamp & ")", $COLOR_ERROR)

	ClickP($aAway, 2, 0, "#0000") ;Click Away
	$asLastTimeChecked[$g_iCurAccount] = $bResult ? _NowCalc() : ""

EndFunc   ;==>CheckQuickTrainTroop

Func CreateQuickTrainPreset($i)
	SetLog("Creating troops/spells/siege machines preset for Army " & $i + 1)

	Local $aRemoveButton[4] = [535, 300 + $g_iMidOffsetYFixed, 0xff8f94, 20] ; red ; Resolution changed
	Local $iArmyPage = 0

	If _ColorCheck(_GetPixelColor($aRemoveButton[0], $aRemoveButton[1], True), Hex($aRemoveButton[2], 6), $aRemoveButton[2]) Then
		ClickP($aRemoveButton) ; click remove
		If _Sleep(750) Then Return

		For $j = 0 To 6
			Local $iIndex = $g_aiQuickTroopType[$i][$j]
			If _ArrayIndexValid($g_aiArmyQuickTroops, $iIndex) Then
				If $iIndex >= $eHeal And $iArmyPage = 0 Then
					If _Sleep(250) Then Return
					ClickDrag(715, 475, 25, 475, 2000)
					If _Sleep(1500) Then Return
					$iArmyPage = 1
				EndIf

				If $iIndex >= $eGole And $iArmyPage = 1 Then
					If _Sleep(250) Then Return
					ClickDrag(715, 475, 25, 475, 2000)
					If _Sleep(1500) Then Return
					$iArmyPage = 2
				EndIf

				Local $aTrainPos = GetTrainPos($iIndex)
				If IsArray($aTrainPos) And $aTrainPos[0] <> -1 Then
					SetLog("Adding " & $g_aiQuickTroopQty[$i][$j] & "x " & $g_asTroopNames[$iIndex], $COLOR_SUCCESS)
					ClickP($aTrainPos, $g_aiQuickTroopQty[$i][$j], $g_iTrainClickDelay, "QTrain")
				EndIf
			EndIf
		Next

		For $j = 0 To 6
			Local $iIndex = $g_aiQuickSpellType[$i][$j]
			If _ArrayIndexValid($g_aiArmyQuickSpells, $iIndex) Then
				If $iArmyPage = 0 Then
				    If _Sleep(250) Then Return
					ClickDrag(715, 475 + $g_iBottomOffsetYFixed, 25, 475 + $g_iBottomOffsetYFixed, 2000) ; Resolution changed
					If _Sleep(1500) Then Return
					ClickDrag(715, 475 + $g_iBottomOffsetYFixed, 25, 475 + $g_iBottomOffsetYFixed, 2000) ; Resolution changed
					If _Sleep(1500) Then Return
					ClickDrag(510, 475 + $g_iBottomOffsetYFixed, 25, 475 + $g_iBottomOffsetYFixed, 2000) ; Resolution changed
					If _Sleep(1500) Then Return
					$iArmyPage = 3
				ElseIf $iArmyPage = 1 Then
				    If _Sleep(250) Then Return
					ClickDrag(715, 475 + $g_iBottomOffsetYFixed, 25, 475 + $g_iBottomOffsetYFixed, 2000) ; Resolution changed
					If _Sleep(1500) Then Return
					ClickDrag(510, 475 + $g_iBottomOffsetYFixed, 25, 475 + $g_iBottomOffsetYFixed, 2000) ; Resolution changed
					If _Sleep(1500) Then Return
					$iArmyPage = 3
				ElseIf $iArmyPage = 2 Then
				    If _Sleep(250) Then Return
					ClickDrag(510, 475 + $g_iBottomOffsetYFixed, 25, 475 + $g_iBottomOffsetYFixed, 2000) ; Resolution changed
					If _Sleep(1500) Then Return
					$iArmyPage = 3
				EndIf
				Local $aTrainPos = GetTrainPos($iIndex + $eLSpell)
				If IsArray($aTrainPos) And $aTrainPos[0] <> -1 Then
					SetLog("Adding " & $g_aiQuickSpellQty[$i][$j] & "x " & $g_asSpellNames[$iIndex], $COLOR_SUCCESS)
					ClickP($aTrainPos, $g_aiQuickSpellQty[$i][$j], $g_iTrainClickDelay, "QTrain")
				EndIf
			EndIf
		Next

		If _Sleep(1000) Then Return
	EndIf
EndFunc   ;==>CreateQuickTrainPreset
