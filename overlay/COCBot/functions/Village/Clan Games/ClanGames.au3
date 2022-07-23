; #FUNCTION# ====================================================================================================================
; Name ..........: Clan Games
; Description ...: This file contains the Clan Games algorithm
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: ViperZ And Uncle Xbenk 01-2018
; Modified ......: ProMac 02/2018 [v2 and v3] , ProMac 08/2018 v4, GrumpyHog 08/2020, xBebenk x boludoz (2021)
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Global $g_bYourAccScoreCG[$g_eTotalAcc][3]

For $i = 0 To $g_eTotalAcc - 1
	$g_bYourAccScoreCG[$i][0] = -1
	$g_bYourAccScoreCG[$i][1] = True
	$g_bYourAccScoreCG[$i][2] = False
Next

#Region - Custom BB - Team AIO Mod++
Func _ClanGames($test = False, $bFromBB = False)
	$g_bIsBBevent = False ; Reset
	; Check If this Feature is Enable on GUI.
	If Not $g_bChkClanGamesEnabled Then Return
	__ClanGames($test, $bFromBB)
	$g_sTimerStatusBB = _DateAdd('n', Round(10 * Random(1.05, 1.25)), _NowCalc()) ; Custom BB - Team AIO Mod++
	CloseClanGames()
EndFunc   ;==>_ClanGames
#EndRegion - Custom BB - Team AIO Mod++

Func __ClanGames($test = False, $bFromBB = False)
	If Not $g_bChkClanGamesEnabled Then Return

	; Local $sINIPath = StringReplace($g_sProfileConfigPath, "config.ini", "ClanGames_config.ini")

	; A user Log and a Click away just in case
	SetLog("Entering Clan Games", $COLOR_INFO)

	; Local and Static Variables
	Local $TabChallengesPosition[2] = [820, 130 - 44] ; Resolution fixed
	Local $sTimeRemain = "", $sEventName = "", $getCapture = True

	; Initial Timer
	Local $hTimer = TimerInit()

    ; Let's selected only the necessary images
    Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"
    Local $sTempPath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\"

    ;Remove All previous file (in case setting changed)
    DirRemove($sTempPath, $DIR_REMOVE)

    If $g_bChkClanGamesLoot Then ClanGameImageCopy($sImagePath, $sTempPath, "L") ;L for Loot
    If $g_bChkClanGamesBattle Then ClanGameImageCopy($sImagePath, $sTempPath, "B") ;B for Battle
    If $g_bChkClanGamesDes Then ClanGameImageCopy($sImagePath, $sTempPath, "D") ;D for Destruction
    If $g_bChkClanGamesAirTroop Then ClanGameImageCopy($sImagePath, $sTempPath, "A") ;A for AirTroops
    If $g_bChkClanGamesGroundTroop Then ClanGameImageCopy($sImagePath, $sTempPath, "G") ;G for GroundTroops

    If $g_bChkClanGamesMiscellaneous Then ClanGameImageCopy($sImagePath, $sTempPath, "M") ;M for Misc
    If $g_bChkClanGamesSpell Then ClanGameImageCopy($sImagePath, $sTempPath, "S") ;S for GroundTroops
    If $g_bChkClanGamesBBBattle Then ClanGameImageCopy($sImagePath, $sTempPath, "BBB") ;BBB for BB Battle
    If $g_bChkClanGamesBBDes Then ClanGameImageCopy($sImagePath, $sTempPath, "BBD") ;BBD for BB Destruction
    If $g_bChkClanGamesBBTroops Then ClanGameImageCopy($sImagePath, $sTempPath, "BBT") ;BBT for BB Troops

    ;now we need to copy selected challenge before checking current running event is not wrong event selected

	; Enter on Clan Games window
	If Not IsClanGamesWindow(True, False, $bFromBB) Then Return ; Custom BB - Team AIO Mod++

	If _Sleep(3000) Then Return

	; Enter on Clan Games window
	$g_bYourAccScoreCG[Int($g_iCurAccount)][2] = False

	; Let's get some information , like Remain Timer, Score and limit
	Local $aiScoreLimit = GetTimesAndScores()
	If $aiScoreLimit = -1 Or UBound($aiScoreLimit) <> 2 Then
		CloseClanGames() ;need CloseClanGames, as we are leaving
		Return
	Else
		SetLog("Your Score is: " & $aiScoreLimit[0], $COLOR_INFO)
		Local $sTimeCG
		If $aiScoreLimit[0] = $aiScoreLimit[1] Then
			$g_bYourAccScoreCG[Int($g_iCurAccount)][2] = True
			SetLog("Your score limit is reached! Congrats")
			CloseClanGames()
			Return
		ElseIf $aiScoreLimit[0] + 300 > $aiScoreLimit[1] Then
			SetLog("Your almost reached max point")
			If $g_bChkClanGamesStopBeforeReachAndPurge Then
				If IsEventRunning() Then Return
				$sTimeCG = ConvertOCRTime("ClanGames()", $g_sClanGamesTimeRemaining, True)
				Setlog("Clan Games Minute Remain: " & $sTimeCG)
				If $g_bChkClanGamesPurgeAny And $sTimeCG > 1200 Then ; purge, but not purge on last day of clangames
					SetLog("Stop before completing your limit and only Purge")
					SetLog("Lets only purge 1 most top event", $COLOR_WARNING)
					ForcePurgeEvent(False, True)
					CloseClanGames()
					Return
				EndIf
			EndIf
		EndIf
		If $g_bYourAccScoreCG[$g_iCurAccount][0] = -1 Then $g_bYourAccScoreCG[$g_iCurAccount][0] = $aiScoreLimit[0]
	EndIf

	;check cooldown purge
	If CooldownTime() Then Return
	If Not $g_bRunState Then Return ;trap pause or stop bot
	If IsEventRunning() Then Return
	If Not $g_bRunState Then Return ;trap pause or stop bot

	UpdateStats()

	Local $HowManyImages = _FileListToArray($sTempPath, "*", $FLTA_FILES)
	If IsArray($HowManyImages) Then
		Setlog($HowManyImages[0] & " Events to search")
	Else
		Setlog("ClanGames-Error on $HowManyImages: " & @error)
		CloseClanGames()
		Return
	EndIf

	; To store the detections
	Local $aSelectChallenges[0][6]
	
	; [0]=ChallengeName [1]=EventName [2]=Xaxis [3]=Yaxis, [4]=IsBBChallenge
	Local $aAllDetectionsOnScreen = ChallengeDetection()
	If $g_bChkClanGamesDebug Then Setlog("_ClanGames findMultiple (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)

	If UBound($aAllDetectionsOnScreen) > 0 Then
		For $i = 0 To UBound($aAllDetectionsOnScreen) - 1
			
			If $aAllDetectionsOnScreen[$i][4] = False Then
				Switch $aAllDetectionsOnScreen[$i][0]
					Case "L"
						If Not $g_bChkClanGamesLoot Then ContinueLoop
						;[0] = Path Directory , [1] = Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
						; Local $g_aCGLootChallenges = $g_aCGLootChallenges
						For $j = 0 To UBound($g_aCGLootChallenges) - 1
							; If $g_aCGLootChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGLootChallenges[$j][0] Then
								; Verify your TH level and Challenge kind
								If $g_iTownHallLevel < $g_aCGLootChallenges[$j][2] Then ExitLoop
								; Disable this event from INI File
								If $g_aCGLootChallenges[$j][3] = 0 Then ExitLoop
								; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
								Local $aArray = [$g_aCGLootChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $g_aCGLootChallenges[$j][3]]
							EndIf
						Next
					Case "A"
						If Not $g_bChkClanGamesAirTroop Then ContinueLoop
						;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Event Quantities
						; Local $g_aCGAirTroopChallenges = $g_aCGAirTroopChallenges
						For $j = 0 To UBound($g_aCGAirTroopChallenges) - 1
							; If $g_aCGAirTroopChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGAirTroopChallenges[$j][0] Then
								; Verify if the Troops exist in your Army Composition
								Local $TroopIndex = Int(Eval("eTroop" & $g_aCGAirTroopChallenges[$j][1]))
								; If doesn't Exist the Troop on your Army
								If $g_aiCurrentTroops[$TroopIndex] < 1 Then
									If $g_bChkClanGamesDebug Then SetLog("[" & $g_aCGAirTroopChallenges[$j][1] & "] No " & $g_asTroopNames[$TroopIndex] & " on your army composition.")
									ExitLoop
									; If Exist BUT not is required quantities
								ElseIf $g_aiCurrentTroops[$TroopIndex] > 0 And $g_aiCurrentTroops[$TroopIndex] < $g_aCGAirTroopChallenges[$j][3] Then
									If $g_bChkClanGamesDebug Then SetLog("[" & $g_aCGAirTroopChallenges[$j][1] & "] You need more " & $g_asTroopNames[$TroopIndex] & " [" & $g_aiCurrentTroops[$TroopIndex] & "/" & $g_aCGAirTroopChallenges[$j][3] & "]")
									ExitLoop
								EndIf
								; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
								Local $aArray[4] = [$g_aCGAirTroopChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], 1]
							EndIf
						Next

					Case "S" ; - grumpy
						If Not $g_bChkClanGamesSpell Then ContinueLoop
						;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Event Quantities
						; Local $g_aCGSpellChallenges = $g_aCGSpellChallenges ; load all spell challenges
						For $j = 0 To UBound($g_aCGSpellChallenges) - 1 ; loop through all challenges
							; If $g_aCGSpellChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGSpellChallenges[$j][0] Then
								; Verify if the Spell exist in your Army Composition
								Local $SpellIndex = Int(Eval("eSpell" & $g_aCGSpellChallenges[$j][1])) ; assign $SpellIndex enum second column of array is spell name line 740 in GlobalVariables
								; If doesn't Exist the Troop on your Army
								If $g_aiCurrentSpells[$SpellIndex] < 1 Then
									If $g_bChkClanGamesDebug Then SetLog("[" & $g_aCGSpellChallenges[$j][1] & "] No " & $g_asSpellNames[$SpellIndex] & " on your army composition.")
									ExitLoop
									; If Exist BUT not is required quantities
								ElseIf $g_aiCurrentSpells[$SpellIndex] > 0 And $g_aiCurrentSpells[$SpellIndex] < $g_aCGSpellChallenges[$j][3] Then
									If $g_bChkClanGamesDebug Then SetLog("[" & $g_aCGSpellChallenges[$j][1] & "] You need more " & $g_asSpellNames[$SpellIndex] & " [" & $g_aiCurrentSpells[$SpellIndex] & "/" & $g_aCGSpellChallenges[$j][3] & "]")
									ExitLoop
								EndIf
								; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
								Local $aArray[4] = [$g_aCGSpellChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], 1]
							EndIf
						Next

				   Case "G"
						If Not $g_bChkClanGamesGroundTroop Then ContinueLoop
						;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Event Quantities
						; Local $g_aCGGroundTroopChallenges = $g_aCGGroundTroopChallenges
						For $j = 0 To UBound($g_aCGGroundTroopChallenges) - 1
							; If $g_aCGGroundTroopChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGGroundTroopChallenges[$j][0] Then
								; Verify if the Troops exist in your Army Composition
								Local $TroopIndex = Int(Eval("eTroop" & $g_aCGGroundTroopChallenges[$j][1]))
								; If doesn't Exist the Troop on your Army
								If $g_aiCurrentTroops[$TroopIndex] < 1 Then
									If $g_bChkClanGamesDebug Then SetLog("[" & $g_aCGGroundTroopChallenges[$j][1] & "] No " & $g_asTroopNames[$TroopIndex] & " on your army composition.")
									ExitLoop
									; If Exist BUT not is required quantities
								ElseIf $g_aiCurrentTroops[$TroopIndex] > 0 And $g_aiCurrentTroops[$TroopIndex] < $g_aCGGroundTroopChallenges[$j][3] Then
									If $g_bChkClanGamesDebug Then SetLog("[" & $g_aCGGroundTroopChallenges[$j][1] & "] You need more " & $g_asTroopNames[$TroopIndex] & " [" & $g_aiCurrentTroops[$TroopIndex] & "/" & $g_aCGGroundTroopChallenges[$j][3] & "]")
									ExitLoop
								EndIf
								; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
								Local $aArray[4] = [$g_aCGGroundTroopChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], 1]
							EndIf
						 Next

					Case "B"
						If Not $g_bChkClanGamesBattle Then ContinueLoop
						;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
						; Local $g_aCGBattleChallenges = $g_aCGBattleChallenges
						For $j = 0 To UBound($g_aCGBattleChallenges) - 1
							; If $g_aCGBattleChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGBattleChallenges[$j][0] Then
								; Verify the TH level and a few Challenge to destroy TH specific level
								If $g_aCGBattleChallenges[$j][1] = "Scrappy 6s" And ($g_iTownHallLevel < 5 Or $g_iTownHallLevel > 7) Then ExitLoop        ; TH level 5-6-7
								If $g_aCGBattleChallenges[$j][1] = "Super 7s" And ($g_iTownHallLevel < 6 Or $g_iTownHallLevel > 8) Then ExitLoop            ; TH level 6-7-8
								If $g_aCGBattleChallenges[$j][1] = "Exciting 8s" And ($g_iTownHallLevel < 7 Or $g_iTownHallLevel > 9) Then ExitLoop        ; TH level 7-8-9
								If $g_aCGBattleChallenges[$j][1] = "Noble 9s" And ($g_iTownHallLevel < 8 Or $g_iTownHallLevel > 10) Then ExitLoop        ; TH level 8-9-10
								If $g_aCGBattleChallenges[$j][1] = "Terrific 10s" And ($g_iTownHallLevel < 9 Or $g_iTownHallLevel > 11) Then ExitLoop    ; TH level 9-10-11
								If $g_aCGBattleChallenges[$j][1] = "Exotic 11s" And ($g_iTownHallLevel < 10 Or $g_iTownHallLevel > 12) Then ExitLoop     ; TH level 10-11-12
								If $g_aCGBattleChallenges[$j][1] = "Triumphant 12s" And $g_iTownHallLevel < 11 Then ExitLoop  ; TH level 11-12-13
								If $g_aCGBattleChallenges[$j][1] = "Tremendous 13s" And $g_iTownHallLevel < 12 Then ExitLoop  ; TH level 12-13

								; Verify your TH level and Challenge
								If $g_iTownHallLevel < $g_aCGBattleChallenges[$j][2] Then ExitLoop
								; Disable this event from INI File
								If $g_aCGBattleChallenges[$j][3] = 0 Then ExitLoop
								; If you are a TH13 , doesn't exist the TH14 yet
								If $g_aCGBattleChallenges[$j][1] = "Attack Up" And $g_iTownHallLevel >= 13 Then ExitLoop
								; Check your Trophy Range
								If $g_aCGBattleChallenges[$j][1] = "Slaying The Titans" And (Int($g_aiCurrentLoot[$eLootTrophy]) < 4100 or Int($g_aiCurrentLoot[$eLootTrophy]) > 5000) Then ExitLoop

								If $g_aCGBattleChallenges[$j][1] = "Clash of Legends" And Int($g_aiCurrentLoot[$eLootTrophy]) < 5000 Then ExitLoop

								; Check if exist a probability to use any Spell
								; If $g_aCGBattleChallenges[$j][1] = "No-Magic Zone" And ($g_bSmartZapEnable = True Or ($g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 1) Or ($g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 1)) Then ExitLoop
								; same as above, but SmartZap as condition removed, cause SZ does not necessary triggers every attack
								If $g_aCGBattleChallenges[$j][1] = "No-Magic Zone" And (($g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 1) Or ($g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 1)) Then ExitLoop
								; Check if you are using Heroes
								If $g_aCGBattleChallenges[$j][1] = "No Heroics Allowed" And ((Int($g_aiAttackUseHeroes[$DB]) > $eHeroNone And $g_iMatchMode = $DB) Or (Int($g_aiAttackUseHeroes[$LB]) > $eHeroNone And $g_iMatchMode = $LB)) Then ExitLoop
								; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
								Local $aArray[4] = [$g_aCGBattleChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $g_aCGBattleChallenges[$j][3]]
							EndIf
						Next
					Case "D"
						If Not $g_bChkClanGamesDes Then ContinueLoop
						;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
						; Local $g_aCGDestructionChallenges = $g_aCGDestructionChallenges
						For $j = 0 To UBound($g_aCGDestructionChallenges) - 1
							; If $g_aCGDestructionChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGDestructionChallenges[$j][0] Then
								; Verify your TH level and Challenge kind
								If $g_iTownHallLevel < $g_aCGDestructionChallenges[$j][2] Then ExitLoop

								; Disable this event from INI File
								If $g_aCGDestructionChallenges[$j][3] = 0 Then ExitLoop

								; Check if you are using Heroes
								If $g_aCGDestructionChallenges[$j][1] = "Hero Level Hunter" Or _
										$g_aCGDestructionChallenges[$j][1] = "King Level Hunter" Or _
										$g_aCGDestructionChallenges[$j][1] = "Queen Level Hunter" Or _
										$g_aCGDestructionChallenges[$j][1] = "Warden Level Hunter" And ((Int($g_aiAttackUseHeroes[$DB]) = $eHeroNone And $g_iMatchMode = $DB) Or (Int($g_aiAttackUseHeroes[$LB]) = $eHeroNone And $g_iMatchMode = $LB)) Then ExitLoop
								; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
								Local $aArray[4] = [$g_aCGDestructionChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $g_aCGDestructionChallenges[$j][3]]
							EndIf
						Next
					Case "M"
						If Not $g_bChkClanGamesMiscellaneous Then ContinueLoop
						;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
						; Local $g_aCGMiscChallenges = $g_aCGMiscChallenges
						For $j = 0 To UBound($g_aCGMiscChallenges) - 1
							; If $g_aCGMiscChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGMiscChallenges[$j][0] Then
								; Disable this event from INI File
								If $g_aCGMiscChallenges[$j][3] = 0 Then ExitLoop

								; Exceptions :
								; 1 - "Gardening Exercise" needs at least a Free Builder and "Remove Obstacles" enabled
								If $g_aCGMiscChallenges[$j][1] = "Gardening Exercise" And ($g_iFreeBuilderCount < 1 Or Not $g_bChkCleanYard) Then ExitLoop

								; 2 - Verify your TH level and Challenge kind
								If $g_iTownHallLevel < $g_aCGMiscChallenges[$j][2] Then ExitLoop

								; 3 - If you don't Donate Troops
								If $g_aCGMiscChallenges[$j][1] = "Helping Hand" And Not $g_iActiveDonate Then ExitLoop

								; 4 - If you don't Donate Spells , $g_aiPrepDon[2] = Donate Spells , $g_aiPrepDon[3] = Donate All Spells [PrepareDonateCC()]
								If $g_aCGMiscChallenges[$j][1] = "Donate Spells" And ($g_aiPrepDon[2] = 0 And $g_aiPrepDon[3] = 0) Then ExitLoop

								; 5 - If you don't use Blimp
								If $g_aCGMiscChallenges[$j][1] = "Battle Blimp" And ($g_aiAttackUseSiege[$DB] = 2 Or $g_aiAttackUseSiege[$LB] = 2) And $g_aiArmyCompSiegeMachines[$eSiegeBattleBlimp] = 0 Then ExitLoop

								; 6 - If you don't use Wrecker
								If $g_aCGMiscChallenges[$j][1] = "Wall Wrecker" And ($g_aiAttackUseSiege[$DB] = 1 Or $g_aiAttackUseSiege[$LB] = 1) And $g_aiArmyCompSiegeMachines[$eSiegeWallWrecker] = 0 Then ExitLoop

								If $g_aCGMiscChallenges[$j][1] = "Stone Slammer" And ($g_aiAttackUseSiege[$DB] = 3 Or $g_aiAttackUseSiege[$LB] = 3) And $g_aiArmyCompSiegeMachines[$eSiegeStoneSlammer] = 0 Then ExitLoop

								If $g_aCGMiscChallenges[$j][1] = "Siege Barrack" And ($g_aiAttackUseSiege[$DB] = 4 Or $g_aiAttackUseSiege[$LB] = 4) And $g_aiArmyCompSiegeMachines[$eSiegeBarracks] = 0 Then ExitLoop

								If $g_aCGMiscChallenges[$j][1] = "Log Launcher" And ($g_aiAttackUseSiege[$DB] = 5 Or $g_aiAttackUseSiege[$LB] = 5) And $g_aiArmyCompSiegeMachines[$eSiegeLogLauncher] = 0 Then ExitLoop

								; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
								Local $aArray[4] = [$g_aCGMiscChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $g_aCGMiscChallenges[$j][3]]
							EndIf
						Next
				EndSwitch
			Else
				Switch $aAllDetectionsOnScreen[$i][0]
					Case "BBB" ; BB Battle challenges
						If Not $g_bChkClanGamesBBBattle Then ContinueLoop

						;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
						; Local $g_aCGBBBattleChallenges = $g_aCGBBBattleChallenges
						For $j = 0 To UBound($g_aCGBBBattleChallenges) - 1
							; If $g_aCGBBBattleChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGBBBattleChallenges[$j][0] Then

								; Verify your TH level and Challenge kind
								; If $g_iBBTownHallLevel < $g_aCGDestructionChallenges[$j][2] Then ExitLoop ; adding soon

								Local $aArray[4] = [$g_aCGBBBattleChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $g_aCGBBBattleChallenges[$j][3]]
							EndIf
						Next
					Case "BBD" ; BB Destruction challenges
						If Not $g_bChkClanGamesBBDes Then ContinueLoop

						;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
						; Local $g_aCGBBDestructionChallenges = $g_aCGBBDestructionChallenges
						For $j = 0 To UBound($g_aCGBBDestructionChallenges) - 1
							; If $g_aCGBBDestructionChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGBBDestructionChallenges[$j][0] Then
								Local $aArray[4] = [$g_aCGBBDestructionChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $g_aCGBBDestructionChallenges[$j][3]]
							EndIf
						Next
					Case "BBT" ; BB Troop challenges
						If Not $g_bChkClanGamesBBTroops Then ContinueLoop

						;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
						; Local $g_aCGBBTroopChallenges = $g_aCGBBTroopChallenges
						For $j = 0 To UBound($g_aCGBBTroopChallenges) - 1
							; If $g_aCGBBTroopChallenges[$j][5] = False Then ContinueLoop
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $g_aCGBBTroopChallenges[$j][0] Then
								Local $aArray[4] = [$g_aCGBBTroopChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $g_aCGBBTroopChallenges[$j][3]]
							EndIf
						Next
				EndSwitch
			EndIf
			
			If IsDeclared("aArray") And $aArray[0] <> "" Then
				ReDim $aSelectChallenges[UBound($aSelectChallenges) + 1][6]
				$aSelectChallenges[UBound($aSelectChallenges) - 1][0] = $aArray[0] ; Event Name Full Name
				$aSelectChallenges[UBound($aSelectChallenges) - 1][1] = $aArray[1] ; Xaxis
				$aSelectChallenges[UBound($aSelectChallenges) - 1][2] = $aArray[2] ; Yaxis
				$aSelectChallenges[UBound($aSelectChallenges) - 1][3] = $aArray[3] ; difficulty
				$aSelectChallenges[UBound($aSelectChallenges) - 1][4] = 0 ; timer minutes
				$aSelectChallenges[UBound($aSelectChallenges) - 1][5] = $aAllDetectionsOnScreen[$i][4] ; EventType: MainVillage/BuilderBase
				$aArray[0] = ""
			EndIf
		Next
	EndIf

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames aAllDetectionsOnScreen (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; Sort by Yaxis , TOP to Bottom
	_ArraySort($aSelectChallenges, 0, 0, 0, 2)

	If UBound($aSelectChallenges) > 0 Then
		; let's get the Event timing
		For $i = 0 To UBound($aSelectChallenges) - 1
			Setlog("Detected " & $aSelectChallenges[$i][0] & " difficulty of " & $aSelectChallenges[$i][3])
			Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
			If _Sleep(1500) Then Return
			Local $EventHours = GetEventInformation()
			Setlog("Time: " & $EventHours & " min", $COLOR_INFO)
			Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
			If _Sleep(250) Then Return
			$aSelectChallenges[$i][4] = Number($EventHours)
		Next

		; let's get the 60 minutes events and remove from array
		Local $aTempSelectChallenges[0][6]
		For $i = 0 To UBound($aSelectChallenges) - 1
			If $aSelectChallenges[$i][4] = 60 And $g_bChkClanGames60 Then
				Setlog($aSelectChallenges[$i][0] & " unselected, is a 60min event!", $COLOR_INFO)
				ContinueLoop
			EndIf
			ReDim $aTempSelectChallenges[UBound($aTempSelectChallenges) + 1][6]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][0] = $aSelectChallenges[$i][0]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][1] = $aSelectChallenges[$i][1]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][2] = $aSelectChallenges[$i][2]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][3] = $aSelectChallenges[$i][3]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][4] = $aSelectChallenges[$i][4]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][5] = $aSelectChallenges[$i][5]
		Next

		; Drop to top again , because coordinates Xaxis and Yaxis
		ClickP($TabChallengesPosition, 2, 0, "#Tab")
		If _sleep(250) Then Return
		ClickDrag(807, 210 + $g_iMidOffsetYFixed, 807, 385 + $g_iMidOffsetYFixed, 500) ; Resolution changed
		If _Sleep(500) Then Return
	EndIf

	; After removing is necessary check Ubound
	If IsDeclared("aTempSelectChallenges") Then
		If UBound($aTempSelectChallenges) > 0 Then
			SetDebugLog("$aTempSelectChallenges: " & _ArrayToString($aTempSelectChallenges))
			; Sort by difficulties
			;_ArraySort($aTempSelectChallenges, 0, 0, 0, 3)

			; Sort by time
			_ArraySort($aTempSelectChallenges, 1, 4, 0, 3)

			Setlog("Next Event will be " & $aTempSelectChallenges[0][0] & " to make in " & $aTempSelectChallenges[0][4] & " min.")
			; Select and Start EVENT
			$sEventName = $aTempSelectChallenges[0][0]
			Click($aTempSelectChallenges[0][1], $aTempSelectChallenges[0][2])
			If _Sleep(1750) Then Return
			$g_bIsBBevent = $aTempSelectChallenges[0][5]
			If ClickOnEvent($g_bYourAccScoreCG, $aiScoreLimit, $sEventName, $getCapture) Then Return
			; Some error occurred let's click on Challenges Tab and proceeds
			ClickP($TabChallengesPosition, 2, 0, "#Tab")
		EndIf
	EndIf

	If $g_bChkClanGamesPurgeAny Then ; still have to purge, because no enabled event on setting found
		SetLog("Still have to purge, because no enabled event on setting found", $COLOR_WARNING)
		SetLog("No Event found, lets purge 1 most top event", $COLOR_WARNING)
		ForcePurgeEvent(False, True)
		CloseClanGames()
		If _Sleep(1000) Then Return
	Else
		SetLog("No Event found, Check your settings", $COLOR_WARNING)
		CloseClanGames()
		If _Sleep(2000) Then Return
	EndIf
EndFunc ;==>_ClanGames

; xbebenk
Func ClanGameImageCopy($sImagePath, $sTempPath, $sImageType = Default)
	Local $iBBT = -1, $s = ""
	Local $oBjs = BBCampsGet()

	If $sImageType = Default Then Return
	Local $bBuilderChallenge = True
	Switch $sImageType
		Case "D"
			For $i = 0 To UBound($g_aCGDestructionChallenges) - 1
				If $g_aCGDestructionChallenges[$i][3] > -1 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "DestructionChallenges: " & $g_aCGDestructionChallenges[$i][0], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $g_aCGDestructionChallenges[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "A"
			For $i = 0 To UBound($g_aCGAirTroopChallenges) - 1
				If $g_aCGAirTroopChallenges[$i][3] > -1 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "AirTroopChallenges: " & $g_aCGAirTroopChallenges[$i][0], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $g_aCGAirTroopChallenges[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "G"
			For $i = 0 To UBound($g_aCGGroundTroopChallenges) - 1
				If $g_aCGGroundTroopChallenges[$i][3] > -1 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "GroundTroopChallenges: " & $g_aCGGroundTroopChallenges[$i][0], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $g_aCGGroundTroopChallenges[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "BBD"
			If Not $bBuilderChallenge Then Return
			Local $bSkipWall = True
			For $s = 0 To UBound($oBjs) -1
				If TroopIndexLookupBB("Breaker", "Clan games BBD") = $oBjs[$s] Then
					$bSkipWall = False
					Exitloop
				EndIf
			Next
			
			For $i = 0 To UBound($g_aCGBBDestructionChallenges) - 1
				If $g_aCGBBDestructionChallenges[$i][3] > -1 Then
					If "WallDes" = $g_aCGBBDestructionChallenges[$i][0] And $bSkipWall = True Then ContinueLoop
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BBDestructionChallenges: " & $g_aCGBBDestructionChallenges[$i][0], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $g_aCGBBDestructionChallenges[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "BBT"
			If Not $bBuilderChallenge Then Return
			
			For $i = 0 To UBound($g_aCGBBTroopChallenges) - 1
				$iBBT = TroopIndexLookupBB($g_aCGBBTroopChallenges[$i][0], "Clan games BBT")
				If $iBBT < 0 Then ContinueLoop
				If $g_aCGBBTroopChallenges[$i][3] > -1 Then
					For $s = 0 To UBound($oBjs) -1
						If $iBBT <> $oBjs[$s] Then ContinueLoop
						If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BBTroopChallenges: " & $g_aCGBBTroopChallenges[$i][0], $COLOR_DEBUG)
						FileCopy($sImagePath & "\" & $sImageType & "-" & $g_aCGBBTroopChallenges[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
					Next
				EndIf
			Next
		Case "BBB"
			If Not $bBuilderChallenge Then Return

			For $i = 0 To UBound($g_aCGBBBattleChallenges) - 1
				If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BBBattleChallenges: " & $g_aCGBBBattleChallenges[$i][0], $COLOR_DEBUG)
				FileCopy($sImagePath & "\" & $sImageType & "-" & $g_aCGBBBattleChallenges[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
			Next
		Case "S"
			For $i = 0 To UBound($g_aCGSpellChallenges) - 1
				If $g_aCGSpellChallenges[$i][3] > -1 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "SpellChallenges: " & $g_aCGSpellChallenges[$i][0], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $g_aCGSpellChallenges[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case Else
			If $g_bChkClanGamesDebug Then SetLog("Rest Challenges: " & $sImageType & "-" & "*.xml", $COLOR_DEBUG)
			FileCopy($sImagePath & "\" & $sImageType & "-" & "*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
	EndSwitch
EndFunc ;==>ClanGameImageCopy

Func BBCampsGet()
	If Not $g_bRunState Then Return
	Local $bIsCampCSV = False
	Local $aLines[0]
	Local $iModeAttack = 0

	If ($g_iCmbBBAttack = $g_eBBAttackCSV) Then
		$iModeAttack = 0
		If ($g_bChkBBGetFromArmy = True) Then
			$iModeAttack = 1
		EndIf
	ElseIf ($g_iCmbBBAttack = $g_eBBAttackSmart) Then
		$iModeAttack = 1
		If ($g_bChkBBGetFromCSV = True) Then
			$iModeAttack = 0
		EndIf
	EndIf

	Local $sLastObj = "Barbarian", $sTmp
	Local $aFakeCsv[1]
	Do
		Switch $iModeAttack

			; CSV
			Case 0
				If Not $g_bChkBBCustomAttack Or ($g_iCmbBBAttack = $g_eBBAttackSmart) Then
					$g_iBuilderBaseScript = 0
				EndIf

				; Let load the Command [Troop] from CSV
				Local $aLArray[0]
				Local $FileNamePath = @ScriptDir & "\CSV\BuilderBase\" & $g_sAttackScrScriptNameBB[$g_iBuilderBaseScript] & ".csv"
				If FileExists($FileNamePath) Then $aLArray = FileReadToArray($FileNamePath)

				; Special case if CSV dont have camps.
				$iModeAttack = 1 ; CSV Mode
				Local $iLast = 0, $aSplitLine, $sName
				For $iLine = 0 To UBound($aLArray) - 1
					If Not $g_bRunState Then Return
					$aSplitLine = StringSplit(StringStripWS($aLArray[$iLine], $STR_STRIPALL), "|", $STR_NOCOUNT)

					If ($aSplitLine[0] = "CAMP") Then
						$iModeAttack = 0 ; CSV Mode
						$sName = "CAMP" & "|"
						For $i = 1 To UBound($aSplitLine) - 1
							If StringIsSpace($aSplitLine[$i]) = 1 Then ContinueLoop
							$iLast = TroopIndexLookupBB($aSplitLine[$i], "Clan Games 1")
							If $iLast > -1 Then
								$sTmp = $g_asAttackBarBB[$iLast]
								If Not StringIsSpace($sTmp) Then $sLastObj = $sTmp
								$sName &= $sLastObj
								If $i <> UBound($aSplitLine) - 1 Then $sName &= "|"
							EndIf
						Next
						$aFakeCsv[0] = $sName
						_ArrayAdd($aLines, $aFakeCsv)

						; ExitLoop 2
					EndIf
				Next

				If $iModeAttack <> 0 Then
					SetLog("You are bad at CSV writing, but we can correct that.", $COLOR_ERROR)
					ContinueCase
				EndIf

				ExitLoop
				; Smart
			Case Else
				Local $sName = "CAMP" & "|"
				For $i = 0 To UBound($g_iCmbCampsBB) - 1
					$sTmp = $g_asAttackBarBB[$g_iCmbCampsBB[$i]]
					If Not StringIsSpace($sTmp) Then $sLastObj = $sTmp
					$sName &= $sLastObj
					If $i <> UBound($g_iCmbCampsBB) - 1 Then $sName &= "|"
					$aFakeCsv[0] = $sName
					_ArrayAdd($aLines, $aFakeCsv)
				Next

				ExitLoop
		EndSwitch
	Until True

	If UBound($aLines) = 0 Then
		SetLog("BuilderBaseSelectCorrectScript 0x12 error.", $COLOR_ERROR)
		Return
	EndIf

	Local $oDicCamps = ObjCreate("Scripting.Dictionary")

	Local $aReturn[0]
	Local $aSplitLine = StringSplit(StringStripWS($aLines[UBound($aLines)-1], $STR_STRIPALL), "|", $STR_NOCOUNT)
	For $i = 1 To UBound($aSplitLine) -1
		If StringIsSpace($aSplitLine[$i]) Then ContinueLoop
		If Not $oDicCamps.Exists($aSplitLine[$i]) Then
			$oDicCamps($aSplitLine[$i]) = True
			_ArrayAdd($aReturn, TroopIndexLookupBB($aSplitLine[$i], "Clan games | 2"))
		EndIf
	Next

	Return $aReturn
EndFunc

Func IsClanGamesWindow($getCapture = True, $bOnlyCheck = False, $bFromBB = False)
	Local $sState, $bRet = False
	
	If Not IsMainPage(3) Then Return False
	
	$g_bIsCaravanOn = "False"
	If $bFromBB = False Then
		If QuickMIS("BC1", $g_sImgCaravan, 230, 55 + $g_iMidOffsetYFixed, 330, 155 + $g_iMidOffsetYFixed, $getCapture, False) Then ; Resolution changed
			SetLog("Caravan available! Entering Clan Games", $COLOR_SUCCESS)
			Click($g_iQuickMISX, $g_iQuickMISY)
		Else
			SetLog("Caravan not available", $COLOR_WARNING)
			$bRet = False
			$g_bIsCaravanOn = "False"
			Return $bRet
		EndIf
	EndIf
	
	; Just wait for window open
	If _Wait4Pixel(826, 34, 0xFFFFFF, 15, 2500, 250, "IsClanGamesWindow") Then
		
		$sState = IsClanGamesRunning()
		Switch $sState
			Case "prepare"
				$bRet = False
			Case "running"
				$bRet = True
				$g_bIsCaravanOn = "True"
			Case "end"
				$bRet = False
		EndSwitch
	
		SetLog("Clan Games Event is : " & $sState, $COLOR_INFO)
	
		If $bOnlyCheck = True Then
			CloseClanGames()
			If _Sleep(1500) Then Return
	
			CheckMainScreen(False, False)
		EndIf
	Else
		SetLog("Caravan bad pixel.", $COLOR_ERROR)
	EndIf
	
	If $bOnlyCheck = True Then CloseClanGames()
	Return $bRet
EndFunc   ;==>IsClanGamesWindow

; Close clan games with European lord manners.
Func CloseClanGames()
	If _Wait4Pixel(824, 31, 0xFFFFFF, 15, 1500, 250, "CloseClanGames") Then
		Click(824, 31) ;Close Window
	EndIf
	
	If IsMainPage(5) Then Return
	
	checkobstacles()

	; ClickAway() ;Click Away
EndFunc   ;==>CloseClanGames

Func IsClanGamesRunning($getCapture = True) ;to check whether clangames current state, return string of the state "prepare" "running" "end"
	Local $sState = "running"
	If QuickMIS("BC1", $g_sImgWindow, 70, 100 + $g_iMidOffsetYFixed, 150, 150 + $g_iMidOffsetYFixed, $getCapture, False) Then ; Resolution changed
		SetLog("Window Opened", $COLOR_DEBUG)
		If QuickMIS("BC1", $g_sImgReward, 580, 480 + $g_iBottomOffsetYFixed, 830, 570 + $g_iBottomOffsetYFixed, $getCapture, False) Then ; Resolution changed
			SetLog("Your Reward is Ready", $COLOR_INFO)
			$sState = "end"
		EndIf
	Else
		If _CheckPixel($g_aGameTime, True) Then
			Local $sTimeRemain = getOcrTimeGameTime(380, 461 + $g_iBottomOffsetYFixed) ; read Clan Games waiting time ; Resolution changed
			SetLog("Clan Games will start in " & $sTimeRemain, $COLOR_INFO)
			$g_sClanGamesTimeRemaining = $sTimeRemain
			$sState = "prepare"
		EndIf
		SetLog("Clan Games Window Not Opened", $COLOR_DEBUG)
		$sState = "Cannot open ClanGames"
	EndIf
	Return $sState
EndFunc ;==>IsClanGamesRunning

Func GetTimesAndScores()
	Local $sYourGameScore = "", $aiScoreLimit, $sTimeRemain = 0
	
	; Ocr for game time remaining
	; This Loop is just to check if the Score is changing , when you complete a previous events is necessary to take some time
	For $i = 0 To 10
		
		$sYourGameScore = getOcrYourScore(45, 530 + $g_iMidOffsetYFixed) ;  Read your Score ; resolution fixed
		If $g_bChkClanGamesDebug Then SetLog("Your OCR score: " & $sYourGameScore)
		
		;Check if OCR returned a valid timer format
		If StringInStr($sYourGameScore, "#") Then
			; read Clan Games waiting time ; resolution fixed
			$sTimeRemain = getOcrTimeGameTime(55, 470 + $g_iMidOffsetYFixed)
			
			If _IsValideOCR($sTimeRemain) Then
				$sTimeRemain = StringStripWS($sTimeRemain, $STR_STRIPALL)
				
				$sYourGameScore = StringReplace($sYourGameScore, "#", "/")
				$aiScoreLimit = StringSplit($sYourGameScore, "/", $STR_NOCOUNT)
				$aiScoreLimit[0] = Int($aiScoreLimit[0])
				$aiScoreLimit[1] = Int($aiScoreLimit[1])
				
				;Update Values
				$g_sClanGamesScore = $sYourGameScore
				$g_sClanGamesTimeRemaining = $sTimeRemain

				SetLog("Clan Games time remaining: " & $sTimeRemain, $COLOR_INFO)
				Return $aiScoreLimit
			EndIf
		EndIf
		
		If _Sleep(800) Then Return
		
		If _ColorCheck(_GetPixelColor(232, 344 + $g_iMidOffsetYFixed, True), Hex(0x4C84C4, 6), 15) Then ; Resolution fixed
			SetLog("[ClanGames] You need to joing a clan", $COLOR_WARNING)
			ExitLoop
		EndIf
	Next
	
	SetLog("[ClanGames] [GetTimesAndScores] failed", $COLOR_ERROR)
	Return -1
	
EndFunc   ;==>GetTimesAndScores

Func CooldownTime($getCapture = True)
	; Check IF exist the Gem icon
	;check cooldown purge
	If QuickMIS("BC1", $g_sImgCoolPurge, 172, 72, 831, 505, $getCapture, False) Then ; Resolution fixed
		SetLog("Cooldown Purge Detected", $COLOR_INFO)
		CloseClanGames()
		Return True
	EndIf
	Return False
EndFunc   ;==>CooldownTime

Func IsEventRunning($bOpenWindow = False)
	If $bOpenWindow Then
		CloseClanGames()
		SetLog("Entering Clan Games", $COLOR_INFO)
		If Not IsClanGamesWindow() Then Return
	EndIf

	; Check if any event is running or not
	If Not _ColorCheck(_GetPixelColor(304, 257 + $g_iMidOffsetYFixed, True), Hex(0x53E050, 6), 5) Then ; RC Done ; Green Bar from First Position
		SetLog("An Event is already in progress !", $COLOR_SUCCESS)
		If $g_bChkClanGamesDebug Then SetLog("[0]: " & _GetPixelColor(304, 257 + $g_iMidOffsetYFixed, True)) ; RC Done
		Return _IsEventRunning()
	Else
		SetLog("No event under progress", $COLOR_INFO)
	EndIf
	Return False
EndFunc   ;==>IsEventRunning

Func _IsEventRunning()
	;Check if Event failed
	If _CheckPixel($g_aEventFailed, True) Then
		SetLog("Couldn't finish last event! Lets trash it and look for a new one", $COLOR_INFO)
		If TrashFailedEvent() Then
			If _Sleep(3000) Then Return ;Add sleep here, to wait ClanGames Challenge Tile ordered again as 1 has been deleted
			Return False
		Else
			SetLog("Error happend while trashing failed event", $COLOR_ERROR)
			CloseClanGames()
			Return True
		EndIf
	ElseIf CooldownTime() Then
		; SetLog("An event purge cooldown in progress!", $COLOR_WARNING)
		; CloseClanGames()
		Return True
	Else

		; [0]=ChallengeName [1]=EventName [2]=Xaxis [3]=Yaxis, [4]=IsBBChallenge
		Local $aAllDetectionsOnScreen = ChallengeDetection(True)
		
		;check if its Enabled Challenge, if not = purge
		If UBound($aAllDetectionsOnScreen) > 0 Then ; Resolution changed
			SetLog("Active Challenge is Enabled on Setting, OK!!", $COLOR_DEBUG)
			;check if Challenge is BB Challenge, enabling force BB attack
			If $g_bChkForceBBAttackOnClanGames Then
	
				Click(340, 210 + $g_iMidOffsetYFixed)
				If _Sleep(1000) Then Return
				SetLog("Re-Check If Running Challenge is BB Event or No?", $COLOR_DEBUG)
				If QuickMIS("BC1", $g_sImgVersus, 425, 180 + $g_iMidOffsetYFixed, 700, 235 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
					Setlog("Running Challenge is BB Challenge", $COLOR_INFO)
					$g_bIsBBevent = True
				Else
					Setlog("Running Challenge is MainVillage Challenge", $COLOR_INFO)
					$g_bIsBBevent = False
				EndIf
			EndIf
		Else
			Setlog("Active Challenge Not Enabled on Setting! started by mistake?", $COLOR_ERROR)
			ForcePurgeEvent(False, False)
		EndIf

		CloseClanGames()
		Return True
	EndIf
	Return False
EndFunc   ;==>_IsEventRunning

Func IsBBChallenge($x, $y)

	Local $aBorderX[4] = [290, 416, 542, 668]
	Local $iColumn, $iRow, $bReturn

	Switch $x
		Case $aBorderX[0] To $aBorderX[1]
			$iColumn = 0
		Case $aBorderX[1] To $aBorderX[2]
			$iColumn = 1
		Case $aBorderX[1] To $aBorderX[3]
			$iColumn = 2
		Case Else
			$iColumn = 3
	EndSwitch

	If $g_bChkClanGamesDebug Then SetLog("Column : " & $iColumn, $COLOR_DEBUG)
	
	Local $iModeSet = -1, $hResultColor = 0
	Local $aColorsResult = [0x5C91CE, 0x78A9DD, 0x7DA9DD]
	Local $aColorsResultBB = [0x0D6685, 0x0D6083, 0x0D5A7F, 0x0D5A81]

	For $iX = $aBorderX[$iColumn] + 1 To $aBorderX[$iColumn] + 9
		
		$hResultColor = _GetPixelColor($iX, $y, False)
		$iModeSet = HexColorIndex($aColorsResult, $hResultColor, 25)
		If $iModeSet <> -1 Then
			Return False
		Else
			$iModeSet = HexColorIndex($aColorsResultBB, $hResultColor, 25)
			If $iModeSet <> -1 Then
				Return True
			EndIf
		EndIf
		
	Next
	
	Return False
EndFunc ;==>IsBBChallenge

Func ChallengeDetection($bOnlyScanAtOne = False)

	; To store the detections
	; [0]=ChallengeName [1]=EventName [2]=Xaxis [3]=Yaxis, [4]=IsBBChallenge
	Local $aAllDetectionsOnScreen[0][5]

	; we can make a image detection by row, can be faster
	If $bOnlyScanAtOne = False Then
		Local $aRows = ["300,111,760,201", "300,271,760,361", "300,360,760,506"]
	Else
		Local $aRows = ["300,90,760, 247"]
	EndIf
	
	; Temp Variables
	Local $sClanGamesWindow, $aCurrentDetection, $aEachDetection
	Local $FullImageName, $StringCoordinates, $sString, $tempObbj, $tempObbjs, $aNames
	
	_CaptureRegions()
	For $x = 0 To UBound($aRows) - 1

		If $g_bChkClanGamesDebug Then Setlog("Detecting the row number " & $x + 1)
		
		$sClanGamesWindow = GetDiamondFromRect($aRows[$x]) ; Contains iXStart, $iYStart, $iXEnd, $iYEnd
		$aCurrentDetection = findMultiple(@TempDir & "\" & $g_sProfileCurrentName & "\Challenges\", $sClanGamesWindow, "", 0, 1000, 0, "objectname,objectpoints", False)

		; Let's split Names and Coordinates and populate a new array
		If UBound($aCurrentDetection) > 0 Then

			For $i = 0 To UBound($aCurrentDetection) - 1
				If _Sleep(50) Then Return ; just in case of PAUSE
				If Not $g_bRunState Then Return ; Stop Button

				$aEachDetection = $aCurrentDetection[$i]
				; Justto debug
				SetDebugLog(_ArrayToString($aEachDetection))

				$FullImageName = String($aEachDetection[0])
				$StringCoordinates = $aEachDetection[1]

				If $FullImageName = "" Or $StringCoordinates = "" Then ContinueLoop

				; Exist more than One coordinate!?
				If StringInStr($StringCoordinates, "|") Then
					; Code to test the string if exist anomalies on string
					$StringCoordinates = StringReplace($StringCoordinates, "||", "|")
					$sString = StringRight($StringCoordinates, 1)
					If $sString = "|" Then $StringCoordinates = StringTrimRight($StringCoordinates, 1)
					; Split the coordinates
					$tempObbjs = StringSplit($StringCoordinates, "|", $STR_NOCOUNT)
					; Just get the first [0]
					$tempObbj = StringSplit($tempObbjs[0], ",", $STR_NOCOUNT) ;  will be a string : 708,360
					If UBound($tempObbj) <> 2 Then ContinueLoop
				Else
					$tempObbj = StringSplit($StringCoordinates, ",", $STR_NOCOUNT) ;  will be a string : 708,360
					If UBound($tempObbj) <> 2 Then ContinueLoop
				EndIf
	
				$aNames = StringSplit($FullImageName, "-", $STR_NOCOUNT)
				
				SetDebugLog("filename: " & $FullImageName & " $aNames[0] = " & $aNames[0] & " $aNames[1]= " & $aNames[1], $COLOR_ACTION)

				ReDim $aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) + 1][5]
				$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][0] = $aNames[0] ; Challenge Name
				$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][1] = $aNames[1] ; Event Name
				$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][2] = $tempObbj[0] ; Xaxis
				$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][3] = $tempObbj[1] ; Yaxis
				If $bOnlyScanAtOne = False Then $aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][4] = IsBBChallenge($tempObbj[0], $tempObbj[1])
			Next
		EndIf
	Next

	Return $aAllDetectionsOnScreen
EndFunc

Func ClickOnEvent(ByRef $g_bYourAccScoreCG, $ScoreLimits, $sEventName, $getCapture)
	If Not $g_bYourAccScoreCG[$g_iCurAccount][1] Then
		Local $Text = "", $color = $COLOR_SUCCESS
		If $g_bYourAccScoreCG[$g_iCurAccount][0] <> $ScoreLimits[0] Then
			$Text = "You on " & $ScoreLimits[0] - $g_bYourAccScoreCG[$g_iCurAccount][0] & "points in last Event"
		Else
			$Text = "You could not complete the last event!"
			$color = $COLOR_WARNING
		EndIf
		SetLog($Text, $color)
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - " & $Text)
	EndIf
	$g_bYourAccScoreCG[$g_iCurAccount][1] = False
	$g_bYourAccScoreCG[$g_iCurAccount][0] = $ScoreLimits[0]
	If $g_bChkClanGamesDebug Then SetLog("ClickOnEvent $g_bYourAccScoreCG[" & $g_iCurAccount & "][1]: " & $g_bYourAccScoreCG[$g_iCurAccount][1])
	If $g_bChkClanGamesDebug Then SetLog("ClickOnEvent $g_bYourAccScoreCG[" & $g_iCurAccount & "][0]: " & $g_bYourAccScoreCG[$g_iCurAccount][0])
	If Not StartsEvent($sEventName, False, $getCapture, $g_bChkClanGamesDebug) Then Return False
	CloseClanGames()
	Return True
EndFunc   ;==>ClickOnEvent

Func StartsEvent($sEventName, $g_bPurgeJob = False, $getCapture = True, $g_bChkClanGamesDebug = False)
	If Not $g_bRunState Then Return

	Local $aStartButton = StartButton(True, $getCapture)
	If IsArray($aStartButton) Then
		Local $Timer = GetEventTimeInMinutes($aStartButton[0], $aStartButton[1])
		If $g_bPurgeJob = False Then SetLog("Starting Event" & " [" & $Timer & " min]" & " Is builder base challenge? " & $g_bIsBBevent, $COLOR_SUCCESS)
		Click($aStartButton[0], $aStartButton[1])
		GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $Timer & " min", 1)
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $Timer & " min")

		If $g_bPurgeJob Then
			If _Sleep(2500) Then Return
			If QuickMIS("BC1", $g_sImgTrashPurge, 400, 200 + $g_iMidOffsetYFixed, 700, 350 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1500) Then Return
				SetLog("Click Trash", $COLOR_INFO)
				If QuickMIS("BC1", $g_sImgOkayPurge, 440, 400 + $g_iMidOffsetYFixed, 580, 450 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
					SetLog("Click OK", $COLOR_INFO)
					Click($g_iQuickMISX, $g_iQuickMISY)
					SetLog("StartsEvent and Purge job!", $COLOR_SUCCESS)
                    GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - Purging Event ", 1)
                    _FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Purging Event ")
					CloseClanGames()
				Else
					SetLog("[StartsEvent] $g_sImgOkayPurge Issue", $COLOR_ERROR)
					Return False
				EndIf
			Else
				SetLog("[StartsEvent] $g_sImgTrashPurge Issue", $COLOR_ERROR)
				Return False
			EndIf
		EndIf

		Return True
	Else
		SetLog("Didn't Get the Green Start Button Event", $COLOR_WARNING)
		If $g_bChkClanGamesDebug Then SetLog("[X: " & 220 & " Y:" & 150 & " X1: " & 830 & " Y1: " & 580 & "]", $COLOR_WARNING)
		CloseClanGames()
		Return False
	EndIf

EndFunc   ;==>StartsEvent

Func StartButton($bGetEventType = True, $getCapture = True)
    Local $aButtonPixel[2]
    If QuickMIS("BC1", $g_sImgStart, 220, 150 + $g_iMidOffsetYFixed, 830, 580 + $g_iBottomOffsetYFixed, $getCapture, False) Then ; Resolution changed
		$aButtonPixel[0] = $g_iQuickMISX
		$aButtonPixel[1] = $g_iQuickMISY
		Return $aButtonPixel
	Else
		SetLog("Bad $g_sImgStart.", $COLOR_ERROR)
	EndIf
	Return 0
EndFunc   ;==>StartButton

Func PurgeEvent($directoryImage, $sEventName, $getCapture = True)
	SetLog("Checking Builder Base Challenges to Purge", $COLOR_DEBUG)
	; Screen coordinates for ScreenCapture
	Local $x = 281, $y = 150 + $g_iMidOffsetYFixed, $x1 = 775, $y1 = 545 + $g_iBottomOffsetYFixed ; Resolution changed
	If QuickMIS("BC1", $directoryImage, $x, $y, $x1, $y1, $getCapture, False) Then
		Click($g_iQuickMISX, $g_iQuickMISY)
		; Start and Purge at same time
		SetLog("Starting Impossible Job to purge", $COLOR_INFO)
		If _Sleep(1500) Then Return
		If StartsEvent($sEventName, True, $getCapture, $g_bChkClanGamesDebug) Then
			CloseClanGames()
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>PurgeEvent

Func ForcePurgeEvent($bTest = False, $startFirst = True)
	Local $SearchArea

	Click(340, 200 + $g_iMidOffsetYFixed) ;Most Top Challenge

	If _Sleep(1500) Then Return
	If $startFirst Then
		SetLog("ForcePurgeEvent: No event Found, Start and Purge a Challenge", $COLOR_INFO)
		If StartAndPurgeEvent($bTest) Then
			CloseClanGames()
			Return True
		EndIf
	Else
		SetLog("ForcePurgeEvent: Purge a Wrong Challenge", $COLOR_INFO)
		If QuickMIS("BC1", $g_sImgTrashPurge, 400, 200 + $g_iMidOffsetYFixed, 700, 350 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1200) Then Return
			SetLog("Click Trash", $COLOR_INFO)
			If QuickMIS("BC1", $g_sImgOkayPurge, 440, 400 + $g_iMidOffsetYFixed, 580, 450 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
				SetLog("Click OK", $COLOR_INFO)
				If $bTest Then Return
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1500) Then Return
			Else
                GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - ForcePurgeEvent: Purge a Wrong Challenge ", 1)
                _FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - ForcePurgeEvent: Purge a Wrong Challenge ")
				SetLog("$g_sImgOkayPurge Issue", $COLOR_ERROR)
				Return False
			EndIf
		Else
			SetLog("$g_sImgTrashPurge Issue", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
	Return False
EndFunc   ;==>ForcePurgeEvent

Func StartAndPurgeEvent($bTest = False)

	Local $aStartButton = StartButton(False)
	If IsArray($aStartButton) Then
		Local $Timer = GetEventTimeInMinutes($aStartButton[0], $aStartButton[1])
		SetLog("Starting  Event" & " [" & $Timer & " min]", $COLOR_SUCCESS)
		Click($aStartButton[0], $aStartButton[1])
		GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - Starting Purge for " & $Timer & " min", 1)
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Starting Purge for " & $Timer & " min")

		If _Sleep(2500) Then Return
		If QuickMIS("BC1", $g_sImgTrashPurge, 400, 200 + $g_iMidOffsetYFixed, 700, 350 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(2000) Then Return
			SetLog("Click Trash", $COLOR_INFO)
			If QuickMIS("BC1", $g_sImgOkayPurge, 440, 400 + $g_iBottomOffsetYFixed, 580, 450 + $g_iBottomOffsetYFixed, True, False) Then ; Resolution changed
				SetLog("Click OK", $COLOR_INFO)
				If $bTest Then Return
				Click($g_iQuickMISX, $g_iQuickMISY)
				SetLog("StartAndPurgeEvent event!", $COLOR_SUCCESS)
                GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - StartAndPurgeEvent: No event Found ", 1)
                _FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - StartAndPurgeEvent: No event Found ")
				CloseClanGames()
			Else
				SetLog("[StartAndPurgeEvent] $g_sImgOkayPurge Issue", $COLOR_ERROR)
				Return False
			EndIf
		Else
			SetLog("[StartAndPurgeEvent] $g_sImgTrashPurge Issue", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
	Return True
EndFunc

Func TrashFailedEvent()
	;Look for the red cross on failed event
	If Not ClickB("EventFailed") Then
		SetLog("Could not find the failed event icon!", $COLOR_ERROR)
		Return False
	EndIf

	If _Sleep(1000) Then Return

	;Look for the red trash event Button and press it
	If Not ClickB("TrashEvent") Then
		SetLog("Could not find the trash event button!", $COLOR_ERROR)
		Return False
	EndIf

	If _Sleep(500) Then Return
	Return True
EndFunc   ;==>TrashFailedEvent

Func _IsValideOCR($sString)

	If StringInStr($sString, "d") > 0 Or _
			StringInStr($sString, "h") > 0 Or _
			StringInStr($sString, "m") > 0 Or _
			StringInStr($sString, "s") > 0 Then Return True

	Return False
EndFunc   ;==>_IsValideOCR

Func OcrToMinutes($sStringOCR)

	If Not _IsValideOCR($sStringOCR) Then Return 0

	Local $temp, $d, $h, $m

	If StringInStr($sStringOCR, "d") > 0 Then
		$temp = StringSplit($sStringOCR, "d", $STR_NOCOUNT)
		$d = Int($temp[0])
		$h = Int(StringReplace($temp[1], "h", ""))
		Return ($d * 24) * 60 + ($h * 60)
	ElseIf StringInStr($sStringOCR, "h") > 0 Then
		$temp = StringSplit($sStringOCR, "h", $STR_NOCOUNT)
		$h = Int($temp[0])
		$m = Int(StringReplace($temp[1], "m", ""))
		Return ($h * 60) + $m
	ElseIf StringInStr($sStringOCR, "m") > 0 Then
		$temp = StringSplit($sStringOCR, "m", $STR_NOCOUNT)
		Return Int($temp[0])
	ElseIf StringInStr($sStringOCR, "s") > 0 Then
		Return 1
	EndIf

	Return 0
EndFunc   ;==>OcrToMinutes

Func GetEventTimeInMinutes($iXStartBtn, $iYStartBtn, $bIsStartBtn = True)

	Local $XAxis = $iXStartBtn - 163 ; Related to Start Button
	Local $YAxis = $iYStartBtn + 8 ; Related to Start Button

	If Not $bIsStartBtn Then
		$XAxis = $iXStartBtn - 163 ; Related to Trash Button
		$YAxis = $iYStartBtn + 8 ; Related to Trash Button
	EndIf

	Local $iOcr = getOcrEventTime($XAxis, $YAxis)
	Local $iOcrToMinutes = OcrToMinutes($iOcr)
	If $iOcrToMinutes = 0 Then $iOcrToMinutes = 1440
	Return $iOcrToMinutes

EndFunc   ;==>GetEventTimeInMinutes

Func GetEventInformation()
	Local $aStartButton = StartButton(False)
	If IsArray($aStartButton) Then
		Return GetEventTimeInMinutes($aStartButton[0], $aStartButton[1])
	Else
		Return 0
	EndIf
EndFunc   ;==>GetEventInformation

; Just for any button test
Func ClanGames($bTest = False)
	Local $bWasRunState = $g_bRunState
	$g_bRunState = True
	Local $temp = $g_bChkClanGamesDebug
	Local $debug = $g_bDebugSetlog
	$g_bDebugSetlog = True
	$g_bChkClanGamesDebug = True
	Local $tempCurrentTroops = $g_aiCurrentTroops
	For $i = 0 To UBound($g_aiCurrentTroops) - 1
		$g_aiCurrentTroops[$i] = 50
	Next
	Local $Result = _ClanGames(True)
	$g_aiCurrentTroops = $tempCurrentTroops
	$g_bRunState = $bWasRunState
	$g_bChkClanGamesDebug = $temp
	$g_bDebugSetlog = $debug
	Return $Result
EndFunc   ;==>ClanGames

Func SaveClanGamesConfig()
	ApplyConfig_ClanGames(GetApplyConfigSaveAction())

	Local $aChallengesClanGamesVars = [$g_aCGLootChallenges, $g_aCGAirTroopChallenges, $g_aCGGroundTroopChallenges, $g_aCGBattleChallenges, $g_aCGDestructionChallenges, $g_aCGMiscChallenges, $g_aCGSpellChallenges, $g_aCGBBBattleChallenges, $g_aCGBBDestructionChallenges, $g_aCGBBTroopChallenges]
	Local $ahChallengesClanGamesVarsHandle = [$g_hCGLootChallenges, $g_hCGAirTroopChallenges, $g_hCGGroundTroopChallenges, $g_hCGBattleChallenges, $g_hCGDestructionChallenges, $g_hCGMiscChallenges, $g_hCGSpellChallenges, $g_hCGBBBattleChallenges, $g_hCGBBDestructionChallenges, $g_hCGBBTroopChallenges]

	_Ini_Clear()

	Local $aTmp, $iKey, $ah
	; Loop through the CG strings
	For $i = 0 To UBound($g_aChallengesClanGamesStrings) - 1

		; Loop through the CG Vars
		$aTmp = $aChallengesClanGamesVars[$i]
		$ah = $ahChallengesClanGamesVarsHandle[$i]

		For $j = 0 To UBound($aTmp) - 1

			; Write the new value to the file
			_Ini_Add($g_aChallengesClanGamesStrings[$i], $aTmp[$j][1], $aTmp[$j][3])

			; If Int($ah[$j]) = 0 Then ContinueLoop ; Handle GUI always have num ref, skip no implemented.

			; Write boolean status
			; _Ini_Add($g_aChallengesClanGamesStrings[$i], $aTmp[$j][1] & " Chk", $aTmp[$j][5])

		Next

	Next

	_Ini_Save($g_sProfileClanGamesPath)
EndFunc   ;==>SaveClanGamesConfig

Func ApplyConfig_ClanGames($TypeReadSave)
	Local $ahChallengesClanGamesVarsHandle = [$g_hCGLootChallenges, $g_hCGAirTroopChallenges, $g_hCGGroundTroopChallenges, $g_hCGBattleChallenges, $g_hCGDestructionChallenges, $g_hCGMiscChallenges, $g_hCGSpellChallenges, $g_hCGBBBattleChallenges, $g_hCGBBDestructionChallenges, $g_hCGBBTroopChallenges]

	Local $aTmp
	; Loop through the CG strings
	For $i = 0 To UBound($g_aChallengesClanGamesStrings) - 1
		Local $ah = $ahChallengesClanGamesVarsHandle[$i]
		For $j = 0 To UBound($ah) - 1
			If Int($ah[$j]) = 0 Then ContinueLoop ; Handle GUI always have num ref, skip no implemented.
			ApplyConfig_ClanGamesSwitch($TypeReadSave, $g_aChallengesClanGamesStrings[$i], $j, 3) ; Skip autoit limits.
		Next

	Next
EndFunc   ;==>ApplyConfig_ClanGames

Func ApplyConfig_ClanGamesSwitch($TypeReadSave, $sTring, $i, $j)
	Switch $TypeReadSave
		Case "Read"
			Switch $sTring
				Case "Loot Challenges"
					GUICtrlSetState($g_hCGLootChallenges[$i], ($g_aCGLootChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case "Air Troop Challenges"
					GUICtrlSetState($g_hCGAirTroopChallenges[$i], ($g_aCGAirTroopChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case "Ground Troop Challenges"
					GUICtrlSetState($g_hCGGroundTroopChallenges[$i], ($g_aCGGroundTroopChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case "Battle Challenges"
					GUICtrlSetState($g_hCGBattleChallenges[$i], ($g_aCGBattleChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case "Destruction Challenges"
					GUICtrlSetState($g_hCGDestructionChallenges[$i], ($g_aCGDestructionChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case "Misc Challenges"
					GUICtrlSetState($g_hCGMiscChallenges[$i], ($g_aCGMiscChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case "Spell Challenges"
					GUICtrlSetState($g_hCGSpellChallenges[$i], ($g_aCGSpellChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case "BB Battle Challenges"
					GUICtrlSetState($g_hCGBBBattleChallenges[$i], ($g_aCGBBBattleChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case "BB Destruction Challenges"
					GUICtrlSetState($g_hCGBBDestructionChallenges[$i], ($g_aCGBBDestructionChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case "BB Troop Challenges"
					GUICtrlSetState($g_hCGBBTroopChallenges[$i], ($g_aCGBBTroopChallenges[$i][$j] > -1) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
				Case Else
					SetLog("Badly SaveApply: " & $sTring, $COLOR_ERROR)
			EndSwitch
		Case "Save"
			Switch $sTring
				Case "Loot Challenges"
					$g_aCGLootChallenges[$i][$j] = (GUICtrlRead($g_hCGLootChallenges[$i]) = $GUI_UNCHECKED) ? Abs($g_aCGLootChallenges[$i][$j]) : -Abs($g_aCGLootChallenges[$i][$j])
				Case "Air Troop Challenges"
					$g_aCGAirTroopChallenges[$i][$j] = (GUICtrlRead($g_hCGAirTroopChallenges[$i]) = $GUI_CHECKED) ? Abs($g_aCGAirTroopChallenges[$i][$j]) : -Abs($g_aCGAirTroopChallenges[$i][$j])
				Case "Ground Troop Challenges"
					$g_aCGGroundTroopChallenges[$i][$j] = (GUICtrlRead($g_hCGGroundTroopChallenges[$i]) = $GUI_CHECKED) ? Abs($g_aCGGroundTroopChallenges[$i][$j]) : -Abs($g_aCGGroundTroopChallenges[$i][$j])
				Case "Battle Challenges"
					$g_aCGBattleChallenges[$i][$j] = (GUICtrlRead($g_hCGBattleChallenges[$i]) = $GUI_CHECKED) ? Abs($g_aCGBattleChallenges[$i][$j]) : -Abs($g_aCGBattleChallenges[$i][$j])
				Case "Destruction Challenges"
					$g_aCGDestructionChallenges[$i][$j] = (GUICtrlRead($g_hCGDestructionChallenges[$i]) = $GUI_CHECKED) ? Abs($g_aCGDestructionChallenges[$i][$j]) : -Abs($g_aCGDestructionChallenges[$i][$j])
				Case "Misc Challenges"
					$g_aCGMiscChallenges[$i][$j] = (GUICtrlRead($g_hCGMiscChallenges[$i]) = $GUI_CHECKED) ? Abs($g_aCGMiscChallenges[$i][$j]) : -Abs($g_aCGMiscChallenges[$i][$j])
				Case "Spell Challenges"
					$g_aCGSpellChallenges[$i][$j] = (GUICtrlRead($g_hCGSpellChallenges[$i]) = $GUI_CHECKED) ? Abs($g_aCGSpellChallenges[$i][$j]) : -Abs($g_aCGSpellChallenges[$i][$j])
				Case "BB Battle Challenges"
					$g_aCGBBBattleChallenges[$i][$j] = (GUICtrlRead($g_hCGBBBattleChallenges[$i]) = $GUI_CHECKED) ? Abs($g_aCGBBBattleChallenges[$i][$j]) : -Abs($g_aCGBBBattleChallenges[$i][$j])
				Case "BB Destruction Challenges"
					$g_aCGBBDestructionChallenges[$i][$j] = (GUICtrlRead($g_hCGBBDestructionChallenges[$i]) = $GUI_CHECKED) ? Abs($g_aCGBBDestructionChallenges[$i][$j]) : -Abs($g_aCGBBDestructionChallenges[$i][$j])
				Case "BB Troop Challenges"
					$g_aCGBBTroopChallenges[$i][$j] = (GUICtrlRead($g_hCGBBTroopChallenges[$i]) = $GUI_CHECKED) ? Abs($g_aCGBBTroopChallenges[$i][$j]) : -Abs($g_aCGBBTroopChallenges[$i][$j])
				Case Else
					SetLog("Badly SaveApply: " & $sTring, $COLOR_ERROR)
			EndSwitch
		EndSwitch
EndFunc   ;==>ApplyConfig_ClanGamesSwitch

Func ClanGamesStatus()
	If Not $g_bChkClanGamesEnabled Then Return "False"
	
	If $g_bYourAccScoreCG[Int($g_iCurAccount)][2] = True Then
		SetLog("Maximum number of points achieved in clan games.", $COLOR_SUCCESS)
		Return "False"
	EndIf

	Switch $g_bIsCaravanOn
		Case "False"
			Return "False"
		Case "True"
			Return "True"
	EndSwitch

	Return "Undefined"
EndFunc
