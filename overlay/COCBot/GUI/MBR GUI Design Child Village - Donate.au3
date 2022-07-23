; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Req. & Donate" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (07-2016), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DONATE = 0, $g_hGUI_DONATE_TAB = 0, $g_hGUI_DONATE_TAB_ITEM1 = 0, $g_hGUI_DONATE_TAB_ITEM2 = 0, $g_hGUI_DONATE_TAB_ITEM3 = 0, $g_hGUI_DONATE_TAB_ITEM4 = 0

; Request
Global $g_hChkRequestTroopsEnable = 0, $g_hTxtRequestCC = 0, $g_ahChkRequestCCHours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkRequestCCHoursE1 = 0, $g_hChkRequestCCHoursE2 = 0
Global $g_hGrpRequestCC = 0, $g_hLblRequestCCHoursAM = 0, $g_hLblRequestCCHoursPM = 0, $g_hGrpRequestCCTroops = 0, $g_hGrpRequestCCDefenseTroops = 0 ; Team AIO Mod++
Global $g_hLblRequestCChour = 0, $g_ahLblRequestCChoursE = 0
Global $g_hLblRequestCChours[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblRequestType, $g_hChkRequestType_Troops, $g_hChkRequestType_Spells, $g_hChkRequestType_Siege
Global $g_hTxtRequestCountCCTroop, $g_hTxtRequestCountCCSpell, $g_hChkClanCastleSpell = 0
Global $g_ahCmbClanCastleTroop[3], $g_ahTxtClanCastleTroop[3]
Global $g_ahCmbClanCastleSpell[3], $g_ahCmbClanCastleSiege[2]

; Donate
Global $g_hChkExtraAlphabets = 0, $g_hChkExtraChinese = 0, $g_hChkExtraKorean = 0, $g_hChkExtraPersian = 0
Global $g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $g_ahChkDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahChkDonateAllSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtBlacklistSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahGrpDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahLblDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahBtnDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $g_ahCmbDonateCustomA[3] = [0, 0, 0], $g_ahTxtDonateCustomA[3] = [0, 0, 0], $g_ahPicDonateCustomA[3] = [0, 0, 0]
Global $g_ahCmbDonateCustomB[3] = [0, 0, 0], $g_ahTxtDonateCustomB[3] = [0, 0, 0], $g_ahPicDonateCustomB[3] = [0, 0, 0]
Global $g_ahCmbDonateCustomC[3] = [0, 0, 0], $g_ahTxtDonateCustomC[3] = [0, 0, 0], $g_ahPicDonateCustomC[3] = [0, 0, 0]
Global $g_ahCmbDonateCustomD[3] = [0, 0, 0], $g_ahTxtDonateCustomD[3] = [0, 0, 0], $g_ahPicDonateCustomD[3] = [0, 0, 0]

Global $g_hLblDonateTroopTBD1 = 0, $g_hLblDonateTroopTBD2 = 0, $g_hLblDonateTroopTBD3 = 0, _
	   $g_hLblDonateTroopCustomC = 0, $g_hLblDonateTroopCustomD = 0, $g_hLblDonateTroopCustomF = 0, $g_hLblDonateTroopCustomG = 0, $g_hLblDonateTroopCustomH = 0, _
	   $g_hLblDonateTroopCustomI = 0, $g_hLblDonateTroopCustomJ = 0, $g_hLblDonateSpellTBD1 = 0

Global $g_hGrpDonateGeneralBlacklist = 0, $g_hTxtGeneralBlacklist = 0
Global $lblBtnCustomE = 0

Global $g_hChkDonateQueueTroopOnly = 0, $g_hChkDonateQueueSpellOnly = 0

; Schedule
Global $g_hChkDonateHoursEnable = 0, $g_ahChkDonateHours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hCmbFilterDonationsCC = 0, $g_hChkSkipDonateNearFullTroopsEnable = 0
Global $g_hLblDonateHours1 = 0, $g_hLblDonateHoursPM = 0
Global $g_hLblSkipDonateNearFullTroopsText = 0, $g_hTxtSkipDonateNearFullTroopsPercentage = 0, $g_hLblSkipDonateNearFullTroopsText1 = 0

Global $g_hGrpDonateCC = 0, $g_ahChkDonateHoursE1 = 0, $g_ahChkDonateHoursE2 = 0

Global $g_hGUI_RequestCC = 0, $g_hGUI_DONATECC = 0, $g_hGUI_ScheduleCC = 0
Global $g_hGrpDonate = 0, $g_hChkDonate = 1, $g_hLblDonateDisabled = 0, $g_hLblScheduleDisabled = 0

; Clan castle
Global $g_hChkUseCCBalanced = 0, $g_hCmbCCDonated = 0, $g_hCmbCCReceived = 0, $g_hChkCheckDonateOften = 0
GLobal $g_hLblDonateCChour = 0, $g_ahLblDonateCChoursE = 0
GLobal $g_hLblDonateCChours[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

#Region - Request defense CC (Demen)
Global $g_hChkRequestCCDefense = 0, $g_hChkSaveCCTroopForDefense = 0, $g_hTxtRequestCCDefense = 0, _
	   $g_hCmbRequestCCDefenseWhen = 0, $g_hTxtRequestCCDefenseTime = 0, $g_hChkRemoveCCForDefense = 0
Global $g_ahCmbClanCastleTroopDef[3], $g_ahTxtClanCastleTroopDef[3]

; Type Once - ChacalGyn 
Global $g_hChkRequestTypeOnceEnable = 0

; Request Early - Team AIO Mod++
Global $g_hChkReqCCFirst = 0

; Request from chat - Team AIO Mod++
Global $g_hChkRequestFromChat = 0
#EndRegion - Request defense CC (Demen)

Func CreateVillageDonate()
	$g_hGUI_DONATE = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_DONATE)
	Local $x = 82
	$g_hChkDonate = GUICtrlCreateCheckbox("", $x + 131, 6, 13, 13)
		GUICtrlSetState(-1,$GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "Doncheck")
		CreateRequestSubTab()
		CreateDonateSubTab()
		CreateScheduleSubTab()
	GUISwitch($g_hGUI_DONATE)

	$g_hGUI_DONATE_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, $WS_CLIPSIBLINGS)
	$g_hGUI_DONATE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_01", "Request Troops"))
	$g_hGUI_DONATE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_02", "Donate Troops") & "    ")
	$g_hLblDonateDisabled = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_02_STab_02_STab_Info_01", "Note: Donate is disabled, tick the checkmark on the") & " " & GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_02", -1) & " " & GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_02", -1), 5, 30, $g_iSizeWGrpTab3, 374)
		GUICtrlSetState(-1, $GUI_HIDE)
	$g_hGUI_DONATE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_03", "Schedule Donations"))
	$g_hLblScheduleDisabled = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_02_STab_02_STab_Info_01", -1) & " " & GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_02", -1) & " " & GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_02", -1), 5, 30, $g_iSizeWGrpTab3, 374)
		GUICtrlSetState(-1, $GUI_HIDE)
	
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageDonate

#Region CreateRequestSubTab
Func CreateRequestSubTab()

	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	$g_hGUI_RequestCC = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, $xStart - 20, $yStart - 20, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DONATE)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_RequestCC)
	Local $xStart = 20, $yStart = 20
	Local $x = $xStart
	Local $y = $yStart
	$g_hGrpRequestCC = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Group_01", "Clan Castle Request"), $x - 20, $y - 20, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3 - 231)
	$y += 10
	$x += 5
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCCRequest, $x - 5, $y, 64, 64, $BS_ICON)
		$g_hChkRequestTroopsEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestTroopsEnable", "Request Troops / Spells"), $x + 40 + 30, $y - 6)
			GUICtrlSetOnEvent(-1, "chkRequestCCHours")
		$g_hTxtRequestCC = _GUICtrlCreateInput(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "TxtRequestCC", "Anything please"), $x + 70, $y + 15, 214, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "TxtRequestCC_Info_01", "This text is used on your request for troops in the Clan chat."))
		$g_hChkRequestTypeOnceEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestTypeOnceEnable", "Type Once"), $x + 210, $y - 6) ; Type Once - ChacalGyn 
		$g_hChkReqCCFirst = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "LblChkReqCCFirst", "Request Early"), $x + 290, $y - 6 + 25 - 8) ; Request Early - Team AIO Mod++
		$g_hChkRequestFromChat = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestFromChat", "Request from chat"), $x + 290, $y - 6 + 45 - 8) ; Request from chat - Team AIO Mod++

	$x += 70
	$y += 90 - 47
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", "Only during these hours of each day"), $x, $y, 216, 20, $BS_MULTILINE)

	$x += 40
	$y += 20 
		$g_hLblRequestCChour = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", "Hour") & ":", $x, $y, -1, 15)
			Local $sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblRequestCChours[0] = GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[10] = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[11] = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahLblRequestCChoursE = GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 15
		$g_ahChkRequestCCHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_hChkRequestCCHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", "This button will clear or set the entire row of boxes"))
			GUICtrlSetOnEvent(-1, "chkRequestCCHoursE1")
		$g_hLblRequestCCHoursAM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", "AM"), $x + 5, $y)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 15
		$g_ahChkRequestCCHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_hChkRequestCCHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkRequestCCHoursE2")
		$g_hLblRequestCCHoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", "PM"), $x + 5, $y)
			GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$g_hGrpRequestCCTroops = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Group_02", "Clan Castle Troops"), $xStart - 20, $yStart - 20 + 145, $g_iSizeWGrpTab3, 144 - 12)
	
	$x -= 110
	$y -= 50
	
	; Request Type (Demen)
	$y += 65
		$g_hLblRequestType = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "LblRequestType", "When lacking "), $x, $y + 23)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "LblRequestType_Info_01", "Not send request when all the checked items are full"))
		$g_hChkRequestType_Troops = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestType", "Troops"), $x + 70, $y + 20)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestType_Info_01", "Send request when CC Troop is not full"))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkRequestCountCC")
		$g_hChkRequestType_Spells = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestType_Spells", "Spells"), $x + 170, $y + 20)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestType_Spells_Info_01", "Send request when CC Spell is not full"))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkRequestCountCC")
		$g_hChkRequestType_Siege = GUICtrlCreateCheckbox( GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC","ChkRequestType_Sieges", "Siege Machine"), $x + 275, $y + 20)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC","ChkRequestType_Sieges_Info_01", "Send request when CC Siege Machine is not received"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkRequestCountCC")

	$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "lblIfLessThan", "If less than "), $x, $y + 23)
		$g_hTxtRequestCountCCTroop = _GUICtrlCreateInput("0", $x + 70, $y + 20, 25, 16, BitOR($SS_RIGHT, $ES_NUMBER))
			GUICtrlSetLimit(-1, 2)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "lblIfLessThan_Info_01", "Do not request when already received that many CC Troops") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "lblIfLessThan_Info_02", "Set to either ""0"" or ""40+"" when full CC Troop wanted"))
			If GUICtrlRead($g_hChkRequestType_Troops) = $GUI_CHECKED Then
				GUICtrlSetState(-1, $GUI_ENABLE)
			Else
				GUICtrlSetState(-1, $GUI_DISABLE)
			EndIf
		$g_hTxtRequestCountCCSpell = _GUICtrlCreateInput("0", $x + 170, $y + 20, 25, 16, BitOR($SS_RIGHT, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "lblIfLessThan_Info_03", "Do not request when already received that many CC Spells") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "lblIfLessThan_Info_04", "Set to either ""0"" or ""2+"" when full CC Spell wanted"))
			If GUICtrlRead($g_hChkRequestType_Spells) = $GUI_CHECKED Then
				GUICtrlSetState(-1, $GUI_ENABLE)
			Else
				GUICtrlSetState(-1, $GUI_DISABLE)
			EndIf

	$y += 40
        Local $sCmbTroopList = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtListOfTroops_Any", "Any") & "|" & _ArrayToString($g_asTroopNames)
        For $i = 0 To 2
            $g_ahCmbClanCastleTroop[$i] = GUICtrlCreateCombo("", $x, $y + $i * 25, 125, -1, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
				GUICtrlSetOnEvent(-1, "CmbClanCastleTroop")
                GUICtrlSetData(-1, $sCmbTroopList)
                _GUICtrlComboBox_SetCurSel(-1, 0)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Onlytake_Info_01", "Pick a troop type allowed to stay in your Clan Castle. \r\nTroops of other type shall be removed"))

			$g_ahTxtClanCastleTroop[$i] = _GUICtrlCreateInput("0", $x + 130, $y + $i * 25, 20, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
				GUICtrlSetState(-1, $GUI_DISABLE)
				GUICtrlSetLimit(-1, 2)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Onlytake_Info_02", "Set the maximum quantity to stay. \r\nExcessive quantity shall be removed") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Onlytake_Info_03", "Set to ""0"" or ""40+"" means unlimited"))
		Next

        Local $sCmbSpellList = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtListOfSpells_Any", "Any") & "|" & _ArrayToString($g_asSpellNames)
        For $i = 0 To 2
            $g_ahCmbClanCastleSpell[$i] = GUICtrlCreateCombo("", $x + 170, $y + $i * 25, 85, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetOnEvent(-1, "CmbClanCastleSpell")
				GUICtrlSetData(-1, $sCmbSpellList)
                _GUICtrlComboBox_SetCurSel(-1, 0)
                _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Onlytake_Info_04", "Only keep this spell (1 unit) in Clan Castle. \r\nOther spells or excessive quantity shall be removed"))
        Next

        Local $sCmbSiegeList = GetTranslatedFileIni("MBR Global GUI Design Names Sieges", "TxtListOfSieges_Any", "Any") & "|" & _ArrayToString($g_asSiegeMachineNames)
        For $i = 0 To 1
            $g_ahCmbClanCastleSiege[$i] = GUICtrlCreateCombo("", $x + 275, $y + $i * 25, 100, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
                GUICtrlSetData(-1, $sCmbSiegeList)
                _GUICtrlComboBox_SetCurSel(-1, 0)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Onlytake_Info_05", "Only keep this siege machine in Clan Castle. \r\nSiege machine of other types shall be removed"))
		Next

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	
	#Region - Request defense CC (Demen)
	$x = $xStart + 10 - 22
	$y = $yStart + 288 - 2 - 15
	
	$g_hGrpRequestCCDefenseTroops = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Group_03", "Clan Castle Defense Troops"), $xStart - 20, $yStart - 20 + 288 - 12, $g_iSizeWGrpTab3, 89 + 12)
	
	$g_hChkRequestCCDefense = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestCCDefense", "Request Defense Troops"), $x, $y - 3)
            GUICtrlSetOnEvent(-1, "chkRequestDefense")
	
	$g_hChkSaveCCTroopForDefense = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkCCTroopForDefense", "Save CC for defense"), $x + 145, $y - 3)
			; GUICtrlSetState(-1, $GUI_CHECKED)
			_GUICtrlSetTip(-1, "Not dropping CC troops in attack to save for defense")
			
	$y += 30
	$g_hTxtRequestCCDefense = _GUICtrlCreateInput(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "TxtRequestCCDefense", "Defense troop please"), $x, $y - 6, 214, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestCCDefense_01", "This text is used on your request for defensive troops in the Clan chat."))
	$y += 25
	$g_hCmbRequestCCDefenseWhen = GUICtrlCreateCombo("", $x, $y - 6, 162, 15, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "CmbRequestCCDefenseWhen_01", "When Personal Break time <") & "|" & GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "CmbRequestCCDefenseWhen_02", "When Shield & Guard time <"), GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "CmbRequestCCDefenseWhen_01", -1))
	$g_hTxtRequestCCDefenseTime = _GUICtrlCreateInput("10", $x + 166, $y - 6, 28, 21, $SS_CENTER)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetBkColor(-1, $_COLOR_MONEYGREEN)
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "LblRequestCCDefenseWhenMin", "min"), $x + 195, $y - 3, 20, 15, $SS_RIGHT)

	;;;;;;;;;;;
	$y -= 35
	$x += 145 + 152
		$g_hChkRemoveCCForDefense = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "lblOnlyTake", "Only take"), $x, $y - 23)
		GUICtrlSetOnEvent(-1, "chkRemoveCCForDefense")
		For $i = 0 To 2
			$g_ahCmbClanCastleTroopDef[$i] = GUICtrlCreateCombo("", $x, $y - 2 + $i * 22, 65, -1, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sCmbTroopList, "Any")
				GUICtrlSetOnEvent(-1, "CmbClanCastleTroopDef")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Onlytake_Info_01", "Pick a troop type allowed to stay in your Clan Castle. \r\nTroops of other type shall be removed"))

			$g_ahTxtClanCastleTroopDef[$i] = _GUICtrlCreateInput("0", $x + 70, $y - 2 + $i * 22, 20, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
				GUICtrlSetState(-1, $GUI_DISABLE)
				GUICtrlSetLimit(-1, 2)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Onlytake_Info_02", "Set the maximum quantity to stay. \r\nExcessive quantity shall be removed") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Onlytake_Info_03", "Set to ""0"" or ""40+"" means unlimited"))
		Next
	;;;;;;;;;;;
	#EndRegion - Request defense CC (Demen)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateRequestSubTab
#EndRegion

#Region CreateDonateSubTab
Func CreateDonateSubTab()
	;Local $xStart = 25, $yStart = 45
	Local $xStart = 20, $yStart = 20
	$g_hGUI_DONATECC = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, $xStart-20, $yStart+1, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DONATE) ;HArchH was $xStart-20 or 25-20, y was 45-21
	GUISetBkColor($COLOR_WHITE, $g_hGUI_DONATECC)
	; GUISetBkColor($COLOR_WHITE)

	;~ -------------------------------------------------------------
	;~ Language Variables used a lot
	;~ -------------------------------------------------------------

	Local $sTxtBlacklist1 = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklist1", "Blacklist")
	Local $sDonateTxtCustomA = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "DonateTxtCustom", "Custom Troops")
	Local $sDonateTxtCustomB = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "DonateTxtCustom", -1)
	Local $sDonateTxtCustomC = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "DonateTxtCustom", -1)
	Local $sDonateTxtCustomD = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "DonateTxtCustom", -1)

	Local $sTxtNothing = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtNothing", "Nothing")

	Local $sTxtDonate = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonate", "Donate")
	Local $sTxtDonateTip = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTip", "Check this to donate")
	Local $sTxtDonateAll = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateAll", "Donate to All")
	Local $sTxtDonateQueueTroop = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateQueueTroop", "Queued troop only")
	Local $sTxtDonateQueueSpell = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateQueueSpell", "Queued spell only")
	Local $sTxtIgnoreAll = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtIgnoreAll", "This will also ignore ALL keywords.")
	Local $sTxtKeywords = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtKeywords", "Keywords for donating")
	Local $sTxtKeywordsNo = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtKeywordsNo", "Do NOT donate to these keywords")
	Local $sTxtKeywordsNoTip = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtKeywordsNoTip", "Blacklist for donating")
	Local $sTxtDonateTipTroop = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTipTroop", "if keywords match the Chat Request.")
	Local $sTxtDonateTipAll = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTipAll", "to ALL Chat Requests.")

	Local $sTxtBarbarians = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians")
	Local $sTxtArchers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers")
	Local $sTxtGiants = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants")
	Local $sTxtGoblins = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins")
	Local $sTxtWallBreakers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers")
	Local $sTxtBalloons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons")
	Local $sTxtRocketBalloons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRocketBalloons", "Rocket Balloons")
	Local $sTxtWizards = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards")
	Local $sTxtHealers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers")
	Local $sTxtDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons")
	Local $sTxtSuperDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperDragons", "Super Dragons")
	Local $sTxtPekkas = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas")
	Local $sTxtMinions = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions")
	Local $sTxtHogRiders = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders")
	Local $sTxtValkyries = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries")
	Local $sTxtGolems = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems")
	Local $sTxtWitches = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches")
	Local $sTxtLavaHounds = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds")
	Local $sTxtBowlers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers")
	Local $sTxtSuperBowlers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperBowlers", "Super Bowlers")
	Local $sTxtIceGolems = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceGolems", "Ice Golems")
	Local $sTxtHeadhunters = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHeadhunters", "Headhunters")
	Local $sTxtBabyDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons")
	Local $sTxtMiners = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners")
	Local $sTxtElectroDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroDragons", "Electro Dragons")
	Local $sTxtYetis = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtYetis", "Yetis")
	Local $sTxtDragonRiders = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragonRiders", "Dragon Riders")

	Local $sTxtWallWreckers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallWreckers", "Wall Wreckers")
	Local $sTxtBattleBlimps = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBattleBlimps", "Battle Blimps")
	Local $sTxtStoneSlammers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtStoneSlammers", "Stone Slammers")
	Local $sTxtSiegeBarracks = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSiegeBarracks", "Siege Barracks")
	Local $sTxtLogLauncher = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLogLauncher", "Log Launcher")
	Local $sTxtFlameFlinger = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtFlameFlinger", "Flame Flinger")

	Local $sTxtSuperBarbarians = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperBarbarians", "Super Barbarians")
	Local $sTxtSuperArchers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperArchers", "Super Archers")
	Local $sTxtSuperGiants = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperGiants", "Super Giants")
	Local $sTxtSneakyGoblins = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSneakyGoblins", "Sneaky Goblins")
	Local $sTxtSuperWallBreakers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWallBreakers", "Super Wall Breakers")
	Local $sTxtSuperWizards = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWizards", "Super Wizards")
	Local $sTxtInfernoDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtInfernoDragons", "Inferno Dragons")
	Local $sTxtSuperMinions = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperMinions", "Super Minions")
	Local $sTxtSuperValkyries = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperValkyries", "Super Valkyries")
	Local $sTxtSuperWitches = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWitches", "Super Witches")
	Local $sTxtIceHounds = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceHounds", "Ice Hounds")

	Local $sTxtLightningSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortLightningSpells", "Lightning")
	Local $sTxtHealSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHealSpells", "Heal")
	Local $sTxtRageSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortRageSpells", "Rage")
	Local $sTxtJumpSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortJumpSpells", "Jump")
	Local $sTxtFreezeSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortFreezeSpells", "Freeze")
	Local $sTxtInvisibilitySpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortInvisibilitySpells", "Invisibility")
	Local $sTxtPoisonSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortPoisonSpells", "Poison")
	Local $sTxtEarthquakeSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortEarthquakeSpells", "EarthQuake")
	Local $sTxtHasteSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHasteSpells", "Haste")
	Local $sTxtSkeletonSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortSkeletonSpells", "Skeleton")
	Local $sTxtBatSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortBatSpells", "Bat")
	Local $sTxtCloneSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortCloneSpells", "Clone")

	Local $x
	Local $y = $yStart - 17 ;HArch was 15
	Local $Offx = 36
	; Row 1
	$x = $xStart - $xStart ; HArchH Was 21, but only worked for Barb row.  Other rows need color box to start at 20.
	; Barbarian
		$g_ahLblDonateTroop[$eTroopBarbarian] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopBarbarian] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBarbarian, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Giant
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopGiant] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopGiant] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGiant, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; WallBreaker
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopWallBreaker] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopWallBreaker] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWallBreaker, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Wizard
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopWizard] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopWizard] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWizard, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Dragon
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDragon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; BabyDragon
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopBabyDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopBabyDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBabyDragon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; ElectroDragon
	$x += $Offx
	    $g_ahLblDonateTroop[$eTroopElectroDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopElectroDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnElectroDragon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; DragonRider
	$x += $Offx
	    $g_ahLblDonateTroop[$eTroopDragonRider] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopDragonRider] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDragonRider, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; HogRider
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopHogRider] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopHogRider] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHogRider, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Golem
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopGolem] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopGolem] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGolem, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; LavaHound
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopLavaHound] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopLavaHound] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLavaHound, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; IceGolem
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopIceGolem] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 1, $Offx + 1)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopIceGolem] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnIceGolem, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")

	; Row 2
	$y += 39 ;HArchH was 35
	$x = $xStart - $xStart ;HArchH was 20
	; Archer
		$g_ahLblDonateTroop[$eTroopArcher] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopArcher] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnArcher, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Goblin
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopGoblin] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopGoblin] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoblin, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Balloon
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopBalloon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopBalloon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBalloon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Healer
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopHealer] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopHealer] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHealer, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Pekka
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopPekka] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopPekka] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnPekka, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Miner
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopMiner] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopMiner] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnMiner, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Yeti
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopYeti] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopYeti] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnYeti, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Minion
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopMinion] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopMinion] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnMinion, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Valkyrie
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopValkyrie] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopValkyrie] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnValkyrie, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Witch
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopWitch] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopWitch] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWitch, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Bowler
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopBowler] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopBowler] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBowler, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Headhunter
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopHeadhunter] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopHeadhunter] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHeadhunter, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")

	; Row 3
	$y += 39 ;HArchH was 35
	$x = $xStart - $xStart
	; Lightning
		$g_ahLblDonateSpell[$eSpellLightning] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellLightning] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLightSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Heal
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellHeal] = GUICtrlCreateLabel("", $x , $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellHeal] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHealSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Rage
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellRage] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellRage] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnRageSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Jump
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellJump] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellJump] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnJumpSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Freeze
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellFreeze] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellFreeze] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnFreezeSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Invisibility
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellInvisibility] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellInvisibility] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnInvisibilitySpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Clone
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellClone] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellClone] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnCloneSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Poison
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellPoison] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellPoison] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnPoisonSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; EarthQuake
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellEarthquake] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellEarthquake] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnEarthQuakeSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Haste
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellHaste] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellHaste] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHasteSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Skeleton
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellSkeleton] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellSkeleton] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSkeletonSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Bat
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellBat] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellBat] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBatSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	; Row 4
	$y += 39 ;HArchH was 35
	$x = $xStart - $xStart
	; Super Barbarian
		$g_ahLblDonateTroop[$eTroopSuperBarbarian] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperBarbarian] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperBarbarian, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Super Archer
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopSuperArcher] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperArcher] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperArcher, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Super Giant
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopSuperGiant] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperGiant] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperGiant, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Sneaky Goblin
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopSneakyGoblin] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSneakyGoblin] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSneakyGoblin, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Super WallBreaker
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopSuperWallBreaker] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperWallBreaker] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperWallBreaker, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Rocket Balloon
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopRocketBalloon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopRocketBalloon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnRocketBalloon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Super Wizard
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopSuperWizard] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperWizard] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperWizard, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; InfernoDragon
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopInfernoDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopInfernoDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnInfernoDragon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Super Minion
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopSuperMinion] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperMinion] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperMinion, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Super Valkyrie
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopSuperValkyrie] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperValkyrie] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperValkyrie, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Super Witch
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopSuperWitch] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperWitch] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperWitch, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; IceHound
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopIceHound] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopIceHound] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnIceHound, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")

	; Row 5
	$y += 39 ;HArchH was 35
	$x = $xStart - $xStart
	; Super Bowler
		$g_ahLblDonateTroop[$eTroopSuperBowler] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperBowler] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperBowler, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Super Dragon
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopSuperDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopSuperDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSuperDragon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Wall Wrecker
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWallW, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Battle Blimp
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBattleB, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Stone Slammer
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnStoneS, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Siege Barracks
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBarracks] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBarracks] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSiegeB, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Log Launcher
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeLogLauncher] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeLogLauncher] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLogL, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Flame Flinger
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeFlameFlinger] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeFlameFlinger] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnFlameF, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Custom #1
	$x += $Offx
		;;; Custom Combination Donate #1 by ChiefM3, edit my MonkeyHunter
		$g_ahLblDonateTroop[$eCustomA] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eCustomA] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonCustom, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Custom #2
	$x += $Offx
		;;; Custom Combination Donate #2 added by MonkeyHunter
		$g_ahLblDonateTroop[$eCustomB] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eCustomB] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonCustomB, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Custom #3
	$x += $Offx
		;;; Custom Combination Donate #3 ~ Additional Custom Donate by NguyenAnhHD
		$g_ahLblDonateTroop[$eCustomC] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eCustomC] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonCustom, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
;~ 	; Custom #4
;~ 	$x += $Offx
;~ 		;;; Custom Combination Donate #4 ~ ; Additional Custom Donate by NguyenAnhHD
;~ 		$g_ahLblDonateTroop[$eCustomD] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
;~ 			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
;~ 			GUICtrlSetState(-1, $GUI_DISABLE)
;~ 		$g_ahBtnDonateTroop[$eCustomD] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
;~ 			_GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonCustomB, 1)
;~ 			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	; Blacklist button
	$x += $Offx
		GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonBlacklist, 1)
			GUICtrlSetOnEvent(-1, "btnDonateBlacklist")

	Local $Offy = $yStart + 185
	$x = $xStart
	$y = $yStart + 185
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblExtraAlphabets", "Extra Alphabet Recognitions:"), $x - 15, $y + 159, -1, -1) ; HArchH was $y+153
		$g_hChkExtraAlphabets = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraAlphabets", "Cyrillic"), $x + 127 , $y + 155, -1, -1) ; HArchH was $y+149
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraAlphabets_Info_01", "Check this to enable the Cyrillic Alphabet."))
		$g_hChkExtraChinese = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraChinese", "Chinese"), $x + 191, $y + 155, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraChinese_Info_01", "Check this to enable the Chinese Alphabet."))
		$g_hChkExtraKorean = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraKorean", "Korean"), $x + 265, $y + 155, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraKorean_Info_01", "Check this to enable the Korean Alphabet."))
		$g_hChkExtraPersian = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraPersian", "Persian"), $x + 340, $y + 155, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraPersian_Info_01", "Check this to enable the Persian Alphabet."))

	$g_hChkDonateQueueTroopOnly = GUICtrlCreateCheckbox($sTxtDonateQueueTroop, $x + 275, $y + 46, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateQueueTroopTip", "Only donate troops which are ready in 2nd army,\r\nor troops which are training in first slot of 2nd army.\r\nIf 2nd army is not prepared, donate whatever exists in 1st army.")) ;HarchH was y+36
	$g_hChkDonateQueueSpellOnly = GUICtrlCreateCheckbox($sTxtDonateQueueSpell, $x + 275, $y + 46, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateQueueSpellTip", "Only donate spells which are ready in 2nd army,\r\nor spells which are training in first slot of 2nd army.\r\n\If 2nd army is not prepared, donate whatever exists in 1st army.")) ;HArchH was y+36
		GUICtrlSetState(-1, $GUI_HIDE)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopBarbarian] = GUICtrlCreateGroup($sTxtBarbarians, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	;$y -= 4
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBarbarian, $x + 215, $y, 64, 64, $BS_ICON)
		$g_ahChkDonateTroop[$eTroopBarbarian] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBarbarians, $x + 285, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBarbarians & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBarbarian] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBarbarians & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBarbarians & ":", $x - 5, $y + 5, -1, -1)
		$g_ahTxtDonateTroop[$eTroopBarbarian] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_01", "barbarians\r\nbarb")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBarbarians)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
		$g_ahTxtBlacklistTroop[$eTroopBarbarian] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_01", "no barbarians\r\nno barb\r\nbarbarians no\r\nbarb no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBarbarians)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopArcher] = GUICtrlCreateGroup($sTxtArchers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonArcher, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopArcher] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtArchers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtArchers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopArcher] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtArchers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtArchers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopArcher] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_02", "archers\r\narch")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtArchers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopArcher] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_02", "no archers\r\nno arch\r\narchers no\r\narch no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtArchers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopGiant] = GUICtrlCreateGroup($sTxtGiants, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonGiant, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopGiant] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtGiants, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGiants & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopGiant] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGiants & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtGiants & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopGiant] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_03", "giants\r\ngiant\r\nany\r\nreinforcement")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtGiants)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopGiant] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_03", "no giants\r\ngiants no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtGiants)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopGoblin] = GUICtrlCreateGroup($sTxtGoblins, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonGoblin, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopGoblin] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtGoblins, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGoblins & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopGoblin] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGoblins & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtGoblins & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopGoblin] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_04", "goblins\r\ngoblin")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtGoblins)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopGoblin] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_04", "no goblins\r\ngoblins no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtGoblins)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopWallBreaker] = GUICtrlCreateGroup($sTxtWallBreakers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWallBreaker, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopWallBreaker] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWallBreakers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallBreakers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopWallBreaker] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallBreakers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWallBreakers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopWallBreaker] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_05", "wall breakers\r\nbreaker")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWallBreakers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopWallBreaker] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_05", "no wall breakers\r\nwall breakers no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWallBreakers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopBalloon] = GUICtrlCreateGroup($sTxtBalloons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBalloon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopBalloon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBalloons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBalloons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBalloon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBalloons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBalloons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopBalloon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_06", "balloons\r\nballoon")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBalloons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopBalloon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_06", "no balloon\r\nballoons no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBalloons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopWizard] = GUICtrlCreateGroup($sTxtWizards, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWizard, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopWizard] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWizards, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWizards & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopWizard] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWizards & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWizards & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopWizard] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_07", "wizards\r\nwizard\r\nwiz")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWizards)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopWizard] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_07", "no wizards\r\nwizards no\r\nno wizard\r\nwizard no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWizards)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopHealer] = GUICtrlCreateGroup($sTxtHealers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHealer, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopHealer] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHealers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopHealer] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHealers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopHealer] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_08", "healer")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHealers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopHealer] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_08", "no healer\r\nhealer no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHealers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopDragon] = GUICtrlCreateGroup($sTxtDragons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtDragons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtDragons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_09", "dragon")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_09", "no dragon\r\ndragon no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperDragon] = GUICtrlCreateGroup($sTxtSuperDragons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperDragons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperDragons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_57", "super dragon")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_57", "no super dragon\r\nsuper dragon no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopPekka] = GUICtrlCreateGroup($sTxtPekkas, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonPekka, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopPekka] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtPekkas, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPekkas & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopPekka] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPekkas & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtPekkas & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopPekka] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_10", "PEKKA\r\npekka")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtPekkas)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopPekka] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_10", "no PEKKA\r\npekka no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtPekkas)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopBabyDragon] = GUICtrlCreateGroup($sTxtBabyDragons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBabyDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopBabyDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBabyDragons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBabyDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBabyDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBabyDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBabyDragons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopBabyDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_11", "baby dragon\r\nbaby")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBabyDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopBabyDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_11", "no baby dragon\r\nbaby dragon no\r\nno baby\r\nbaby no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBabyDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopMiner] = GUICtrlCreateGroup($sTxtMiners, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMiner, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopMiner] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtMiners, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMiners & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopMiner] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMiners & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtMiners & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopMiner] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_12", "miner|mine")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtMiners)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopMiner] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_12", "no miner\r\nminer no\r\nno mine\r\nmine no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtMiners)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopElectroDragon] = GUICtrlCreateGroup($sTxtElectroDragons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElectroDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopElectroDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtElectroDragons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtElectroDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopElectroDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtElectroDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtElectroDragons & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopElectroDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_31", "electro dragon\r\nelectrodrag\r\nedrag")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtElectroDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopElectroDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_31", "no electro dragon\r\nelectrodrag no\r\nedrag no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtElectroDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopYeti] = GUICtrlCreateGroup($sTxtYetis, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnYeti, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopYeti] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtYetis, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtYetis & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopYeti] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtYetis & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtYetis & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopYeti] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_37", "Yeti\r\nYetis")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtYetis)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopYeti] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_37", "no yeti\r\nyeti no\r\nyetis no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtYetis)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopDragonRider] = GUICtrlCreateGroup($sTxtDragonRiders, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragonRider, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopDragonRider] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtDragonRiders, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtDragonRiders & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopDragonRider] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtDragonRiders & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtDragonRiders & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopDragonRider] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_54", "Dragon Rider\r\nDragon Riders")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtDragonRiders)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopDragonRider] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_54", "No Dragon Rider\r\nDragon Rider No\r\nDragon Riders No")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtDragonRiders)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopMinion] = GUICtrlCreateGroup($sTxtMinions, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMinion, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopMinion] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtMinions, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMinions & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopMinion] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMinions & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtMinions & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopMinion] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_18", "minions\r\nminion")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtMinions)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopMinion] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_18", "no minions\r\nminions no\r\nno minion\r\nminion no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtMinions)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopHogRider] = GUICtrlCreateGroup($sTxtHogRiders, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHogRider, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopHogRider] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHogRiders, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHogRiders & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopHogRider] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " &  $sTxtHogRiders & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHogRiders & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopHogRider] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_19", "hogriders\r\nhogs\r\nhog")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHogRiders)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopHogRider] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_19", "no hogs\r\nhog no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHogRiders)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopValkyrie] = GUICtrlCreateGroup($sTxtValkyries, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonValkyrie, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopValkyrie] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtValkyries, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtValkyries & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopValkyrie] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtValkyries & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtValkyries & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopValkyrie] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_20", "valkyries\r\nvalkyrie\r\nvalk")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtValkyries)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopValkyrie] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_20", "no valkyries\r\nvalkyries no\r\nno valk\r\nvalk no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtValkyries)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopGolem] = GUICtrlCreateGroup($sTxtGolems, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonGolem, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopGolem] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtGolems, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGolems & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopGolem] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGolems & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtGolems & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopGolem] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_21", "golem")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtGolems)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopGolem] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_21", "no golem\r\ngolem no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtGolems)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopWitch] = GUICtrlCreateGroup($sTxtWitches, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWitch, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopWitch] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWitches, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWitches & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopWitch] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWitches & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWitches & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopWitch] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_22", "witches\r\nwitch")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWitches)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopWitch] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_22", "no witches\r\nwitch no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWitches)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopLavaHound] = GUICtrlCreateGroup($sTxtLavaHounds, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonLavaHound, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopLavaHound] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtLavaHounds, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLavaHounds & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopLavaHound] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLavaHounds & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtLavaHounds & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopLavaHound] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_23", "lavahound\r\nlava\r\nhound")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtLavaHounds)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopLavaHound] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_23", "no lavahound\r\nlava no\r\nhound no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtLavaHounds)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopBowler] = GUICtrlCreateGroup($sTxtBowlers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBowler, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopBowler] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBowlers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBowlers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBowler] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBowlers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBowlers & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopBowler] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_24", "bowler\r\nbowlers\r\nbowl")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBowlers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopBowler] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_24", "no bowler\r\nbowl no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBowlers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopIceGolem] = GUICtrlCreateGroup($sTxtIceGolems, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceGolem, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopIceGolem] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtIceGolems, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtIceGolems & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopIceGolem] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtIceGolems & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtIceGolems & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopIceGolem] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_36", "ice golem\r\nice golems")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtIceGolems)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopIceGolem] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_36", "no ice golem\r\nice golem no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtIceGolems)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopHeadhunter] = GUICtrlCreateGroup($sTxtHeadhunters, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeadhunter, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopHeadhunter] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHeadhunters, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHeadhunters & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopHeadhunter] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHeadhunters & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHeadhunters & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopHeadhunter] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_39", "headhunter\r\nhunt")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHeadhunters)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopHeadhunter] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_39", "no headhunter\r\nno hunt")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHeadhunters)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	;Super Troops
	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperBarbarian] = GUICtrlCreateGroup($sTxtSuperBarbarians, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperBarbarian, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperBarbarian] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperBarbarians, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperBarbarians & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperBarbarian] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperBarbarians & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperBarbarians & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperBarbarian] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_42", "Super Barbarians\r\nSuper Barb")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperBarbarians)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperBarbarian] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_42", "no super barbarians\r\nno barb super\r\nsuper Barbarians no\r\nsuper barb no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperBarbarians)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperArcher] = GUICtrlCreateGroup($sTxtSuperArchers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperArcher, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperArcher] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperArchers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperArchers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperArcher] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperArchers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperArchers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperArcher] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_43", "super archers\r\nsuper arch")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperArchers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperArcher] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_43", "no super archers\r\nno arch super\r\nsuper archers no\r\nsuper arch no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperArchers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperGiant] = GUICtrlCreateGroup($sTxtSuperGiants, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperGiant, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperGiant] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperGiants, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperGiants & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperGiant] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperGiants & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperGiants & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperGiant] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_44", "super giants\r\nsuper giant")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperGiants)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperGiant] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_44", "no super giants\r\nsuper giants no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperGiants)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSneakyGoblin] = GUICtrlCreateGroup($sTxtSneakyGoblins, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSneakyGoblin, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSneakyGoblin] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSneakyGoblins, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSneakyGoblins & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSneakyGoblin] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSneakyGoblins & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSneakyGoblins & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSneakyGoblin] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_45", "SneakyGoblins\r\nSneakyGoblin")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSneakyGoblins)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSneakyGoblin] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_45", "no SneakyGoblins\r\nSneakyGoblins no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSneakyGoblins)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperWallBreaker] = GUICtrlCreateGroup($sTxtSuperWallBreakers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWallBreaker, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperWallBreaker] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperWallBreakers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperWallBreakers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperWallBreaker] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperWallBreakers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperWallBreakers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperWallBreaker] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_46", "super wall breakers\r\nsuper  breaker")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperWallBreakers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperWallBreaker] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_46", "no super wall breakers\r\nsuper  wall breakers no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperWallBreakers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopRocketBalloon] = GUICtrlCreateGroup($sTxtRocketBalloons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRocketBalloon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopRocketBalloon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtRocketBalloons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtRocketBalloons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopRocketBalloon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtRocketBalloons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtRocketBalloons & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopRocketBalloon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_55", "Rocket Balloon\r\nRocket Balloons")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtRocketBalloons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopRocketBalloon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_55", "No Rocket Balloon\r\nRocket Balloon No\r\nRocket Balloons No")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtRocketBalloons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperWizard] = GUICtrlCreateGroup($sTxtSuperWizards, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWizard, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperWizard] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperWizards, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperWizards & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperWizard] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperWizards & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperWizards & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperWizard] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_47", "SuperWizards\r\nSuperWizard\r\nsuper wiz")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperWizards)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperWizard] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_47", "no SuperWizards\r\nSuperWizards no\r\nno SuperWizard\r\nSuperWizard no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperWizards)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopInfernoDragon] = GUICtrlCreateGroup($sTxtInfernoDragons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnInfernoDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopInfernoDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtInfernoDragons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtInfernoDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopInfernoDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtInfernoDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtInfernoDragons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopInfernoDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_48", "inferno dragon\r\ninferno baby")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtInfernoDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopInfernoDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_48", "no inferno dragon\r\ninferno baby dragon no\r\nno inferno\r\ninferno no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtInfernoDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperMinion] = GUICtrlCreateGroup($sTxtSuperMinions, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperMinion, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperMinion] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperMinions, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperMinions & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperMinion] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperMinions & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperMinions & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperMinion] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_49", "SuperMinions\r\nSuperMinion")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperMinions)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperMinion] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_49", "no SuperMinions\r\nSuperMinions no\r\nno SuperMinion\r\nSuperMinion no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperMinions)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperValkyrie] = GUICtrlCreateGroup($sTxtSuperValkyries, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperValkyrie, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperValkyrie] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperValkyries, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperValkyries & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperValkyrie] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperValkyries & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperValkyries & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperValkyrie] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_50", "SuperValkyries\r\nSuperValkyrie\r\nsvalk")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperValkyries)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperValkyrie] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_50", "no SuperValkyries\r\nSuperValkyries no\r\nno valk\r\nsvalk no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperValkyries)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperWitch] = GUICtrlCreateGroup($sTxtSuperWitches, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWitch, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperWitch] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperWitches, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperWitches & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperWitch] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperWitches & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperWitches & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperWitch] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_51", "SuperWitches\r\nSuperWitch")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperWitches)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperWitch] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_51", "no SuperWitches\r\nSuperWitch no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperWitches)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopIceHound] = GUICtrlCreateGroup($sTxtIceHounds, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceHound, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopIceHound] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtIceHounds, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtIceHounds & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopIceHound] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtIceHounds & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtIceHounds & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopIceHound] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_52", "IceHound\r\nice")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtIceHounds)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopIceHound] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_52", "no IceHound\r\nice no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtIceHounds)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopSuperBowler] = GUICtrlCreateGroup($sTxtSuperBowlers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperBowler, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopSuperBowler] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSuperBowlers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperBowlers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopSuperBowler] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSuperBowlers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSuperBowlers & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopSuperBowler] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_56", "Super Bowler\r\nSuper Bowlers\r\nSBowl")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSuperBowlers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopSuperBowler] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_56", "No Super Bowler\r\nSBowl no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSuperBowlers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Spells
	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellLightning] = GUICtrlCreateGroup($sTxtLightningSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellLightning] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtLightningSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLightningSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellLightning] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLightningSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtLightningSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellLightning] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_13", "lightning")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtLightningSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellLightning] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_13", "no lightning\r\nlightning no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtLightningSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellHeal] = GUICtrlCreateGroup($sTxtHealSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellHeal] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHealSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellHeal] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		 GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHealSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellHeal] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_14", "heal")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHealSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellHeal] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_14", "no heal\r\nheal no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHealSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellRage] = GUICtrlCreateGroup($sTxtRageSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellRage] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtRageSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtRageSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellRage] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtRageSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtRageSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellRage] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_15", "rage")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtRageSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellRage] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_15", "no rage\r\nrage no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtRageSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellJump] = GUICtrlCreateGroup($sTxtJumpSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellJump] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtJumpSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtJumpSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellJump] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtJumpSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtJumpSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellJump] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_16", "jump")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtJumpSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellJump] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_16", "no jump\r\njump no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtJumpSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellFreeze] = GUICtrlCreateGroup($sTxtFreezeSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellFreeze] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtFreezeSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtFreezeSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellFreeze] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtFreezeSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtFreezeSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellFreeze] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_17", "freeze")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtFreezeSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellFreeze] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_17", "no freeze\r\nfreeze no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtFreezeSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellInvisibility] = GUICtrlCreateGroup($sTxtInvisibilitySpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnInvisibilitySpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellInvisibility] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtInvisibilitySpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtInvisibilitySpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellInvisibility] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtInvisibilitySpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtInvisibilitySpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellInvisibility] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_40", "Invisibility")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtInvisibilitySpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellInvisibility] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_40", "No Invisibility\r\nInvisibility No")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtInvisibilitySpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellClone] = GUICtrlCreateGroup($sTxtCloneSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellClone] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtCloneSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtCloneSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellClone] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtCloneSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtCloneSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellClone] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_53", "Clone")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtCloneSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellClone] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_53", "No Clone\r\nClone No")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtCloneSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellPoison] = GUICtrlCreateGroup($sTxtPoisonSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonPoisonSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellPoison] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtPoisonSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPoisonSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellPoison] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPoisonSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtPoisonSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellPoison] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_25", "poison")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtPoisonSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellPoison] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_25", "no poison\r\npoison no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtPoisonSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellEarthquake] = GUICtrlCreateGroup($sTxtEarthQuakeSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonEarthQuakeSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellEarthquake] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtEarthQuakeSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtEarthQuakeSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellEarthquake] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtEarthQuakeSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtEarthQuakeSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellEarthquake] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_26", "earthquake\r\nquake")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtEarthQuakeSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellEarthquake] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_26", "no earthquake\r\nquake no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtEarthQuakeSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellHaste] = GUICtrlCreateGroup($sTxtHasteSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHasteSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellHaste] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHasteSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHasteSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellHaste] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHasteSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHasteSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellHaste] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_27", "haste")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHasteSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellHaste] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_27", "no haste\r\nhaste no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHasteSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellSkeleton] = GUICtrlCreateGroup($sTxtSkeletonSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonSkeletonSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellSkeleton] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSkeletonSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSkeletonSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellSkeleton] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSkeletonSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSkeletonSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellSkeleton] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_28", "skeleton|skel")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSkeletonSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellSkeleton] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_28", "no skeleton\r\nskeleton no\r\nno skel")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSkeletonSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateSpell[$eSpellBat] = GUICtrlCreateGroup($sTxtBatSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBatSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellBat] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBatSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBatSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellBat] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBatSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBatSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellBat] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_34", "Bat")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBatSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellBat] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_34", "no bat\r\nbat no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBatSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Siege Machines
	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateGroup($sTxtWallWreckers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallW, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWallWreckers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallWreckers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallWreckers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWallWreckers & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_32", "wall wreckers\r\nsieges\r\nwreckers")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWallWreckers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_32", "no wreckers\r\nsiege no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWallWreckers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateGroup($sTxtBattleBlimps, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleB, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBattleBlimps, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBattleBlimps & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBattleBlimps & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBattleBlimps & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_33", "battle blimps\r\nsieges\r\nblimps")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBattleBlimps)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_33", "no blimps\r\nsiege no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBattleBlimps)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateGroup($sTxtStoneSlammers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnStoneS, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtStoneSlammers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtStoneSlammers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtStoneSlammers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtStoneSlammers & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_35", "stone slammers\r\nsieges\r\nslammers")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtStoneSlammers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_35", "no slammers\r\nsiege no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtStoneSlammers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBarracks] = GUICtrlCreateGroup($sTxtSiegeBarracks, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSiegeB, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBarracks] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSiegeBarracks, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSiegeBarracks & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBarracks] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSiegeBarracks & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSiegeBarracks & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBarracks] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_38", "Siege Barracks\r\nsieges\r\nbarracks")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSiegeBarracks)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBarracks] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_38", "no barracks\r\nsiege no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSiegeBarracks)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeLogLauncher] = GUICtrlCreateGroup($sTxtLogLauncher, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLogL, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeLogLauncher] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtLogLauncher, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLogLauncher & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeLogLauncher] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLogLauncher & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtLogLauncher & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeLogLauncher] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_41", "Log Launcher\r\nsieges\r\nlauncher")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtLogLauncher)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeLogLauncher] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_41", "no launcher\r\nsiege no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtLogLauncher)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeFlameFlinger] = GUICtrlCreateGroup($sTxtFlameFlinger, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnFlameF, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeFlameFlinger] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtFlameFlinger, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtFlameFlinger & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeFlameFlinger] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtFlameFlinger & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtFlameFlinger & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeFlameFlinger] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_58", "Flame Flinger\r\nsieges\r\nFlinger")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtFlameFlinger)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeFlameFlinger] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_58", "no Flinger\r\nsiege no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtFlameFlinger)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Custom Combinations
	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	;;; Custom Combination Donate #1 by ChiefM3, edit by Hervidero
	$g_ahGrpDonateTroop[$eCustomA] = GUICtrlCreateGroup($sDonateTxtCustomA, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 2
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustom, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eCustomA] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomA, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomA & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eCustomA] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomA & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomA & ":", $x - 5, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eCustomA] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_29", "ground support\r\nground")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomA)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_01", "1") & ":", $x - 5, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomA[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWizard, $x + 6, $y, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomA[0] = GUICtrlCreateCombo("", $x + 35, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtWizards)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomA")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomA[0] = _GUICtrlCreateInput("2", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_02", "2") & ":", $x - 5, $y + 29, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomA[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonArcher, $x + 6, $y + 25, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomA[1] = GUICtrlCreateCombo("", $x + 35, $y + 25, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtArchers)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomA")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomA[1] = _GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_03", "3") & ":", $x - 5, $y + 54, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomA[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBarbarian, $x + 6, $y + 50, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomA[2] = GUICtrlCreateCombo("", $x + 35, $y + 50, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtBarbarians)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomA")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomA[2] = _GUICtrlCreateInput("1", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eCustomA] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_29", "no ground\r\nground no\r\nonly")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomA)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	;;; Custom Combination Donate #2 added by MonkeyHunter
	$g_ahGrpDonateTroop[$eCustomB] = GUICtrlCreateGroup($sDonateTxtCustomB, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 2
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustomB, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eCustomB] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomB, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomB & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eCustomB] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomB & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomB & ":", $x - 5, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eCustomB] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_30", "air support\r\nany air")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomB)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_01", -1) & ":", $x - 5, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomB[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBabyDragon, $x + 6, $y, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomB[0] = GUICtrlCreateCombo("", $x + 35, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtBabyDragons)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomB")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomB[0] = _GUICtrlCreateInput("1", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_02", -1) & ":", $x - 5, $y + 29, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomB[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBalloon, $x + 6, $y + 25, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomB[1] = GUICtrlCreateCombo("", $x + 35, $y + 25, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtBalloons)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomB")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomB[1] = _GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_03", -1) & ":", $x - 5, $y + 54, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomB[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMinion, $x + 6, $y + 50, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomB[2] = GUICtrlCreateCombo("", $x + 35, $y + 50, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtMinions)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomB")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomB[2] = _GUICtrlCreateInput("5", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eCustomB] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_30", "no air\r\nair no\r\nonly\r\njust")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomB)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	;;; Additional Custom Donate #3 ~ Additional Custom Donate by NguyenAnhHD
	$g_ahGrpDonateTroop[$eCustomC] = GUICtrlCreateGroup($sDonateTxtCustomC, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 2
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustom, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eCustomC] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomC, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomC & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eCustomC] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomC & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomC & ":", $x - 5, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eCustomC] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_29", -1)))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomC)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_01", -1) & ":", $x - 5, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomC[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWizard, $x + 6, $y, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomC[0] = GUICtrlCreateCombo("", $x + 35, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtWizards)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomC")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomC[0] = _GUICtrlCreateInput("1", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_02", -1) & ":", $x - 5, $y + 29, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomC[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonArcher, $x + 6, $y + 25, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomC[1] = GUICtrlCreateCombo("", $x + 35, $y + 25, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtArchers)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomC")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomC[1] = _GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_03", -1) & ":", $x - 5, $y + 54, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomC[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBarbarian, $x + 6, $y + 50, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomC[2] = GUICtrlCreateCombo("", $x + 35, $y + 50, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtBarbarians)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomC")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomC[2] = _GUICtrlCreateInput("5", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eCustomC] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_29", -1)))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomC)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	;;; Additional Custom Donate #4 ~ Additional Custom Donate by NguyenAnhHD
	$g_ahGrpDonateTroop[$eCustomD] = GUICtrlCreateGroup($sDonateTxtCustomD, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 2
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustomB, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eCustomD] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomD, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomD & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eCustomD] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomD & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomD & ":", $x - 5, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eCustomD] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_30", -1)))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomD)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_01", -1) & ":", $x - 5, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomD[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBabyDragon, $x + 6, $y, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomD[0] = GUICtrlCreateCombo("", $x + 35, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtBabyDragons)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomD")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomD[0] = _GUICtrlCreateInput("1", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_02", -1) & ":", $x - 5, $y + 29, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomD[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBalloon, $x + 6, $y + 25, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomD[1] = GUICtrlCreateCombo("", $x + 35, $y + 25, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtBalloons)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomD")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomD[1] = _GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_03", -1) & ":", $x - 5, $y + 54, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomD[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMinion, $x + 6, $y + 50, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomD[2] = GUICtrlCreateCombo("", $x + 35, $y + 50, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
						GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtSuperBarbarians & "|" & $sTxtArchers & "|" & $sTxtSuperArchers & "|" & $sTxtGiants & "|" & $sTxtSuperGiants & "|" & $sTxtGoblins & "|" & $sTxtSneakyGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtSuperWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtRocketBalloons & "|" & $sTxtWizards & "|" & $sTxtSuperWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtSuperDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtInfernoDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtYetis & "|" & $sTxtDragonRiders & "|" & $sTxtMinions & "|" & $sTxtSuperMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtSuperValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtSuperWitches & "|" & $sTxtLavaHounds & "|" & $sTxtIceHounds & "|" & $sTxtBowlers & "|" & $sTxtSuperBowlers & "|" & $sTxtIceGolems & "|" & $sTxtHeadhunters & "|" & $sTxtNothing, $sTxtMinions)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomD")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomD[2] = _GUICtrlCreateInput("5", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eCustomD] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_30", -1)))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomD)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy + 10 ;HArchH added the +10
	$g_hGrpDonateGeneralBlacklist = GUICtrlCreateGroup( GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "Group_02", "General Blacklist"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBlacklist, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblGeneralBlacklist", "Do NOT donate to any of these keywords") & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hTxtGeneralBlacklist = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtGeneralBlacklist_Item_01", "clan war\r\nwar\r\ncw")))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtGeneralBlacklist_Info_01", "General Blacklist for donation requests"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateDonateSubTab
#EndRegion

#Region CreateScheduleSubTab
Func CreateScheduleSubTab()
	Local $xStart = 25, $yStart = 45
	$g_hGUI_ScheduleCC = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, $xStart - 20, $yStart - 20, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DONATE)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_ScheduleCC)
	Local $xStart = 20, $yStart = 20
	Local $x = $xStart
	Local $y = $yStart
	$g_hGrpDonateCC = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_01", "Donate Schedule"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 120)
	$y += 10
	$x += 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCCDonate, $x - 5, $y, 64, 60, $BS_ICON)

		$g_hChkDonateHoursEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1), $x + 40 + 30, $y - 6)
			GUICtrlSetOnEvent(-1, "chkDonateHours")

	$y += 20
	$x += 90
		$g_hLblDonateCChour = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", -1) & ":", $x, $y, -1, 15)
			Local $sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblDonateCChours[0] = GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[10] = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[11] = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahLblDonateCChoursE = GUICtrlCreateLabel("X", $x + 213, $y + 2, 11, 11)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 15
		$g_ahChkDonateHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkDonateHoursE1")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", -1), $x + 5, $y)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 15
		$g_ahChkDonateHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkDonateHoursE2")
		$g_hLblDonateHoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", -1), $x + 5, $y)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 16
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 130
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_02", "Donation Clan Mates Filter"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 155)
	$y += 10
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblOption_donate_members", "Using this option you can choose to donate to all members of your team (No Filter), donate only to certain friends (White List) or give everyone except a few members of your team (Black List)"), $x , $y - 10, 380, 40, $BS_MULTILINE)
	$y += 35

		$g_hCmbFilterDonationsCC = GUICtrlCreateCombo("", $x, $y, 300, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_01", "No Filter, donate at all Clan Mates") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_02", "No Filter but collect Clan Mates Images") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_03", "Donate only at Clan Mates in White List") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_04", "Donate at all Except at Clan Mates in Black List"), GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_01", -1))
			GUICtrlSetOnEvent(-1, "cmbABAlgorithm")

	$y += 35
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblImages_of_Clan_Mates", "Images of Clan Mates are captured and stored in main folder, move to appropriate folder (White or Black List)"), $x , $y - 10, 380, 30, $BS_MULTILINE)
	$y += 20

		GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "BtnOpen_Images_of_Clan_Mates", "Open Clan Mates Image Folder"), $x + 2, $y, 300, 20,-1)
;~			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonBarbarian, 1)
			GUICtrlSetOnEvent(-1, "btnFilterDonationsCC")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 60
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_03", "Skip donation near full troops"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 45)

		$g_hChkSkipDonateNearFullTroopsEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "ChkSkipDonateNearFullTroopsEnable", "Skip donation near full troops"), $x, $y - 4)
			GUICtrlSetState(-1, $GUI_CHECKED )
			GUICtrlSetOnEvent(-1, "chkskipDonateNearFulLTroopsEnable")

	$x += 180
		$g_hLblSkipDonateNearFullTroopsText = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblSkipDonateNearFullTroopsText", "if troops army camps are greater than"), $x, $y)
	$x += 110
		$g_hTxtSkipDonateNearFullTroopsPercentage = _GUICtrlCreateInput("90", $x + 40 + 30, $y - 2, 20, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
			GUICtrlSetLimit(-1, 2)
	$x += 95
		$g_hLblSkipDonateNearFullTroopsText1 = GUICtrlCreateLabel("%", $x, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 315
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_04", "Balance Donate/Receive"), $x - 20, $y, $g_iSizeWGrpTab3 / 3 * 2 - 5, 40)
	$y += 12
		$g_hChkUseCCBalanced = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_04", -1), $x, $y+2, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "ChkUseCCBalanced_Info_01", "Disable Clan Castle Usage or Donations if Ratio is not correct. Will Auto Continue when the Ratio is correct again"))
			GUICtrlSetOnEvent(-1, "chkBalanceDR")

	$x += 140
		$g_hCmbCCDonated = GUICtrlCreateCombo("", $x + 40, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbCCDonated_Info_01", "Donated ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")
		GUICtrlCreateLabel("/", $x + 73, $y + 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblCCDonated-Received_Info_01", "Wanted donated / received ratio") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblCCDonated-Received_Info_02", "1/1 means donated = received, 1/2 means donated = half the received etc."))
		$g_hCmbCCReceived = GUICtrlCreateCombo("", $x + 80, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbCCReceived_Info_01", "Received ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + $g_iSizeWGrpTab3 / 3 * 2
	$y = $yStart + 315
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_05", "Check Donate Often"), $x - 20, $y, $g_iSizeWGrpTab3 / 3, 40)
	$y += 12
		$g_hChkCheckDonateOften = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_05", -1), $x, $y+2, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "ChkCheckDonateOften_Info_01", "If checked, bot will check for requests every idle round."))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateScheduleSubTab
#EndRegion
