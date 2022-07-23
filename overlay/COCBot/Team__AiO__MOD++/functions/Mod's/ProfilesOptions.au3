; #FUNCTION# ====================================================================================================================
; Name ..........: Farm Schedule
; Description ...: Farm Schedule for Switch Accounts
; Author ........: Demen
; Modified ......: Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckFarmSchedule()

	If Not ProfileSwitchAccountEnabled() Then Return

	Static $aiActionDone = $g_PreResetZero
	Static $iStartHour = @HOUR
	Static $iDay = @YDay
	Local $bNeedRunBot = False

	If $g_bFirstStart And $iStartHour = -1 Then $iStartHour = @HOUR
	Local $bActionDone = False
	SetDebugLog("Checking Farm Schedule...", $COLOR_DEBUG)

	For $i = 0 To 7
		If $i > $g_iTotalAcc Then ExitLoop

		If $iDay < @YDay Then ; reset timers
			$aiActionDone[$i] = 0
			$iStartHour = -1
			If $i >= _Min($g_iTotalAcc, 7) Then $iDay = @YDay
			SetDebugLog("New day is coming $iDay/ @YDay : " & $iDay & "/ " & @YDay, $COLOR_DEBUG)
		EndIf
		If $g_abChkSetFarm[$i] Then
			Local $iAction = -1

			; Check timing schedule
			Local $iTimer1 = 25, $iTimer2 = 25
			If $g_aiCmbAction1[$i] >= 1 And $g_aiCmbCriteria1[$i] = 5 And $g_aiCmbTime1[$i] >= 0 Then $iTimer1 = Number($g_aiCmbTime1[$i])
			If $g_aiCmbAction2[$i] >= 1 And $g_aiCmbCriteria2[$i] = 5 And $g_aiCmbTime2[$i] >= 0 Then $iTimer2 = Number($g_aiCmbTime2[$i])
			SetDebugLog($i + 1 & ". $iTimer1: " & $iTimer1 & ", $iTimer2: " & $iTimer2 & ", Max: " & _Max($iTimer1, $iTimer2) & ", Min: " & _Min($iTimer1, $iTimer2) & ", ActionDone: " & $aiActionDone[$i], $COLOR_DEBUG)

			If @HOUR < _Min($iTimer1, $iTimer2) Then ; both timers are ahead.
				;Do nothing
			ElseIf @HOUR < _Max($iTimer1, $iTimer2) Then ; 1 timer has passed, 1 timer ahead
				If $iTimer1 < $iTimer2 Then ; reach timer1, let's do action1
					If $aiActionDone[$i] <> 1 And $iStartHour < $iTimer1 Then
						$iAction = $g_aiCmbAction1[$i] - 1
						$aiActionDone[$i] = 1
					EndIf
				Else ; reach timer2, let's do action2
					If $aiActionDone[$i] <> 2 And $iStartHour < $iTimer2 Then
						$iAction = $g_aiCmbAction2[$i] - 1
						$aiActionDone[$i] = 2
					EndIf
				EndIf
				SetDebugLog($i + 1 & ". @HOUR (<): " & @HOUR & ", ActionDone: " & $aiActionDone[$i] & ", StartHour: " &$iStartHour & ", Action: " & $iAction, $COLOR_DEBUG)
			Else ; passed both timers
				If $iTimer1 < $iTimer2 Then
					If $aiActionDone[$i] <> 2 And $iStartHour < $iTimer2 Then
						$iAction = $g_aiCmbAction2[$i] - 1
						$aiActionDone[$i] = 2
					EndIf
				Else
					If $aiActionDone[$i] <> 1 And $iStartHour < $iTimer1 Then
						$iAction = $g_aiCmbAction1[$i] - 1
						$aiActionDone[$i] = 1
					EndIf
				EndIf
				SetDebugLog($i + 1 & ". @HOUR (>): " & @HOUR & ", ActionDone: " & $aiActionDone[$i] & ", StartHour: " &$iStartHour & ", Action: " & $iAction, $COLOR_DEBUG)
			EndIf

			; Check resource criteria for current account
			If $i = $g_iCurAccount Then
				Local $asText[4] = ["Gold", "Elixir", "DarkE", "Trophy"]
				While 1
					If $g_aiCmbAction1[$i] >= 1 And $g_aiCmbCriteria1[$i] >= 1 And $g_aiCmbCriteria1[$i] <= 4 Then
						For $r = 1 To 4
							If $g_aiCmbCriteria1[$i] = $r And Number($g_aiCurrentLoot[$r - 1]) >= Number($g_aiTxtResource1[$i]) Then
								SetLog("Village " & $asText[$r - 1] & " detected above 1st criterium: " & $g_aiTxtResource1[$i])
								$iAction = $g_aiCmbAction1[$i] - 1
								ExitLoop 2
							EndIf
						Next
					EndIf
					If $g_aiCmbAction2[$i] >= 1 And $g_aiCmbCriteria2[$i] >= 1 And $g_aiCmbCriteria2[$i] <= 4 Then
						For $r = 1 To 4
							If $g_aiCmbCriteria2[$i] = $r And Number($g_aiCurrentLoot[$r - 1]) < Number($g_aiTxtResource2[$i]) And Number($g_aiCurrentLoot[$r - 1]) > 1 Then
								SetLog("Village " & $asText[$r - 1] & " detected below 2nd criterium: " & $g_aiTxtResource2[$i])
								$iAction = $g_aiCmbAction2[$i] - 1
								ExitLoop 2
							EndIf
						Next
					EndIf
					ExitLoop
				WEnd
			EndIf

			; Action
			Switch $iAction
				Case 0 ; turn Off (idle)
					If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then

						; Checking if this is the last active account
						Local $iSleeptime = CheckLastActiveAccount($i)
						If $iSleeptime > 1 Then
							SetLog("This is the last active/donate account to turn off.")
							SetLog("Let's go sleep until another account is scheduled to turn active/donate")
							SetSwitchAccLog("   Acc. " & $i + 1 & " go sleep", $COLOR_BLUE)
							UniversalCloseWaitOpenCoC($iSleeptime * 60 * 1000, "FarmSchedule", False, True) ; wake up & full restart
						EndIf

						GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
						chkAccount($i)
						$bActionDone = True
						If $i = $g_iCurAccount Then $g_bInitiateSwitchAcc = True
						SetLog("Acc [" & $i + 1 & "] turned OFF")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Idle", $COLOR_BLUE)
					EndIf
				Case 1 ; turn Donate
					If GUICtrlRead($g_ahChkDonate[$i]) = $GUI_UNCHECKED Then
						_GUI_Value_STATE("CHECKED", $g_ahChkAccount[$i] & "#" & $g_ahChkDonate[$i])
						$bActionDone = True
						If $i = $g_iCurAccount Then $bNeedRunBot = True
						SetLog("Acc [" & $i + 1 & "] turned ON for Donating")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Donate", $COLOR_BLUE)
					EndIf
				Case 2 ; turn Active
					If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_UNCHECKED Or GUICtrlRead($g_ahChkDonate[$i]) = $GUI_CHECKED Then
						GUICtrlSetState($g_ahChkAccount[$i], $GUI_CHECKED)
						GUICtrlSetState($g_ahChkDonate[$i], $GUI_UNCHECKED)
						$bActionDone = True
						If $i = $g_iCurAccount Then $bNeedRunBot = True
						SetLog("Acc [" & $i + 1 & "] turned ON for Farming")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Active", $COLOR_BLUE)
					EndIf
			EndSwitch
		EndIf
	Next

	If $bActionDone Then
		SaveConfig_600_35_2() ; Save config profile after changing botting type
		ReadConfig_600_35_2() ; Update variables
		UpdateMultiStats(False)
	EndIf

	If _Sleep(500) Then Return
	If $g_bInitiateSwitchAcc Then
		Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)
		If UBound($aActiveAccount) >= 1 Then
			$g_iNextAccount = $aActiveAccount[0]
			If $g_sProfileCurrentName <> $g_asProfileName[$g_iNextAccount] Then
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
			runBot()
		EndIf

	ElseIf $bNeedRunBot Then
		runBot()
	EndIf
EndFunc   ;==>CheckFarmSchedule

Func CheckLastActiveAccount($i)

	Local $iSleeptime = 0 ; result in minutes
	Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)

	If $i = $g_iCurAccount And UBound($aActiveAccount) <= 1 Then
		SetLog("  This is the last active/donate account to turn off.")

		Local $iCurrentTime = @HOUR + @MIN / 60 + @SEC / 3600 ; decimal hour
		Local $iSoonestTimer = -1
		For $i = 0 To 7
			If $i > $g_iTotalAcc Then ExitLoop
			If $g_abChkSetFarm[$i] Then
				If $g_aiCmbAction1[$i] >= 1 And $g_aiCmbCriteria1[$i] = 5 And $g_aiCmbTime1[$i] >= 0 Then
					Local $ConvertTime1 = $g_aiCmbTime1[$i] + $g_aiCmbTime1[$i] <= @HOUR ? 24 : 0
					If $iSoonestTimer = -1 Or $iSoonestTimer > $ConvertTime1 Then $iSoonestTimer = $ConvertTime1
				EndIf
				If $g_aiCmbAction2[$i] >= 1 And $g_aiCmbCriteria2[$i] = 5 And $g_aiCmbTime2[$i] >= 0 Then
					Local $ConvertTime2 = $g_aiCmbTime2[$i] + $g_aiCmbTime2[$i] <= @HOUR ? 24 : 0
					If $iSoonestTimer = -1 Or $iSoonestTimer > $ConvertTime2 Then $iSoonestTimer = $ConvertTime2
				EndIf
				SetDebugLog("@Hour: " & @HOUR & "Timers " & $i + 1 & ": " & $g_aiCmbTime1[$i] & " / " & $g_aiCmbTime2[$i] & ". $iSoonestTimer = " & $iSoonestTimer)
			EndIf
		Next
		SetDebugLog("$iSoonestTimer = " & $iSoonestTimer)
		If $iSoonestTimer >= 0 Then $iSleeptime = ($iSoonestTimer - $iCurrentTime) * 60
	EndIf

	SetDebugLog("$iSleeptime: " & Round($iSleeptime, 2) & " m")

	Return $iSleeptime

EndFunc   ;==>CheckLastActiveAccount

; #FUNCTION# ====================================================================================================================
; Name ..........: Switch Profiles
; Description ...:
; Author ........: Demen
; Modified ......: Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ProfileSwitch()

	For $i = 0 To 3
		If $g_abChkSwitchMax[$i] Or $g_abChkSwitchMin[$i] Or $g_abChkBotTypeMax[$i] Or $g_abChkBotTypeMin[$i] Then
			ExitLoop
		Else
			If $i = 3 Then Return
		EndIf
	Next

	Local $iSwitchToProfile = -1, $iChangeBotType = -1
	Local $asText[4] = ["Gold", "Elixir", "Dark Elixir", "Trophy"]
	Local $bSwitchDone = False, $bChangBotTypeDone = False

	For $i = 0 To 3
		If $g_abChkSwitchMax[$i] Or $g_abChkBotTypeMax[$i] Then
			If Number($g_aiCurrentLoot[$i]) >= Number($g_aiConditionMax[$i]) Then
				SetLog("Village " & $asText[$i] & " detected above " & $asText[$i] & " Switch Condition: " & $g_aiCurrentLoot[$i] & "/" & $g_aiConditionMax[$i])
				If $g_abChkSwitchMax[$i] Then $iSwitchToProfile = $g_aiCmbSwitchMax[$i]
				If $g_abChkBotTypeMax[$i] Then $iChangeBotType = $g_aiCmbBotTypeMax[$i]
				ExitLoop
			EndIf
		EndIf
		If $g_abChkSwitchMin[$i] Or $g_abChkBotTypeMin[$i] Then
			If Number($g_aiCurrentLoot[$i]) < Number($g_aiConditionMin[$i]) And Number($g_aiCurrentLoot[$i]) > 1 Then
				SetLog("Village " & $asText[$i] & " detected below " & $asText[$i] & " Switch Condition: " & $g_aiCurrentLoot[$i] & "/" & $g_aiConditionMin[$i])
				If $g_abChkSwitchMin[$i] Then $iSwitchToProfile = $g_aiCmbSwitchMin[$i]
				If $g_abChkBotTypeMin[$i] Then $iChangeBotType = $g_aiCmbBotTypeMin[$i]
				ExitLoop
			EndIf
		EndIf
	Next

	If $iSwitchToProfile >= 0 Or $iChangeBotType >= 0 Then
		TrayTip(" Profile Switch Village Report!", "Gold: " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & "; Elixir: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & "; Dark Elixir: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & "; Trophy: " & _NumberFormat($g_aiCurrentLoot[$eLootTrophy]), "", 0)

		If $iSwitchToProfile >= 0 Then
			; change profile in the account list
			If ProfileSwitchAccountEnabled() Then
				If $iSwitchToProfile <> _GUICtrlComboBox_GetCurSel($g_ahCmbProfile[$g_iCurAccount]) Then
					_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$g_iCurAccount], $iSwitchToProfile)
					SetLog("Acc [" & $g_iCurAccount + 1 & "] is now matched with Profile: " & GUICtrlRead($g_ahCmbProfile[$g_iCurAccount]))
				EndIf
			EndIf
			; change profile in main tab bot
			If $iSwitchToProfile <> _GUICtrlComboBox_GetCurSel($g_hCmbProfile) Then
				_GUICtrlComboBox_SetCurSel($g_hCmbProfile, $iSwitchToProfile)
				SetLog("Switched to Profile: " & GUICtrlRead($g_hCmbProfile))
				$bSwitchDone = True
				If ProfileSwitchAccountEnabled() Then $g_bReMatchAcc = True
			EndIf
		EndIf

		If ProfileSwitchAccountEnabled() Then
			Switch $iChangeBotType
				Case 0 ; turn Off (idle)
					If GUICtrlRead($g_ahChkAccount[$g_iCurAccount]) = $GUI_CHECKED Then
						GUICtrlSetState($g_ahChkAccount[$g_iCurAccount], $GUI_UNCHECKED)
						chkAccount($g_iCurAccount)
						SetLog("Acc [" & $g_iCurAccount + 1 & "] is now turned off")
						$bChangBotTypeDone = True
					EndIf
				Case 1 ; turn Donate
					If GUICtrlRead($g_ahChkDonate[$g_iCurAccount]) = $GUI_UNCHECKED Then
						_GUI_Value_STATE("CHECKED", $g_ahChkAccount[$g_iCurAccount] & "#" & $g_ahChkDonate[$g_iCurAccount])
						SetLog("Acc [" & $g_iCurAccount + 1 & "] is now for Donating only")
						$bChangBotTypeDone = True
					EndIf
				Case 2 ; turn Active
					If GUICtrlRead($g_ahChkAccount[$g_iCurAccount]) = $GUI_UNCHECKED Or GUICtrlRead($g_ahChkDonate[$g_iCurAccount]) = $GUI_CHECKED Then
						GUICtrlSetState($g_ahChkAccount[$g_iCurAccount], $GUI_CHECKED)
						GUICtrlSetState($g_ahChkDonate[$g_iCurAccount], $GUI_UNCHECKED)
						SetLog("Acc [" & $g_iCurAccount + 1 & "] starts Farming now")
						$bChangBotTypeDone = True
					EndIf
			EndSwitch
			If $bChangBotTypeDone Then $g_bInitiateSwitchAcc = True
		EndIf

		If _Sleep(500) Then Return

		If $bSwitchDone Or $bChangBotTypeDone Then
			If $bSwitchDone Then
				cmbProfile()
				DisableGUI_AfterLoadNewProfile()
			Else
				saveConfig()
				readConfig()
				UpdateMultiStats()
			EndIf
			runBot()
		EndIf
	EndIf

EndFunc   ;==>ProfileSwitch
