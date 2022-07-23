; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseMain.au3
; Description ...: Builder Base Main Loop
; Syntax ........: runBuilderBase()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018), Fahid.Mahmood (03-2018)
; Modified ......: Team AIO Mod++ (01-11-2021) 
;                  MyBot is distributed under the terms of the GNU GPL.
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func TestBuilderBase()
	SetDebugLog("** TestrunBuilderBase START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	$g_bStayOnBuilderBase = True
	BuilderBase(False)
	$g_bStayOnBuilderBase = False
	$g_bRunState = $Status
	SetDebugLog("** TestrunBuilderBase END**", $COLOR_DEBUG)
EndFunc   ;==>TestrunBuilderBase

Func BuilderBase($bTestRun = False, $bSkipBBCG = False)
	Local $bReturn = False
	
	#Region - Dates - Team AIO Mod++
	If Not $bTestRun And Not PlayBBOnly() And ByPassedForceBBAttackOnClanGames($g_bChkBBStopAt3, True, False) Then
		If _DateIsValid($g_sDateBuilderBase) Then
			Local $iDateDiff = _DateDiff('s', _NowCalc(), $g_sDateBuilderBase)
			If $iDateDiff > 0 And $g_sConstMaxBuilderBase > $iDateDiff Then
				SetLog("Builder Base: We will return when the bonus is available.", $COLOR_INFO)
				Return
			EndIf
		EndIf
	EndIf
	#EndRegion - Dates - Team AIO Mod++

	ClickAway("Right", False, 3)
	If Not ByPassedForceBBAttackOnClanGames($g_bChkBuilderAttack, True, True) And Not $g_bChkCollectBuilderBase And Not $g_bChkStartClockTowerBoost And Not $g_iChkBBSuggestedUpgrades And Not $g_bChkCleanBBYard And Not $g_bChkUpgradeMachine Then
		If $g_bOnlyBuilderBase Then
			SetLog("Play Only Builder Base Check Is On But BB Option's(Collect,Attack etc) Unchecked", $COLOR_ERROR)
			SetLog("Please Check BB Options From Builder Base Tab", $COLOR_INFO)
			If ProfileSwitchAccountEnabled(True) Then ; (:
				Return
			EndIf

			$g_bRunState = False
			btnStop()
		EndIf
		Return
	EndIf

	ZoomOut()

	$g_bRestart = False
	$g_bStayOnBuilderBase = True

	If $bSkipBBCG = False Then GoToClanGames()

	$bReturn = _BuilderBase($bTestRun)
	$g_bStayOnBuilderBase = False

	If isOnBuilderBase(True) Then CheckMainScreen(False, False)
	
	SetLog("Returned to the main village.", $COLOR_SUCCESS)
	
	Return $bReturn
EndFunc

Func _BuilderBase($bTestRun = False)
	$g_iAvailableAttacksBB = 0
	
	If Not $g_bRunState Then Return
	
	; Check if is in Builder Base.
	If Not isOnBuilderBase(True) Then
		If Not SwitchBetweenBases() Then
			Return False
		EndIf
	EndIf

	SetLog("Builder Base Idle Starts", $COLOR_INFO)

	If _Sleep(2000) Then Return

	ZoomOut()
	; If ZoomOut(True, False) = False Then
		; SetLog("Bad zoom builder base - BAD. (1)", $COLOR_ERROR)
		; $g_bStayOnBuilderBase = False
		; Return
	; Else
		; SetDebugLog("Zoom builder base - OK. (1)", $COLOR_SUCCESS)
	; EndIf


	If Not $g_bRunState Then Return

	If ($g_iCmbBoostBarracks = 0 Or $g_bFirstStart Or PlayBBOnly()) And $g_bChkOnlyFarm = False Then CollectBuilderBase()
	If Not $g_bRunState Then Return

	BuilderBaseReport()
	If Not $g_bRunState Then Return

	CleanBBYard()
	If Not $g_bRunState Then Return

	If ($g_iCmbBoostBarracks = 0 Or $g_bFirstStart Or PlayBBOnly()) And $g_bChkOnlyFarm = False Then
		StarLaboratory()
		If Not $g_bRunState Then Return

		ClickAway()
		If _Sleep(1500) Then Return
	EndIf

	Local $bBoostedClock = False

	; Loops to do logic.
	Local $iAttackLoops = 1
	Local $iLoopsToDoNormal = Random($g_iBBMinAttack, $g_iBBMaxAttack, 1)
	Local $iLoopsToDoCG = 25 + $iLoopsToDoNormal
	
	Local $iLoopsToDo = 0
	Local $iBigLoops = 0
	; $g_sTimerStatusBB = _DateAdd('n', Round(10 * Random(1.05, 1.25)), _NowCalc())
	Do
		$iBigLoops += 1

		NotifyPendingActions()
		If Not $g_bRunState Then Return
		
		ZoomOut()
		; If Not ZoomOut(False, False) Then
			; SetLog("Bad zoom builder base. (1)", $COLOR_ERROR)
			; $g_bStayOnBuilderBase = False
			; Return
		; EndIf

		If Not $g_bRunState Then Return

		If checkObstacles(True) Then
			SetLog("Window clean required, but no problem!", $COLOR_INFO)
		EndIf

		If Not $g_bRunState Then Return

		; Check if Builder Base is to run
		; New logic to add speed to the attack.
		Local $bCondition = True, $bOkAttack = True, $bFunctionPassed = True, $bLastLoop = True
		Do
			If Not $g_bRunState Then Return
			$bFunctionPassed = ByPassedForceBBAttackOnClanGames(False, True, True)
			$bCondition = (($g_bChkBuilderAttack And not $g_bChkBBStopAt3) Or ($g_bChkBuilderAttack And $g_bChkBBStopAt3 And $g_iAvailableAttacksBB > 0)) Or $bFunctionPassed

			If $bCondition = False Then
				Setlog("Dynamic attack loop skipped.", $COLOR_INFO)
				$iBigLoops = 3
				ExitLoop
			EndIf
			
			$iLoopsToDo = ($bCondition = True And $bFunctionPassed) ? ($iLoopsToDoCG) : ($iLoopsToDoNormal)

			Setlog("Dynamic attack loop: " & $iAttackLoops & " / " & $iLoopsToDo, $COLOR_INFO)
			$bLastLoop = ($iLoopsToDoCG == $iAttackLoops)
			
			;  $g_bCloudsActive fast network fix.
			$g_bCloudsActive = True

			; Attack
			$bOkAttack = BuilderBaseAttack($bTestRun)
			$iAttackLoops += 1
			$g_bCloudsActive = False
			
			If Not $bLastLoop And $g_bChkClanGamesEnabled And _DateIsValid($g_sTimerStatusBB) Then
				Local $iDateDiff = _DateDiff('n', _NowCalc(), $g_sTimerStatusBB)
				If $iDateDiff < 0 Then
					$g_sTimerStatusBB = _DateAdd('n', Round(10 * Random(1.05, 1.25)), _NowCalc())
					GoToClanGames()
				EndIf
			EndIf

			; Improved logic, as long as the bot can be farmed it will continue doing the external while, otherwise it will continue attacking to fulfill the user's request more fast.
			If checkObstacles(True) Then
				SetLog("Window clean required, but no problem!", $COLOR_INFO)
				ExitLoop
			EndIf
			
		Until ($iAttackLoops >= $iLoopsToDo) Or $iBigLoops = 3
		
		$bFunctionPassed = ByPassedForceBBAttackOnClanGames(False, True, True)
		$bCondition = (($g_bChkBuilderAttack And not $g_bChkBBStopAt3) Or ($g_bChkBuilderAttack And $g_bChkBBStopAt3 And $g_iAvailableAttacksBB > 0)) Or $bFunctionPassed

		If Not $g_bRunState Then Return

		WallsUpgradeBB()

		If checkObstacles(True) Then
			SetLog("Window clean required, but no problem!", $COLOR_INFO)
			ExitLoop
		EndIf

		If Not $g_bRunState Then Return

		If ($g_iCmbBoostBarracks = 0 Or $g_bFirstStart Or PlayBBOnly()) And $g_bChkOnlyFarm = False And $g_iAvailableAttacksBB = 0 Then
			MainSuggestedUpgradeCode()
		EndIf

		$bBoostedClock = StartClockTowerBoost() And Not $bCondition
		
		ZoomOut()
		; ZoomOut(False, False)
		CleanBBYard()
		If Not $g_bRunState Then Return

	Until ($iAttackLoops >= $iLoopsToDo) Or $iBigLoops > 2 Or $bBoostedClock

	If Not $g_bRunState Then Return
	BuilderBaseReport()

	If _Sleep($DELAYRUNBOT3) Then Return
	SetLog("Builder base idle ends", $COLOR_INFO)

	Return True
EndFunc   ;==>runBuilderBase

Func GoToClanGames()
	Local $bIsToByPass = False
	If ClanGamesStatus() = "True" Or ClanGamesStatus() = "Undefined" Then $bIsToByPass = True
	If Not $g_bChkClanGamesEnabled Or Not ClanGamesBB() Then Return
	If ($g_bIsSearchLimit Or $g_bRestart Or $g_bIsClientSyncError) Then Return
	SetLog("Checking clan games.", $COLOR_INFO)
	If $g_iAvailableAttacksBB > 0 Or Not ByPassedForceBBAttackOnClanGames($g_bChkBBStopAt3, False) Or $bIsToByPass Then
		If isOnBuilderBase(True) Then
			$g_bStayOnBuilderBase = False
			SwitchBetweenBases()
		EndIf
		ClanGames()
		If Not isOnBuilderBase(True) Then
			$g_bStayOnBuilderBase = True
			SwitchBetweenBases()
		EndIf
	EndIf
EndFunc   ;==>GoToClanGames

; Only attack in bb if CG active
Func SmartBuilderBase($bCheckevent = True)
	Local $bSmartBuilderBase = ($g_bChkOnlyBuilderBaseGC And ClanGamesStatus() == "True" And ClanGamesBB())
	If $bCheckevent And not $g_bIsBBevent Then $bSmartBuilderBase = False
	Return $bSmartBuilderBase
EndFunc   ;==>SmartBuilderBase

; Force attack bb in CG active
Func ForceBBAttackOnClanGames($bCheckevent = True)
	Local $bSmartBuilderBase = ($g_bChkForceBBAttackOnClanGames And ClanGamesStatus() == "True" And ClanGamesBB())
	If $bCheckevent And not $g_bIsBBevent Then $bSmartBuilderBase = False
	Return $bSmartBuilderBase
EndFunc   ;==>ForceBBAttackOnClanGames

Func PlayBBOnly()
	Local $b = ($g_iCommandStop = 8) ? (True) : (False)
	If $g_bOnlyBuilderBase = True Or SmartBuilderBase() = True Or $b = True Then Return True
	Return False
EndFunc   ;==>PlayBBOnly

Func ByPassedForceBBAttackOnClanGames($bByPassedContion = False, $bIfByPassReturn = True, $bCheckevent = False)
	If ForceBBAttackOnClanGames($bCheckevent) Then
		Return $bIfByPassReturn
	ElseIf SmartBuilderBase($bCheckevent) Then
		Return $bIfByPassReturn
	EndIf
	Return $bByPassedContion
EndFunc

Func ClanGamesBB()
	Return ($g_bChkClanGamesBBBattle Or $g_bChkClanGamesBBDes Or $g_bChkClanGamesBBTroops)
EndFunc   ;==>ClanGamesBB

Func BuilderBaseReportAttack($bSetLog = True)
    If $g_bRestart = True Then Return False

    If ByPassedForceBBAttackOnClanGames($g_bChkBuilderAttack, True) = True Then

        ; Get Trophies for drop.
        $g_aiCurrentLootBB[$eLootTrophyBB] = getTrophyMainScreen(67, 84)
        If $bSetLog = True Then Setlog("- Builder base trophies report: " & $g_aiCurrentLootBB[$eLootTrophyBB], $COLOR_INFO)

        $g_iAvailableAttacksBB = UBound(QuickMIS("CX", $g_sImgBBLootAvail, 20, 625 + $g_iBottomOffsetYFixed, 110, 650 + $g_iBottomOffsetYFixed, True)) ; Resolution changed

		If $bSetLog = True Then Setlog("- Builder base: You have " & $g_iAvailableAttacksBB & " available attack(s).", $COLOR_INFO)

		If $g_iAvailableAttacksBB > 0 Then
			Return True
        EndIf

    Else
		If $bSetLog = True Then SetLog("- Builder base: Attack disabled.", $COLOR_INFO)
	EndIf

	Return False

EndFunc   ;==>BuilderBaseReportAttack

Func IsBuilderBaseOCR($bSetLog = True)
	If WaitforPixel(510, 650 + $g_iBottomOffsetYFixed, 630, 700 + $g_iBottomOffsetYFixed, Hex(0xB3E25B, 6), 15, 3) = True Then ; Fixed resolution
		Local $sString = GetBldgUpgradeTime(404, 677 + $g_iBottomOffsetYFixed) ; Fixed resolution
		If StringLen($sString) > 2 Then
			SetLog("Next attack in  : " & $sString, $COLOR_INFO)
			$g_sDateBuilderBase = _DateAdd('n', Round(ConvertOCRLongTime("Builder Base Bonus", $sString) * Random(1.002, 1.005)), _NowCalc())
			GUICtrlSetData($g_hNextBBAttack, $g_sDateBuilderBase)
			$g_iAvailableAttacksBB = 0
			If ByPassedForceBBAttackOnClanGames($g_bChkBBStopAt3, False) = True And Not PlayBBOnly() Then
				Return True
			EndIf
		EndIf
	EndIf
	GUICtrlSetData($g_hNextBBAttack, "Now")
	Return False
EndFunc   ;==>IsBuilderBaseOCR
