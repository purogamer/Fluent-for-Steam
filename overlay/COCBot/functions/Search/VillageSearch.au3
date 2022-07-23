; #FUNCTION# ====================================================================================================================
; Name ..........: VillageSearch
; Description ...: Searches for a village that until meets conditions
; Syntax ........: VillageSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #6
; Modified ......: kaganus (Jun/Aug 2015), Sardo 2015-07, KnowJack(Aug 2015) , The Master (2015), MonkeyHunter (02/08-2016),
;				   CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func VillageSearch()

	$g_bVillageSearchActive = True
	$g_bCloudsActive = True

	Local $bResult = _VillageSearch()
	If $g_bSearchAttackNowEnable Then
		GUICtrlSetState($g_hBtnAttackNowDB, $GUI_HIDE)
		GUICtrlSetState($g_hBtnAttackNowLB, $GUI_HIDE)
		GUICtrlSetState($g_hBtnAttackNowTS, $GUI_HIDE)
		; GUICtrlSetState($g_hPicTwoArrowShield, $GUI_SHOW)
		GUICtrlSetState($g_hLblVersion, $GUI_SHOW)
		HideShields(False)
		; GUICtrlSetState($g_hLblMod, $GUI_SHOW)
		$g_bBtnAttackNowPressed = False
	EndIf

	$g_bVillageSearchActive = False
	$g_bCloudsActive = False

	Return $bResult

EndFunc   ;==>VillageSearch

Func _VillageSearch() ;Control for searching a village that meets conditions
	Local $Result
	Local $weakBaseValues
	Local $logwrited = False
	Local $iSkipped = 0
	Local $bReturnToPickupHero = False
	Local $abHeroUse[$eHeroCount] = [False, False, False, False]
	For $i = 0 To $eHeroCount - 1
		$abHeroUse[$i] = ($g_abSearchSearchesEnable[$DB] ? IsUnitUsed($DB, $eKing + $i) : False) _
				Or ($g_abSearchSearchesEnable[$LB] ? IsUnitUsed($LB, $eKing + $i) : False)
	Next

	If $g_bDebugDeadBaseImage Or $g_aiSearchEnableDebugDeadBaseImage > 0 Then
		DirCreate($g_sProfileTempDebugPath & "\SkippedZombies\")
		DirCreate($g_sProfileTempDebugPath & "\Zombies\")
		setZombie()
	EndIf

	If $g_bIsClientSyncError = False Then
		For $i = 0 To $g_iModeCount - 1
			$g_iAimGold[$i] = $g_aiFilterMinGold[$i]
			$g_iAimElixir[$i] = $g_aiFilterMinElixir[$i]
			$g_iAimGoldPlusElixir[$i] = $g_aiFilterMinGoldPlusElixir[$i]
			$g_iAimDark[$i] = ($g_abFilterMeetDEEnable[$i] ? ($g_aiFilterMeetDEMin[$i]) : (0))
			$g_iAimTrophy[$i] = ($g_abFilterMeetTrophyEnable[$i] ? ($g_aiFilterMeetTrophyMin[$i]) : (0))
			$g_iAimTrophyMax[$i] = ($g_abFilterMeetTrophyEnable[$i] ? ($g_aiFilterMeetTrophyMax[$i]) : (99))
		Next
	EndIf

	If _Sleep($DELAYVILLAGESEARCH1) Then Return
	$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
	checkAttackDisable($g_iTaBChkAttack, $Result) ;last check to see If TakeABreak msg on screen for fast PC from PrepareSearch click
	If $g_bRestart = True Then Return ; exit func
	If Not ($g_bIsSearchLimit) Then
		SetLogCentered("=", "=", $COLOR_INFO)
	EndIf
	For $x = 0 To $g_iModeCount - 1
		If IsSearchModeActive($x) Then WriteLogVillageSearch($x)
	Next

	If Not ($g_bIsSearchLimit) Then
		SetLogCentered("=", "=", $COLOR_INFO)
	Else
		SetLogCentered(" Restart To Search ", Default, $COLOR_INFO)
	EndIf

	If $g_bSearchAttackNowEnable Then
		HideShields(True)
		GUICtrlSetState($g_hBtnAttackNowDB, $GUI_SHOW)
		GUICtrlSetState($g_hBtnAttackNowLB, $GUI_SHOW)
		GUICtrlSetState($g_hBtnAttackNowTS, $GUI_SHOW)
		; GUICtrlSetState($g_hPicTwoArrowShield, $GUI_HIDE)
		GUICtrlSetState($g_hLblVersion, $GUI_HIDE)
		; GUICtrlSetState($g_hLblMod, $GUI_HIDE)
	EndIf

	If $g_bIsClientSyncError = False And $g_bIsSearchLimit = False Then
		$g_iSearchCount = 0
	EndIf

	$g_iSearchTotalSearchTime = _NowCalc() ; Custom Search Reduction - Team AIO Mod++

	If $g_bIsSearchLimit = True Then $g_bIsSearchLimit = False

	$g_bDoneSmartZap = False ; Custom SmartZap - Team AIO Mod++
	
	; Reset page errors.
	InitAndroidPageError()
	While 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; cleanup some vars used by imgloc just in case. usend in TH and DeadBase ( imgloc functions)
		ResetTHsearch()

		_ObjDeleteKey($g_oBldgAttackInfo, "") ; Remove all keys from building dictionary

		If $g_bDebugVillageSearchImages Then SaveDebugImage("villagesearch")
		$logwrited = False
		$g_bBtnAttackNowPressed = False
		$g_iSearchTHLResult = -1

		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC

		If $g_bRestart Then Return ; exit func

		; ----------------- READ ENEMY VILLAGE RESOURCES  -----------------------------------
		WaitForClouds()

		#Region - Custom PrepareSearch - Team AIO Mod++
		If $g_bBadPrepareSearch = True Then
			SetLog("Error: _VillageSearch, bad WaitForClouds.", $COLOR_ERROR)
			Return
		EndIf
		#EndRegion - Custom PrepareSearch - Team AIO Mod++

		AttackRemainingTime(True) ; Timer for knowing when attack starts, in 30 Sec. attack automatically starts and lasts for 3 Minutes
		If $g_bRestart Then Return ; exit func

		$g_bCloudsActive = False

		GetResources(False) ;Reads Resource Values
		If $g_bRestart Then Return ; exit func

		SuspendAndroid()

		; ---------------- CHECK THE ACTIVE MODE  --------------------------------------------
		; $dbase = true if dead base found
		; $match[$i] = result of check between gui settings and target village resources
		; $g_bIsModeActive[$i] = the mode it is active or not (cups, research, army %)
		Local $noMatchTxt = ""
		Local $dbBase = False
		Local $match[$g_iModeCount]
		For $i = 0 To $g_iModeCount - 1
			$match[$i] = False
			$g_bIsModeActive[$i] = False
		Next

		If _Sleep($DELAYRESPOND) Then Return

		For $i = 0 To $g_iModeCount - 1
			$g_bIsModeActive[$i] = IsSearchModeActive($i)
			If $g_bIsModeActive[$i] Then
				$match[$i] = CompareResources($i)
			EndIf
		Next

		#Region - Custom Search Reduction - Team AIO Mod++
		If $g_iSearchRedByMinHowManyTime > 0 Then
			$g_iSearchTotalSearchTime = _DateAdd('n', $g_iSearchRedByMinHowManyTime * Number($g_iSearchReductionByMin), $g_iSearchTotalSearchTime)
			SetDebugLog("Total Search Time Updated: " & $g_iSearchTotalSearchTime)
			$g_iSearchRedByMinHowManyTime = 0
		EndIf
		#EndRegion - Custom Search Reduction - Team AIO Mod++

		; reset village measures
		setVillageOffset(0, 0, 1)
		ConvertInternalExternArea()

		; only one capture here, very important for consistent debug images, zombies, redline calc etc.
		ForceCaptureRegion()
		_CaptureRegion2()

		; measure enemy village (only if resources match)
		Local $bAlwaysMeasure = $g_bVillageSearchAlwaysMeasure
		; If $bAlwaysMeasure Then TestDropLine(True) ;g_bVillageSearchAlwaysMeasure must enabled manually by editing Global var
		For $i = 0 To $g_iModeCount - 1
			If $match[$i] Or $bAlwaysMeasure Then
				If Not CheckZoomOut("VillageSearch", True, False) Then
					SaveDebugImage("VillageSearchMeasureFailed", False) ; make clean snapshot as well
					ExitLoop ; disable exiting search for December 2018 update due to zoomout issues
					; check two more times, only required for snow theme (snow fall can make it easily fail), but don't hurt to keep it
					$i = 0
					Local $bMeasured
					Do
						$i += 1
						If _Sleep($DELAYPREPARESEARCH2) Then Return ; wait 500 ms
						ForceCaptureRegion()
						_CaptureRegion2()
						$bMeasured = CheckZoomOut("VillageSearch", $i < 2, False)
					Until $bMeasured = True Or $i >= 2
					If Not $bMeasured Then Return ; exit func
				EndIf
				ExitLoop
			EndIf
		Next

		If $g_bRestart Then Return

		; ----------------- FIND TARGET TOWNHALL -------------------------------------------
		; $g_iSearchTH name of level of townhall (return "-" if no th found)
		; $g_iTHx and $g_iTHy coordinates of townhall
		Local $THString = ""
		If $match[$DB] Or $match[$LB] Then ; make sure resource conditions are met
			$THString = FindTownhall(False, False) ;find TH, but only if TH condition is checked
		ElseIf ($g_abFilterMeetOneConditionEnable[$DB] Or $g_abFilterMeetOneConditionEnable[$LB]) Then ; meet one then attack, do not need correct resources
			$THString = FindTownhall(True, False)
		ElseIf $g_abAttackTypeEnable[$TB] = 1 And ($g_iSearchCount >= $g_iAtkTBEnableCount) Then
			; Check the TH for BullyMode
			$THString = FindTownhall(True, False)
		EndIf

		#Region - Legend trophy protection - Team AIO Mod++
		If $g_bLeagueAttack = False Then
			For $i = 0 To $g_iModeCount - 1
				If $g_bIsModeActive[$i] Then
					If $g_abFilterMeetOneConditionEnable[$i] Then
						If $g_abFilterMeetTH[$i] = False And $g_abFilterMeetTHOutsideEnable[$i] = False Then
							;ignore, conditions not checked
						Else
							If CompareTH($i) Then $match[$i] = True ;have a match if meet one enabled & a TH condition is met. ; UPDATE THE VARIABLE $g_iSearchTHLResult
						EndIf
					Else
						If Not CompareTH($i) Then $match[$i] = False ;if TH condition not met, skip. if it is, match is determined based on resources ; UPDATE THE VARIABLE $g_iSearchTHLResult
					EndIf
				EndIf
			Next

			; Check the TH Level for BullyMode conditional
			If $g_iSearchTHLResult = -1 Then CompareTH(0) ; inside have a conditional to update $g_iSearchTHLResult
		EndIf
		#EndRegion - Legend trophy protection - Team AIO Mod++

		; ----------------- MOD -----------------------------------

		; Custom optimization - Team AIO Mod++
		If $g_bTestSceneryAttack = True And $g_bVillageSearchAlwaysMeasure = True Then
			Local $sScenery = DetectScenery($g_aVillageSize[6])

			SetLog("Attacking " & $sScenery, $COLOR_ACTION)
			; ExitLoop

		EndIf

		; ----------------- WRITE LOG OF ENEMY RESOURCES -----------------------------------
		Local $GetResourcesTXT = StringFormat("%3s", $g_iSearchCount) & "> [G]:" & StringFormat("%7s", $g_iSearchGold) & " [E]:" & StringFormat("%7s", $g_iSearchElixir) & " [D]:" & StringFormat("%5s", $g_iSearchDark) & " [T]:" & StringFormat("%2s", $g_iSearchTrophy) & $THString

		; Stats Attack
		$g_sSearchCount = $g_iSearchCount
		$g_sOppGold = $g_iSearchGold
		$g_sOppElixir = $g_iSearchElixir
		$g_sOppDE = $g_iSearchDark
		$g_sOppTrophies = $g_iSearchTrophy

		; ----------------- CHECK DEAD BASE -------------------------------------------------
		If Not $g_bRunState Then Return

		; check deadbase
		Local $checkDeadBase = $match[$DB] Or $match[$LB]

		; Custom - AIO Mod++
		If $g_bChkNoLeague[$DB] And $match[$DB] = True Then
			If SearchNoLeague() Then
				SetLog("Dead Base is in No League, match found.", $COLOR_SUCCESS)
				$dbBase = True
			Else
				; If you play against, this is disabled.
				If ($g_iSearchCount = 10) Then
					SetLog("Disabling no league, it seems that there are no true dead bases in your league !", $COLOR_ACTION)
				EndIf
				If ($g_iSearchCount > 10) Then $dbBase = checkDeadBase(False)
			EndIf
		ElseIf $checkDeadBase = True Then
			$dbBase = checkDeadBase(False)
		EndIf

		; ----------------- CHECK WEAK BASE -------------------------------------------------
		#Region - Legend trophy protection - Team AIO Mod++
		Local $sModeBase[3] = ["DB", "LB", "DT"]
		If $g_bLeagueAttack = False Then
			If (IsWeakBaseActive($DB) And $dbBase And ($match[$DB] Or $g_abFilterMeetOneConditionEnable[$DB])) Or _
					(IsWeakBaseActive($LB) And ($match[$LB] Or $g_abFilterMeetOneConditionEnable[$LB])) Then
				If ($g_iSearchTH <> "-") Then
					$weakBaseValues = IsWeakBase($g_iImglocTHLevel, $g_sImglocRedline, False)
				Else
					$weakBaseValues = IsWeakBase($g_iMaxTHLevel, "", False)
				EndIf
				For $i = 0 To $g_iModeCount - 2
					If IsWeakBaseActive($i) And (($i = $DB And $dbBase) Or $i <> $DB) And ($match[$i] Or $g_abFilterMeetOneConditionEnable[$i]) Then
						SetDebugLog("'Wakebase' for " & $sModeBase[$i])
						If getIsWeak($weakBaseValues, $i) Then
							$match[$i] = True
						Else
							$match[$i] = False
							$noMatchTxt &= ", Not a Weak Base for " & $g_asModeText[$i]
						EndIf
						SetDebugLog("'match' for " & $sModeBase[$i] & " is now " & $match[$i])
					EndIf
				Next
			EndIf
		EndIf
		
		ResumeAndroid()
		
		If $g_bLeagueAttack = True Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS)
			If $match[$LB] = True Then
				SetLog("      " & "Legend League: Live Base Found!", $COLOR_SUCCESS)
				$g_iMatchMode = $LB
			ElseIf $match[$DB] = True Then
				SetLog("      " & "Legend League: Live Base Found But Will Use Dead Base Attack Type!", $COLOR_SUCCESS)
				$g_iMatchMode = $DB
			EndIf
			ExitLoop
		EndIf
		#EndRegion - Legend trophy protection - Team AIO Mod++

		; ----------------- WRITE LOG VILLAGE FOUND AND ASSIGN VALUE AT $g_iMatchMode and exitloop  IF CONTITIONS MEET ---------------------------
		If $match[$DB] And $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Dead Base Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True

			#Region - Custom - Team AIO Mod++
			Local $bFlagSearchAnotherBase = False

			If ($bFlagSearchAnotherBase = False) Then
				If $g_bDBMeetCollectorOutside Then ; check is that collector  near outside
					$g_bScanMineAndElixir = False

					If CollectorsAndRedLines(False) Then
						SetLog("Collectors are outside, match found !", $COLOR_SUCCESS)
						$bFlagSearchAnotherBase = False
					Else
						$bFlagSearchAnotherBase = True
						If $g_bSkipCollectorCheck Then
							If Number($g_iTxtSkipCollectorGold) <> 0 And Number($g_iTxtSkipCollectorElixir) <> 0 And Number($g_iTxtSkipCollectorDark) <> 0 Then
								If Number($g_iSearchGold) >= Number($g_iTxtSkipCollectorGold) And Number($g_iSearchElixir) >= Number($g_iTxtSkipCollectorElixir) And Number($g_iSearchDark) >= Number($g_iTxtSkipCollectorDark) Then
									SetLog("Target Resource(G,E,D) over for skip collectors check, Prepare for attack...", $COLOR_INFO)
									$bFlagSearchAnotherBase = False
								EndIf
							ElseIf Number($g_iTxtSkipCollectorGold) <> 0 And Number($g_iTxtSkipCollectorElixir) <> 0 Then
								If Number($g_iSearchGold) >= Number($g_iTxtSkipCollectorGold) And Number($g_iSearchElixir) >= Number($g_iTxtSkipCollectorElixir) Then
									SetLog("Target Resource(G,E) over for skip collectors check, Prepare for attack...", $COLOR_INFO)
									$bFlagSearchAnotherBase = False
								EndIf
							ElseIf Number($g_iTxtSkipCollectorGold) <> 0 And Number($g_iTxtSkipCollectorDark) <> 0 Then
								If Number($g_iSearchGold) >= Number($g_iTxtSkipCollectorGold) And Number($g_iSearchDark) >= Number($g_iTxtSkipCollectorDark) Then
									SetLog("Target Resource(G,D) over for skip collectors check, Prepare for attack...", $COLOR_INFO)
									$bFlagSearchAnotherBase = False
								EndIf
							ElseIf Number($g_iTxtSkipCollectorElixir) <> 0 And Number($g_iTxtSkipCollectorDark) <> 0 Then
								If Number($g_iSearchElixir) >= Number($g_iTxtSkipCollectorElixir) And Number($g_iSearchDark) >= Number($g_iTxtSkipCollectorDark) Then
									SetLog("Target Resource(E,D) over for skip collectors check, Prepare for attack...", $COLOR_INFO)
									$bFlagSearchAnotherBase = False
								EndIf
							ElseIf Number($g_iTxtSkipCollectorGold) <> 0 Then
								If Number($g_iSearchGold) >= Number($g_iTxtSkipCollectorGold) Then
									SetLog("Target Resource(G) over for skip collectors check, Prepare for attack...", $COLOR_INFO)
									$bFlagSearchAnotherBase = False
								EndIf
							ElseIf Number($g_iTxtSkipCollectorElixir) <> 0 Then
								If Number($g_iSearchElixir) >= Number($g_iTxtSkipCollectorElixir) Then
									SetLog("Target Resource(E) over for skip collectors check, Prepare for attack...", $COLOR_INFO)
									$bFlagSearchAnotherBase = False
								EndIf
							ElseIf Number($g_iTxtSkipCollectorDark) <> 0 Then
								If Number($g_iSearchDark) >= Number($g_iTxtSkipCollectorDark) Then
									SetLog("Target Resource(D) over for skip collectors check, Prepare for attack...", $COLOR_INFO)
									$bFlagSearchAnotherBase = False
								EndIf
							EndIf
							If $bFlagSearchAnotherBase Then
								SetLog("Collectors are not outside AND Target Resource not match for attack, skipping search !", $COLOR_ERROR, "Lucida Console", 7.5)
							EndIf
						Else
							SetLog("Collectors are not outside, skipping search !", $COLOR_ERROR, "Lucida Console", 7.5)
						EndIf
						If $g_bSkipCollectorCheckTH Then
							If $bFlagSearchAnotherBase Then
								If $g_iSearchTH <> "-" Then
									If Number($g_iSearchTH) <= $g_iCmbSkipCollectorCheckTH Then
										SetLog("Target TownHall Level is " & $g_iSearchTH & ", lower than or equal my setting " & $g_iCmbSkipCollectorCheckTH & ", Prepare for attack...", $COLOR_INFO)
										$bFlagSearchAnotherBase = False
									Else
										SetLog("Collectors are not outside, and TownHall Level is " & $g_iSearchTH & " Over " & $g_iCmbSkipCollectorCheckTH & ", skipping search !", $COLOR_ERROR, "Lucida Console", 7.5)
									EndIf
								Else
									SetLog("Collectors are not outside, and failded to get townhall level, skipping search !", $COLOR_ERROR, "Lucida Console", 7.5)
								EndIf
							EndIf
						EndIf
					EndIf
					$g_iSearchTH = ""
				Else
					$bFlagSearchAnotherBase = False
				EndIf
				If Not $bFlagSearchAnotherBase Then
					$g_iMatchMode = $DB
					ExitLoop
				EndIf
			EndIf
			#EndRegion - Custom - Team AIO Mod++

		ElseIf $match[$LB] And Not $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Live Base Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$g_iMatchMode = $LB
			ExitLoop
		ElseIf $match[$LB] And $g_bCollectorFilterDisable Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Live Base Found!*", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$g_iMatchMode = $LB
			ExitLoop
		ElseIf $g_abAttackTypeEnable[$TB] = 1 And ($g_iSearchCount >= $g_iAtkTBEnableCount) Then ; TH bully doesn't need the resources conditions
			If $g_iSearchTHLResult = 1 Then
				SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
				SetLog("      " & "Not a match, but TH Bully Level Found! ", $COLOR_SUCCESS, "Lucida Console", 7.5)
				$logwrited = True
				$g_iMatchMode = $g_iAtkTBMode
				ExitLoop
			EndIf
		EndIf

		If $match[$DB] And Not $dbBase Then
			$noMatchTxt &= ", Not a " & $g_asModeText[$DB]
		ElseIf $match[$LB] And $dbBase Then
			$noMatchTxt &= ", Not a " & $g_asModeText[$LB]
		EndIf

		If $noMatchTxt <> "" Then
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
			SetLog("      " & StringMid($noMatchTxt, 3), $COLOR_ACTION, "Lucida Console", 7.5)
			$logwrited = True
		EndIf

		If Not ($logwrited) Then
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
		EndIf

		If $g_bSearchRestartPickupHero Then
			For $i = 0 To $eHeroCount - 1 ; check all heros
				If Not $abHeroUse[$i] Or Not _DateIsValid($g_asHeroHealTime[$i]) Then ContinueLoop
				Local $iTimeTillHeroHealed = Int(_DateDiff('s', _NowCalc(), $g_asHeroHealTime[$i])) ; hero time in seconds
				SetDebugLog($g_asHeroNames[$i] & " will be ready in " & $iTimeTillHeroHealed & " seconds")
				If $iTimeTillHeroHealed <= 0 Then
					$bReturnToPickupHero = True
					$g_asHeroHealTime[$i] = ""
					SetLog($g_asHeroNames[$i] & " is ready. Return home to pick " & ($i <> 1 ? "him" : "her") & " up to join the attack")
					ExitLoop ; found 1 Hero is ready, skip checking other heros
				EndIf
			Next
		EndIf
		; Return Home on Search limit or Hero healed
		If SearchLimit($iSkipped + 1, $bReturnToPickupHero) Then Return True

		If CheckAndroidReboot() = True Then
			$g_bRestart = True
			$g_bIsClientSyncError = True
			Return
		EndIf

		; ----------------- ADD RANDOM DELAY IF REQUESTED -----------------------------------
		If $g_iSearchDelayMin > 0 And $g_iSearchDelayMax > 0 Then ; Check if village delay values are set
			If $g_iSearchDelayMin <> $g_iSearchDelayMax Then ; Check if random delay requested
				If _Sleep(Round(1000 * Random($g_iSearchDelayMin, $g_iSearchDelayMax))) Then Return ;Delay time is random between min & max set by user
			Else
				If _Sleep(1000 * $g_iSearchDelayMin) Then Return ; Wait Village Serch delay set by user
			EndIf
		EndIf
		If _Sleep($DELAYRESPOND) Then Return

		; ------- Add attack now button delay and check button status
		If $g_bSearchAttackNowEnable And $g_iSearchAttackNowDelay > 0 Then
			If _Sleep(1000 * $g_iSearchAttackNowDelay) Then Return ; add human reaction time on AttackNow button function
		EndIf
		If $g_bBtnAttackNowPressed = True Then ExitLoop

		; ----------------- PRESS BUTTON NEXT  -------------------------------------------------
		If $checkDeadBase And Not $g_bDebugDeadBaseImage And $g_iSearchCount > $g_aiSearchEnableDebugDeadBaseImage Then
			SetLog("Enabled collecting debug images of dead bases (zombies)", $COLOR_DEBUG)
			SetLog("- Save skipped dead base when available Elixir with empty storage > " & (($g_aZombie[8] > -1) ? ($g_aZombie[8] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save skipped dead base when available Elixir > " & (($g_aZombie[9] > -1) ? ($g_aZombie[9] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save dead base when available Elixir < " & (($g_aZombie[10] > -1) ? ($g_aZombie[10] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save dead base when raided Elixir < " & (($g_aZombie[7] > -1) ? ($g_aZombie[7] & "%") : ("is disabled")), $COLOR_DEBUG)
			$g_bDebugDeadBaseImage = True
		EndIf
		If $g_bDebugDeadBaseImage Then setZombie()
		Local $i = 0
		While $i < 100
			If _Sleep($DELAYVILLAGESEARCH2) Then Return
			$i += 1
			_CaptureRegions()
			If Mod($i, 2) = 0 Then
				If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1]), Hex($NextBtn[2], 6), $NextBtn[3])) Then
					If IsAttackPage(False) Then
						$g_bCloudsActive = True
						ClickP($NextBtn, 1, 0, "#0155") ;Click Next
						ExitLoop
					Else
						SetDebugLog("Wait to see Next Button... " & $i, $COLOR_DEBUG)
					EndIf
				EndIf
			Else
				If ( _ColorCheck(_GetPixelColor($NextBtnFixed[0], $NextBtnFixed[1]), Hex($NextBtnFixed[2], 6), $NextBtnFixed[3])) Then
					If IsAttackPage(False) Then
						$g_bCloudsActive = True
						ClickP($NextBtnFixed, 1, 0, "#0155") ;Click Next
						ExitLoop
					Else
						SetDebugLog("Wait to see Next Button... " & $i, $COLOR_DEBUG)
					EndIf
				EndIf
			EndIf
			If $i >= 99 Or isProblemAffect() Or (Mod($i, 10) = 0 And checkObstacles_Network(False, False)) Then ; if we can't find the next button or there is an error, then restart
				$g_bIsClientSyncError = True
				checkMainScreen()
				If $g_bRestart Then
					$g_iNbrOfOoS += 1
					UpdateStats()
					SetLog("Couldn't locate Next button", $COLOR_ERROR)
					PushMsg("OoSResources")
				Else
					SetLog("Have strange problem Couldn't locate Next button, Restarting CoC and Bot...", $COLOR_ERROR)
					$g_bIsClientSyncError = False ; disable fast OOS restart if not simple error and try restarting CoC
					CloseCoC(True)
				EndIf
				Return
			EndIf
		WEnd

		If _Sleep($DELAYRESPOND) Then Return
		$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
		checkAttackDisable($g_iTaBChkAttack, $Result) ; check to see If TakeABreak msg on screen after next click
		If $g_bRestart = True Then Return ; exit func

		If isGemOpen(True) = True Then
			SetLog(" Not enough gold to keep searching.....", $COLOR_ERROR)
			Click(585, 252, 1, 0, "#0156") ; Click close gem window "X"
			If _Sleep($DELAYVILLAGESEARCH3) Then Return
			$g_bOutOfGold = True ; Set flag for out of gold to search for attack
			ReturnHome(False, False)
			Return
		EndIf

		$iSkipped = $iSkipped + 1
		$g_iSkippedVillageCount += 1
		If $g_iTownHallLevel <> "" And $g_iTownHallLevel > 0 Then
			$g_iSearchCost += $g_aiSearchCost[$g_iTownHallLevel - 1]
			$g_iStatsTotalGain[$eLootGold] -= $g_aiSearchCost[$g_iTownHallLevel - 1]
		EndIf
		UpdateStats()

	WEnd ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop End ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; center village, also update global village coordinates (that overwrites home base data, but will reset when returning anyway)
	; centering disabled and village measuring moved to top
	Local $aCenterVillage = SearchZoomOut($aCenterEnemyVillageClickDrag, True, "VillageSearch") ; Team AIO Mod++
	updateGlobalVillageOffset($aCenterVillage[3], $aCenterVillage[4]) ; update red line and TH location

	;--- show buttons attacknow ----
	If $g_bBtnAttackNowPressed = True Then
		SetLogCentered(" Attack Now Pressed! ", "~", $COLOR_SUCCESS)
	EndIf

	;--- write in log match found ----
	If $g_bSearchAlertMe Then
		TrayTip($g_sProfileCurrentName & ": " & $g_asModeText[$g_iMatchMode] & " Match Found!", "Gold: " & $g_iSearchGold & "; Elixir: " & $g_iSearchElixir & "; Dark: " & $g_iSearchDark & "; Trophy: " & $g_iSearchTrophy, "", 0)
		SetDebugLog("Trying to play sound.  Set volume to 50%", $COLOR_DEBUG)
		SoundSetWaveVolume(50) ;50% WAV volume setting
		If FileExists(@WindowsDir & "\media\Festival\Windows Exclamation.wav") Then
			SetDebugLog("Playing first sound.", $COLOR_DEBUG)
			SoundPlay(@WindowsDir & "\media\Festival\Windows Exclamation.wav", 1)
		ElseIf FileExists(@WindowsDir & "\media\Windows Exclamation.wav") Then
			SetDebugLog("Playing second sound.", $COLOR_DEBUG)
			SoundPlay(@WindowsDir & "\media\Windows Exclamation.wav", 1)
		Else
			SetDebugLog("No sound files found.", $COLOR_DEBUG)
		EndIf
	EndIf
	 
	SetLogCentered(" Search Complete ", Default, $COLOR_INFO)
	PushMsg("MatchFound")

	$g_bIsClientSyncError = False

EndFunc   ;==>_VillageSearch

Func SearchLimit($iSkipped, $bReturnToPickupHero = False)
	If $bReturnToPickupHero Or ($g_bSearchRestartEnable And $iSkipped >= Number($g_iSearchRestartLimit)) Then
		Local $Wcount = 0
		While 1
			If Mod($Wcount, 2) = 0 Then
				If _CheckPixel($aSurrenderButton, $g_bCapturePixel) = True Then
					ExitLoop
				EndIf
			Else
				If _CheckPixel($aSurrenderButtonFixed, $g_bCapturePixel) = True Then
					ExitLoop
				EndIf
			EndIf

			If _Sleep($DELAYSEARCHLIMIT) Then Return
			$Wcount += 1
			SetDebugLog("wait surrender button " & $Wcount, $COLOR_DEBUG)
			If $Wcount >= 50 Or isProblemAffect(True) Then
				checkMainScreen()
				$g_bIsClientSyncError = False ; reset OOS flag for long restart
				$g_bRestart = True ; set force runbot restart flag
				Return True
			EndIf
		WEnd
		$g_bIsSearchLimit = True
		ReturnHome(False, False) ;If End battle is available
		getArmyTroopCapacity(True, True)
		$g_bRestart = True ; set force runbot restart flag
		$g_bIsClientSyncError = True ; set OOS flag for fast restart
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SearchLimit


Func WriteLogVillageSearch($x)
	;this function write in BOT LOG the values setting for each attack mode ($DB,$LB)
	;example
	;[18.07.30] ============== Searching For Dead Base ===============
	;[18.07.30] Enable Dead Base search IF
	;[18.07.30] - Army Camps % >  70
	;[18.07.30] Match Dead Base  village IF
	;[18.07.30] - Meet: Gold and Elixir
	;[18.07.30] - Weak Base(Mortar: 5, WizTower: 5)

	If $g_bLeagueAttack Then
		If $g_bDebugSetlog Then SetLogCentered(" Searching For " & $g_asModeText[$x] & " ", Default, $COLOR_INFO)
		SetLog("In Legend League Bot will attack any " & $g_asModeText[$x] & " it get's.", $COLOR_INFO)
		Return
	EndIf

	Local $MeetGxEtext = "", $MeetGorEtext = "", $MeetGplusEtext = "", $MeetDEtext = "", $MeetTrophytext = "", $MeetTHtext = "", $MeetTHOtext = "", $MeetWeakBasetext = "", $EnabledAftertext = ""
	If $g_aiFilterMeetGE[$x] = 0 Then $MeetGxEtext = "- Meet: Gold and Elixir"
	If $g_aiFilterMeetGE[$x] = 1 Then $MeetGorEtext = "- Meet: Gold or Elixir"
	If $g_aiFilterMeetGE[$x] = 2 Then $MeetGplusEtext = "- Meet: Gold + Elixir"
	If $g_abFilterMeetDEEnable[$x] Then $MeetDEtext = "- Dark"
	If $g_abFilterMeetTrophyEnable[$x] Then $MeetTrophytext = "- Trophy"
	If $g_abFilterMeetTH[$x] Then $MeetTHtext = "- Max TH " & $g_aiMaxTH[$x] ;$g_aiFilterMeetTHMin
	If $g_abFilterMeetTHOutsideEnable[$x] Then $MeetTHOtext = "- TH Outside"
	If IsWeakBaseActive($x) Then $MeetWeakBasetext = "- Weak Base"
	If Not ($g_bIsSearchLimit) And $g_bDebugSetlog Then
		SetLogCentered(" Searching For " & $g_asModeText[$x] & " ", Default, $COLOR_INFO)
		SetLog("Enable " & $g_asModeText[$x] & " search IF ", $COLOR_INFO)
		If $g_abSearchSearchesEnable[$x] Then SetLog("- Numbers of searches range " & $g_aiSearchSearchesMin[$x] & " - " & $g_aiSearchSearchesMax[$x], $COLOR_INFO)
		If $g_abSearchTropiesEnable[$x] Then SetLog("- Search tropies range " & $g_aiSearchTrophiesMin[$x] & " - " & $g_aiSearchTrophiesMax[$x], $COLOR_INFO)
		If $g_abSearchCampsEnable[$x] Then SetLog("- Army Camps % >  " & $g_aiSearchCampsPct[$x], $COLOR_INFO)
		SetLog("Match " & $g_asModeText[$x] & "  village IF ", $COLOR_INFO)
		If $MeetGxEtext <> "" Then SetLog($MeetGxEtext, $COLOR_INFO)
		If $MeetGorEtext <> "" Then SetLog($MeetGorEtext, $COLOR_INFO)
		If $MeetGplusEtext <> "" Then SetLog($MeetGplusEtext, $COLOR_INFO)
		If $MeetDEtext <> "" Then SetLog($MeetDEtext, $COLOR_INFO)
		If $MeetTrophytext <> "" Then SetLog($MeetTrophytext, $COLOR_INFO)
		If $MeetTHtext <> "" Then SetLog($MeetTHtext, $COLOR_INFO)
		If $MeetTHOtext <> "" Then SetLog($MeetTHOtext, $COLOR_INFO)
		If $MeetWeakBasetext <> "" Then SetLog($MeetWeakBasetext, $COLOR_INFO)
		If $g_abFilterMeetOneConditionEnable[$x] Then SetLog("Meet One and Attack!")
		SetLogCentered(" RESOURCE CONDITIONS ", "~", $COLOR_INFO)
	EndIf
	If Not ($g_bIsSearchLimit) Then
		Local $txtTrophies = "", $txtTownhall = ""
		If $g_abFilterMeetTrophyEnable[$x] Then $txtTrophies = " [T]:" & StringFormat("%2s", $g_iAimTrophy[$x]) & "-" & StringFormat("%2s", $g_iAimTrophyMax[$x])
		If $g_abFilterMeetTH[$x] Then $txtTownhall = " [TH]:" & StringFormat("%2s", $g_aiMaxTH[$x]) ;$g_aiFilterMeetTHMin
		If $g_abFilterMeetTHOutsideEnable[$x] Then $txtTownhall &= ", Out"
		If $g_aiFilterMeetGE[$x] = 2 Then
			SetLog("Aim:           [G+E]:" & StringFormat("%7s", $g_iAimGoldPlusElixir[$x]) & " [D]:" & StringFormat("%5s", $g_iAimDark[$x]) & $txtTrophies & $txtTownhall & " for: " & $g_asModeText[$x], $COLOR_INFO)
		Else
			SetLog("Aim: [G]:" & StringFormat("%7s", $g_iAimGold[$x]) & " [E]:" & StringFormat("%7s", $g_iAimElixir[$x]) & " [D]:" & StringFormat("%5s", $g_iAimDark[$x]) & $txtTrophies & $txtTownhall & " for: " & $g_asModeText[$x], $COLOR_INFO)
		EndIf
	EndIf

EndFunc   ;==>WriteLogVillageSearch

Func TestCheckDeadBase()
	Local $dbBase
	_CaptureRegion2()
	#Region - No League - Team AIO Mod++
	If $g_bChkNoLeague[$DB] Then
		If SearchNoLeague() Then
			SetLog("Dead Base is in No League, match found !", $COLOR_SUCCESS)
			$dbBase = True
		ElseIf $g_iSearchCount > 50 Then
			$dbBase = checkDeadBase()
		Else
			SetLog("Dead Base is in a League, skipping search !", $COLOR_INFO)
			$dbBase = False
		EndIf
	Else
		$dbBase = checkDeadBase()
	EndIf
	#EndRegion - No League - Team AIO Mod++
	Return $dbBase
EndFunc   ;==>TestCheckDeadBase
