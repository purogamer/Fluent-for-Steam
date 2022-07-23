; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "End Battle" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hChkStopAtkABNoLoot1 = 0, $g_hTxtStopAtkABNoLoot1 = 0, $g_hChkStopAtkABNoLoot2 = 0, $g_hTxtStopAtkABNoLoot2 = 0, _
	   $g_hTxtABMinGoldStopAtk2 = 0, $g_hTxtABMinElixirStopAtk2 = 0, $g_hTxtABMinDarkElixirStopAtk2 = 0, _
	   $g_hChkABEndNoResources = 0, $g_hChkABEndOneStar = 0, $g_hChkABEndTwoStars = 0, $g_hChkABEndPercentHigher = 0, $g_hTxtABPercentHigher = 0, $g_hChkABEndPercentChange = 0, $g_hTxtABPercentChange = 0
Global $g_hChkDESideEB = 0, $g_hTxtDELowEndMin = 0, $g_hChkDisableOtherEBO = 0, $g_hChkDEEndOneStar = 0, $g_hChkDEEndBk = 0, $g_hChkDEEndAq = 0

Global $g_hGrpABEndBattle = 0, $g_hLblABTimeStopAtka = 0, $g_hLblABTimeStopAtk = 0, $g_hLblABTimeStopAtk2a = 0, $g_hLblABTimeStopAtk2 = 0, _
	   $g_hLblABMinRerourcesAtk2 = 0, $g_hPicABMinGoldStopAtk2 = 0, $g_hPicABMinElixirStopAtk2 = 0, $g_hPicABMinDarkElixirStopAtk2 = 0
Global $g_hLblDELowEndMin = 0, $g_hLblDEEndAq = 0, $g_hLblABPercentHigher = 0, $g_hLblABPercentHigherSec = 0, $g_hLblABPercentChange = 0, $g_hLblABPercentChangeSec = 0

Func CreateAttackSearchActiveBaseEndBattle()
	Local $sTxtTip = ""
	Local $x = 10, $y = 45
	$g_hGrpABEndBattle = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "Group_01", -1), $x - 5, $y - 20, 155, $g_iSizeHGrpTab4)
	$y -=5
		$g_hChkStopAtkABNoLoot1 = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot", -1), $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot_Info_01", -1) & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot_Info_02", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkStopAtkABNoLoot1")
			GUICtrlSetState(-1, $GUI_CHECKED)

	$y += 20
		$g_hLblABTimeStopAtka = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblStopAtkNoLoot", -1) & ":", $x + 16, $y + 3, -1, -1)
		$g_hTxtStopAtkABNoLoot1 = _GUICtrlCreateInput("20", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
		$g_hLblABTimeStopAtk = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 120, $y + 3, -1, -1)

	$y += 20
		$g_hChkStopAtkABNoLoot2 = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot", -1), $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot_Info_01", -1) & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot_Info_02", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkStopAtkABNoLoot2")
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 20
		$g_hLblABTimeStopAtk2a = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblStopAtkNoLoot", -1) & ":", $x + 16, $y + 3, -1, -1)
		$g_hTxtStopAtkABNoLoot2 = _GUICtrlCreateInput("5", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblABTimeStopAtk2 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 120, $y + 3, -1, -1)

	$y += 21
		$g_hLblABMinRerourcesAtk2 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblMinRerourcesAtk2", -1) & ":", $x + 16, $y + 2, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblMinRerourcesAtk2_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip & " resources.")
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 21
		$g_hTxtABMinGoldStopAtk2 = _GUICtrlCreateInput("2000", $x + 65, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip & " gold.")
			GUICtrlSetLimit(-1, 7) ; Custom fix - Team AIO Mod++
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hPicABMinGoldStopAtk2 = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 117, $y, 16, 16)

	$y += 21
		$g_hTxtABMinElixirStopAtk2 = _GUICtrlCreateInput("2000", $x + 65, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip & " elixir.")
			GUICtrlSetLimit(-1, 7) ; Custom fix - Team AIO Mod++
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hPicABMinElixirStopAtk2 = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 117, $y, 16, 16)

	$y += 21
		$g_hTxtABMinDarkElixirStopAtk2 = _GUICtrlCreateInput("50", $x + 65, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip & "dark elixir.")
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hPicABMinDarkElixirStopAtk2 = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 117, $y, 16, 16)

	$y += 21
		$g_hChkABEndNoResources = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndNoResources", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndNoResources_Info_01", -1))
			GUICtrlSetState(-1, $GUI_ENABLE)

	$y += 21
		$g_hChkABEndOneStar = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndOneStar", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndOneStar_Info_01", -1))
			GUICtrlSetState(-1, $GUI_ENABLE)

	$y += 21
		$g_hChkABEndTwoStars = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndTwoStars", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndTwoStars_Info_01", -1))
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 21
		$g_hChkABEndPercentHigher = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentHigher", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentHigher_Info_01", -1))
			GUICtrlSetOnEvent(-1, "chkABEndPercentHigher")
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 20
		$g_hLblABPercentHigher = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblPercentHigher", -1) & ":", $x + 16, $y + 2, -1, -1)
		$g_hTxtABPercentHigher = _GUICtrlCreateInput("60", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentHigher_Info_01", -1))
			GUICtrlSetLimit(-1, 2)
		$g_hLblABPercentHigherSec = GUICtrlCreateLabel("%", $x + 120, $y + 3, -1, -1)
	$y += 21
		$g_hChkABEndPercentChange = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentChange", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentChange_Info_01", -1))
			GUICtrlSetOnEvent(-1, "chkABEndPercentChange")
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 20
		$g_hLblABPercentChange = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblPercentChange", -1) & ":", $x + 16, $y + 3, -1, -1)
		$g_hTxtABPercentChange = _GUICtrlCreateInput("15", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentChange_Info_01", -1))
			GUICtrlSetLimit(-1, 2)
		$g_hLblABPercentChangeSec = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 120, $y + 3, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 185, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "Group_02", "DE side End Battle options"), $x - 20, $y - 20, 259, $g_iSizeHGrpTab4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LabelDE_01", "Attack Dark Elixir Side, End Battle Options") & ":", $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LabelDE_Info_01", "Enabled by selecting DE side attack in ActiveBase Deploy - Attack On: options"))

		$y += 15
		$x -= 10
			$g_hChkDESideEB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkDESideEB", "When below") & ":", $x, $y, -1, -1)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkDESideEB_Info_01", "Enables Special conditions for Dark Elixir side attack.") & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkDESideEB_Info_02", "If no additional filters are selected will end battle when below Total Dark Elixir Percent.")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "chkDESideEB")
			$g_hTxtDELowEndMin = _GUICtrlCreateInput("25", $x + 92, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetLimit(-1, 2)
				GUICtrlSetState(-1, $GUI_DISABLE)
			$g_hLblDELowEndMin = GUICtrlCreateLabel("%", $x + 136, $y + 2, -1, -1)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 147, $y, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 20
			$g_hChkDisableOtherEBO = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkDisableOtherEBO", "Disable Normal End Battle Options"), $x, $y, -1, -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkDisableOtherEBO_Info_01", "Disable Normal End Battle Options when DE side attack is found."))
				GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 20
			$g_hChkDEEndOneStar = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndOneStar", -1) & ":", $x, $y, -1, -1)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndOneStar_Info_02", "Will End the Battle when below min DE and One Star is won.")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 135, $y + 2, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 20
			$g_hChkDEEndBk = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkDEEnd", "When"), $x, $y, -1, -1)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkDEEnd_Info_01", "Will End the Battle when below min DE and King is weak")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x + 50, $y + 2, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblDEEnd", "is weak"), $x + 70, $y + 4, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 20
			$g_hChkDEEndAq = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkDEEnd", -1), $x, $y, -1, -1)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkDEEnd_Info_02", "Will End the Battle when below min DE and Queen is weak")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x + 50, $y + 2, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hLblDEEndAq = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblDEEnd", -1), $x + 70, $y + 4, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchActiveBaseEndBattle
