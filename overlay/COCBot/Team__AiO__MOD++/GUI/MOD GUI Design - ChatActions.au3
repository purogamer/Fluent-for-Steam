; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - ChatActions
; Description ...: Design sub gui for ChatActions
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Boduloz & NguyenAnhHD
; Modified ......: Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkClanChat = 0, $g_hChkUseResponses = 0, $g_hChkUseGeneric = 0, $g_hTxtDelayTimeClan = 0, $g_hTxtEditResponses = 0, $g_hTxtEditGeneric = 0, $g_hLblEditResponses = 0, $g_hLblEditGeneric = 0;, $g_hChkCleverbot = 0

Global $g_hChkEnableFriendlyChallenge = 0, $g_hChkOnlyOnRequest = 0, $g_hChkFriendlyChallengeBase[6] = [0, 0, 0, 0, 0, 0], _
	$g_hTxtDelayTimeFC = 0, $g_hTxtChallengeText = 0, $g_hTxtKeywordForRequest = 0, $g_hLblChallengeText = 0, $g_hLblKeywordForRequest = 0

Global $g_hLblFriendlyChallengeHours[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahChkFriendlyChallengeHours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkFriendlyChallengeHoursE1 = 0, $g_hChkFriendlyChallengeHoursE2 = 0, _
	$g_hLblChatActionsOnlyDuringHours = 0, $g_ahLblFriendlyChallengeHoursE = 0, $g_hLblFriendlyChallengeHoursAM = 0, $g_hLblFriendlyChallengeHoursPM = 0

Global $g_hChkChatNotify = 0, $g_hChkPbSendNewChats = 0

Global $g_hCmbPriorityCHAT = 0, $g_hCmbPriorityFC = 0

Global $g_hChkHarangueCG = 0

Func TabChatActionsGUI()
	ChatbotReadSettings()

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - ChatActions", "Group_02", "Clan Chat"), $x - 20, $y - 20, $g_iSizeWGrpTab2 - 1, 118)
	$x -= 10
	$y -= 10

		GUICtrlCreateLabel("Frequency :", $x, $y + 4, 60, 17)
		$g_hCmbPriorityCHAT = GUICtrlCreateCombo("", $x + 120, $y, 89, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain))
			_GUICtrlComboBox_SetCurSel($g_hCmbPriorityCHAT, 0)
		GUICtrlSetOnEvent(-1, "cmbChatActionsChat")
        GUICtrlCreateLabel("Use each ... minutes :", $x + 272, $y + 4, 107, 17)
		$g_hTxtDelayTimeClan = _GUICtrlCreateInput("2", $x + 400, $y, 25, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "TxtDelayTime_Info_01", "Time to wait after use."))
			GUICtrlSetLimit(-1, 2)

	$y += 23
		$g_hChkUseResponses = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkUseResponses", "Response"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkUseResponses_Info_01", "Use the keywords and responses defined below"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkUseResponses")

	$y += 20
		$g_hChkUseGeneric = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkUseGeneric", "Generic chats"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkUseGeneric_Info_01", "Use generic chats if reading the latest chat failed or there are no new chats."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkUseGeneric")
	$y += 20
		$g_hChkHarangueCG = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkHarangueCG", "Only in clan games"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkHarangueCG_Info_01", "You are not a populist, use this to harangue others (lazy players) to") & @CRLF & _
			GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkHarangueCG_Info_02", "do clan games now you can be in your pool while others suffer."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkUseGeneric")
	$y += 20
	#cs
		$g_hChkCleverbot = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkCleverbot", "Cleverbot"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkCleverbot_Info_01", "Enabele on this function to communicate Cleverbot with your clan"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
	#ce
	$y -= 55
	$x += 120
		$g_hLblEditResponses = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - ChatActions", "EditResponses", "Responses Messages"), $x + 2, $y, -1, -1)
		$g_hTxtEditResponses = GUICtrlCreateEdit(_ArrayToString($g_aClanResponses, ":", -1, -1, @CRLF), $x, $y + 15, 150, 57, BitOR($GUI_SS_DEFAULT_EDIT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "EditResponses_Info_01", "Look for the specified keywords in clan messages and respond with the responses. One item per line, in the format keyword:response"))
			GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")

		$g_hLblEditGeneric = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - ChatActions", "EditGeneric", "Generic Messages"), $x + 159, $y, -1, -1)
		$g_hTxtEditGeneric = GUICtrlCreateEdit(_ArrayToString($g_aClanGeneric, @CRLF), $x + 157, $y + 15, 150, 57, BitOR($GUI_SS_DEFAULT_EDIT, $ES_CENTER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "EditGeneric_Info_01", "Generic messages to send, one per line"))
			GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 25, $y = 165
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - ChatActions", "Group_03", "Friend Challenge"), $x - 20, $y - 20, $g_iSizeWGrpTab2 - 1, 117)
	$x -= 10
	$y -= 5
		GUICtrlCreateLabel("Frequency :", $x, $y + 4, 60, 17)
		$g_hCmbPriorityFC = GUICtrlCreateCombo("", $x + 120, $y, 89, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", -1))
			_GUICtrlComboBox_SetCurSel($g_hCmbPriorityFC, 0)
		GUICtrlSetOnEvent(-1, "cmbChatActionsFC")
        GUICtrlCreateLabel("Use each ... minutes :", $x + 272, $y + 4, 107, 17)
		$g_hTxtDelayTimeFC = _GUICtrlCreateInput("5", $x + 400, $y, 25, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "TxtDelayTime_Info_01", "Time to wait after use."))
			GUICtrlSetLimit(-1, 2)


	$y += 20
		$g_hChkOnlyOnRequest = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkOnlyOnRequest", "Cond. in chat"), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkOnlyOnRequest")
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - ChatActions", "LblFriendlyChallengeBase_01", "Village Base:"), $x, $y, -1, 12)
		GUICtrlSetFont(-1, 7)
	$y += 12
		$g_hChkFriendlyChallengeBase[0] = GUICtrlCreateCheckbox("1", $x + 25, $y, -1, 15)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkFriendlyChallengeBase[1] = GUICtrlCreateCheckbox("2", $x + 55, $y, -1, 15)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkFriendlyChallengeBase[2] = GUICtrlCreateCheckbox("3", $x + 85, $y, -1, 15)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
	$y += 16
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - ChatActions", "LblFriendlyChallengeBase_02", "War Base:"), $x, $y, -1, 12)
		GUICtrlSetFont(-1, 7)
	$y += 12
		$g_hChkFriendlyChallengeBase[3] = GUICtrlCreateCheckbox("4", $x + 25, $y, -1, 15)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkFriendlyChallengeBase[4] = GUICtrlCreateCheckbox("5", $x + 55, $y, -1, 15)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkFriendlyChallengeBase[5] = GUICtrlCreateCheckbox("6", $x + 85, $y, -1, 15)
		GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y -= 57
	$x += 120
		$g_hLblChallengeText = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - ChatActions", "LblChallengeText", "Challenge Text"), $x + 2, $y, -1, -1)
		$g_hTxtChallengeText = GUICtrlCreateEdit(_ArrayToString($g_aChallengeText, @CRLF), $x, $y + 15, 150, 57, BitOR($ES_WANTRETURN, $ES_CENTER))
			GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")

		$g_hLblKeywordForRequest = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - ChatActions", "LblKeywordForRequest", "Keyword For Request"), $x + 159, $y, -1, -1)
		$g_hTxtKeywordForRequest = GUICtrlCreateEdit(_ArrayToString($g_aKeywordFcRequest, @CRLF), $x + 157, $y + 15, 150, 57, BitOR($ES_WANTRETURN, $ES_CENTER))
			GUICtrlSetOnEvent(-1, "ChatGuiEditUpdate")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 25, $y = 284
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - ChatActions", "Group_04", "Only in hours"), $x - 20, $y - 20, $g_iSizeWGrpTab2 - 151, 67)
	$x -= 10
	$y -= 6
		$g_hLblChatActionsOnlyDuringHours = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", -1) & ":", $x, $y, -1, 15)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1))
		$g_hLblFriendlyChallengeHours[0] = GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[10] = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
		$g_hLblFriendlyChallengeHours[11] = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
		$g_ahLblFriendlyChallengeHoursE = GUICtrlCreateLabel("X", $x + 213, $y, 11, 11)

	$y += 15
		$g_ahChkFriendlyChallengeHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_hChkFriendlyChallengeHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkFriendlyChallengeHoursE1")
		$g_hLblFriendlyChallengeHoursAM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", -1), $x + 5, $y)

	$y += 15
		$g_ahChkFriendlyChallengeHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_ahChkFriendlyChallengeHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_hChkFriendlyChallengeHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkFriendlyChallengeHoursE2")
		$g_hLblFriendlyChallengeHoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", -1), $x + 5, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 324, $y = 284
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - ChatActions", "Group_05", "Remote chat"), $x - 20, $y - 20, $g_iSizeWGrpTab2 - 300, 67)
	$x -= 10
		$g_hChkChatNotify = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkChatNotify", "Remote chatting"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkChatNotify_Info_01", "Send and recieve chats via telegram.") & @CRLF & _
					GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkChatNotify_Info_02", "Use BOT <myvillage> GETCHATS <interval|NOW|STOP> to get the latest clan") & @CRLF & _
					GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkChatNotify_Info_03", "chat as an image, and BOT <myvillage> SENDCHAT <chat message> to send a chat to your clan"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

		$g_hChkPbSendNewChats = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkPbSendNewChats", "Notify me chat"), $x, $y + 20, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkPbSendNewChats_Info_01", "Will send an image of your clan chat via telegram when a new chat is detected.") & @CRLF & _
					GetTranslatedFileIni("MOD GUI Design - ChatActions", "ChkPbSendNewChats_Info_02", "Not guaranteed to be 100% accurate."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
	$x -= 300 + 8
	$y += 40 + 8
	_GUICtrlCreatePic($g_sIcnChatAction, $x, $y, 438, 100)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>TabChatActionsGUI
