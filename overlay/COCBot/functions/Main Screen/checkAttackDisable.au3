
; #FUNCTION# ====================================================================================================================
; Name ..........: checkAttackDisable
; Description ...:
; Syntax ........: checkAttackDisable($iSource, [$Result = getAttackDisable(X,Y])
; Parameters ....: $Result              - [optional] previous saved string from OCR read. Default is getAttackDisable(346, 182) or getAttackDisable(180,167)
;					    $iSource				 - integer, 1 = called during search process (preparesearch/villagesearch)
;																	2 = called during time when not trying to attack (all other idle times have different message)
; Return values .: None
; Author ........: KnowJack (08-2015)
; Modified ......: TheMaster (2015), MonkeyHunter (12-2015/01-2016), Hervidero (12-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkAttackDisable($iSource, $Result = "")
	Local $i = 0, $iCount = 0
	Local $iModSource

	If $g_bDisableBreakCheck = True Then Return ; check Disable break flag, added to prevent recursion for CheckBaseQuick

	If $g_bForceSinglePBLogoff And _DateIsValid($g_sPBStartTime) Then
		Local $iTimeTillPBTstartSec = Int(_DateDiff('s', $g_sPBStartTime, _NowCalc())) ; time in seconds
		SetDebugLog("PB starts in: " & $iTimeTillPBTstartSec & " Seconds", $COLOR_DEBUG)
		If $iTimeTillPBTstartSec >= 0 Then ; test if PBT date/time in past (positive value) or future (negative value
			$iModSource = $g_iTaBChkTime
		Else
			$g_abPBActive[$g_iCurAccount] = False
			Return
		EndIf
	Else
		$iModSource = $iSource
	EndIf

	Switch $iModSource
		Case $g_iTaBChkAttack ; look at location 346, 182 for "disable", "for" or "after" if checked early enough
			While $Result = "" Or (StringLen($Result) < 3)
				$i += 1
				If _Sleep($DELAYATTACKDISABLE100) Then Return
				$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak if not found due slow PC
				If $i >= 3 Then ExitLoop
			WEnd
			SetDebugLog("Attack Personal Break OCR result = " & $Result, $COLOR_DEBUG)
			If $Result <> "" Then ; fast test to see if have Take-A-Break
				If StringInStr($Result, "disable") <> 0 Or StringInStr($Result, "for") <> 0 Or StringInStr($Result, "after") <> 0 Or StringInStr($Result, "have") <> 0 Then ; verify we have right text strings, 'after' added for Personal Break
					SetLog("Attacking disabled, Personal Break detected...", $COLOR_ERROR)
					If _CheckPixel($aSurrenderButton, $g_bCapturePixel) Then ; village search requires end battle 1s, so check for surrender/endbattle button
						If TestCapture() Then
							SetLog("checkAttackDisable: ReturnHome")
						Else
							ReturnHome(False, False) ;If End battle is available
						EndIf
					ElseIf _CheckPixel($aSurrenderButtonFixed, $g_bCapturePixel) Then ; village search requires end battle 1s, so check for surrender/endbattle button
						If TestCapture() Then
							SetLog("checkAttackDisable: ReturnHome")
						Else
							ReturnHome(False, False) ;If End battle is available
						EndIf
					Else
						If TestCapture() Then
							SetLog("checkAttackDisable: CloseCoC")
						Else
							CloseCoC()
						EndIf
					EndIf
				Else
					SetDebugLog("wrong text string", $COLOR_DEBUG)
					If TestCapture() Then Return "wrong text string"
					Return ; exit function, wrong string found
				EndIf
			Else
				If TestCapture() Then Return "take a break text not found"
				Return ; exit function, take a break text not found
			EndIf
		Case $g_iTaBChkIdle ; look at location 180, 167 for the have "been" online too long message, and the "after" Personal Break message
			If $Result = "" Then $Result = getAttackDisable(180, 156 + $g_iMidOffsetY) ; change to 180, 186 for 860x780
			If _Sleep($DELAYATTACKDISABLE500) Then Return ; short wait to not delay to much
			If $Result = "" Or (StringLen($Result) < 3) Then $Result = getAttackDisable(180, 156 + $g_iMidOffsetY) ; Grab Ocr for "Have Been" 2nd time if not found due slow PC
			SetDebugLog("Personal Break OCR result = " & $Result, $COLOR_DEBUG)
			If $Result <> "" Then ; fast test to see if have Take-A-Break
				If StringInStr($Result, "been") <> 0 Or StringInStr($Result, "after") <> 0 Or StringInStr($Result, "have") <> 0 Then ; verify we have right text string, 'after' added for Personal Break
					SetLog("Online too long, Personal Break detected....", $COLOR_ERROR)
					checkMainScreen()
				Else
					SetDebugLog("wrong text string", $COLOR_DEBUG)
					If TestCapture() Then Return "wrong text string #2"
					$g_abPBActive[$g_iCurAccount] = False
					Return ; exit function, wrong string found
				EndIf
			Else
				If TestCapture() Then Return "take a break text not found #2"
				$g_abPBActive[$g_iCurAccount] = False
				Return ; exit function, take a break text not found
			EndIf
		Case $g_iTaBChkTime
			If $iSource = $g_iTaBChkAttack Then ; If from village search, need to return home
				While _CheckPixel($aIsAttackPage, $g_bCapturePixel) = False ; Wait for attack page ready
					If _Sleep($DELAYATTACKDISABLE500) Then Return
					$iCount += 1
					SetDebugLog("wait end battle button " & $iCount, $COLOR_DEBUG)
					If $iCount > 40 Or isProblemAffect(True) Then ; wait 20 seconds and give up.
						checkObstacles()
						ExitLoop
					EndIf
					If Not $g_bRunState Then ExitLoop
				WEnd
				If _CheckPixel($aIsAttackPage, $g_bCapturePixel) Then
					If TestCapture() Then
						SetLog("checkAttackDisable: ReturnHome #2")
					Else
						ReturnHome(False, False) ;If End battle is available
					EndIf
				EndIf
			EndIf
			If $iSource = $g_iTaBChkIdle Then
				While _CheckPixel($aIsMain, $g_bCapturePixel) = False
					If _Sleep($DELAYATTACKDISABLE500) Then Return
					ClickAway()
					$iCount += 1
					SetDebugLog("wait main page" & $iCount, $COLOR_DEBUG)
					If $iCount > 5 Or isProblemAffect(True) Then ; wait 2.5 seconds, give up, let checkobstacles try to clear page
						checkObstacles()
						ExitLoop
					EndIf
				WEnd
				If _Sleep($DELAYATTACKDISABLE500) Then Return
			EndIf
			If $g_asShieldStatus[0] = "guard" Then
				SetLog("Unable to Force PB, Guard shield present", $COLOR_INFO)
			Else
				SetLog("Forcing Early Personal Break Now!!", $COLOR_SUCCESS)
			EndIf
		Case Else
			SetLog("Misformed $sSource parameter, silly programmer made a mistake!", $COLOR_DEBUG)
			Return False
	EndSwitch

	SetLog("Prepare base before Personal Break..", $COLOR_INFO)
	CheckBaseQuick(True) ; check and restock base before exit.

	$g_bIsClientSyncError = False ; reset OOS fast restart flag
	$g_bIsSearchLimit = False ; reset search limit flag
	$g_bRestart = True ; Set flag to restart the process at the bot main code when it returns

	; TODO: Check if you are using Switch account ,
	;       adding 18 minutes to Remain train Time and goes to next available Account
	If ProfileSwitchAccountEnabled() Then
		SetLog("Adding the PB time to remain time of the current account.", $COLOR_INFO)
		If _DateIsValid($g_asTrainTimeFinish[$g_iCurAccount]) Then
			If _DateDiff("n", _NowCalc(), $g_asTrainTimeFinish[$g_iCurAccount]) < $g_iSinglePBForcedLogoffTime Then
				$g_asTrainTimeFinish[$g_iCurAccount] = _DateAdd("n", $g_iSinglePBForcedLogoffTime, _NowCalc())
				$g_abPBActive[$g_iCurAccount] = True
			EndIf
		EndIf
		Local $iAllcounts = 0, $iAllAccountsPBactive = 0
		For $i = 0 To $g_iTotalAcc
			If $g_abAccountNo[$i] = True Then
				If SwitchAccountEnabled($i) Then
					$iAllcounts +=1
					If $g_abPBActive[$i] = True Then $iAllAccountsPBactive+=1
				EndIf
			EndIf
		Next

		If $iAllcounts <> $iAllAccountsPBactive Then
			checkSwitchAcc()
			Return
		Else
			SetLog("All Accounts are in PB Time!!", $COLOR_INFO)
		EndIf
	EndIf
	SetLog("Time for break, exit now..", $COLOR_INFO)

	If TestCapture() Then
		SetLog("checkAttackDisable: PoliteCloseCoC")
	Else
		PoliteCloseCoC("AttackDisable_")
	EndIf

	If _Sleep(1000) Then Return ; short wait for CoC to exit
	PushMsg("TakeBreak")

	; CoC is closed >>
	If $iModSource = $g_iTaBChkTime And $g_asShieldStatus[0] <> "guard" Then
		SetLog("Personal Break Reset log off: " & $g_iSinglePBForcedLogoffTime & " Minutes", $COLOR_INFO)
		If TestCapture() Then
			SetLog("checkAttackDisable: WaitnOpenCoC")
		Else
			WaitnOpenCoC($g_iSinglePBForcedLogoffTime * 60 * 1000, True) ; Log off CoC for user set time in expert tab
		EndIf
	Else
		If TestCapture() Then
			SetLog("checkAttackDisable: WaitnOpenCoC")
		Else
			WaitnOpenCoC(20000, True) ; close CoC for 20 seconds to ensure server logoff, True=call checkmainscreen to clean up if needed
		EndIf
	EndIf
	$g_sPBStartTime = "" ; reset Personal Break global time value to get update
	For $i = 0 To UBound($g_asShieldStatus) - 1
		$g_asShieldStatus[$i] = "" ; reset global shield info array
	Next

	For $i = 0 To $g_iTotalAcc ; Reset all enable accounts PB time
		If $g_abAccountNo[$i] = True Then
			If SwitchAccountEnabled($i) Then
				$g_abPBActive[$i] = False
			EndIf
		EndIF
	Next

EndFunc   ;==>checkAttackDisable

