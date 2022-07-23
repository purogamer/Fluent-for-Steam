; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "End Battle" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hChkStopAtkDBNoLoot1 = 0, $g_hTxtStopAtkDBNoLoot1 = 0, $g_hChkStopAtkDBNoLoot2 = 0, $g_hTxtStopAtkDBNoLoot2 = 0, _
	   $g_hTxtDBMinGoldStopAtk2 = 0, $g_hTxtDBMinElixirStopAtk2 = 0, $g_hTxtDBMinDarkElixirStopAtk2 = 0, _
	   $g_hChkDBEndNoResources = 0, $g_hChkDBEndOneStar = 0, $g_hChkDBEndTwoStars = 0, _
	   $g_hChkDBEndPercentHigher = 0, $g_hTxtDBPercentHigher = 0, $g_hChkDBEndPercentChange = 0, $g_hTxtDBPercentChange = 0

Global $g_hGrpDBEndBattle = 0, $g_hLblStopAtkDBNoLoot1a = 0, $g_hLblStopAtkDBNoLoot1b = 0, $g_hLblStopAtkDBNoLoot2a = 0, $g_hLblStopAtkDBNoLoot2b = 0, _
	   $g_hLblDBMinRerourcesAtk2 = 0, $g_hPicDBMinGoldStopAtk2 = 0, $g_hPicDBMinElixirStopAtk2 = 0, $g_hPicDBMinDarkElixirStopAtk2 = 0, _
	   $g_hLblDBPercentHigher = 0, $g_hLblDBPercentHigherSec = 0, $g_hLblDBPercentChange = 0, $g_hLblDBPercentChangeSec = 0

Func CreateAttackSearchDeadBaseEndBattle()
	Local $sTxtTip = ""
	Local $x = 10, $y = 45
	$g_hGrpDBEndBattle = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "Group_01", "Exit Battle"), $x - 5, $y - 20, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
	$y -= 5
		$g_hChkStopAtkDBNoLoot1 = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot", "When no New loot"), $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot_Info_01", "End Battle if there is no extra loot raided within this No. of seconds.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot_Info_02", "Countdown is started after all Troops and Royals are deployed in battle.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkStopAtkDBNoLoot1")
			GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 20
		$g_hLblStopAtkDBNoLoot1a = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblStopAtkNoLoot", "raided within") & ":", $x + 16, $y + 3, -1, -1)
		$g_hTxtStopAtkDBNoLoot1 = _GUICtrlCreateInput("15", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
		$g_hLblStopAtkDBNoLoot1b = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 120, $y + 3, -1, -1)

	$y += 20
		$g_hChkStopAtkDBNoLoot2 = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot", -1), $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot_Info_01", -1) & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkStopAtkNoLoot_Info_02", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkStopAtkDBNoLoot2")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
	$y += 20
		$g_hLblStopAtkDBNoLoot2a = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblStopAtkNoLoot", -1) & ":", $x + 16, $y + 3, -1, -1)
		$g_hTxtStopAtkDBNoLoot2 = _GUICtrlCreateInput("5", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblStopAtkDBNoLoot2b = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 120, $y + 3, -1, -1)

	$y += 21
		$g_hLblDBMinRerourcesAtk2 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblMinRerourcesAtk2", "And Resources are below") & ":", $x + 16, $y + 2, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblMinRerourcesAtk2_Info_01", "End Battle if below this amount of")
			_GUICtrlSetTip(-1, $sTxtTip & " resources.")
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 21
		$g_hTxtDBMinGoldStopAtk2 = _GUICtrlCreateInput("2000", $x + 65, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip & " gold.")
			GUICtrlSetLimit(-1, 7) ; Custom fix - Team AIO Mod++
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hPicDBMinGoldStopAtk2 = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 117, $y, 16, 16)
	$y += 21
		$g_hTxtDBMinElixirStopAtk2 = _GUICtrlCreateInput("2000", $x + 65, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip & " elixir.")
			GUICtrlSetLimit(-1, 7) ; Custom fix - Team AIO Mod++
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hPicDBMinElixirStopAtk2 = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 117, $y, 16, 16)
	$y += 21
		$g_hTxtDBMinDarkElixirStopAtk2 = _GUICtrlCreateInput("50", $x + 65, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip & " dark elixir.")
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hPicDBMinDarkElixirStopAtk2 = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 117, $y, 16, 16)
	$y += 21
		$g_hChkDBEndNoResources = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndNoResources", "When no Resources left"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndNoResources_Info_01", "End Battle when all Gold, Elixir and Dark Elixir = 0"))
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 21
		$g_hChkDBEndOneStar = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndOneStar", "When One Star is won"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndOneStar_Info_01", "Will End the Battle if 1 star is won in battle"))
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 21
		$g_hChkDBEndTwoStars = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndTwoStars", "When Two Stars are won"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndTwoStars_Info_01", "Will End the Battle if 2 stars are won in battle"))
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 21
		$g_hChkDBEndPercentHigher = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentHigher", "When Percentage is"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentHigher_Info_01", "End Battle if Overall Damage Percentage is above"))
			GUICtrlSetOnEvent(-1, "chkDBEndPercentHigher")
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 20
		$g_hLblDBPercentHigher = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblPercentHigher", "above") & ":", $x + 16, $y + 2, -1, -1)
		$g_hTxtDBPercentHigher = _GUICtrlCreateInput("60", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentHigher_Info_01", -1))
			GUICtrlSetLimit(-1, 3)
		$g_hLblDBPercentHigherSec = GUICtrlCreateLabel("%", $x + 120, $y + 3, -1, -1)
	$y += 21
		$g_hChkDBEndPercentChange = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentChange", "When Percentage doesn't"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentChange_Info_01", "End Battle when Percentage doesn't change in"))
			GUICtrlSetOnEvent(-1, "chkDBEndPercentChange")
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 20
		$g_hLblDBPercentChange = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblPercentChange", "change in") & ":", $x + 16, $y + 3, -1, -1)
		$g_hTxtDBPercentChange = _GUICtrlCreateInput("15", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "ChkEndPercentChange_Info_01", -1))
			GUICtrlSetLimit(-1, 2)
		$g_hLblDBPercentChangeSec = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 120, $y + 3, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchDeadBaseEndBattle
