; #FUNCTION# ====================================================================================================================
; Name ..........: Switch Account
; Description ...: This file contains the Sequence that runs all MBR Bot
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: chalicucu (6/2016), demen (4/2017), Team AIO Mod++ (13/02/2022)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Return True or False if Switch Account is enabled and current profile in configured list
Func ProfileSwitchAccountEnabled($bReally = False) 
	; Custom fix - Team AIO Mod++
	If $bReally = True Then
		Local $abAccountNo = AccountNoActive()
		If UBound(_ArrayFindAll($abAccountNo, "True")) < 2 Then
			Return SetError(0, 0, False)
		EndIf
	EndIf
	If Not $g_bChkSwitchAcc Or Not aquireSwitchAccountMutex() Then Return False
	Return SetError(0, 0, _ArraySearch($g_asProfileName, $g_sProfileCurrentName) >= 0)
EndFunc   ;==>ProfileSwitchAccountEnabled

; Return True or False if specified Profile is enabled for Switch Account and controlled by this bot instance
Func SwitchAccountEnabled($IdxOrProfilename = $g_sProfileCurrentName)
	Local $sProfile
	Local $iIdx
	If IsInt($IdxOrProfilename) Then
		$iIdx = $IdxOrProfilename
		$sProfile = $g_asProfileName[$iIdx]
	Else
		$sProfile = $IdxOrProfilename
		$iIdx = _ArraySearch($g_asProfileName, $sProfile)
	EndIf

	If Not $sProfile Or $iIdx < 0 Or Not $g_abAccountNo[$iIdx] Then
		; not in list or not enabled
		Return False
	EndIf

	; check if mutex is or can be aquired
	Return aquireProfileMutex($sProfile) <> 0
EndFunc   ;==>SwitchAccountEnabled

; retuns copy of $g_abAccountNo validated with SwitchAccountEnabled
Func AccountNoActive()
	Local $a[UBound($g_abAccountNo)]

	For $i = 0 To UBound($g_abAccountNo) - 1
		$a[$i] = SwitchAccountEnabled($i)
	Next

	Return $a
EndFunc   ;==>AccountNoActive

Func InitiateSwitchAcc() ; Checking profiles setup in Mybot, First matching CoC Acc with current profile, Reset all Timers relating to Switch Acc Mode.
	If Not ProfileSwitchAccountEnabled() Or Not $g_bInitiateSwitchAcc Then Return
	UpdateMultiStats()
	$g_iNextAccount = -1
	SetLog("Switch Account enable for " & $g_iTotalAcc + 1 & " accounts")
	SetSwitchAccLog("Initiating: " & $g_iTotalAcc + 1 & " acc", $COLOR_SUCCESS)

	If Not $g_bRunState Then Return
	;Local $iCurProfile = _GUICtrlComboBox_GetCurSel($g_hCmbProfile)
	For $i = 0 To $g_iTotalAcc
		; listing all accounts
		Local $sBotType = "Idle"
		If $g_abAccountNo[$i] Then
			If SwitchAccountEnabled($i) Then
				$sBotType = "Active"
				If $g_abDonateOnly[$i] Then $sBotType = "Donate"
				If $g_iNextAccount = -1 Then $g_iNextAccount = $i
				If $g_asProfileName[$i] = $g_sProfileCurrentName Then $g_iNextAccount = $i
			Else
				$sBotType = "Other bot"
			EndIf
		EndIf
		SetLog("  - Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " - " & $sBotType)
		;SetSwitchAccLog("  - Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " - " & $sBotType)
		SetSwitchAccLog("  - Acc. " & $i + 1 & ": " & $sBotType)

		$g_abPBActive[$i] = False
	Next
	$g_iCurAccount = $g_iNextAccount ; make sure no crash
	SwitchAccountVariablesReload("Reset")
	SetLog("Let's start with Account [" & $g_iNextAccount + 1 & "]")
	SetSwitchAccLog("Start with Acc [" & $g_iNextAccount + 1 & "]")
	SwitchCOCAcc($g_iNextAccount)
EndFunc   ;==>InitiateSwitchAcc

Func CheckSwitchAcc()
	Local $abAccountNo = AccountNoActive()
	If Not $g_bRunState Then Return
	Local $aActiveAccount = _ArrayFindAll($abAccountNo, True)
	If UBound($aActiveAccount) <= 1 Then Return

	Local $aDonateAccount = _ArrayFindAll($g_abDonateOnly, True)
	Local $bReachAttackLimit = ($g_aiAttackedCountSwitch[$g_iCurAccount] <= $g_aiAttackedCountAcc[$g_iCurAccount] - 2)
	Local $bForceSwitch = $g_bForceSwitch
	Local $nMinRemainTrain, $iWaitTime
	Local $aActibePBTaccounts = _ArrayFindAll($g_abPBActive, True)

	SetLog("Start Switch Account!", $COLOR_INFO)

	#Region - Custom BB - Team AIO Mod++
	; Force Switch when PBT detected
	If $g_abPBActive[$g_iCurAccount] = True Then
		SetSwitchAccLog(" - PBT Active")
		$bForceSwitch = True
	ElseIf $g_bOnlyBuilderBase Then
		SetLog("This account is Play BB Only, switching to another account", $COLOR_ACTION)
		SetSwitchAccLog(" - Play BB Only")
		$bForceSwitch = True
	#EndRegion - Custom BB - Team AIO Mod++
	ElseIf $g_iCommandStop = 0 Or $g_iCommandStop = 3 Then ; Forced to switch when in halt attack mode
		SetLog("This account is in halt attack mode, switching to another account", $COLOR_ACTION)
		SetSwitchAccLog(" - Halt Attack, Force switch")
		$bForceSwitch = True
	ElseIf $g_iCommandStop = 1 Then
		SetLog("This account is turned off, switching to another account", $COLOR_ACTION)
		SetSwitchAccLog(" - Turn idle, Force switch")
		$bForceSwitch = True
	ElseIf $g_iCommandStop = 2 Then
		SetLog("This account is out of Attack Schedule, switching to another account", $COLOR_ACTION)
		SetSwitchAccLog(" - Off Schedule, Force switch")
		$bForceSwitch = True
	ElseIf $g_bWaitForCCTroopSpell Then
		SetLog("Still waiting for CC Troops/Spells, switching to another Account", $COLOR_ACTION)
		SetSwitchAccLog(" - Waiting for CC")
		$bForceSwitch = True
	ElseIf $g_bAllBarracksUpgd Then ;Check if all barrack are upgrading, no army can be train --> Force Switch account
		SetLog("Seems all your barracks are upgrading", $COLOR_INFO)
		SetLog("No troops can be trained, let's switch account", $COLOR_INFO)
		SetSwitchAccLog(" - All Barracks Upgrading, Force switch")
		$bForceSwitch = True
	Else
		getArmyTroopTime(True, False) ; update $g_aiTimeTrain[0]

		$g_aiTimeTrain[1] = 0
		If IsWaitforSpellsActive() Then getArmySpellTime() ; update $g_aiTimeTrain[1]

		$g_aiTimeTrain[2] = 0
		If IsWaitforHeroesActive() Then CheckWaitHero() ; update $g_aiTimeTrain[2]

		ClickAway()

		$iWaitTime = _ArrayMax($g_aiTimeTrain, 1, 0, 2) ; Not check Siege Machine time: $g_aiTimeTrain[3]
		If $bReachAttackLimit And $iWaitTime <= 0 Then
			SetLog("This account has attacked twice in a row, switching to another account", $COLOR_INFO)
			SetSwitchAccLog(" - Reach attack limit: " & $g_aiAttackedCountAcc[$g_iCurAccount] - $g_aiAttackedCountSwitch[$g_iCurAccount])
			$bForceSwitch = True
		EndIf
	EndIf

	Local $sLogSkip = ""
	If Not $g_abDonateOnly[$g_iCurAccount] And $iWaitTime <= $g_iTrainTimeToSkip And Not $bForceSwitch Then
		If Not $g_bRunState Then Return
		If $iWaitTime > 0 Then $sLogSkip = " in " & Round($iWaitTime, 1) & " mins"
		SetLog("Army is ready" & $sLogSkip & ", skip switching account", $COLOR_INFO)
		SetSwitchAccLog(" - Army is ready" & $sLogSkip)
		SetSwitchAccLog("Stay at [" & $g_iCurAccount + 1 & "]", $COLOR_SUCCESS)
		If _Sleep(500) Then Return

	Else

		If $g_bChkSmartSwitch = True Then
			SetDebugLog("-Smart Switch-")
			If CheckPlannedAttackLimits() Then
				$g_iNextAccount = CheckPlannedAccountLimits($bForceSwitch)
				If $g_iNextAccount = $g_iCurAccount Then
					SetLog("Staying in this account")
					SetSwitchAccLog("Stay at [" & $g_iCurAccount + 1 & "]", $COLOR_SUCCESS)
					Return
				EndIf
			Else
				; Custom schedule - Team AIO Mod++
				$nMinRemainTrain = CheckTroopTimeAllAccount($bForceSwitch)
				If $nMinRemainTrain <= 1 And Not $bForceSwitch And Not $g_bDonateLikeCrazy Then
					If $g_bDebugSetlog Then SetDebugLog("Switch to or Stay at Active Account: " & $g_iNextAccount + 1, $COLOR_DEBUG)
					$g_iDonateSwitchCounter = 0
				Else
					If $g_iDonateSwitchCounter < UBound($aDonateAccount) Then
						$g_iNextAccount = $aDonateAccount[$g_iDonateSwitchCounter]
						$g_iDonateSwitchCounter += 1
						If $g_bDebugSetlog Then SetDebugLog("Switch to Donate Account " & $g_iNextAccount + 1 & ". $g_iDonateSwitchCounter = " & $g_iDonateSwitchCounter, $COLOR_DEBUG)
						SetSwitchAccLog(" - Donate Acc [" & $g_iNextAccount + 1 & "]")
					Else
						$g_iDonateSwitchCounter = 0
					EndIf
				EndIf
			EndIf
		Else
			SetDebugLog("-Normal Switch-")
			; Custom schedule - Team AIO Mod++
			If CheckPlannedAttackLimits() Then
				$g_iNextAccount = CheckPlannedAccountLimits($bForceSwitch)
				If $g_iNextAccount = $g_iCurAccount Then
					SetLog("Staying in this account")
					SetSwitchAccLog("Stay at [" & $g_iCurAccount + 1 & "]", $COLOR_SUCCESS)
					Return
				EndIf
			Else
				$g_iNextAccount = $g_iCurAccount + 1
				If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0
				While $abAccountNo[$g_iNextAccount] = False
					$g_iNextAccount += 1
					If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0
					SetDebugLog("- While Account: " & $g_asProfileName[$g_iNextAccount] & " number: " & $g_iNextAccount + 1)
				WEnd
			EndIf
		EndIf

		SetDebugLog("- Current Account: " & $g_asProfileName[$g_iCurAccount] & " number: " & $g_iCurAccount + 1)
		SetDebugLog("- Next Account: " & $g_asProfileName[$g_iNextAccount] & " number: " & $g_iNextAccount + 1)

		For $i = 0 To $g_iTotalAcc
			If ($g_abPBActive[$g_iNextAccount] And $g_asTrainTimeFinish[$g_iNextAccount] > 2) Or $abAccountNo[$g_iNextAccount] = False Then
				If $abAccountNo[$g_iNextAccount] = False Then
					SetLog("Account " & $g_iNextAccount + 1 & " disabled!", $COLOR_INFO)
					SetSwitchAccLog(" - Account " & $g_iNextAccount + 1 & " disabled")
				Else
					SetLog("Account " & $g_iNextAccount + 1 & " is in a Personal Break Time!", $COLOR_INFO)
					SetSwitchAccLog(" - Account " & $g_iNextAccount + 1 & " is in PTB")
				EndIf
				$g_iNextAccount = $g_iNextAccount + 1
				If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0
				While $abAccountNo[$g_iNextAccount] = False
					$g_iNextAccount += 1
					If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0
				WEnd
			Else
				ExitLoop
			EndIf
		Next

		If UBound($aActibePBTaccounts) + UBound($aDonateAccount) = UBound($aActiveAccount) Then
			SetLog("All accounts set to Donate and/or are in PBT!", $COLOR_INFO)
			SetSwitchAccLog("All accounts in PBT/Donate:")
			For $i = 0 To $g_iTotalAcc
				If $g_abDonateOnly[$i] Then SetSwitchAccLog(" - Donate Acc [" & $i + 1 & "]")
				If $g_abPBActive[$i] Then SetSwitchAccLog(" - PBT Acc [" & $i + 1 & "]")
			Next
		EndIf

		If $g_iNextAccount <> $g_iCurAccount Then
			If $g_bRequestTroopsEnable And $g_bCanRequestCC And not $bForceSwitch Then
				If _Sleep(1000) Then Return
				SetLog("Try Request troops before switching account", $COLOR_INFO)
				RequestCC(True)
			EndIf
			If Not $bForceSwitch Then
				If Not IsMainPage() Then checkMainScreen()
			EndIf
			SwitchCOCAcc($g_iNextAccount, $bForceSwitch)
		Else
			SetLog("Staying in this account")
			SetSwitchAccLog("Stay at [" & $g_iCurAccount + 1 & "]", $COLOR_SUCCESS)
			VillageReport()
			CheckFarmSchedule()
		EndIf
	EndIf
	If Not $g_bRunState Then Return

	$g_bForceSwitch = false ; reset the need to switch
EndFunc   ;==>CheckSwitchAcc

Func SwitchCOCAcc($NextAccount, $bForceSwitch = False)
	Local $abAccountNo = AccountNoActive()
	If $NextAccount < 0 And $NextAccount > $g_iTotalAcc Then $NextAccount = _ArraySearch(True, $abAccountNo)
	Static $iRetry = 0
	Local $bResult
	If Not $g_bRunState Then Return

	SetLog("Switching to Account [" & $NextAccount + 1 & "]")
	
	Local $bSharedPrefs = $g_bChkSharedPrefs And HaveSharedPrefs($g_asProfileName[$g_iNextAccount])
	If $bSharedPrefs And $g_PushedSharedPrefsProfile = $g_asProfileName[$g_iNextAccount] Then
		; shared prefs already pushed
		$bResult = True
		$bSharedPrefs = False ; don't push again
		SetLog("Profile shared_prefs already pushed")
		If Not $g_bRunState Then Return
	Else
		If Not $g_bRunState Then Return
		; AIO Mod++
		If $bSharedPrefs And $g_bChkSharedPrefs Then
		Else
			If IsMainPage() Then Click($aButtonSetting[0], $aButtonSetting[1], 1, 0, "Click Setting")
			If _Sleep(500) Then Return
		EndIf
		
		While 1
			; all good
			; AIO Mod++
			If $bSharedPrefs And $g_bChkSharedPrefs Then
				CloseCoC(False)
				$bResult = True
				ExitLoop
			ElseIf $g_bChkSharedPrefs Then
				SetLog("No Shared prefs in acc.", $COLOR_ERROR)
			EndIf
		
			If Not IsSettingPage() Then ExitLoop
		
			If $g_bChkGooglePlay Then
				Switch SwitchCOCAcc_DisconnectConnect($bResult, $bSharedPrefs)
					Case 0
						Return
					Case -1
						ExitLoop
				EndSwitch
				Switch SwitchCOCAcc_ClickAccount($bResult, $NextAccount, $bSharedPrefs)
					Case "OK"
						; all good
						If $g_bChkSharedPrefs Then
							If $bSharedPrefs Then
								CloseCoC(False)
								$bResult = True
								ExitLoop
							Else
								SetLog($g_asProfileName[$g_iNextAccount] & " missing shared_prefs, using normal switch account", $COLOR_WARNING)
							EndIf
						EndIf
					Case "Error"
						; some problem
						ExitLoop
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
				Switch SwitchCOCAcc_ConfirmAccount($bResult)
					Case "OK"
						; all good
					Case "Error"
						; some problem
						ExitLoop
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
		
			ElseIf $g_bChkSuperCellID Then
				Switch SwitchCOCAcc_ConnectedSCID($bResult)
					Case "OK"
						; all good
					Case "Error"
						; some problem
						ExitLoop
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
				Switch SwitchCOCAcc_ClickAccountSCID($bResult, $NextAccount, 2)
					Case "OK"
						; all good
					Case "Error"
						; some problem
						ExitLoop
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
		
			EndIf
			ExitLoop
		WEnd
		If _Sleep(500) Then Return
	EndIf
	
	If $bResult Then
		$iRetry = 0
		$g_bReMatchAcc = False
		If Not $g_bRunState Then Return
		If Not $g_bInitiateSwitchAcc Then SwitchAccountVariablesReload("Save")
		If $g_ahTimerSinceSwitched[$g_iCurAccount] <> 0 Then
			If Not $g_bReMatchAcc Then SetSwitchAccLog(" - Acc " & $g_iCurAccount + 1 & ", online: " & Int(__TimerDiff($g_ahTimerSinceSwitched[$g_iCurAccount]) / 1000 / 60) & "m")
			SetTime(True)
			$g_aiRunTime[$g_iCurAccount] += __TimerDiff($g_ahTimerSinceSwitched[$g_iCurAccount])
			$g_ahTimerSinceSwitched[$g_iCurAccount] = 0
		EndIf

		$g_aiAttackedCountSwitch[$g_iCurAccount] = $g_aiAttackedCountAcc[$g_iCurAccount]

		$g_iCurAccount = $NextAccount
		SwitchAccountVariablesReload()

		$g_ahTimerSinceSwitched[$g_iCurAccount] = __TimerInit()
		$g_bInitiateSwitchAcc = False
		If $g_sProfileCurrentName <> $g_asProfileName[$g_iNextAccount] Then
			BuilderBaseResetStats() ; AIO Mod++
			If $g_iGuiMode = 1 Then
				; normal GUI Mode
				_GUICtrlComboBox_SetCurSel($g_hCmbProfile, _GUICtrlComboBox_FindStringExact($g_hCmbProfile, $g_asProfileName[$g_iNextAccount]))
				cmbProfile()
				DisableGUI_AfterLoadNewProfile()
			Else
				; mini or headless GUI Mode
				saveConfig()
				$g_sProfileCurrentName = $g_asProfileName[$g_iNextAccount]
				LoadProfile(False)
			EndIf
		EndIf
		If $bSharedPrefs Then
			SetLog("Please wait for loading CoC")
			PushSharedPrefs()
			OpenCoC()
			waitMainScreen()
		EndIf

		If Not $g_bRunState Then Return
		SetSwitchAccLog("Switched to Acc [" & $NextAccount + 1 & "]", $COLOR_SUCCESS)
		CreateLogFile() ; Cause use of the right log file after switch
		If Not $g_bRunState Then Return

		If $g_bChkSharedPrefs Then
			; disconnect account again for saving shared_prefs
			waitMainScreen()
			If IsMainPage() Then
				Click($aButtonSetting[0], $aButtonSetting[1], 1, 0, "Click Setting")
				If _Sleep(500) Then Return
				If SwitchCOCAcc_DisconnectConnect($bResult, $g_bChkSharedPrefs) = -1 Then Return ;Return if Error happend

				Switch SwitchCOCAcc_ClickAccount($bResult, $NextAccount, $g_bChkSharedPrefs, False)
					Case "OK"
						; all good
						PullSharedPrefs()
				EndSwitch
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Else
		$iRetry += 1
		$g_bReMatchAcc = True
		SetLog("Switching account failed!", $COLOR_ERROR)
		SetSwitchAccLog("Switching to Acc " & $NextAccount + 1 & " Failed!", $COLOR_ERROR)
		If $iRetry <= 3 Then
			Local $ClickPoint = $aAway
			If $g_bChkSuperCellID Then $ClickPoint = $aCloseTabSCID
			ClickP($ClickPoint, 2, 500)
			checkMainScreen()
		Else
			$iRetry = 0
			UniversalCloseWaitOpenCoC()
		EndIf
		If Not $g_bRunState Then Return
	EndIf
	waitMainScreen()
	If Not $g_bRunState Then Return
	;switch using scid sometime makes emulator seem freeze but not, need to send back button first for click work again
	If $g_bChkSuperCellID Then
		SetDebugLog("Checkscidswitch: Send AndroidBackButton", $COLOR_DEBUG)
		AndroidBackButton() ;Send back button to android
		If _Sleep(1000) Then Return
		If IsEndBattlePage() Then
			AndroidBackButton()
		EndIf
	EndIf
	CheckObstacles()
	If $g_bForceSinglePBLogoff Then $g_bGForcePBTUpdate = True
	runBot()

EndFunc   ;==>SwitchCOCAcc

Func SwitchCOCAcc_DisconnectConnect(ByRef $bResult, $bDisconnectOnly = $g_bChkSharedPrefs)
	Local $sGooglePlayButtonArea = GetDiamondFromRect("50,66,800,600") ; Resolution changed ?
	Local $avGoogleButtonStatus, $sButtonState, $avGoogleButtonSubResult, $aiButtonPos
	If Not $g_bRunState Then Return -1

	For $i = 0 To 20 ; Checking Green Connect Button continuously in 20sec
		$avGoogleButtonStatus = findMultiple($g_sImgGoogleButtonState, $sGooglePlayButtonArea, $sGooglePlayButtonArea, 0, 1000, 1, "objectname,objectpoints", True)
		If IsArray($avGoogleButtonStatus) And UBound($avGoogleButtonStatus, 1) > 0 Then
			$avGoogleButtonSubResult = $avGoogleButtonStatus[0]
			$sButtonState = $avGoogleButtonSubResult[0]
			$aiButtonPos = StringSplit($avGoogleButtonSubResult[1], ",", $STR_NOCOUNT)
			If Not $g_bRunState Then Return -1

			If StringInStr($sButtonState, "Green", 0) Then; Google Play Disconnected
				If Not $bDisconnectOnly Then
					SetLog("   1. Click Connect & Disconnect")
					ClickP($aiButtonPos, 2, 1000)
					If _Sleep(200) Then Return -1
				Else
					SetLog("   1. Click Connected")
					ClickP($aiButtonPos, 1, 1000)
					If _Sleep(200) Then Return -1
				EndIf

				Return 1
			ElseIf StringInStr($sButtonState, "Red", 0) Then ; Google Play Connected
				If Not $bDisconnectOnly Then
					SetLog("   1. Click Disconnect")
					ClickP($aiButtonPos)
					If _Sleep(200) Then Return -1
				Else
					SetLog("Account already disconnected")
				EndIf

				Return 1
			Else ; The Unknown has happend
				SetDebugLog("Unkown Google Play Button State: " & $sButtonState, $COLOR_ERROR)
				Return -1
			EndIf
		Else ; SupercellID
			Local $aSuperCellIDConnected = decodeSingleCoord(findImage("SupercellID Connected", $g_sImgSupercellIDConnected, GetDiamondFromRect("612,117,691,216"), 1, True, Default)) ; Resolution changed
			If IsArray($aSuperCellIDConnected) And UBound($aSuperCellIDConnected, 1) >= 2 Then
				SetLog("Account connected to SuperCell ID")
				;ExitLoop
				Return 1
			EndIf
		EndIf
		If $i = 20 Then
			$bResult = False
			;ExitLoop 2
			Return -1
		EndIf
		If _Sleep(900) Then Return 0
		If Not $g_bRunState Then Return 0
	Next

	Return -1
EndFunc   ;==>SwitchCOCAcc_DisconnectConnect

Func SwitchCOCAcc_ClickAccount(ByRef $bResult, $iNextAccount, $bStayDisconnected = $g_bChkSharedPrefs, $bLateDisconnectButtonCheck = True)
	FuncEnter(SwitchCOCAcc_ClickAccount)

	Local $aSearchForAccount, $aCoordinates[0][2], $aTempArray

	For $i = 0 To 20 ; Checking Account List continuously in 20sec
		If _ColorCheck(_GetPixelColor($aListAccount[0], $aListAccount[1], True), Hex($aListAccount[2], 6), $aListAccount[3]) Then ;	Grey
			If $bStayDisconnected Then
				ClickAway()
				Return FuncReturn("OK")
			EndIf
			If _Sleep(600) Then Return FuncReturn("Exit")
			If Not $g_bRunState Then Return FuncReturn("Exit")

			$aSearchForAccount = decodeMultipleCoords(findImage("AccountLocations", $g_sImgGoogleAccounts, GetDiamondFromRect("155,66,705,666"), 0, True, Default)) ; Resolution changed ?
			If UBound($aSearchForAccount, 1) <= 0 Then
				SetLog("No GooglePlay accounts detected!", $COLOR_ERROR)
				Return FuncReturn("Error")
			ElseIf UBound($aSearchForAccount, 1) < $g_iTotalAcc + 1 Then
				SetLog("Less GooglePlay accounts detected than configured!", $COLOR_ERROR)
				SetDebugLog("Detected: " & UBound($aSearchForAccount, 1) & ", Configured: " & ($g_iTotalAcc + 1), $COLOR_DEBUG)
				Return FuncReturn("Error")
			ElseIf UBound($aSearchForAccount, 1) > $g_iTotalAcc + 1 Then
				SetLog("More GooglePlay accounts detected than configured!", $COLOR_ERROR)
				SetDebugLog("Detected: " & UBound($aSearchForAccount, 1) & ", Configured: " & ($g_iTotalAcc + 1), $COLOR_DEBUG)
				Return FuncReturn("Error")
			Else
				SetDebugLog("[GooglePlay Accounts]: " & UBound($aSearchForAccount, 1), $COLOR_DEBUG)

				For $j = 0 To UBound($aSearchForAccount) - 1
					$aTempArray = $aSearchForAccount[$j]
					_ArrayAdd($aCoordinates, $aTempArray[0] & "|" & $aTempArray[1], 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
				Next

				_ArraySort($aCoordinates, 0, 0, 0, 1) ; short by column 1 [Y]
				For $j = 0 To UBound($aCoordinates) - 1
					SetDebugLog("[" & $j & "] Account coordinates: " & $aCoordinates[$j][0] & "," & $aCoordinates[$j][1] & " named: " & $g_asProfileName[$j])
				Next

				If $iNextAccount + 1 > UBound($aCoordinates, 1) Then
					SetLog("You selected a GooglePlay undetected account!", $COLOR_ERROR)
					Return FuncReturn("Error")
				EndIf

				SetLog("   2. Click Account [" & $iNextAccount + 1 & "]")
				Click($aCoordinates[$iNextAccount][0], $aCoordinates[$iNextAccount][1], 1)
				If _Sleep(600) Then Return FuncReturn("Exit")
				Return FuncReturn("OK")
			EndIf

			If Not $g_bRunState Then Return FuncReturn("Exit")
			If _sleep(1000) Then Return FuncReturn("Exit")
			Return FuncReturn("Error")
		ElseIf (Not $bLateDisconnectButtonCheck Or $i = 6) And UBound(decodeSingleCoord(findImage("Google Play Disconnected", $g_sImgGoogleButtonState & "GooglePlayRed*", GetDiamondFromRect("50,66,800,556"), 1, True, Default)), 1) > 0 Then ; Red, double click did not work, try click Disconnect 1 more time ; Resolution changed ?
			If $bStayDisconnected Then
				ClickAway()
				Return FuncReturn("OK")
			EndIf
			If _Sleep(250) Then Return FuncReturn("Exit")
			If Not $g_bRunState Then Return FuncReturn("Exit")
			SetLog("   1.1. Click Disconnect again")
			Local $aiButtonDisconnect = decodeSingleCoord(findImage("Google Play Connected", $g_sImgGoogleButtonState & "GooglePlayRed*", GetDiamondFromRect("50,66,800,556"), 1, True, Default)) ; Resolution changed ?
			If IsArray($aiButtonDisconnect) And UBound($aiButtonDisconnect, 1) >= 2 Then ClickP($aiButtonDisconnect)
			If _Sleep(600) Then Return FuncReturn("Exit")
		Else ; SupercellID
			Local $aSuperCellIDConnected = decodeSingleCoord(findImage("SupercellID Connected", $g_sImgSupercellIDConnected, GetDiamondFromRect("612,117,691,216"), 1, True, Default)) ; Resolution changed ?
			If IsArray($aSuperCellIDConnected) And UBound($aSuperCellIDConnected, 1) >= 2 Then
				SetLog("Account connected to SuperCell ID, cannot disconnect")
				If $bStayDisconnected Then
					ClickAway()
					Return FuncReturn("OK")
				EndIf
			EndIf
		EndIf
		If $i = 20 Then
			$bResult = False
			;ExitLoop 2
			Return FuncReturn("Error")
		EndIf
		If _Sleep(900) Then Return FuncReturn("Exit")
		If Not $g_bRunState Then Return FuncReturn("Exit")
	Next
	Return FuncReturn("") ; should never get here
EndFunc   ;==>SwitchCOCAcc_ClickAccount

Func SwitchCOCAcc_ConfirmAccount(ByRef $bResult, $iStep = 3, $bDisconnectAfterSwitch = $g_bChkSharedPrefs)
	Local $aiGooglePlayConnected
	For $i = 0 To 30 ; Checking Load Button continuously in 30sec
		If _ColorCheck(_GetPixelColor($aButtonVillageLoad[0], $aButtonVillageLoad[1], True), Hex($aButtonVillageLoad[2], 6), $aButtonVillageLoad[3]) Then ; Load Button
			If _Sleep(250) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			SetLog("   " & $iStep & ". Click Load button")
			Click($aButtonVillageLoad[0], $aButtonVillageLoad[1], 1, 0, "Click Load") ; Click Load

			For $j = 0 To 25 ; Checking Text Box and OKAY Button continuously in 25sec
				If _ColorCheck(_GetPixelColor($aButtonVillageOkay[0], $aButtonVillageOkay[1], True), Hex($aButtonVillageOkay[2], 6), $aButtonVillageOkay[3]) Then ; with modified texts.csv OKAY Button may be already green
					If _Sleep(250) Then Return "Exit"
					SetLog("   " & ($iStep + 1) & ". Click OKAY")
					Click($aButtonVillageOkay[0], $aButtonVillageOkay[1], 1, 0, "Click OKAY")
					SetLog("Please wait for loading CoC")
					$bResult = True
					;ExitLoop 2
					Return "OK"
				ElseIf _ColorCheck(_GetPixelColor($aTextBox[0], $aTextBox[1], True), Hex($aTextBox[2], 6), $aTextBox[3]) Then ; Pink (close icon)
					If _Sleep(250) Then Return "Exit"
					SetLog("   " & ($iStep + 1) & ". Click text box & type CONFIRM")
					Click($aTextBox[0], $aTextBox[1], 1, 0, "Click Text box")
					If _Sleep(500) Then Return "Exit"
					AndroidSendText("CONFIRM")
					ExitLoop
				EndIf
				If $j = 25 Then
					$bResult = False
					;ExitLoop 3
					Return "Error"
				EndIf
				If _Sleep(900) Then Return "Exit"
				If Not $g_bRunState Then Return "Exit"
			Next

			For $k = 0 To 10 ; Checking OKAY Button continuously in 10sec
				If _ColorCheck(_GetPixelColor($aButtonVillageOkay[0], $aButtonVillageOkay[1], True), Hex($aButtonVillageOkay[2], 6), $aButtonVillageOkay[3]) Then
					If _Sleep(250) Then Return "Exit"
					SetLog("   " & ($iStep + 2) & ". Click OKAY")
					Click($aButtonVillageOkay[0], $aButtonVillageOkay[1], 1, 0, "Click OKAY")
					SetLog("Please wait for loading CoC")
					$bResult = True
					If $bDisconnectAfterSwitch Then
						If Not checkMainScreen() Then
							SetLog("Cannot Disconnect account", $COLOR_ERROR)
							Return "Error"
						EndIf
						Click($aButtonSetting[0], $aButtonSetting[1], 1, 0, "Click Setting")
						If _Sleep(500) Then Return
						Switch SwitchCOCAcc_DisconnectConnect($bResult)
							Case 0
								Return "Exit"
							Case -1
								Return "Error"
						EndSwitch
					EndIf

					;ExitLoop 2
					Return "OK"
				EndIf
				If $k = 10 Then
					$bResult = False
					;ExitLoop 3
					Return "Error"
				EndIf
				If _Sleep(900) Then Return "Exit"
				If Not $g_bRunState Then Return "Exit"
			Next
		ElseIf UBound(decodeSingleCoord(findImage("Google Play Connected", $g_sImgGoogleButtonState & "GooglePlayGreen*", GetDiamondFromRect("50,66,800,556"), 1, True, Default)), 1) >= 2 Then ; Resolution changed ?
			SetLog("Already in current account")
			If $bDisconnectAfterSwitch Then
				Switch SwitchCOCAcc_DisconnectConnect($bResult)
					Case -1
						Return "Error"
					Case 0
						Return "Exit"
				EndSwitch
			EndIf
			ClickAway()
			If _Sleep(500) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			$bResult = True
			Return "OK"
		EndIf
		If $i = 30 Then
			$bResult = False
			;ExitLoop 2
			Return "Error"
		EndIf
		If _Sleep(900) Then Return "Exit"
		If Not $g_bRunState Then Return "Exit"
	Next
	Return "" ; should never get here
EndFunc   ;==>SwitchCOCAcc_ConfirmAccount

Func SwitchCOCAcc_ConnectedSCID(ByRef $bResult)
	For $i = 0 To 20 ; Checking Blue Reload button continuously in 20sec
		Local $aSuperCellIDReload = decodeSingleCoord(findImage("SupercellID Reload", $g_sImgSupercellIDReload, GetDiamondFromRect("563,119,612,217"), 1, True, Default)) ; Resolution changed?
		If IsArray($aSuperCellIDReload) And UBound($aSuperCellIDReload, 1) >= 2 Then
			Click($aSuperCellIDReload[0], $aSuperCellIDReload[1], 1, 0, "Click Reload SC_ID")
			Setlog("   1. Click Reload Supercell ID")
			If $g_bDebugSetlog Then SetSwitchAccLog("   1. Click Reload Supercell ID")
			If _Sleep(3000) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			;ExitLoop
			Return "OK"
		EndIf

		If $i = 20 Then
			$bResult = False
			;ExitLoop 2
			Return "Error"
		EndIf
		If _Sleep(900) Then Return "Exit"
		If Not $g_bRunState Then Return "Exit"
	Next
	Return "" ; should never get here
EndFunc   ;==>SwitchCOCAcc_ConnectedSCID

Func SwitchCOCAcc_ClickAccountSCID(ByRef $bResult, $NextAccount, $iStep = 2)
    Local $aSuperCellIDWindowsUI, $bSCIDWindowOpened = False
	Local $iIndexSCID = $NextAccount
	Local $aAccount, $aFound, $aCoord[0][2]
	If Not $g_bRunState Then Return

	For $i = 0 To 30 ; Checking "New SuperCellID UI" continuously in 30sec
		$aSuperCellIDWindowsUI = decodeSingleCoord(findImage("SupercellID Windows", $g_sImgSupercellIDWindows, GetDiamondFromRect("550,60,760,160"), 1, True, Default)) ; Resolution changed ?
		If _Sleep(500) Then Return
		If IsArray($aSuperCellIDWindowsUI) And UBound($aSuperCellIDWindowsUI, 1) >= 2 Then
			SetLog("SupercellID Window Opened", $COLOR_DEBUG)
			$bSCIDWindowOpened = True
			ExitLoop
		EndIf
		If $i = 30 Then
			$bResult = False
			Return "Error"
		EndIf
		If _Sleep(900) Then Return
		If Not $g_bRunState Then Return
	Next

	If $bSCIDWindowOpened Then
		If _Sleep(500) Then Return
		SCIDScrollUp()
		
		SCIDScrollDown($NextAccount) ; Make Drag only when SCID window is visible.
		If _Sleep(1000) Then Return
		$aAccount = QuickMIS("CX", $g_sImgSupercellIDSlots, 750, 320 + $g_iMidOffsetYFixed, 850, 685 + $g_iBottomOffsetYFixed, True, False) ; Resolution changed
		SetLog("Found: " & UBound($aAccount) & " SCID", $COLOR_SUCCESS)
		If IsArray($aAccount) And UBound($aAccount) > 0 Then
			For $j = 0 To UBound($aAccount) - 1
				$aFound = StringSplit($aAccount[$j], ",", $STR_NOCOUNT)
				_ArrayAdd($aCoord, $aFound[0] + 750 & "|" & $aFound[1] + 320)
			Next
			_ArraySort($aCoord, 0, 0, 0, 1)

			; Correct Index for Profile if needs to drag
			If $NextAccount >= 3 Then $iIndexSCID = 3 ; based on drag logic, the account will always be the bottom one

			; list all account see-able after drag on debug chat
			For $j = 0 To UBound($aCoord) - 1
				SetLog("[" & $j & "] Account coordinates: " & $aCoord[$j][0] & "," & $aCoord[$j][1] & " named: " & $g_asProfileName[$NextAccount-$iIndexSCID+$j])
			Next

			If UBound($aCoord) < 4 And $NextAccount >= 3 Then
				SetLog("Only Found " & UBound($aCoord) & " SCID Account", $COLOR_ERROR)
				$bResult = False
				Return "Error"
			EndIf
			
			If UBound($aCoord) <= $iIndexSCID Then 
				SetLog("Error in SCID Account, out of range.", $COLOR_ERROR)
				$bResult = False
				Return "Error"
			EndIf
			
			SetLog("   " & $iStep & ". Click Account [" & $NextAccount + 1 & "] Supercell ID with Profile: " & $g_asProfileName[$NextAccount])
			Click($aCoord[$iIndexSCID][0]-75, $aCoord[$iIndexSCID][1] + 10, 1)
			If _Sleep(750) Then Return
			SetLog("   " & $iStep + 1 & ". Please wait for loading CoC!")
			$bResult = True
			Return "OK"
		Else
			$bResult = False
			Return "Error"
		EndIf
	EndIf
EndFunc   ;==>SwitchCOCAcc_ClickAccountSCID

Func CheckWaitHero() ; get hero regen time remaining if enabled
	Local $iActiveHero
	Local $aHeroResult[$eHeroCount]
	$g_aiTimeTrain[2] = 0

	$aHeroResult = getArmyHeroTime("all")
	If UBound($aHeroResult) < $eHeroCount Then Return ; OCR error

	If _Sleep($DELAYRESPOND) Then Return
	If Not $g_bRunState Then Return
	If $aHeroResult[0] > 0 Or $aHeroResult[1] > 0 Or $aHeroResult[2] > 0 Or $aHeroResult[3] > 0 Then ; check if hero is enabled to use/wait and set wait time
		For $pTroopType = $eKing To $eChampion ; check all 4 hero
			For $pMatchMode = $DB To $g_iModeCount - 1 ; check all attack modes
				$iActiveHero = -1
				If IsUnitUsed($pMatchMode, $pTroopType) And _
						BitOR($g_aiAttackUseHeroes[$pMatchMode], $g_aiSearchHeroWaitEnable[$pMatchMode]) = $g_aiAttackUseHeroes[$pMatchMode] Then ; check if Hero enabled to wait
					$iActiveHero = $pTroopType - $eKing ; compute array offset to active hero
				EndIf
				If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
					; check exact time & existing time is less than new time
					If $g_aiTimeTrain[2] < $aHeroResult[$iActiveHero] Then
						$g_aiTimeTrain[2] = $aHeroResult[$iActiveHero] ; use exact time
					EndIf
				EndIf
			Next
			If _Sleep($DELAYRESPOND) Then Return
			If Not $g_bRunState Then Return
		Next
	EndIf

EndFunc   ;==>CheckWaitHero

Func CheckTroopTimeAllAccount($bExcludeCurrent = False) ; Return the minimum remain training time
	If Not $g_bRunState Then Return
	Local $abAccountNo = AccountNoActive()
	Local $iMinRemainTrain = 999, $iRemainTrain, $bNextAccountDefined = False
	If Not $bExcludeCurrent And Not $g_abPBActive[$g_iCurAccount] Then
		$g_asTrainTimeFinish[$g_iCurAccount] = _DateAdd("n", Number(_ArrayMax($g_aiTimeTrain, 1, 0, 2)), _NowCalc())
		SetDebugLog("Army times: Troop = " & $g_aiTimeTrain[0] & ", Spell = " & $g_aiTimeTrain[1] & ", Hero = " & $g_aiTimeTrain[2] & ", $g_asTrainTimeFinish = " & $g_asTrainTimeFinish[$g_iCurAccount])
	EndIf

	SetSwitchAccLog(" - Train times: ")

	For $i = 0 To $g_iTotalAcc
		If $bExcludeCurrent And $i = $g_iCurAccount Then ContinueLoop
		If $abAccountNo[$i] And Not $g_abDonateOnly[$i] Then ;	Only check Active profiles
			If _DateIsValid($g_asTrainTimeFinish[$i]) Then
				$iRemainTrain = _DateDiff("n", _NowCalc(), $g_asTrainTimeFinish[$i])
				; if remaining time is negative and stop mode, force 0 to ensure other accounts will be picked
				If $iRemainTrain < 0 And SwitchAccountVariablesReload("$g_iCommandStop", $i) <> -1 Then
					; Account was last time in halt attack mode, set time to 0
					$iRemainTrain = 0
					SetLog("Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " halt mode detected, set negative remaining time to 0")
				EndIf
				; Custom schedule - Team AIO Mod++
				If $iRemainTrain >= 0 Then
					SetLog("Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " will have full army in: " & $iRemainTrain & " minutes")
				Else
					SetLog("Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " was ready: " & - $iRemainTrain & " minutes ago")
				EndIf
				If $iMinRemainTrain > $iRemainTrain Then
					If Not $bNextAccountDefined Then $g_iNextAccount = $i
					$iMinRemainTrain = $iRemainTrain
				EndIf
				SetSwitchAccLog("    Acc " & $i + 1 & ": " & $iRemainTrain & "m")
			Else ; for accounts first Run
				SetLog("Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " has not been read its remain train time")
				SetSwitchAccLog("    Acc " & $i + 1 & ": Unknown")
				If Not $bNextAccountDefined Then
					$g_iNextAccount = $i
					$bNextAccountDefined = True
				EndIf
			EndIf
		EndIf
	Next

	SetDebugLog("- Min Remain Train Time is " & $iMinRemainTrain)

	Return $iMinRemainTrain

EndFunc   ;==>CheckTroopTimeAllAccount

Func DisableGUI_AfterLoadNewProfile()
	$g_bGUIControlDisabled = True
	For $i = $g_hFirstControlToHide To $g_hLastControlToHide
		If IsAlwaysEnabledControl($i) Then ContinueLoop
		;If $g_bNotifyPBEnable And $i = $g_hBtnNotifyDeleteMessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
		If BitAND(GUICtrlGetState($i), $GUI_ENABLE) Then GUICtrlSetState($i, $GUI_DISABLE)
	Next
	ControlEnable("", "", $g_hCmbGUILanguage)
	$g_bGUIControlDisabled = False
EndFunc   ;==>DisableGUI_AfterLoadNewProfile

Func aquireSwitchAccountMutex($iSwitchAccountGroup = $g_iCmbSwitchAcc, $bReturnOnlyMutex = False, $bShowMsgBox = False)
	Local $sMsg = GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Msg_SwitchAccounts_InUse", "My Bot with Switch Accounts Group %s is already in use or active.", $iSwitchAccountGroup)
	If $iSwitchAccountGroup Then
		Local $hMutex_Profile = 0
		If $g_ahMutex_SwitchAccountsGroup[0] = $iSwitchAccountGroup And $g_ahMutex_SwitchAccountsGroup[1] Then
			$hMutex_Profile = $g_ahMutex_SwitchAccountsGroup[1]
		Else
			$hMutex_Profile = CreateMutex(StringReplace($g_sProfilePath & "\SwitchAccount.0" & $iSwitchAccountGroup, "\", "-"))
			$g_ahMutex_SwitchAccountsGroup[0] = $iSwitchAccountGroup
			$g_ahMutex_SwitchAccountsGroup[1] = $hMutex_Profile
		EndIf
		;SetDebugLog("Aquire Switch Accounts Group " & $iSwitchAccountGroup & " Mutex: " & $hMutex_Profile)
		If $bReturnOnlyMutex Then
			Return $hMutex_Profile
		EndIf

		If $hMutex_Profile = 0 Then
			; mutex already in use
			SetLog($sMsg, $COLOR_ERROR)
			;SetLog($sMsg, "Cannot switch to profile " & $sProfile, $COLOR_ERROR)
			If $bShowMsgBox Then
				MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION, $MB_TOPMOST), $g_sBotTitle, $sMsg)
			EndIf
		EndIf
		Return $hMutex_Profile <> 0
	EndIf
	Return False
EndFunc   ;==>aquireSwitchAccountMutex

Func releaseSwitchAccountMutex()
	If $g_ahMutex_SwitchAccountsGroup[1] Then
		;SetDebugLog("Release Switch Accounts Group " & $g_ahMutex_SwitchAccountsGroup[0] & " Mutex: " & $g_ahMutex_SwitchAccountsGroup[1])
		ReleaseMutex($g_ahMutex_SwitchAccountsGroup[1])
		$g_ahMutex_SwitchAccountsGroup[0] = 0
		$g_ahMutex_SwitchAccountsGroup[1] = 0
		Return True
	EndIf
	Return False
EndFunc   ;==>releaseSwitchAccountMutex

; Checks if Acc Account is shown and returns true if not or sucessfully switched, clicks first account if $bSelectFirst is true
Func CheckGoogleSelectAccount($bSelectFirst = True)
	Local $bResult = False

	If _CheckPixel($aListAccount, True) Then
		SetDebugLog("Found open Google Accounts list pixel")

		; Account List check be there, validate with imgloc
		If UBound(decodeSingleCoord(FindImageInPlace("GoogleSelectAccount", $g_sImgGoogleSelectAccount, "180,312(90,300)", False))) > 1 Then ; Fixed resolution
			; Google Account selection found
			SetLog("Found open Google Accounts list")

			If $g_bChkSharedPrefs Then
				SetLog("Close Google Accounts list")
				Click(90, 400) ; Close Window
				Return True
			EndIf

			Local $aiSelectGoogleEmail = decodeSingleCoord(FindImageInPlace("GoogleSelectEmail", $g_sImgGoogleSelectEmail, "220,36(400,600)", False)) ; Fixed resolution
			If UBound($aiSelectGoogleEmail) > 1 Then
				SetLog("   1. Click first Google Account")
				ClickP($aiSelectGoogleEmail)
				$bResult = True
				Switch SwitchCOCAcc_ConfirmAccount($bResult, 2)
					Case "OK"
						; all good
					Case "Error"
						; some problem
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
			Else
				SetLog("Cannot find Google Account Email", $COLOR_ERROR)
				$bResult = False
			EndIf
		Else
			SetDebugLog("Open Google Accounts list not verified")
			Click($aAway[0], $aAway[1] + 40, 1)
		EndIf
	Else
		SetDebugLog("CheckGoogleSelectAccount pixel color: " & _GetPixelColor($aListAccount[0], $aListAccount[1], False))
		Click($aAway[0], $aAway[1] + 40, 1)
	EndIf

	Return $bResult
EndFunc   ;==>CheckGoogleSelectAccount

; Checks if "Log in with Supercell ID" boot screen shows up and closes CoC and pushes shared_prefs to fix
Func CheckLoginWithSupercellID($bTestLegacy = False)

	Local $bResult = False

	If Not $g_bRunState Then Return
	
	; Custom Fix - Team AIO Mod++
	Local $bCheckPixel = _ColorCheck(_GetPixelColor($aLoginWithSupercellID[0], $aLoginWithSupercellID[1], False), Hex($aLoginWithSupercellID[2], 6), $aLoginWithSupercellID[3]) And _ColorCheck(_GetPixelColor($aLoginWithSupercellID2[0], $aLoginWithSupercellID2[1], False), Hex($aLoginWithSupercellID2[2], 6), $aLoginWithSupercellID2[3])
	
	; Account List check be there, validate with imgloc
	If $bCheckPixel Then ; Fixed resolution
		; Google Account selection found
		SetLog("Verified Log in with Supercell ID boot screen")

		Local $bSharedPrefsOK = False
		If $bTestLegacy = False Then
			If HaveSharedPrefs($g_sProfileCurrentName) Then
				$bSharedPrefsOK = PushSharedPrefs($g_sProfileCurrentName, True)
				If @error Then
					SetLog("Push SharedPrefs error: " & @error, $COLOR_ERROR) ; that is amazing.
					$bSharedPrefsOK = False
				EndIf

				If $bSharedPrefsOK Then
					SetLog("Close CoC and push shared_prefs for Supercell ID screen")
					Return True
				EndIf
			EndIf
		EndIf
		
		If $bSharedPrefsOK = False Then
			If $g_bChkSuperCellID And ProfileSwitchAccountEnabled() Then ; select the correct account matching with current profile
				Local $NextAccount = 0
				$bResult = True
				For $i = 0 To $g_iTotalAcc
					If $g_abAccountNo[$i] = True And SwitchAccountEnabled($i) And $g_asProfileName[$i] = $g_sProfileCurrentName Then $NextAccount = $i
				Next

				Click($aLoginWithSupercellID[0], $aLoginWithSupercellID[1], 1, 0, "Click Log in with SC_ID")
				If _Sleep(2000) Then Return

				Switch SwitchCOCAcc_ClickAccountSCID($bResult, $NextAccount, 1)
					Case "OK"
						; all good
					Case "Error"
						; some problem
						Return
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
			Else
				SetLog("Cannot close Supercell ID screen, shared_prefs not pulled.", $COLOR_ERROR)
				SetLog("Please resolve Supercell ID screen manually, close CoC", $COLOR_INFO)
				SetLog("and then pull shared_prefs in tab Bot/Profiles.", $COLOR_INFO)
			EndIf
		EndIf
	EndIf

	SetDebugLog("Log in with Supercell ID boot screen not verified")
	Return $bResult
EndFunc   ;==>CheckLoginWithSupercellID

Func CheckLoginWithSupercellIDScreen()

	Local $bResult = False
	Local $aSearchForAccount, $aCoordinates[0][2], $aTempArray
	Local $acount = $g_iWhatSCIDAccount2Use

	If $g_bChkSuperCellID And ProfileSwitchAccountEnabled() Then
		$acount = $g_iCurAccount
	EndIf
	
	; Custom Fix - Team AIO Mod++
	Local $bCheckPixel = _ColorCheck(_GetPixelColor($aLoginWithSupercellID[0], $aLoginWithSupercellID[1], False), Hex($aLoginWithSupercellID[2], 6), $aLoginWithSupercellID[3]) And _ColorCheck(_GetPixelColor($aLoginWithSupercellID2[0], $aLoginWithSupercellID2[1], False), Hex($aLoginWithSupercellID2[2], 6), $aLoginWithSupercellID2[3]) 

	; Account List check be there, validate with imgloc
	If $bCheckPixel Then ; Fixed resolution
		; Google Account selection found
		SetLog("Verified Log in with Supercell ID boot screen for login")

		Click($aLoginWithSupercellID[0], $aLoginWithSupercellID[1], 1, 0, "Click Log in with SC_ID")
		If _Sleep(2000) Then Return

		$bResult = True
		Switch SwitchCOCAcc_ClickAccountSCID($bResult, $acount, 1)
			Case "OK"
				; all good
			Case "Error"
				; some problem
				Return
			Case "Exit"
				; no $g_bRunState
				Return
		EndSwitch
	Else
		SetDebugLog("Log in with Supercell ID boot screen not verified for login")
	EndIf

EndFunc   ;==>CheckLoginWithSupercellIDScreen

Func SwitchAccountCheckProfileInUse($sNewProfile)
	; now check if profile is used in another group
	Local $sInGroups = ""
	For $g = 1 To 8
		If $g = $g_iCmbSwitchAcc Then ContinueLoop
		; find group this profile belongs to: no switch profile config is saved in config.ini on purpose!
		Local $sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g & ".ini"
		If FileExists($sSwitchAccFile) = 0 Then ContinueLoop
		Local $sProfile
		Local $bEnabled
		For $i = 1 To Int(IniRead($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", 0)) + 1
			$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "Enable", "") = "1"
			If $bEnabled Then
				$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
				If $bEnabled Then
					$sProfile = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
					If $sProfile = $sNewProfile Then
						; found profile
						If $sInGroups <> "" Then $sInGroups &= ", "
						$sInGroups &= $g
					EndIf
				EndIf
			EndIf
		Next
	Next

	If $sInGroups Then
		If StringLen($sInGroups) > 2 Then
			$sInGroups = "used in groups " & $sInGroups
		Else
			$sInGroups = "used in group " & $sInGroups
		EndIf
	EndIf

	; test if profile can be aquired
	Local $iAquired = aquireProfileMutex($sNewProfile)
	If $iAquired Then
		If $iAquired = 1 Then
			; ok, release again
			releaseProfileMutex($sNewProfile)
		EndIf

		If $sInGroups Then
			; write to log
			SetLog("Profile " & $sNewProfile & " not active, but " & $sInGroups & "!", $COLOR_ERROR)
			SetSwitchAccLog($sNewProfile & " " & $sInGroups & "!", $COLOR_ERROR)
			Return False
		EndIf

		Return True
	Else
		; write to log
		If $sInGroups Then
			SetLog("Profile " & $sNewProfile & " active and " & $sInGroups & "!", $COLOR_ERROR)
			SetSwitchAccLog($sNewProfile & " active & " & $sInGroups & "!", $COLOR_ERROR)
		Else
			SetLog("Profile " & $sNewProfile & " active in another bot instance!", $COLOR_ERROR)
			SetSwitchAccLog($sNewProfile & " active!", $COLOR_ERROR)
		EndIf
		Return False
	EndIf
EndFunc   ;==>SwitchAccountCheckProfileInUse

; Custom schedule - Team AIO Mod++
Func CheckPlannedAttackLimits()
	$g_bAttackAccountReachLimts[$g_iCurAccount] = _OverAttackLimit()
	SetDebugLog("== CheckPlannedAttackLimits ==")
	SetDebugLog("$g_bAttackPlannerEnable: " & $g_bAttackPlannerEnable)
	SetDebugLog("$g_bAttackAccountReachLimts[$g_iCurAccount]: " & $g_bAttackAccountReachLimts[$g_iCurAccount])
	If $g_bAttackPlannerEnable = False Then Return False
	SetLog("Checking Limits and Schedule to attack!")
	Static $bIsHour2Attack[$g_eTotalAcc] = ["-"]
	If $bIsHour2Attack[0] = "-" Then
		For $ib = 0 To UBound($bIsHour2Attack) -1
			$bIsHour2Attack[$ib] = True
		Next
	EndIf

	Local $bIsAvailable2Attack = False
	Local $abAccountNo = AccountNoActive()
	$bIsHour2Attack[$g_iCurAccount] = IsPlannedTimeNow(False)
	If Not $g_bAttackAccountReachLimts[$g_iCurAccount] And $bIsHour2Attack[$g_iCurAccount] Then Return False
	For $i = 0 To UBound($g_bAttackAccountReachLimts) - 1
		If $abAccountNo[$i] And Not $g_abDonateOnly[$i] Then
			$bIsHour2Attack[$i] = IsPlannedTimeNow(False, $i)
			SetDebugLog("Acount: " & $g_asProfileName[$i] & " | $abAccountNo[" & $i + 1 & "]: " & $abAccountNo[$i])
			SetDebugLog("Acount: " & $g_asProfileName[$i] & " | $g_bAttackAccountReachLimts[" & $i + 1 & "]: " & $g_bAttackAccountReachLimts[$i])
			SetDebugLog("Acount: " & $g_asProfileName[$i] & " | $bIsHour2Attack: " & $bIsHour2Attack[$i])
			If $bIsHour2Attack[$i] Then
				If Not $g_bAttackPlannerDayLimit Or (Not $g_bAttackAccountReachLimts[$i] And $g_bAttackPlannerDayLimit) Then
					SetDebugLog("Account available to attack is : " & $i + 1)
					$bIsAvailable2Attack = True
				EndIf
			EndIf
		EndIf
	Next
	
	If $bIsAvailable2Attack Then
		Return True
	Else
		Local $iWaitTime = _getTimeRemainTimeToday()
		For $i = 0 To UBound($bIsHour2Attack) - 1
			If $abAccountNo[$i] And Not $g_abDonateOnly[$i] And Not $g_bAttackAccountReachLimts[$i] Then
				$iWaitTime = (61 - @MIN) * 60
				SetLog("Account " & $g_asProfileName[$i] & " didn't reach the limit of daily attacks!")
			EndIf
		Next
		
		If $iWaitTime > 3660 Then
			SetLog("Doesn't exist accounts to attack!")
		EndIf
		
		UniversalCloseWaitOpenCoC(TimePickAttackLimits() * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer)
		$g_bRestart = True
		Return False
	EndIf
EndFunc   ;==>CheckPlannedAttackLimits

Func TimePickAttackLimits()
	#REGION
	Static $s_abMinimalTime[$g_eTotalAcc]
	
	Local $aiActiveAccs = AccountNoActive()
	Local $bSafe = $g_sProfileConfigPath, $iSafe = $g_iCurAccount, $iWaitTime = 0
	
	For $eAccNId = 0 To UBound($aiActiveAccs) - 1
		If $aiActiveAccs[$eAccNId] = False Then
			$s_abMinimalTime[$eAccNId] = 604800
			ContinueLoop
		EndIf
		
		$g_sProfileConfigPath = $g_asProfileName[$eAccNId]
		$g_iCurAccount = $eAccNId
		
		; Someone who programs since he was 5 years old does not forget this, the important thing is to reason, not to know, a technician is not better than an engineer.
		$g_sProfileConfigPath = $g_sProfilePath & "\" & $g_sProfileConfigPath & "\config.ini"
		ReadConfig_600_29()
		; _ArrayDisplay($g_abPlannedAttackWeekDays)
		
		$iWaitTime = 0
		
		If _Sleep($DELAYRESPOND) Then Return True
		Local $bCloseGameAtaall = $g_bAttackPlannerCloseCoC = True Or $g_bAttackPlannerCloseAll = True Or $g_bAttackPlannerSuspendComputer = True
		If $bCloseGameAtaall Then
			; Custom schedule - Team AIO Mod++
			; determine how long to close CoC or emulator if selected
			If $g_abPlannedAttackWeekDays[$eAccNId][@WDAY - 1] = False Then
				$iWaitTime = _getTimeRemainTimeToday() ; get number of seconds remaining till Midnight today
				For $i = @WDAY To 6
					If Not $g_abPlannedAttackWeekDays[$eAccNId][$i] Then $iWaitTime += 86400 ; add 1 day of seconds to wait time
					If $g_abPlannedAttackWeekDays[$eAccNId][$i] Then ExitLoop ; stop adding days when find attack planner enabled
					; SetDebugLog("Subtotal wait time= " & $iWaitTime & " Seconds", $COLOR_DEBUG)
				Next
			EndIf
			If $iWaitTime = 0 Then ; if days are not set then compute wait time from hours
				If $g_abPlannedAttackWeekDays[$eAccNId][@WDAY - 1] And $g_abPlannedattackHours[$eAccNId][@HOUR] = False Then
					$iWaitTime += (59 - @MIN) * 60 ; compute seconds left this hour
					For $i = @HOUR + 1 To 23
						If Not $g_abPlannedattackHours[$eAccNId][$i] Then $iWaitTime += 3600 ; add 1 hour of seconds to wait time
						If $g_abPlannedattackHours[$eAccNId][$i] Then ExitLoop ; stop adding hours when find attack planner enabled
						; SetDebugLog("Subtotal wait time= " & $iWaitTime & " Seconds", $COLOR_DEBUG)
					Next
				EndIf
			EndIf
		EndIf
		
		$s_abMinimalTime[$eAccNId] = $iWaitTime
	Next
	
	; _ArrayDisplay($s_abMinimalTime)
	Local $iMinimalTime = _ArrayMin($s_abMinimalTime)
	
	$g_sProfileConfigPath = $bSafe
	$g_iCurAccount = $iSafe
	ReadConfig_600_29()
	#ENDREGION
	Return $iMinimalTime
EndFunc   ;==>TimePickAttackLimits

; Custom schedule - Team AIO Mod++
Func CheckPlannedAccountLimits($bForceSwitch = False)
	SetDebugLog("== CheckPlannedAccountLimits ==")
	Local $abAccountNo = AccountNoActive()
	Static $bIsHour2Attack[$g_eTotalAcc] = ["-"]
	If $bIsHour2Attack[0] = "-" Then
		For $ib = 0 To UBound($bIsHour2Attack) -1
			$bIsHour2Attack[$ib] = True
		Next
	EndIf

	$bIsHour2Attack[$g_iCurAccount] = IsPlannedTimeNow(False)
	If $g_bChkSmartSwitch = True Then
		SetDebugLog("== CheckTroopTimeAllAccount ==")
		Local $iMinRemainTrain = CheckTroopTimeAllAccount($bForceSwitch)
		SetDebugLog("$iMinRemainTrain: " & $iMinRemainTrain)
		Local $Account2Return = $g_iCurAccount
		For $j = 0 To UBound($abAccountNo) - 1
			If $abAccountNo[$j] And Not $g_abDonateOnly[$j] Then
				$bIsHour2Attack[$j] = IsPlannedTimeNow(False, $j)
				SetDebugLog("2-Acount: " & $g_asProfileName[$j] & " | $abAccountNo[$j]: " & $abAccountNo[$j])
				SetDebugLog("2-Acount: " & $g_asProfileName[$j] & " | $g_bAttackAccountReachLimts[$j]: " & $g_bAttackAccountReachLimts[$j])
				SetDebugLog("2-Acount: " & $g_asProfileName[$j] & " | $bIsHour2Attack: " & $bIsHour2Attack[$j])
				If _DateDiff("n", _NowCalc(), $g_asTrainTimeFinish[$j]) < $iMinRemainTrain And Not $g_bAttackAccountReachLimts[$j] And $bIsHour2Attack[$j] Then
					$iMinRemainTrain = _DateDiff("n", _NowCalc(), $g_asTrainTimeFinish[$j])
					SetDebugLog("2-Account available to attack is : " & $j)
					$Account2Return = $j
				EndIf
			EndIf
		Next
		SetDebugLog("2-Account available to attack is and smaller time is: " & $Account2Return)
		Return $Account2Return
	Else
		Local $iNextAccount = $g_iCurAccount + 1
		If $iNextAccount > $g_iTotalAcc Then $iNextAccount = 0
		For $i = 0 To $g_eTotalAcc - 1
			If $iNextAccount > $g_iTotalAcc Then $iNextAccount = 0
			SetDebugLog("2-Checking the account: " & $iNextAccount + 1)
			$bIsHour2Attack[$iNextAccount] = IsPlannedTimeNow(False, $iNextAccount)
			If $abAccountNo[$iNextAccount] And Not $g_abDonateOnly[$iNextAccount] And Not $g_bAttackAccountReachLimts[$iNextAccount] And $bIsHour2Attack[$iNextAccount] Then
				SetDebugLog("2-Account available to attack is : " & $iNextAccount + 1)
				Return $iNextAccount
			EndIf
			$iNextAccount += 1
		Next
	EndIf
	Return $g_iCurAccount
EndFunc   ;==>CheckPlannedAccountLimits

; Boldina TM - Swipe 2022 
Func SCIDScrollDown($iSCIDAccount)
	If Not $g_bRunState Then Return
	
	Local $x1 = Random(450, 457, 1)
	Local $x2 = Random(450, 457, 1)
	Local $y  = Random(542, 546, 1)
	
	If $iSCIDAccount = 3 Then 
		AndroidInputSwipe($x1, $y, $x2, $y - 61, $g_bRunState, True)
		If _Sleep(Random(400, 700, 1)) Then Return
		Return True
	EndIf
	
	If $iSCIDAccount < 4 Then Return
	
	AndroidInputSwipe($x1, $y, $x2, $y - (94 * ($iSCIDAccount - 3)) - 61, $g_bRunState, True) ; drag a multiple of 90 pixels up for how many accounts down it is
	If _Sleep(Random(400, 700, 1)) Then Return
	
	Return True
EndFunc   ;==>SCIDScrollDown

Func SCIDScrollUp()
	If Not $g_bRunState Then Return
	SetLog("Try to scroll up", $COLOR_DEBUG)
	For $i = 1 To 6
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(786, 340 + $g_iMidOffsetYFixed, False), Hex(0xF1F1F1, 6), 10) = True And _ColorCheck(_GetPixelColor(786, 357 + $g_iMidOffsetYFixed, False), Hex(0xEFEFEF, 6), 10) = True Then Return True
		Swipe(Random(450, 456, 1), 316, Random(450, 456, 1), 316 + Random(100, 400, 1), 1000)
		If _Sleep(500) Then Return
	Next
	Return False
EndFunc   ;==>SCIDScrollUp
