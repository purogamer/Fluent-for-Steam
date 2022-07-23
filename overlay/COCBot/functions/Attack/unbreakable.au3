; #FUNCTION# ====================================================================================================================
; Name ..........: Unbreakable.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: KnowJack (07-2015)
; Modified ......: Sardo (08-2015), MonkeyHunter (12-2015)(6-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Unbreakable()
	;
	; Special mode to complete unbreakable achievement
	; Need to set max/min trophy on Misc tab to range where base can win defenses
	; Enable mode with checkbox, and set desired time to be offline getting defense wins before base is reset.
	; Set absolute minimum loot required to still farm for more loot in Farm Minimum setting, and Save Minimum setting loot that will atttact enemy attackers
	;
	Local $x, $y, $i, $iTime, $iCount

	Switch $g_iUnbrkMode
		Case 2
			If (Number($g_aiCurrentLoot[$eLootGold]) > Number($g_iUnbrkMaxGold)) And (Number($g_aiCurrentLoot[$eLootElixir]) > Number($g_iUnbrkMaxElixir)) And (Number($g_aiCurrentLoot[$eLootDarkElixir]) > Number($g_iUnbrkMaxDark)) Then
				SetLog(" ====== Unbreakable Mode restarted! ====== ", $COLOR_SUCCESS)
				$g_iUnbrkMode = 1
			Else
				SetLog(" = Unbreakable Mode Paused, Farming to Refill Storages =", $COLOR_INFO)
				Return False
			EndIf
		Case 1
			SetLog(" ====== Unbreakable Mode enabled! ====== ", $COLOR_SUCCESS)
		Case Else
			SetLog(">>> Programmer Humor, You shouldn't ever see this message, RUN! <<<", $COLOR_DEBUG)
	EndSwitch

	; If attack dead bases during trophy drop is enabled then make sure we have at least 70% full army
	If $g_bDropTrophyAtkDead Then
		If ($g_CurrentCampUtilization <= ($g_iTotalCampSpace * 70 / 100)) Then
			SetLog("Oops, wait for 70% troops due attack dead base checked", $COLOR_ERROR)
			Return True ; no troops then cycle again
		EndIf
		; no deadbase attacks, then only a few troops needed to enable drop trophy to work
	Else
		If ($g_CurrentCampUtilization <= ($g_iTotalCampSpace * 20 / 100)) Then
			SetLog("Oops, wait for 20% troops for use in trophy drop", $COLOR_ERROR)
			Return True ; no troops then cycle again
		EndIf
	EndIf

	Local $sMissingLoot = ""
	If ((Number($g_aiCurrentLoot[$eLootGold]) - Number($g_iUnbrkMinGold)) < 0) Then
		$sMissingLoot &= "Gold, "
	EndIf
	If ((Number($g_aiCurrentLoot[$eLootElixir]) - Number($g_iUnbrkMinElixir)) < 0) Then
		$sMissingLoot &= "Elixir, "
	EndIf
	If ((Number($g_aiCurrentLoot[$eLootDarkElixir]) - Number($g_iUnbrkMinDark)) < 0) Then
		$sMissingLoot &= "Dark Elixir"
	EndIf
	If $sMissingLoot <> "" Then
		SetLog("Oops, Out of " & $sMissingLoot & " - back to farming", $COLOR_ERROR)
		$g_iUnbrkMode = 2 ; go back to farming mode.
		Return False
	EndIf

	DropTrophy()
	If _Sleep($DELAYUNBREAKABLE2) Then Return True ; wait for home screen
	ClickAway()
	If _Sleep($DELAYUNBREAKABLE1) Then Return True ; wait for home screen
	If $g_bRestart = True Then Return True ; Check Restart Flag to see if drop trophy used all the troops and need to train more.
	$iCount = 0
	Local $iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; Get trophy
	SetDebugLog("Trophy Count Read = " & $iTrophyCurrent, $COLOR_DEBUG)
	While Number($iTrophyCurrent) > Number($g_iDropTrophyMax) ; verify that trophy dropped and didn't fail due misc errors searching
		SetDebugLog("Drop Trophy Loop #" & $iCount + 1, $COLOR_DEBUG)
		DropTrophy()
		If _Sleep($DELAYUNBREAKABLE2) Then Return True; wait for home screen
		ClickAway()
		If _Sleep($DELAYUNBREAKABLE1) Then Return True; wait for home screen
		$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
		If ($iCount > 2) And (Number($iTrophyCurrent) > Number($g_iDropTrophyMax)) Then ; If unable to drop trophy after a couple of tries, restart at main loop.
			SetLog("Unable to drop trophy, trying again", $COLOR_ERROR)
			If _Sleep(500) Then Return True
			Return True
		EndIf
		$iCount += 1
	WEnd
	If $g_bRestart = True Then Return True ; Check Restart Flag to see if drop trophy used all the troops and need to train more.

	BreakPersonalShield() ; break personal Shield and Personal Guard
	If @error Then
		If @extended <> "" Then SetLog("PersonalShield button problem: " & @extended, $COLOR_ERROR)
		ClickAway()
		Return True ; return to runbot and try again
	EndIf

	ClickAway()
	If _Sleep($DELAYUNBREAKABLE1) Then Return True

	If CheckObstacles() = True Then SetLog("Window clean required, but no problem for MyBot!", $COLOR_INFO)

	CloseCoC()
	
	$iTime = Number($g_iUnbrkWait)
	If $iTime < 1 Then $iTime = 1 ;error check user time input
	Local Const $iGracePeriodTime = 5 ; 5 minutes for server to acknowledge log off.
	$iTime = ($iTime + $iGracePeriodTime) * 60 * 1000 ; add server grace time and convert to milliseconds

	WaitnOpenCoC($iTime, False) ;Tell ClosenOpenCoC False to not cleanup windows

	$iCount = 0
	While 1 ; Under attack when return from sleep?  wait some more ...
		SetDebugLog("Under Attack Pixels = " & _GetPixelColor(841, 342 + $g_iMidOffsetY, True) & "/" & _GetPixelColor(842, 348 + $g_iMidOffsetY, True), $COLOR_DEBUG)
		If _ColorCheck(_GetPixelColor(841, 342 + $g_iMidOffsetY, True), Hex(0x711C0A, 6), 20) And _ColorCheck(_GetPixelColor(842, 348 + $g_iMidOffsetY, True), Hex(0x721C0E, 6), 20) Then
			SetLog("Base is under attack, waiting 30 seocnds for end", $COLOR_INFO)
		Else
			ExitLoop
		EndIf
		If _SleepStatus($DELAYUNBREAKABLE6) Then Return True ; sleep 30 seconds
		If $iCount > 7 Then ExitLoop ; wait 3 minutes for attack, and 30 seconds prep time; up to 3:30 total
		$iCount += 1
	WEnd
	If _Sleep($DELAYUNBREAKABLE4) Then Return True

	Local $Message = _PixelSearch(20, 624 + $g_iBottomOffsetYFixed, 105, 627 + $g_iBottomOffsetYFixed, Hex(0xE1E3CB, 6), 15) ;Check if Return Home button available and close the screen
	If IsArray($Message) Then
		SetDebugLog("Return Home Pixel = " & _GetPixelColor($Message[0], $Message[1], True) & ", Pos: " & $Message[0] & "/" & $Message[1], $COLOR_DEBUG)
		PureClick(67, 602 + $g_iBottomOffsetY, 1, 0, "#0138")
		If _Sleep($DELAYUNBREAKABLE3) Then Return True
	EndIf

	If _ColorCheck(_GetPixelColor(235, 209 + $g_iMidOffsetY, True), Hex(0x9E3826, 6), 20) And _ColorCheck(_GetPixelColor(242, 140 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 20) Then ;See if village was attacked, then click Okay
		SetDebugLog("Village Attacked Pixels = " & _GetPixelColor(235, 209 + $g_iMidOffsetY, True) & "/" & _GetPixelColor(242, 140 + $g_iMidOffsetY, True), $COLOR_DEBUG)
		PureClick(429, 493 + $g_iMidOffsetY, 1, 0, "#0132")
		If _Sleep($DELAYUNBREAKABLE3) Then Return True
	EndIf

	If CheckObstacles() = True Then ; Check for unusual windows open, or slow windows
		If _Sleep($DELAYUNBREAKABLE3) Then Return ; wait for window to close
		If CheckObstacles() = True Then CheckMainScreen(False) ; Check again, if true then let Check main screen fix it and zoomout
		Return
	EndIf

	ZoomOut()
	If _Sleep($DELAYUNBREAKABLE1) Then Return True

	Return True

EndFunc   ;==>Unbreakable
