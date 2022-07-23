; #FUNCTION# ====================================================================================================================
; Name ..........: Kickout
; Description ...: This File contents for 'Kickout' algorithm , fast Donate'n'Train and Kickout New members
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: Boludoz
; Modified ......: 07/2022
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ---
; ===============================================================================================================================
Global $g_bNotKick = False

Func MainKickout()
	If Not $g_bChkUseKickOut Or $g_bNotKick Then Return
	Local $iLastSlot = 0

	SetLog("Start The Kickout Feature![" & $g_iTxtKickLimit & "]....", $COLOR_INFO)
	Local $Number2Kick = 0

	For $T = 0 To $g_iTxtKickLimit - 1
		
		; Needs refresh.
		If Not IsMainPage(3) Then
			CheckMainScreen()
		EndIf
		
		If OpenClanPage("Kickout") Then
			ClickP($g_aClickOnMost, 4, 1000)
			
			SetLog("Donated CAP: " & $g_iTxtDonatedCap & " /Received CAP: " & $g_iTxtReceivedCap & " /Kick Spammers: " & $g_bChkKickOutSpammers, $COLOR_INFO)
			For $Rank = 0 To 9

				#Region - Core
				If RandomSleep(1500) Then Return
				
				Go2Bottom()
				Local $aXPStar = QuickMIS("CNX", @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\KickOut\Equal\", 798, 118, 833, 626, True, False) ; Resolution changed

				If Not IsArray($aXPStar) Then
					CheckMainScreen()
					Setlog("- KickOut fail : $aXPStar", $COLOR_ERROR)
					Return False
				EndIf
				
				; RemoveDupCNX($aXPStar)
				
				_ArrayShuffle($aXPStar)

				For $i = 0 To UBound($aXPStar) - 1
					; Get the Red from 'New' Word
					Local $iNewWord = _PixelSearch(197, $aXPStar[$i][2] - 23, 214, $aXPStar[$i][2] + 23, Hex(0xE73838, 6), 15)
					Local $iRank = _PixelSearch(197, $aXPStar[$i][2], 214, $aXPStar[$i][2] + 23, Hex(0x434137, 6), 15)

					; Return 0 let's proceed with a new loop
					If $iNewWord = 0 Or $iRank <> 0 Then ContinueLoop

					Local $iDonated = 0
					Local $iReceived = 0

					; Confirming the array and the Dimension
					If IsArray($iNewWord) Then
						$iDonated = Number(getOcrAndCapture("coc-army", 508, $aXPStar[$i][2] - 6, 75, 16, True))
						$iReceived = Number(getOcrAndCapture("coc-army", 625, $aXPStar[$i][2] - 6, 75, 16, True))
						SetDebugLog("$iDonated : " & $iDonated & "/ $iReceived : " & $iReceived)
						SetLog("[NEW CLAN MEMBER] Donated: " & $iDonated & " / Received: " & $iReceived, $COLOR_BLACK)
					Else
						ContinueLoop
					EndIf
					
					Select
						Case ($iDonated = 0 And $iReceived = 0) Or ($iDonated < $g_iTxtDonatedCap And $iReceived < $g_iTxtReceivedCap)
							ContinueLoop

						Case ($g_bChkKickOutSpammers = True And $iDonated > 0 And $iReceived = 0) Or ($g_bChkKickOutSpammers = False And $iDonated >= $g_iTxtDonatedCap) Or ($g_bChkKickOutSpammers = False And $iReceived >= $g_iTxtReceivedCap)

					EndSelect

					Local $aKickOut = QuickMIS("CNX", @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\KickOut\KickOutBTN\", 445, 116, 493, 636, True, False) ; Resolution changed
					
					If Not IsArray($aKickOut) Then
						Setlog("- KickOut fail : $aKickOut", $COLOR_ERROR)
						Return False
					ElseIf UBound($aKickOut) > 2 Then
						_ArraySort($aKickOut, 1, 0, 0, 2)
						PureClick($aKickOut[0][1] + 50, $aKickOut[0][2] + 25)
						If _Wait4Pixel($g_aOkayKickOut[0], $g_aOkayKickOut[1] , $g_aOkayKickOut[2], $g_aOkayKickOut[3], 4000) Then
							ClickP($g_aOkayKickOut, 1)
							Setlog("Member Kicked Out", $COLOR_ACTION)
						EndIf
						$Number2Kick += 1
						ExitLoop 2
						
					EndIf
				Next
				#EndRegion - Core
			Next
			If $g_iTxtKickLimit >= $Number2Kick Then Return
			ClickP($g_aIsOnClanTab, 1)
		Else
			ClickP($g_aIsOnClanTab, 1)
			CheckMainScreen()
		EndIf
		If $g_iTxtKickLimit >= $Number2Kick Then Return
	Next


EndFunc   ;==>MainKickout

Func Go2Bottom()

	SetLog(" ## Go2Bottom | ClickDrag ## ", $COLOR_DEBUG)

	Swipe(421 - Random(0, 50, 1), 580 - Random(0, 50, 1), 421 - Random(0, 50, 1), 50 + Random(0, 10, 1), Random(900, 1100, 1))
	If @error Then
		SetLog("Swipe ISSUE|error: " & @error, $COLOR_DEBUG)
	EndIf
	If _Sleep(150) Then Return ; 500ms

	; SetLog(" ## Go2Bottom | ClickDrag ## Failed!", $COLOR_DEBUG)
	Return True
EndFunc   ;==>Go2Bottom

#cs
# 1 . Open profile ; Mouse LBUTTONDOWN 036,029 Color FFFFFE
# 2 . Go to clan page ; Mouse LBUTTONDOWN 323,020 Color 828C92
	|--> Check if is on home village > Mouse LBUTTONDOWN 277,077 Color BCCBCD
# 3 . Check if is leader o coleader ; 307,263 Color F0D56C (Coleader / Leader)
# 4 . Do four clicks > Mouse LBUTTONDOWN 406,418 Color CF932F x4
# 5 . Drag.
# 4 . KickOut if condition is.
#ce

Global $g_aOpenProfile = [36, 29]
Global $g_aIsOnClanTab = [409, 23, 0xEBEFEF, 20]
Global $g_aIsOnHomeVillage = [277, 77, 0xBCCBCD, 20]
Global $g_aIsLeaderColeader = [438, 288, 0xd8f380, 20]
Global $g_aClickOnMost = [406, 418, 0xCF932F, 20] ;x4
Global $g_aCloseX = [824, 31 , 0xFFFFFF, 25]
Global $g_aOkayKickOut = [553, 205 , 0x87F9E0, 25]

Func OpenClanPage($sMode = "None")

	; ********* OPEN TAB AND CHECK IT PROFILE ***********

	SetLog("[OpenClanPage] Mode : " & $sMode, $COLOR_DEBUG)
	; Click Info Profile Button
	ClickP($g_aOpenProfile, 1, 0, "#0222")
	If _Sleep(2500) Then Return

	; Check the '[X]' tab region
	If _Wait4Pixel($g_aCloseX[0], $g_aCloseX[1] , $g_aCloseX[2], $g_aCloseX[3], 4000) Then

		; Click on Clan Tab
		ClickP($g_aIsOnClanTab, 1)
		
		If _Wait4PixelArray($g_aIsOnClanTab) Then
	
			; Click on Home Village
			If Not _Wait4Pixel($g_aIsOnHomeVillage[0], $g_aIsOnHomeVillage[1], $g_aIsOnHomeVillage[2], $g_aIsOnHomeVillage[3], 500) Then
				ClickP($g_aIsOnHomeVillage, 1)
			EndIf
			
			Switch $sMode
				Case "KickOut"
					If Not _Wait4Pixel($g_aIsLeaderColeader[0], $g_aIsLeaderColeader[1], $g_aIsLeaderColeader[2], $g_aIsLeaderColeader[3], 500) Then
						SetLog("[OpenClanPage] You are not a Co-Leader/Leader of your clan! ", $COLOR_DEBUG)
						ClickP($g_aCloseX)
						CheckMainScreen()
						Return False
					Else
						Return True
					EndIf
				Case "GTFO"
					SetLog("[OpenClanPage] GTFO MODE NOT FINISHED", $COLOR_ERROR)
			EndSwitch
			
			SetLog("[OpenClanPage] Didn't Openned", $COLOR_DEBUG)
			Return False
		EndIf
	Else
		
	EndIf
EndFunc   ;==>OpenClanPage

Func Swipe($x1, $y1, $X2, $Y2, $Delay, $wasRunState = $g_bRunState)

	Local $error = 0

	If $g_bAndroidAdbClickDrag Then
		AndroidAdbLaunchShellInstance($wasRunState)
		If @error = 0 Then
			AndroidAdbSendShellCommand("input swipe " & $x1 & " " & $y1 & " " & $X2 & " " & $Y2, Default, $wasRunState)
			SetError(0, 0)
		Else
			$error = @error
			SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB input due to error", $COLOR_ERROR)
			$g_bAndroidAdbInput = False
		EndIf
		If _Sleep($Delay / 5) Then Return SetError(-1, "", False)
	EndIf

	If Not $g_bAndroidAdbClickDrag Or $error <> 0 Then
		Return _PostMessage_ClickDrag($x1, $y1, $X2, $Y2, "left", $Delay)
	EndIf

	Return SetError($error, 0)

EndFunc   ;==>Swipe
