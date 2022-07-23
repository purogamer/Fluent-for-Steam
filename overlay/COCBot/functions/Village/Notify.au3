; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This function will notify events and allow remote control of your bot on your mobile phone
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Full revamp of Notify by IceCube (2016-09)
; Modified ......: IceCube (2016-12) v1.5.1, CodeSLinger69 (2017), ProMac 2018-08, Boldina ! (19/08/2021) (For AIO Mod++)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $TELEGRAM_URL = "https://api.telegram.org/bot"
Global Const $HTTP_STATUS_OK = 200


Func __WinHttpURLEncode($sData)
	Local $aData = StringToASCIIArray($sData, Default, Default, 2)
	Local $sOut
	For $i = 0 To UBound($aData) - 1
		Switch $aData[$i]
			Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
				$sOut &= Chr($aData[$i])
			Case 32
				$sOut &= "+"
			Case Else
				$sOut &= "%" & Hex($aData[$i], 2)
		EndSwitch
	Next
	Return $sOut
EndFunc   ;==>__WinHttpURLEncode

Func NotifyRemoteControl()
	SetDebugLog("Notify | NotifyRemoteControl()")
	If $g_bNotifyRemoteEnable = True Then NotifyRemoteControlProc()
EndFunc   ;==>NotifyRemoteControl

Func NotifyReport()
	SetDebugLog("Notify | NotifyReport()")
	If $g_bNotifyAlertVillageReport = True Or $g_bNotifyAlertVillageReportDS = True Then
		Local $text = $g_sNotifyOrigin & ":" & chr(10)
		$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & chr(10)
		$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & chr(10)
		$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & chr(10)
		$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootTrophy]) & chr(10)
		$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Free-Builders_Info_01", "No. of Free Builders") & "]: " & $g_iFreeBuilderCount & chr(10)
		
		
		If $g_abFullStorage[$eLootGold] = True Or $g_abFullStorage[$eLootElixir] = True Or $g_abFullStorage[$eLootDarkElixir] = True Or $g_abFullStorage[$eLootTrophy] = True Then
			$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Free-FullResources_Info_01", "Is Full Gold? ") & "]: " & String($g_abFullStorage[$eLootGold] = True) & chr(10)
			$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Free-FullResources_Info_02", "Is Full Elixir? ") & "]: " & String($g_abFullStorage[$eLootElixir] = True) & chr(10)
			$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Free-FullResources_Info_03", "Is Full Dark Elixir? ") & "]: " & String($g_abFullStorage[$eLootDarkElixir] = True) & chr(10)
			$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Free-FullResources_Info_04", "Is Full Trophies? ") & "]: " & String($g_abFullStorage[$eLootTrophy] = True) & chr(10)
		EndIf
		
		If $g_bNotifyAlertVillageReport = True Then NotifyPushToTelegram($text)
		If $g_bNotifyAlertVillageReportDS = True Then NotifyPushToDiscord($text)
	EndIf
	If $g_bNotifyAlertLastAttack = True Or $g_bNotifyAlertLastAttackDS = True Then
		If Not ($g_iStatsLastAttack[$eLootGold] = "" And $g_iStatsLastAttack[$eLootElixir] = "") Then
			Local $text = $g_sNotifyOrigin & ":" & chr(10)
			$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold])
			$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & chr(10)
			$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir])
			$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootTrophy])
			If $g_bNotifyAlertLastAttack = True Then NotifyPushToTelegram($text)
			If $g_bNotifyAlertLastAttackDS = True Then NotifyPushToDiscord($text)
		EndIf
	EndIf
	If _Sleep($DELAYNOTIFY1) Then Return
	; checkMainScreen(False)
EndFunc   ;==>NotifyReport

; GENERAL FUNCTION TO PUSH MSG
Func PushMsg($Message, $Source = "")
	SetDebugLog("Notify | PushMsg()")
	NotifyPushMessageToBoth($Message, $Source)
EndFunc   ;==>PushMsg

; EXECUTE NOTIFY PENDING ACTIONS
Func NotifyPendingActions()
	SetDebugLog("Notify | NotifyPendingActions()")
	If ($g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "") Then Return

	NotifyRemoteControl()

	If $g_bTGRequestScreenshot = True Then
		$g_bNotifyForced = True
		PushMsg("RequestScreenshot")
	EndIf
	
	If $g_bStayOnBuilderBase = True Then Return ; Custom BB - Team AIO Mod++

	If $g_bTGRequestBuilderInfo = True Then
		$g_bNotifyForced = True
		PushMsg("BuilderInfo")
	EndIf
	If $g_bTGRequestShieldInfo = True Then
		$g_bNotifyForced = True
		PushMsg("ShieldInfo")
	EndIf
	PushMsg("BuilderIdle")
EndFunc   ;==>NotifyPendingActions

; ONLY PUSH TELEGRAM MSG
Func NotifyPushToTelegram($pMessage)

	SetDebugLog("NotifyPushToTelegram(" & $pMessage & " ): ")

	If Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "" Then Return False

	If Not IsPlanUseTelegram($pMessage) Then Return False

	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then
		Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		Local $Time = @HOUR & ':' & @MIN

		Local $text = __WinHttpURLEncode($pMessage & chr(10) & $Date & ' ' & $Time)
		
		; Telegram Message
		Local $SdtOut = InetRead($TELEGRAM_URL & $g_sNotifyTGToken & "/sendMessage?chat_id=" & $g_sTGChatID & "&text=" & $text, $INET_FORCERELOAD)
		Local $eError = @error ; Save error - Custom fix - Team AIO Mod++
		
		SetDebugLog("Telegram sent msg:" & $TELEGRAM_URL & $g_sNotifyTGToken & "/sendMessage?chat_id=" & $g_sTGChatID & "&text=" & $text)
		SetDebugLog("NotifyPushToTelegram Send Return code:" & @error)
		;SetDebugLog("NotifyPushToTelegram Send Return SdtOut:" & $SdtOut)

		If $eError Or $SdtOut = "" Then Return False
		; Convert Binary to String/Json Format
		Local $sCorrectStdOut = BinaryToString($SdtOut, 4)
		If @error Or $sCorrectStdOut = "" Then Return False
		SetDebugLog("NotifyPushToTelegram Send Return msg:" & $sCorrectStdOut)
		; Json Format :
		; {"ok":true,"result":{"message_id":XXX,"from":{"id":XXXXXXX,"is_bot":true,"first_name":"TH12","username":"TH12bot"},"chat":{"id":XXXXXXX,"first_name":"XXXXX","username":"XXXXXX","type":"private"},"date":XXXXXXXX,"text":"XXXXXXX"}}
		; Parse message id from Json Format , just to confirm if all are ok
		Local $mdg = _StringBetween($sCorrectStdOut, '"message_id":', ',"from":')
		If @error Or Not IsArray($mdg) Then
			SetDebugLog("NotifyPushToTelegram Send Error!: " & $sCorrectStdOut)
			Return False
		EndIf
		SetDebugLog("Telegram last sent msg number is '" & $mdg[0] & "'")
		Return True
	EndIf
EndFunc   ;==>NotifyPushToTelegram

; ONLY PUSH TELEGRAM FILES
Func NotifyPushFileToTelegram($File, $Folder, $FileType, $body)

	SetDebugLog("Notify | NotifyPushFileToTelegram($File, $Folder, $FileType, $body): " & $File & "," & $Folder & "," & $FileType & "," & $body)

	If Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "" Then Return

	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then
		If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then

			; cURL Part , sending Images
			Local $sCmd = "/sendPhoto", $sCmd1 = "photo"
			; cURL Part , sending documents
			If $FileType = "text\/plain; charset=utf-8" Then
				$sCmd = "/sendDocument"
				$sCmd1 = "document"
			EndIf
			Local $FullTelegram_url = $TELEGRAM_URL & $g_sNotifyTGToken & $sCmd

			SetDebugLog("NotifyPushFileToTelegram(): " & $g_sCurlPath & " -i -X POST " & $FullTelegram_url & ' -F chat_id="' & $g_sTGChatID & '" -F ' & $sCmd1 & '=@"' & $g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File & '"')

			Local $Result = RunWait($g_sCurlPath & " -i -X POST " & $FullTelegram_url & ' -F chat_id="' & $g_sTGChatID & '" -F ' & $sCmd1 & '=@"' & $g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)

			; Telegram Message attached to file
			Local $SdtOut = InetRead($TELEGRAM_URL & $g_sNotifyTGToken & "/sendMessage?chat_id=" & $g_sTGChatID & "&text=" & $body, $INET_FORCERELOAD)
			If @error Or $SdtOut = "" Then Return
			; Convert Binary to String/Json Format
			Local $sCorrectStdOut = BinaryToString($SdtOut, 4)
			If @error Or $sCorrectStdOut = "" Then Return
			SetDebugLog("NotifyPushFileToTelegram(): " & $sCorrectStdOut)
			; Parse The Json Format
			Local $mdg = _StringBetween($sCorrectStdOut, '"message_id":', ',"from":')
			If @error Or Not IsArray($mdg) Then SetDebugLog("NotifyPushFileToTelegram Send Error!")
		Else
			SetLog("Notify Telegram: Unable to send file " & $File, $COLOR_ERROR)
			NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_03", "Unable to Upload File") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_02", "Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
EndFunc   ;==>NotifyPushFileToTelegram

; GET LAST MSG ID USED AT MainLoop()
Func NotifyGetLastMessageFromTelegram()
	SetDebugLog("Notify | NotifyGetLastMessageFromTelegram()")

	Local $TGLastMessage = ""
	If Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "" Then Return
	
	; Internet Check
	If _IsInternet() < 1 Then
		SetLog("Telegram: Check your internet connection! No Connection..", $COLOR_ERROR)
		Return
	EndIf

	If $TELEGRAM_URL = "https://api.telegram.org/bot" Then
		; AltProxy 
		Ping("telegram.org", 250)
		If @error = 4 Then
			Ping("herokuapp.com", 250)
			If @error = 2 Or not @error Then
				$TELEGRAM_URL = "https://tgproxy-m.herokuapp.com/bot"
				Setlog("Bypassing telegram firewall.", $COLOR_SUCCESS)
			EndIf
		EndIf
	EndIf
	
	; GetUpdates
	Local $SdtOut = InetRead($TELEGRAM_URL & $g_sNotifyTGToken & "/getUpdates", $INET_FORCERELOAD)
	If @error Or $SdtOut = "" Then Return
	; Convert Binary to String/Json Format
	; convert from Web UTF-8 to AutoIt native UTF-16
	Local $sCorrectStdOut = BinaryToString($SdtOut, 4)
	;convert \uxxxx to real word
	$sCorrectStdOut = Json_StringDecode($sCorrectStdOut)
	If @error Or $sCorrectStdOut = "" Then Return
	SetDebugLog("Notify | getUpdates(): " & $sCorrectStdOut)
	; Parse user_id from Json Format
	Local $chat_id = _StringBetween($sCorrectStdOut, 'from":{"id":', ',"is_bot":')
	If @error Or Not IsArray($chat_id) Then Return
	; THIS IS SUPER IMPORTANT is the 'user_id' , the 'contact' to send the pushes!! the bot can't send nothing without this number , don't know who is the 'receptor'!
	; The $g_sTGChatID Will be save on ini file
	If $g_sTGChatID = "" Or $g_sTGChatID <> $chat_id[0] Then
		$g_sTGChatID = $chat_id[0]
		SaveConfig_600_18()
		SetDebugLog("Saved a new Chat_ID/User_ID for Telegram as " & $g_sTGChatID)
	Else
		SetDebugLog("Telegram Chat_ID/User_ID:" & $g_sTGChatID)
	EndIf
	; Parse update_id from Json Format
	Local $uid = _StringBetween($sCorrectStdOut, '"update_id":', ',') ;take update id
	If @error Or Not IsArray($uid) Then Return
	SetDebugLog("You have " & UBound($uid) & " update_id to confirm!")
	$g_sTGLast_UID = $uid[UBound($uid) - 1]
	SetDebugLog("Telegram getting update_ID: " & $g_sTGLast_UID)
	SetDebugLog("Telegram last update_id was: " & $g_iTGLastRemote)

	; To confirm the last update_id is necessary send the last , to forget the last update is necessary send : update_id + 1
	Local $SdtOut = InetRead($TELEGRAM_URL & $g_sNotifyTGToken & "/getupdates?offset=" & $g_sTGLast_UID, $INET_FORCERELOAD)
	If @error Or $SdtOut = "" Then Return
	Local $sCorrectStdOut = BinaryToString($SdtOut, 4)
	$sCorrectStdOut = Json_StringDecode($sCorrectStdOut)
	SetDebugLog("Notify | getupdates?offset=" & $g_sTGLast_UID & " : " & $sCorrectStdOut)

	; Parse message text from Json Format
	Local $msg = _StringBetween($sCorrectStdOut, '"text":"', '"')
	If @error Or Not IsArray($msg) Then Return
	; This array can be more than 1 , let's get the last!
	SetDebugLog("You have " & UBound($msg) & " messages to read")
	$TGLastMessage = String($msg[UBound($msg) - 1])
	SetDebugLog("Telegram last message was '" & $TGLastMessage & "'")

	Return $TGLastMessage

EndFunc   ;==>NotifyGetLastMessageFromTelegram

; SENDING CUSTOM KEYBOARD
Func NotifyActivateKeyboardOnTelegram($TGMsg)
	SetDebugLog("Notify | NotifyActivateKeyboardOnTelegram($TGMsg): " & $TGMsg)

	If $TGMsg = "" Or $g_sNotifyTGToken = "" Or $g_sTGChatID = "" Then Return False
	Local $ReplayMarkup = '{"keyboard": [["' & _
			'\ud83d\udcf7 ' & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT") & '","' & _
			'\ud83d\udd28 ' & GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER") & '","' & _
			'\ud83d\udd30 ' & GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD") & '"],["' & _
			'\ud83d\udcc8 ' & GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS") & '","' & _
			'\ud83d\udcaa ' & GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS") & '","' & _
			'\u2753 ' & GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP") & '"],["' & _
			'\u25aa ' & GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP") & '","' & _
			'\u25b6 ' & GetTranslatedFileIni("MBR Func_Notify", "START", "START") & '","' & _
			'\ud83d\udd00 ' & GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE") & '","' & _
			'\u25b6 ' & GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME") & '","' & _
			'\ud83d\udd01 ' & GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART") & '"],["' & _
			'\ud83d\udccb ' & GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG") & '","' & _
			'\ud83c\udf04 ' & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID") & '","' & _
			'\ud83d\udcc4 ' & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT") & '"],["' & _
			'\u2705 ' & GetTranslatedFileIni("MBR Func_Notify", "ATTACK ON ", "ATTACK ON") & '","' & _
			'\u274C ' & GetTranslatedFileIni("MBR Func_Notify", "ATTACK OFF", "ATTACK OFF") & '"],["' & _
			'\ud83d\udca4 ' & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE") & '","' & _
			'\u26a1 ' & GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN") & '","' & _
			'\ud83d\udd06 ' & GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY") & '"]],"one_time_keyboard": false,"resize_keyboard":true}'

	Local $sOUTPUT = InetRead($TELEGRAM_URL & $g_sNotifyTGToken & "/sendMessage?chat_id=" & $g_sTGChatID & "&text=" & $TGMsg & "&reply_markup=" & $ReplayMarkup, $INET_FORCERELOAD)
	If @error Or $sOUTPUT = "" Then Return False
	$g_iTGLastRemote = $g_sTGLast_UID
	Return True

EndFunc   ;==>NotifyActivateKeyboardOnTelegram

; CONTROL TELEGRAM ON MAINLOOP()
Func NotifyRemoteControlProcBtnStart()
	Local $bWasSilent = SetDebugLogSilent()
	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then
		$g_sTGLastMessage = NotifyGetLastMessageFromTelegram()
		If $g_sTGLastMessage = "" Then Return
		Local $TGActionMSG = StringUpper(StringStripWS($g_sTGLastMessage, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message
		SetDebugLog("Telegram | NotifyRemoteControlProcBtnStart $TGActionMSG : " & $TGActionMSG)
		SetDebugLog("Telegram | NotifyRemoteControlProcBtnStart $g_iTGLastRemote : " & $g_iTGLastRemote)
		SetDebugLog("Telegram | NotifyRemoteControlProcBtnStart $g_sTGLast_UID : " & $g_sTGLast_UID)
		If $g_iTGLastRemote <> $g_sTGLast_UID Then
			$g_iTGLastRemote = $g_sTGLast_UID

			SetDebugLog("Telegram | NotifyRemoteControlProcBtnStart $TGActionMSG1:" & $TGActionMSG)

			Switch $TGActionMSG
				Case "/START", GetTranslatedFileIni("MBR Func_Notify", "START", "START"), BinaryToString( Binary("0x25b6"), 3)&' ' & GetTranslatedFileIni("MBR Func_Notify", "START", "START")
					btnStart()
					NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_01", "Request to Start...") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_02", "Your bot is now starting..."))
				Case "/KEYBOARD", "/keyboard"
					NotifyActivateKeyboardOnTelegram($g_sNotifyOrigin & " | " & $g_sBotTitle & " | Notify " & $g_sNotifyVersion)
				Case Else
					NotifyPushToTelegram($g_sNotifyOrigin & ":" & chr(10) & "Get:" & $TGActionMSG & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_03", "Start MyBot first."))
			EndSwitch
		EndIf
	EndIf
	SetDebugLogSilent($bWasSilent)
EndFunc   ;==>NotifyRemoteControlProcBtnStart

; CONTROL TELEGRAM ON MAINLOOP()
Func NotifyRemoteBotisOnline()
	;Local $bWasSilent = SetDebugLogSilent()
	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" And $g_bNotifyBotOnline = False Then
		local $TGRet = NotifyPushToTelegram($g_sNotifyOrigin & ":" & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_04", "The Bot is online, you can say:" & @CRLF & "/start - start the bot" & @CRLF & "/keyboard - get a command keyboard"))
		;not send this msg again
		If $TGRet = True Then $g_bNotifyBotOnline = TRUE
		SetDebugLog("Telegram | NotifyRemoteBotisOnline $TGRet:" & $TGRet & " $g_bNotifyBotOnline:" & $g_bNotifyBotOnline)
	EndIf
	;SetDebugLogSilent($bWasSilent)
EndFunc   ;==>NotifyRemoteBotisOnline



; CONTROL TELEGRAM : REMOTE CONTROL
Func NotifyRemoteControlProc()
	SetDebugLog("Notify | NotifyRemoteControlProc()")
	Static $bShutdown = False
	Static $bHibernate = False
	Static $bStandby = False

	If Not $g_bNotifyTGEnable Or Not $g_bNotifyRemoteEnable Then Return

	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" And $g_bRunState Then
		$g_sTGLastMessage = NotifyGetLastMessageFromTelegram()
		Local $TGActionMSG = StringUpper(StringStripWS($g_sTGLastMessage, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message
		SetDebugLog("Telegram | NotifyRemoteControlProc $TGActionMSG : " & $TGActionMSG)
		SetDebugLog("Telegram | NotifyRemoteControlProc $g_iTGLastRemote : " & $g_iTGLastRemote)
		SetDebugLog("Telegram | NotifyRemoteControlProc $g_sTGLast_UID : " & $g_sTGLast_UID)
		If ($TGActionMSG = "/START" Or $TGActionMSG = "KEYB" Or $TGActionMSG = "/KEYBOARD") And $g_iTGLastRemote <> $g_sTGLast_UID Then
			$g_iTGLastRemote = $g_sTGLast_UID
			NotifyActivateKeyboardOnTelegram($g_sBotTitle & " | Notify " & $g_sNotifyVersion)
		Else
			If $g_iTGLastRemote <> $g_sTGLast_UID Then
				$g_iTGLastRemote = $g_sTGLast_UID
				SetDebugLog("Telegram | NotifyRemoteControlProc $TGActionMSG:" & $TGActionMSG)
				Switch $TGActionMSG
					Case GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP"), BinaryToString( Binary("0x2753"), 3)&' ' & GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP")
						Local $txtHelp = "Telegram " & GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP") & " " & GetTranslatedFileIni("MBR Func_Notify", "Bot_Info_01", "- You can remotely control your bot sending COMMANDS from the following list:")
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "HELP", -1) & " " & GetTranslatedFileIni("MBR Func_Notify", "HELP_Info_01", "- send this help message")
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART") & " " & GetTranslatedFileIni("MBR Func_Notify", "RESTART_Info_01", "- restart the Emulator and bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "START", "START") & " " & GetTranslatedFileIni("MBR Func_Notify", "START_Info_01", "- start the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP") & " " & GetTranslatedFileIni("MBR Func_Notify", "STOP_Info_01", "- stop the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE") & " " & GetTranslatedFileIni("MBR Func_Notify", "PAUSE_Info_01", "- pause the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME") & " " & GetTranslatedFileIni("MBR Func_Notify", "RESUME_Info_01", "- resume the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS") & " " & GetTranslatedFileIni("MBR Func_Notify", "STATS_Info_01", "- send Village Statistics of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG") & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_01", "- send the current log file of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID") & " " & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID_Info_01", "- send the last raid loot screenshot of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT") & " " & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT_Info_01", "- send the last raid loot values of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT") & " " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_01", "- send a screenshot of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD", "SCREENSHOTHD") & " " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD_Info_01", "- send a screenshot in high resolution of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER") & " " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER_Info_01", "- send a screenshot of builder status of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD") & " " & GetTranslatedFileIni("MBR Func_Notify", "SHIELD_Info_01", "- send a screenshot of shield status of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS", "RESETSTATS") & " " & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS_Info_01", "- reset Village Statistics")
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS") & " " & GetTranslatedFileIni("MBR Func_Notify", "TROOPS_Info_01", "- send Troops & Spells Stats")
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKON", "HALTATTACKON") & " " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK OFF_Info_01", "- Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKOFF", "HALTATTACKOFF") & " " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK ON_Info_01", "- Turn Off 'Halt Attack' in the 'Misc' Tab")
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE") & " " & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE_Info_01", "- Hibernate host PC")
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN") & " " & GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN_Info_01", "- Shut down host PC")
						$txtHelp &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY") & " " & GetTranslatedFileIni("MBR Func_Notify", "STANDBY_Info_01", "- Standby host PC")

						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-For-Help_Info_02", "Request for Help") & chr(10) & $txtHelp)
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Help has been sent", $COLOR_SUCCESS)
					Case GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART"), BinaryToString( Binary("0xD83DDD01"), 3)&' ' & GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART")
						SetLog("Notify Telegram: Your request has been received.", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_16", "Request to Restart") & "..."& chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_09", "Your bot and Emulator are now restarting..."))
						SaveConfig()
						RestartBot()
					Case GetTranslatedFileIni("MBR Func_Notify", "START", "START"), BinaryToString( Binary("0x25b6"), 3)&' '  & GetTranslatedFileIni("MBR Func_Notify", "START", "START")
						If $g_bRunState = True Then
							SetLog("Notify Telegram" & ": " & "Your bot is currently started, no action was taken", $COLOR_SUCCESS)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_01", "Request to Start...") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_03", "Your bot is currently started, no action was taken"))
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP"), BinaryToString( Binary("0x25aa"), 3)&' '  & GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP")
						SetLog("Notify Telegram: Your request has been received. Bot is now stopped", $COLOR_SUCCESS)
						If $g_bRunState = True Then
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_02", "Request to Stop...") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_19", "Please wait..."))
							$g_iAndroidCoCPid = GetAndroidProcessPID(Default, False) ; check is CoC app is still open
							While $g_iAndroidCoCPid <> 0
								; Close Game
								CloseCoC()
								; Check is CoC app is still open
								$g_iAndroidCoCPid = GetAndroidProcessPID(Default, False)
								If $g_iAndroidCoCPid = 0 Then ExitLoop
							WEnd
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_02", "Request to Stop...") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_03", "Your bot is now stopped"))
							btnStop()
						Else
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_02", "Request to Stop...") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_04", "Your bot is currently stopped, no action was taken"))
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE"), BinaryToString( Binary("0xD83DDD00"), 3)&' '  & GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE")
						If $g_bBotPaused = False And $g_bRunState = True Then
							If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
								SetLog("Notify Telegram: Unable to pause during attack", $COLOR_ERROR)
								NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_17", "Request to Pause") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_08", "Unable to pause during attack, try again later."))
							ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
								ReturnHome(False, False)
								$g_bIsSearchLimit = True
								$g_bIsClientSyncError = True
								$g_bRestart = True
								TogglePauseImpl("Push")
								Return True
							Else
								TogglePauseImpl("Push")
							EndIf
						Else
							SetLog("Notify Telegram: Your bot is currently paused, no action was taken", $COLOR_SUCCESS)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_17", "Request to Pause") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_11", "Your bot is currently paused, no action was taken"))
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME"), BinaryToString( Binary("0x25b6"), 3)&' '   & GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME")
						If $g_bBotPaused = True And $g_bRunState = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Notify Telegram: Your bot is currently resumed, no action was taken", $COLOR_SUCCESS)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_18", "Request to Resume") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_12", "Your bot is currently resumed, no action was taken"))
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS"), BinaryToString( Binary("0xd83ddcc8"), 3)&' '   & GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS")
						SetLog("Notify Telegram: Your request has been received. Statistics sent", $COLOR_SUCCESS)
						Local $GoldGainPerHour = "0 / h"
						Local $ElixirGainPerHour = "0 / h"
						Local $DarkGainPerHour = "0 / h"
						Local $TrophyGainPerHour = "0 / h"
						If $g_iFirstAttack = 2 Then
							$GoldGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h"
							$ElixirGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h"
						EndIf
						If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
							$DarkGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h"
						EndIf
						$TrophyGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootTrophy] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h"
						Local $txtStats = " | " & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_02", "Stats Village Report") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_05", "At Start") & chr(10)&"[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsStartedWith[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: "
						$txtStats &= _NumberFormat($g_iStatsStartedWith[$eLootElixir]) & " [D]: " & _NumberFormat($g_iStatsStartedWith[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsStartedWith[$eLootTrophy]
						$txtStats &= chr(10)&chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Stats-Now_Info_01", "Now (Current Resources)") & chr(10)&"[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir])
						$txtStats &= " [D]: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_aiCurrentLoot[$eLootTrophy] & " [GEM]: " & $g_iGemAmount
						$txtStats &= chr(10)&chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_04", "Gain per Hour") & ":"& chr(10)&"[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & $GoldGainPerHour & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & $ElixirGainPerHour
						$txtStats &= chr(10)&"[D]: " & $DarkGainPerHour & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $TrophyGainPerHour
						$txtStats &= chr(10)&chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Free-Builders_Info_01", "No. of Free Builders") & ": " & $g_iFreeBuilderCount & chr(10)&"[" & GetTranslatedFileIni("MBR Func_Notify", "Wall-Up_Info_01", "No. of Wall Up") & "]: [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: "
						$txtStats &= $g_iNbrOfWallsUppedGold & "/ [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & $g_iNbrOfWallsUppedElixir & chr(10)&chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Attack_Info_01", "Attacked") & ": "
						$txtStats &= $g_aiAttackedCount & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Skip_Info_02", "Skipped") & ": " & $g_iSkippedVillageCount
                        Local $day = 0, $hour = 0, $min = 0, $sec = 0
                        _TicksToDay(Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed), $day, $hour, $min, $sec)
                        GUICtrlSetData($g_hLblResultRuntime, $day > 0 ? StringFormat("%2u Day(s) %02i:%02i:%02i", $day, $hour, $min, $sec) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
                        $txtStats &= "%0A" & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_07", "Run Time") & ": " & GUICtrlRead($g_hLblResultRuntime) ;This label only changes when on the stats screen, so update it here.
						$txtStats &= chr(10)&chr(10) & "Clan Games:"
						$txtStats &= chr(10) & "[T]: " & GUICtrlRead($g_hLblRemainTime) & " [S]: " & GUICtrlRead($g_hLblYourScore)
						$txtStats &= chr(10) & " "
						NotifyPushToTelegram($g_sNotifyOrigin & $txtStats)
					Case GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG"), BinaryToString( Binary("0xd83ddccb"), 3)&' '   & GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG")
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Log is now sent", $COLOR_SUCCESS)
						NotifyPushFileToTelegram($g_sLogFileName, "Logs", "text\/plain; charset=utf-8", $g_sNotifyOrigin & " | Current Log " & chr(10))
					Case GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID"), BinaryToString( Binary("0xd83cdf04"), 3)&' '    & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID")
						If $g_sLootFileName <> "" Then
							NotifyPushFileToTelegram($g_sLootFileName, "Loots", "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_05", "Last Raid") & chr(10) & $g_sLootFileName)
							SetLog("Notify Telegram: Push Last Raid Snapshot...", $COLOR_SUCCESS)
						Else
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_03", "There is no last raid screenshot."))
							SetLog("There is no last raid screenshot.")
							SetLog("Notify Telegram: Your request has been received. Last Raid txt sent", $COLOR_SUCCESS)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_04", "Last Raid txt") & chr(10) & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [D]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT"), BinaryToString( Binary("0xD83Ddcc4"), 3)&' '   & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT")
						SetLog("Notify Telegram: Your request has been received. Last Raid txt sent", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_04", "Last Raid txt") & chr(10) & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [D]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
					Case GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT"), BinaryToString( Binary("0xD83Ddcf7"), 3)&' '   & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT")
						SetLog("Notify Telegram: ScreenShot request received", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_03", "Chief, your request for Screenshot will be processed ASAP"))
						$g_bTGRequestScreenshot = True
					Case GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD", "SCREENSHOTHD")
						SetLog("Notify Telegram: ScreenShot HD request received", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_03", "Chief, your request for Screenshot will be processed ASAP"))
						$g_bTGRequestScreenshot = True
						$g_bTGRequestScreenshotHD = True
						$g_bNotifyForced = False
					Case GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER"), BinaryToString( Binary("0xD83Ddd28"), 3)&' '     & GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER")
						SetLog("Notify Telegram: Builder Status request received", $COLOR_SUCCESS)
						$g_bTGRequestBuilderInfo = True
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER_Info_04", "Chief, your request for Builder Info will be processed ASAP"))
					Case GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD"), BinaryToString( Binary("0xD83Ddd30"), 3)&' '   & GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD")
						SetLog("Notify Telegram: Shield Status request received", $COLOR_SUCCESS)
						$g_bTGRequestShieldInfo = True
						$g_bNotifyForced = False
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SHIELD_Info_02", "Chief, your request for Shield Info will be processed ASAP"))
					Case GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS", "RESETSTATS")
						btnResetStats()
						SetLog("Notify Telegram: Your request has been received. Statistics resetted", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS_Info_02", "Statistics resetted."))
					Case GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS"), BinaryToString( Binary("0xD83Ddcaa"), 3)&' '    & GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS")
						SetLog("Notify Telegram: Your request has been received. Sending Troop/Spell Stats...", $COLOR_SUCCESS)
						Local $txtTroopStats = " | " & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_01", "[Train Status]:"& chr(10) )
						For $i = 0 To UBound($g_aiArmyCompTroops) - 1
							If $g_aiArmyCompTroops[$i] > 0 Then
								$txtTroopStats &= $g_asTroopShortNames[$i] & ": " & $g_aiCurrentTroops[$i] & " of " & $g_aiArmyCompTroops[$i] & chr(10)
							EndIf
						Next
						For $i = 0 To UBound($g_aiArmyCompSpells) - 1
							If $g_aiArmyCompSpells[$i] > 0 Then
								$txtTroopStats &= $g_asSpellShortNames[$i] & ": " & $g_aiCurrentSpells[$i] & " of " & $g_aiArmyCompSpells[$i] & chr(10)
							EndIf
						Next
						For $i = 0 To UBound($g_aiArmyCompSiegeMachines) - 1
							If $g_aiArmyCompSiegeMachines[$i] > 0 Then
								$txtTroopStats &= $g_asSiegeMachineShortNames[$i] & ": " & $g_aiArmyCompSiegeMachines[$i] & " of " & $g_aiArmyCompSiegeMachines[$i] & chr(10)
							EndIf
						Next
						$txtTroopStats &= chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_05", "Current Capacities") & ":"
						$txtTroopStats &= chr(10) & " " & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_06", "- Army Camp") & ": " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace
						$txtTroopStats &= chr(10) & " " & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_04", "- Spells") & ": " & $g_iCurrentSpells & "/" & $g_iTotalTrainSpaceSpell

						NotifyPushToTelegram($g_sNotifyOrigin & $txtTroopStats)
					Case GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKON", "HALTATTACKON"), BinaryToString( Binary("0x274c"), 3)&' '   & StringUpper(GetTranslatedFileIni("MBR Func_Notify", "ATTACK OFF", "ATTACK OFF"))
						GUICtrlSetState($g_hChkBotStop, $GUI_CHECKED)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK ON_Info_02", "Set Halt Attack ON."))
						btnStop()
						$g_bChkBotStop = True ; set halt attack variable
						$g_iCmbBotCond = 18 ; set stay online
						btnStart()
					Case GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKOFF", "HALTATTACKOFF"), BinaryToString( Binary("0x2705"), 3)&' '    & StringUpper(GetTranslatedFileIni("MBR Func_Notify", "ATTACK ON_Info_01", "ATTACK ON"))
						GUICtrlSetState($g_hChkBotStop, $GUI_UNCHECKED)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK OFF_Info_02", "Set Halt Attack OFF."))
						btnStop()
						btnStart()
					Case GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE"), BinaryToString( Binary("0xD83DDCA4"), 3)&' '  & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE")
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Hibernate PC", $COLOR_SUCCESS)
						$bHibernate = True
						NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "CONFIRM_Info_01", "Are you sure?, Please send") & " CONFIRM" & chr(10) & _
								GetTranslatedFileIni("MBR Func_Notify", "CONFIRM_Info_02", "If isn't to continue send") & " CANCEL")
					Case GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN"), BinaryToString( Binary("0x26a1"), 3)&' '    & StringUpper(GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN"))
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Shutdown PC", $COLOR_SUCCESS)
						$bShutdown = True
						NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "CONFIRM_Info_01", "Are you sure?, Please send") & " CONFIRM" & chr(10) & _
								GetTranslatedFileIni("MBR Func_Notify", "CONFIRM_Info_02", "If isn't to continue send") & " CANCEL")
					Case GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY"), BinaryToString( Binary("0xD83Ddd06"), 3)&' '    & GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY")
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Standby PC", $COLOR_SUCCESS)
						NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "CONFIRM_Info_01", "Are you sure?, Please send") & " CONFIRM" & chr(10) & _
								GetTranslatedFileIni("MBR Func_Notify", "CONFIRM_Info_02", "If isn't to continue send") & " CANCEL")
						$bStandby = True
					Case "CONFIRM"
						If $bShutdown Then
							NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN_Info_02", "PC Shutdown sequence initiated"))
							$bShutdown = False
							Shutdown(5)
						ElseIf $bHibernate Then
							NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE_Info_02", "PC Hibernate sequence initiated"))
							$bHibernate = False
							Shutdown(64)
						ElseIf $bStandby Then
							NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "STANDBY_Info_02", "PC Standby sequence initiated"))
							$bStandby = False
							Shutdown(32)
						EndIf
					Case "CANCEL"
						NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "CANCEL_Info_01", "Canceled the last sequence"))
						$bShutdown = False
						$bHibernate = False
						$bStandby = False
					Case Else
						; ChatActions - Team AiO MOD++ START
						Local $bFoundChatMessage = False
						If StringInStr($TGActionMSG, "SENDCHAT") Then
							$bFoundChatMessage = True
							Local $sChatMessage = StringRight($TGActionMSG, StringLen($TGActionMSG) - StringLen("SENDCHAT"))
							$sChatMessage = StringLower($sChatMessage)
							ChatbotNotifyQueueChat($sChatMessage)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & "Chat queued, will send on next idle")
						ElseIf StringInStr($TGActionMSG, "GETCHATS") Then
							$bFoundChatMessage = True
							Local $Interval = 1
							$Interval = StringRight($TGActionMSG, StringLen($TGActionMSG) - StringLen("GETCHATS"))
							If $Interval = "STOP" Then
								ChatbotNotifyStopChatRead()
								NotifyPushToTelegram($g_sNotifyOrigin & " | " & "Stopping interval sending")
							Else
								If $Interval = "NOW" Then
									ChatbotNotifySendChat()
									NotifyPushToTelegram($g_sNotifyOrigin & " | " & "Command queued, will send clan chat image on next idle")
								EndIf
							EndIf
						EndIf
						If Not $bFoundChatMessage Then
							NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "ELSE_Info_01", "Sorry Chief!,") & " " & $TGActionMSG & " " & _
								GetTranslatedFileIni("MBR Func_Notify", "ELSE_Info_02", "is not a valid command."))
							EndIf
						; ChatActions - Team AiO MOD++ END
				EndSwitch
			EndIf
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------

EndFunc   ;==>NotifyRemoteControlProc

; CONTROL TELEGRAM : UI ASKED PUSHES
Func NotifyPushMessageToBoth($Message, $Source = "")

	If Not $g_bNotifyTGEnable And Not $g_bNotifyDSEnable Then Return

	SetDebugLog("Notify | NotifyPushMessageToBoth($Message, $Source = ""): " & $Message & "," & $Source)
	Static $iReportIdleBuilder = 0

	If Not IsPlanUseTelegram($Message) And  Not IsPlanUseDiscord($Message) Then Return

	$g_bNotifyForced = False

	Local $hBitmap_Scaled
	Local $sTring = ""
	Switch $Message
		Case "Restarted"
			If $g_bNotifyRemoteEnable Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_10", "Bot restarted"))
			If $g_bNotifyRemoteEnableDS Then NotifyPushToDiscord($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_10", "Bot restarted"))
		Case "OutOfSync"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_05", "Restarted after Out of Sync Error") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_06", "Attacking now") & "..."
			If $g_bNotifyAlertOutOfSync Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertOutOfSyncDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "LastRaid"
			If $g_bNotifyAlerLastRaidTXT Or $g_bNotifyAlerLastRaidTXTDS Then
				$g_aiCurrentLoot[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy] + $g_iStatsLastAttack[$eLootTrophy]
				$g_iStatsLastAttack[$eLootGold] = $g_iStatsLastAttack[$eLootGold] / 1000
				$g_iStatsLastAttack[$eLootElixir] = $g_iStatsLastAttack[$eLootElixir] / 1000
				$g_iStatsLastAttack[$eLootDarkElixir] = $g_iStatsLastAttack[$eLootDarkElixir] / 1000
				$g_iStatsLastAttack[$eLootGold] = Round($g_iStatsLastAttack[$eLootGold], -1)
				$g_iStatsLastAttack[$eLootElixir] = Round($g_iStatsLastAttack[$eLootElixir], -1)
				$g_iStatsLastAttack[$eLootDarkElixir] = Round($g_iStatsLastAttack[$eLootDarkElixir], 1)

				$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_02", "Last Raid txt") & _
						chr(10) & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & _
						"k  [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & _
						"k  [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & _
						"k "& chr(10)&"[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy] & _
						"  [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "%") & "]: " & $g_sTotalDamage & _
						"  [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "*") & "]: " & $g_sStarsEarned & _
						"  [Tr#]: " & $g_aiCurrentLoot[$eLootTrophy]

				If $g_bNotifyAlerLastRaidTXT Then
					NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
				EndIf
				If $g_bNotifyAlerLastRaidTXTDS Then
					NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
				EndIf

				If _Sleep($DELAYPUSHMSG1) Then Return
				SetLog("Notify Telegram: Last Raid Text has been sent!", $COLOR_SUCCESS)
			EndIf
			If $g_bNotifyAlerLastRaidIMG Or $g_bNotifyAlerLastRaidIMGDS Then

				;create a temporary file to send with pushbullet...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				If $g_bScreenshotLootInfo Then
					$g_sAttackFile = $g_sLootFileName
				Else
					_CaptureRegion()
					$g_sAttackFile = "Notify_" & $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
					$hBitmap_Scaled = _GDIPlus_ImageResize($g_hBitmap, _GDIPlus_ImageGetWidth($g_hBitmap) / 2, _GDIPlus_ImageGetHeight($g_hBitmap) / 2) ;resize image
					_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $g_sProfileLootsPath & $g_sAttackFile)
					_GDIPlus_ImageDispose($hBitmap_Scaled)
				EndIf
				;push the file
				SetLog("Notify Telegram: Last Raid screenshot has been sent!", $COLOR_SUCCESS)
				If $g_bNotifyAlerLastRaidIMG Then NotifyPushFileToTelegram($g_sAttackFile, "Loots", "image/jpeg", $g_sNotifyOrigin & " | " & "Last Raid" & chr(10) & $g_sAttackFile)
				If $g_bNotifyAlerLastRaidIMGDS Then NotifyPushFileToDiscord($g_sAttackFile, "Loots", "image/jpeg", $g_sNotifyOrigin & " | " & "Last Raid" & chr(10) & $g_sAttackFile)
				;wait a second and then delete the file
				If _Sleep($DELAYPUSHMSG1) Then Return
				Local $iDelete = FileDelete($g_sProfileLootsPath & $g_sAttackFile)
				If Not $iDelete Then
					SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
				EndIf
			EndIf
		Case "FoundWalls"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "Wall-Up_Info_02", "Found Wall level") & " " & $g_iCmbUpgradeWallsLevel + 4 & chr(10) & " " & GetTranslatedFileIni("MBR Func_Notify", "Wall-Up_Info_04", "Wall segment has been located") & "..."& chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_01", "Upgrading") & "..."
			If $g_bNotifyAlertUpgradeWalls Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertUpgradeWallsDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "SkipWalls"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "Wall-Up_Info_03", "Cannot find Wall level") & $g_iCmbUpgradeWallsLevel + 4 & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_02", "Skip upgrade") & "..."
			If $g_bNotifyAlertUpgradeWalls Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertUpgradeWallsDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "AnotherDevice3600"
			$sTring = " | 1. " & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_01", "Another Device has connected") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_02", "Another Device has connected, waiting") & " " & Floor(Floor($g_iAnotherDeviceWaitTime / 60) / 60) & " " & GetTranslatedFileIni("MBR Global GUI Design", "Hours", -1) & " " & Floor(Mod(Floor($g_iAnotherDeviceWaitTime / 60), 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "Min", -1) & " " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "seconds", -1)
			If $g_bNotifyAlertAnotherDevice Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertAnotherDeviceDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "AnotherDevice60"
			$sTring = " | 2. " & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_01", "Another Device has connected") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_02", "Another Device has connected, waiting") & " " & Floor(Mod(Floor($g_iAnotherDeviceWaitTime / 60), 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "Min", -1) & " " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "seconds", -1)
			If $g_bNotifyAlertAnotherDevice Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertAnotherDeviceDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "AnotherDevice"
			$sTring = " | 3. " & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_01", "Another Device has connected") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_02", "Another Device has connected, waiting") & " " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "seconds", -1)
			If $g_bNotifyAlertAnotherDevice Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertAnotherDeviceDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "TakeBreak"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "Need-Rest_Info_01", "Chief, we need some rest!") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Take-Break_Info_01", "Village must take a break..")
			If $g_bNotifyAlertTakeBreak Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertTakeBreakDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "Update"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "New-Version_Info_01", "Chief, there is a new version of the bot available")
			If $g_bNotifyAlertBOTUpdate Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertBOTUpdateDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "BuilderIdle"
			If $g_bNotifyAlertBulderIdle Or $g_bNotifyAlertBulderIdleDS Then
				Local $iAvailBldr = $g_iFreeBuilderCount - ($g_bUpgradeWallSaveBuilder ? 1 : 0)
				If $iAvailBldr > 0 Then
					If $iReportIdleBuilder <> $iAvailBldr Then
						If $g_bNotifyAlertBulderIdle Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_03", "You have") & " " & $iAvailBldr & " " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER_Info_03", "builder(s) idle."))
						If $g_bNotifyAlertBulderIdleDS Then NotifyPushToDiscord($g_sNotifyOriginDS & " | " & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_03", "You have") & " " & $iAvailBldr & " " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER_Info_03", "builder(s) idle."))
						SetLog("You have " & $iAvailBldr & " builder(s) idle.", $COLOR_SUCCESS)
						$iReportIdleBuilder = $iAvailBldr
					EndIf
				Else
					$iReportIdleBuilder = 0
				EndIf
			EndIf
		Case "CocError"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_04", "CoC Has Stopped Error") & "....."
			If $g_bNotifyAlertOutOfSync Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertOutOfSyncDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "Pause"
			If $Source = "Push" Then
				If $g_bNotifyRemoteEnable Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_17", "Request to Pause") & "..." & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_13", "Your request has been received. Bot is now paused"))
				If $g_bNotifyRemoteEnableDS Then NotifyPushToDiscord($g_sNotifyOriginDS & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_17", "Request to Pause") & "..." & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_13", "Your request has been received. Bot is now paused"))
			EndIf
		Case "Resume"
			If $Source = "Push" Then
				If $g_bNotifyRemoteEnable Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_18", "Request to Resume") & "..." & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_14", "Your request has been received. Bot is now resumed"))
				If $g_bNotifyRemoteEnableDS Then NotifyPushToDiscord($g_sNotifyOriginDS & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_18", "Request to Resume") & "..." & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_14", "Your request has been received. Bot is now resumed"))
			EndIf
		Case "OoSResources"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_06", "Disconnected after") & " " & StringFormat("%3s", $g_iSearchCount) & " " & GetTranslatedFileIni("MBR Func_Notify", "Skip_Info_01", "skip(s)") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Attack_Info_02", "Cannot locate Next button, Restarting Bot") & "..."
			If $g_bNotifyAlertOutOfSync Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertOutOfSyncDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "MatchFound"
			$sTring = " | " & $g_asModeText[$g_iMatchMode] & " " & GetTranslatedFileIni("MBR Func_Notify", "Match-Found_Info_01", "Match Found! after") & " " & StringFormat("%3s", $g_iSearchCount) & " " & GetTranslatedFileIni("MBR Func_Notify", "Skip_Info_01", "skip(s)") & chr(10) & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iSearchGold) & "; [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iSearchElixir) & "; [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_iSearchDark) & "; [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iSearchTrophy
			If $g_bNotifyAlertMatchFound Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertMatchFoundDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "UpgradeWithGold"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_07", "Upgrade completed by using GOLD") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_03", "Complete by using GOLD") & "..."
			If $g_bNotifyAlertUpgradeWalls Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertUpgradeWallsDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "UpgradeWithElixir"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_08", "Upgrade completed by using ELIXIR") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_04", "Complete by using ELIXIR") & "..."
			If $g_bNotifyAlertUpgradeWalls Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertUpgradeWallsDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "NoUpgradeWallButton"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_05", "No Upgrade Gold Button") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_10", "Cannot find gold upgrade button") & "..."
			If $g_bNotifyAlertUpgradeWalls Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertUpgradeWallsDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "NoUpgradeElixirButton"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_09", "No Upgrade Elixir Button") & chr(10) & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_06", "Cannot find elixir upgrade button") & "..."
			If $g_bNotifyAlertUpgradeWalls Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
			EndIf
			If $g_bNotifyAlertUpgradeWallsDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
			EndIf
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion()
			If $g_bTGRequestScreenshotHD Then
				$hBitmap_Scaled = $g_hBitmap
			Else
				$hBitmap_Scaled = _GDIPlus_ImageResize($g_hBitmap, _GDIPlus_ImageGetWidth($g_hBitmap) / 2, _GDIPlus_ImageGetHeight($g_hBitmap) / 2) ;resize image
			EndIf
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $g_sProfileTempPath & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			If $g_bTGRequestScreenshot Then
				NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_04", "Screenshot of your village") & " " & chr(10) & $Screnshotfilename)
				SetLog("Notify Telegram: Screenshot sent!", $COLOR_SUCCESS)
				If $g_bNotifyDSEnable Then
					NotifyPushFileToDiscord($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOriginDS & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_04", "Screenshot of your village") & " " & chr(10) & $Screnshotfilename)
					SetLog("Notify Discord: Screenshot sent!", $COLOR_SUCCESS)
				EndIf
			EndIf
			$g_bTGRequestScreenshot = False
			$g_bTGRequestScreenshotHD = False
			;wait a second and then delete the file
			If _Sleep($DELAYPUSHMSG2) Then Return
			Local $iDelete = FileDelete($g_sProfileTempPath & $Screnshotfilename)
			If Not $iDelete Then
				SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
			EndIf
		Case "BuilderInfo"
			ClickAway()
			If Not IsMainPage() Then Return
			; open the builders menu
			Click(295, 30)
			If _Sleep(1500) Then Return
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(215, 77, 450, 360)
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($g_hBitmap, $g_sProfileTempPath & $Screnshotfilename)
			If $g_bTGRequestBuilderInfo Then
				NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & "Builder Information" & chr(10) & $Screnshotfilename)
				SetLog("Notify Telegram: Builder Information sent!", $COLOR_GREEN)
				If $g_bNotifyDSEnable Then
					NotifyPushFileToDiscord($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOriginDS & " | " & "Builder Information" & chr(10) & $Screnshotfilename)
					SetLog("Notify Discord: Builder Information sent!", $COLOR_GREEN)
				EndIf
			EndIf
			$g_bTGRequestBuilderInfo = False
			;wait a second and then delete the file
			If _Sleep($DELAYPUSHMSG2) Then Return
			Local $iDelete = FileDelete($g_sProfileTempPath & $Screnshotfilename)
			If Not $iDelete Then
				SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
			EndIf
			ClickAway(Default, True)
		Case "ShieldInfo"
			ClickAway()
			If Not IsMainPage() Then Return
			Click(435, 8)
			If _Sleep(1500) Then Return
			If _Wait4PixelGoneArray($aIsMain) Then
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				_CaptureRegion(200, 165, 660, 568)
				Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
				_GDIPlus_ImageSaveToFile($g_hBitmap, $g_sProfileTempPath & $Screnshotfilename)
				If $g_bTGRequestShieldInfo Then
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & "Shield Information" & chr(10) & $Screnshotfilename)
					If $g_bNotifyDSEnable Then
						NotifyPushFileToDiscord($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOriginDS & " | " & "Shield Information" & chr(10) & $Screnshotfilename)
						SetLog("Notify Telegram: Shield Information sent!", $COLOR_SUCCESS)
					EndIf
				EndIf
				$g_bTGRequestShieldInfo = False
				;wait a second and then delete the file
				If _Sleep($DELAYPUSHMSG2) Then Return
				Local $iDelete = FileDelete($g_sProfileTempPath & $Screnshotfilename)
				If Not $iDelete Then
					SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
				EndIf
			EndIf
			ClickAway()
		Case "CampFull"
			$sTring = " | " & GetTranslatedFileIni("MBR Func_Notify", "Camps-Full_Info_01", "Your Army Camps are now Full")
			If $g_bNotifyAlertCampFull Then
				NotifyPushToTelegram($g_sNotifyOrigin & $sTring)
				SetLog("Notify Telegram: Your Army Camps are now Full", $COLOR_SUCCESS)
			EndIf
			If $g_bNotifyAlertCampFullDS Then
				NotifyPushToDiscord($g_sNotifyOriginDS & $sTring)
				SetLog("Notify Discord: Your Army Camps are now Full", $COLOR_SUCCESS)
			EndIf
		Case "Misc"
			NotifyPushToTelegram($Message)
			NotifyPushToDiscord($Message)
		Case Else
			NotifyPushToTelegram(String($Message))
			NotifyPushToDiscord(String($Message))
	EndSwitch
EndFunc   ;==>NotifyPushMessageToBoth

; CHECK IF WAS PLANNED TO USE TELEGRAM
Func IsPlanUseTelegram($Message)
	If Not $g_bNotifyForced And $Message <> "DeleteAllPBMessages" Then
		If $g_bNotifyScheduleWeekDaysEnable Then
			If $g_abNotifyScheduleWeekDays[@WDAY - 1] Then
				If $g_bNotifyScheduleHoursEnable Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If Not $g_abNotifyScheduleHours[$hour[0]] Then
						SetLog("Notify not planned for this hour! Notification skipped", $COLOR_WARNING)
						SetLog($Message, $COLOR_ACTION)
						Return False ; exit func if no planned
					EndIf
				EndIf
			Else
				Return False ; exit func if not planned
			EndIf
		Else
			If $g_bNotifyScheduleHoursEnable Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If Not $g_abNotifyScheduleHours[$hour[0]] Then
					SetLog("Notify not planned for this hour! Notification skipped", $COLOR_WARNING)
					SetLog($Message, $COLOR_ACTION)
					Return False ; exit func if no planned
				EndIf
			EndIf
		EndIf
	EndIf
	Return True
EndFunc   ;==>IsPlanUseTelegram

#Region - Discord - Team AIO Mod++
Func _HTTP_Upload_Discord($strUploadUrl = '', $strFilePath = '', $strFileField = '', $strDataPairs = '', $strFilename = Default)
    If $strFilename = Default Then $strFilename = StringMid($strFilePath, StringInStr($strFilePath, "\", 0, -1) + 1)

    Local $MULTIPART_BOUNDARY = "----WebKitFormBoundary"
    Local $aSpace[3]
    For $i = 1 To 16
        $aSpace[0] = Chr(Random(65, 90, 1)) ;A-Z
        $aSpace[1] = Chr(Random(97, 122, 1)) ;a-z
        $aSpace[2] = Chr(Random(48, 57, 1)) ;0-9
        $MULTIPART_BOUNDARY &= $aSpace[Random(0, 2, 1)]
    Next

    If Not FileExists($strFilePath) Then Return SetError(4, 0, 0)

    Local $h = FileOpen($strFilePath, $FO_BINARY)
    Local $bytFile = FileRead($h)
    FileClose($h)

    ; Create the multipart form data - Define the end of form
    Local $strFormEnd = @CRLF & "--" & $MULTIPART_BOUNDARY & "--" & @CRLF
    Local $strFormStart

    ; First add any ordinary form data pairs
    If $strDataPairs Then
        Local $split = StringSplit($strDataPairs, "&")
        Local $splitagain
        For $i = 1 To $split[0]
            $splitagain = StringSplit($split[$i], "=")
            $strFormStart &= "--" & $MULTIPART_BOUNDARY & @CRLF & _
                    "Content-Disposition: form-data; " & _
                    "name=""" & $splitagain[1] & """" & _
                    @CRLF & @CRLF & _
                    URLDecode($splitagain[2]) & @CRLF
        Next
    EndIf

    ; Now add the header for the uploaded file
    $strFormStart &= "--" & $MULTIPART_BOUNDARY & @CRLF & _
            "Content-Disposition: form-data; " & _
            "name=""" & $strFileField & """; " & _
            "filename=""" & $strFilename & """" & @CRLF & _
            "Content-Type: application/upload" & _ ; bogus, but it works
            @CRLF & @CRLF

    ; Now merge it all
    Local $bytFormData = StringToBinary($strFormStart) & $bytFile & StringToBinary($strFormEnd)

    ; Upload it
    Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
    $oHTTP.Open("POST", $strUploadUrl, False)
    If @error Then Return SetError(1, 0, 0)

    $oHTTP.SetRequestHeader("Content-Type", "multipart/form-data; boundary=" & $MULTIPART_BOUNDARY)
    $oHTTP.Send($bytFormData)
    If @error Then Return SetError(2, 0, 0)

    Local $sReceived = $oHTTP.ResponseText
    Local $iStatus = $oHTTP.Status
    If $iStatus = 200 Then Return $sReceived

    Return SetError(3, $iStatus, $sReceived)
EndFunc   ;==>_HTTP_Upload_Discord

Func URLDecode($urlText)
    $urlText = StringReplace($urlText, "+", " ")
    Local $matches = StringRegExp($urlText, "\%([abcdefABCDEF0-9]{2})", 3)
    If Not @error Then
        For $match In $matches
            $urlText = StringReplace($urlText, "%" & $match, BinaryToString('0x' & $match))
        Next
    EndIf
    Return $urlText
EndFunc   ;==>URLDecode

Func NotifyPushFileToDiscord($File, $Folder, $FileType, $body)

    If Not $g_bNotifyDSEnable Or $g_sNotifyDSToken = "" Then Return

    If Not IsPlanUseDiscord("Photo") Then Return

    If $g_bNotifyDSEnable And $g_sNotifyDSToken <> "" Then
        If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then
        _HTTP_Upload_Discord($g_sNotifyDSToken, ($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File), '', '', Default)
        EndIf
    EndIf

EndFunc   ;==>NotifyPushFileToDiscord

; ONLY PUSH DISCORD MSG
Func NotifyPushToDiscord($pMessage)

	SetDebugLog("NotifyPushToDiscord(" & $pMessage & " ): ")

	If Not $g_bNotifyDSEnable Or $g_sNotifyDSToken = "" Then Return False

	If Not IsPlanUseDiscord($pMessage) Then Return False

    Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
    Local $Time = @HOUR & '.' & @MIN
    Local $text = __WinHttpURLEncode($pMessage & chr(10) & $Date & ' ' & $Time)

    If $g_bNotifyDSEnable And $g_sNotifyDSToken <> "" Then
        $pMessage = StringReplace($pMessage, chr(10), "\n")
        SetDebugLog("NotifyPushToDiscord(" & $pMessage & " ): ")
        Local $sUrl = $g_sNotifyDSToken
        Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
        Local $sPacket = '{"content": "' & $pMessage & '"}'
        $oHTTP.open('POST',$sUrl)
        $oHTTP.setRequestHeader("Content-Type","application/json")
        $oHTTP.send($sPacket)
    EndIf
EndFunc   ;==>NotifyPushToDiscord

; CHECK IF WAS PLANNED TO USE DISCORD
Func IsPlanUseDiscord($Message)
	If Not $g_bNotifyForced And $Message <> "DeleteAllPBMessages" Then
		If $g_bNotifyScheduleWeekDaysEnableDS Then
			If $g_abNotifyScheduleWeekDaysDS[@WDAY - 1] Then
				If $g_bNotifyScheduleHoursEnableDS Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If Not $g_abNotifyScheduleHoursDS[$hour[0]] Then
						SetLog("Notify not planned for this hour! Notification skipped (DS)", $COLOR_WARNING)
						SetLog($Message, $COLOR_ACTION)
						Return False ; exit func if no planned
					EndIf
				EndIf
			Else
				Return False ; exit func if not planned
			EndIf
		Else
			If $g_bNotifyScheduleHoursEnableDS Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If Not $g_abNotifyScheduleHoursDS[$hour[0]] Then
					SetLog("Notify not planned for this hour! Notification skipped (DS)", $COLOR_WARNING)
					SetLog($Message, $COLOR_ACTION)
					Return False ; exit func if no planned
				EndIf
			EndIf
		EndIf
	EndIf
	Return True
EndFunc   ;==>IsPlanUseDiscord

#EndRegion - Discord - Team AIO Mod++

; ::: EXTRA TOOLS :::
; Checking the connection of the card to the Internet
Func _IsInternet()
	Local $Ret = DllCall('wininet.dll', 'int', 'InternetGetConnectedState', 'dword*', 0x20, 'dword', 0)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Local $Error = _WinAPI_GetLastError()
	Return SetError((Not ($Error = 0)), $Error, $Ret[0])
EndFunc   ;==>_IsInternet

; User's COM error function. Will be called if COM error occurs
Func __ErrFunc($oError)
	SetLog("COM Error intercepted !" & @CRLF & _
			"Scriptline is: " & $oError.scriptline & @CRLF & _
			"Number is: " & Hex($oError.number, 8) & @CRLF & _
			"Returncode is: " & Hex($oError.retcode, 8) & @CRLF & _
			"WinDescription is: " & $oError.windescription & @CRLF & _
			"Description is: " & $oError.description, $COLOR_RED)
EndFunc   ;==>__ErrFunc

Func __ObjEventIni()
	$g_oCOMErrorHandler = ObjEvent("AutoIt.Error", "__ErrFunc")
EndFunc   ;==>__ObjEventIni

Func __ObjEventEnds()
	$g_oCOMErrorHandler = 0
EndFunc   ;==>__ObjEventEnds

