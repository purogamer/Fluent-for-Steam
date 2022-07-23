; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Options" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hCmbGUILanguage = 0
Global $g_hChkDisableSplash = 0, $g_hChkForMBRUpdates = 0, $g_hChkDeleteLogs = 0, $g_hTxtDeleteLogsDays = 0, $g_hChkDeleteTemp = 0, $g_hTxtDeleteTempDays = 0, _
	   $g_hChkDeleteLoots = 0, $g_hTxtDeleteLootsDays = 0
Global $g_hChkAutostart = 0, $g_hTxtAutostartDelay = 0, $g_hChkCheckGameLanguage = 0, $g_hChkAutoAlign = 0, $g_hTxtAlignOffsetX = 0, $g_hTxtAlignOffsetY = 0, _
	   $g_hCmbAlignmentOptions = 0
Global $g_hTxtGlobalActiveBotsAllowed = 0, $g_hTxtGlobalThreads = 0, $g_hTxtThreads = 0
;Global $g_hChkUpdatingWhenMinimized = 0
Global $g_hChkBotCustomTitleBarClick = 0, $g_hChkBotAutoSlideClick = 0, $g_hChkHideWhenMinimized = 0, $g_hChkUseRandomClick = 0, $g_hChkScreenshotType = 0, _
	   $g_hChkScreenshotHideName = 0, $g_hTxtTimeAnotherDevice = 0
Global $g_hChkSinglePBTForced = 0, $g_hTxtSinglePBTimeForced = 0, $g_hTxtPBTimeForcedExit = 0, $g_hChkFixClanCastle = 0, $g_hChkAutoResume = 0, $g_hTxtAutoResumeTime = 0, $g_hChkDisableNotifications = 0
Global $g_hChkSqlite = 0
Global $g_hBtnExportData = 0

; Auto Dock, Hide Emulator & Bot - Team AiO MOD++
Global $g_hChkEnableAuto = 0, $g_hChkAutoDock = 0, $g_hChkAutoHideEmulator = 0, $g_hChkAutoMinimizeBot = 0

Func CreateBotOptions()

	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "Group_01", "GUI Language"), $x - 20, $y - 20, 210, 47)
		$y -= 2
		$g_hCmbGUILanguage = _GUICtrlComboBoxEx_Create($g_hGUI_BOT, "", $x - 8, $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		_GUICtrlSetTip(_GUICtrlComboBoxEx_GetComboControl($g_hCmbGUILanguage), GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbGUILanguage_Info_01", "Use this to switch to a different GUI language"), Default, Default, Default, False)

		LoadLanguagesComboBox() ; full combo box languages reading from languages folders
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 54
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "Group_02", "When Bot Loads"), $x - 20, $y - 20, 210, 141) ; AIO Updater - Team AIO Mod++
	$y -= 4
		$g_hChkDisableSplash = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDisableSplash", "Disable Splash Screen"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDisableSplash_Info_01", "Disables the splash screen on startup."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 20
		$g_hChkForMBRUpdates = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkForMBRUpdates", "Check for Updates"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkForMBRUpdates_Info_01", "Check if you are running the latest version of the bot."))
			GUICtrlSetState(-1, $GUI_CHECKED)
	
	#Region - AIO Updater - Team AIO Mod++
	$y += 20
		$g_hChkForAIOUpdates = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkForAIOUpdates", "Check for AIO Updates"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkForAIOUpdates_Info_01", "Check if you are running the latest version of the AIO Mod."))
			GUICtrlSetState(-1, $GUI_CHECKED)
	#EndRegion - AIO Updater - Team AIO Mod++

	$y += 20
		$g_hChkDeleteLogs = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDeleteLogs", "Delete Log Files")& ":", $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDeleteLogs_Info_01", "Delete log files older than this specified No. of days.")
			GUICtrlSetState(-1, $GUI_CHECKED)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkDeleteLogs")
		$g_hTxtDeleteLogsDays = _GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "days", "days"), $x + 150, $y + 4, 27, 15)

	$y += 20
		$g_hChkDeleteTemp = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDeleteTemp", "Delete Temp Files") & ":", $x, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_CHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDeleteTemp_Info_01", "Delete temp files older than this specified No. of days."))
			GUICtrlSetOnEvent(-1, "chkDeleteTemp")
		$g_hTxtDeleteTempDays = _GUICtrlCreateInput("5", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "days", -1), $x + 150, $y + 4, 27, 15)

	$y += 20
		$g_hChkDeleteLoots = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDeleteLoots", "Delete Loot Images") & ":", $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDeleteLoots_Info_01", "Delete loot image files older than this specified No. of days.")
			GUICtrlSetState(-1, $GUI_CHECKED)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkDeleteLoots")
		$g_hTxtDeleteLootsDays = _GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "days", -1), $x + 150, $y + 4, 27, 15)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 48
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "Group_03", "When Bot Starts"), $x - 20, $y - 20, 210, 112)
	$y -= 5
		$g_hChkAutostart = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkAutostart", "Auto START after") & ":", $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkAutostart_Info_01", "Auto START the Bot after this No. of seconds."))
			GUICtrlSetOnEvent(-1, "chkAutostart")
		$g_hTxtAutostartDelay = _GUICtrlCreateInput("10", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 150, $y + 4, 27, 18)

	$y += 22
		$g_hChkCheckGameLanguage = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkCheckGameLanguage", "Check Game Language (EN)"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkCheckGameLanguage_Info_01", "Check if the Game is set to the correct language (Must be set to English)."))
			GUICtrlSetState(-1, $GUI_CHECKED)

	$y += 22
		$g_hChkAutoAlign = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkAutoAlign", "Auto Align"), $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkAutoAlign_Info_01", "Reposition/Align Android Emulator and BOT windows on the screen.")
			GUICtrlSetOnEvent(-1, "chkDisposeWindows")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "LblAlignOffsetX", "Offset") & ":", $x + 60, $y + 4, 48, -1, $SS_RIGHT)
		$g_hTxtAlignOffsetX = _GUICtrlCreateInput("", $x + 110, $y + 2, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "TxtAlignOffsetX_Info_01", "Offset horizontal pixels between Android Emulator and BOT windows.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 4)
		$g_hTxtAlignOffsetY= _GUICtrlCreateInput("", $x + 145, $y + 2, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "TxtAlignOffsetY_Info_01", "Offset vertical pixels between Android Emulator and BOT windows.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 4)

	$y += 23
		$g_hCmbAlignmentOptions = GUICtrlCreateCombo("", $x, $y, 175, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Item_01", "0,0: Android Emulator-Bot") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Item_02", "0,0: Bot-Android Emulator") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Item_03", "SNAP: Bot TopRight to Android") &"|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Item_04", "SNAP: Bot TopLeft to Android") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Item_05", "SNAP: Bot BottomRight to Android") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Item_06", "SNAP: Bot BottomLeft to Android") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Item_07", "DOCK: Android into Bot"), GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Item_07", -1))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Info_01", "0,0: Reposition Android Emulator screen to position 0,0 on windows desktop and align Bot window right or left to it.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "CmbAlignmentOptions_Info_02", "SNAP: Only reorder windows, Align Bot window to Android Emulator window at Top Right, Top Left, Bottom Right or Bottom Left.\r\n" & _
													"DOCK: Integrate Android Screen into bot window."))
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 52
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "Group_08", "Processor/Thread Advanced"), $x - 20, $y - 20, 210, 85)
	$y -= 2
		$g_hTxtGlobalActiveBotsAllowed = _GUICtrlCreateInput($g_iGlobalActiveBotsAllowed, $x, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "TxtGlobalActiveBotsAllowed_Info_01", "When running multiple bots, specify how many can run at the same time.\r\nThis reduces your CPU utilization significantly.\r\nHalf of available logical processors is a good number.\r\nThis configuration is shared across all profiles/instances and a restart of all bots is required (close all, wait, and start all again!).")
			GUICtrlSetOnEvent(-1, "txtGlobalActiveBotsAllowed")
			GUICtrlSetLimit(-1, 2)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "LblGlobalActiveBotsAllowed_Info_01", "Bots can run at the same time"), $x + 30, $y + 3)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 20
		$g_hTxtGlobalThreads = _GUICtrlCreateInput($g_iGlobalThreads, $x, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "TxtGlobalThreads_Info_01", "When running multiple bots, specify how many global threads for image processing tasks can run at the same time.\r\nThis reduces your CPU utilization significantly.\r\nHalf of available logical processors is a good number.\r\nThis configuration is shared across all profiles/instances and a restart of all bots is required (close all, wait, and start all again!).")
			GUICtrlSetOnEvent(-1, "txtGlobalThreads")
			GUICtrlSetLimit(-1, 2)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "LblGlobalThreads_Info_01", "Image Threads for all bots"), $x + 30, $y + 3)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 20
		$g_hTxtThreads = _GUICtrlCreateInput($g_iThreads, $x, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "TxtThreads_Info_01", "When images are processed, multiple threads are used. Here you specifiy how many threads this bot can use.\r\nLess threads reduce your CPU utilization significantly.\r\nHalf of available logical processors is a good number. Use 0 for all available. Global threads setting has priority.")
			GUICtrlSetOnEvent(-1, "txtThreads")
			GUICtrlSetLimit(-1, 2)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "LblThreads_Info_01", "Image Threads for this bot"), $x + 30, $y + 3)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 240, $y = 45, $yGroup = $y
	Local $hGroup = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "Group_04", "Advanced"), $x - 20, $y - 20, 225, 140)
		#cs
		$g_hChkUpdatingWhenMinimized = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkUpdatingWhenMinimized", "Updating when minimized"), $x, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE) ; must be always enabled
			GUICtrlSetOnEvent(-1, "chkUpdatingWhenMinimized")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkUpdatingWhenMinimized_Info_01", "Enable different minimize routine for bot window.\r\nWhen bot is minimized, screen updates are shown in taskbar preview."))
		$y += 19
		#ce
		$g_hChkBotCustomTitleBarClick = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkBotCustomTitleBarClick", "MyBot Design Title Bar"), $x, $y, -1, -1)
			If BitAND($g_iBotDesignFlags, 1) Then GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkBotCustomTitleBarClick")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkBotCustomTitleBarClick_Info_01", "Enable optimized My Bot Window Title Bar and\r\nthin Window Border (restart of bot is required)"))
	$y += 19
		$g_hChkBotAutoSlideClick = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkBotAutoSlideClick", "Auto Slide when docked"), $x, $y, -1, -1)
			If BitAND($g_iBotDesignFlags, 1) = 0 Then GUICtrlSetState(-1, $GUI_DISABLE)
			If BitAND($g_iBotDesignFlags, 2) Then GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkBotAutoSlideClick")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkBotAutoSlideClick_Info_01", "Enable auto sliding when Android is docked\r\non bot window activation/deactivation"))
	$y += 19
		$g_hChkHideWhenMinimized = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkHideWhenMinimized", "Hide when minimized"), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkHideWhenMinimized")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkHideWhenMinimized_Info_01", "Hide bot window in taskbar when minimized.\r\nUse trayicon 'Show bot' to display bot window again."))
	$y += 19
		$g_hChkAutoResume = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkAutoResume", "Auto resume Bot after") & ":", $x, $y, -1, -1)
			_GUICtrlSetTip(-1,GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkAutoResume_Info_01", "This will auto resume your bot after x minutes"))
			GUICtrlSetOnEvent(-1, "chkAutoResume")
		$g_hTxtAutoResumeTime = _GUICtrlCreateInput("5",$x + 132, $y + 2, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "min.", -1), $x + 167, $y + 4, -1, -1)
	$y += 19
		$g_hChkDisableNotifications = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDisableNotifications", "Disable Notifications"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1,GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkDisableNotifications_Info_01", "Disable Notifications sent by the Bot"))
			GUICtrlSetOnEvent(-1, "chkDisableNotifications")
	$y += 19
		$g_hChkUseRandomClick = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkUseRandomClick", "Random Click"), $x, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkUseRandomClick")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "Group_05", "Photo Screenshot Options"), $x - 20, $y - 17, 225, 60)
		$g_hChkScreenshotType = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkScreenshotType", "Make in PNG format"), $x, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkScreenshotType")
	$y += 19
		$g_hChkScreenshotHideName = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkScreenshotHideName", "Hide Village and Clan Castle Name"), $x, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkScreenshotHideName")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 48
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "Group_06", "Remote Device"), $x - 20, $y - 20 , 225, 42)
	$y -= 5
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "LblTimeAnotherDevice", "When 'Another Device' wait") & ":", $x - 10, $y + 2, -1, -1)
		$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "LblTimeAnotherDevice_Info_01", "Enter the time to wait (in Minutes) before the Bot reconnects when another device took control.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtTimeAnotherDevice = _GUICtrlCreateInput("2", $x + 132, $y, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "min.", -1), $x + 167, $y + 2, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 51
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "Group_07", "Other Options"), $x - 20, $y - 20, 225, 122)
		$g_hChkSinglePBTForced = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkSinglePBTForced", "Force Single PB logoff"), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkSinglePBTForced")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkSinglePBTForced_Info_01", "This forces bot to exit CoC only one time prior to normal start of PB"))
		$g_hTxtSinglePBTimeForced = _GUICtrlCreateInput("18", $x + 132, $y + 2, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "TxtSinglePBTimeForced_Info_01", "Type in number of minutes to keep CoC closed. Set to 15 minimum to reset PB timer!"))
			GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "min.", -1), $x + 167, $y + 4, -1, -1)

	$y += 20
		GUICtrlCreateLabel( GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "LblPBTimeForcedExit", "Subtract time for early PB exit"), $x - 10, $y + 3)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "LblPBTimeForcedExit_Info_01", "Type in number of minutes to quit CoC early! Setting below 10 minutes may not function!")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtPBTimeForcedExit = _GUICtrlCreateInput("16", $x + 132, $y, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "min.", -1), $x + 167, $y + 3, -1, -1)

	$y += 20
		$g_hChkFixClanCastle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkFixClanCastle", "Force Clan Castle Detection"), $x, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkFixClanCastle_Info_01", "If clan Castle it is undetected and it is NOT placed in the last slot, force bot to consider the undetected slot as Clan Castle"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 20
		$g_hChkSqlite = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkSqlite", "Use SQLite for statistics"), $x, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkSqlite_Info_01", "Will collect data from attacks to SQlite, exporting to CSV.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "ChkSqlite_Info_02", "Excellent to use with Smart-Farm, to collect sides, resources inside and outside, etc."))
			GUICtrlSetOnEvent(-1, "chkSQLite")
			GUICtrlSetState(-1, $GUI_UNCHECKED)

		$g_hBtnExportData = GUICtrlCreateButton( GetTranslatedFileIni("MBR GUI Design Child Bot - Options", "BtnExportData", "ExportData"), $x + 137 , $y + 14)
			GUICtrlSetOnEvent(-1, "SQLiteExport")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBotOptions
