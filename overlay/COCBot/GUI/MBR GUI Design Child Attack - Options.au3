; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Options" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_ATTACKOPTION = 0

#include "MBR GUI Design Child Attack - Options-Search.au3"
#include "MBR GUI Design Child Attack - Options-Attack.au3"
#include "MBR GUI Design Child Attack - Options-SmartZap.au3"
#include "MBR GUI Design Child Attack - Options-EndBattle.au3"
#include "MBR GUI Design Child Attack - Options-TrophySettings.au3"

Global $g_hGUI_ATTACKOPTION_TAB = 0, $g_hGUI_ATTACKOPTION_TAB_ITEM1 = 0, $g_hGUI_ATTACKOPTION_TAB_ITEM2 = 0, $g_hGUI_ATTACKOPTION_TAB_ITEM3 = 0, _
	   $g_hGUI_ATTACKOPTION_TAB_ITEM4 = 0, $g_hGUI_ATTACKOPTION_TAB_ITEM5 = 0

Func CreateAttackSearchOptions()
	$g_hGUI_ATTACKOPTION = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_SEARCH)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_ATTACKOPTION)

	GUISwitch($g_hGUI_ATTACKOPTION)
	$g_hGUI_ATTACKOPTION_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, $WS_CLIPSIBLINGS)
	$g_hGUI_ATTACKOPTION_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_01", -1))
		CreateAttackSearchOptionsSearch()
	$g_hGUI_ATTACKOPTION_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_02", -1))
		CreateAttackSearchOptionsAttack()
	$g_hGUI_ATTACKOPTION_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_05_STab_01", "SmartZap"))
		CreateAttackNewSmartZap()
	$g_hGUI_ATTACKOPTION_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_03", -1))
		CreateAttackSearchOptionsEndBattle()
	$g_hGUI_ATTACKOPTION_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_05_STab_02", "Trophy Settings"))
		CreateAttackSearchOptionsTrophySettings()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackSearchOptions
