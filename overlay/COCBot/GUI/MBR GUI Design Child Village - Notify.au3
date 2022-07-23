; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Notify" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017), Bolina (13/08/2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Discord - Team AIO Mod++
#include-once
Global $g_hGUI_NOTIFY = 0, $g_hGUI_NOTIFY_TAB = 0, $g_hGUI_NOTIFY_TAB_ITEM2 = 0, $g_hGUI_NOTIFY_TAB_ITEM3 = 0

Func CreateVillageNotify()
	$g_hGUI_NOTIFY = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)

	GUISwitch($g_hGUI_NOTIFY)
	$g_hGUI_NOTIFY_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, $WS_CLIPSIBLINGS)
	$g_hGUI_NOTIFY_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_05_STab_01_Mod", "Telegram"))
		CreateTelegramSubTab()
	GUICtrlCreateTabItem("")

	$g_hGUI_NOTIFY_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_05_STab_02_Mod", "Discord"))
		CreateDiscordSubTab()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageNotify

Global $g_hGrpNotifyDS = 0

Global $g_hChkNotifyDSEnable = 0, $g_hTxtNotifyDSToken = 0
Global $g_hChkNotifyRemoteDS = 0, $g_hTxtNotifyOriginDS = 0

Global $g_hChkNotifyAlertMatchFoundDS = 0, $g_hChkNotifyAlertLastRaidIMGDS = 0, $g_hChkNotifyAlertLastRaidTXTDS = 0, $g_hChkNotifyAlertCampFullDS = 0, _
	   $g_hChkNotifyAlertUpgradeWallsDS = 0, $g_hChkNotifyAlertOutOfSyncDS = 0, $g_hChkNotifyAlertTakeBreakDS = 0, $g_hChkNotifyAlertBuilderIdleDS = 0, _
	   $g_hChkNotifyAlertVillageStatsDS = 0, $g_hChkNotifyAlertLastAttackDS = 0, $g_hChkNotifyAlertAnotherDeviceDS = 0, $g_hChkNotifyAlertMaintenanceDS = 0, _
	   $g_hChkNotifyAlertBANDS = 0, $g_hChkNotifyBOTUpdateDS = 0, $g_hChkNotifyAlertSmartWaitTimeDS = 0, $g_hChkNotifyAlertLaboratoryIdleDS = 0, $g_hChkNotifyAlertPetHouseIdleDS = 0 ; Discord - Team AIO Mod++

Global $g_hChkNotifyOnlyHoursDS = 0, $g_hChkNotifyOnlyWeekDaysDS = 0, $g_hChkNotifyhoursDS[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], _
	   $g_hChkNotifyWeekdaysDS[7] = [0, 0, 0, 0, 0, 0, 0]

GLobal $g_hLblNotifyhourDS = 0, $g_ahLblNotifyhoursEDS = 0, $g_hChkNotifyhoursE1DS = 0, $g_hChkNotifyhoursE2DS = 0, $g_hLblNotifyhoursAMDS = 0, $g_hLblNotifyhoursPMDS = 0
GLobal $g_hLblNotifyhoursDS[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblNotifyWeekdaysDS[7] = [0, 0, 0, 0, 0, 0, 0], $g_ahLblNotifyWeekdaysEDS = 0, $g_ahChkNotifyWeekdaysEDS = 0 , $g_lblHepNotifyDS = 0


Func CreateDiscordSubTab()
	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	$g_hGrpNotifyDS = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "Group_01", "Discord Notify") & " " & $g_sNotifyVersion, $x - 20, $y - 20, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3)

		_GUICtrlCreateIcon ($g_sLibIconPath, $eIcnDiscord, $x + 3, $y, 32, 32)
		$g_hChkNotifyDSEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyDSEnable", "Enable Discord"), $x + 40, $y + 5)
			GUICtrlSetOnEvent(-1, "chkDSenabled")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyDSEnable_Info_01", "Enable Discord notifications"))

	$y += 40
	$x -= 10
        GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyDSToken", "Webhook URL") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$g_hTxtNotifyDSToken = _GUICtrlCreateInput($g_sNotifyDSToken, $x + 120, $y - 3, 280, 19)
            _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyDSToken_Info_01", "You need a Discord Webhook URL."))
            GUICtrlSetState(-1, $GUI_DISABLE)


	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "LblNotifyOrigin", "Origin") & ":", $x + 120, $y + 3, -1, -1, $SS_RIGHT)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "LblNotifyOrigin_Info_01", "Origin - Village name.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtNotifyOriginDS = _GUICtrlCreateInput("", $x + 170, $y, 230, 19)
			_GUICtrlSetTip(-1, $sTxtTip)
			
	$y += 25
		$g_hChkNotifyRemoteDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyRemoteDS", "Receive miscellaneous notifications including those from telegram."), $x + 10, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyRemote_InfoDS", "Receive miscellaneous notifications including those from telegram"))
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "LblNotifyOptions", "Send a Discord message for these options") & ":", $x, $y, -1, -1, $SS_RIGHT)

	$y += 15
		$g_hChkNotifyAlertMatchFoundDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertMatchFound", "Match Found"), $x + 10, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertMatchFound_Info_01", "Send the amount of available loot when bot finds a village to attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLastRaidIMGDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertLastRaidIMG", "Last raid as image"), $x + 100, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertLastRaidIMG_Info_01", "Send the last raid screenshot."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLastRaidTXTDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertLastRaidTXT", "Last raid as Text"), $x + 210, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertLastRaidTXT_Info_01", "Send the last raid results as text."))
		$g_hChkNotifyAlertCampFullDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertCampFull", "Army Camp Full"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertCampFull_Info_01", "Sent an Alert when your Army Camp is full."))
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 20
		$g_hChkNotifyAlertUpgradeWallsDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertUpgradeWall", "Wall upgrade"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertUpgradeWall_Info_01", "Send info about wall upgrades."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertOutOfSyncDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertOutOfSync", "Error: Out Of Sync"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertOutOfSync_Info_01", "Send an Alert when you get the Error: Client and Server out of sync"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertTakeBreakDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertTakeBreak", "Take a break"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertTakeBreak_Info_01", "Send an Alert when you have been playing for too long and your villagers need to rest."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertBuilderIdleDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertBuilderIdle", "Builder Idle"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertBuilderIdle_Info_01", "Send an Alert when at least one builder is idle."))
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 20
		$g_hChkNotifyAlertVillageStatsDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertVillageStats", "Village Report"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertVillageStats_Info_01", "Send a Village Report."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLastAttackDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertLastAttack", "Alert Last Attack"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertLastAttack_Info_01", "Send info about the Last Attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertAnotherDeviceDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertAnotherDevice", "Another device"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertAnotherDevice_Info_01", "Send an Alert when your village is connected to from another device."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertSmartWaitTimeDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertSmartWaitTime", "Smart Wait Time"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertSmartWaitTime_Info_02", "Send an Alert when your village take wait troops."))
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 20
		$g_hChkNotifyAlertMaintenanceDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertMaintenance", "Maintenance"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertMaintenance_Info_01", "Send an Alert when CoC is under maintenance by SuperCell"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertBANDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertBAN", "BAN"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertBAN_Info_01", "Send an Alert if your village was BANNED by SuperCell"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyBOTUpdateDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyBOTUpdate", "BOT Update"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyBOTUpdate_Info_01", "Send an Alert when there is a new version of the bot."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLaboratoryIdleDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertLaboratoryIdle", "Laboratory Idle"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "ChkNotifyAlertLaboratoryIdle_Info_01", "Send an Alert when the laboratory is idle."))
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 20
		$g_hChkNotifyAlertPetHouseIdleDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertPetHouseIdle", "Pet house Idle"), $x + 10, $y, -1, -1) ; Discord - Team AIO Mod++
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertPetHouseIdle_Info_01", "Send an Alert when the pet house is idle.")) ; Discord - Team AIO Mod++
			GUICtrlSetState(-1, $GUI_DISABLE) ; Discord - Team AIO Mod++
		; TODO

	$y += 25
		$g_hChkNotifyOnlyHoursDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", "Only during these hours of each day"), $x - 5, $y )
			GUICtrlSetOnEvent(-1, "chkNotifyHoursDS")

	$y += 25
		$g_hLblNotifyhourDS = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", "Hour") & ":", $x - 5, $y, -1, 15)
			$sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		For $i = 0 to 11
			$g_hLblNotifyhoursDS[$i] = GUICtrlCreateLabel(StringFormat("%2s", String($i)), $x + 30 + ( 15 * $i), $y)
		Next
		$g_ahLblNotifyhoursEDS = GUICtrlCreateLabel("X", $x + 214, $y + 1, 11, 11)
	$y += 15
		For $i = 0 to 11
			$g_hChkNotifyhoursDS[$i] = GUICtrlCreateCheckbox("", $x + 30 + (15 * $i), $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		Next
		$g_hChkNotifyhoursE1DS = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkNotifyhoursE1DS")
		$g_hLblNotifyhoursAMDS = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", -1), $x + 10, $y)
	$y += 15
		For $i = 12 to 23
			$g_hChkNotifyhoursDS[$i] = GUICtrlCreateCheckbox("", $x + 30 + (15 * ($i - 12)), $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		Next
		$g_hChkNotifyhoursE2DS = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkNotifyhoursE2DS")
		$g_hLblNotifyhoursPMDS = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", -1), $x + 10, $y)
	$y -= 55
	$x += 235
		$g_hChkNotifyOnlyWeekDaysDS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", "Only during these day of week"), $x - 40, $y )
			GUICtrlSetOnEvent(-1, "chkNotifyWeekDaysDS")
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Day", "Day") & ":", $x, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		$g_hLblNotifyWeekdaysDS[0] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Su", "Su"), $x + 30, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Sunday", "Sunday"))
		$g_hLblNotifyWeekdaysDS[1] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Mo", "Mo"), $x + 46, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Monday", "Monday"))
		$g_hLblNotifyWeekdaysDS[2] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Tu", "Tu"), $x + 62, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Tuesday", "Tuesday"))
		$g_hLblNotifyWeekdaysDS[3] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "We", "We"), $x + 80, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Wednesday", "Wednesday"))
		$g_hLblNotifyWeekdaysDS[4] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Th", "Th"), $x + 99, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Thursday", "Thursday"))
		$g_hLblNotifyWeekdaysDS[5] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Fr", "Fr"), $x + 116, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Friday", "Friday"))
		$g_hLblNotifyWeekdaysDS[6] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Sa", "Sa"), $x + 133, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Saturday", "Saturday"))
		$g_ahLblNotifyWeekdaysEDS = GUICtrlCreateLabel("X", $x + 155, $y + 1, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
	$y += 13
		For $i = 0 to 6
			$g_hChkNotifyWeekdaysDS[$i] = GUICtrlCreateCheckbox("", $x + 30 + (17 * $i), $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		Next
		$g_ahChkNotifyWeekdaysEDS = GUICtrlCreateCheckbox("", $x + 151, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "ChkNotifyWeekdaysEDS")
	$y += 18 
	$x = 15
		$g_lblHepNotifyDS = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "LblNotifyHelp", "Help ?"), $x + 310, $y , 100, 24, $SS_RIGHT)
			GUICtrlSetOnEvent($g_lblHepNotifyDS, "ShowControlHelp")
			GUICtrlSetCursor(-1, 0)
			GUICtrlSetFont(-1, 8.5, $FW_BOLD)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify - Discord", "LblNotifyHelp_Info_01", "Click here to get Help about Notify Remote commands to Discord"))
			GUICtrlSetColor(-1, $COLOR_NAVY)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateDiscordSubTab
#EndRegion - Discord - Team AIO Mod++

Global $g_hGrpNotify = 0

Global $g_hChkNotifyTGEnable = 0, $g_hTxtNotifyTGToken = 0
Global $g_hChkNotifyRemote = 0, $g_hTxtNotifyOrigin = 0

Global $g_hChkNotifyAlertMatchFound = 0, $g_hChkNotifyAlertLastRaidIMG = 0, $g_hChkNotifyAlertLastRaidTXT = 0, $g_hChkNotifyAlertCampFull = 0, _
	   $g_hChkNotifyAlertUpgradeWall = 0, $g_hChkNotifyAlertOutOfSync = 0, $g_hChkNotifyAlertTakeBreak = 0, $g_hChkNotifyAlertBuilderIdle = 0, _
	   $g_hChkNotifyAlertVillageStats = 0, $g_hChkNotifyAlertLastAttack = 0, $g_hChkNotifyAlertAnotherDevice = 0, $g_hChkNotifyAlertMaintenance = 0, _
	   $g_hChkNotifyAlertBAN = 0, $g_hChkNotifyBOTUpdate = 0, $g_hChkNotifyAlertSmartWaitTime = 0, $g_hChkNotifyAlertLaboratoryIdle = 0, $g_hChkNotifyAlertPetHouseIdle = 0 ; Discord - Team AIO Mod++

Global $g_hChkNotifyOnlyHours = 0, $g_hChkNotifyOnlyWeekDays = 0, $g_hChkNotifyhours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], _
	   $g_hChkNotifyWeekdays[7] = [0, 0, 0, 0, 0, 0, 0]

GLobal $g_hLblNotifyhour = 0, $g_ahLblNotifyhoursE = 0, $g_hChkNotifyhoursE1 = 0, $g_hChkNotifyhoursE2 = 0, $g_hLblNotifyhoursAM = 0, $g_hLblNotifyhoursPM = 0
GLobal $g_hLblNotifyhours[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblNotifyWeekdays[7] = [0, 0, 0, 0, 0, 0, 0], $g_ahLblNotifyWeekdaysE = 0, $g_ahChkNotifyWeekdaysE = 0 , $g_lblHepNotify = 0

Func CreateTelegramSubTab()
	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	$g_hGrpNotify = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "Group_01", "Telegram Notify") & " " & $g_sNotifyVersion, $x - 20, $y - 20, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3)

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTelegram, $x + 3, $y, 32, 32)
		$g_hChkNotifyTGEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyTGEnable", "Enable Telegram"), $x + 40, $y + 5)
			GUICtrlSetOnEvent(-1, "chkPBTGenabled")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyTGEnable_Info_01", "Enable Telegram notifications"))

	$y += 40
	$x -= 10
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyTGToken", "Token (Telegram)") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$g_hTxtNotifyTGToken = _GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyTGToken_Info_01", "You need a Token to use Telegram notifications. Get a token from Telegram.com"))
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 25
		$g_hChkNotifyRemote = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyRemote", "Remote Control"), $x + 10, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyRemote_Info_01", "Enables Telegram Remote function"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyOrigin", "Origin") & ":", $x + 120, $y + 3, -1, -1, $SS_RIGHT)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyOrigin_Info_01", "Origin - Village name.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtNotifyOrigin = _GUICtrlCreateInput("", $x + 170, $y, 230, 19)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyOptions", "Send a Telegram message for these options") & ":", $x, $y, -1, -1, $SS_RIGHT)

	$y += 15
		$g_hChkNotifyAlertMatchFound = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertMatchFound", "Match Found"), $x + 10, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertMatchFound_Info_01", "Send the amount of available loot when bot finds a village to attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLastRaidIMG = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertLastRaidIMG", "Last raid as image"), $x + 100, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertLastRaidIMG_Info_01", "Send the last raid screenshot."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLastRaidTXT = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertLastRaidTXT", "Last raid as Text"), $x + 210, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertLastRaidTXT_Info_01", "Send the last raid results as text."))
		$g_hChkNotifyAlertCampFull = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertCampFull", "Army Camp Full"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertCampFull_Info_01", "Sent an Alert when your Army Camp is full."))
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 20
		$g_hChkNotifyAlertUpgradeWall = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertUpgradeWall", "Wall upgrade"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertUpgradeWall_Info_01", "Send info about wall upgrades."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertOutOfSync = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertOutOfSync", "Error: Out Of Sync"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertOutOfSync_Info_01", "Send an Alert when you get the Error: Client and Server out of sync"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertTakeBreak = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertTakeBreak", "Take a break"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertTakeBreak_Info_01", "Send an Alert when you have been playing for too long and your villagers need to rest."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertBuilderIdle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertBuilderIdle", "Builder Idle"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertBuilderIdle_Info_01", "Send an Alert when at least one builder is idle."))
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 20
		$g_hChkNotifyAlertVillageStats = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertVillageStats", "Village Report"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertVillageStats_Info_01", "Send a Village Report."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLastAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertLastAttack", "Alert Last Attack"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertLastAttack_Info_01", "Send info about the Last Attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertAnotherDevice = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertAnotherDevice", "Another device"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertAnotherDevice_Info_01", "Send an Alert when your village is connected to from another device."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertSmartWaitTime = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertSmartWaitTime", "Smart Wait Time"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertSmartWaitTime_Info_02", "Send an Alert when your village take wait troops."))
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 20
		$g_hChkNotifyAlertMaintenance = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertMaintenance", "Maintenance"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertMaintenance_Info_01", "Send an Alert when CoC is under maintenance by SuperCell"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertBAN = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertBAN", "BAN"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertBAN_Info_01", "Send an Alert if your village was BANNED by SuperCell"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyBOTUpdate = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyBOTUpdate", "BOT Update"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyBOTUpdate_Info_01", "Send an Alert when there is a new version of the bot."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLaboratoryIdle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertLaboratoryIdle", "Laboratory Idle"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertLaboratoryIdle_Info_01", "Send an Alert when the laboratory is idle."))
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 20
		$g_hChkNotifyAlertPetHouseIdle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertPetHouseIdle", "Pet house Idle"), $x + 10, $y, -1, -1) ; Discord - Team AIO Mod++
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyAlertPetHouseIdle_Info_01", "Send an Alert when the pet house is idle.")) ; Discord - Team AIO Mod++
			GUICtrlSetState(-1, $GUI_DISABLE) ; Discord - Team AIO Mod++
		; TODO

	$y += 25  ; Discord - Team AIO Mod++
		$g_hChkNotifyOnlyHours = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", "Only during these hours of each day"), $x - 5, $y )
			GUICtrlSetOnEvent(-1, "chkNotifyHours")
	; $x += 59  ; Discord - Team AIO Mod++
	$y += 25
		$g_hLblNotifyhour = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", "Hour") & ":", $x - 5, $y, -1, 15)   ; Discord - Team AIO Mod++
			$sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		For $i = 0 to 11
			$g_hLblNotifyhours[$i] = GUICtrlCreateLabel(StringFormat("%2s", String($i)), $x + 30 + ( 15 * $i), $y)
		Next
		$g_ahLblNotifyhoursE = GUICtrlCreateLabel("X", $x + 214, $y + 1, 11, 11)
	$y += 15
		For $i = 0 to 11
			$g_hChkNotifyhours[$i] = GUICtrlCreateCheckbox("", $x + 30 + (15 * $i), $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		Next
		$g_hChkNotifyhoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkNotifyhoursE1")
		$g_hLblNotifyhoursAM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", -1), $x + 5, $y)
	$y += 15
		For $i = 12 to 23
			$g_hChkNotifyhours[$i] = GUICtrlCreateCheckbox("", $x + 30 + (15 * ($i - 12)), $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		Next
		$g_hChkNotifyhoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkNotifyhoursE2")
		$g_hLblNotifyhoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", -1), $x + 10, $y)
	$y -= 55 ; Discord - Team AIO Mod++
	$x += 235 ; Discord - Team AIO Mod++
		$g_hChkNotifyOnlyWeekDays = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", "Only during these day of week"), $x - 40, $y ) ; Discord - Team AIO Mod++
			GUICtrlSetOnEvent(-1, "chkNotifyWeekDays")
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Day", "Day") & ":", $x, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		$g_hLblNotifyWeekdays[0] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Su", "Su"), $x + 30, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Sunday", "Sunday"))
		$g_hLblNotifyWeekdays[1] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Mo", "Mo"), $x + 46, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Monday", "Monday"))
		$g_hLblNotifyWeekdays[2] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Tu", "Tu"), $x + 62, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Tuesday", "Tuesday"))
		$g_hLblNotifyWeekdays[3] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "We", "We"), $x + 80, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Wednesday", "Wednesday"))
		$g_hLblNotifyWeekdays[4] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Th", "Th"), $x + 99, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Thursday", "Thursday"))
		$g_hLblNotifyWeekdays[5] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Fr", "Fr"), $x + 116, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Friday", "Friday"))
		$g_hLblNotifyWeekdays[6] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Sa", "Sa"), $x + 133, $y)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Saturday", "Saturday"))
		$g_ahLblNotifyWeekdaysE = GUICtrlCreateLabel("X", $x + 155, $y + 1, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
	$y += 13
		For $i = 0 to 6
			$g_hChkNotifyWeekdays[$i] = GUICtrlCreateCheckbox("", $x + 30 + (17 * $i), $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		Next
		$g_ahChkNotifyWeekdaysE = GUICtrlCreateCheckbox("", $x + 151, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "ChkNotifyWeekdaysE")
	$y += 15
	$x = 15
		$g_lblHepNotify = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyHelp", "Help ?"), $x + 310, $y , 100, 24, $SS_RIGHT)
			GUICtrlSetOnEvent($g_lblHepNotify, "ShowControlHelp")
			GUICtrlSetCursor(-1, 0)
			GUICtrlSetFont(-1, 8.5, $FW_BOLD)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyHelp_Info_01", "Click here to get Help about Notify Remote commands to Telegram"))
			GUICtrlSetColor(-1, $COLOR_NAVY)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateDiscordTelegramSubTab
