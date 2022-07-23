; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design
; Description ...: This file creates the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: NguyenAnhHD
; Modified ......: Team AiO MOD++ (2020)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_MOD = 0
Global $g_hGUI_MOD_TAB = 0, $g_hGUI_MOD_TAB_ITEM1 = 0, $g_hGUI_MOD_TAB_ITEM2 = 0, $g_hGUI_MOD_TAB_ITEM3 = 0, $g_hGUI_MOD_TAB_ITEM4 = 0, $g_hGUI_MOD_TAB_ITEM5 = 0, $g_hGUI_MOD_TAB_ITEM6 = 0;, $g_hGUI_MOD_TAB_ITEM7 = 0

#include "MOD GUI Design - SuperXP.au3"
#include "MOD GUI Design - Humanization.au3"
#include "MOD GUI Design - ChatActions.au3"
#include "MOD GUI Design - GTFO.au3"
#include "MOD GUI Design - AiO-Debug.au3"
#include "MOD GUI Design - WarPreparation.au3"

Func CreateMODTab()

	$g_hGUI_MOD = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	GUISwitch($g_hGUI_MOD)
	$g_hGUI_MOD_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $TCS_RIGHTJUSTIFY)

		$g_hGUI_MOD_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_00", "Super XP"))
			TabSuperXPGUI()
		$g_hGUI_MOD_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_02", "Humanization"))
			TabHumanizationGUI()
		$g_hGUI_MOD_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_03", "Chat"))
			TabChatActionsGUI()
		$g_hGUI_MOD_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_04", "GTFO"))
			TabGTFOGUI()
		$g_hGUI_MOD_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_05", "Prewar"))
			TabWarPreparationGUI()

	If $g_bDevMode Then
		$g_hGUI_MOD_TAB_ITEM6 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_06Ex", "Debug"))
		; $g_hGUI_MOD_TAB_ITEM7 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_07", "Debug"))
			TabDebugGUI()
		EndIf

	GUICtrlCreateTabItem("")
EndFunc   ;==>CreateMODTab

; Tab Misc GUI - Team AiO MOD++
 Func TabMiscGUI()
	SplashStep("Loading mod - Misc options ...")

	Local $iX = 32, $iY = 45

	GUICtrlCreateGroup("Misc options", $iX - 28, $iY, 415 + 28, 164 + 25)

	$iY += 25

	GUICtrlCreateLabel(GetTranslatedFileIni("MiscMODs", "AttackLabel",  "Attack"), $iX, $iY, 408, 22, BitOR($SS_CENTER,$SS_CENTERIMAGE))
	GUICtrlSetTip(-1, GetTranslatedFileIni("MiscMODs", "AttackTip",  "Attacks extra functions."))
	GUICtrlSetBkColor(-1, 0x333300)
	GUICtrlSetFont(-1, 12, 500, 0, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, 0xFFCC00)

	$iY += 30

	$g_hChkSkipFirstAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MiscMODs", "ChkSkipFirstAttack", "Skip attack first."), $iX, $iY, 244, 17)
  	GUICtrlSetOnEvent(-1, "chkMiscModOptions")
  	_GUICtrlSetTip(-1, GetTranslatedFileIni("MiscMODs", "ChkBuildingsLocateTip", "Skip first check without attack first."))

	$iY += 25

	GUICtrlCreateLabel(GetTranslatedFileIni("MiscMODs", "OtherSettingsLabel", "Other"), $iX, $iY, 408, 22, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetTip(-1, GetTranslatedFileIni("MiscMODs", "OtherSettingsTip", "Other settings"))
	GUICtrlSetBkColor(-1, 0x333300)
	GUICtrlSetFont(-1, 12, 500, 0, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, 0xFFCC00)
	$iY += 30

  	$g_hChkBuildingsLocate = GUICtrlCreateCheckbox(GetTranslatedFileIni("MiscMODs", "ChkBuildingsLocate",  "Skip buildings location."), 32, $iY, 244, 17)
	GUICtrlSetOnEvent(-1, "chkMiscModOptions")
	$iY += 25

  	$g_hChkEnableFirewall = GUICtrlCreateCheckbox(GetTranslatedFileIni("MiscMODs", "ChkEnableFirewall",  "Timeout telemetry"), 32, $iY, 244, 17)
	GUICtrlSetOnEvent(-1, "chkMiscModOptions")
	$iY += 23

	$g_hChkBotLogLineLimit = GUICtrlCreateCheckbox(GetTranslatedFileIni("MiscMODs", "BotLogLineLimit", "Disable clear bot log, and line limit to: "), $iX, $iY, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MiscMODs", "BotLogLineLimitTips", "Bot log will never clear after battle, and clear bot log will replace will line limit."))
	GUICtrlSetOnEvent(-1, "chkBotLogLineLimit")

	$g_hTxtLogLineLimit = _GUICtrlCreateInput("240", $iX + 300, $iY + 2, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MiscMODs", "BotLogLineLimitValue", "Please enter how many line to limit for the bot log."))
	GUICtrlSetLimit(-1, 4)
	GUICtrlSetOnEvent(-1, "txtLogLineLimit")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateTabItem("")
EndFunc   ;==>TabMiscGUI