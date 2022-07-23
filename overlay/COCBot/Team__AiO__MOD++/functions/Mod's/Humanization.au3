; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization / ClanActions.au3
; Description ...: This file contains all functions of Bot Humanization feature - Clan Part
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: 11.11.2016
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func LookAtWarLog()
	Click(20, 380 + $g_iMidOffsetY) ; open chat
	If randomSleep(3000) Then Return

	If ChatOpen() Then
		If randomSleep(1500) Then Return

		If IsClanChat() Then
			Click(120, 30) ; open the clan menu
			If randomSleep(1500) Then Return

			If IsClanOverview() Then
				If QuickMIS("BC1", $g_sImgHumanizationWarLog) Then ; October Update Changed
					Click($g_iQuickMISX, $g_iQuickMISY) ; open war log
					If randomSleep(500) Then Return
					Click(258, 135 + $g_iMidOffsetYFixed) ;Click Classic War Log
					If randomSleep(500) Then Return
					SetLog("Let's Scrolling The War Log ...", $COLOR_OLIVE)
					Scroll(Random(1, 3, 1)) ; scroll the war log
				Else
					SetLog("No War Log Button Found ... Skipping ...", $COLOR_WARNING)
				EndIf

				Click(830, 45 + $g_iMidOffsetY) ; close window
				If randomSleep(1000) Then Return
				Click(330, 380 + $g_iMidOffsetY) ; close chat
			Else
				SetLog("Error When Trying To Open Clan Overview ... Skipping ...", $COLOR_WARNING)
			EndIf
		Else
			SetLog("Error When Trying To Open Clan Chat ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open Chat ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>LookAtWarLog

Func VisitClanmates()
	Click(20, 380 + $g_iMidOffsetY) ; open chat
	If randomSleep(3000) Then Return

	If ChatOpen() Then
		If randomSleep(1500) Then Return

		If IsClanChat() Then
			Click(120, 30) ; open the clan menu
			If randomSleep(1500) Then Return

			If IsClanOverview() Then
				SetLog("Let's Visit a Random Player ...", $COLOR_OLIVE)
				Click(660, 428 + $g_iMidOffsetY + (52 * Random(0, 5, 1))) ; click on a random player
				If randomSleep(1500) Then Return ;Was less due to that bot was unable to detect visit button
				VisitAPlayer()
				If randomSleep(500) Then Return
				Click(70, 620 + $g_iBottomOffsetY) ; return home
			Else
				SetLog("Error When Trying To Open Clan overview ... Skipping ...", $COLOR_WARNING)
			EndIf
		Else
			SetLog("Error When Trying To Open Clan Chat ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open Chat ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>VisitClanmates

; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization / ClanWarActions.au3
; Description ...: This file contains all functions of Bot Humanization feature - War Part
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: 11.11.2016
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func LookAtCurrentWar()
	Local $sResult, $bResult

	CheckWarTime($sResult, $bResult, False)
	If Not @error Then
		If randomSleep(250) Then Return
		If $g_bClanWar = True Or $g_bClanWarLeague = True Then

			If IsWarMenu() Then
				Local $sWarMode = ($g_bClanWarLeague = True) ? ("Current CWL war") : ("Current War")
				SetLog("Let's Examine The " & $sWarMode & " Map ...", $COLOR_OLIVE)
				Scroll(Random(2, 5, 1)) ; scroll enemy
				If randomSleep(3000) Then Return

				If $g_bClanWar = True Then
					Local $LookAtHome = Random(0, 1, 1)
					If $LookAtHome = 1 Then
						SetLog("Looking At Home Territory ...", $COLOR_OLIVE)
						Click(790, 340 + $g_iMidOffsetY) ; go to home territory
						Scroll(Random(2, 5, 1)) ; scroll home
						If randomSleep(3000) Then Return
					EndIf
				EndIf

				SetLog("Open War Details Menu ...", $COLOR_OLIVE)
				If $g_bClanWar = True Then Click(800, 610 + $g_iBottomOffsetY) ; go to war details
				If $g_bClanWarLeague = True Then Click(810, 540 + $g_iMidOffsetY) ; go to Cwl war details
				If randomSleep(1500) Then Return

				If IsClanOverview() Then
					Local $FirstMenu = Random(1, 2, 1)
					Switch $FirstMenu
						Case 1
							SetLog("Looking At First Tab ...", $COLOR_OLIVE)
							Click(180, 50 + $g_iMidOffsetY) ; click first tab
						Case 2
							SetLog("Looking At Second Tab ...", $COLOR_OLIVE)
							Click(360, 50 + $g_iMidOffsetY) ; click second tab
					EndSwitch
					If randomSleep(1500) Then Return

					Scroll(Random(1, 3, 1)) ; scroll the tab

					Local $SecondMenu = Random(1, 2, 1)
					Switch $SecondMenu
						Case 1
							SetLog("Looking At Third Tab ...", $COLOR_OLIVE)
							Click(530, 50 + $g_iMidOffsetY) ; click the third tab
						Case 2
							SetLog("Looking At Fourth Tab ...", $COLOR_OLIVE)
							Click(700, 50 + $g_iMidOffsetY) ; click the fourth tab
					EndSwitch
					If randomSleep(1500) Then Return

					Scroll(Random(2, 4, 1)) ; scroll the tab

					Click(830, 50 + $g_iMidOffsetY) ; close window
					If randomSleep(1500) Then Return
					; Return ReturnToHomeFromWar()
				Else
					SetLog("Error When Trying To Open War Details Window ... Skipping ...", $COLOR_WARNING)
				EndIf
			Else
				SetLog("Your Clan Is Not In Active War yet ... Skipping ...", $COLOR_WARNING)
				If randomSleep(1500) Then Return
				; Return ReturnToHomeFromWar()
			EndIf
		Else
			SetLog("Error When Trying To Open War Window ... Skipping ...", $COLOR_WARNING)
		EndIf
	EndIf
	Return ReturnToHomeFromWar()
EndFunc   ;==>LookAtCurrentWar

Func WatchWarReplays()
	Local $sResult, $bResult
	CheckWarTime($sResult, $bResult, False)
	If Not @error Then
		If randomSleep(250) Then Return
		If $g_bClanWar = True Or $g_bClanWarLeague = True Then
			SetLog("Open War Details Menu ...", $COLOR_OLIVE)
			If $g_bClanWar = True Then Click(800, 610 + $g_iBottomOffsetY) ; go to war details
			If $g_bClanWarLeague = True Then Click(810, 540 + $g_iMidOffsetY) ; go to Cwl war details
			If randomSleep(1500) Then Return

			If IsClanOverview() Then
				SetLog("Looking At Second Tab ...", $COLOR_OLIVE)
				Click(360, 50 + $g_iMidOffsetY) ; go to replays tab
				If randomSleep(1500) Then Return

				If IsBestClans() Then
					Local $vReplayNumber = findMultipleQuick($g_sImgHumanizationReplay, 6, $g_aHumanizationReplayArea, True, "", False, 36)
					If UBound($vReplayNumber) > 0 And not @error Then
						SetLog("There Are " & UBound($vReplayNumber) & " Replays To Watch ... We Will Choose One Of Them ...", $COLOR_INFO)
						Local $iReplayToLaunch = Random(0, UBound($vReplayNumber) -1, 1)

						Click($vReplayNumber[$iReplayToLaunch][1], $vReplayNumber[$iReplayToLaunch][2]) ; click on the choosen replay

						WaitForReplayWindow()

						If IsReplayWindow() Then
							GetReplayDuration(1)
							If randomSleep(1000) Then Return

							If IsReplayWindow() Then
								AccelerateReplay(1)
							EndIf

							If randomSleep($g_aReplayDuration[1] / 3) Then Return

							If IsReplayWindow() Then
								DoAPauseDuringReplay(1)
							EndIf

							If randomSleep($g_aReplayDuration[1] / 3) Then Return

							If IsReplayWindow() And $g_aReplayDuration[0] <> 0 Then
								DoAPauseDuringReplay(1)
							EndIf

							SetLog("Waiting For Replay End ...", $COLOR_ACTION)

							While IsReplayWindow()
								If randomSleep(1000) Then Return
							WEnd

							If randomSleep(1000) Then Return
							Click(70, 620 + $g_iBottomOffsetY) ; return home
						EndIf
					Else
						SetLog("No Replay To Watch Yet ... Skipping ...", $COLOR_WARNING)
					EndIf
				Else
					SetLog("Error When Trying To Open Replays Menu ... Skipping ...", $COLOR_WARNING)
				EndIf
			Else
				SetLog("Error When Trying to Open War Details Window ... Skipping ...", $COLOR_WARNING)
			EndIf

			Click(830, 50 + $g_iMidOffsetY) ; close window
			If randomSleep(3500) Then Return
			; Return ReturnToHomeFromWar()
		Else
			SetLog("Your Clan Is Not In Active War Yet ... Skipping ...", $COLOR_WARNING)
			If randomSleep(1500) Then Return
			; Return ReturnToHomeFromWar()
		EndIf
	EndIf

	Return ReturnToHomeFromWar()
EndFunc   ;==>WatchWarReplays

; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization / AttackNDefenseActions.au3
; Description ...: This file contains all functions of Bot Humanization feature - Attack and Defenses Part
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: Chilly-Chill (08.2019)
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func WatchDefense()
	Click(40, 150 + $g_iMidOffsetYFixed) ; open messages tab - defenses tab
	If randomSleep(1500) Then Return

	If IsMessagesReplayWindow() Then
		Click(190, 90 + $g_iMidOffsetY) ; open defenses tab
		If randomSleep(1500) Then Return

		If IsDefensesTab() Then
			Click(710, (180 + $g_iMidOffsetY + (145 * Random(0, 2, 1)))) ; click on a random replay
			WaitForReplayWindow()

			If IsReplayWindow() Then
				GetReplayDuration(0)
				If randomSleep(1000) Then Return

				If IsReplayWindow() Then
					AccelerateReplay(0)
				EndIf

				If randomSleep($g_aReplayDuration[1] / 3) Then Return

				Local $IsBoring = Random(1, 5, 1)
				If $IsBoring >= 4 Then
					If IsReplayWindow() Then
						SetLog("This Replay Is Boring, Let Me Go Out ...", $COLOR_OLIVE)
						Click(70, 620 + $g_iBottomOffsetY) ; return home
					EndIf
				Else
					If IsReplayWindow() Then
						DoAPauseDuringReplay(0)
					EndIf

					If randomSleep($g_aReplayDuration[1] / 3) Then Return

					If IsReplayWindow() And $g_aReplayDuration[0] <> 0 Then
						DoAPauseDuringReplay(0)
					EndIf

					If IsReplayWindow() Then SetLog("Waiting For Replay End ...", $COLOR_ACTION)

					While IsReplayWindow()
						If randomSleep(2000) Then Return
					WEnd

					If randomSleep(1000) Then Return
					Click(70, 620 + $g_iBottomOffsetY) ; return home
				EndIf
			EndIf
		Else
			SetLog("Error When Trying To Open Defenses Menu ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open Replays Menu ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>WatchDefense

Func WatchAttack()
	Click(40, 150 + $g_iMidOffsetYFixed) ; open messages tab - defenses tab
	If randomSleep(1500) Then Return

	If IsMessagesReplayWindow() Then
		Click(380, 90 + $g_iMidOffsetY) ; open attacks tab
		If randomSleep(1500) Then Return

		If IsAttacksTab() Then
			Click(710, (180 + $g_iMidOffsetY + (145 * Random(0, 2, 1)))) ; click on a random replay
			WaitForReplayWindow()

			If IsReplayWindow() Then
				GetReplayDuration(0)
				If randomSleep(1000) Then Return

				If IsReplayWindow() Then
					AccelerateReplay(0)
				EndIf

				If randomSleep($g_aReplayDuration[1] / 3) Then Return

				Local $IsBoring = Random(1, 5, 1)
				If $IsBoring >= 4 Then
					If IsReplayWindow() Then
						SetLog("This Replay Is Boring, Let Me Go Out ...", $COLOR_OLIVE)
						If randomSleep(1000) Then Return
						Click(70, 620 + $g_iBottomOffsetY) ; return home
					EndIf
				Else
					If IsReplayWindow() Then
						DoAPauseDuringReplay(0)
					EndIf

					If randomSleep($g_aReplayDuration[1] / 3) Then Return

					If IsReplayWindow() And $g_aReplayDuration[0] <> 0 Then
						DoAPauseDuringReplay(0)
					EndIf

					If IsReplayWindow() Then SetLog("Waiting For Replay End ...", $COLOR_ACTION)

					While IsReplayWindow()
						If randomSleep(2000) Then Return
					WEnd

					If randomSleep(1000) Then Return
					Click(70, 620 + $g_iBottomOffsetY) ; return home
				EndIf
			EndIf
		Else
			SetLog("Error When Trying To Open Defenses Menu ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open Replays Menu ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>WatchAttack

Func BotHumanization()
   If Not $g_bRunState Then Return

   If $g_bUseBotHumanization = True Then
	  Local $iNoActionsToDo = 0, $iActions = UBound($g_acmbPriority)
	  SetLog("OK, Let AiO++ Makes The Bot More Human Like!", $COLOR_SUCCESS1)

	  If $g_bLookAtRedNotifications = True Then LookAtRedNotifications()
	  ReturnAtHome()
		
	  For $i = 0 To $iActions -1
		 Local $ActionEnabled = _GUICtrlComboBox_GetCurSel($g_acmbPriority[$i])
		 If $ActionEnabled = 0 Then $iNoActionsToDo += 1
	  Next

	  If $iNoActionsToDo <> $iActions Then
		 $g_iMaxActionsNumber = Random(1, _GUICtrlComboBox_GetCurSel($g_hCmbMaxActionsNumber) + 1, 1)
		 SetLog("AiO++ Will Do " & $g_iMaxActionsNumber & " Human Actions During This Loop ...", $COLOR_INFO)
		 For $i = 1 To $g_iMaxActionsNumber
			If randomSleep(2000) Then Return
			ReturnAtHome()
			RandomHumanAction()
		 Next
	  Else
		 SetLog("All Actions Disabled, Skipping ...", $COLOR_WARNING)
	  EndIf
	  SetLog("Bot Humanization Finished !", $COLOR_SUCCESS1)
	  If randomSleep(3000) Then Return
   EndIf
EndFunc   ;==>BotHumanization

Func RandomHumanAction()
	For $i = 0 To UBound($g_iacmbPriority) -1
		SetActionPriority($i)
	Next

	$g_iActionToDo = _ArrayMaxIndex($g_aSetActionPriority)
	Switch $g_iActionToDo
		Case 0
			SetLog("AiO++ Humanization Read Clan Chat Now. Let's Go!", $COLOR_INFO)
			ReadClanChat()
		Case 1
			SetLog("AiO++ Humanization Watch a Defense Now. Let's Go!", $COLOR_INFO)
			WatchDefense()
		Case 2
			SetLog("AiO++ Humanization Watch an Attack Now. Let's Go!", $COLOR_INFO)
			WatchAttack()
		Case 3
			SetLog("AiO++ Humanization Look at War Log Now. Let's Go!", $COLOR_INFO)
			LookAtWarLog()
		Case 4
			SetLog("AiO++ Humanization Visit Clanmates Now. Let's Go!", $COLOR_INFO)
			VisitClanmates()
		Case 5
			SetLog("AiO++ Humanization Visit Best Players Now. Let's Go!", $COLOR_INFO)
			VisitBestPlayers()
		Case 6
			SetLog("AiO++ Humanization Look at Best Clans Now. Let's Go!", $COLOR_INFO)
			LookAtBestClans()
		Case 7
			SetLog("AiO++ Humanization Look at Current War Now. Let's Go!", $COLOR_INFO)
			LookAtCurrentWar()
		Case 8
			SetLog("AiO++ Humanization Watch War Replay Now. Let's Go!", $COLOR_INFO)
			WatchWarReplays()
		Case 9
			SetLog("AiO++ Humanization Do Nothing For Now.", $COLOR_INFO)
			DoNothing()
	EndSwitch
EndFunc   ;==>RandomHumanAction

Func SetActionPriority($ActionNumber)
	If _GUICtrlComboBox_GetCurSel($g_acmbPriority[$ActionNumber]) <> 0 Then
		MatchPriorityNValue($ActionNumber)
		$g_aSetActionPriority[$ActionNumber] = Random($g_iMinimumPriority, 100, 1)
	Else
		$g_aSetActionPriority[$ActionNumber] = 0
	EndIf
EndFunc   ;==>SetActionPriority

Func MatchPriorityNValue($ActionNumber)
	Switch _GUICtrlComboBox_GetCurSel($g_acmbPriority[$ActionNumber])
		Case 1
			$g_iMinimumPriority = 0
		Case 2
			$g_iMinimumPriority = 25
		Case 3
			$g_iMinimumPriority = 50
		Case 4
			$g_iMinimumPriority = 75
	EndSwitch
EndFunc   ;==>MatchPriorityNValue

Func WaitForReplayWindow()
	SetLog("Waiting For Replay Screen...", $COLOR_ACTION)
	Local $CheckStep = 0
	While Not IsReplayWindow() And $CheckStep < 30
		If _Sleep(1000) Then Return
		$CheckStep += 1
	WEnd
	Return $g_bOnReplayWindow
EndFunc   ;==>WaitForReplayWindow

Func IsReplayWindow()
	$g_bOnReplayWindow = _ColorCheck(_GetPixelColor(799, 559 + $g_iBottomOffsetY, True), "FF5151", 20)
	Return $g_bOnReplayWindow
EndFunc   ;==>IsReplayWindow

Func GetReplayDuration($g_iReplayToPause) ; will work with this but can update to make time exact.
	Local $MaxSpeed = _GUICtrlComboBox_GetCurSel($g_acmbMaxSpeed[$g_iReplayToPause])
	Local $bResult = QuickMIS("N1", $g_sImgHumanizationDuration, 375, 535 + $g_iBottomOffsetY, 430, 570 + $g_iBottomOffsetY)
	If $bResult = "OneMinute" Then
		$g_aReplayDuration[0] = 1
		$g_aReplayDuration[1] = 90000
	ElseIf $bResult = "TwoMinutes" Then
		$g_aReplayDuration[0] = 2
		$g_aReplayDuration[1] = 150000
	ElseIf $bResult = "ThreeMinutes" Then
		$g_aReplayDuration[0] = 3
		$g_aReplayDuration[1] = 180000
	Else
		$g_aReplayDuration[0] = 0
		$g_aReplayDuration[1] = 45000
	EndIf
	Switch $MaxSpeed
		Case 1
			$g_aReplayDuration[1] /= 2
		Case 2
			$g_aReplayDuration[1] /= 4
	EndSwitch
	SetLog("Estimated Replay Duration : " & $g_aReplayDuration[1] / 1000 & " second(s)", $COLOR_INFO)
EndFunc   ;==>GetReplayDuration

Func AccelerateReplay($g_iReplayToPause)
	Local $CurrentSpeed = 0
	Local $MaxSpeed = _GUICtrlComboBox_GetCurSel($g_acmbMaxSpeed[$g_iReplayToPause])
	If $CurrentSpeed <> $MaxSpeed Then SetLog("Let's Make The Replay Faster ...", $COLOR_OLIVE)
	While $CurrentSpeed < $MaxSpeed
		Click(820, 630 + $g_iBottomOffsetY) ; click on the speed button
		If randomSleep(500) Then Return
		$CurrentSpeed += 1
	WEnd
EndFunc   ;==>AccelerateReplay

Func DoAPauseDuringReplay($g_iReplayToPause)
	Local $MinimumToPause = 0, $PauseScore = 0
	Local $Pause = _GUICtrlComboBox_GetCurSel($g_acmbPause[0])
	If $Pause <> 0 Then
		Switch $Pause
			Case 1
				$MinimumToPause = 80
			Case 2
				$MinimumToPause = 60
			Case 3
				$MinimumToPause = 40
			Case 4
				$MinimumToPause = 20
		EndSwitch
		$PauseScore = Random(0, 100, 1)
		If $PauseScore > $MinimumToPause Then
			SetLog("Let's Do a Small Pause To See What Happens ...", $COLOR_OLIVE)
			Click(750, 630 + $g_iBottomOffsetY) ; click pause button
			If randomSleep(10000, 3000) Then Return
			SetLog("Pause Finished, Let's Relaunch Replay!", $COLOR_OLIVE)
			Click(750, 630 + $g_iBottomOffsetY) ; click play button
		EndIf
	EndIf
EndFunc   ;==>DoAPauseDuringReplay

Func VisitAPlayer()
	If randomSleep(1000) Then Return
	SetLog("Let's Visit a Player ...", $COLOR_INFO)
	If QuickMIS("BC1", $g_sImgHumanizationVisit) Then
		Click($g_iQuickMISX, $g_iQuickMISY)
		If randomSleep(8000) Then Return
		For $i = 0 To Random(1, 4, 1)
			SetLog("We Will Click On a Random Builing ...", $COLOR_OLIVE)
			Local $xInfo = Random(300, 500, 1)
			Local $yInfo = Random(300, 402 + $g_iMidOffsetY, 1)
			Click($xInfo, $yInfo) ; click on a random builing
			If randomSleep(1500) Then Return
			SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
			Click(430, 575 + $g_iBottomOffsetY) ; open the info window about building
			If randomSleep(8000) Then Return
			Click(685, 145 + $g_iMidOffsetY) ;Click Away
			If randomSleep(3000) Then Return
		Next
	Else
		SetLog("Error When Trying to Find Visit Button ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>VisitAPlayer

Func DoNothing()
	SetLog("Let The Bot Wait a Little Before Continue ...", $COLOR_OLIVE)
	If randomSleep(8000, 3000) Then Return
EndFunc   ;==>DoNothing

Func LookAtRedNotifications()
	SetLog("Looking For Notifications ...", $COLOR_INFO)
	Local $NoNotif = 0
	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(50, 137 + $g_iMidOffsetYFixed, True), "F5151D", 20) Then
		SetLog("You Have a New Message ...", $COLOR_OLIVE)
		Click(40, 150 + $g_iMidOffsetYFixed) ; open Messages button
		If randomSleep(8000, 3000) Then Return
		Click(765, 87 + $g_iMidOffsetY) ; close window
		If randomSleep(2000) Then Return
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(50, 76 + $g_iMidOffsetYFixed, True), "F5151D", 20) Then
		SetLog("Let's See The Current League You Are In ...", $COLOR_OLIVE)
		Click(40, 90 + $g_iMidOffsetYFixed) ; open Cup button
		If randomSleep(4000) Then Return
		Click(445, 580 + $g_iMidOffsetY) ; click Okay
		If randomSleep(1500) Then Return
		Click(830, 50 + $g_iMidOffsetY) ; close window
		If randomSleep(2000) Then Return
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(50, 451 + $g_iBottomOffsetY, True), "F5151D", 20) Then
		SetLog("Current War To Look At ...", $COLOR_OLIVE)
		Click(40, 490 + $g_iMidOffsetY) ; open War menu
		If randomSleep(8000, 3000) Then Return
		Click(70, 620 + $g_iBottomOffsetY) ; return home
		If randomSleep(2000) Then Return
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(28, 323 + $g_iMidOffsetY, True), "F5151D", 20) Then
		SetLog("New Messages On The Chat Room ...", $COLOR_OLIVE)
		Click(20, 380 + $g_iMidOffsetY) ; open chat
		If randomSleep(3000) Then Return
		Click(330, 380 + $g_iMidOffsetY) ; close chat
		If randomSleep(2000) Then Return
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(722, 614 + $g_iBottomOffsetY, True), "F5151D", 20) Then
		SetLog("New Messages Or Events From SC To Read ...", $COLOR_OLIVE)
		Click(715, 630 + $g_iBottomOffsetY) ; open events
		If randomSleep(3000) Then Return

		If _ColorCheck(_GetPixelColor(245, 80 + $g_iMidOffsetY, True), "F0F4F0", 20) Then ; check if we are on events/news tab
			Click(435, 80 + $g_iMidOffsetY) ; open new tab
			If randomSleep(3000) Then Return
		Else
			Click(245, 80 + $g_iMidOffsetY) ; open events tab
			If randomSleep(3000) Then Return
		EndIf

		Click(760, 90 + $g_iMidOffsetY) ; close settings
		If randomSleep(2000) Then Return
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(832, 578 + $g_iBottomOffsetY, True), "683072", 20) Or _ColorCheck(_GetPixelColor(832, 577 + $g_iBottomOffsetY, True), "F5151D", 20) Then
		SetLog("There Is Something New On The Shop ...", $COLOR_OLIVE)
		Click(800, 610 + $g_iBottomOffsetY) ; open Shop
		If randomSleep(2000) Then Return
		Local $NeedScroll = Random(0, 1, 1)
		Local $NeedScroll2 = Random(0, 1, 1)
		If $NeedScroll = 1 Then
			Local $xStart = Random(300, 800, 1)
			Local $xEnd = Random($xStart - 250, $xStart - 220, 1)
			Local $y = Random(330 - 10 + $g_iMidOffsetY, 330 + 10 + $g_iMidOffsetY, 1) ; Resolution changed
			ClickDrag($xStart, $y, $xEnd, $y) ; scroll the shop
			If $NeedScroll2 = 1 Then
				If randomSleep(2000) Then Return
				$xEnd = Random(300, 800, 1)
				$xStart = Random($xEnd - 250, $xEnd - 220, 1)
				$y = Random(330 - 10 + $g_iMidOffsetY, 330 + 10 + $g_iMidOffsetY, 1) ; Resolution changed
				ClickDrag($xStart, $y, $xEnd, $y) ; scroll the shop
			EndIf
		EndIf

		If randomSleep(2000) Then Return
		Click(820, 40) ; return home
		If randomSleep(2000) Then Return
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(50, 17, True), "F5151D", 20) Then
		SetLog("Maybe You Have a New Friend Request, Let Me Check ...", $COLOR_OLIVE)
		Click(40, 40) ; open profile
		If randomSleep(2000) Then Return

		If IsClanOverview() Then
			If _ColorCheck(_GetPixelColor(773, 63 + $g_iMidOffsetYFixed, True), "E20814", 20) Then
				SetLog("It's Confirmed, You Have a New Friend Request, Let Me Check ...", $COLOR_OLIVE)
				Click(720, 50 + $g_iMidOffsetY)
				If randomSleep(2000) Then Return
				If QuickMIS("BC1", $g_sImgHumanizationFriend, 720, 130 + $g_iMidOffsetY, 780, 570 + $g_iMidOffsetY) Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					If randomSleep(1500) Then Return
					If QuickMIS("BC1", $g_sImgHumanizationFriend, 440, 350 + $g_iMidOffsetY, 590, 440 + $g_iMidOffsetY) Then
						Click($g_iQuickMISX, $g_iQuickMISY)
					Else
						SetLog("Error When Trying To Find Okay Button ... Skipping ...", $COLOR_WARNING)
					EndIf
				Else
					SetLog("Error When Trying To Find Friend Request ... Skipping ...", $COLOR_WARNING)
				EndIf
			Else
				SetLog("No Friend Request Found ... Skipping ...", $COLOR_WARNING)
			EndIf
		Else
			SetLog("Error When Trying To Open Social Tab ... Skipping ...", $COLOR_WARNING)
		EndIf
		If randomSleep(2000) Then Return
	Else
		$NoNotif += 1
	EndIf
	If $NoNotif = 7 Then SetLog("No Notification Found, Nothing To Look At ...", $COLOR_OLIVE)
EndFunc   ;==>LookAtRedNotifications

Func Scroll($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $x = Random(430 - 20, 430 + 20, 1)
		Local $yStart = Random(475 - 20 + $g_iMidOffsetY, 475 + 20 + $g_iMidOffsetY, 1) ; Resolution changed
		Local $yEnd = Random(200 - 20 + $g_iMidOffsetY, 200 + 20 + $g_iMidOffsetY, 1) ; Resolution changed
		ClickDrag($x, $yStart, $x, $yEnd) ; generic random scroll
		If randomSleep(4000) Then Return
	Next
EndFunc   ;==>Scroll

; ================================================== SECURITY PART ================================================== ;

Func SecureMessage($TextToClean)
	Return StringRegExpReplace($TextToClean, "[^\w \-\,\?\!\:]", "") ; delete dangerous characters
EndFunc   ;==>SecureMessage

Func ReturnAtHome()
	Local $CheckStep = 0
	While Not IsMainScreen() And $CheckStep <= 5
		AndroidBackButton()
		If randomSleep(3000) Then Return
		$CheckStep += 1
	WEnd
	If Not IsMainScreen() Then
		SetLog("Main Screen Not Found, Need To Restart CoC App...", $COLOR_ERROR)
		RestartAndroidCoC()
		waitMainScreen()
	EndIf
EndFunc   ;==>ReturnAtHome

Func IsMainScreen()
	;Wait for Main Screen To Be Appear
	Local $bResult = False

	If IsMainPage(2) Then
		$bResult = True
	ElseIf IsMainPageBuilderBase(2) Then
		$bResult = True
	EndIf

	Return $bResult
EndFunc   ;==>IsMainScreen

Func ReturnToHomeFromWar()
	If _Wait4PixelGoneArray($aIsMain) = True Then
		Click(70, 620 + $g_iBottomOffsetY) ; return home

		If _Wait4PixelArray($aIsMain) = False Then
			Click(70, 620 + $g_iBottomOffsetY) ; return home
			CheckMainScreen()
		EndIf
	EndIf

	Return True
EndFunc   ;==>IsMessagesReplayWindow

Func IsMessagesReplayWindow()
	Local $bResult = _Wait4Pixel(750, 93 + $g_iMidOffsetY, 0xED1115, 20, 3000, "IsMessagesReplayWindow") ;Wait for Replay Message Window To Be Appear
	Return $bResult
EndFunc   ;==>IsMessagesReplayWindow

Func IsDefensesTab()
	Local $bResult = _Wait4Pixel(180, 80 + $g_iMidOffsetY, 0xF0F4F0, 20, 3000, "IsDefensesTab") ;Wait for Defence To Be Selected
	Return $bResult
EndFunc   ;==>IsDefensesTab

Func IsAttacksTab()
	Local $bResult = _Wait4Pixel(380, 110 + $g_iMidOffsetY, 0xF0F4F0, 20, 3000, "IsAttacksTab") ;Wait for Attack To Be Selected
	Return $bResult
EndFunc   ;==>IsAttacksTab

Func IsBestPlayers()
	Local $bResult = _Wait4Pixel(530, 60 + $g_iMidOffsetY, 0xF0F4F0, 20, 3000, "IsBestPlayers") ;Wait for Best Player Screen To Be Appear
	Return $bResult
EndFunc   ;==>IsBestPlayers

Func IsBestClans()
	Local $bResult = _Wait4Pixel(350, 60 + $g_iMidOffsetY, 0xF0F4F0, 20, 3000, "IsBestClans") ;Wait for Best Clan Screen To Be Appear
	Return $bResult
EndFunc   ;==>IsBestClans

Func ChatOpen()
	Local $bResult = _Wait4Pixel(330, 382 + $g_iMidOffsetY, 0xC75315, 20, 3000, "ChatOpen") ;Wait for Chat To Be Appear
	Return $bResult
EndFunc   ;==>ChatOpen

Func IsClanChat()
	Local $bResult = _Wait4Pixel(220, 10, 0x787458, 20, 3000, "IsClanChat") ;Wait for Clan Chat To Be Appear
	Return $bResult
EndFunc   ;==>IsClanChat
#cs
Func IsGlobalChat()
	Local $bResult = _Wait4Pixel(80, 10, 0x787458, 20, 3000, "IsGlobalChat") ;Wait for Global Chat To Be Appear
	Return $bResult
EndFunc   ;==>IsGlobalChat
#ce
Func IsTextBox()
	Local $bResult = _Wait4Pixel(190, 650 + $g_iBottomOffsetY, 0xFFFFFF, 20, 3000, "IsTextBox") ;Wait for Text Box To Be Appear
	Return $bResult
EndFunc   ;==>IsTextBox

Func IsChallengeWindow()
	Local $bResult = _Wait4Pixel(700, 110, 0xFFFFFF, 20, 3000, "IsChallengeWindow")  ;Wait for Challenge Window To Be Appear
	Return $bResult
EndFunc   ;==>IsChallengeWindow

Func IsChangeLayoutMenu()
	Local $bResult = _Wait4Pixel(180, 110, 0xFFFFFF, 20, 3000, "IsChangeLayoutMenu")  ;Wait for Is Change Layout Menu To Be Appear
	Return $bResult
EndFunc   ;==>IsChangeLayoutMenu

Func IsClanOverview()
	Local $bResult = _Wait4Pixel(822, 40 + $g_iMidOffsetY, 0xFFFFFF, 20, 3000, "IsClanOverview") ;Wait for Is Clan Overview To Be Appear
	Return $bResult
EndFunc   ;==>IsClanOverview

Func randomSleep($iSleepTime, $iRange = Default)
	If Not $g_bRunState Or $g_bRestart Then Return
	If $iRange = Default Then $iRange = $iSleepTime * 0.20
	Local $iSleepTimeF = Abs(Round($iSleepTime + Random( -Abs($iRange), Abs($iRange))))
	If $g_bDebugClick Or $g_bDebugSetlog Then SetLog("Default sleep : " & $iSleepTime & " - Random sleep : " & $iSleepTimeF, $COLOR_ACTION)
	Return _Sleep($iSleepTimeF)
EndFunc   ;==>If randomSleep

; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization / BestClansNPlayersActions.au3
; Description ...: This file contains all functions of Bot Humanization feature - Best Clans and Players Part
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: Chilly-Chill (08.2019)
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func VisitBestPlayers()
	Click(40, 80) ; open the cup menu
	If randomSleep(1500) Then Return

	If IsClanOverview() Then
		Click(540, 50 + $g_iMidOffsetY) ; open best players menu
		If randomSleep(3000) Then Return

		If IsBestPlayers() Then
			Local $PlayerList = Random(1, 2, 1)
			Switch $PlayerList
				Case 1
					Click(270, 110 + $g_iMidOffsetY) ; look at global list
					If randomSleep(1000) Then Return
					Click(580, 320 + $g_iMidOffsetY + (52 * Random(0, 6, 1)))
					If randomSleep(500) Then Return
					VisitAPlayer()
					Click(70, 620 + $g_iBottomOffsetY) ; return home
				Case 2
					Click(640, 110 + $g_iMidOffsetY) ; look at local list
					If randomSleep(1000) Then Return
					Click(580, 160 + $g_iMidOffsetY + (52 * Random(0, 9, 1)))
					If randomSleep(500) Then Return
					VisitAPlayer()
					Click(70, 620 + $g_iBottomOffsetY) ; return home
			EndSwitch
		Else
			SetLog("Error When Trying To Open Best Players Menu ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open League Menu ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>VisitBestPlayers

Func LookAtBestClans()
	Click(40, 80) ; open the cup menu
	If randomSleep(1500) Then Return

	If IsClanOverview() Then
		Click(360, 50 + $g_iMidOffsetY) ; open best clans menu
		If randomSleep(3000) Then Return

		If IsBestClans() Then
			Local $PlayerList = Random(1, 2, 1)
			Switch $PlayerList
				Case 1
					Click(270, 110 + $g_iMidOffsetY) ; look at global list
					Click(580, 300 + $g_iMidOffsetY + (52 * Random(0, 6, 1)))
				Case 2
					Click(640, 110 + $g_iMidOffsetY) ; look at local list
					Click(580, 160 + $g_iMidOffsetY + (52 * Random(0, 9, 1)))
			EndSwitch
			If randomSleep(1500) Then Return

			If QuickMIS("BC1", $g_sImgHumanizationWarLog) Then
				SetLog("We Have Found a War Log Button, Let's Look At It ...", $COLOR_OLIVE)
				Click(100, 370 + $g_iMidOffsetY) ; open war log if available
				If randomSleep(1500) Then Return
				Click(270, 105 + $g_iMidOffsetY) ; classic war
				If randomSleep(1500) Then Return
				SetLog("Let's Scrolling The War Log ...", $COLOR_OLIVE)
				Scroll(Random(0, 2, 1)) ; scroll the war log
				SetLog("Exiting War Log Window ...", $COLOR_OLIVE)
				Click(50, 50 + $g_iMidOffsetY) ; click Return
			EndIf

			If randomSleep(1500) Then Return
			SetLog("Let's Scrolling The Clan Member List...", $COLOR_OLIVE)
			Scroll(Random(3, 5, 1)) ; scroll the member list

			Click(830, 50 + $g_iMidOffsetY) ; close window

		Else
			SetLog("Error When Trying To Open Best Players Menu ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open League Menu ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>LookAtBestClans

; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization / ChatActions.au3
; Description ...: This file contains all functions of Bot Humanization feature - Chat Part
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: Chilly-Chill (08.2019)
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func ReadClanChat()
	Click(20, 380 + $g_iMidOffsetY) ; open chat
	If randomSleep(3000) Then Return

	If ChatOpen() Then
		Click(230, 20) ; go to clan chat
		If randomSleep(1500) Then Return
		If Not IsClanChat() Then SetLog("Warning, We Will Scroll Global Chat ...", $COLOR_WARNING) ;=> Note: Global Chat has been Removed
		UnderstandChatRules()
		Local $MaxScroll = Random(0, 3, 1)
		SetLog("Let's Scrolling The Chat ...", $COLOR_OLIVE)
		For $i = 0 To $MaxScroll
			Local $x = Random(180 - 10, 180 + 10, 1)
			Local $yStart = Random(110 - 10 + $g_iMidOffsetYFixed, 110 + 10 + $g_iMidOffsetYFixed, 1) ; Resolution changed
			Local $yEnd = Random(570 - 10 + $g_iBottomOffsetYFixed, 570 + 10 + $g_iBottomOffsetYFixed, 1) ; Resolution changed
			ClickDrag($x, $yStart, $x, $yEnd) ; scroll the chat
			If randomSleep(10000, 3000) Then Return
		Next
		Click(330, 380 + $g_iMidOffsetY) ; close chat
	Else
		SetLog("Error When Trying To Open Chat ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>ReadClanChat

Func LaunchChallenges()
	Click(20, 380 + $g_iMidOffsetY) ; open chat
	If randomSleep(3000) Then Return

	If ChatOpen() Then
		Click(230, 20) ; go to clan chat
		If randomSleep(1500) Then Return
		If IsClanChat() Then
			UnderstandChatRules()
			Click(200, 650 + $g_iBottomOffsetY) ; click challenge button
			If randomSleep(1500) Then Return
			If IsChallengeWindow() Then
				Click(530, 175 + $g_iMidOffsetY) ; click text box
				SendText(SecureMessage(GUICtrlRead($g_hChallengeMessage)))
				If randomSleep(1500) Then Return
				Local $Layout = Random(1, 2, 1) ; choose a layout between normal or war base
				If $Layout <> $g_iLastLayout Then
					Click(240, 300) ; click choose layout button
					If randomSleep(1000) Then Return
					If IsChangeLayoutMenu() Then
						Switch $Layout
							Case 1
								$g_iLastLayout = 1
								Local $y = Random(180 + $g_iMidOffsetYFixed, 200 + $g_iMidOffsetYFixed, 1) ; Resolution changed
								Local $xStart = Random(170 - 10, 170 + 10, 1)
								Local $xEnd = Random(830 - 10, 830 + 10, 1)
								ClickDrag($xStart, $y, $xEnd, $y) ; scroll the layout bar to see normal bases
							Case 2
								$g_iLastLayout = 2
								Local $y = Random(180 + $g_iMidOffsetYFixed, 200 + $g_iMidOffsetYFixed, 1) ; Resolution changed
								Local $xStart = Random(690 - 10, 690 + 10, 1)
								Local $xEnd = Random(20 - 10, 20 + 10, 1)
								ClickDrag($xStart, $y, $xEnd, $y) ; scroll the layout bar to see war bases
						EndSwitch
						If randomSleep(2000) Then Return
						Click(240, 180) ; click first layout
						If randomSleep(1500) Then Return
						Click(180, 110) ; click top left return button
					Else
						SetLog("Error When Trying To Open Change Layout Menu ... Skipping...", $COLOR_WARNING)
					EndIf
				EndIf

				If IsChallengeWindow() Then
					If randomSleep(1500) Then Return
					Click(530, 300 + $g_iMidOffsetYFixed) ; click start button ; Resolution changed
					If randomSleep(1500) Then Return
					Click(330, 380 + $g_iMidOffsetY) ; close chat
				Else
					SetLog("We Are Not Anymore On Start Challenge Window ... Skipping ...", $COLOR_WARNING)
				EndIf
			Else
				SetLog("Error When Trying To Open Start Challenge Window ... Skipping ...", $COLOR_WARNING)
			EndIf
		Else
			SetLog("Error When Trying To Open Clan Chat ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open Chat ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>LaunchChallenges