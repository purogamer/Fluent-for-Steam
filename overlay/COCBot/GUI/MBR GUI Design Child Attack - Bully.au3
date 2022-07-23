; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Bully" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hGUI_BULLY = 0

Global $g_hTxtATBullyMode = 0, $g_hCmbBullyMaxTH = 0, $g_hRadBullyUseDBAttack = 0, $g_hRadBullyUseLBAttack = 0
Global $g_hGrpBullyAtkCombo = 0, $g_hLblBullyMode = 0, $g_hLblATBullyMode = 0

Global $g_ahPicBullyMaxTH[15]

Func CreateAttackSearchBully()

	$g_hGUI_BULLY = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_SEARCH)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_BULLY)
	GUISwitch($g_hGUI_BULLY)

	Local $sTxtTip = ""
	Local $x = 20, $y = 130 - 105
		$g_hGrpBullyAtkCombo = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "Group_01", "Bully Attack Combo"), $x - 20, $y - 20, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3 - 6)
		$y -= 5
		$x -= 10
			$g_hLblBullyMode = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "LblBullyMode", "In Bully Mode, ALL bases that meet the TH level requirement below will be attacked."), $x - 5, $y + 3, 209, 30, $SS_LEFT)

		$y += 35
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "LblSearch", "Enable Bully after"), $x, $y + 3)
			$g_hTxtATBullyMode = _GUICtrlCreateInput("150", $x + 95, $y, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				GUICtrlSetLimit(-1, 3)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "LblSearch_Info_01", "TH Bully: No. of searches to wait before activating."))
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "search(es).", "search(es)."), $x + 135, $y + 5, -1, -1)

		$y += 25
			$g_hLblATBullyMode = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "LblATBullyMode", "Max TH level") & ":", $x - 5, $y + 3, 90, -1, $SS_RIGHT)
			$g_hCmbBullyMaxTH = GUICtrlCreateCombo("", $x + 85, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "CmbBullyMaxTH_Info_01", "TH Bully: Max. Townhall level to bully.")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetData(-1, "4-6|7|8|9|10|11|12|13|14", "4-6")
				GUICtrlSetOnEvent(-1, "CmbBullyMaxTH")
			$g_ahPicBullyMaxTH[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV06, $x + 137, $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState (-1, $GUI_SHOW)
			$g_ahPicBullyMaxTH[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV07, $x + 137, $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState (-1, $GUI_HIDE)
			$g_ahPicBullyMaxTH[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV08, $x + 137, $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState (-1, $GUI_HIDE)
			$g_ahPicBullyMaxTH[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV09, $x + 137, $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState (-1, $GUI_HIDE)
			$g_ahPicBullyMaxTH[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV10, $x + 137, $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState (-1, $GUI_HIDE)
			$g_ahPicBullyMaxTH[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV11, $x + 137, $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState (-1, $GUI_HIDE)
			$g_ahPicBullyMaxTH[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV12, $x + 137, $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState (-1, $GUI_HIDE)
			$g_ahPicBullyMaxTH[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV13, $x + 137, $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState (-1, $GUI_HIDE)

		$y += 24
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "LblWhenFound", "When found, Attack with settings from") & ":", $x + 10, $y, -1, -1, $SS_RIGHT)

		$y += 14
			$g_hRadBullyUseDBAttack = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "RadBullyUseDBAttack", "DeadBase Atk."), $x + 20, $y, -1, -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "RadBullyUseDBAttack_Info_01", "Use Dead Base attack settings when attacking a TH Bully match."))
				GUICtrlSetState(-1, $GUI_CHECKED)
			$g_hRadBullyUseLBAttack = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "RadBullyUseLBAttack", "Active Base Atk."), $x + 115, $y, -1, -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Bully", "RadBullyUseLBAttack_Info_01", "Use Active Base attack settings when attacking a TH Bully match."))
		GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchBully
