; #FUNCTION# ====================================================================================================================
; Name ..........: CheckStopForWar
; Description ...: 
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......: Chilly-Chill (08/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CheckStopForWar()

	Local $asResetTimer[$g_eTotalAcc] = ["", "", "", "", "", "", "", ""], $abResetBoolean = $g_PreResetFalse
	Static $sTimeToRecheck = "", $bTimeToStop = False ; single account mode
	Static $asTimeToRecheck[$g_eTotalAcc] = ["", "", "", "", "", "", "", ""], $abTimeToStop = $g_PreResetFalse ; switch account mode
	Static $asTimeToReturn[$g_eTotalAcc] = ["", "", "", "", "", "", "", ""]
	Static $abStopForWar = $g_PreResetFalse
	Static $abTrainWarTroop = $g_PreResetFalse

	If $g_bFirstStart Then ; reset statics
		$sTimeToRecheck = ""
		$bTimeToStop = False
	EndIf

	If ProfileSwitchAccountEnabled() Then
		If $g_bFirstStart Then ; reset statics all accounts
			$asTimeToRecheck = $asResetTimer
			$asTimeToReturn = $asResetTimer
			$abTimeToStop = $abResetBoolean
			$abStopForWar = $abResetBoolean
			$abTrainWarTroop = $abResetBoolean
		EndIf

		; Load Timer of Current Account
		$sTimeToRecheck = $asTimeToRecheck[$g_iCurAccount]
		$bTimeToStop = $abTimeToStop[$g_iCurAccount]

		; Circulate all accounts to turn Active if reaching TimeToReturn / Idle if reaching TimeToStop and Not need to train war troop
		$abStopForWar[$g_iCurAccount] = $g_bStopForWar
		$abTrainWarTroop[$g_iCurAccount] = $g_bTrainWarTroop
		For $i = 0 To $g_iTotalAcc
			If $i = $g_iCurAccount Or Not $abStopForWar[$i] Then ContinueLoop ; bypass Current account Or Feature disable
			If _DateIsValid($asTimeToReturn[$i]) Then
				If _DateDiff("n", _NowCalc(), $asTimeToReturn[$i]) <= 0 Then
					SetLog("Account [" & $i + 1 & "] should back to farm now.", $COLOR_INFO)
					If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_UNCHECKED Then
						GUICtrlSetState($g_ahChkAccount[$i], $GUI_CHECKED)
						chkAccount($i)
						SaveConfig_600_35_2() ; Save config profile after changing botting type
						ReadConfig_600_35_2() ; Update variables
						UpdateMultiStats()
						SetLog("Acc [" & $i + 1 & "] turned ON")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Active for farm", $COLOR_ACTION)
					EndIf
				EndIf
			EndIf

			If Not $abTimeToStop[$i] Or $abTrainWarTroop[$i] Then ContinueLoop ; bypass if Not yet time to stop Or Need train war troop
			If _DateIsValid($asTimeToRecheck[$i]) Then
				If _DateDiff("n", _NowCalc(), $asTimeToRecheck[$i]) <= 0 Then
					SetLog("Account [" & $i + 1 & "] should stop for war now.", $COLOR_INFO)
					If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then
						GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
						chkAccount($i)
						SaveConfig_600_35_2() ; Save config profile after changing botting type
						ReadConfig_600_35_2() ; Update variables
						UpdateMultiStats()
						SetLog("Acc [" & $i + 1 & "] turned OFF")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Idle for war", $COLOR_ACTION)
					EndIf
				EndIf
			EndIf
		Next
	EndIf

	If Not $g_bStopForWar Then Return

	If _DateIsValid($sTimeToRecheck) Then
		If _DateDiff("n", _NowCalc(), $sTimeToRecheck) > 0 Then Return
		If $bTimeToStop Then SetLog("Should be time to stop for war now. Let's have a look", $COLOR_INFO)
	EndIf

	Local $bCurrentWar = False, $sBattleEndTime = "", $bInWar, $iSleepTime = -1
	$bCurrentWar = CheckWarTime($sBattleEndTime, $bInWar)
	If @error Or Not _DateIsValid($sBattleEndTime) Then ; Incase error was returned go to home
		ReturnToHomeFromWar()
		Return
	EndIf
	If Not $bCurrentWar Then
		$sTimeToRecheck = _DateAdd("h", 6, _NowCalc())
		SetLog("Will come back to check in 6 hours", $COLOR_INFO)
	Else
		If Not $bInWar Then
			$sTimeToRecheck = $sBattleEndTime
			SetLog("Will come back to check after current war finish: " & $sTimeToRecheck, $COLOR_INFO)
		Else

			Local $iBattleEndTime = _DateDiff("h", _NowCalc(), $sBattleEndTime) ; in hours
			SetDebugLog("$iBattleEndTime: " & Round($iBattleEndTime, 2) & " hours")

			Local $iTimerToStop = $iBattleEndTime - 24 + Number($g_iStopTime)
			SetDebugLog("$iTimerToStop: " & Round($iTimerToStop, 2) & " hours")

			If $iTimerToStop > 0 Then
				$sTimeToRecheck = _DateAdd("h", $iTimerToStop, _NowCalc())
				SetLog("Will stop for war preparation in " & Int($iTimerToStop) & "h " & Mod($iTimerToStop * 60, 60) & "m", $COLOR_INFO)
				$bTimeToStop = True
			Else
				$sTimeToRecheck = "" ; remove timer
				$bTimeToStop = False

				$iSleepTime = $iBattleEndTime - $g_iReturnTime
				If $iSleepTime < 1 Then
					SetLog("It's time to stop for war. But stop time window is too tight, just skip and continue", $COLOR_INFO)
					SetLog("Will come back to check in 6 hours", $COLOR_INFO)
					$sTimeToRecheck = _DateAdd("h", 6, _NowCalc())
				EndIf
			EndIf
		EndIf
	EndIf

	If ProfileSwitchAccountEnabled() Then ; Save Timer of Current Account
		$asTimeToRecheck[$g_iCurAccount] = $sTimeToRecheck
		$abTimeToStop[$g_iCurAccount] = $bTimeToStop
		If $iSleepTime >= 1 Then $asTimeToReturn[$g_iCurAccount] = _DateAdd("h", $iSleepTime, _NowCalc())
	EndIf

	If $iSleepTime >= 1 Then
		SetLog("Stop and prepare for war now", $COLOR_INFO)
		StopAndPrepareForWar($iSleepTime) ; quit function here
	EndIf

EndFunc   ;==>CheckStopForWar

Func IsWarMenu()

	If RandomSleep(250) Then Return
	
	Local $bResult = _Wait4Pixel(826, 34, 0xFFFFFF, 25, 3000, 100, "IsWarMenu")
	Return $bResult
EndFunc   ;==>IsWarMenu

Func CheckWarTime(ByRef $sResult, ByRef $bResult, $bReturnFrom = True) ; return [Success + $sResult = $sBattleEndTime, $bResult = $bInWar] OR Failure
	Local $directoryDay = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\WarPage\Day"
	Local $directoryTime = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\WarPage\Time"
	Local $bBattleDay_InWar, $sWarDay, $sTime
	Local $bLocalReturn = False
	
	$g_bClanWarLeague = False
	$g_bClanWar = False
	$sResult = ""
	
	If IsMainPage(1) = False Then
		CheckMainScreen(False)
	EndIf
	
	_CaptureRegion()
	$bBattleDay_InWar = _ColorCheck(_GetPixelColor(45, 500 + $g_iBottomOffsetYFixed, False), "ED151D", 20) ; Red color in war button
	$g_bClanWarLeague = _ColorCheck(_GetPixelColor(10, 510 + $g_iBottomOffsetYFixed, False), "FFED71", 20) ; Golden color at left side of clan war button
	$g_bClanWar = _ColorCheck(_GetPixelColor(36, 502 + $g_iBottomOffsetYFixed, False), "F0B345", 20) ; Ordinary war color at left side of clan war button
	If $g_bClanWarLeague Then SetDebugLog("Your Clan Is Doing Clan War League.", $COLOR_INFO)
	SetDebugLog("Checking battle notification, $bBattleDay_InWar = " & $bBattleDay_InWar)
	
	Click(40, 530) ; open war menu
	
	If RandomSleep(5000) Then Return
	
	If _Wait4PixelGoneArray($aIsMain) = False Then
		SetLog("War check fail.", $COLOR_ERROR)
		$bLocalReturn = False
	EndIf

	Local $sDirectory = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\WarPage\Window"
	If _WaitForCheckImg($sDirectory, "339, 13, 847, 585") Then ; Check Clan War Leage Result [X] or View Map. ; Resolution changed
		Click($g_aImageSearchXML[0][1], $g_aImageSearchXML[0][2])
		SetLog("War is finished.", $COLOR_WARNING)
		If RandomSleep(1000) Then Return False
		$bLocalReturn = False
		$bResult = False
	ElseIf IsWarMenu() Then
		If $bBattleDay_InWar Then
			$sWarDay = "Battle"
			$bResult = True
		Else
			If $g_bClanWarLeague Then
				If QuickMIS("BC1", $directoryDay & "\CWL_Preparation", 175, 645 + $g_iBottomOffsetYFixed, 175 + 515, 645 + $g_iBottomOffsetYFixed + 30, True) Then ; By Default Battle Days Opens So Find Prepration Button ; Resolution changed
					SetDebugLog("CWL Enter In Preparation page")
					Click($g_iQuickMISX, $g_iQuickMISY, 1)
					If _Sleep(500) Then Return
					If Not IsWarMenu() Then
						SetLog("Error when trying to open CWL Preparation page.", $COLOR_ERROR)
						$bLocalReturn = SetError(1, 0, "Error Open CWL Preparation page")
					EndIf
				ElseIf QuickMIS("BC1", $directoryDay & "\CWL_Battle", 175, 645 + $g_iBottomOffsetYFixed, 175 + 515, 645 + 30 + $g_iBottomOffsetYFixed, True) Then ; When Battle Day Is Unselected ; Resolution changed
					SetDebugLog("CWL Enter In Battle page")
					Click($g_iQuickMISX, $g_iQuickMISY, 1)
					If _Sleep(500) Then Return
					If Not IsWarMenu() Then
						SetLog("Error when trying to open CWL Battle page.", $COLOR_ERROR)
						$bLocalReturn = SetError(1, 0, "Error Open CWL Battle page")
					EndIf
				EndIf
			EndIf
			$sWarDay = QuickMIS("N1", $directoryDay, 360, 85 + $g_iMidOffsetYFixed, 360 + 145, 85 + $g_iMidOffsetYFixed + 28, True) ; Prepare or Battle ; Resolution changed ?
			$bResult = Not (QuickMIS("BC1", $directoryDay, 359, 127 + $g_iMidOffsetYFixed, 510, 154 + $g_iMidOffsetYFixed, True)) ; $bInWar.... Fixed (08/2019) ; Resolution changed ?
			SetDebugLog("$sResult QuickMIS N1/BC1: " & $sWarDay & "/ " & $bResult)
			If $sWarDay = "none" Then 
				$bLocalReturn =  SetError(1, 0, "Error reading war day")
			EndIf
		EndIf

		If Not StringInStr($sWarDay, "Battle") And Not StringInStr($sWarDay, "Preparation") Then
			SetLog("Your Clan is not in active war yet.", $COLOR_INFO)
			$bLocalReturn = False
		Else
			$sTime = QuickMIS("OCR", $directoryTime, 396, 65 + $g_iMidOffsetYFixed, 396 + 70, 70 + 30 + $g_iMidOffsetYFixed, True) ; Resolution changed?
			SetDebugLog("$sResult QuickMIS OCR: " & ($bBattleDay_InWar ? $sWarDay & ", " : "") & $sTime)
			If $sTime = "none" Then Return SetError(1, 0, "Error reading war time")

			Local $iConvertedTime = ConvertOCRTime("War", $sTime, False)
			If $iConvertedTime = 0 Then Return SetError(1, 0, "Error converting war time")

			; set $sResult to be the date and time of war end
			If StringInStr($sWarDay, "Preparation") Then
				SetLog("Clan war is now in preparation. Battle will start in " & $sTime, $COLOR_INFO)
				$sResult = _DateAdd("n", $iConvertedTime + 24 * 60, _NowCalc()) ; $iBattleFinishTime
			ElseIf StringInStr($sWarDay, "Battle") Then
				SetLog("Clan war is now in battle day. Battle will finish in " & $sTime, $COLOR_INFO)
				$sResult = _DateAdd("n", $iConvertedTime, _NowCalc()) ; $iBattleFinishTime
			EndIf

			If Not _DateIsValid($sResult) Then Return SetError(1, 0, "Error converting battle finish time")

			SetLog("You are " & ($bResult ? "" : "not ") & "in war", $COLOR_INFO)

			$bLocalReturn = True
		EndIf
	Else
		If (_ColorCheck(_GetPixelColor(825, 33 + $g_iMidOffsetYFixed, True), Hex(0xFFFFFF, 6), 5)) Then
			SetLog("War is finished.", $COLOR_WARNING)
			$bLocalReturn = True
		Else
			SetLog("Error when trying to open War window.", $COLOR_WARNING)
			ClickAway()
			CheckMainScreen()
			$bLocalReturn = SetError(1, 0, "Error open War window")
		EndIf
	EndIf
	
	If $bReturnFrom = True Then
		ReturnToHomeFromWar()
	EndIf
	
	Return $bLocalReturn
EndFunc   ;==>CheckWarTime

Func StopAndPrepareForWar($iSleepTime)

	If $g_bTrainWarTroop Then
		SetLog("Let's remove all farming troops and train war troop", $COLOR_ACTION)

		; Loading variables
		$g_bDoubleTrain = True
		If $g_iTotalSpellValue = 0 Then $g_iTotalSpellValue = 11
		If $g_iTotalCampSpace = 0 Then $g_iTotalCampSpace = 300
		If $g_bUseQuickTrainWar Then
			$g_bQuickTrainEnable = True
			$g_bQuickTrainArmy = $g_aChkArmyWar
			For $i = 0 To $eTroopCount - 1
				$g_aiArmyCompTroops[$i] = 0
				If $i < $eSpellCount Then $g_aiArmyCompSpells[$i] = 0
			Next
			$g_aiArmyCompTroops[0] = 1 ; set troop training to be a single barbarian
			$g_aiArmyCompSpells[10] = 1 ; set spell training to be a single bat spell
			; removing current army
			OpenArmyOverview(False, "StopAndPrepareForWar()")
			If Not IsQueueEmpty("Troops", False, False) Then DeleteQueued("Troops")
			If Not IsQueueEmpty("Spells", False, False) Then DeleteQueued("Spells")
			If _Sleep(300) Then Return

			If Not OpenArmyTab(False, "StopAndPrepareForWar()") Then Return
			If _Sleep(300) Then Return
			Local $toTrainFake[2][2] = [["Barb", 1], ["BtSpell", 1]] ; if the user had a bat spell or barb, delete the left over
			Local $toRemove = WhatToTrain(True)
			RemoveExtraTroops($toRemove) ; delete all troops except one barb and a bat spell
			getArmySpells(False, False, False, False)
			For $i = 0 To $eSpellCount - 1
				If $g_aiCurrentSpells[$i] = 0 Then
					$g_aiArmyCompSpells[$i] = 1 ; this is to by pass TotalSpellsToBrewInGUI() in TrainSystem
					ExitLoop
				EndIf
			Next
			RemoveExtraTroops($toTrainFake) ; delete the leftover barb and bat... easy trick to delete all troops
			If _Sleep(300) Then Return
			QuickTrain() ; train
		Else
			$g_aiArmyCompTroops = $g_aiWarCompTroops
			$g_aiArmyCompSpells = $g_aiWarCompSpells
			OpenArmyOverview(False, "StopAndPrepareForWar()") ; train
			DoubleTrain(True)
		EndIf

		ClickAway() ; ClickP($aAway, 2, 0, "#0346") ;Click Away
		If _Sleep(500) Then Return
	EndIf

	If $g_bRequestCCForWar Then
		$g_bRequestTroopsEnable = True
		$g_bDonationEnabled = True
		$g_bCanRequestCC = True
		$g_abRequestCCHours[@HOUR] = True
		$g_sRequestTroopsText = $g_sTxtRequestCCForWar
		$g_abRequestType[0] = True
		$g_abRequestType[1] = True
		For $i = 0 To 2
			$g_aiClanCastleTroopWaitType[$i] = 0 ; Barb for all 3 slots
			$g_aiClanCastleTroopWaitQty[$i] = 1 ; Q'ty = 0 for all 3 slots
		Next
		For $i = 0 To $eTroopCount - 1
			$g_aiCCTroopsExpected[$i] = 0 ; remove all troops
		Next
		$g_iCurrentCCSpells = $g_iTotalCCSpells

		SetLog("Let's request again for war", $COLOR_ACTION)
		RequestCC()
	EndIf

	SetLog("It's war time, let's take a break", $COLOR_ACTION)

	readConfig() ; release all war variables value for war troops & requestCC

	If ProfileSwitchAccountEnabled() Then
		If GUICtrlRead($g_ahChkAccount[$g_iCurAccount]) = $GUI_CHECKED Then
			Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)
			If UBound($aActiveAccount) > 1 Then
				GUICtrlSetState($g_ahChkAccount[$g_iCurAccount], $GUI_UNCHECKED)
				chkAccount($g_iCurAccount)
				SaveConfig_600_35_2() ; Save config profile after changing botting type
				ReadConfig_600_35_2() ; Update variables
				UpdateMultiStats(False)
				SetLog("Acc [" & $g_iCurAccount + 1 & "] turned OFF and start over with another account")
				SetSwitchAccLog("   Acc. " & $g_iCurAccount + 1 & " now Idle for war", $COLOR_ACTION)

				For $i = 0 To UBound($aActiveAccount) - 1
					If $aActiveAccount[$i] <> $g_iCurAccount Then
						$g_iNextAccount = $aActiveAccount[$i]
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
						$g_bInitiateSwitchAcc = True
						ExitLoop
					EndIf
				Next

				runBot()
			ElseIf UBound($aActiveAccount) = 1 Then
				SetLog("This is the last active account for switching, close CoC anyway")
			EndIf
		EndIf
	EndIf

	UniversalCloseWaitOpenCoC($iSleepTime * 60 * 1000, "StopAndPrepareForWar", False, True) ; wake up & full restart ; Fixed, math was off by one multiple of 60

EndFunc   ;==>StopAndPrepareForWar
