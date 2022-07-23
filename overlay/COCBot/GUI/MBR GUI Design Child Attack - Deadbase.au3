; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hGUI_DEADBASE = 0

#include "MBR GUI Design Child Attack - Deadbase Attack Standard.au3"
#include "MBR GUI Design Child Attack - Deadbase Attack Scripted.au3"
#include "MBR GUI Design Child Attack - Deadbase Attack Smart Farm.au3"
#include "MBR GUI Design Child Attack - Deadbase-Search.au3"
#include "MBR GUI Design Child Attack - Deadbase-Attack.au3"
#include "MBR GUI Design Child Attack - Deadbase-EndBattle.au3"
#include "MBR GUI Design Child Attack - Deadbase-Collectors.au3"

Global $g_hGUI_DEADBASE_TAB = 0, $g_hGUI_DEADBASE_TAB_ITEM1 = 0, $g_hGUI_DEADBASE_TAB_ITEM2 = 0, $g_hGUI_DEADBASE_TAB_ITEM3 = 0, $g_hGUI_DEADBASE_TAB_ITEM4 = 0

Func CreateAttackSearchDeadBase()

	$g_hGUI_DEADBASE = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_SEARCH)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_DEADBASE)

	;creating subchilds first!
	CreateAttackSearchDeadBaseStandard()
	CreateAttackSearchDeadBaseScripted()
	CreateAttackSearchDeadBaseSmartFarm()
	#Region - SmartMilk
	CreateAttackSearchDeadBaseSmartMilk()
	#EndRegion - SmartMilk

	GUISwitch($g_hGUI_DEADBASE)
	$g_hGUI_DEADBASE_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, $WS_CLIPSIBLINGS)
	$g_hGUI_DEADBASE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_01", "Search"))
		CreateAttackSearchDeadBaseSearch()
	$g_hGUI_DEADBASE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_02", "Attack"))
		CreateAttackSearchDeadBaseAttack()
	$g_hGUI_DEADBASE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_03", "End Battle"))
		CreateAttackSearchDeadBaseEndBattle()
	$g_hGUI_DEADBASE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_01_STab_01", "Collectors"))
		CreateAttackSearchDeadBaseCollectors()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackSearchDeadBase

