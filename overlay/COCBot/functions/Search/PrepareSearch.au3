; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareSearch
; Description ...: Goes into searching for a match, breaks shield if it has to
; Syntax ........: PrepareSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #4
; Modified ......: KnowJack (Aug 2015), MonkeyHunter(2015-12)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func PrepareSearch($iMode = $DB)
	Local $bReturn = _PrepareSearch($iMode)
	If  $g_bLegendLeagueFindingOpponents Or $g_bLegendLeagueAttacksDone Or ($g_bTakedBonus = True And $g_bExitIfIsTakedBonus = True) Then
		CloseClanGames()
		$g_bRestart = True
		$g_bForceSwitch = True
		Return False
	EndIf
	Return $bReturn
EndFunc

Func _PrepareSearch($Mode = $DB) ;Click attack button and find match button, will break shield
	Local $aislegendleagueattackscreen[4] = [690, 275, 0x6131A7, 20]
	Local $aislegendleaguecomplete[4] = [556, 483, 0x3583F3, 10]
	Local $aislegendleaguesignup[4] = [556, 417, 0x3583F3, 10]
	Local $islegendleaguesignupbtn[2] = [556, 417]
	Local $aislegendleaguesignupok[4] = [515, 366, 0xDFF887, 10]
	Local $islegendleaguesignupokbtn[2] = [515, 366]
	Local $aattacknowwindowgreenbutton[4] = [690, 425, 0x69B231, 20]

	SetLog("Going to Attack", $COLOR_INFO)

	; RestartSearchPickupHero - Check Remaining Heal Time
	If $g_bSearchRestartPickupHero And $Mode <> $DT Then
		For $pTroopType = $eKing To $eChampion ; check all 4 hero
			For $pMatchMode = $DB To $g_iModeCount - 1 ; check all attack Modes
				If IsUnitUsed($pMatchMode, $pTroopType) Then
					If Not _DateIsValid($g_asHeroHealTime[$pTroopType - $eKing]) Then
						getArmyHeroTime("All", True, True)
						ExitLoop 2
					EndIf
				EndIf
			Next
		Next
	EndIf

	If chkattackcsvconfig() Then
		SetLog("Bot is stopped due to Script file missing.", $COLOR_INFO)
		Return
	EndIf
	
	If isMainPage() Then
		ZoomOut()
		If _Sleep($DELAYTREASURY4) Then Return
		If _CheckPixel($aAttackForTreasury, $g_bCapturePixel, Default, "Is attack for treasury:") Then
			SetLog("It isn't attack for Treasury", $COLOR_SUCCESS)
			$g_bTakedBonus = True
			If $g_bExitIfIsTakedBonus = True Then
				SetLog("Exit if is taked bonus enabled", $COLOR_SUCCESS)
				Return
			EndIf
		EndIf
		If _Sleep($DELAYTREASURY4) Then Return
		ClickP($aattackbutton, 1, 0, "#0149")
	EndIf
	
	If _Sleep($DELAYPREPARESEARCH1) Then Return
	Local $bIsPageError = Not IsWindowOpen($g_sImgGeneralCloseButton, 10, 200, GetDiamondFromRect("716,1,860,179"))
	If $bIsPageError = True Then  ; Resolution changed
		SetLog("Launch attack Page Fail", $COLOR_ERROR)
	Else
		$g_bLeagueAttack = _CheckPixel($aIsLegendLeagueAttackScreen, True, Default, "IsLegendLeague")
		If Not $g_bLeagueAttack Then
			If _CheckPixel($aIsLegendLeagueSignUp, True, Default, "SignUpLegendLeague") Then
				SetLog("Let's Sing-Up at Legends League!", $COLOR_SUCCESS)
				$g_bLeagueAttack = True
				ClickP($IsLegendLeagueSignupBtn, 1, 0, "#0149")
				If _Sleep($DELAYPREPARESEARCH2) Then Return
				If _CheckPixel($aIsLegendLeagueSignUpOk, True, Default, "SignUpLegendLeagueOkBtn") Then
					ClickP($IsLegendLeagueSignupBtn, 1, 0, "#0149")
					If _Sleep($DELAYPREPARESEARCH2) Then Return
					$g_bLegendLeagueFindingOpponents = True
					Return
				EndIf
			EndIf
		EndIf
		If _CheckPixel($aIsLegendLeagueComplete, True, Default, "CompleteDailyLegendLeague") Then
			SetLog("All of today's attacks are complete!", $COLOR_SUCCESS)
			SetDebugLog("$aIsLegendLeagueComplete pixel checked")
			If _Sleep($DELAYPREPARESEARCH2) Then Return
			If Not $g_bLeagueAttack Then
				SetDebugLog("Last verification in Legend League was False!!", $COLOR_ERROR)
				SetDebugLog("Detected the Blue List icon!", $COLOR_ERROR)
				$g_bLeagueAttack = True
			EndIf
			$g_bLegendLeagueAttacksDone = True
			Return
		EndIf
		Local $aiMatch = _PixelSearch(650, 355 + $g_iMidOffsetYFixed, 730, 545 + $g_iBottomOffsetYFixed, Hex(0xC95918, 6), 30)
		If UBound($aiMatch) > 1 And Not @error Then
			$g_bLegendLeagueAttacksDone = False
			$g_bLegendLeagueFindingOpponents = False
			$g_bCloudsActive = True
			If $g_iTownhallLevel <> "" And $g_iTownhallLevel > 0 Then
				$g_iSearchCost += $g_aiSearchCost[$g_iTownhallLevel - 1]
				$g_iStatsTotalGain[$elootgold] -= $g_aiSearchCost[$g_iTownhallLevel - 1]
			EndIf
			UpdateStats()
			
			If $g_bLeagueAttack Then
				Local $sAttackStates = getocroveralldamage(671, 451)
				If StringLen($sAttackStates) = 2 Then
					SetLog("Legend League " & StringLeft($sAttackStates, 1) & "/" & StringRight($sAttackStates, 1) & " Attacks Available", $COLOR_INFO)
				EndIf
			EndIf

			Click($aiMatch[0], $aiMatch[1])
			SetDebugLog("Founded Match Button", $COLOR_SUCCESS)
			
			If $g_bLeagueAttack Then
				If _wait4pixel($aattacknowwindowgreenbutton[0], $aattacknowwindowgreenbutton[1], $aattacknowwindowgreenbutton[2], $aattacknowwindowgreenbutton[3], 10000, "IsAttackNowWindow") Then
					Click($aattacknowwindowgreenbutton[0], $aattacknowwindowgreenbutton[1])
					SetDebugLog("Founded Attack now Button", $COLOR_SUCCESS)
					If _Sleep($DELAYPREPARESEARCH1) Then Return
				Else
					SetDebugLog("Unable to find Legend League attack now window.", $COLOR_ERROR)
					SaveDebugImage("IsAttackNowWindow")
				EndIf
			EndIf
		Else
			If $g_bLeagueAttack Then
				For $i = 0 To 3
					Local $aiMatch = _PixelSearch(510, 335, 660, 500, Hex(0x6E460E, 6), 15)
					If UBound($aiMatch) > 1 And Not @error Then
						SetLog("Finding Opponents, Let's do other work!", $COLOR_INFO)
						$g_bLegendLeagueFindingOpponents = True
						ExitLoop
					Else
						If _CheckPixel($aIsLegendLeagueSignUp, True, Default, "SignUpLegendLeague") Then
							SetLog("Let's Sing-Up at Legends League!", $COLOR_SUCCESS)
							$g_bLeagueAttack = True
							ClickP($IsLegendLeagueSignupBtn, 1, 0, "#0149")
							If _Sleep($DELAYPREPARESEARCH2) Then Return
							If _CheckPixel($aIsLegendLeagueSignUpOk, True, Default, "SignUpLegendLeagueOkBtn") Then
								ClickP($IsLegendLeagueSignupBtn, 1, 0, "#0149")
								If _Sleep($DELAYPREPARESEARCH2) Then Return
								ExitLoop
							EndIf
						EndIf
						If _CheckPixel($aIsLegendLeagueComplete, True, Default, "CompleteDailyLegendLeague") Then
							SetLog("All of today's attacks are complete!", $COLOR_SUCCESS)
							SetDebugLog("$g_sImgLegendFindingOppoentents _PixelSearch checked")
							$g_bLegendLeagueAttacksDone = True
							ExitLoop
						EndIf
					EndIf
					If _Sleep(3000) Then Return
				Next
				Return
			Else
				SetLog("Unable to find match button.", $COLOR_ERROR)
				$bIsPageError = True
			EndIf
		EndIf
	EndIf
	If $bIsPageError Then
		SaveDebugImage("IsAttackNowWindow")
		Androidpageerror("PrepareSearch")
		checkMainScreen()
		$g_bRestart = True
		$g_bIsClientSyncError = False
		Return
	EndIf
	
	If _Sleep($DELAYPREPARESEARCH2) Then Return
	
	Local $Result = getAttackDisable(180, 156) ; Grab Ocr for TakeABreak check
	If IsGemOpen(True) = True Then
		SetLog(" Not enough gold to start searching.....", $COLOR_ERROR)
		Click(585, 252, 1, 0, "#0151")
		If _Sleep($DELAYPREPARESEARCH1) Then Return
		Click(822, 32, 1, 0, "#0152")
		If _Sleep($DELAYPREPARESEARCH1) Then Return
		$g_bOutOfGold = True
	EndIf
	
	checkAttackDisable($g_iTaBChkAttack, $Result) ;See If TakeABreak msg on screen

	SetDebugLog("PrepareSearch exit check $g_bRestart= " & $g_bRestart & ", $g_bOutOfGold= " & $g_bOutOfGold, $COLOR_DEBUG)

	If $g_bRestart Or $g_bOutOfGold Then ; If we have one or both errors, then return
		$g_bIsClientSyncError = False ; reset fast restart flag to stop OOS mode, collecting resources etc.
		Return
	EndIf
	If IsAttackWhileShieldPage(False) Then ; check for shield window and then button to lose time due attack and click okay
		Local $offColors[3][3] = [[0x000000, 144, 1], [0xFFFFFF, 54, 17], [0xFFFFFF, 54, 28]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
		Local $ButtonPixel = _MultiPixelSearch(359, 404 + $g_iMidOffsetY, 510, 445 + $g_iMidOffsetY, 1, 1, Hex(0x000000, 6), $offColors, 20) ; first vertical black pixel of Okay
		SetDebugLog("Shield btn clr chk-#1: " & _GetPixelColor(441, 344 + $g_iMidOffsetY, True) & ", #2: " & _
				_GetPixelColor(441 + 144, 344 + $g_iMidOffsetY, True) & ", #3: " & _GetPixelColor(441 + 54, 344 + 17 + $g_iMidOffsetY, True) & ", #4: " & _
				_GetPixelColor(441 + 54, 344 + 10 + $g_iMidOffsetY, True), $COLOR_DEBUG)
		If IsArray($ButtonPixel) Then
			If $g_bDebugSetlog Then
				SetDebugLog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
				SetDebugLog("Shld Btn Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 17, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 27, True), $COLOR_DEBUG)
			EndIf
			Click($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 1, 0, "#0153") ; Click Okay Button
		EndIf
	EndIf
EndFunc   ;==>PrepareSearch
