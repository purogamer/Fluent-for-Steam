; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_SEARCH = 0

; These global arrays are used at multiple levels in the GUI hierarchy, and must be defined at this common level.  They are referenced in
;   MBR GUI Design Child Attack - Deadbase-Search.au3
;   MBR GUI Design Child Attack - Activebase-Search.au3
Global $g_ahChkMaxMortar[$g_iModeCount] = [0, 0, 0], $g_ahChkMaxWizTower[$g_iModeCount] = [0, 0, 0], $g_ahChkMaxAirDefense[$g_iModeCount] = [0, 0, 0], _
	   $g_ahChkMaxXBow[$g_iModeCount] = [0, 0, 0], $g_ahChkMaxInferno[$g_iModeCount] = [0, 0, 0], $g_ahChkMaxEagle[$g_iModeCount] = [0, 0, 0], $g_ahChkMaxScatter[$g_iModeCount] = [0, 0, 0]
Global $g_ahCmbWeakMortar[$g_iModeCount] = [0, 0, 0], $g_ahCmbWeakWizTower[$g_iModeCount] = [0, 0, 0],  $g_ahCmbWeakAirDefense[$g_iModeCount] = [0, 0, 0], _
	   $g_ahCmbWeakXBow[$g_iModeCount] = [0, 0, 0], $g_ahCmbWeakInferno[$g_iModeCount] = [0, 0, 0], $g_ahCmbWeakEagle[$g_iModeCount] = [0, 0, 0], $g_ahCmbWeakScatter[$g_iModeCount] = [0, 0, 0]

Global $g_ahPicWeakMortar[$g_iModeCount] = [0, 0, 0], $g_ahPicWeakWizTower[$g_iModeCount] = [0, 0, 0], $g_ahPicWeakAirDefense[$g_iModeCount] = [0, 0, 0], _
	   $g_ahPicWeakXBow[$g_iModeCount] = [0, 0, 0], $g_ahPicWeakInferno[$g_iModeCount] = [0, 0, 0], $g_ahPicWeakEagle[$g_iModeCount] = [0, 0, 0], $g_ahPicWeakScatter[$g_iModeCount] = [0, 0, 0]
Global $g_ahChkMeetOne[$g_iModeCount] = [0, 0, 0]

#include "MBR GUI Design Child Attack - Deadbase.au3"
#include "MBR GUI Design Child Attack - Activebase.au3"
#include "MBR GUI Design Child Attack - Bully.au3"
#include "MBR GUI Design Child Attack - Options.au3"

Global $g_hGUI_SEARCH_TAB = 0, $g_hGUI_SEARCH_TAB_ITEM1 = 0, $g_hGUI_SEARCH_TAB_ITEM2 = 0, $g_hGUI_SEARCH_TAB_ITEM3 = 0, $g_hGUI_SEARCH_TAB_ITEM4 = 0
Global $g_hChkDeadbase = 0, $g_hChkActivebase = 0, $g_hChkBully = 0
Global $g_hLblDeadbaseDisabled = 0, $g_hLblActivebaseDisabled = 0, $g_hLblBullyDisabled = 0

Func CreateAttackSearch()
	$g_hGUI_SEARCH = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_ATTACK)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_SEARCH)
	; ---
	; Note:
	; $x, $y=4, $y=6 are used as a dummy here to placehold the controls, the final position of the $x,$y coordinates is dynamically set by use of Func TabSearch() in MBR GUI Control file.
	; This is done to be able to use translation of the tabitem names.
	Local $x = 82
	; ---
	$g_hChkDeadbase = GUICtrlCreateCheckbox("", $x, 6, 13, 13)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "DBcheck")
	$g_hChkActivebase = GUICtrlCreateCheckbox("", $x + 100, 4, 13, 13)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetOnEvent(-1, "Abcheck")
	$g_hChkBully = GUICtrlCreateCheckbox("", $x + 180, 4, 13, 13)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetOnEvent(-1, "Bullycheck")

	;creating subchilds first!
	CreateAttackSearchDeadBase()
	CreateAttackSearchActiveBase()
	CreateAttackSearchBully()
	CreateAttackSearchOptions()

	GUISwitch($g_hGUI_SEARCH)
	; SEARCH tab
	;============
	$g_hGUI_SEARCH_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, $WS_CLIPSIBLINGS)
	$g_hGUI_SEARCH_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_01", "DeadBase") & "    ") ; MUST add 4 spaces to make room for the Checkmark box!
	; this tab will be empty because it is only used to display a child GUI
	; below controls are only shown when the strategy is disabled and the child gui will be hidden.
		$g_hLblDeadbaseDisabled = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_01", "Note: This Strategy is disabled, tick the checkmark on the") & " " & _
													 GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_01", -1) & " " & _
													 GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_02", "tab to enable it!"), 20, 30, $_GUI_MAIN_WIDTH - 40, -1)
		GUICtrlSetState(-1, $GUI_HIDE)

	$g_hGUI_SEARCH_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_02", "ActiveBase") & "    ")
	; this tab will be empty because it is only used to display a child GUI
	; below controls are only shown when the strategy is disabled and the child gui will be hidden.
		$g_hLblActivebaseDisabled = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_01", -1) & " " & _
													   GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_02", -1) & " " & _
													   GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_02", -1), 20, 30, $_GUI_MAIN_WIDTH - 40, -1)
		GUICtrlSetState(-1, $GUI_HIDE)

	$g_hGUI_SEARCH_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_04", "Bully") & "    ")
	; this tab will be empty because it is only used to display a child GUI
		$g_hLblBullyDisabled = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_01", -1) & " " & _
												  GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_04", -1) & " " & _
												  GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_02", -1), 20, 30, $_GUI_MAIN_WIDTH - 40, -1)
		GUICtrlSetState(-1, $GUI_HIDE)

	$g_hGUI_SEARCH_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_05", "Options"))
	; this tab will be empty because it is only used to display a child GUI
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackSearch
