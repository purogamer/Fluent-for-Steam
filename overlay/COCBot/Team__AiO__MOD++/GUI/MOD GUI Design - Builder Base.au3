; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Builder Base" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Boldina (2018)
; Remarks .......: This file is part of MultiBot, previously known as MyBot Copyright 2015-2018
;                  MultiBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_BUILDER_BASE = 0, $g_hGUI_LOG_BB = 0
Global $g_hGUI_BUILDER_BASE_TAB = 0, $g_hGUI_BUILDER_BASE_TAB_ITEM1 = 0, $g_hGUI_BUILDER_BASE_TAB_ITEM2 = 0, $g_hGUI_BUILDER_BASE_TAB_ITEM3 = 0
Global $g_hTxtBBAtkLog = 0
Global $g_hChkBuilderAttack = 0, $g_hLblBuilderAttackDisabled = 0

#include "BBase\MOD GUI Design Child Builder Base - Misc.au3"
#include "BBase\MOD GUI Design Child Builder Base - Upgrade.au3"
#include "BBase\MOD GUI Design Child Builder Base - Attack.au3"

Func CreateBuilderBaseTab()
	$g_hGUI_BUILDER_BASE = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_BUILDER_BASE)
	$g_hChkBuilderAttack = GUICtrlCreateCheckbox("", 266, 5, 13, 13)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkBuilderAttack")
	CreateAttackPlanBuilderBaseSubTab()
	$g_hGUI_LOG_BB = _GUICreate("", 310, 225 - 52, 130, 170 + 52, BitOR($WS_CHILD, 0), -1, $g_hGUI_BUILDER_BASE)
	;creating subchilds first!
	GUISwitch($g_hGUI_BUILDER_BASE)
	$g_hGUI_BUILDER_BASE_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $WS_CLIPSIBLINGS)

	$g_hGUI_BUILDER_BASE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_006_STab_01", "Misc && Stats"))
	CreateMiscBuilderBaseSubTab()

	$g_hGUI_BUILDER_BASE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_006_STab_02", "Upgrade"))
	CreateUpgradeBuilderBaseSubTab()

	$g_hGUI_BUILDER_BASE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_006_STab_03", "Versus Battles")& "     ")
  	; this tab will be empty because it is only used to display a child GUI
	; below controls are only shown when the strategy is disabled and the child gui will be hidden.

  	$g_hLblBuilderAttackDisabled = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Main GUI", "disabled_VersusBuilderBase", "Note: Builder Base Versus Battle is disabled, tick the check mark on the ") & GetTranslatedFileIni("MBR Main GUI", "Tab_006_STab_03", "Versus Battles") & ".", 10, 30, $_GUI_MAIN_WIDTH - 40, 50)
	GUICtrlSetState(-1, $GUI_HIDE)

	CreateBBAttackLog()

	CreateBBDropOrderGUI()
	CreateBBUpgradeOrderGUI()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateBuilderBaseTab

Func CreateBBAttackLog()
	Local $x = 0, $y = 0
	Local $activeHWnD1 = WinGetHandle("") ; RichEdit Controls tamper with active window
	$g_hTxtBBAtkLog = _GUICtrlRichEdit_Create($g_hGUI_LOG_BB, "", $x, $y, 310, 225 - 52, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $ES_UPPERCASE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_NUMBER, 0x200), $WS_EX_STATICEDGE)
	WinActivate($activeHWnD1) ; restore current active window

EndFunc   ;==>CreateBBAttackLog

