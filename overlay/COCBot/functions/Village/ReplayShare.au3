; #FUNCTION# ====================================================================================================================
; Name ..........: ReplayShare
; Description ...: This function will publish replay if minimum loot reached
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-06)
; Modified ......: Sardo (2015-08), MonkeyHunter(2016-01), CodeSlinger69 (2017-01), Fliegerfaust(2017-08)
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func ReplayShare($bShareLastReplay)
	If Not $g_bShareAttackEnable Or Not $bShareLastReplay Then Return

	Local Static $sLastTimeShared = ""
	If $sLastTimeShared <> "" And Number(_DateDiff("n", $sLastTimeShared, _NowCalc())) <= 5 Then
		SetDebugLog("Last Replay got shared less than 30 Minutes ago, return (" & $sLastTimeShared & ")", $COLOR_DEBUG)
		Return
	EndIf

	SetLog("Sharing last Attack", $COLOR_INFO)

	ClickAway()
	If _Sleep($DELAYREPLAYSHARE2) Then Return

	If ClickB("MessagesButton", Default, 300) Then
		If _Sleep(2000) Then Return
		SetDebugLog("ClickB true", $COLOR_DEBUG)
		Local $aiAttackLogTab = findButton("AttackLogTab")
		SetDebugLog("Trying to find AttackLogTab button", $COLOR_DEBUG)
		If _Sleep(2000) Then Return
		If IsArray($aiAttackLogTab) And UBound($aiAttackLogTab, 1) >= 2 Then
			SetDebugLog("Found Attack Log tab", $COLOR_DEBUG)
			Local $aIsAttackLogTabOpen[4] = [$aiAttackLogTab[0] - 30, $aiAttackLogTab[1], 0xF4F4F0, 20]
			If Not _CheckPixel($aIsAttackLogTabOpen, True) Then ClickP($aiAttackLogTab) ; Check if Attack Log Tab is already open otherwise click it

			If ClickB("ShareReplayButton") Then
				Local $asReplayText = StringSplit($g_sShareMessage, "|")     ; Split the String into an Array holding each seperat
				Local $sRndMessage = @error ? $asReplayText[1] : $asReplayText[Random(1, $asReplayText[0], 1)]

				If _Sleep($DELAYREPLAYSHARE1) Then Return

				Local $aiSendButton = findButton("SendButton")
				If IsArray($aiSendButton) And UBound($aiSendButton, 1) >= 1 Then
					Click($aiSendButton[0], $aiSendButton[1] - 75) ; Select the Text Area Above the Send Button
					If _Sleep($DELAYREPLAYSHARE1) Then Return

					If Not $g_bChkBackgroundMode And Not $g_bNoFocusTampering Then ControlFocus($g_hAndroidWindow, "", "") ; Fixes typos which could occur
					AndroidSendText($sRndMessage, True)
					If _Sleep($DELAYREPLAYSHARE1) Then Return
					If SendText($sRndMessage) = 0 Then ; Type in Text to share
						SetLog("Failed to insert text!", $COLOR_ERROR)
						Return
					EndIf

					If _Sleep($DELAYREPLAYSHARE1) Then Return
					ClickP($aiSendButton) ; Click Send
					$sLastTimeShared = _NowCalc() ; Update the Date where the last Replay got shared
				Else
					SetLog("Send Button not found", $COLOR_ERROR)
					Return
				EndIf
			Else
				SetLog("Share Replay Button not available or not found", $COLOR_WARNING)
				Return
			EndIf
		Else
			SetLog("Error checking/opening attack log tab!", $COLOR_ERROR)
			Return
		EndIf
	Else
		SetLog("Error opening Messages Window!", $COLOR_ERROR)
		Return
	EndIf

	ClickAway()
EndFunc   ;==>ReplayShare
