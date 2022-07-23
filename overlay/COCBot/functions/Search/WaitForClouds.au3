; #FUNCTION# ====================================================================================================================
; Name ..........: WaitForClouds
; Description ...: Wait loop that checks for clouds to clear screen when searching for base to attack
;					  : Includes ability to extend search time beyond normal 5 minute idle time with randomization of max wait time base on trophy level
; Syntax ........: WaitForClouds()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (08-2016)
; Modified ......: MonkeyHunter (05-2017) MMHK (07-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func WaitForClouds()

	SetDebugLog("Begin WaitForClouds:", $COLOR_DEBUG1)
	$g_bCloudsActive = True

	Local $iCount = 0
	Local $bigCount = 0, $iLastTime = 0
	Local $hMinuteTimer, $iSearchTime
	Local $bEnabledGUI = False

	Local $maxSearchCount = 720 ; $maxSearchCount * 250ms ($DELAYGETRESOURCES1) = seconds wait time before reset in lower leagues: 720*250ms = 3 minutes
	Local $maxLongSearchCount = 7 ; $maxLongSearchCount * $maxSearchCount = seconds total wait time in higher leagues: ; 21 minutes, set a value here but is never used unless error

	Switch Int($g_aiCurrentLoot[$eLootTrophy]) ; add randomization to SearchCounters (long cloud keep alive time) for higher leagues
		Case 3700 To 4099 ; champion 1 league
			$maxSearchCount = Random(480, 840, 1) ; random range 2-3.5 minutes
			$maxLongSearchCount = Random(10, 12, 1) ; random range 20-40 minutes
		Case 4100 To 4399 ; Titan 3 league
			$maxSearchCount = Random(480, 840, 1) ; random range 2-3.5 minutes
			$maxLongSearchCount = Random(15, 25, 1) ; random range 30-87 minutes
		Case 4400 To 4699 ; Titan 2 league
			$maxSearchCount = Random(600, 840, 1) ; random range 2.5-3.5 minutes
			$maxLongSearchCount = Random(24, 42, 1) ; random range 60-147 minutes
		Case 4700 To 4999 ; Titan 1 league
			$maxSearchCount = Random(600, 840, 1) ; random range 2.5-3.5 minutes
			$maxLongSearchCount = Random(36, 50, 1) ; random range 90-175 minutes
		Case 5000 To 6500 ; Legend league
			$maxSearchCount = Random(600, 840, 1) ; random range 2.5-3.5 minutes
			$maxLongSearchCount = Random(80, 85, 1) ; random range 200-300 minutes
	EndSwitch
	If $g_bDebugSetlog Then ; display random values if debug log
		SetLog("RANDOM: $maxSearchCount= " & $maxSearchCount & "= " & Round($maxSearchCount / $DELAYGETRESOURCES1, 2) & " min between cloud chk", $COLOR_DEBUG)
		SetLog("RANDOM: $maxLongSearchCount= " & $maxLongSearchCount & "= " & Round(($maxSearchCount / $DELAYGETRESOURCES1) * $maxLongSearchCount, 2) & " min max search time", $COLOR_DEBUG)
	EndIf

	ForceCaptureRegion() ; ensure screenshots are not cached
	Local $hMinuteTimer = __TimerInit() ; initialize timer for tracking search time

	While $g_bRestart = False And _CaptureRegions() And _CheckPixel($aNoCloudsAttack) = False ; loop to wait for clouds to disappear
		; notice: don't exit function with return in this loop, use ExitLoop ! ! !
		If _Sleep($DELAYGETRESOURCES1 * 10) Then ExitLoop ;250ms * 10 = 2.5 sec
		$iCount += 1
		If isProblemAffect(True) Then ; check for reload error messages and restart search if needed
			resetAttackSearch()
			ExitLoop
		EndIf
		If $iCount >= $maxSearchCount Then ; If clouds do not clear in alloted time do something
			If EnableLongSearch() = False Then ; Check if attacking in Champion 1 or higher league with long search that needs to be continued
				resetAttackSearch()
				ExitLoop
			Else
				$bigCount += 1 ; Increment long wait time fail safe timer
				If $bigCount > $maxLongSearchCount Then ; check maximum wait time
					$iSearchTime = __TimerDiff($hMinuteTimer) / 60000 ;get time since minute timer start in minutes
					SetLog("Spent " & $iSearchTime & " minutes in Clouds searching, Restarting CoC and Bot...", $COLOR_ERROR)
					$g_bIsClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
					$g_bRestart = True
					CloseCoC(True)
					ExitLoop
				EndIf
				$iCount = 0 ; reset outer loop value
			EndIf
		EndIf
		If (Mod($iCount, 10) = 0 And checkObstacles_Network(False, False)) Then
			; network error -> restart CoC
			$g_bIsClientSyncError = True
			$g_bRestart = True
			CloseCoC(True)
			ExitLoop
		EndIf
		If $g_bDebugSetlog Then _GUICtrlStatusBar_SetTextEx($g_hStatusBar, " Status: Loop to clean screen without Clouds, # " & $iCount)
		$iSearchTime = __TimerDiff($hMinuteTimer) / 60000 ;get time since minute timer start in minutes

		#CS - Region - Custom PrepareSearch - Team AIO Mod++
		; Check if CoC app restarted without notice (where android restarted app automatically with same PID), and returned to main base
		Local $iSubCount = 0
		_CaptureRegion()
		While _CheckPixel($aIsMainGrayed, False, Default, "IsMainGrayed") Or _CheckPixel($aIsMain, False, Default, "IsMain")
			_CaptureRegion()
			$iSubCount += 1
			If _Sleep($DELAYATTACKREPORT1) Then Return
			SetDebugLog("Waiting WaitForClouds, " & ($iCount / 2) & " Seconds.", $COLOR_DEBUG)
			If $iSubCount > 3 Then
				SetLog("Error: Main screen detected! 'WaitforClouds'.", $COLOR_ERROR)
				$g_bBadPrepareSearch = True
				ExitLoop 2
			EndIf
		WEnd
		#CE - EndRegion - Custom PrepareSearch - Team AIO Mod++

		If $iSearchTime >= $iLastTime + 1 Then
			SetLog("Cloud wait time " & StringFormat("%.1f", $iSearchTime) & " minute(s)", $COLOR_INFO)
			$iLastTime += 1
			#Region - Return Home by Time - Team AIO Mod++
			If $g_bResetByCloudTimeEnable = True Then
				If $iSearchTime > (Random(0.80, 1.20) * $g_iTxtReturnTimer) Then
				    SetLog("Return home by time due to the long wait in the cloud.", $COLOR_INFO)
					$g_bIsClientSyncError = True
					$g_bRestart = True
					UniversalCloseWaitOpenCoC(0, "WaitForClouds", True, True, False)
					Return
				EndIf
			EndIf
			#EndRegion - Return Home by Time - Team AIO Mod++

			; once a minute safety checks for search fail/retry msg and Personal Break events and early detection if CoC app has crashed inside emulator (Bluestacks issue mainly)
			If chkAttackSearchFail() = 2 Or chkAttackSearchPersonalBreak() = True Or GetAndroidProcessPID() = 0 Then
				resetAttackSearch()
				ExitLoop
			EndIf

			; attempt to enable GUI during long wait?
			If $iSearchTime > 2 And Not $bEnabledGUI Then
				AndroidShieldForceDown(True)
				EnableGuiControls() ; enable bot controls is more than 2 minutes wait
				SetLog("Enabled bot controls due to long wait time", $COLOR_SUCCESS)
				$bEnabledGUI = True
			EndIf
		EndIf
		If Not $g_bRunState Then ExitLoop
		ForceCaptureRegion() ; ensure screenshots are not cached
	WEnd

	If $bEnabledGUI = True Then
		SetLog("Disable bot controls after long wait time", $COLOR_SUCCESS)
		AndroidShieldForceDown(False)
		DisableGuiControls()
		SaveConfig()
		readConfig()
		applyConfig()
	EndIf

	; add delay as few clouds might be still on screen (better to check for remaining clouds at top right?)
	If _Sleep($DELAYCLOUDSCLEARED) Then Return

EndFunc   ;==>WaitForClouds

Func EnableLongSearch()
	; verifies that chat tab is active on cloud window due long search time, and open/closes chat window to avoid app closing while waiting for base to attack
	; Also checks for common error events, search fail/retry, and Personal Break that happen during long searches
	Local $result = ""
	Static $aKeepAlive[2] = [271, 351 + $g_iMidOffsetY]

	SetDebugLog("Begin EnableLongSearch:", $COLOR_DEBUG1)

	If Int($g_aiCurrentLoot[$eLootTrophy]) < 3700 Then ; If not searching Champion 1 or higher, skip long waiting to return and restart due error
		SetDebugLog("Long cloud search not enabled due trophy count: " & $g_aiCurrentLoot[$eLootTrophy], $COLOR_DEBUG)
		Return False
	EndIf

	For $iCount = 0 To 30
		#Region - Custom PrepareSearch - Team AIO Mod++
		; Check if CoC app restarted without notice (where android restarted app automatically with same PID), and returned to main base
		Local $iSubCount = 0
		_CaptureRegion()
		While _CheckPixel($aIsMainGrayed, False, Default, "IsMainGrayed") Or _CheckPixel($aIsMain, False, Default, "IsMain")
			_CaptureRegion()
			$iSubCount += 1
			If _Sleep($DELAYATTACKREPORT1) Then Return
			If $iSubCount > 3 Then
				SetLog("Error: Main screen detected! 'EnableLongSearch'.", $COLOR_ERROR)
				$g_bBadPrepareSearch = True
				Return True
			EndIf
		WEnd
		#EndRegion - Custom PrepareSearch - Team AIO Mod++

		If chkSurrenderBtn() = True Then Return True ; check if clouds are gone.
		If chkAttackSearchPersonalBreak() = True Then Return False ; OCR check for Personal Break while in clouds, return after PB prep
		If chkAttackSearchFail() = 1 Then Return True ; OCR text for search fail message, and press retry if available, success continue searching

		If chkSearchText() = False Then
			SetDebugLog("Cloud Search Text not found...", $COLOR_DEBUG)
			Return False
		Else
			ClickP($aKeepAlive, 1, 0, "#0514") ; click on text just to keep game alive
		EndIf

		; Small delay
		If _Sleep(1000) Then Return

	Next

	Return True
EndFunc   ;==>EnableLongSearch

Func chkSearchText()
	; boolean 50-60ms OCR check for yellow text "Searching for oponents..." message that appears during attack search with long cloud times
	Local $result
	$result = getCloudTextShort(388, 348 + $g_iMidOffsetY, "Cloud Search Text: for=", $COLOR_DEBUG, Default) ; OCR "Searching for oponents..." text
	If $result <> "" And StringLen($result) > 2 Then ; found "for" characters in text?
		Return True
	EndIf
	Return False
EndFunc   ;==>chkSearchText

Func chkAttackSearchFail()
	; boolean 50-60ms OCR check for pink text "unable to find villages to attack!" error message during search for base to attack
	If _Sleep($DELAYCLOUDSCLEARED) Then Return ; add delay as buying time for OCR text to disappear when retry btn pressed
	Local $result
	$result = getCloudFailShort(271, 351 + $g_iMidOffsetY, "Cloud Search Fail Text: unable=", $COLOR_DEBUG, Default)
	If $result <> "" And StringInStr($result, "unable", $STR_NOCASESENSEBASIC) > 0 Then ; found "unable" characters in text
		If btnSearchFailRetry() = True Then ; if press retry button is success, then keep searching
			SetLog("Search Fail? Retry search button pushed, continue...", $COLOR_SUCCESS)
			Return 1
		Else
			SetLog("Warning, failed to find/press retry search button", $COLOR_WARNING)
			Return 2
		EndIf
	EndIf
EndFunc   ;==>chkAttackSearchFail

Func chkAttackSearchPersonalBreak()
	; Boolean 100ms OCR check for pink text "You must wait until after your Personal Break to start an attack." error message during search for base to attack
	Local $result
	$result = getCloudFailShort(499, 350 + $g_iMidOffsetY, "Cloud Search PB Text: Break=", $COLOR_DEBUG, Default)
	If $result <> "" And StringInStr($result, "break", $STR_NOCASESENSEBASIC) > 0 Then ; found "break" characters in text
		SetLog("Prepare base before Personal Break in clouds..", $COLOR_INFO)
		CheckBaseQuick(True, "cloud") ; check and restock base before exit.
		Return True
	EndIf
	If $g_bForceSinglePBLogoff And _DateIsValid($g_sPBStartTime) Then ; silly feature to use with long clouds, but check if single PB is enabled.
		Local $iTimeTillPBTstartSec = Int(_DateDiff('s', $g_sPBStartTime, _NowCalc())) ; time in seconds
		SetDebugLog("PB starts in: " & $iTimeTillPBTstartSec & " Seconds", $COLOR_DEBUG)
		If $iTimeTillPBTstartSec >= 0 Then ; test if PBT date/time in past (positive value) or future (negative value
			SetLog("Prepare base before user forced Break..", $COLOR_INFO)
			CheckBaseQuick(True, "cloud") ; check and restock base before exit.
			Return True
		EndIf
	EndIf
	; Check if it's time to request troops for defense (Demen)
	If $g_bChkRemoveCCForDefense And IsRequestDefense() Then
		SetLog("Prepare base to get defense Troops..", $COLOR_INFO)
		CheckBaseQuick(True, "cloud")
		Return True
	EndIf
	Return False
EndFunc   ;==>chkAttackSearchPersonalBreak

Func btnSearchFailRetry()
	Local $aRetrySearchButton = decodeSingleCoord(findImage("Retry Search", $g_sImgRetrySearchButton, GetDiamondFromRect("270,356,600,456"), 1, True)) ; Resolution changed
	If IsArray($aRetrySearchButton) And UBound($aRetrySearchButton) = 2 Then
		Click($aRetrySearchButton[0], $aRetrySearchButton[1], 1, 0, "#0512")
		Return True
	EndIf
	Return False
EndFunc   ;==>btnSearchFailRetry

Func chkSurrenderBtn($bCapture = True)
	; loop for a few seconds checking if surrender button exists and search is over
	For $iCount = 0 To 60
		If $bCapture = True Then _CaptureRegion()
		If _CheckPixel( (Mod($iCount, 2) = 0) ? ($aSurrenderButton) : ($aSurrenderButtonFixed), False, Default, "Surrender btn wait #" & $iCount, $COLOR_DEBUG) = True Then
			SetDebugLog("Surrender button found, clouds gone, continue...", $COLOR_DEBUG)
			Return True
		EndIf

		If $iCount = 0 Then
			ContinueLoop
		EndIf

		If _Sleep($DELAYSLEEP) Then Return
	Next

	If $iCount >= 60 Or isProblemAffect(False) Then ; Return in 30 * ~150ms = 4.5 seconds if surrender button not found or reload msg appears
		Return False
	EndIf

EndFunc   ;==>chkSurrenderBtn
