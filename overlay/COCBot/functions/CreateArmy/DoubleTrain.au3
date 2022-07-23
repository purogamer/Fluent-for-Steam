
; #FUNCTION# ====================================================================================================================
; Name ..........: Double Train
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen (2018)
; Modified ......: Boldina (2018 in debug / 2022), Team AIO Mod++
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2022
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func DoubleTrain($bWarTroop = False) ; Check Stop For War - Team AiO MOD++

	; If Not $g_bDoubleTrain Then Return ; Custom train - Team AIO Mod++
	Local $bDebug = $g_bDebugSetlogTrain Or $g_bDebugSetlog

	If $bDebug then SetLog(" == Double Train Army == ", $COLOR_ACTION)

	Local $bNeedReCheckTroopTab = False, $bNeedReCheckSpellTab = False

	#Region - Missing PreciseArmy - Team AIO Mod++
	Local $bHasIncorrectTroop = False, $bHasIncorrectSpell = False
	If $g_bPreciseArmy Or $g_bPreciseBrew Then
		Local $aWrongArmy = WhatToTrain(True)
		If IsArray($aWrongArmy) Then
			If $bDebug Then SetLog("$aWrongTroops: " & _ArrayToString($aWrongArmy), $COLOR_DEBUG)
			If Not (UBound($aWrongArmy) = 1 And $aWrongArmy[0][1] = "Arch" And $aWrongArmy[0][1] = 0) Then ; Default result of WhatToTrain
				For $i = 0 To UBound($aWrongArmy) - 1
					If Not $bHasIncorrectTroop And _ArraySearch($g_asTroopShortNames, $aWrongArmy[$i][0]) >= 0 And $g_bPreciseArmy Then
						$bHasIncorrectTroop = True
						If $bHasIncorrectSpell Or Not $g_bPreciseArmy Then
							ExitLoop
						EndIf
					EndIf
					
					If Not $bHasIncorrectSpell And _ArraySearch($g_asSpellShortNames, $aWrongArmy[$i][0]) >= 0 And $g_bPreciseBrew Then
						$bHasIncorrectSpell = True
						If $bHasIncorrectTroop Or Not $g_bPreciseBrew Then
							ExitLoop
						EndIf
					EndIf
				Next
				If $bDebug Then SetLog("$bNeedReCheckTroopTab: " & $bNeedReCheckTroopTab & "$bNeedReCheckSpellTab: " & $bNeedReCheckSpellTab, $COLOR_DEBUG)
				SetLog("Found incorrect " & ($bHasIncorrectTroop ? "Troops " & ($bHasIncorrectSpell ? "and Spells " : "") : "Spells ") & "in army")
			EndIf
		EndIf
	EndIf
	#EndRegion - Missing PreciseArmy - Team AIO Mod++
	
	#Region - Custom Army - Team AIO Mod++
	Local $bForceDouble = $g_bIsFullArmywithHeroesAndSpells
	Local $bPreTrainFlag = $g_bDoubleTrain Or $bForceDouble
	
	If $g_bChkPreTrainTroopsPercent = True And $g_bForceDoubleTrain = False Then
		$bPreTrainFlag = ($g_iArmyCapacity >= $g_iInpPreTrainTroopsPercent)
		SetLog("Double train condition ? " & $bPreTrainFlag, $COLOR_INFO)
	ElseIf $g_bForceDoubleTrain = True Then
		SetLog("Force double train before switch account.", $COLOR_SUCCESS)
		$bPreTrainFlag = True
	EndIf
	
	If $g_bIsFullArmywithHeroesAndSpells = True And $g_bDoubleTrain = False Then
		$bPreTrainFlag = $g_bTrainBeforeAttack
		$bForceDouble = $g_bTrainBeforeAttack
		If $g_bIsFullArmywithHeroesAndSpells = True And $g_bTrainBeforeAttack = True Then SetLog("Force double train before attack.", $COLOR_SUCCESS)
	EndIf
	
	If $bWarTroop = True Or ($g_bDoubleTrain = True And $g_bIsFullArmywithHeroesAndSpells = True) Then
		$bPreTrainFlag = True
		$bForceDouble = True
	EndIf
	#EndRegion - Custom Army - Team AIO Mod++

	Local $Step = 1
	While 1
		
		; Troop
		If Not OpenTroopsTab(False, "DoubleTrain()") Then Return
		If _Sleep(500) Then Return
		
		Local $TroopCamp = GetCurrentArmy(48, 160 + $g_iMidOffsetYFixed, "DoubleTrain Troops")
		SetLog("Checking Troop tab: " & $TroopCamp[0] & "/" & $TroopCamp[1] * 2)
		If $TroopCamp[1] = 0 Then ExitLoop
		If $TroopCamp[1] <> $g_iTotalCampSpace Then _
			SetLog("Incorrect Troop combo: " & $g_iTotalCampSpace & " vs Total camp: " & $TroopCamp[1] & @CRLF & @TAB & "Double train may not work well", $COLOR_DEBUG)

		If $bWarTroop Or $bHasIncorrectTroop Or $TroopCamp[0] < $TroopCamp[1] Then ; <280/280 ; Check Stop For War and DoubleTrain precise - Team AiO MOD++
			If Not $bWarTroop And $g_bDonationEnabled And $g_bChkDonate And MakingDonatedTroops("Troops") Then ; Check Stop For War - Team AiO MOD++
				If $bDebug Then SetLog($Step & ". MakingDonatedTroops('Troops')", $COLOR_DEBUG)
				$Step += 1
				If $Step = 6 Then ExitLoop
				ContinueLoop
			EndIf
			If Not IsQueueEmpty("Troops", False, False) Then DeleteQueued("Troops")
			$bNeedReCheckTroopTab = True
			If $bDebug Then SetLog($Step & ". DeleteQueued('Troops'). $bNeedReCheckTroopTab: " & $bNeedReCheckTroopTab, $COLOR_DEBUG)

		ElseIf $TroopCamp[0] = $TroopCamp[1] And ($g_bDoubleTrain And $bPreTrainFlag Or $bForceDouble) Then ; 280/280
			TrainFullTroop($bPreTrainFlag)
			If $bDebug Then SetLog($Step & ". TrainFullTroop(True) done!", $COLOR_DEBUG)

		ElseIf $TroopCamp[0] <= $TroopCamp[1] * 2 And ($g_bDoubleTrain And $bPreTrainFlag Or $bForceDouble) Then ; 281-540/540
			If CheckQueueTroopAndTrainRemain($TroopCamp, $bDebug) Then
				If $bDebug Then SetLog($Step & ". CheckQueueAndTrainRemain() done!", $COLOR_DEBUG)
			Else
				RemoveExtraTroopsQueue()
				If _Sleep(500) Then Return
				If $bDebug Then SetLog($Step & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
				$Step += 1
				If $Step = 6 Then ExitLoop
				ContinueLoop
			EndIf
		EndIf
		ExitLoop
	WEnd

	; Spell
	Local $iUnbalancedSpell = 0
	Local $TotalSpell = _Min(Number(TotalSpellsToBrewInGUI()), Number($g_iTotalSpellValue))
	If $TotalSpell = 0 Then
		If $bDebug Then SetLog("No spell is required, skip checking spell tab", $COLOR_DEBUG)
	Else
		$Step = 1
		While 1
			If Not OpenSpellsTab(False, "DoubleTrain()") Then Return
			If _Sleep(500) Then Return
			
			Local $SpellCamp = GetCurrentArmy(43, 160 + $g_iMidOffsetYFixed, "DoubleTrain Spells")
			SetLog("Checking Spell tab: " & $SpellCamp[0] & "/" & $SpellCamp[1] * 2)

			If $SpellCamp[1] > $TotalSpell Then
				SetLog("Unbalance Total spell setting vs actual spell capacity: " & $TotalSpell & "/" & $SpellCamp[1] & @CRLF & @TAB & "Double train may not work well", $COLOR_DEBUG)
				$iUnbalancedSpell = $SpellCamp[1] - $TotalSpell
				$SpellCamp[1] = $TotalSpell
			EndIf

			If $bWarTroop Or $bHasIncorrectSpell Or $SpellCamp[0] < $SpellCamp[1] Then ; 0-10/11 ; Check Stop For War and DoubleTrain precise - Team AiO MOD++
				If Not $bWarTroop And $g_bDonationEnabled And $g_bChkDonate And MakingDonatedTroops("Spells") Then ; Check Stop For War - Team AiO MOD++
					If $bDebug Then SetLog($Step & ". MakingDonatedTroops('Spells')", $COLOR_DEBUG)
					$Step += 1
					If $Step = 6 Then ExitLoop
					ContinueLoop
				EndIf
				If Not IsQueueEmpty("Spells", False, False) Then DeleteQueued("Spells")
				$bNeedReCheckSpellTab = True
				If $bDebug Then SetLog($Step & ". DeleteQueued('Spells'). $bNeedReCheckSpellTab: " & $bNeedReCheckSpellTab, $COLOR_DEBUG)

			ElseIf $SpellCamp[0] = $SpellCamp[1] Or $SpellCamp[0] <= $SpellCamp[1] + $iUnbalancedSpell And ($g_bForcePreBrewSpells Or ($g_bDoubleTrain And $bPreTrainFlag) Or $bForceDouble) Then ; 11/22
				BrewFullSpell($bPreTrainFlag)
				If $iUnbalancedSpell > 0 Then TopUpUnbalancedSpell($iUnbalancedSpell)
				If $bDebug Then SetLog($Step & ". BrewFullSpell(True) done!", $COLOR_DEBUG)

			ElseIf ($g_bForcePreBrewSpells Or ($g_bDoubleTrain And $bPreTrainFlag) Or $bForceDouble) Then ; If $SpellCamp[0] <= $SpellCamp[1] * 2 Then ; 12-22/22
				If CheckQueueSpellAndTrainRemain($SpellCamp, $bDebug, $iUnbalancedSpell) Then
					If $SpellCamp[0] < ($SpellCamp[1] + $iUnbalancedSpell) * 2 Then TopUpUnbalancedSpell($iUnbalancedSpell)
					If $bDebug Then SetLog($Step & ". CheckQueueSpellAndTrainRemain() done!", $COLOR_DEBUG)
				Else
					RemoveExtraTroopsQueue()
					If _Sleep(500) Then Return
					If $bDebug Then SetLog($Step & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
					$Step += 1
					If $Step = 6 Then ExitLoop
					ContinueLoop
				EndIf
			ElseIf $iUnbalancedSpell = 0 Then
				If CheckQueueSpellAndTrainRemain($SpellCamp, $bDebug, $iUnbalancedSpell, True) Then
					If $bDebug Then SetLog($Step & ". CheckQueueSpellAndTrainRemain() force pre train!", $COLOR_DEBUG)
				EndIf
			EndIf
			ExitLoop
		WEnd
	EndIf

	If $bNeedReCheckTroopTab Or $bNeedReCheckSpellTab Then
		Local $aWhatToRemove = WhatToTrain(True)
		Local $rRemoveExtraTroops = RemoveExtraTroops($aWhatToRemove)
		If $bDebug Then SetLog("RemoveExtraTroops(): " & $rRemoveExtraTroops, $COLOR_DEBUG)

		Local $aWhatToTrain = WhatToTrain(False, False)
		If DoWhatToTrainContainTroop($aWhatToTrain) Then
			TrainUsingWhatToTrain($aWhatToTrain)
			TrainFullTroop($bPreTrainFlag)
			If $bDebug Then SetLog("TrainFullTroop(True) done.", $COLOR_DEBUG)
		EndIf
		If DoWhatToTrainContainSpell($aWhatToTrain) Then
			BrewUsingWhatToTrain($aWhatToTrain)
			BrewFullSpell($bPreTrainFlag)
			If $iUnbalancedSpell > 0 Then TopUpUnbalancedSpell($iUnbalancedSpell)
			If $bDebug Then SetLog("BrewFullSpell(True) done.", $COLOR_DEBUG)
		EndIf
	EndIf

	If _Sleep(250) Then Return

EndFunc   ;==>DoubleTrain

Func TrainFullTroop($bQueue = False)
	SetLog("Training " & ($bQueue ? "2nd Army..." : "1st Army..."), $COLOR_ACTION)
	
	Local $ToReturn[1][2] = [["Arch", 0]]
	For $i = 0 To $eTroopCount - 1
		Local $troopIndex = $g_aiTrainOrder[$i]
		If $g_aiArmyCompTroops[$troopIndex] > 0 Then
			$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
			$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompTroops[$troopIndex]
			ReDim $ToReturn[UBound($ToReturn) + 1][2]
		EndIf
	Next

	If $ToReturn[0][0] = "Arch" And $ToReturn[0][1] = 0 Then Return

	TrainUsingWhatToTrain($ToReturn, $bQueue)
	If _Sleep(500) Then Return

	Local $CampOCR = GetCurrentArmy(48, 160 + $g_iMidOffsetYFixed, "TrainFullTroop army")
	SetDebugLog("Checking troop tab: " & $CampOCR[0] & "/" & $CampOCR[1] * 2)
EndFunc   ;==>TrainFullTroop

Func BrewFullSpell($bQueue = False)
	If $g_bForcePreBrewSpells Then $bQueue = True
	SetLog("Brewing " & ($bQueue ? "2nd Army..." : "1st Army..."), $COLOR_ACTION)

	Local $ToReturn[1][2] = [["Arch", 0]]
	For $i = 0 To $eSpellCount - 1
		Local $BrewIndex = $g_aiBrewOrder[$i]
        If $g_aiArmyCompSpells[$BrewIndex] > 0 Then
			$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
			$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$BrewIndex]
			ReDim $ToReturn[UBound($ToReturn) + 1][2]
		EndIf
	Next

	If $ToReturn[0][0] = "Arch" And $ToReturn[0][1] = 0 Then Return

	BrewUsingWhatToTrain($ToReturn, $bQueue)
	If _Sleep(750) Then Return

	Local $CampOCR = GetCurrentArmy(43, 160 + $g_iMidOffsetYFixed, "BrewFullSpell army")
	SetDebugLog("Checking spell tab: " & $CampOCR[0] & "/" & $CampOCR[1] * 2)
EndFunc   ;==>BrewFullSpell

Func TopUpUnbalancedSpell($iUnbalancedSpell = 0)

	If $iUnbalancedSpell = 0 Then Return
	Local $iTypeOfSpell = 0, $iSpellIndex
	For $i = 0 To UBound($g_aiArmyCompSpells) - 1
		If $g_aiArmyCompSpells[$i] > 0 Then
			$iSpellIndex = $i
			$iTypeOfSpell += 1
		EndIf
		If $iTypeOfSpell > 1 Then ExitLoop
	Next

	If $iTypeOfSpell = 1 Then
		Local $aSpell[1][2]
		$aSpell[0][0] = $g_asSpellShortNames[$iSpellIndex]
		$aSpell[0][1] = Int($iUnbalancedSpell * 2 / $g_aiSpellSpace[$iSpellIndex])

		If $aSpell[0][1] >= 1 Then
			SetLog("Topping up " & $g_asSpellNames[$iSpellIndex] & " Spell x" & $aSpell[0][1])
			BrewUsingWhatToTrain($aSpell, True)
		EndIf
	EndIf

	If _Sleep(750) Then Return

EndFunc   ;==>IsBrewOnlyOneType

Func GetCurrentArmy($x_start, $y_start, $sCalledFrom = "")

	Local $aResult[3] = [0, 0, 0]
	If Not $g_bRunState Then Return $aResult

	; [0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army
	Local $iOCRResult = getArmyCapacityOnTrainTroops($x_start, $y_start)

	If StringInStr($iOCRResult, "#") Then
		Local $aTempResult = StringSplit($iOCRResult, "#", $STR_NOCOUNT)
		$aResult[0] = Number($aTempResult[0])
		$aResult[1] = Number($aTempResult[1]) / 2
		$aResult[2] = $aResult[1] - $aResult[0]
	Else
		SetLog("DEBUG | ERROR on GetCurrentArmy " & $sCalledFrom, $COLOR_ERROR)
	EndIf

	Return $aResult

EndFunc   ;==>GetCurrentArmy

Func CheckQueueTroopAndTrainRemain($ArmyCamp, $bDebug)
	If $ArmyCamp[0] = $ArmyCamp[1] * 2 And ((ProfileSwitchAccountEnabled() And $g_abAccountNo[$g_iCurAccount] And $g_abDonateOnly[$g_iCurAccount]) Or $g_iCommandStop = 0) Then Return True ; bypass Donate account when full queue

	Local $iTotalQueue = 0
	If $bDebug Then SetLog("Checking troop queue: " & $ArmyCamp[0] & "/" & $ArmyCamp[1] * 2, $COLOR_DEBUG)

	Local $XQueueStart = 839
	For $i = 0 To 10
		If _ColorCheck(_GetPixelColor(825 - $i * 70, 186 + $g_iMidOffsetYFixed, True), Hex(0xD7AFA9, 6), 20) Then ; Pink background found ; Fixed resolution
			$XQueueStart -= 70.5 * $i
			ExitLoop
		EndIf
	Next

	Local $aiQueueTroops = CheckQueueTroops(True, $bDebug, $XQueueStart)
	If Not IsArray($aiQueueTroops) Then Return False
	For $i = 0 To UBound($aiQueueTroops) - 1
		If $aiQueueTroops[$i] > 0 Then $iTotalQueue += $aiQueueTroops[$i] * $g_aiTroopSpace[$i]
	Next
	; Check block troop
	If $ArmyCamp[0] < $ArmyCamp[1] + $iTotalQueue Then
		SetLog("A big guy blocks our camp")
		Return False
	EndIf
	; check wrong queue
	For $i = 0 To UBound($aiQueueTroops) - 1
		If $aiQueueTroops[$i] - $g_aiArmyCompTroops[$i] > 0 Then
			SetLog("Some wrong troops in queue")

			Return False
		EndIf
	Next
	If $ArmyCamp[0] < $ArmyCamp[1] * 2 Then
		; Train remain
		SetLog("Checking troop queue:")
		Local $rWTT[1][2] = [["Arch", 0]] ; what to train
		For $i = 0 To UBound($aiQueueTroops) - 1
			Local $iIndex = $g_aiTrainOrder[$i]
			If $aiQueueTroops[$iIndex] > 0 Then SetLog("  - " & $g_asTroopNames[$iIndex] & ": " & $aiQueueTroops[$iIndex] & "x")
			If $g_aiArmyCompTroops[$iIndex] - $aiQueueTroops[$iIndex] > 0 Then
				$rWTT[UBound($rWTT) - 1][0] = $g_asTroopShortNames[$iIndex]
				$rWTT[UBound($rWTT) - 1][1] = Abs($g_aiArmyCompTroops[$iIndex] - $aiQueueTroops[$iIndex])
				SetLog("   - Missing: " & $g_asTroopNames[$iIndex] & " x" & $rWTT[UBound($rWTT) - 1][1])
				ReDim $rWTT[UBound($rWTT) + 1][2]
			EndIf
		Next
		TrainUsingWhatToTrain($rWTT, True)

		If _Sleep(1000) Then Return
		$ArmyCamp = GetCurrentArmy(48, 160 + $g_iMidOffsetYFixed, "CheckQueueTroopAndTrainRemain army")
		SetLog("Checking troop tab: " & $ArmyCamp[0] & "/" & $ArmyCamp[1] * 2 & ($ArmyCamp[0] < $ArmyCamp[1] * 2 ? ". Top-up queue failed!" : ""))
		If $ArmyCamp[0] < $ArmyCamp[1] * 2 Then Return False
	EndIf
	Return True
EndFunc   ;==>CheckQueueTroopAndTrainRemain

Func CheckQueueSpellAndTrainRemain($ArmyCamp, $bDebug, $iUnbalancedSpell = 0, $bBrewPre = False)
	If $ArmyCamp[0] = $ArmyCamp[1] * 2 And ((ProfileSwitchAccountEnabled() And $g_abAccountNo[$g_iCurAccount] And $g_abDonateOnly[$g_iCurAccount]) Or $g_iCommandStop = 0) Then Return True ; bypass Donate account when full queue

	Local $iTotalQueue = 0
	If $bDebug Then SetLog("Checking spell queue: " & $ArmyCamp[0] & "/" & $ArmyCamp[1] * 2, $COLOR_DEBUG)

	Local $XQueueStart = 839
	For $i = 0 To 10
		If _ColorCheck(_GetPixelColor(825 - $i * 70, 186 + $g_iMidOffsetYFixed, True), Hex(0xD7AFA9, 6), 20) Then ; Pink background found ; Fixed resolution
			$XQueueStart -= 70.5 * $i
			ExitLoop
		EndIf
	Next

	Local $aiQueueSpells = CheckQueueSpells(True, true, 839)
	If $bBrewPre = False Then
		If Not IsArray($aiQueueSpells) Then Return False
		For $i = 0 To UBound($aiQueueSpells) - 1
			If $aiQueueSpells[$i] > 0 Then $iTotalQueue += $aiQueueSpells[$i] * $g_aiSpellSpace[$i]
		Next
		; Check block spell
		If $ArmyCamp[0] < $ArmyCamp[1] + $iTotalQueue Then
			SetLog("A big guy blocks our camp")
			Return False
		EndIf
		
		; check wrong queue
		Local $iUnbalancedSlot = 0, $iTypeOfSpell = 0
		For $i = 0 To UBound($aiQueueSpells) - 1
			If $aiQueueSpells[$i] > 0 Then $iTypeOfSpell += 1
			If $aiQueueSpells[$i] - $g_aiArmyCompSpells[$i] > 0 Then
				$iUnbalancedSlot += ($aiQueueSpells[$i] - $g_aiArmyCompSpells[$i]) * $g_aiSpellSpace[$i]
				If $iTypeOfSpell > 1 Or $iUnbalancedSlot > $iUnbalancedSpell * 2 Then ; more than 2 spell types
					SetLog("Some wrong spells in queue (" & $g_asSpellNames[$i] & " x" & $aiQueueSpells[$i] & "/" & $g_aiArmyCompSpells[$i] & ")")
					Return False
				EndIf
			EndIf
		Next
	EndIf
	
	If $ArmyCamp[0] < $ArmyCamp[1] * 2 And Not $bBrewPre Then
		; Train remain
		SetLog("Checking spells queue:")
		Local $rWTT[1][2] = [["Arch", 0]] ; what to train
		For $i = 0 To UBound($aiQueueSpells) - 1
			Local $iIndex = $g_aiBrewOrder[$i]
			$aiQueueSpells[$iIndex] = Number($aiQueueSpells[$iIndex])
			If $aiQueueSpells[$iIndex] > 0 Then SetLog("  - " & $g_asSpellNames[$iIndex] & ": " & $aiQueueSpells[$iIndex] & "x")
			If $g_aiArmyCompSpells[$iIndex] - $aiQueueSpells[$iIndex] > 0 Then
				$rWTT[UBound($rWTT) - 1][0] = $g_asSpellShortNames[$iIndex]
				$rWTT[UBound($rWTT) - 1][1] = Abs($g_aiArmyCompSpells[$iIndex] - $aiQueueSpells[$iIndex])
				SetLog("    missing: " & $g_asSpellNames[$iIndex] & " x" & $rWTT[UBound($rWTT) - 1][1])
				ReDim $rWTT[UBound($rWTT) + 1][2]
			EndIf
		Next
		BrewUsingWhatToTrain($rWTT, True)

		If _Sleep(1000) Then Return
		Local $NewSpellCamp = GetCurrentArmy(43, 160 + $g_iMidOffsetYFixed, "CheckQueueSpellAndTrainRemain brew")
		SetLog("Checking spell tab: " & $NewSpellCamp[0] & "/" & $NewSpellCamp[1] * 2 & ($NewSpellCamp[0] < $ArmyCamp[1] * 2 ? ". Top-up queue failed!" : ""))
		If $NewSpellCamp[0] < $ArmyCamp[1] * 2 Then Return False
	ElseIf $bBrewPre And $ArmyCamp[0] = $ArmyCamp[1] Then ;- $iUnbalancedSlot Then
		; Train remain
		If Not IsArray($aiQueueSpells) Then
			Local $aiFake[UBound($g_ahChkSpellsPre)]
			$aiQueueSpells = $aiFake
		EndIf
		SetLog("Checking pre spells queue:")
		Local $rWTT[1][2] = [["Arch", 0]] ; what to train
		For $i = 0 To UBound($aiQueueSpells) - 1
			Local $iIndex = $g_aiBrewOrder[$i]
			If (GUICtrlRead($g_ahChkSpellsPre[$i]) = $GUI_UNCHECKED) Then ContinueLoop
			$aiQueueSpells[$iIndex] = Number($aiQueueSpells[$iIndex])
			If $aiQueueSpells[$iIndex] > 0 Then SetLog("  - " & $g_asSpellNames[$iIndex] & ": " & $aiQueueSpells[$iIndex] & "x")
			If $g_aiArmyCompSpells[$iIndex] - $aiQueueSpells[$iIndex] > 0 Then
				$rWTT[UBound($rWTT) - 1][0] = $g_asSpellShortNames[$iIndex]
				$rWTT[UBound($rWTT) - 1][1] = Abs($g_aiArmyCompSpells[$iIndex] - $aiQueueSpells[$iIndex])
				SetLog("    missing: " & $g_asSpellNames[$iIndex] & " x" & $rWTT[UBound($rWTT) - 1][1])
				ReDim $rWTT[UBound($rWTT) + 1][2]
			EndIf
		Next
		BrewUsingWhatToTrain($rWTT, True)

		If _Sleep(1000) Then Return
		Return True
	EndIf
	Return True
EndFunc   ;==>CheckQueueSpellAndTrainRemain

#Region - Custom Train - Team AIO Mod++
Func TestFixInDoubleTrain()
    $g_iTotalCampSpace = 300
    FixInDoubleTrain($g_aiArmyCompTroops, $g_iTotalCampSpace, $g_aiTroopSpace, 0)
    _ArrayDisplay($g_aiArmyCompTroops)
EndFunc

Func FixInDoubleTrain(ByRef $aTroops, $iTotal, $aTroopSpace, $iIndexRemain = 0)
    Local $iTotalFixed = 0, $iRealCAP = 0
    Local $iCo = _Min(UBound($aTroops), UBound($aTroopSpace))

    For $i = 0 To $iCo -1
        $iRealCAP += $aTroops[$i] * $aTroopSpace[$i]
    Next
	
    If $iRealCAP == $g_iTotalCampSpace Then Return
	
    If $iRealCAP = 0 Or $iTotal = 0 Then
        SetLog("FixInDoubleTrain error", $COLOR_ERROR)
        Return False
    EndIf
    
    If $iRealCAP = 0 Then
        SetLog("Set-up your army !", $COLOR_ERROR)
        $aTroops[$iIndexRemain] = $iTotal
        Return
    EndIf

    For $i = 0 To $iCo -1
        $aTroops[$i] = Floor(((((($aTroops[$i] * $aTroopSpace[$i]) / $iRealCAP)  * 100) * $iTotal) / 100) / $aTroopSpace[$i])
        $iTotalFixed += $aTroops[$i] * $aTroopSpace[$i]
    Next

    Local $iFinal = $iTotalFixed
    If $iTotalFixed <> $iTotal Then
        For $i = 0 To $iCo -1
            If $aTroops[$i] = 0 Then ContinueLoop
            Local $iDiff = Abs($iTotalFixed - $iTotal)
            If Mod($iDiff, $aTroopSpace[$i]) = 0 Then
                $iFinal -= $aTroops[$i] * $aTroopSpace[$i]
                $aTroops[$i] += $iDiff / $aTroopSpace[$i]
                $iFinal += $aTroops[$i] * $aTroopSpace[$i]
                ExitLoop
            EndIf
        Next
    EndIf
    $aTroops[$iIndexRemain] += Abs($iFinal - $iTotal)
EndFunc   ;==>FixInDoubleTrain
#EndRegion - Custom Train - Team AIO Mod++