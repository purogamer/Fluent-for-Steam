; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Collectors" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hChkDBDisableCollectorsFilter = 0
Global $g_ahChkDBCollectorLevel[16] = [-1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; elements 0 thru 5 are never referenced ; Custom - Team AiO MOD++
Global $g_ahCmbDBCollectorLevel[16] = [-1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; elements 0 thru 5 are never referenced ; Custom - Team AiO MOD++
Global $g_hCmbMinCollectorMatches = 0, $g_hSldCollectorTolerance = 0, $g_hLblCollectorWarning = 0

; Check Collectors Outside - Team AiO MOD++
Global $g_hChkDBMeetCollectorOutside = 0, $g_hLblDBMinCollectorOutside = 0, $g_hTxtDBMinCollectorOutsidePercent = 0, $g_hChkDBCollectorNone = 0
Global $g_hChkDBCollectorNearRedline = 0, $g_hCmbRedlineTiles = 0, $g_hLblRedlineTiles = 0
Global $g_hChkSkipCollectorCheck = 0, $g_hLblSkipCollectorCheck = 0, _
		$g_hTxtSkipCollectorGold = 0, $g_hLblSkipCollectorGold = 0, _
		$g_hTxtSkipCollectorElixir = 0, $g_hLblSkipCollectorElixir = 0, _
		$g_hTxtSkipCollectorDark = 0, $g_hLblSkipCollectorDark = 0
Global $g_hChkSkipCollectorCheckTH = 0, $g_hCmbSkipCollectorCheckTH = 0, $g_hLblSkipCollectorCheckTH = 0

Func CreateAttackSearchDeadBaseCollectors()
	Local $x = 10, $y = 43
	Local $s_TxtTip1 = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel_Info_01", "If this box is checked, then the bot will look")
	;Local $g_hTxtFull = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel_Info_02", "Full")
	Local $sTxtTip = ""

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "Group_01", "Collectors"), $x - 5, $y - 20, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel", "Choose which collectors to search for while looking for a dead base. Also, choose how full they must be."), $x, $y, 250, 28)
	$y += 15
		$g_hChkDBDisableCollectorsFilter = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDisableCollectorsFilter", "Disable Collector Filter"), $x, $y + 17, 120, 18)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDisableCollectorsFilter_Info_01", "Disable Collector Filter CHANGES DeadBase into another ActiveBase search"))

	$y += 15
	For $i = 6 To Ubound($g_aiCollectorLevelFill) -1
		$y += 25
			$g_ahChkDBCollectorLevel[$i] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
				$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel" & $i & "_Info_01", "for level " & $i & " elixir collectors during dead base detection.")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState(-1, ($i = 6) ? (GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)) : (($g_abCollectorLevelEnabled[$i] = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))
				GUICtrlSetOnEvent(-1, "chkDBCollector")
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel" & $i, "Lvl " & $i & ". Must be >"), $x + 40, $y + 3, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_ahCmbDBCollectorLevel[$i] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel" & $i & "_Info_01", "Select how full a level " & $i & ' collector needs to be for it to be marked "dead"'))
				GUICtrlSetData(-1, "50%|100%", ($i > 12) ? ("50%") : ("100%"))
				GUICtrlSetOnEvent(-1, "cmbDBCollector")
			;GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)
	Next

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblMinCollectorMatches", "Collectors required"), $x, $y + 3, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "CmbMinCollectorMatches_Info_01", 'Select how many collectors are needed to consider village "dead"')
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hCmbMinCollectorMatches = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6", String($g_iCollectorMatchesMin))
			GUICtrlSetOnEvent(-1, "cmbMinCollectorMatches")

	$y += 25
		GUICtrlCreateLabel("-15" & _PadStringCenter(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorTolerance", "Tolerance"), 66, " ") & "15", $x, $y)
		;If $g_bDevMode = False Then
			GUICtrlSetState(-1, $GUI_HIDE)
		;EndIf

	$y += 15
		$g_hSldCollectorTolerance = GUICtrlCreateSlider($x, $y, 250, 20, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_01", "Use this slider to adjust the tolerance of ALL images.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_02", "If you want to adjust individual images, you must edit the files.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_03", "WARNING: Do not change this setting unless you know what you are doing. Set it to 0 if you're not sure."))
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 15, -15) ; change max/min value
			GUICtrlSetData(-1, 0) ; default value
			GUICtrlSetOnEvent(-1, "sldCollectorTolerance")
		;If $g_bDevMode = False Then
			GUICtrlSetState(-1, $GUI_HIDE)
		;EndIf

	$y += 25
		$g_hLblCollectorWarning = GUICtrlCreateLabel("Warning: no collecters are selected. The bot will never find a dead base.", $x, $y, 255, 30)
			GUICtrlSetFont(-1, 10, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_ERROR)
			GUICtrlSetState(-1, $GUI_HIDE)

	; Check Collectors Outside - Team AiO MOD++
	$y -= 300
	$x += 230
		$g_hChkDBCollectorNone = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDBNone", "None"), $x, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkCollectorsAndRedLines")

	$y += 20
		$g_hChkDBMeetCollectorOutside = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDBMeetCollectorOutside", "Check Collectors Outside"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDBMeetCollectorOutside_Info_01", "Search for bases that has their collectors outside."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkCollectorsAndRedLines")

	$y += 28
		$g_hLblDBMinCollectorOutside = GUICtrlCreateLabel("Min" & ": ", $x + 20, $y, -1, -1)
		GUICtrlCreateLabel("%", $x + 85, $y, -1, -1)
		$g_hTxtDBMinCollectorOutsidePercent = _GUICtrlCreateInput("80", $x + 50, $y - 3, 31, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDBMeetCollectorOutside_Info_02", "Set the Min. % of collectors outside to search for on a village to attack."))
			GUICtrlSetLimit(-1, 3)

	$y += 20
		$g_hChkDBCollectorNearRedline = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDBCollectorNearRedline", "Collectors Near Redline"), $x, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDBCollectorNearRedline_Info_01", "Check how many collectors are near redline. If more than % you set then attack."))
			GUICtrlSetOnEvent(-1, "chkCollectorsAndRedLines")
	$y += 28
		$g_hLblRedlineTiles = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblRedlineTiles", "Tiles") & ": ", $x + 20, $y, -1, -1)
		$g_hCmbRedlineTiles = GUICtrlCreateCombo("", $x + 50, $y - 3, 31, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6", "1")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "CmbRedlineTiles_Info_01", "Distance between redline to collectors. Use Tiles as measure."))

	$y += 20
		$g_hChkSkipCollectorCheck = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkSkipCollectorCheck", "Skip Outside Collectors Check"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkSkipCollectorCheck_Info_01", "If you don't want compare one of the resource below, just set to 0"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkSkipCollectorCheck")
	$y += 25
		$g_hLblSkipCollectorCheck = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblSkipCollectorCheck", "IF Target Resource Over"), $x + 15, $y, -1, -1)
	$y += 20
		$g_hLblSkipCollectorGold = GUICtrlCreateLabel(ChrW(8805), $x, $y + 2, -1, -1)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 60, $y, 16, 16)
		$g_hTxtSkipCollectorGold = _GUICtrlCreateInput("400000", $x + 8, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "TxtSkipCollectorGold", "Skip outside collectors check IF target Gold value over"))
			GUICtrlSetLimit(-1, 7)
	$x += 90
		$g_hLblSkipCollectorElixir = GUICtrlCreateLabel(ChrW(8805), $x, $y + 2, -1, -1)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 60, $y, 16, 16)
		$g_hTxtSkipCollectorElixir = _GUICtrlCreateInput("400000", $x + 8, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "TxtSkipCollectorElixir", "Skip outside collectors check IF target Elixir value over"))
			GUICtrlSetLimit(-1, 7)
	$y += 25
		$g_hLblSkipCollectorDark = GUICtrlCreateLabel(ChrW(8805), $x - 40, $y + 2, -1, -1)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 20, $y, 16, 16)
		$g_hTxtSkipCollectorDark = _GUICtrlCreateInput("0", $x - 32, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "TxtSkipCollectorDark", "Skip outside collectors check IF target Dark Elixir value over"))
			GUICtrlSetLimit(-1, 6)

	$y += 25
	$x -= 90
		$g_hChkSkipCollectorCheckTH = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkSkipCollectorCheckTH", "Skip Outside Collectors Check IF"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkSkipCollectorCheckTH_Info_01", "Compare the level if is lower than or equal my setting, just attack!"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkSkipCollectorCheckTH")
	$y += 25
		$g_hLblSkipCollectorCheckTH = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblSkipCollectorCheckTH", "Target Townhall Level"), $x + 10, $y, -1, -1)
		GUICtrlCreateLabel(ChrW(8804), $x + 120, $y, -1, -1)
		$g_hCmbSkipCollectorCheckTH = GUICtrlCreateCombo("", $x + 130, $y - 2, 36, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "7|8|9|10|11|12|13|14", "8")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchDeadBaseCollectors
