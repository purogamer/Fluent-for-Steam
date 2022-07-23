; #FUNCTION# ====================================================================================================================
; Name ..........: SuperXP
; Description ...: This file is all related to Gaining XP by Attacking to Goblin Picninc Signle player
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MR.ViPER (2016-11-5)
; Modified ......: MR.ViPER (2016-11-13), MR.ViPER (2017-1-1)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;SuperXP / GoblinXP
Global $g_iStatsSuperXP = 0
Global Const $DELAYDROPSuperXP1= 500
Global Const $DELAYDROPSuperXP2 = 1000
Global Const $DELAYDROPSuperXP3 = 250
Global Const $DELAYPREPARESearchSuperXP = 500

Func SetStatsSX()

	If Not ProfileSwitchAccountEnabled() Then Return
	Static $FirstRun = True
	Static $StatsAccounts[9][5]

	If $FirstRun Then
		For $i = 0 To UBound($StatsAccounts) - 1
			$StatsAccounts[$i][0] = 0
			$StatsAccounts[$i][1] = 0
			$StatsAccounts[$i][2] = 0
			$StatsAccounts[$i][3] = 0
			$StatsAccounts[$i][4] = 0
		Next
	EndIf

	Static $CurrentAccountSX = -1

	If $g_bDebugSX Then
		SetDebugLog("$CurrentAccountSuperXP:" & $CurrentAccountSX, $COLOR_DEBUG)
		SetDebugLog("$g_iCurAccount:" & $g_iCurAccount, $COLOR_DEBUG)
		SetDebugLog("$g_iStartXP:" & $g_iStartXP, $COLOR_DEBUG)
	EndIf

	If $g_iCurAccount = $CurrentAccountSX Then
		If $g_bDebugSX Then SetDebugLog("'Same' account Update Values!", $COLOR_DEBUG)
		; Store the values from this account
		$StatsAccounts[$g_iCurAccount][0] = $g_iStartXP
		$StatsAccounts[$g_iCurAccount][1] = $g_iCurrentXP
		$StatsAccounts[$g_iCurAccount][2] = $g_iGainedXP
		$StatsAccounts[$g_iCurAccount][3] = $g_iGainedHourXP
		$StatsAccounts[$g_iCurAccount][4] = $g_sRunTimeXP
	Else
		If $g_bDebugSX Then SetDebugLog("'Other' account Update Values!", $COLOR_DEBUG)
		; Restore the previous values from this account
		$g_iStartXP = $StatsAccounts[$g_iCurAccount][0]
		$g_iCurrentXP = $StatsAccounts[$g_iCurAccount][1]
		$g_iGainedXP = $StatsAccounts[$g_iCurAccount][2]
		$g_iGainedHourXP = $StatsAccounts[$g_iCurAccount][3]
		$g_sRunTimeXP = $StatsAccounts[$g_iCurAccount][4]
		; Update the account number
		$CurrentAccountSX = $g_iCurAccount
	EndIf
	$FirstRun = False

EndFunc   ;==>SetStatsSX

Func ResetStatsSX()
	$g_iStartXP = 0
	$g_iCurrentXP = 0
	$g_iGainedXP = 0
	$g_iGainedHourXP = 0
	$g_sRunTimeXP = 0
	GUICtrlSetData($g_hLblStartXP, $g_iStartXP)
	GUICtrlSetData($g_hLblCurrentXP, $g_iCurrentXP)
	GUICtrlSetData($g_hLblWonXP, $g_iGainedXP)
	GUICtrlSetData($g_hLblWonHourXP, $g_iGainedHourXP)
	GUICtrlSetData($g_hLblRunTimeXP, "00:00:00")
EndFunc   ;==>ResetStatsSX

Func DisableSX()
	GUICtrlSetState($g_hChkEnableSuperXP, $GUI_UNCHECKED)
	$g_bEnableSuperXP = False

	For $i = $g_hChkEnableSuperXP To $g_hLblRunTimeXP
		GUICtrlSetState($i, $GUI_DISABLE)
	Next

	GUICtrlSetState($g_hLblLockedSX, $GUI_SHOW + $GUI_ENABLE)
EndFunc   ;==>DisableSX

Func SetSuperXP($toSet = "")
	SetStatsSX()
	If $toSet = "S" Or $toSet = "" Then GUICtrlSetData($g_hLblStartXP, $g_iStartXP)
	If $toSet = "C" Or $toSet = "" Then GUICtrlSetData($g_hLblCurrentXP, $g_iCurrentXP)
	If $toSet = "W" Or $toSet = "" Then GUICtrlSetData($g_hLblWonXP, $g_iGainedXP)
	$g_iGainedHourXP = Round($g_iGainedXP / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)
	If $toSet = "H" Or $toSet = "" Then GUICtrlSetData($g_hLblWonHourXP, $g_iGainedHourXP)
	If _DateIsValid($g_sRunTimeXP) Then
		Local $hour = 0, $min = 0, $sec = 0
		Local $sDateTimeDiffOfXPRunTimeInSec = _DateDiff("s", $g_sRunTimeXP, _NowCalc())
		_TicksToTime($sDateTimeDiffOfXPRunTimeInSec * 1000, $hour, $min, $sec)
		GUICtrlSetData($g_hLblRunTimeXP, StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
	EndIf
EndFunc   ;==>SetSuperXP

Func MainSXHandler()
	If Not $g_bEnableSuperXP Then Return
	If $g_bDebugSetlog Then $g_bDebugSX = True
	If Not $g_bDebugSetlog Then $g_bDebugSX = False
	If $g_bDebugSetlog Or $g_bDebugSX Then SetDebugLog("Begin MainSXHandler, $g_iActivateOptionSX = " & $g_iActivateOptionSX & ", $g_bIsFullArmywithHeroesAndSpells = " & $g_bIsFullArmywithHeroesAndSpells, $COLOR_DEBUG)
	If $g_iActivateOptionSX = 1 And $g_bIsFullArmywithHeroesAndSpells = True Then Return ; If Gain while Training Enabled but Army is Full Then Return
	$g_iStatsSuperXP = 0

	checkMainScreen(False, False)
	ZoomOut()

	$g_sRunTimeXP = _NowCalc()
	If $g_iGainedXP >= $g_iMaxXPtoGain Then
		SetLog("You have Max XP to Gain SuperXP", $COLOR_DEBUG)
		If $g_bDebugSX Then SetDebugLog("$g_iGainedXP = " & $g_iGainedXP & "|$g_iMaxXPtoGain = " & $g_iMaxXPtoGain, $COLOR_DEBUG)
		$g_bEnableSuperXP = False
		GUICtrlSetState($g_hChkEnableSuperXP, $GUI_UNCHECKED)
		Return ; If Gain XP More Than Max XP to Gain Then Exit/Return
	EndIf

	If Not WaitForMain() Then
		SetLog("Cannot get in Main Screen!! Exiting SuperXP", $COLOR_ERROR)
		Return False
	EndIf

	$g_aiCurrentLoot[$eLootTrophy] = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; get OCR to read current Village Trophies
	SetDebugLog("Current Trophy Count: " & $g_aiCurrentLoot, $COLOR_DEBUG) ;Debug
	If Number($g_aiCurrentLoot) > Number($g_iDropTrophyMax) Then Return
	If Number($g_aiCurrentLoot) < 4900 Then chkShieldStatus()

	Local $aHeroResult = getArmyHeroCount(True, True)
	If $aHeroResult = @error And @error > 0 Then SetLog("Error while getting hero count, #" & @error, $COLOR_DEBUG)
	If Not WaitForMain() Then
		SetLog("Cannot get in Main Screen!! Exiting SuperXP", $COLOR_ERROR)
		Return False
	EndIf

	Local $bKing = IIf($g_bBKingSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroKing) = $eHeroKing)
	Local $bQueen = IIf($g_bAQueenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroQueen) = $eHeroQueen)
	Local $bWarden = IIf($g_bGWardenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroWarden) = $eHeroWarden)

	$bCanGainXP = ($g_iHeroAvailable <> $eHeroNone And ($bKing Or $bQueen Or $bWarden And _
														IIf($g_iActivateOptionSX = 1, $g_bIsFullArmywithHeroesAndSpells = False, True) And Number($g_iGainedXP) < Number($g_iMaxXPtoGain)))

	If $g_bDebugSX Then SetDebugLog("$g_iHeroAvailable = " & $g_iHeroAvailable)
	If $g_bDebugSX Then SetDebugLog("BK: " & $g_bBKingSX & ", AQ: " & $g_bAQueenSX & ", GW: " & $g_bGWardenSX)
	If $g_bDebugSX Then SetDebugLog("$bCanGainXP = " & $bCanGainXP & @CRLF & _
			"1: " & String(IIf($g_bBKingSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroKing) = $eHeroKing)) & _
			", 2: " & String(IIf($g_bAQueenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroQueen) = $eHeroQueen) & "|" & BitAND($g_iHeroAvailable, $eHeroQueen)) & _
			", 3: " & String(IIf($g_bGWardenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroWarden) = $eHeroWarden) & "|" & BitAND($g_iHeroAvailable, $eHeroWarden)) & _
			", 4: " & ($g_iHeroAvailable <> $eHeroNone) & _
			", 5: " & String(IIf($g_iActivateOptionSX = 1, $g_bIsFullArmywithHeroesAndSpells = False, True)) & _
			", 6: " & String(Number($g_iGainedXP) < Number($g_iMaxXPtoGain)))

	If Not $bCanGainXP Then Return

	; Check if Start XP is not grabbed YET
	If $g_iStartXP = 0 Or $g_iStartXP = "" Then
		$g_iStartXP = GetCurXP()
		SetSuperXP("S")
	EndIf

	; For SwitchAccounts loops
	Local $CurrentXPgain = 0

	; Okay everything is Good, Attack Goblin Picnic
	checkAttackDisable($g_iTaBChkIdle)
	While $bCanGainXP
		If Not WaitForMain() Then
			SetLog("Cannot get in Main Screen!! Exiting SuperXP", $COLOR_ERROR)
			Return False
		EndIf

		If $g_iGainedXP >= $g_iMaxXPtoGain And Not $g_bFastSuperXP Then
			$bCanGainXP = False
			SetLog("You have Max XP to Gain SuperXP", $COLOR_DEBUG)
			If $g_bDebugSX Then SetDebugLog("$g_iGainedXP = " & $g_iGainedXP & "|$g_iMaxXPtoGain = " & $g_iMaxXPtoGain, $COLOR_DEBUG)
			$g_bEnableSuperXP = False
			GUICtrlSetState($g_hChkEnableSuperXP, $GUI_UNCHECKED)
			ExitLoop ; If Gain XP More Than Max XP to Gain Then Exit/Return
		EndIf

		SetLog("Attacking to " & $g_sGoblinMapOptSX & " - SuperXP", $COLOR_INFO)
		If Not $g_bRunState Then Return
		If Not OpenGoblinMapSX() Then
			SafeReturnSX()
			Return False
		EndIf

		If Not $g_bRunState Then Return
		Local $isAttackSuperXP = AttackSX()
		If $isAttackSuperXP Then
			If Not $g_bRunState Then Return
			WaitToFinishSX()
		EndIf

		If Not $g_bRunState Then Return
		SetLog("Attack Finished - SuperXP", $COLOR_SUCCESS)
		If $isAttackSuperXP Then AttackFinishedSX()
		If Not $bCanGainXP Then ExitLoop
		If $g_iGoblinMapOptSX = 1 Then
			$CurrentXPgain += 5
		ElseIf $g_iGoblinMapOptSX = 2 Then
			$CurrentXPgain += 11
		EndIf

		If ((BalanceDonRec(False)) And (Not SkipDonateNearFullTroops(False, $aHeroResult)) And (not $g_bFastSuperXP) And ((_ColorCheck(_GetPixelColor(26, 342 + $g_iMidOffsetYFixed, True), Hex(0xEA0810, 6), 20)))) Then
			DonateCC(True)
		EndIf

		If Not $g_bSkipZoomOutSX Or Not IsMainPage() Then
			checkMainScreen(False, False)
			ZoomOut()
		EndIf

		If $g_iActivateOptionSX = 1 Then CheckForFullArmy()
		$bCanGainXP = ($g_iHeroAvailable <> $eHeroNone And (IIf($g_bBKingSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroKing) = $eHeroKing) Or _
															IIf($g_bAQueenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroQueen) = $eHeroQueen) Or _
															IIf($g_bGWardenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroWarden) = $eHeroWarden) And _
															IIf($g_iActivateOptionSX = 1, $g_bIsFullArmywithHeroesAndSpells = False, True) And $g_bEnableSuperXP = True And Number($g_iGainedXP) < Number($g_iMaxXPtoGain)))

		If ProfileSwitchAccountEnabled() And $bCanGainXP And $CurrentXPgain >= 50 And Not $g_bFastSuperXP Then
			SetLog("Switch Account is enable let's check it", $COLOR_SUCCESS)
			ExitLoop
		EndIf

		If $g_bDebugSX Then SetDebugLog("$g_iHeroAvailable = " & $g_iHeroAvailable)
		If $g_bDebugSX Then SetDebugLog("BK: " & $g_bBKingSX & ", AQ: " & $g_bAQueenSX & ", GW: " & $g_bGWardenSX)
		If $g_bDebugSX Then SetDebugLog("While|$bCanGainXP = " & $bCanGainXP & @CRLF & _
				"1: " & String(IIf($g_bBKingSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroKing) = $eHeroKing)) & _
				", 2: " & String(IIf($g_bAQueenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroQueen) = $eHeroQueen)) & _
				", 3: " & String(IIf($g_bGWardenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroWarden) = $eHeroWarden)) & ", 4: " & ($g_iHeroAvailable <> $eHeroNone) & _
				", 5: " & String(IIf($g_iActivateOptionSX = 1, $g_bIsFullArmywithHeroesAndSpells = False, True)) & _
				", 6: " & String($g_bEnableSuperXP = True) & _
				", 7: " & String(Number($g_iGainedXP) < Number($g_iMaxXPtoGain)))
	WEnd

EndFunc   ;==>MainSXHandler

Func CheckForFullArmy()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin CheckForFullArmy", $COLOR_DEBUG)

	; ********** This will check ALL , Troops , Spells, Heroes, CC etc etc  **************
	CheckIfArmyIsReady()

	$g_bCanRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1] + 20, True, "CheckForFullArmy-Request#1"), Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) And _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True, "CheckForFullArmy-Request#2"), Hex($aRequestTroopsAO[4], 6), $aRequestTroopsAO[5])

	; $g_bCanRequestCC was updated on previous Function getArmyCCStatus()
	If $g_bCanRequestCC Then
		; If Use CC Balanced : check the ratio
		If $g_bUseCCBalanced Then
			If Number($g_iTroopsDonated) / Number($g_iTroopsReceived) >= Number($g_iCCDonated) / Number($g_iCCReceived) Then
				RequestCC()
			Else
				SetLog("Skip RequestCC, donated  (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") < " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
			EndIf
		Else
			RequestCC()
		EndIf
	EndIf

	;Test for Train/Donate Only and Fullarmy
	If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And $g_bIsFullArmywithHeroesAndSpells Then
		SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
		If $g_bFirstStart Then $g_bFirstStart = False
		Return
	EndIf

	If $g_bDebugSX Then SetDebugLog("$g_bIsFullArmywithHeroesAndSpells: " & $g_bIsFullArmywithHeroesAndSpells)
	If $g_bDebugSX Then SetDebugLog("Army Pixel: " & _GetPixelColor($aGreenArrowTrainTroops[0], $aGreenArrowTrainTroops[1], True))
	If $g_bDebugSX Then SetDebugLog("Spell Pixel: " & _GetPixelColor($aGreenArrowBrewSpells[0], $aGreenArrowBrewSpells[1], True))

	If Not $g_bIsFullArmywithHeroesAndSpells And _
		((Not $g_bFullArmy And _ColorCheck(_GetPixelColor($aGreenArrowTrainTroops[0], $aGreenArrowTrainTroops[1], True, "CheckForFullArmy-Army"), Hex(0x605C4C, 6), 15)) Or _
		(Not $g_bFullArmySpells And _ColorCheck(_GetPixelColor($aGreenArrowBrewSpells[0], $aGreenArrowBrewSpells[1], True, "CheckForFullArmy-Spell"), Hex(0x605C4C, 6), 15))) Then ; if Full army was false and nothing was in 'Train' and 'Brew' Queue then check for train

		If $g_bDebugSX Then SetDebugLog("Super XP : CheckForFullArmy| TrainSystem. #1", $COLOR_DEBUG)
		TrainSystem()
	ElseIf $g_bIsFullArmywithHeroesAndSpells And $g_bEnableSuperXP And $g_iActivateOptionSX = 1 Then ; Train Troops Before Attack
		If $g_bDebugSX Then SetDebugLog("Super XP : CheckForFullArmy| TrainSystem. #2", $COLOR_DEBUG)
		TrainSystem()
	EndIf

	If $g_bDebugSX Then SetDebugLog("Super XP : CheckForFullArmy Finished", $COLOR_DEBUG)
EndFunc   ;==>CheckForFullArmy

Func SafeReturnSX()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin SafeReturnSX", $COLOR_DEBUG)

	Local $bObstacleResult = checkObstacles(False)
	SetDebugLog("CheckObstacles Result = " & $bObstacleResult, $COLOR_DEBUG)

	If (Not $bObstacleResult And $g_bMinorObstacle) Then
		$g_bMinorObstacle = False
	ElseIf (Not $bObstacleResult And Not $g_bMinorObstacle) Then
		RestartAndroidCoC() ; Need to try to restart CoC
	Else
		$g_bRestart = True
	EndIf

	If IsMainPage() Then
		If $g_iActivateOptionSX = 1 Then $bCanGainXP = False
		Return True
	Else
		$bCanGainXP = False
	EndIf

	Local $rExit = False
	If IsInAttackSX() Then
		$rExit = ReturnHomeSX()
	ElseIf IsInSPPage() Then
		$rExit = ExitSPPage()
	EndIf
	If $g_bDebugSX Then SetDebugLog("Super XP : SafeReturnSX = " & $rExit)
	Return $rExit
EndFunc   ;==>SafeReturnSX

Func ExitSPPage()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin ExitSPPage", $COLOR_DEBUG)

	ClickAway() ; ClickP($aAway, 1, 0, "#0167") ; Click Away for Close Page
	Local $iCounter = 0
	While Not (IsMainPage())
		If _Sleep(50) Then Return False
		$iCounter += 1
		If $iCounter > 100 Then ExitLoop
	WEnd
	If $iCounter > 100 Then
		SetLog("Cannot Exit Single Player Page", $COLOR_RED)
		Return False
	Else
		If $g_bDebugSX Then SetDebugLog("Super XP : ExitSPPage Finished", $COLOR_DEBUG)
		Return True
	EndIf
EndFunc   ;==>ExitSPPage

Func AttackFinishedSX()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin AttackFinishedSX", $COLOR_DEBUG)

	$g_iCurrentXP = GetCurXP("Current")
	If $g_iGoblinMapOptSX = 1 Then
		$g_iGainedXP += 5
	ElseIf $g_iGoblinMapOptSX = 2 Then
		$g_iGainedXP += 11
	EndIf
	SetSuperXP()
	$g_bActivatedHeroes[0] = False
	$g_bActivatedHeroes[1] = False
	$g_bActivatedHeroes[2] = False

	If $g_bDebugSX Then SetDebugLog("Super XP : AttackFinishedSX Finished", $COLOR_DEBUG)
EndFunc   ;==>AttackFinishedSX

Func GetCurXP($returnVal = "Current")
	If $g_bFastSuperXP Then Return
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin GetCurXP", $COLOR_DEBUG)

	Local $ToReturn = "0#0"
	Click(135, 30, 1)
	If _Sleep(2000) Then Return

	Local $OCRResultXP = getCurrentXP(80, 60)
	If $g_bDebugSX Then SetDebugLog("Super XP : GetCurXP $OCRResultXP: " & $OCRResultXP, $COLOR_DEBUG)
	Click(855, 10, 1) ; Click To Close XP Stats

	If $returnVal = "" Then
		$ToReturn = $OCRResultXP
	ElseIf StringInStr($returnVal, "Cur") And StringInStr($OCRResultXP, "#") Then
		$ToReturn = StringSplit($OCRResultXP, "#", 2)[0]
	ElseIf StringInStr($returnVal, "Tot") And StringInStr($OCRResultXP, "#") Then
		$ToReturn = StringSplit($OCRResultXP, "#", 2)[1]
	Else
		$ToReturn = $OCRResultXP
	EndIf

	If $g_bDebugSX Then SetDebugLog("Super XP : GetCurXP Finished", $COLOR_DEBUG)
	Return $ToReturn
EndFunc   ;==>GetCurXP

Func WaitToFinishSX()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin WaitToFinishSX", $COLOR_DEBUG)

	Local $BdTimer = TimerInit()
	While 1
		If CheckEarnedStars($g_iMinStarsToEnd) = True Then ExitLoop
		If _Sleep(70) Then ExitLoop
		If Not $g_bRunState Then ExitLoop
		If IsInAttackSX() = False Then ExitLoop
		ActivateHeroesByDelay($BdTimer)
		If TimerDiff($BdTimer) >= 120000 Then ; If Battle Started 2 Minutes ago, Then Return
			If $g_bDebugSX Then SetDebugLog("Super XP : WaitToFinishSuper XP :  TimeOut", $COLOR_ERROR)
			SafeReturnSX()
			ExitLoop
		EndIf
	WEnd
	If $g_bDebugSX Then SetDebugLog("Super XP : WaitToFinishSX Finished", $COLOR_DEBUG)
	Return True
EndFunc   ;==>WaitToFinishSX

Func ActivateHeroesByDelay($hBdTimer)

	Local $QueenDelay = $g_iGoblinMapOptSX = 1 ? $g_aiBdGoblinPicnic[0] : $g_aiBdTheArena[0]
	If StringInStr($QueenDelay, "-") > 0 Then $QueenDelay = Random(Number(StringSplit($QueenDelay, "-", 2)[0]), Number(StringSplit($QueenDelay, "-", 2)[1]), 1)

	Local $WardenDelay = $g_iGoblinMapOptSX = 1 ? $g_aiBdGoblinPicnic[1] : $g_aiBdTheArena[1]
	If StringInStr($WardenDelay, "-") > 0 Then $WardenDelay = Random(Number(StringSplit($WardenDelay, "-", 2)[0]), Number(StringSplit($WardenDelay, "-", 2)[1]), 1)

	Local $KingDelay = $g_aiBdGoblinPicnic[2]
	If StringInStr($KingDelay, "-") > 0 Then $KingDelay = Random(Number(StringSplit($KingDelay, "-", 2)[0]), Number(StringSplit($KingDelay, "-", 2)[1]), 1)

	Local $tDiff = TimerDiff($hBdTimer)
	If $tDiff >= $QueenDelay And $QueenDelay <> 0 And Not $g_bActivatedHeroes[0] And $g_iQueenSlot <> -1 And $g_bAQueenSX <> $eHeroNone Then
		If $g_bDebugSX Then SetDebugLog("Super XP : Activating Queen Ability After " & Round($tDiff, 3) & "/" & $QueenDelay & " ms(s)")
		SelectDropTroop($g_iQueenSlot)
		$g_bActivatedHeroes[0] = True
	EndIf
	If $tDiff >= $WardenDelay And $WardenDelay <> 0 And Not $g_bActivatedHeroes[1] And $g_iWardenSlot <> -1 And $g_bGWardenSX <> $eHeroNone Then
		If $g_bDebugSX Then SetDebugLog("Super XP : Activating Warden Ability After " & Round($tDiff, 3) & "/" & $WardenDelay & " ms(s)")
		SelectDropTroop($g_iWardenSlot)
		$g_bActivatedHeroes[1] = True
	EndIf
	If $tDiff >= $KingDelay And $KingDelay <> 0 And Not $g_bActivatedHeroes[2] And $g_iKingSlot <> -1 And $g_bBKingSX <> $eHeroNone Then
		If $g_bDebugSX Then SetDebugLog("Super XP : Activating King Ability After " & Round($tDiff, 3) & "/" & $KingDelay & " ms(s)")
		SelectDropTroop($g_iKingSlot)
		$g_bActivatedHeroes[2] = True
	EndIf
EndFunc   ;==>ActivateHeroesByDelay

Func IsInAttackSX()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin IsInAttackSX", $COLOR_DEBUG)
	If _ColorCheck(_GetPixelColor($aIsInAttack[0], $aIsInAttack[1], True, "IsInAttackSX"), Hex($aIsInAttack[2], 6), $aIsInAttack[3]) Then Return True
	If $g_bDebugSX Then SetDebugLog("Super XP : IsInAttackSX = FALSE", $COLOR_DEBUG)
	Return False
EndFunc   ;==>IsInAttackSX

Func IsInSPPage()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin IsInSPPage", $COLOR_DEBUG)
	Local $rColCheck = _ColorCheck(_GetPixelColor($aIsLaunchSinglePage[0], $aIsLaunchSinglePage[1], True, "IsInSPPage"), Hex($aIsLaunchSinglePage[2], 6), $aIsLaunchSinglePage[3])
	If $g_bDebugSX Then SetDebugLog("Super XP : IsInSPPage = " & $rColCheck, $COLOR_DEBUG)
	Return $rColCheck
EndFunc   ;==>IsInSPPage

Func AttackSX()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin AttackSX", $COLOR_DEBUG)

	If WaitForNoClouds() = False Then
		If $g_bDebugSX Then SetDebugLog("Super XP : AttackSuper XP : Wait For Clouds = False", $COLOR_DEBUG)
		$g_bIsClientSyncError = False
		Return False
	EndIf
	PrepareAttackSX()
	If CheckAvailableHeroes() = False Then
		SetLog("No heroes available to attack with " & $g_sGoblinMapOptSX, $COLOR_ACTION)
		ReturnHomeSX()
		Return False
	EndIf

	DropAQueenSX($g_iGoblinMapOptSX = 1 ? $g_aiBdGoblinPicnic[0] = 0 : $g_aiBdTheArena[0] = 0)
	If CheckEarnedStars($g_iMinStarsToEnd) = True Then Return True
	DropGWardenSX($g_iGoblinMapOptSX = 1 ? $g_aiBdGoblinPicnic[1] = 0 : $g_aiBdTheArena[1] = 0)
	If CheckEarnedStars($g_iMinStarsToEnd) = True Then Return True
	DropBKingSX($g_aiBdGoblinPicnic[2] = 0)

	If $g_bDebugSX Then SetDebugLog("Super XP : AttackSX Finished", $COLOR_DEBUG)
	Return True
EndFunc   ;==>AttackSX

Func CheckAvailableHeroes()
	$bCanGainXP = ((IIf($g_bBKingSX = $eHeroNone, False, $g_iKingSlot <> -1) Or _
					IIf($g_bAQueenSX = $eHeroNone, False, $g_iQueenSlot <> -1) Or _
					IIf($g_bGWardenSX = $eHeroNone, False, $g_iWardenSlot <> -1)) And _
					IIf($g_iActivateOptionSX = 1, $g_bIsFullArmywithHeroesAndSpells = False, True))
	If $g_bDebugSX Then SetDebugLog("Super XP : CheckAvailableHeroes = " & $bCanGainXP)
	Return $bCanGainXP
EndFunc   ;==>CheckAvailableHeroes

Func DropAQueenSX($bActivateASAP = True)
	If $g_iQueenSlot <> -1 And $g_bAQueenSX <> $eHeroNone Then
		SetLog("Deploying Archer Queen!", $COLOR_INFO)
		SelectDropTroop($g_iQueenSlot)
		If _Sleep($DELAYDROPSuperXP1) Then Return False
		If CheckEarnedStars($g_iMinStarsToEnd) = True Then Return True
		ClickP(GetDropPointSX(1), 1, 0, "#0000") ;Drop Queen
		If _Sleep($DELAYDROPSuperXP3) Then Return False
		If $bActivateASAP = True Then
			If IsAttackPage() Then
				SelectDropTroop($g_iQueenSlot) ;If Queen was not activated: Boost Queen
				$g_bActivatedHeroes[0] = True
			EndIf
		EndIf
		If _Sleep($DELAYDROPSuperXP3) Then Return False
	EndIf
EndFunc   ;==>DropAQueenSX

Func DropGWardenSX($bActivateASAP = True)
	If $g_iWardenSlot <> -1 And $g_bGWardenSX <> $eHeroNone Then
		SetLog("Deploying Grand Warden!", $COLOR_INFO)
		SelectDropTroop($g_iWardenSlot)
		If _Sleep($DELAYDROPSuperXP1) Then Return False
		If CheckEarnedStars($g_iMinStarsToEnd) = True Then Return True
		ClickP(GetDropPointSX(2), 1, 0, "#0180") ;Drop Warden
		If _Sleep($DELAYDROPSuperXP3) Then Return False
		If $bActivateASAP = True Then
			If IsAttackPage() Then
				SelectDropTroop($g_iWardenSlot) ;If Warden was not activated: Boost Warden
				$g_bActivatedHeroes[1] = True
			EndIf
		EndIf
		If _Sleep($DELAYDROPSuperXP3) Then Return False
	EndIf
EndFunc   ;==>DropGWardenSX

Func DropBKingSX($bActivateASAP = True)
	If $g_iKingSlot <> -1 And $g_bBKingSX <> $eHeroNone Then
		SetLog("Deploying Barbarian King!", $COLOR_INFO)
		SelectDropTroop($g_iKingSlot)
		If _Sleep($DELAYDROPSuperXP1) Then Return False
		If CheckEarnedStars($g_iMinStarsToEnd) = True Then Return True
		ClickP(GetDropPointSX(3), 1, 0, "#0178") ;Drop King
		If _Sleep($DELAYDROPSuperXP3) Then Return False
		If $bActivateASAP = True Then
			If IsAttackPage() Then
				SelectDropTroop($g_iKingSlot) ;If King was not activated: Boost King
				$g_bActivatedHeroes[2] = True
			EndIf
		EndIf
		If _Sleep($DELAYDROPSuperXP3) Then Return False
	EndIf
EndFunc   ;==>DropBKingSX

Func GetDropPointSX($iHero)
	; Local variables
	Local $ToReturn[2] = [-1, -1]
	Local $Hero = $iHero - 1
	Local $aiDpGoblinMapSX[4] = [0, 0, 0, 0]

	; Just in case
	If $iHero = 0 Or $iHero > 3 Then $Hero = 0

	; Populatre with correct Globals
	If $g_iGoblinMapOptSX = 1 Then
		$aiDpGoblinMapSX[0] = $g_aiDpGoblinPicnic[$Hero][0]
		$aiDpGoblinMapSX[1] = $g_aiDpGoblinPicnic[$Hero][1]
		$aiDpGoblinMapSX[2] = $g_aiDpGoblinPicnic[$Hero][2]
		$aiDpGoblinMapSX[3] = $g_aiDpGoblinPicnic[$Hero][3]
	ElseIf $g_iGoblinMapOptSX = 2 And $iHero < 3 Then
		$aiDpGoblinMapSX[0] = $g_aiDpTheArena[$Hero][0]
		$aiDpGoblinMapSX[1] = $g_aiDpTheArena[$Hero][1]
		$aiDpGoblinMapSX[2] = $g_aiDpTheArena[$Hero][2]
		$aiDpGoblinMapSX[3] = $g_aiDpTheArena[$Hero][3]
	EndIf

	;random
	$ToReturn[0] = Random($aiDpGoblinMapSX[0] - $aiDpGoblinMapSX[2], $aiDpGoblinMapSX[0] + $aiDpGoblinMapSX[2], 1)
	$ToReturn[1] = Random($aiDpGoblinMapSX[1] - $aiDpGoblinMapSX[3], $aiDpGoblinMapSX[1] + $aiDpGoblinMapSX[3], 1)
	Return $ToReturn
EndFunc   ;==>GetDropPointSX

Func PrepareAttackSX($pMatchMode = $DT, $bRemaining = False)
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin PrepareAttackSX", $COLOR_DEBUG)

	$g_iTotalAttackSlot = 10 ; reset flag - Slot11+
	$g_bDraggedAttackBar = False
	Local $iTroopNumber = 0
	Local $avAttackBar = GetAttackBar($bRemaining, $pMatchMode)
	For $i = 0 To UBound($g_avAttackTroops, 1) - 1
		Local $bClearSlot = True ; by default clear the slot, if no corresponding slot is found in attackbar detection
		If UBound($avAttackBar, 1) > 0 Then
			For $j = 0 To UBound($avAttackBar, 1) - 1
				If $avAttackBar[$j][1] = $i Then
					; troop slot found
					If IsUnitUsed($pMatchMode, $avAttackBar[$j][0]) Then
						$bClearSlot = False
						; populate the i-th slot
						$g_avAttackTroops[$i][0] = Number($avAttackBar[$j][0]) ; Troop Index
						$g_avAttackTroops[$i][1] = Number($avAttackBar[$j][2]) ; Amount
						$g_avAttackTroops[$i][2] = Number($avAttackBar[$j][3]) ; X-Coord
						$g_avAttackTroops[$i][3] = Number($avAttackBar[$j][4]) ; Y-Coord
						$g_avAttackTroops[$i][4] = Number($avAttackBar[$j][5]) ; OCR X-Coord
						$g_avAttackTroops[$i][5] = Number($avAttackBar[$j][6]) ; OCR Y-Coord
						$iTroopNumber += $avAttackBar[$j][2]

						Local $sDebugText = $g_bDebugSetlog ? " (X:" & $avAttackBar[$j][3] & "|Y:" & $avAttackBar[$j][4] & "|OCR-X:" & $avAttackBar[$j][5] & "|OCR-Y:" & $avAttackBar[$j][6] & ")" : ""
						SetLog($avAttackBar[$j][1] & ": " & $avAttackBar[$j][2] & " " & GetTroopName($avAttackBar[$j][0], $avAttackBar[$j][2]) & $sDebugText, $COLOR_SUCCESS)
					Else
						SetDebugLog("Discard use of " & GetTroopName($avAttackBar[$j][0]) & " (" & $avAttackBar[$j][0] & ")", $COLOR_ERROR)
					EndIf
					ExitLoop
				EndIf
			Next
		EndIf

		If $bClearSlot Then
			; slot not identified
			$g_avAttackTroops[$i][0] = -1
			$g_avAttackTroops[$i][1] = 0
			$g_avAttackTroops[$i][2] = 0
			$g_avAttackTroops[$i][3] = 0
			$g_avAttackTroops[$i][4] = 0
			$g_avAttackTroops[$i][5] = 0
		EndIf
	Next
	SetSlotSpecialTroops()
	If $g_bDebugSX Then SetDebugLog("Super XP : PrepareAttackSX Finished", $COLOR_DEBUG)
	Return $iTroopNumber
EndFunc   ;==>PrepareAttackSX

Func CheckEarnedStars($ExitWhileHave = 0) ; If the parameter is 0, will not exit from attack lol
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin CheckEarnedStars", $COLOR_DEBUG)

	Local $StarsEarned = 0
	If $ExitWhileHave = 1 Then
		; IT CAN BE DETECTED By WRONG... But just made this to prevent heroes getting attacked
		; Please Simply Comment This If Condition If you Saw Problems And Bot Returned to Home Without Getting At Least One Star
		If _ColorCheck(_GetPixelColor($aEarnedStar[0], $aEarnedStar[1], True, "CheckEarnedStars-1Star#1"), Hex($aEarnedStar[2], 6), $aEarnedStar[3]) Then
			SetLog("1 Star earned", $COLOR_SUCCESS)
			If ReturnHomeSX() = False Then CloseCoC(True) ; If Something Was Wrong with Returning Home, Close CoC And Open Again
			Return True
		EndIf
	EndIf

	If _ColorCheck(_GetPixelColor($aOneStar[0], $aOneStar[1], True, "CheckEarnedStars-1Star#2"), Hex($aOneStar[2], 6), $aOneStar[3]) Then $StarsEarned += 1

	If $ExitWhileHave <> 0 And $StarsEarned >= $ExitWhileHave Then
		SetLog($StarsEarned & " Star earned", $COLOR_SUCCESS)
		If ReturnHomeSX() = False Then CloseCoC(True) ; If Something Was Wrong with Returning Home, Close CoC And Open Again
		Return True
	EndIf

	If $ExitWhileHave >= 2 Then
		If _ColorCheck(_GetPixelColor($aTwoStar[0], $aTwoStar[1], True, "CheckEarnedStars-2Star"), Hex($aTwoStar[2], 6), $aTwoStar[3]) Then $StarsEarned += 1

		If $ExitWhileHave <> 0 And $StarsEarned >= $ExitWhileHave Then
			SetLog($StarsEarned & " Stars earned", $COLOR_SUCCESS)
			If ReturnHomeSX() = False Then CloseCoC(True) ; If Something Was Wrong with Returning Home, Close CoC And Open Again
			Return True
		EndIf

		If $ExitWhileHave >= 3 Then
			If _ColorCheck(_GetPixelColor($aThreeStar[0], $aThreeStar[1], True, "CheckEarnedStars-3Star"), Hex($aThreeStar[2], 6), $aThreeStar[3]) Then $StarsEarned += 1

			If $ExitWhileHave <> 0 And $StarsEarned >= $ExitWhileHave Then
				SetLog($StarsEarned & " Stars earned", $COLOR_SUCCESS)
				If ReturnHomeSX() = False Then CloseCoC(True) ; If Something Was Wrong with Returning Home, Close CoC And Open Again
				Return True
			EndIf
		EndIf
	EndIf

	If $g_bDebugSX Then SetDebugLog("Super XP : CheckEarnedStars Finished", $COLOR_DEBUG)
	Return False
EndFunc   ;==>CheckEarnedStars

Func ReturnHomeSX()
	Local Const $DELAYEachCheck = 70, $iRetryLimits = 429 ; Wait for each Color About 30 Seconds If didn't found!

	Local $iCounter = 0
	$g_iKingSlot = -1
	$g_iQueenSlot = -1
	$g_iWardenSlot = -1
	SetLog("Returning Home - SuperXP", $COLOR_INFO)

	; 1st Step
	While Not _ColorCheck(_GetPixelColor($EndBattleText1[0], $EndBattleText1[1], True, "ReturnHomeSX-Text1"), Hex($EndBattleText1[2], 6), $EndBattleText1[3]) ; First EndBattle Button
		If $g_bDebugSX Then SetDebugLog("Super XP : ReturnHomeSuper XP : 1-Loop #" & $iCounter, $COLOR_DEBUG)
		If _Sleep($DELAYEachCheck) Then Return False
		$iCounter += 1
		If $iCounter >= $iRetryLimits Then
			If $g_bDebugSX Then SetDebugLog("Super XP : ReturnHomeSuper XP : 1-EndBattle Button not found", $COLOR_DEBUG)
			Return False
		EndIf
	WEnd
	Click(Random($EndBattleText1[0] + 35, $EndBattleText1[0] + 45, 1), Random($EndBattleText1[1] - 5, $EndBattleText1[1] + 5, 1)) ; Click First EndBattle Button
	If _Sleep($DELAYEachCheck) Then Return False

	; 2nd Step
	$iCounter = 0 ; Reset Counter
	While Not _ColorCheck(_GetPixelColor($EndBattleText2[0], $EndBattleText2[1], True, "ReturnHomeSX-Text2"), Hex($EndBattleText2[2], 6), $EndBattleText2[3]) ; Second EndBattle Button
		If $g_bDebugSX Then SetDebugLog("Super XP : ReturnHomeSuper XP : 2-Loop #" & $iCounter, $COLOR_DEBUG)
		If _Sleep($DELAYEachCheck) Then Return False
		$iCounter += 1
		If $iCounter >= $iRetryLimits Then
			If $g_bDebugSX Then SetDebugLog("Super XP : ReturnHomeSuper XP : 2-EndBattle Button not found", $COLOR_DEBUG)
			Return False
		EndIf
	WEnd

	Click(Random(455, 565, 1), Random(412, 447, 1)) ; Click 2nd EndBattle Button, (Verify)
	If _Sleep($DELAYEachCheck) Then Return False

	; 3rd Step
	$iCounter = 0 ; Reset Counter
	While Not _ColorCheck(_GetPixelColor($ReturnHomeText[0], $ReturnHomeText[1], True, "ReturnHomeSX-Text3"), Hex($ReturnHomeText[2], 6), $ReturnHomeText[3]) ; Last - Return Home Button
		If $g_bDebugSX Then SetDebugLog("Super XP : ReturnHomeSuper XP : 3-Loop #" & $iCounter, $COLOR_DEBUG)
		If _Sleep($DELAYEachCheck) Then Return False
		$iCounter += 1
		If $iCounter >= $iRetryLimits Then
			If $g_bDebugSX Then SetDebugLog("Super XP : ReturnHomeSuper XP : 3-Return Home Button not found", $COLOR_DEBUG)
			Return False
		EndIf
	WEnd

	Click(Random($ReturnHomeText[0] + 45, $ReturnHomeText[0] + 55, 1), Random($ReturnHomeText[1] - 5, $ReturnHomeText[1] + 5, 1)) ; Click on Return Home Button
	If _Sleep($DELAYReturnHome2) Then Return ; short wait for screen to Exit

	; Last Step, Check for Main Screen
	$iCounter = 0 ; Reset Counter
	While 1
		If $g_bDebugSX Then SetDebugLog("Super XP : ReturnHomeSuper XP : 4-Loop #" & $iCounter, $COLOR_DEBUG)
		If _Sleep($DELAYReturnHome4) Then Return
		If IsMainPage(1) Then
			_GUICtrlEdit_SetText($g_hTxtLog, _PadStringCenter(" BOT LOG ", 71, "="))
			_GUICtrlRichEdit_SetFont($g_hTxtLog, 6, "Lucida Console")
			_GUICtrlRichEdit_AppendTextColor($g_hTxtLog, "" & @CRLF, _ColorConvert($COLOR_BLACK))
			Return True
		EndIf
		$iCounter += 1
		If $iCounter >= 50 Or isProblemAffect(True) Then
			SetLog("Cannot return home.", $COLOR_ERROR)
			checkMainScreen(True)
			Return True
		EndIf
	WEnd
EndFunc   ;==>ReturnHomeSX

Func WaitForNoClouds()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin WaitForNoClouds", $COLOR_DEBUG)

	Local $i = 0
	ForceCaptureRegion()
	While Not _ColorCheck(_GetPixelColor($aIsInAttack[0], $aIsInAttack[1], True, "WaitForNoClouds"), Hex($aIsInAttack[2], 6), $aIsInAttack[3])
		If _Sleep($DELAYGetResources1) Then Return False
		$i += 1
		If $i >= 120 Or isProblemAffect(True) Then ; Wait 30 seconds then restart bot and CoC
			$g_bIsClientSyncError = True
			checkMainScreen()
			If $g_bRestart Then
				$g_iNbrOfOoS += 1
				UpdateStats()
				SetLog("Disconnected At Search Clouds - SuperXP", $COLOR_ERROR)
				PushMsg("OoSResources")
			Else
				SetLog("Stuck At Search Clouds, Restarting CoC and Bot... - SuperXP", $COLOR_ERROR)
				$g_bIsClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
				CloseCoC(True)
			EndIf
			Return False
		EndIf
		If $g_bDebugSX Then SetDebugLog("Super XP : WaitForNoClouds|Loop #" & $i)
		ForceCaptureRegion() ; ensure screenshots are not cached
	WEnd
	If $g_bDebugSX Then SetDebugLog("Super XP : WaitFornoClouds Finished", $COLOR_DEBUG)
	Return True
EndFunc   ;==>WaitForNoClouds

Func OpenGoblinMapSX()
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin OpenGoblinMapSX", $COLOR_DEBUG)

	Local $rOpenSinglePlayerPage = OpenSinglePlayerPage()
	If $rOpenSinglePlayerPage = False Then
		SetLog("Failed to open Attack page, Single Player", $COLOR_ERROR)
		SafeReturnSX()
		Return False
	EndIf

	If RandomSleep(500) Then Return

	Click(Random(278, 592, 1), Random(58, 120, 1), 1, 0) ; Clicks Away Random

	If $g_bDebugSX Then SetDebugLog("Super XP : Smart Drag.", $COLOR_DEBUG)
	Local $iCounter = 0
	Local $aMapPick = -1

	Local $bFastScroll = False
	Local $iTimesD = $g_iStatsSuperXP
	Do
		If $iCounter = 0 Then
			For $i = 0 To 1
				If RandomSleep(250) Then Return
				$aMapPick = FixPosMapSX()
				If IsArray($aMapPick) Then ExitLoop 2
			Next
		EndIf

		$iCounter += 1
		If Not $g_bRunState Then ExitLoop
		If $g_bDebugSX Then SetDebugLog("Super XP : OpenGoblinMapSuper XP : Loop #" & $iCounter)

		$iTimesD -= 1
		If ($iTimesD > 0) Then
			$iTimesD -= 1
			$bFastScroll = True
		Else
			$bFastScroll = False
		EndIf

		Local $iRandom = Random(0, 3, 1)
		If $bFastScroll = True Then
			ClickDrag(Random(305, 310, 1), 138 + $g_iMidOffsetYFixed - $iRandom, Random(305, 310, 1), 658 + $g_iBottomOffsetYFixed + $iRandom, 25, True) ; Resolution changed
		Else
			ClickDrag(Random(305, 310, 1), 138 + $g_iMidOffsetYFixed - $iRandom, Random(305, 310, 1), 398 + $g_iMidOffsetYFixed + $iRandom, 50, True) ; Resolution changed
		EndIf

		SetDebugLog("FastScroll= " & $bFastScroll & " / Button OpenGoblinMapSX= " & _GetPixelColor($aFirstMapPosition[0], $aFirstMapPosition[1], True), $COLOR_DEBUG) ;Debug

		For $i = 0 To 1
			If RandomSleep(250) Then Return
			$aMapPick = FixPosMapSX()
			If IsArray($aMapPick) Then
				If $g_iStatsSuperXP = 0 Then $g_iStatsSuperXP = $iCounter
				ExitLoop 2
			EndIf
			If $bFastScroll Then ExitLoop
		Next

	Until $iCounter > 25 Or _ColorCheck(_GetPixelColor($aFirstMapPosition[0], $aFirstMapPosition[1], True, "OpenGoblinMapSX-Check"), Hex($aFirstMapPosition[2], 6), $aFirstMapPosition[3])

	If RandomSleep(500) Then Return

	If Not IsArray($aMapPick) Then
		PureClickP($aCloseSingleTab, 1, 0, "#CloseSingleTab") ;Clicks X
		If $g_bDebugSX Then SetDebugLog("Super XP : OpenGoblinMapSuper XP : Return False", $COLOR_DEBUG)
		Return False
	Else
		If $aMapPick[UBound($aMapPick) -1][2] > 420 Then
			ClickDrag(Random(305, 310, 1), 304 + $g_iMidOffsetYFixed, Random(305, 310, 1), 138 + $g_iMidOffsetYFixed, 100, True) ; Resolution changed
			For $i = 0 To 1
				If RandomSleep(500) Then Return
				$aMapPick = FixPosMapSX()
				If IsArray($aMapPick) Then ExitLoop
			Next
		EndIf

		If Not IsArray($aMapPick) Then
			PureClickP($aCloseSingleTab, 1, 0, "#CloseSingleTab") ;Clicks X
			If $g_bDebugSX Then SetDebugLog("Super XP : OpenGoblinMapSuper XP : Return False", $COLOR_DEBUG)
			Return False
		EndIf

		PureClick($aMapPick[0][1], $aMapPick[0][2], 1, 0)
		If RandomSleep(250) Then Return

		Local $aPort[2] = [$aMapPick[UBound($aMapPick) -1][1], $aMapPick[UBound($aMapPick) -1][2]]
		If $g_iGoblinMapOptSX = 1 Then
			If (StringInStr($aMapPick[0][0], "Arena") > 0) Then ; FixPosMapSX check IsGoblinMapSXLocked, and here not is necessary.
				SetLog("Switching to The Arena, for win more XP now.", $COLOR_INFO)
				$g_iGoblinMapOptSX = 2
				$g_sGoblinMapOptSX = "The Arena"
				radGoblinMapOptSX()
			ElseIf IsGoblinMapSXLocked($aPort) = True Then
				SetLog("Are you kidding me? " & $g_sGoblinMapOptSX & " is Locked", $COLOR_ERROR)
				DisableSX()
				SafeReturnSX()
				Return False
			EndIf
		EndIf

		If $g_bDebugSX Then SetDebugLog("Super XP : OpenGoblinMapSuper XP : Clicking On Attack Btn: " & $aMapPick[0][1] & ", " & $aMapPick[0][2])
		Click($aMapPick[UBound($aMapPick) -1][1] + Random(20,30,1), $aMapPick[UBound($aMapPick) -1][2] + Random(125,135,1)) ; Click On Attack Button

		$iCounter = 0
		While IsInSPPage()
			If _Sleep(50) Then Return
			$iCounter += 1
			; RETRY
			If $iCounter > 100 Then
				Click(Random(278, 592, 1), Random(58, 120, 1), 1, 0) ; Clicks Away Random

				For $i = 0 To 1
					If RandomSleep(500) Then Return
					$aMapPick = FixPosMapSX()
					If IsArray($aMapPick) Then ExitLoop
				Next

				If Not IsArray($aMapPick) Then
					PureClickP($aCloseSingleTab, 1, 0, "#CloseSingleTab") ;Clicks X
					If $g_bDebugSX Then SetDebugLog("Super XP : OpenGoblinMapSuper XP : Return False", $COLOR_DEBUG)
					Return False
				EndIf

				PureClick($aMapPick[0][1], $aMapPick[0][2], 1, 0)
				If RandomSleep(250) Then Return

				Local $aPort[2] = [$aMapPick[UBound($aMapPick) -1][1], $aMapPick[UBound($aMapPick) -1][2]]
				If $g_iGoblinMapOptSX = 1 Then
					If (StringInStr($aMapPick[0][0], "Arena") > 0) Then ; FixPosMapSX check IsGoblinMapSXLocked, and here not is necessary.
						SetLog("Switching to The Arena, for win more XP now.", $COLOR_INFO)
						$g_iGoblinMapOptSX = 2
						$g_sGoblinMapOptSX = "The Arena"
						radGoblinMapOptSX()
					ElseIf IsGoblinMapSXLocked($aPort) = True Then
						SetLog("Are you kidding me? " & $g_sGoblinMapOptSX & " is Locked", $COLOR_ERROR)
						DisableSX()
						SafeReturnSX()
						Return False
					EndIf
				EndIf

				If $g_bDebugSX Then SetDebugLog("Super XP : OpenGoblinMapSuper XP : Clicking On Attack Btn: " & $aMapPick[0][1] & ", " & $aMapPick[0][2])
				Click($aMapPick[UBound($aMapPick) -1][1] + Random(20,30,1), $aMapPick[UBound($aMapPick) -1][2] + Random(125,135,1)) ; Click On Attack Button

				ExitLoop
			EndIf
			If $iCounter > 150 Then
				SetLog("Still in SinglePlayer Page!! Something Strange Happened", $COLOR_ERROR)
				; $bCanGainXP = False
				; Return False
				PureClickP($aCloseSingleTab, 1, 0, "#CloseSingleTab") ;Clicks X
				Return True
			EndIf
		WEnd

		Local $rIsGoblinMapSX = IsInGoblinMapSX() ; Wait/Check if is In The 'Goblin Picnic/The Arena' Base
		If $rIsGoblinMapSX = False Then
			SetLog("Looks like we're not in " & $g_sGoblinMapOptSX, $COLOR_ERROR)
			If _CheckPixel($aCloseSingleTab, $g_bNoCapturePixel) Then
				SetDebugLog("#cOb# Clicks X, $aCloseSingleTab", $COLOR_INFO)
				PureClickP($aCloseSingleTab, 1, 0, "#CloseSingleTab") ;Clicks X
				If _Sleep($DELAYcheckObstacles1) Then Return False
				SafeReturnSX()
				Return False
			EndIf
			SafeReturnSX()
			Return False
		EndIf
		SetLog("Now we're in " & $g_sGoblinMapOptSX & " Base", $COLOR_SUCCESS)

		If $g_bDebugSX Then SetDebugLog("Super XP : OpenGoblinMapSuper XP : Return True", $COLOR_DEBUG)
		Return True
	EndIf

	Return False
EndFunc   ;==>OpenGoblinMapSX

Func FixPosMapSX()
	Local $aMapPickR[1][4]
	Local $aMapPick = findMultipleQuick(@ScriptDir & "\COCBot\Team__AiO__MOD++\Images\SuperXP\Find", 0, "282, 94, 833, 583", True) ; Resolution changed

	Local $bKing = IIf($g_bBKingSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroKing) = $eHeroKing)
	Local $bQueen = IIf($g_bAQueenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroQueen) = $eHeroQueen)
	Local $bWarden = IIf($g_bGWardenSX = $eHeroNone, False, BitAND($g_iHeroAvailable, $eHeroWarden) = $eHeroWarden)

	If UBound($aMapPick) < 1 and not @Error Then Return -1

	For $i = UBound($aMapPick) -1 To 0 Step -1

		Switch (StringInStr($aMapPick[$i][0], "Picnic") > 0)
			Case True
				; 436 Picnic
				If Abs(Pixel_Distance(436, 0, $aMapPick[$i][1], 0)) < 10 Then

					$aMapPickR[0][0] = $aMapPick[$i][0]
					$aMapPickR[0][1] = $aMapPick[$i][1]
					$aMapPickR[0][2] = $aMapPick[$i][2]
					$aMapPickR[0][3] = $aMapPick[$i][3]
					$g_iGoblinMapOptSX = 1
					$g_sGoblinMapOptSX = "Goblin Picnic"
					Return $aMapPickR
				EndIf
			Case Else

				; 619 Arena
				If Abs(Pixel_Distance(614, 0, $aMapPick[$i][1], 0)) < 10 Then

					If $bKing And Not ($bQueen Or $bWarden) Then
						SetLog("Are you kidding me? " & $g_sGoblinMapOptSX & " is OK, but you can't attack it with king on this map, jumping to Goblin Picnic.", $COLOR_ERROR)
						Return -1 ; Quick fix in no king active case.
					EndIf

					Local $aPort[2] = [$aMapPick[$i][1], $aMapPick[$i][2]]
					If IsGoblinMapSXLocked($aPort) = True Then
						SetLog("Are you kidding me? " & $g_sGoblinMapOptSX & " is Locked, jumping to Goblin Picnic.", $COLOR_ERROR)
						$g_iGoblinMapOptSX = 1
						$g_sGoblinMapOptSX = "Goblin Picnic"
						radGoblinMapOptSX()
						Return -1
					EndIf

					$aMapPickR[0][0] = $aMapPick[$i][0]
					$aMapPickR[0][1] = $aMapPick[$i][1]
					$aMapPickR[0][2] = $aMapPick[$i][2]
					$aMapPickR[0][3] = $aMapPick[$i][3]
					$g_iGoblinMapOptSX = 2
					$g_sGoblinMapOptSX = "The Arena"
					Return $aMapPickR
				EndIf
		EndSwitch
	Next

	Return -1
EndFunc   ;==>FixPosMapSX

Func IsGoblinMapSXLocked($aFoundCoord)
	If not IsArray($aFoundCoord) Then Return True

	Local $x = Int($aFoundCoord[0]) - 100, _
	$y = Int($aFoundCoord[1]) - 100, _
	$x1 = Int($aFoundCoord[0]) + 110, _
	$y1 = Int($aFoundCoord[1]) + 110

	Local $bResult = (IsArray(findMultipleQuick($g_sImgLockedSX, 1, $x & "," & $y & "," & $x1 & "," & $y1  )) = True)

	SetLog("Is Map Locked ?" & " " & $bResult & " / " & $x & "," & $y & "," & $x1 & "," & $y1, $COLOR_INFO)

	Return $bResult
EndFunc   ;==>IsGoblinMapSXLocked

Func IsInGoblinMapSX($Retry = True, $maxRetry = 30, $timeBetweenEachRet = 300)
	If $g_bDebugSX Then SetDebugLog("Super XP : Begin IsInGoblinMapSX", $COLOR_DEBUG)

	Local $bFound = False
	Local $iCounter = 0
	Do
		If _Sleep($timeBetweenEachRet) Then Return False
		$bFound = IsInAttackSX()

		$iCounter += 1
		If $iCounter = $maxRetry Then
			$bFound = False
			ExitLoop
		EndIf
	Until $bFound
	If $g_bDebugSX Then SetDebugLog("Super XP : IsInGoblinMapSX = " & $bFound, $COLOR_DEBUG)
	Return $bFound
EndFunc   ;==>IsInGoblinMapSX

Func OpenSinglePlayerPage()
	If $g_bDebugSX Then SetDebugLog("Super XP : OpenSinglePlayerPage", $COLOR_DEBUG)

	If Not WaitForMain(True, 50, 300) Then
		If $g_bDebugSX Then SetDebugLog("Super XP : MainPage Not Displayed to Open SingleP", $COLOR_DEBUG)
		Return False
	EndIf

	SetLog("Going to Gain XP...", $COLOR_INFO)
	If IsMainPage() Then
		ClickP($aAttackButton, 1, 0, "#0149") ; Click Attack Button
		If _Sleep(100) Then Return
		Else
		CheckMainScreen()
		If _Sleep(100) Then Return
		ClickP($aAttackButton, 1, 0, "#0149") ; Click Attack Button
		If _Sleep(100) Then Return
	EndIf
	If Not _Wait4PixelArray($aIsLaunchSinglePage) Then Return False
	Click(Random(50, 220, 1), Random(290, 440, 1))
	If _Sleep(50) Then Return
	Return True
EndFunc   ;==>OpenSinglePlayerPage

Func WaitForMain($clickAway = True, $DELAYEachCheck = 50, $maxRetry = 100)
	If Not IsMainPage(1) Then ClickAway() ; ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep($DELAYEachCheck) Then Return True

	; If Not IsMainPage() Then
		; Local $iCounter = 0
		; While Not (IsMainPage())
			; If _Sleep($DELAYEachCheck) Then Return True
			; If $clickAway Then ClickAway() ; ClickP($aAway, 2, 0, "#0346") ;Click Away
			; $iCounter += 1
			; If $iCounter > $maxRetry Then
				; Return False
			; EndIf
		; WEnd
	; EndIf

	Return True
EndFunc   ;==>WaitForMain

Func IsLaunchSinglePage()

	If IsPageLoop($aIsLaunchSinglePage, 1) Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Launch Single Player Window OK**", $COLOR_ACTION)
		Return True
	EndIf

	If $g_bDebugSetlog Or $g_bDebugClick Then
		Local $result = _GetPixelColor($aIsLaunchSinglePage[0], $aIsLaunchSinglePage[1], True)
		SetLog("**Launch Single Player Window FAIL**", $COLOR_ACTION)
		SetLog("expected in (" & $aIsLaunchSinglePage[0] & "," & $aIsLaunchSinglePage[1] & ")  = " & Hex($aIsLaunchSinglePage[2], 6) & " - Found " & $result, $COLOR_ACTION)
	EndIf

	If $g_bDebugImageSave Then SaveDebugImage("IsLaunchSinglePage")
	Return False

EndFunc   ;==>IsLaunchSinglePage

; #FUNCTION# ====================================================================================================================
; Name ..........: -
; Description ...: This file is all related to necessary Imgloc searchrs Or OCR
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Mr.Viper, Team AIO Mod++ (2019-2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getCurrentXP($x_start, $y_start) ; -> Get Current/Total XP, Used in SuperXP.au3
	Return getOcrAndCapture("coc-ms", $x_start, $y_start, 100, 15, True)
EndFunc   ;==>getCurrentXP

Func IIf($Condition, $IfTrue, $IfFalse)
	If $Condition = True Then
		Return $IfTrue
	Else
		Return $IfFalse
	EndIf
EndFunc