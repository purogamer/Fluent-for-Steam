; #FUNCTION# ====================================================================================================================
; Name ..........: ReturnHome
; Description ...: Returns home when in battle, will take screenshot and check for gold/elixir change unless specified not to.
; Syntax ........: ReturnHome([$TakeSS = 1[, $GoldChangeCheck = True]])
; Parameters ....: $TakeSS              - [optional] flag for saving a snapshot of the winning loot. Default is 1.
;                  $GoldChangeCheck     - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (07-2015), MonkeyHunter (01-2016), CodeSlinger69 (01-2017), MonkeyHunter (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ReturnHome($TakeSS = 1, $GoldChangeCheck = True) ;Return main screen
	SetDebugLog("ReturnHome function... (from matchmode=" & $g_iMatchMode & " - " & $g_asModeText[$g_iMatchMode] & ")", $COLOR_DEBUG)
	Local $counter = 0
	Local $hBitmap_Scaled
	Local $i, $j
	Local $aiSurrenderButton

	If $g_bDESideDisableOther And $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable And ($g_bDropQueen Or $g_bDropKing) Then
	; If $g_bDESideDisableOther And $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable And ($g_bDropQueen Or $g_bDropKing) Or (($g_bLeagueAttack Or $g_bForceProtectLL) And $g_bProtectInLL) Then
		SaveandDisableEBO()
		SetLog("Disabling Normal End Battle Options", $COLOR_SUCCESS)
		; If (($g_bLeagueAttack Or $g_bForceProtectLL) And $g_bProtectInLL) Then SetLog("Legends league protection activated by default or forced.", $COLOR_WARNING)
	EndIf

	If $GoldChangeCheck Then
		If Not (IsReturnHomeBattlePage(True, False)) Then ; if already in return home battle page do not wait and try to activate Hero Ability and close battle
			SetLog("Checking if the battle has finished", $COLOR_INFO)
			While GoldElixirChangeEBO()
				If _Sleep($DELAYRETURNHOME1) Then Return
			WEnd
			If IsAttackPage() Then SmartZap(-1, True) ; Check to see if we should zap the DE Drills ; Custom SmartZap - Team AIO Mod++
			;If Heroes were not activated: Hero Ability activation before End of Battle to restore health
			If ($g_bCheckKingPower Or $g_bCheckQueenPower Or $g_bCheckWardenPower Or $g_bCheckChampionPower) Then
				;_CaptureRegion()
				If _ColorCheck(_GetPixelColor($aRtnHomeCheck1[0], $aRtnHomeCheck1[1], True), Hex($aRtnHomeCheck1[2], 6), $aRtnHomeCheck1[3]) = False And _ColorCheck(_GetPixelColor($aRtnHomeCheck2[0], $aRtnHomeCheck2[1], True), Hex($aRtnHomeCheck2[2], 6), $aRtnHomeCheck2[3]) = False Then ; If not already at Return Homescreen
					#CS
					If $g_bCheckKingPower Then
						SetLog("Activating King's power to restore some health before EndBattle", $COLOR_INFO)
						If IsAttackPage() Then SelectDropTroop($g_iKingSlot) ;If King was not activated: Boost King before EndBattle to restore some health
					EndIf
					If $g_bCheckQueenPower Then
						SetLog("Activating Queen's power to restore some health before EndBattle", $COLOR_INFO)
						If IsAttackPage() Then SelectDropTroop($g_iQueenSlot) ;If Queen was not activated: Boost Queen before EndBattle to restore some health
					EndIf
					If $g_bCheckWardenPower Then
						SetLog("Activating Warden's power to restore some health before EndBattle", $COLOR_INFO)
						If IsAttackPage() Then SelectDropTroop($g_iWardenSlot) ;If Queen was not activated: Boost Queen before EndBattle to restore some health
					EndIf
					If $g_bCheckChampionPower Then
						SetLog("Activating Royal Champion's power to restore some health before EndBattle", $COLOR_INFO)
						If IsAttackPage() Then SelectDropTroop($g_iChampionSlot) ;If Champion was not activated: Boost Champion before EndBattle to restore some health
					EndIf
					#CE
				EndIf
			EndIf
		Else
			SetDebugLog("Battle already over", $COLOR_DEBUG)
		EndIf
	EndIf

	If $g_bDESideDisableOther And $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable And ($g_bDropQueen Or $g_bDropKing) Then
	; If $g_bDESideDisableOther And $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable And ($g_bDropQueen Or $g_bDropKing) Or (($g_bLeagueAttack Or $g_bForceProtectLL) And $g_bProtectInLL) Then
		RevertEBO()
	EndIf

	; Reset hero variables
	$g_bCheckKingPower = False
	$g_bCheckQueenPower = False
	$g_bCheckWardenPower = False
	$g_bCheckChampionPower = False
	$g_bDropKing = False
	$g_bDropQueen = False
	$g_bDropWarden = False
	$g_bDropChampion = False
	$g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0
	$g_aHeroesTimerActivation[$eHeroArcherQueen] = 0
	$g_aHeroesTimerActivation[$eHeroGrandWarden] = 0
	$g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0

	; Reset building info used to attack base
	_ObjDeleteKey($g_oBldgAttackInfo, "") ; Remove all Keys from dictionary

	SetLog("Returning Home", $COLOR_INFO)
	If $g_bRunState = False Then Return

	; ---- CLICK SURRENDER BUTTON ----
	Local $bNetworkBadly = False ; Custom fix - Team AIO Mod++
	If Not (IsReturnHomeBattlePage(True, False)) Then ; check if battle is already over
		For $i = 0 To 5 ; dynamic wait loop for surrender button to appear (if end battle or surrender button are not found in 5*(200)ms + 5*(200)ms or 3 seconds, then give up.)
			SetDebugLog("Wait for surrender button to appear #" & $i)
			
			; Custom fix - Team AIO Mod++
			_CaptureRegion2() ;to have FULL screen image to work with
			$bNetworkBadly = checkObstacles_Network(False, False)
			If $i <= 3 And $bNetworkBadly = True Then
				; network error -> restart CoC
				SetLog("Error: ReturnHome, sync error.", $COLOR_ERROR)
				$g_bIsClientSyncError = True
				$g_bRestart = True
				CloseCoC(True)
				Return
			ElseIf $i > 3 And $bNetworkBadly = True Then
				; Avoid unutil check.
				TrayTip($g_sBotTitle, "", BitOR($TIP_ICONASTERISK, $TIP_NOSOUND)) ; clear village search match found message
				ContinueLoop
			EndIf
			
			$aiSurrenderButton = findButton("EndBattle", Default, 1, False) ; Custom fix - Team AIO Mod++
			If IsArray($aiSurrenderButton) And UBound($aiSurrenderButton, 1) = 2 Then
				If IsAttackPage() Then ; verify still on attack page, and battle has not ended magically before clicking
					ClickP($aiSurrenderButton, 1, 0, "#0099") ;Click Surrender
					$j = 0
					While 1 ; dynamic wait for Okay button
						SetDebugLog("Wait for OK button to appear #" & $j)
						If IsEndBattlePage(False) Then
							ClickOkay("SurrenderOkay") ; Click Okay to Confirm surrender
							ExitLoop 2
						Else
							$j += 1
						EndIf
						If ReturnHomeMainPage() Then Return
						If $j > 5 Then ExitLoop ; if Okay button not found in 5*(200)ms or 2 seconds, then give up.
						If _Sleep($DELAYRETURNHOME5) Then Return
					WEnd
				EndIf
			Else
				SetDebugLog("Cannot Find Surrender Button", $COLOR_ERROR)
			EndIf
			If ReturnHomeMainPage() Then Return
			If _Sleep($DELAYRETURNHOME5) Then Return
		Next
	Else
		SetDebugLog("Battle already over.", $COLOR_DEBUG)
	EndIf
	If _Sleep($DELAYRETURNHOME2) Then Return ; short wait for return to main

	TrayTip($g_sBotTitle, "", BitOR($TIP_ICONASTERISK, $TIP_NOSOUND)) ; clear village search match found message

	If CheckAndroidReboot() Then Return

	If $GoldChangeCheck Then
		If IsAttackPage() Then
			$counter = 0
			While _ColorCheck(_GetPixelColor($aRtnHomeCheck1[0], $aRtnHomeCheck1[1], True), Hex($aRtnHomeCheck1[2], 6), $aRtnHomeCheck1[3]) = False And _ColorCheck(_GetPixelColor($aRtnHomeCheck2[0], $aRtnHomeCheck2[1], True), Hex($aRtnHomeCheck2[2], 6), $aRtnHomeCheck2[3]) = False ; test for Return Home Button
				SetDebugLog("Wait for Return Home Button to appear #" & $counter)
				If _Sleep($DELAYRETURNHOME2) Then ExitLoop
				$counter += 1
				If $counter > 40 Then ExitLoop
			WEnd
		EndIf
		If _Sleep($DELAYRETURNHOME3) Then Return ; wait for all report details
		_CaptureRegion()
		AttackReport()
	EndIf
	If $TakeSS = 1 And $GoldChangeCheck Then
		SetLog("Taking snapshot of your loot", $COLOR_SUCCESS)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		_CaptureRegion()
		$hBitmap_Scaled = _GDIPlus_ImageResize($g_hBitmap, _GDIPlus_ImageGetWidth($g_hBitmap) / 2, _GDIPlus_ImageGetHeight($g_hBitmap) / 2) ;resize image
		; screenshot filename according with new options around filenames
		If $g_bScreenshotLootInfo Then
			$g_sLootFileName = $Date & "_" & $Time & " G" & $g_iStatsLastAttack[$eLootGold] & " E" & $g_iStatsLastAttack[$eLootElixir] & " DE" & _
					$g_iStatsLastAttack[$eLootDarkElixir] & " T" & $g_iStatsLastAttack[$eLootTrophy] & " S" & StringFormat("%3s", $g_iSearchCount) & ".jpg"
		Else
			$g_sLootFileName = $Date & "_" & $Time & ".jpg"
		EndIf
		_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $g_sProfileLootsPath & $g_sLootFileName)
		_GDIPlus_ImageDispose($hBitmap_Scaled)
	EndIf

	;push images if requested..
	If $GoldChangeCheck Then PushMsg("LastRaid")

	$i = 0 ; Reset Loop counter
	Local $iExitLoop = -1
	While 1
		SetDebugLog("Wait for End Fight Scene to appear #" & $i)
		If _CheckPixel($aEndFightSceneAvl, $g_bCapturePixel) Then ; check for the gold ribbon in the end of battle data screen
			If IsReturnHomeBattlePage(True) Then
				ClickP($aReturnHomeButton, 1, 0, "#0101") ;Click Return Home Button
				; sometimes 1st click is not closing, so try again
				$iExitLoop = $i
			EndIf
		EndIf
		If $i > 25 Or ($iExitLoop > -1 And $i > $iExitLoop) Then ExitLoop ; if end battle window is not found in 25*200mms or 5 seconds, then give up.
		If _Sleep($DELAYRETURNHOME5) Then Return
		$i += 1
	WEnd
	If _Sleep($DELAYRETURNHOME2) Then Return ; short wait for screen to close

	$counter = 0
	While 1
		SetDebugLog("Wait for Star Bonus window to appear #" & $counter)
		If _Sleep($DELAYRETURNHOME4) Then Return
		If StarBonus() Then SetLog("Star Bonus window closed chief!", $COLOR_INFO) ; Check for Star Bonus window to fill treasury (2016-01) update
		$g_bFullArmy = False ; forcing check the army
		$g_bIsFullArmywithHeroesAndSpells = False ; forcing check the army
		If ReturnHomeMainPage() Then Return
		$counter += 1
		If $counter >= 2 Or isProblemAffect(True) Then
			SetLog("Cannot return home.", $COLOR_ERROR)
			;checkMainScreen()
			CloseAndroid("UniversalCloseWaitOpenCoC")
			Return
		EndIf
	WEnd
EndFunc   ;==>ReturnHome

Func ReturnHomeMainPage()
	If IsMainPage(1) Then
		SetLogCentered(" BOT LOG ", Default, Default, True)
		Return True
	EndIf
	Return False
EndFunc   ;==>ReturnHomeMainPage

Func ReturnfromDropTrophies()
	Local $aiSurrenderButton
	SetDebugLog(" -- ReturnfromDropTrophies -- ")

	For $i = 0 To 5 ; dynamic wait loop for surrender button to appear (if end battle or surrender button are not found in 5*(200)ms + 10*(200)ms or 3 seconds, then give up.)
		$aiSurrenderButton = findButton("Surrender", Default, 1, True)
		If IsArray($aiSurrenderButton) And UBound($aiSurrenderButton, 1) = 2 Then
			ClickP($aiSurrenderButton, 1, 0, "#0099") ;Click Surrender
			If _Sleep(500) Then Return
			Local $j = 0
			While 1 ; dynamic wait for Okay button
				SetDebugLog("Wait for OK button to appear #" & $j)
				If IsEndBattlePage(True) Then
					ClickOkay("SurrenderOkay") ; Click Okay to Confirm surrender
					ExitLoop 2
				Else
					$j += 1
				EndIf
				If $j > 10 Then ExitLoop ; if Okay button not found in 10*(200)ms or 2 seconds, then give up.
				If _Sleep(100) Then Return
			WEnd
			If _Sleep(100) Then Return
		Else
			SetDebugLog("Cannot Find Surrender Button", $COLOR_ERROR)
		EndIf
	Next

	$i = 0 ; Reset Loop counter
	Local $iExitLoop = -1
	While 1
		SetDebugLog("Wait for End Fight Scene to appear #" & $i)
		If _CheckPixel($aEndFightSceneAvl, $g_bCapturePixel) Then ; check for the gold ribbon in the end of battle data screen
			If IsReturnHomeBattlePage(True) Then
				ClickP($aReturnHomeButton, 1, 0, "#0101") ;Click Return Home Button
				; sometimes 1st click is not closing, so try again
				$iExitLoop = $i
			EndIf
		EndIf
		If $i > 25 Or ($iExitLoop > -1 And $i > $iExitLoop) Then ExitLoop ; if end battle window is not found in 25*200mms or 5 seconds, then give up.
		If _Sleep($DELAYRETURNHOME5) Then Return
		$i += 1
	WEnd
	If _Sleep($DELAYRETURNHOME2) Then Return ; short wait for screen to close
	$g_bFullArmy = False ; forcing check the army
	$g_bIsFullArmywithHeroesAndSpells = False ; forcing check the army
	If ReturnHomeMainPage() Then Return
	checkMainScreen()
EndFunc   ;==>ReturnfromDropTrophies

