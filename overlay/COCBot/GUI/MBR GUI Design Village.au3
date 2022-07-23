; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_VILLAGE = 0

#include "MBR GUI Design Child Village - Misc.au3"
#include "MBR GUI Design Child Village - Donate.au3"
#include "MBR GUI Design Child Village - Upgrade.au3"
#include "MBR GUI Design Child Village - Achievements.au3"
#include "MBR GUI Design Child Village - Notify.au3"

Global $g_hGUI_VILLAGE_TAB = 0, $g_hGUI_VILLAGE_TAB_ITEM1 = 0, $g_hGUI_VILLAGE_TAB_ITEM2 = 0, $g_hGUI_VILLAGE_TAB_ITEM3 = 0, _
	   $g_hGUI_VILLAGE_TAB_ITEM4 = 0, $g_hGUI_VILLAGE_TAB_ITEM5 = 0

Func CreateVillageTab()
	$g_hGUI_VILLAGE = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_VILLAGE)

	CreateVillageMisc()
	CreateVillageDonate()
	CreateVillageUpgrade()
	CreateVillageNotify()

	GUISwitch($g_hGUI_VILLAGE)
	$g_hGUI_VILLAGE_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $WS_CLIPSIBLINGS)
	$g_hGUI_VILLAGE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_01", "Misc"))
	$g_hGUI_VILLAGE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02", "Req. && Donate"))
	$g_hGUI_VILLAGE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03", "Upgrade"))
	$g_hGUI_VILLAGE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_04", "Achievements"))
		CreateVillageAchievements()
	$g_hGUI_VILLAGE_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_05", "Notify"))
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageTab
