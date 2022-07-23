; #FUNCTION# ====================================================================================================================
; Name ..........: GTFO
; Description ...: This File contents for 'request and leave' algorithm , fast Donate'n'Train
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: ProMac
; Modified ......: 06/2017 , MHK2012(05/2018), Boludoz(19/08/2018), Fahid.Mahmood(10/10/2018), Boludoz(19/05/2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ---
; ===============================================================================================================================

Global $g_iTroosNumber = 0
Global $g_iSpellsNumber = 0
Global $g_iClanlevel = 8
Global $g_OutOfTroops = False
Global $g_iLoop = 0
Global $g_sClanJoin = True
Global $g_bFirstHop = True
Global $g_bLeader = False

Func MainGTFO()
	If $g_bChkUseGTFO = False Then Return
	If $g_aiCurrentLoot[$eLootElixir] <> 0 And $g_aiCurrentLoot[$eLootElixir] < $g_iTxtMinSaveGTFO_Elixir Then
		SetLog("Elixir Limits Reached!! Let's farm!", $COLOR_INFO)
		Return
	EndIf
	If $g_aiCurrentLoot[$eLootDarkElixir] <> 0 And $g_aiCurrentLoot[$eLootDarkElixir] < $g_iTxtMinSaveGTFO_DE Then
		SetLog("Dark Elixir Limits Reached!! Let's farm!", $COLOR_INFO)
		Return
	EndIf
	If $g_iTxtCyclesGTFO = 0 Then
		$g_iLoop = 0
	Else
		If $g_iLoop > $g_iTxtCyclesGTFO And $g_bExitAfterCyclesGTFO Then
			SetDebugLog("GTFO Cycles Done!", $COLOR_DEBUG)
			Return
		EndIf
	EndIf
	$g_bCloudsActive = True
	ClanHop()
	Local $_timer = TimerInit()
	Local $_diffTimer = 0
	Local $_bFirstLoop = True
	$g_iTroosNumber = 0
	$g_iSpellsNumber = 0
	While 1
		SetLogCentered(" GTFO v2.5 ", Default, Default, True)
		SetDebugLog("Cycles :" & $g_iTxtCyclesGTFO & " Loop(s)", $COLOR_DEBUG)
		If Not IsNumber($g_iTxtCyclesGTFO) Or $g_iTxtCyclesGTFO < 0 Then SetLog("Please config your cycles correctly! (UI:" & $g_iTxtCyclesGTFO & " Loop(s))", $COLOR_ERROR)
		If $g_iTxtCyclesGTFO = 0 Then
			SetLog("Cycles selected as '0', This feature will run indefinitely.", $COLOR_INFO)
			SetLog("Only trains, Donates and eventually other features, but never attacks!", $COLOR_INFO)
		EndIf
		$_diffTimer = (TimerDiff($_timer) / 1000) / 60
		If Not $_bFirstLoop Then
			SetLog(" - Running GTFO for " & StringFormat("%.2f", $_diffTimer) & " min", $COLOR_DEBUG)
		EndIf
		$_bFirstLoop = False

		If Not $g_bRunState Then Return
		If _Sleep($DELAYRUNBOT3) Then Return
		If CheckAndroidReboot() Then ContinueLoop
		checkObstacles()
		checkMainScreen(False)
		If isProblemAffect() Then ExitLoop
		checkAttackDisable($g_iTaBChkIdle)
		TrainTroopsGTFO()
		If $g_aiTimeTrain[0] > 10 Then
			SetLog("Let's wait for a few minutes!", $COLOR_INFO)
			Local $aRndFuncList = ['LabCheck', 'Collect', 'CheckTombs', 'CleanYard', 'CollectFreeMagicItems', "BuilderBase"]
			_ArrayShuffle($aRndFuncList)
			For $Index In $aRndFuncList
				If Not $g_bRunState Then Return
				__RunFunction($Index)
				If $g_bRestart Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
			Next
		EndIf
		VillageReport()
		If $g_aiCurrentLoot[$eLootElixir] <> 0 And $g_aiCurrentLoot[$eLootElixir] < $g_iTxtMinSaveGTFO_Elixir Then
			SetLog("Elixir Limits Reached!! Let's farm!", $COLOR_INFO)
			ExitLoop
		EndIf
		If $g_aiCurrentLoot[$eLootDarkElixir] <> 0 And $g_aiCurrentLoot[$eLootDarkElixir] < $g_iTxtMinSaveGTFO_DE Then
			SetLog("Dark Elixir Limits Reached!! Let's farm!", $COLOR_INFO)
			ExitLoop
		EndIf
		Local $bDonate = DonateGTFO()
		If Not $bDonate Then
			SetLog("Finished GTFO", $COLOR_INFO)
			LeaveClanHop()
			Return
		EndIf
		If Not IfIsToStayInGTFO() Then
			Return
		EndIf
	WEnd
	$g_bCloudsActive = False
EndFunc   ;==>MainGTFO

Func TrainTroopsGTFO()
	TrainSystem()
EndFunc   ;==>TrainTroopsGTFO

Func LeaveClanHop()
	If Not $g_bChkGTFOReturnClan Or $g_bLeader = True Then Return

	;	1. The green join appear.
	;		A. Joins clan with invitation.
	;		B. You want to join a private clan.
	;		C. Joins a free clan and has no clan, therefore the OK does not appear.
	;	2. The green join does not appear.

	Local $aButton = ""
	CloseClanChat()

	Setlog("GTFO|Joining to native clan.", $COLOR_INFO)

	Local $sClaID = StringReplace($g_sTxtClanID, "#", "")
	Setlog("Send : " & $sClaID, $COLOR_INFO)
	AndroidAdbSendShellCommand("am start -n " & $g_sUserGamePackage & "/" & $g_sUserGameClass & " -a android.intent.action.VIEW -d 'https://link.clashofclans.com/?action=OpenClanProfile&tag=" & $sClaID & "'", Default)
	Setlog("Wait", $COLOR_INFO)
	If RandomSleep(2000) Then Return
	If _Wait4PixelArray($g_aJoinClanBtn) Then
		Click($g_aJoinClanBtn[0] - Random(0, 25, 1), $g_aJoinClanBtn[1] + Random(0, 25, 1))
		If RandomSleep(250) Then Return

		Local $iLoops = 15
		Do
			If _Wait4PixelArray($g_aJoinInvBtn) Then
				Click($g_aJoinInvBtn[0] - Random(0, 25, 1), $g_aJoinInvBtn[1] + Random(0, 25, 1))
				If RandomSleep(1000) Then Return
				_Wait4PixelGoneArray($g_aJoinInvBtn)
			EndIf

			If _Wait4PixelArray($g_aOKBtn) Then
				Click($g_aOKBtn[0] - Random(0, 25, 1), $g_aOKBtn[1] + Random(0, 25, 1))
				If RandomSleep(1000) Then Return
				_Wait4PixelGoneArray($g_aOKBtn)
			EndIf

			_CaptureRegion()
			If _CheckPixel($aChatTab, False) Or _CheckPixel($aChatTab2, False) Or _CheckPixel($aChatTab3, False) Then
				ExitLoop
			EndIf
		Until ($iLoops > 15)

		waitMainScreenMini()

		If $iLoops < 15 Then
			If RandomSleep(1000) Then Return False

			If ProfileSwitchAccountEnabled() Then checkSwitchAcc() ; Forced to switch

			Return True
		EndIf
	Else
		waitMainScreenMini()
	EndIf


	Return False
EndFunc   ;==>LeaveClanHop

Func DonateGTFO()
	AutoItSetOption("MouseClickDelay", 1)
	AutoItSetOption("MouseClickDownDelay", 1)
	Local $_timer = TimerInit()
	Local $_diffTimer = 0, $iTime2Exit = 20
	Local $_bReturnT = False
	Local $_bReturnS = False
	Local $y = 90, $firstrun = True
	Local $aiDonateButton[2], $aiDonateButtons
	Local $iToShearch = 10
	Local $bDonate = True
	$g_OutOfTroops = False
	OpenClanChat()
	If _Sleep($DELAYRUNBOT3) Then Return
	Local $iDonateLoop = 0
	While 1
		SetDebugLog("While Main started DonateGTFO")
		If Not $g_bRunState Then Return
		If _Sleep($DELAYRUNBOT3) Then Return
		$_diffTimer = (TimerDiff($_timer) / 1000) / 60

		If $_diffTimer > $iTime2Exit Then ExitLoop
		SetDebugLog("While Main - Cycles Used:" & $g_iLoop & " Loop(s)", $COLOR_ERROR)
		If $g_iTxtCyclesGTFO > 0 And $g_iLoop > $g_iTxtCyclesGTFO And $g_bExitAfterCyclesGTFO Then ExitLoop
		Local $Buttons = 0
		
		; add scroll here
		ScrollDown()
		
		$iToShearch = 10
		$bDonate = True
		While $bDonate
			If Not $g_bRunState Then Return
			SetDebugLog("While Main $iDonateLoop: " & $iDonateLoop)
			Local $iTime = TimerInit()
			Local $iBenchmark
			$iDonateLoop += 1
			$g_iLoop += 1
			If $g_iTxtCyclesGTFO > 0 And $g_iLoop > $g_iTxtCyclesGTFO And $g_bExitAfterCyclesGTFO Then ExitLoop
			If $iDonateLoop >= 10 Then ExitLoop
			$_bReturnT = False
			$_bReturnS = False
			$firstrun = False
			$iBenchmark = TimerDiff($iTime)
			SetDebugLog("While Donation Get all Buttons in " & StringFormat("%.2f", $iBenchmark) & "'ms", $COLOR_DEBUG)
			
			 ; Heavy artillery LoL.
			 $aiDonateButtons = findMultipleQuick($g_sImgDonateCC, $iToShearch, "200, 46, 300, 612", True, "DonateButton", False) ; Resolution changed
			
			If UBound($aiDonateButtons) > 0 And Not @error Then     ; if Donate Button found
				For $iBig = 0 To UBound($aiDonateButtons) - 1
					$aiDonateButton[0] = $aiDonateButtons[$iBig][1]     ; + Random(20, 25, 1)
					$aiDonateButton[1] = $aiDonateButtons[$iBig][2]     ; - Random(5, 10, 1)
					
					;;reset every run
					$bDonate = False
					
					;;; Open Donate Window
					If _Sleep($DELAYDONATECC3) Then Return
					If Not DonateWindow($aiDonateButton) Then
						$bDonate = True
						SetLog("Donate Window did not open - Exiting Donate", $COLOR_ERROR)
						CloseXDonate()     ; Custom fix - Team__AiO__MOD
						ContinueLoop     ; Leave donate to prevent a bot hang condition
					EndIf
					
					If DonateIT(0) Then $_bReturnT = True
					If $g_OutOfTroops Then
						CloseXDonate()     ; Custom fix - Team__AiO__MOD
						CloseClanChat()
						ExitLoop
					EndIf
					If DonateIT(14) Then $_bReturnS = True
					
					$bDonate = True
					
					If _Sleep($DELAYDONATEWINDOW1) Then ExitLoop
					CloseXDonate()     ; Custom fix - Team__AiO__MOD
				Next
			EndIf
			
			$bDonate = ScrollUp()
			If $bDonate Then
				$iToShearch = 1
			EndIf
		WEnd
		SetDebugLog("While Main DonateGTFO EXIT")
		If $iDonateLoop >= 1 Then
			If $g_bChkGTFOClanHop = True Then
				ClanHop()
				$firstrun = True
				$iDonateLoop = 0
			EndIf
		EndIf
		If $iDonateLoop >= 10 Then
			ClickAwayChat(250)
			$iDonateLoop = 0
		EndIf
	WEnd
	AutoItSetOption("MouseClickDelay", 10)
	AutoItSetOption("MouseClickDownDelay", 10)
	CloseClanChat()
	If $g_iTxtCyclesGTFO > 0 And $g_iLoop > $g_iTxtCyclesGTFO And $g_bExitAfterCyclesGTFO Then Return False
EndFunc   ;==>DonateGTFO


Func ClanHop()
	If $g_bLeader Or Not $g_bChkGTFOClanHop Then Return

	SetLog("Start Clan Hopping", $COLOR_INFO)
;~ 	Local $sTimeStartedHopping = _NowCalc()
	Local $iErrors = 0


	$g_iCommandStop = 0 ; Halt Attacking

	While 1
		Local $bIsInClan = False

		If $iErrors >= 10 Then
			SetLog("Too Many Errors occured in current ClanHop Loop. Leaving ClanHopping!", $COLOR_ERROR)
;~ 			CloseClanChat()
			ExitLoop
		EndIf

		If Not OpenClanChat() Then
			SetLog("ClanHop | OpenClanChat fail.", $COLOR_ERROR)
			$iErrors += 1
			ContinueLoop
		EndIf

		#Region - If not is in clan
		If _Wait4PixelGoneArray($g_aIsClanChat) And _Wait4PixelArray($g_aClanBadgeNoClan) Then ; If not Still in Clan
			;CLick on green button if you dont is on clan, It is way 2
			Click(Random(104, 216, 1), Random(471, 515, 1))
			If RandomSleep(250) Then Return
		EndIf
		#EndRegion - If not is in clan

		#Region - If is in clan
		If _Wait4PixelArray($g_aIsClanChat) Then ; If Still in Clan
			$bIsInClan = True
			SetLog("Still in a Clan! Leaving the Clan now")
			ClickP($g_aIsClanChat)

			#Region - ClanHop return to clan alternative
			#cs
			If $g_bFirstHop = True And $g_bChkGTFOReturnClan = True Then
				If _Wait4PixelArray($g_aShare) Then
					ClickP($g_aShare)
				Else
					SetLog("No Share Button", $COLOR_ERROR)
					; Return False
				EndIf

				Local $sData = ""
				If _Wait4PixelArray($g_aCopy) Then
					Click($g_aCopy[0], $g_aCopy[1] + 25)
					$sData = ClipGet()
					If RandomSleep(250) Then Return
					GUICtrlSetData($g_hTxtClanID, $sData)
					$g_sTxtClanID = $sData
					$g_bFirstHop = False
				Else
					SetLog("No Copy Button", $COLOR_ERROR)
					; Return False
				EndIf
			EndIf
			#Ce
			#EndRegion - ClanHop return to clan alternative


			If _Wait4PixelArray($g_aClanPage) Then
				; Click clans label, It is way 1
				ClickP($g_aClanLabel)
			Else
				SetLog("Clan Page did not open! Starting over again", $COLOR_ERROR)
				$iErrors += 1
				ContinueLoop
				;Setlog("GTFO|Error or you are a clan leader.", $COLOR_ERROR)
				;$g_bLeader = True
				;$sClanJoin = False
				;Return False
			EndIf
		EndIf
		#EndRegion - If is in clan

		If RandomSleep(500) Then Return

		; Open clans page
		Local $aIsOnClanLabel = [640, 205, 0xDDF685, 20]
		If _Wait4PixelArray($g_aClanLabel) Then
			If RandomSleep(500) Then Return

			Local $hTimer = TimerInit()
			Local $aReturn = 0
			Do
				$aReturn = _PixelSearch(485, 270 + $g_iMidOffsetYFixed, 495, 670 + $g_iBottomOffsetYFixed, Hex(0xF0E77B, 6), 15)
				If IsArray($aReturn) Then
					Click($aReturn[0], $aReturn[1] + (67 * Random(1, 4, 1)))
					If RandomSleep(250) Then Return
					ExitLoop
				EndIf
				If RandomSleep(250) Then Return
			Until (2000 < TimerDiff($hTimer))

			If IsArray($aReturn) Then

				If _Wait4PixelArray($g_aJoinClanBtn) Then
					Click($g_aJoinClanBtn[0] - Random(0, 25, 1), $g_aJoinClanBtn[1] + Random(0, 25, 1))
					If RandomSleep(250) Then Return

					; Strategy for no clan case.
					Local $iLoops = 0
					Do
						If _Wait4PixelArray($g_aJoinInvBtn) Then
							Click($g_aJoinInvBtn[0] - Random(0, 25, 1), $g_aJoinInvBtn[1] + Random(0, 25, 1))
							If RandomSleep(1000) Then Return
							_Wait4PixelGoneArray($g_aJoinInvBtn)
						EndIf

						If _Wait4PixelArray($g_aOKBtn) Then
							Click($g_aOKBtn[0] - Random(0, 25, 1), $g_aOKBtn[1] + Random(0, 25, 1))
							If RandomSleep(1000) Then Return
							_Wait4PixelGoneArray($g_aOKBtn)
						EndIf
						_CaptureRegion()
						If _CheckPixel($aChatTab, False) Or _CheckPixel($aChatTab2, False) Or _CheckPixel($aChatTab3, False) Then
							ExitLoop
						EndIf
					Until ($iLoops > 6)

					If ($iLoops > 6) Then
						waitMainScreenMini()
						$iErrors += 1
						ContinueLoop
					EndIf

					If RandomSleep(250) Then Return

					If UnderstandChatRules() = False Then
						SetLog("Fail GTFO | UnderstandChatRules. (1).", $COLOR_ERROR)
						$iErrors += 1
						ContinueLoop
					EndIf

				Else
					SetLog("Fail GTFO | Join. (3).", $COLOR_ERROR)
					$iErrors += 1
					ContinueLoop
				EndIf

			Else
				SetLog("Fail GTFO | Join. (1).", $COLOR_ERROR)
				$iErrors += 1
				ContinueLoop
			EndIf

			If Not OpenClanChat() Then
				$iErrors += 1
				ContinueLoop
			EndIf

			SetLog("GTFO | Clan hop finished.", $COLOR_INFO)

			; CloseClanChat()
			Return True

		Else
			$iErrors += 1
			ContinueLoop
		EndIf
	WEnd

	If $iErrors >= 10 Then
		Setlog("ClanSaveAndJoiner|End ERROR", $COLOR_ERROR)
		Return False
	EndIf

	Return True
	ClickAwayChat(400)
EndFunc   ;==>ClanHop


Func ClickAwayChat($iSleep = 10)
	If RandomSleep($iSleep) Then Return
	Local $iX = Random($aiClickAwayRegionRight[0], $aiClickAwayRegionRight[2], 1)
	Local $iY = Random($aiClickAwayRegionRight[1], $aiClickAwayRegionRight[3], 1)
	Click($iX, $iY, 1, 0)
EndFunc   ;==>ClickAwayChat

Func ScrollUp()
	Local $aScroll
	ForceCaptureRegion()
	Local $y = 81 + $g_iMidOffsetYFixed
	$aScroll = _PixelSearch(293, $y, 295, 8 + $y, Hex(0xFFFFFF, 6), 10)
	If IsArray($aScroll) And _ColorCheck(_GetPixelColor(300, 95 + $g_iMidOffsetYFixed, True), Hex(0x5da515, 6), 15) Then
		Click($aScroll[0], $aScroll[1], 1, 0, "#0172")
		Local $aOk, $iLoop = 0
		Do
			$iLoop += 1
			_CaptureRegion()
			If _Sleep($DELAYDONATECC2) Then Return
			_CaptureRegion2()
			$aOk = _MasivePixelCompare($g_hHBitmap2, $g_hHBitmap, 13, 49, 20, 678 + $g_iBottomOffsetYFixed, 15, 5)
		Until $aOk = -1 Or $iLoop > 15
		Return True
	EndIf
	Return False
EndFunc   ;==>ScrollUp

Func ScrollDown()
	Local $aScroll
	ForceCaptureRegion()
	$aScroll = _PixelSearch(24, 629 + $g_iBottomOffsetYFixed, 31, 679 + $g_iBottomOffsetYFixed, Hex(0x6EBD39, 6), 10)
	If IsArray($aScroll) Then
		Click($aScroll[0], $aScroll[1], 1, 0, "#0172")
		Local $aOk, $iLoop = 0
		Do
			$iLoop += 1
			_CaptureRegion()
			If _Sleep($DELAYDONATECC2) Then Return
			_CaptureRegion2()
			$aOk = _MasivePixelCompare($g_hHBitmap2, $g_hHBitmap, 13, 49, 20, 678, 15, 5)
		Until $aOk = -1 Or $iLoop > 15
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>ScrollDown

Func DonateIT($Slot)
	Local $iTroopIndex = $Slot, $yComp = 0, $iNumberClick = 5
	If $g_iClanlevel >= 4 Then $iNumberClick = 6
	If $g_iClanlevel >= 8 Then $iNumberClick = 8
	If $Slot < 14 Then
		If Not _ColorCheck(_GetPixelColor(350, $g_iDonationWindowY + 105 + $yComp, True), Hex(0x3d79b5, 6), 15) Then
			SetLog("You can't donate more Troops for this request!", $COLOR_INFO)
			Return False
		EndIf
		For $i = 1 To $iNumberClick
			PureClick(395 + ($Slot * 68), $g_iDonationWindowY + 57 + $yComp, 1, $DELAYDONATECC3, "#0175")
			If Not _ColorCheck(_GetPixelColor(350, $g_iDonationWindowY + 105 + $yComp, True), Hex(0x3d79b5, 6), 15) Then
				ExitLoop
			EndIf
		Next
		SetLog(" - Donated Troops on Slot " & $Slot + 1, $COLOR_INFO)
		$Slot = 0
		$iTroopIndex = $Slot

		For $i = 1 To $iNumberClick
			PureClick(395 + ($Slot * 68), $g_iDonationWindowY + 147 + $yComp, 1, $DELAYDONATECC3, "#0175")
			If _ColorCheck(_GetPixelColor(350, $g_iDonationWindowY + 105 + $yComp, True), Hex(0xDADAD5, 6), 5) Then
				ExitLoop
			EndIf
		Next
		SetLog(" - Donated Troops on Slot " & $Slot + 1, $COLOR_INFO)
		If _ColorCheck(_GetPixelColor(350, $g_iDonationWindowY + 105 + $yComp, True), Hex(0xDADAD5, 6), 5) Then
			SetLog("No More troops let's train!", $COLOR_INFO)
			$g_OutOfTroops = True
			If _Sleep(1000) Then Return
			Return False
		Else
			Return True
		EndIf
		Return False
	EndIf
	If $Slot > 13 Then
		$Slot = $Slot - 14
		$iTroopIndex = $Slot
		$yComp = 206
	EndIf
	If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $yComp, True), Hex(0x6e6e6e, 6), 20) Then
		SetLog("You can't donate more Spells for this request!", $COLOR_INFO)
		Return False
	EndIf
	If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $g_iDonationWindowY + 105 + $yComp, True), Hex(0x6d45bd, 6), 20) Then
		Click(365 + ($Slot * 68), $g_iDonationWindowY + 57 + $yComp, 1, $DELAYDONATECC3, "#0175")
		SetLog(" - Donated 1 Spell on Slot " & $Slot + 1, $COLOR_INFO)
		$g_aiDonateStatsSpells[$iTroopIndex][0] += 1
		$g_iSpellsNumber += 1

		Return True
	Else
		SetLog(" - Spells Empty or Filled!", $COLOR_ERROR)
		Return False
	EndIf
EndFunc   ;==>DonateIT

; Will update the Stats and check the resources to exist from GTFO and Farm again
Func IfIsToStayInGTFO()
	; **TODO**
	; Main page
	; Report village
	; check values to keep
	; return false or true

	If _Sleep(2000) Then Return
	checkMainScreen(False)
	VillageReport()

	If $g_aiCurrentLoot[$eLootElixir] <> 0 And $g_aiCurrentLoot[$eLootElixir] < $g_iTxtMinSaveGTFO_Elixir Then
		SetLog("Reach the Elixir Limit , Let's Farm!!", $COLOR_INFO)
		; Force double army on GTFO
 		If $g_bTotalCampForced = True And $g_bDoubleTrain Then
			$g_iTotalCampSpace = Number($g_iTotalCampForcedValue) / 2
			For $T = 0 To $eTroopCount - 1
				If $g_aiArmyCompTroops[$T] <> 0 Then
					$g_aiArmyCompTroops[$T] = $g_aiArmyCompTroops[$T] / 2
					SetLog("Set " & $g_asTroopShortNames[$T] & " To  [" & $g_aiArmyCompTroops[$T] & "]", $COLOR_INFO)
				EndIf
			Next
			SetLog("Set Custom Train to One Army to Farm [" & $g_iTotalCampSpace & "]", $COLOR_INFO)
		EndIf
		Return False
	ElseIf $g_aiCurrentLoot[$eLootDarkElixir] <> 0 And $g_aiCurrentLoot[$eLootDarkElixir] < $g_itxtMinSaveGTFO_DE Then
		SetLog("Reach the Dark Elixir Limit , Let's Farm!!", $COLOR_INFO)
		; Force double army on GTFO
 		If $g_bTotalCampForced And $g_bDoubleTrain Then
			$g_iTotalCampSpace = Number($g_iTotalCampForcedValue) / 2
			For $T = 0 To $eTroopCount - 1
				If $g_aiArmyCompTroops[$T] <> 0 Then
					$g_aiArmyCompTroops[$T] = $g_aiArmyCompTroops[$T] / 2
					SetLog("Set " & $g_asTroopShortNames[$T] & " To  [" & $g_aiArmyCompTroops[$T] & "]", $COLOR_INFO)
				EndIf
			Next
			SetLog("Set Custom Train to One Army to Farm [" & $g_iTotalCampSpace & "]", $COLOR_INFO)
		EndIf
		Return False
	EndIf

	Return True
EndFunc   ;==>IfIsToStayInGTFO
