; #FUNCTION# ====================================================================================================================
; Name ..........: Chatbot
; Description ...:
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........:
; Modified ......: Boludoz (12-3-2018) (based on ClashGameBot mod)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ---
; ===============================================================================================================================
#include <WinAPIEx.au3>

Global Const $DELAYCHATACTIONS1 = 100
Global Const $DELAYCHATACTIONS2 = 250
Global Const $DELAYCHATACTIONS3 = 500
Global Const $DELAYCHATACTIONS4 = 750
Global Const $DELAYCHATACTIONS5 = 1000
Global Const $DELAYCHATACTIONS6 = 1250
Global Const $DELAYCHATACTIONS7 = 1500

Func DelayTime($chatType)
	Local $sDateTimeDiffOfLastMsgInMin, $sDateTimeDiffOfLastMsgInSec
	Local $hour = 0, $min = 0, $sec = 0
	Local $aHour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
	If Not $g_abFriendlyChallengeHours[$aHour[0]] Then
		SetLog("ChatActions not planned, Skipped..", $COLOR_INFO)
		Return False
	EndIf

	Switch $chatType
		Case "CLAN"
			If $g_sClanChatLastMsgSentTime = "" Then Return True ;If ClanLastMsgSentTime sent time is empty means it's first time sms allow it

			$sDateTimeDiffOfLastMsgInMin = _DateDiff("s", $g_sClanChatLastMsgSentTime, _NowCalc()) / 60     ;For getting float value of minutes(s) we divided the diffsec by 60
			SetDebugLog("$g_iTxtDelayTimeClan = " & $g_sDelayTimeClan)
			SetDebugLog("$g_sClanChatLastMsgSentTime = " & $g_sClanChatLastMsgSentTime & ", $sDateTimeDiffOfLastMsgInMin = " & $sDateTimeDiffOfLastMsgInMin)
			If $sDateTimeDiffOfLastMsgInMin > $g_sDelayTimeClan Then     ;If ClanLastMsgSentTime sent time is empty means it's first time sms
				Return True
			Else
				$sDateTimeDiffOfLastMsgInSec = _DateDiff("s", _NowCalc(), _DateAdd('n', $g_sDelayTimeClan, $g_sClanChatLastMsgSentTime))
				SetDebugLog("$sDateTimeDiffOfLastMsgInSec = " & $sDateTimeDiffOfLastMsgInSec)
				_TicksToTime($sDateTimeDiffOfLastMsgInSec * 1000, $hour, $min, $sec)

				SetLog("Chatbot: Skip Sending Chats to Clan Chat", $COLOR_INFO)
				SetLog("Delay Time " & StringFormat("%02i:%02i:%02i", $hour, $min, $sec) & " left before sending new msg.", $COLOR_INFO)
				Return False
			EndIf
		Case "FC"
			If $g_sFCLastMsgSentTime = "" Then Return True ;If ClanLastMsgSentTime sent time is empty means it's first time sms allow it

			$sDateTimeDiffOfLastMsgInMin = _DateDiff("s", $g_sFCLastMsgSentTime, _NowCalc()) / 60     ;For getting float value of minutes(s) we divided the diffsec by 60
			SetDebugLog("$g_iTxtDelayTimeFC = " & $g_sDelayTimeFC)
			SetDebugLog("$g_sFCLastMsgSentTime = " & $g_sFCLastMsgSentTime & ", $sDateTimeDiffOfLastMsgInMin = " & $sDateTimeDiffOfLastMsgInMin)
			If $sDateTimeDiffOfLastMsgInMin > $g_sDelayTimeFC Then     ;If ClanLastMsgSentTime sent time is empty means it's first time sms
				Return True
			Else
				$sDateTimeDiffOfLastMsgInSec = _DateDiff("s", _NowCalc(), _DateAdd('n', $g_sDelayTimeFC, $g_sFCLastMsgSentTime))
				SetDebugLog("$sDateTimeDiffOfLastMsgInSec = " & $sDateTimeDiffOfLastMsgInSec)
				_TicksToTime($sDateTimeDiffOfLastMsgInSec * 1000, $hour, $min, $sec)

				SetLog("Chatbot: Skip Sending Chats to Friendly Challenge", $COLOR_INFO)
				SetLog("Delay Time " & StringFormat("%02i:%02i:%02i", $hour, $min, $sec) & " left before sending new challenge.", $COLOR_INFO)
				Return False
			EndIf
	EndSwitch
EndFunc   ;==>DelayTime

Func ClanGamesChatOnly()
	
	If $g_bChatClan = True And $g_bChkHarangueCG = True And $g_bIsCaravanOn == "True" Then
		Return True
	EndIf
	
	Return $g_bChatClan
EndFunc   ;==>ClanGamesChatOnly

Func ChatActions() ; run the chatbot
	
	If IsMainPage(5) Then
		
		If $g_bIsCaravanOn == "Undefined" And $g_bChkHarangueCG = True Then
			IsClanGamesWindow(True, True)
		EndIf
		
		If ClanGamesChatOnly() Or (($g_bEnableFriendlyChallenge) And (Not $g_bStayOnBuilderBase)) Then
			
			Local $bChat = (Random($g_iCmbPriorityCHAT, 5, 1) > 4), $bFriendly = (Random($g_iCmbPriorityFC, 5, 1) > 4)
			If $bChat = False And $bFriendly = False Then Return
			
			Local $bAlreadyOpen = False
			Local $iRandom = Random(0, 1, 1)
			For $i = 0 To 1
				Switch $iRandom
					Case 0
						$iRandom = 1
						
						If $bChat = False Or ClanGamesChatOnly() = False Then ContinueLoop
						
						If $g_sDelayTimeClan > 0 Then
							If DelayTime("CLAN") Then
								$g_sClanChatLastMsgSentTime = _NowCalc() ;Store msg sent time
							Else
								ContinueLoop
							EndIf
						EndIf
						
						If $bAlreadyOpen = False Then $bAlreadyOpen = OpenClanChat()
						If $bAlreadyOpen = False Then ExitLoop
						ChatClan()
						
					Case 1
						$iRandom = 0
						
						If $bFriendly = False Or $g_bEnableFriendlyChallenge = False Then ContinueLoop
	
						If $g_sDelayTimeFC > 0 Then
							If DelayTime("FC") Then
								$g_sFCLastMsgSentTime = _NowCalc() ;Store msg sent time
							Else
								ContinueLoop
							EndIf
						EndIf
						If $bAlreadyOpen = False Then $bAlreadyOpen = OpenClanChat()
						If $bAlreadyOpen = False Then ExitLoop
						FriendlyChallenge()
				EndSwitch
			Next
	
			If Not CloseClanChat() Then
				Setlog("ChatActions : CloseClanChat Error.", $COLOR_ERROR)
				AndroidPageError("ChatActions")
				Return False
			Else
				SetLog("ChatActions: Clan Chatting Done", $COLOR_SUCCESS)
			EndIf
			
			CloseClanChat()
		EndIf
	EndIf
	
EndFunc   ;==>ChatActions

Func ChatClan() ; Handle Clan Chat Logic
	If Not ClanGamesChatOnly() Then Return
	SetLog("Chatbot: Sending Chats To Clan", $COLOR_INFO)
	If Not ChatbotCheckIfUserIsInClan() Then Return False
	Local $bSentClanChat = False
	If _Sleep(2000) Then Return
	
	If $ChatbotReadQueued Then
		ChatbotNotifySendChat()
		$ChatbotReadQueued = False
		$bSentClanChat = True
	ElseIf $ChatbotIsOnInterval Then
		If ChatbotIsInterval() Then
			ChatbotStartTimer()
			ChatbotNotifySendChat()
			$bSentClanChat = True
		EndIf
	EndIf

	If UBound($ChatbotQueuedChats) > 0 Then
		SetLog("Chatbot: Sending Notify Chats", $COLOR_SUCCESS)

		For $a = 0 To UBound($ChatbotQueuedChats) - 1
			Local $ChatToSend = $ChatbotQueuedChats[$a]
			If Not ChatbotSelectChatInput("Clan") Then Return False
			If Not ChatbotChatInput(_Encoding_JavaUnicodeDecode($ChatToSend)) Then Return False
			If Not ChatbotSendChat("Clan") Then Return False
		Next

		Local $aTmp[0]     ; clear queue
		$ChatbotQueuedChats = $aTmp
		If _Sleep(2000) Then Return
		ChatbotNotifySendChat()

		Return False
	EndIf

	Local $bIsLast = ChatbotIsLastChatNew()
	If Not $bIsLast Then
		; get text of the latest message
		Local $sOCRString = -1, $sCondition = ""

		For $iRespInt = 0 To UBound($g_aClanResponses) - 1
			If $iRespInt = 0 Then
				$sCondition &= $g_aClanResponses[$iRespInt][0]
			Else
				$sCondition &= "|" & $g_aClanResponses[$iRespInt][0]
			EndIf
		Next

		$sOCRString = ReadChatIA($sCondition, True)

		SetDebugLog("ChatActions : Condition " & $sCondition)

		Local $bSentMessage = False
		If $sOCRString = -1 Then
			If $g_bClanUseGeneric Then
				If Not ChatbotSelectChatInput("Clan") Then Return False
				If Not ChatbotChatInput($g_aClanGeneric[Random(0, UBound($g_aClanGeneric) - 1, 1)]) Then Return False
				If Not ChatbotSendChat("Clan") Then Return False
				$bSentMessage = True
			EndIf
		EndIf

		If $sOCRString <> -1 And $g_bClanUseResponses And Not $bSentMessage Then
			For $a = 0 To UBound($g_aClanResponses) - 1
				If StringInStr($g_aClanResponses[$iRespInt - 1][0], $g_aClanResponses[$a][0]) Then
					Local $sResponse = $g_aClanResponses[$a][1]
					SetLog("Sending Response : " & $sResponse, $COLOR_SUCCESS)
					If Not ChatbotSelectChatInput("Clan") Then Return False
					If Not ChatbotChatInput($sResponse) Then Return False
					If Not ChatbotSendChat("Clan") Then Return False
					$bSentMessage = True
					Return True
				EndIf
			Next
		EndIf
		
		#cs
		If $g_bCleverbot And Not $bSentMessage Then
			Local $sResponse = runHelper($sOCRString)
			If $sResponse = False Or StringStripWS($sOCRString, $STR_STRIPALL) <> "" Then
				SetLog("Got Cleverbot Response : " & $sResponse, $COLOR_SUCCESS)
				If Not ChatbotSelectChatInput("Clan") Then Return False
				If Not ChatbotChatInput($sResponse) Then Return False
				If Not ChatbotSendChat("Clan") Then Return False
				$bSentMessage = True
			EndIf
		EndIf
		#Ce
		
		If Not $bSentMessage Then
			If $g_bClanUseGeneric Then
				If Not ChatbotSelectChatInput("Clan") Then Return False
				If Not ChatbotChatInput($g_aClanGeneric[Random(0, UBound($g_aClanGeneric) - 1, 1)]) Then Return False
				If Not ChatbotSendChat("Clan") Then Return False
			EndIf
		EndIf

		; send it via Notify if it's new
		; putting the code here makes sure the (cleverbot, specifically) response is sent as well :P
		If $g_bUseNotify And $g_bPbSendNew Then
			If Not $bSentClanChat Then ChatbotNotifySendChat()
		EndIf
	ElseIf $g_bClanUseGeneric And Not $bIsLast Then
		If Not ChatbotSelectChatInput("Clan") Then Return False
		If Not ChatbotChatInput($g_sClanGeneric[Random(0, UBound($g_sClanGeneric) - 1, 1)]) Then Return False
		If Not ChatbotSendChat("Clan") Then Return False
	ElseIf $bIsLast Then
		SetLog("ChatActions : The last chat is own, prevents floods.", $COLOR_INFO)
	EndIf

	Return True
EndFunc   ;==>ChatClan

Func OpenClanChat($iDelay = 200, $bIUnders = True)
	SetDebugLog("ChatBot|Begin OpenClanChat", $COLOR_DEBUG)
	Local $aiButton = 0
	For $i = 0 To 2
		Local $aiButton = findButton("ClanChat", Default, 1, True)
		If IsArray($aiButton) And UBound($aiButton) >= 2 Then
			If $aiButton[0] < 150 Then ClickP($aiButton, 1)
			If $bIUnders And UnderstandChatRules() = True Then SetDebugLog("ChatBot|UnderstandChatRules", $COLOR_DEBUG) ; December Update(2018)
			If RandomSleep(1500) Then Return
			Return True
		Else
			ClickAway(Default, True) ; ClickP($aAway2, 1, 0, "#0176")
		EndIf

		If RandomSleep(250) Then Return
	Next
	Return False
EndFunc   ;==>OpenClanChat

Func CloseClanChat($iDelay = 200) ; close chat area
	SetDebugLog("ChatBot|Begin CloseClanChat", $COLOR_DEBUG)
	Local $aiButton = 0
	For $i = 0 To 2
		Local $aiButton = findButton("ClanChat", Default, 1, True)
		If IsArray($aiButton) And UBound($aiButton) >= 2 Then
			If $aiButton[0] > 150 Then
				ClickP($aiButton, 1)
				Return True
			Else
				Return True
			EndIf
		Else
			CloseXDonate()
		EndIf

		If RandomSleep(100) Then Return
	Next
	Return False
EndFunc   ;==>CloseClanChat

Func CloseXDonate() ; Custom fix - Team__AiO__MOD
	Return ButtonClickDM(@ScriptDir & "\COCBot\Team__AiO__MOD++\Bundles\Button\XClan\", 521, 1, 338, 644)
EndFunc   ;==>CloseXDonate

Func ChatbotCheckIfUserIsInClan() ; check if user is in a clan before doing chat
	If Not _CheckPixel($aClanBadgeNoClan, $g_bCapturePixel, Default, "Clan Badge No Clan:") Then
		Return True
	Else
		SetLog("Chatbot: Sorry, You Are Not In A Clan You Can't Chat.", $COLOR_ERROR)
		Return False
	EndIf
EndFunc   ;==>ChatbotCheckIfUserIsInClan

Func ChatbotSelectChatInput($fromTab) ; select the textbox for Global chat or Clan Chat
	SetDebugLog("ChatBot|Begin ChatbotSelectChatInput", $COLOR_DEBUG)

	Click($aChatSelectTextBox[0], $aChatSelectTextBox[1], 1, 0, "SelectTextBoxBtn")
	If _Sleep($DELAYCHATACTIONS2) Then Return
	If _WaitForCheckPixel($aOpenedChatSelectTextBox, $g_bCapturePixel, Default, "Wait for Chat Select Text Box:") Then
		SetDebugLog("Chatbot: " & $fromTab & " Chat TextBox Appeared.", $COLOR_INFO)
		Return True
	Else
		SetDebugLog("Chatbot: Not find $aOpenedChatSelectTextBox in " & $fromTab & "|Pixel was:" & _GetPixelColor($aOpenedChatSelectTextBox[0], $aOpenedChatSelectTextBox[1], True), $COLOR_ERROR)
		If _WaitForCheckPixel($aChatRules, $g_bCapturePixel, Default, "Wait for Chat Rules:") Then
			ClickP($aChatRules, 1, 0, "#ChatRulesBtn")
			If _Sleep($DELAYCHATACTIONS2) Then Return
			Return ChatbotSelectChatInput($fromTab)
		EndIf
		Return False
	EndIf
	SetDebugLog("ChatBot|ChatbotSelectChatInput Finished", $COLOR_DEBUG)
EndFunc   ;==>ChatbotSelectChatInput

Func ChatbotChatInput($g_sMessage)
	SetDebugLog("ChatBot|Begin ChatbotChatInput", $COLOR_DEBUG)

	SetLog("Chatbot: Type msg : " & $g_sMessage, $COLOR_SUCCESS)
	Click($aOpenedChatSelectTextBox[0], $aOpenedChatSelectTextBox[1], 1, 0, "ChatInput")
	If _Sleep($DELAYCHATACTIONS5) Then Return
;~ 	If $g_bRusLang Then
;~ 		SetLog("Chat Send In Russia", $COLOR_INFO)
;~ 		AutoItWinSetTitle('MyAutoItTitle')
;~ 		_WinAPI_SetKeyboardLayout(WinGetHandle(AutoItWinGetTitle()), 0x0419)
;~ 		_Sleep($DELAYCHATACTIONS3)
;~ 		ControlFocus($g_hAndroidWindow, "", "")
;~ 		SendKeepActive($g_hAndroidWindow)
;~ 		_Sleep($DELAYCHATACTIONS3)
;~ 		AutoItSetOption("SendKeyDelay", 50)
;~ 		_SendExEx($g_sMessage)
;~ 		SendKeepActive("")
;~ 	Else
	_Sleep($DELAYCHATACTIONS3)
	SendText($g_sMessage)
;~ 	EndIf
	Return True
	SetDebugLog("ChatBot|ChatbotChatInput Finished", $COLOR_DEBUG)
EndFunc   ;==>ChatbotChatInput

Func ChatbotSendChat($fromTab) ; click send for global or clan chat
	SetDebugLog("ChatBot|Begin ChatbotSendChat", $COLOR_DEBUG)

	If _CheckPixel($aChatSendBtn, $g_bCapturePixel, Default, "Chat Send (" & $fromTab & ") Btn:") Then
		Click($aChatSendBtn[0], $aChatSendBtn[1], 1, 0, "ChatSendBtn") ; send
		If _Sleep($DELAYCHATACTIONS5) Then Return
		Return True
	Else
		SetDebugLog("Chatbot: Not find $aChatSendBtn in " & $fromTab & "|Pixel was:" & _GetPixelColor($aChatSendBtn[0], $aChatSendBtn[1], True), $COLOR_ERROR)
		Return False
	EndIf
	SetDebugLog("ChatBot|ChatbotSendChat Finished", $COLOR_DEBUG)
EndFunc   ;==>ChatbotSendChat

Func ChatbotIsLastChatNew() ; returns true if the last chat was not by you, false otherwise
	_CaptureRegion()
	For $x = 38 To 261
		If _ColorCheck(_GetPixelColor($x, 129 + $g_iMidOffsetYFixed, False), Hex(0x78BC10, 6), 5) Then Return True ; detect the green menu button
	Next
	Return False
EndFunc   ;==>ChatbotIsLastChatNew

Func ChatbotNotifySendChat()
	If Not $g_bUseNotify Then Return

	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	_CaptureRegion(0, 0, 320, 675)
	Local $ChatFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
	_GDIPlus_ImageSaveToFile($g_hBitmap, $g_sProfileLootsPath & $ChatFile)
	_GDIPlus_ImageDispose($g_hBitmap)
	;push the file
	SetLog("Chatbot: Sent chat image", $COLOR_SUCCESS)
	NotifyPushFileToTelegram($ChatFile, "Loots", "image/jpeg", $g_sNotifyOrigin & " | Last Clan Chats" & "\n" & $ChatFile)
	;wait a second and then delete the file
	If _Sleep($DELAYPUSHMSG2) Then Return
	Local $iDelete = FileDelete($g_sProfileLootsPath & $ChatFile)
	If Not ($iDelete) Then SetLog("Chatbot: Failed to delete temp file", $COLOR_ERROR)
EndFunc   ;==>ChatbotNotifySendChat

Func ChatbotStartTimer()
	$ChatbotStartTime = TimerInit()
EndFunc   ;==>ChatbotStartTimer

Func ChatbotIsInterval()
	Local $Time_Difference = TimerDiff($ChatbotStartTime)
	If $Time_Difference > $ChatbotReadInterval * 1000 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>ChatbotIsInterval

Func ChatbotNotifyQueueChat($Chat)
	If Not $g_bUseNotify Then Return
	_ArrayAdd($ChatbotQueuedChats, $Chat)
EndFunc   ;==>ChatbotNotifyQueueChat

Func ChatbotNotifyQueueChatRead()
	If Not $g_bUseNotify Then Return
	$ChatbotReadQueued = True
EndFunc   ;==>ChatbotNotifyQueueChatRead

Func ChatbotNotifyStopChatRead()
	If Not $g_bUseNotify Then Return
	$ChatbotReadInterval = 0
	$ChatbotIsOnInterval = False
EndFunc   ;==>ChatbotNotifyStopChatRead

Func ChatbotNotifyIntervalChatRead($Interval)
	If Not $g_bUseNotify Then Return
	$ChatbotReadInterval = $Interval
	$ChatbotIsOnInterval = True
	ChatbotStartTimer()
EndFunc   ;==>ChatbotNotifyIntervalChatRead

Func ChatbotSettingOpen() ; Open the Settings
	SetDebugLog("ChatBot|Begin ChatbotSettingOpen", $COLOR_DEBUG)

	ClickAway() ; ClickP($aAway2, 1, 0, "#0176") ;Click Away to prevent any pages on top
	ForceCaptureRegion()
	If _Sleep($DELAYCHATACTIONS2) Then Return
	If Not _CheckPixel($aIsSettingPage, $g_bCapturePixel) Then
		Click($aButtonSetting[0], $aButtonSetting[1], 1, 0, "OpenSettingBtn")
		If _Sleep($DELAYCHATACTIONS2) Then Return
		If _WaitForCheckPixel($aIsSettingPage, $g_bCapturePixel, Default, "Wait for Setting Page:") Then
			SetDebugLog("Chatbot: Main Settings Opened.", $COLOR_SUCCESS)
			Return True
		Else
			SetDebugLog("Chatbot: Not find $aIsSettingPage|Pixel was:" & _GetPixelColor($aIsSettingPage[0], $aIsSettingPage[1], True), $COLOR_ERROR)
			Return False
		EndIf
	EndIf
	SetDebugLog("ChatBot|ChatbotSettingOpen Finished", $COLOR_DEBUG)
EndFunc   ;==>ChatbotSettingOpen

Func ChatbotSettingClose() ; close settings
	SetDebugLog("ChatBot|Begin ChatbotSettingClose", $COLOR_DEBUG)

	If _WaitForCheckPixel($aIsSettingPage, $g_bCapturePixel, Default, "Wait for Close Setting Btn:") Then
		Click($aIsSettingPage[0], $aIsSettingPage[1], 1, 0, "#CloseChatBtn") ; close chat
		If _Sleep($DELAYCHATACTIONS2) Then Return
		SetDebugLog("Chatbot: Close Language Settings Window..", $COLOR_INFO)
		Return True
	Else
		SetDebugLog("Chatbot: Error in $aIsSettingPage|Pixel was:" & _GetPixelColor($aIsSettingPage[0], $aIsSettingPage[1], True), $COLOR_ERROR)
		Return False
	EndIf
	SetDebugLog("ChatBot|ChatbotSettingClose Finished", $COLOR_DEBUG)
EndFunc   ;==>ChatbotSettingClose

Func ChatbotClickLanguageButton() ; Click on language button in settings
	SetDebugLog("ChatBot|Begin ChatbotClickLanguageButton", $COLOR_DEBUG)

	Click($aSelectLangBtn[0], $aSelectLangBtn[1], 1, 0, "SelectLanguageBtn") ; Click on language button in settings
	If _Sleep($DELAYCHATACTIONS2) Then Return
	If _WaitForCheckPixel($aOpenedSelectLang, $g_bCapturePixel, Default, "Wait for Select Language Page:") Then
		SetDebugLog("Chatbot: Language Settings Opened", $COLOR_SUCCESS)
		Return True
	Else
		SetDebugLog("Chatbot: Not find $aOpenedSelectLang|Pixel was:" & _GetPixelColor($aOpenedSelectLang[0], $aOpenedSelectLang[1], True), $COLOR_ERROR)
		Return False
	EndIf
	SetDebugLog("ChatBot|ChatbotClickLanguageButton Finished", $COLOR_DEBUG)
EndFunc   ;==>ChatbotClickLanguageButton

; Returns the response from cleverbot or simsimi, if any
#cs
Func runHelper($sMsg) ; run a script to get a response from cleverbot.com or simsimi.com
	Local $sCommand, $sDOS, $tHelperStartTime, $tTime_Difference
	Static $sMessage = ''

	$sCommand = ' /c "ModLibs\phantomjs.exe "ModLibs\phantom-cleverbot-helper.js" '

	$sDOS = Run(@ComSpec & $sCommand & $sMsg & '"', "", @SW_HIDE, 8)
	$tHelperStartTime = TimerInit()
	SetLog("Waiting for chatbot helper...")
	While ProcessExists($sDOS)
		ProcessWaitClose($sDOS, 10)
		SetLog("Still waiting for chatbot helper...")
		$tTime_Difference = TimerDiff($tHelperStartTime)
		If $tTime_Difference > 50000 Then
			SetLog("Chatbot helper is taking too long!", $COLOR_RED)
			ProcessClose($sDOS)
			_RunDos("taskkill -f -im phantomjs.exe") ; force kill
			Return ""
		EndIf
	WEnd
	$sMessage = ''
	While 1
		$sMessage &= StdoutRead($sDOS)
		If @error Then ExitLoop
	WEnd
	Return StringStripWS($sMessage, 7)
EndFunc   ;==>runHelper
#ce
Func _Encoding_JavaUnicodeDecode($sString)
	Local $iOld_Opt_EVS = Opt('ExpandVarStrings', 0)
	Local $iOld_Opt_EES = Opt('ExpandEnvStrings', 0)

	Local $sOut = "", $aString = StringRegExp($sString, "(\\\\|\\'|\\u[[:xdigit:]]{4}|[[:ascii:]])", 3)

	For $i = 0 To UBound($aString) - 1
		Switch StringLen($aString[$i])
			Case 1
				$sOut &= $aString[$i]
			Case 2
				$sOut &= StringRight($aString[$i], 1)
			Case 6
				$sOut &= ChrW(Dec(StringRight($aString[$i], 4)))
		EndSwitch
	Next

	Opt('ExpandVarStrings', $iOld_Opt_EVS)
	Opt('ExpandEnvStrings', $iOld_Opt_EES)

	Return $sOut
EndFunc   ;==>_Encoding_JavaUnicodeDecode

Func _StringRemoveBlanksFromSplit($strMsg) ;Remove empty string pipes from string e.g |Test||Hey all| becomes Test|Hey all (Using in Chat to avoid empty messages)
	Local $strArray = StringSplit($strMsg, "|", 2)
	$strMsg = ""

	For $i = 0 To (UBound($strArray) - 1)
		If $strArray[$i] <> "" Then
			$strMsg = $strMsg & $strArray[$i] & "|"
		EndIf
	Next
	If ($strMsg <> "") Then $strMsg = StringTrimRight($strMsg, 1) ;Remove last extra pipe from string
	Return $strMsg
EndFunc   ;==>_StringRemoveBlanksFromSplit

Func FriendlyChallenge()

	Local $aBaseForShare[0][2]
	Local $iCount4Share
	For $i = 0 To 5
		Local $bIAdd[1][2] = [[$i, $g_bFriendlyChallengeBase[$i]]]
		_ArrayAdd($aBaseForShare, $bIAdd)
		If $g_bFriendlyChallengeBase[$i] Then $iCount4Share += 1
	Next
	If $iCount4Share = 0 Then
		SetLog("No base to share for friend challenge, please check your setting.", $COLOR_ERROR)
		Return
	Else
		_ArrayShuffle($aBaseForShare)
	EndIf

	ClickAway() ; ClickP($aAway2, 1, 0, "#0176") ;Click Away
	Setlog("Checking Friendly Challenge at Clan Chat", $COLOR_INFO)

	If Not OpenClanChat() Then ; GTFO - Team AIO Mod++
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf


	Local $bDoFriendlyChallenge = False
	Local $sOCRString = -1, $iRequested, $iTempR

	If $g_bOnlyOnRequest Then
		$sOCRString = ReadChatIA($g_sKeywordFcRequest, True)
		If $sOCRString <> -1 Then
			$bDoFriendlyChallenge = True
			$iTempR = Number(StringReverse($sOCRString))
			$iRequested = ($iTempR > 0 And $iTempR < 7) ? ($iTempR - 1) : (-1)
			If $iRequested <> -1 Then
				For $i = 0 To UBound($aBaseForShare) - 1
					If $aBaseForShare[$i][0] = $iRequested And $aBaseForShare[$i][1] = True Then
						_ArrayDelete($aBaseForShare, $i)
						Local $iTempFix = $g_bFriendlyChallengeBase[$i]
						Local $bIAdd[1][2] = [[$iRequested, $iTempFix]]
						_ArrayInsert($aBaseForShare, 0, $bIAdd)
						SetLog("User request challenge base: " & $iRequested, $COLOR_INFO)
						ExitLoop
					EndIf
				Next
			Else
				SetLog("Prepare for select random base", $COLOR_INFO)
			EndIf
		EndIf
	Else
		$bDoFriendlyChallenge = True
	EndIf

	Local $bIsBtnStartOk = False
	If $bDoFriendlyChallenge Then
		If _WaitForCheckPixel($aButtonFriendlyChallenge, $g_bCapturePixel, Default, "Wait for FC Btn:") Then
			Click($aButtonFriendlyChallenge[0], $aButtonFriendlyChallenge[1], 1, 0, "#BtnFC")
			If _WaitForCheckPixel($aButtonFCChangeLayout, $g_bCapturePixel, Default, "Wait for FCCL Btn:") Then
				Click($aButtonFCChangeLayout[0], $aButtonFCChangeLayout[1], 1, 0, "#BtnFCCL")
				If _WaitForCheckPixel($aButtonFCBack, $g_bCapturePixel, Default, "Wait for FC Back:") Then
					If RandomBaseIfNot($aBaseForShare) Then
						If _WaitForCheckPixel($aButtonFCStart, $g_bCapturePixel, Default, "Wait for FC Start:") Then
							If $g_sChallengeText <> "" Then
								Click(Random(440, 620, 1), Random(165, 185, 1))
								If _Sleep($DELAYCHATACTIONS1) Then Return False
								Local $asText = StringSplit($g_sChallengeText, "|", BitOR($STR_ENTIRESPLIT, $STR_NOCOUNT))
								If IsArray($asText) Then
									Local $sText4Send = $asText[Random(0, UBound($asText) - 1, 1)]
									SetLog("Send text: " & $sText4Send, $COLOR_DEBUG)
									If $g_bChkBackgroundMode = False And $g_bNoFocusTampering = False Then ControlFocus($g_hAndroidWindow, "", "")
									If SendText($sText4Send) = 0 Then
										Setlog("Challenge text entry failed!", $COLOR_ERROR)
									EndIf
								EndIf
								If _Sleep($DELAYCHATACTIONS2) Then Return
							EndIf
							If _WaitForCheckPixel($aButtonFCStart, $g_bCapturePixel, Default, "Wait for FC Start:") Then $bIsBtnStartOk = True
							If _Sleep($DELAYCHATACTIONS2) Then Return

							If $bIsBtnStartOk = True Then
								Click($aButtonFCStart[0], $aButtonFCStart[1], 1, 0, "#BtnFCStart")
								SetLog("Friendly Challenge Shared.", $COLOR_INFO)
								Return True
							EndIf
						Else
							SetLog("Cannot find friendly challenge start button. Maybe the base cannot be select.", $COLOR_ERROR)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	Return False

EndFunc   ;==>FriendlyChallenge

Func RandomBaseIfNot($aBaseForShare)

	; Profile entity diff.
	Local Static $asLastTimeChecked[$g_eTotalAcc] = ["", "", "", "", "", "", "", ""]

	If _Sleep($DELAYCHATACTIONS3) Then Return
	For $i = 0 To UBound($aBaseForShare) - 1
		If $aBaseForShare[$i][1] <> True Or (StringInStr($asLastTimeChecked[$g_iCurAccount], $aBaseForShare[$i][0]) > 0) Then ContinueLoop ; Check obstacles or if base is unchecked.
		Setlog("Friendly Challenge : Sharing base " & $aBaseForShare[$i][0] + 1 & ".", $COLOR_ACTION)
		If CheckNeedSwipeFriendlyChallengeBase($aBaseForShare[$i][0]) = True Then
			Return True
		Else
			$asLastTimeChecked[$g_iCurAccount] &= " " & $aBaseForShare[$i][0]
			Setlog("Friendly Challenge : The base has obstacles, it will not be taken into account until you correct it and restart the bot or change account.", $COLOR_INFO)
		EndIf
		If _Sleep($DELAYCHATACTIONS3) Then Return
	Next

	Setlog("Friendly Challenge : No base for share.", $COLOR_ERROR)
	Return False
EndFunc   ;==>RandomBaseIfNot

Func CheckNeedSwipeFriendlyChallengeBase($iBaseSlot)
	If _Sleep($DELAYCHATACTIONS1) Then Return False
	Local $aMeasures[3] = ["148, 136, 330, 256", "330, 136, 518, 256", "516, 136, 712, 256"] ; Resolution changed
	Local $aClick[3][2] = [[250, 245 + $g_iMidOffsetYFixed], [435, 235 + $g_iMidOffsetYFixed], [595, 226 + $g_iMidOffsetYFixed]] ; Resolution changed

	; check need swipe
	Local $iSwipeNum = 2
	Local $iCount = 0
	If $iBaseSlot > $iSwipeNum Then
		$iCount = 0
		While Not _ColorCheck(_GetPixelColor(712, 295 + $g_iMidOffsetYFixed, True), Hex(0XD3D3CB, 6), 10) ; Resolution changed
			ClickDrag(700, 250 + $g_iMidOffsetYFixed, 150, 250 + $g_iMidOffsetYFixed, 250) ; Resolution changed
			If _Sleep($DELAYCHATACTIONS2) Then Return False
			$iCount += 1
			If $iCount > 3 Then Return False
		WEnd
		$iBaseSlot -= 3
		If _Sleep($DELAYCHATACTIONS3) Then Return False
		If _ImageSearchXML($g_sImgChatObstacles, 1, $aMeasures[$iBaseSlot], True, False) = -1 Then
			Click($aClick[$iBaseSlot][0], $aClick[$iBaseSlot][1], 1, Random(500, 570, 1))
			Return True
		EndIf
	Else
		$iCount = 0
		While Not _ColorCheck(_GetPixelColor(146, 295 + $g_iMidOffsetYFixed, True), Hex(0XD3D3CB, 6), 15) ; Resolution changed
			ClickDrag(155, 250 + $g_iMidOffsetYFixed, 705, 250 + $g_iMidOffsetYFixed, 250) ; Resolution changed
			If _Sleep($DELAYCHATACTIONS2) Then Return False
			$iCount += 1
			If $iCount > 3 Then Return False
		WEnd
		If _Sleep($DELAYCHATACTIONS3) Then Return False
		If _ImageSearchXML($g_sImgChatObstacles, 1, $aMeasures[$iBaseSlot], True, False) = -1 Then
			Click($aClick[$iBaseSlot][0], $aClick[$iBaseSlot][1], 1, Random(500, 570, 1))
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>CheckNeedSwipeFriendlyChallengeBase

; #FUNCTION# ====================================================================================================================
; Name ..........: Chatbot Text read (#-23)
; Description ...: This file is all related to READ CHAT AI (Fast) | Samkie based
; Syntax ........:
; Parameters ....: ReadChat()
; Return values .: IF THE STATE = -1 CHAT TEXT IS RETURNED IN TEXT, ANOTHER BOOLEAN OF RETURN.
; Author ........: Boludoz/Boldina
; Modified ......: Boludoz (5/7/2018|17/7/2018|5/3/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ReadChat()
; ===============================================================================================================================
Func ReadChatIATest($sCondition = "porque", $bFast = True)
	Setlog(ReadChatIA($sCondition, $bFast))
EndFunc

Func ReadChatIA($sCondition = "hola", $bFast = True)
	Local $sResult = -1
	Local $asFCKeyword = ""
	Local $aiDonateButton = -1
	Local $aiSearchArray[4] = [200, 90 + $g_iMidOffsetYFixed, 300, 700 + $g_iMidOffsetYFixed]

	ScrollDown()

	If RandomSleep(500) Then Return

	_CaptureRegion2()
	Local $aChatY = findMultipleQuick(@ScriptDir & "\COCBot\Team__AiO__MOD++\Images\ChatActions\Chat", 11, "259, 20, 269, 589", False, Default, False, 0) ; Resolution changed

	If Not IsArray($aChatY) Then Return False

	_ArraySort($aChatY, 1, 0, 0, 2) ; rearrange order by coor Y

	For $y = 0 To UBound($aChatY) - 1

		Local $yFix = (UBound($aChatY) - 1 <> $y) ? ($aChatY[$y + 1][2]) : (680)
		$aiSearchArray[1] = _Min($yFix, $aChatY[$y][2])
		$aiSearchArray[3] = _Max($yFix, $aChatY[$y][2])
		; _ArrayDisplay($aiSearchArray)
		$aiDonateButton = decodeSingleCoord(findImage("Donate Button", $g_sImgDonateCC & "DonateButton*", GetDiamondFromArray($aiSearchArray), 1, False, Default))
		If UBound($aiDonateButton, 1) >= 2 And not @error Then
			ContinueLoop
		EndIf

		Local $Alphabets[4] = [$g_bChkExtraAlphabets, $g_bChkExtraChinese, $g_bChkExtraKorean, $g_bChkExtraPersian]
		Local $TextAlphabetsNames[4] = ["Cyrillic and Latin", "Chinese", "Korean", "Persian"]
		Local $AlphabetFunctions[4] = ["getChatString", "getChatStringChinese", "getChatStringKorean", "getChatStringPersian"]
		Local $BlankSpaces = "", $ClanString = ""
		For $i = 0 To UBound($Alphabets) - 1
			If $i = 0 Then
				; 75
				Local $coordinates[3] = [40, 53, 66] ; Extra coordinates for Latin (3 Lines)
				Local $OcrName = ($Alphabets[$i] = True) ? ("coc-latin-cyr") : ("coc-latinA")
				Local $slog = "Latin"
				If $Alphabets[$i] Then $slog = $TextAlphabetsNames[$i]
				$ClanString = ""
				SetLog("Using OCR to read ChatBox derived alphabets.", $COLOR_ACTION)
				For $j = 0 To 2
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString &= $BlankSpaces & getChatString(30, $aChatY[$y][2] + $coordinates[$j], $OcrName)
						If $g_bDebugSetlog = 1 Then
							SetDebugLog("$OcrName: " & $OcrName)
							SetDebugLog("$coordinates: " & $coordinates[$j])
							SetDebugLog("$ClanString: " & $ClanString)
							SetDebugLog("$j: " & $j)
						EndIf
						If $ClanString <> "" And $ClanString <> " " Then ExitLoop
					EndIf
					If $ClanString <> "" Then $BlankSpaces = " "
				Next
			Else
				Local $Yaxis[4] = [40, 36, 36, 39] ; "Latin", "Chinese", "Korean", "Persian"
				If $Alphabets[$i] Then
					If $ClanString = "" Or $ClanString = " " Then
						SetLog("Using OCR to read " & $TextAlphabetsNames[$i] & " alphabets.", $COLOR_ACTION)
						#Au3Stripper_Off
						$ClanString &= $BlankSpaces & Call($AlphabetFunctions[$i], 30, $aChatY[$y][1] + $Yaxis[$i])
						#Au3Stripper_On
						If @error = 0xDEAD And @extended = 0xBEEF Then SetLog("[FriendChallengeCC] Function " & $AlphabetFunctions[$i] & "() had a problem.")
						If $g_bDebugSetlog = 1 Then
							SetDebugLog("$OcrName: " & $OcrName)
							SetDebugLog("$Yaxis: " & $Yaxis[$i])
							SetDebugLog("$ClanString: " & $ClanString)
						EndIf
						If $ClanString <> "" And $ClanString <> " " Then ExitLoop
					EndIf
				EndIf
			EndIf

		Next

		If StringIsSpace($ClanString) Then ContinueLoop
		Local $sString = StringStripWS($ClanString, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)
		Setlog("Chat texts : " & $sString, $COLOR_SUCCESS)

		If CheckDonateString($sCondition, $sString) Then
			$sResult = $ClanString
			If $bFast = True Then
				Return $sResult
			EndIf
		EndIf

	Next

	Return $sResult ; IF THE STATE = -1 CHAT TEXT IS RETURNED IN TEXT, ANOTHER BOOLEAN OF RETURN
EndFunc   ;==>ReadChatIA

; #FUNCTION# ====================================================================================================================
; Name ..........: Multy Lang
; Description ...: Extended GUI Control Lang
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: by IMMOD
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func _SendExEx($sKeys, $iFlag = 0)
	If @KBLayout = "0419" Then
		Local $sANSI_Chars = "ёйцукенгшщзхъфывапролджэячсмитьбю.?"
		Local $sASCII_Chars = "`qwertyuiop[]asdfghjkl;'zxcvbnm,./&"

		Local $aSplit_Keys = StringSplit($sKeys, "")
		Local $sKey
		$sKeys = ""

		For $i = 1 To $aSplit_Keys[0]
			$sKey = StringMid($sANSI_Chars, StringInStr($sASCII_Chars, $aSplit_Keys[$i]), 1)

			If $sKey <> "" Then
				$sKeys &= $sKey
			Else
				$sKeys &= $aSplit_Keys[$i]
			EndIf
		Next
	EndIf
	Return Send($sKeys, $iFlag)
EndFunc   ;==>_SendExEx
