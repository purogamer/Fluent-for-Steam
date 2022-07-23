; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - Humanization
; Description ...: Design Sub GUI for Humanization
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: RoroTiti (2016)
; Modified ......: Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Global $g_hChkLookAtRedNotifications = 0
Global $g_hChkUseBotHumanization = 0, $g_hChkUseAltRClick = 0, $g_hChallengeMessage = 0
Global $g_hLabel1 = 0, $g_hLabel2 = 0, $g_hLabel3 = 0, $g_hLabel4 = 0
Global $g_hLabel5 = 0, $g_hLabel6 = 0, $g_hLabel7 = 0, $g_hLabel8 = 0
Global $g_hLabel9 = 0, $g_hLabel10 = 0, $g_hLabel11 = 0, $g_hLabel12 = 0
Global $g_hLabel14 = 0, $g_hLabel15 = 0, $g_hLabel16 = 0, $g_hLabel13 = 0
Global $g_hLabel17 = 0, $g_hLabel18 = 0, $g_hLabel20 = 0
Global $g_acmbPriority[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_acmbMaxSpeed[2] = [0, 0]
Global $g_acmbPause[2] = [0, 0]
Global $g_hCmbMaxActionsNumber = 0
; Global $g_ahumanMessage[2] = ["", ""]

Func TabHumanizationGUI()
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Group_01", "Settings"), $x - 20, $y - 20, 440, 400)

	$x -= 15
	$y += 5
	$g_hChkUseBotHumanization = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "chkUseBotHumanization", "Enable Bot Humanization"), 50, $y, 136, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_02", "Bot performs more Human-Like behaviors."))
	GUICtrlSetOnEvent(-1, "chkUseBotHumanization")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$g_hChkLookAtRedNotifications = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "chkLookAtRedNotifications", "Look Red/Purple Flag on Button"), 50, $y + 31, 182, 17)
	GUICtrlSetOnEvent(-1, "chkLookAtRedNotifications")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x += 6
	$y += 30

	$g_hLabel1 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_01", "Read The Clan Chat"), $x + 232, $y + 3, 110, 17)
	$g_acmbPriority[0] = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))

	$y += 30 ; Team AIO Mod++
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModRepeat, $x, $y + 5, 32, 32)
	$g_hLabel5 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_05", "Watch Defenses"), $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[1] = GUICtrlCreateCombo("", $x + 140, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))
	GUICtrlSetOnEvent(-1, "cmbStandardReplay")
	$g_hLabel6 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_06", "Watch Attacks"), $x + 40, $y + 30, 110, 17)
	$g_acmbPriority[2] = GUICtrlCreateCombo("", $x + 140, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))
	GUICtrlSetOnEvent(-1, "cmbStandardReplay")
	$g_hLabel7 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_07", "Max Replay Speed"), $x + 232, $y + 5, 110, 17)
	$g_acmbMaxSpeed[0] = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sReplayChain, "2")
	$g_hLabel8 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_08", "Pause Replay"), $x + 232, $y + 30, 110, 17)
	$g_acmbPause[0] = GUICtrlCreateCombo("", $x + 342, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))

	$y += 62

	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModClan, $x, $y + 5, 32, 32)
	$g_hLabel9 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_09", "Look at War log"), $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[3] = GUICtrlCreateCombo("", $x + 140, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))
	$g_hLabel10 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_10", "Visit Clanmates"), $x + 40, $y + 30, 110, 17)
	$g_acmbPriority[4] = GUICtrlCreateCombo("", $x + 140, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))
	$g_hLabel11 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_11", "Look at Best Players"), $x + 232, $y + 5, 110, 17)
	$g_acmbPriority[5] = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))
	$g_hLabel12 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_12", "Look at Best Clans"), $x + 232, $y + 30, 110, 17)
	$g_acmbPriority[6] = GUICtrlCreateCombo("", $x + 342, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))

	$y += 62

	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModTarget, $x, $y + 5, 32, 32)
	$g_hLabel14 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_14", "Look at Current War"), $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[7] = GUICtrlCreateCombo("", $x + 140, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))
	$g_hLabel16 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_16", "Watch Replays"), $x + 40, $y + 30, 110, 17)
	$g_acmbPriority[8] = GUICtrlCreateCombo("", $x + 140, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))
	GUICtrlSetOnEvent(-1, "cmbWarReplay")
	$g_hLabel13 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_13", "Max Replay Speed"), $x + 232, $y + 5, 110, 17)
	$g_acmbMaxSpeed[1] = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sReplayChain, "2")
	$g_hLabel15 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_15", "Pause Replay"), $x + 232, $y + 30, 110, 17)
	$g_acmbPause[1] = GUICtrlCreateCombo("", $x + 342, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))

	$y += 52

	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModSettings, $x, $y + 5, 32, 32)

	$y += 10

	$g_hLabel17 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_17", "Do nothing"), $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[9] = GUICtrlCreateCombo("", $x + 140, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptions", $g_sFrequenceChain), GetTranslatedFileIni("MOD GUI Design - BotHumanization", "LblHumanizationOptionNever", "Never"))
	$g_hLabel18 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - BotHumanization", "Label_18", "Max Actions by Loop"), $x + 232, $y + 5, 103, 17)
	$g_hCmbMaxActionsNumber = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "1|2|3|4|5", "2")

	$y += 40

	_GUICtrlCreatePic($g_sIcnHumanization, $x - 4, $y, 426, 80)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	For $i = $g_hChkLookAtRedNotifications To $g_hCmbMaxActionsNumber
		GUICtrlSetState($i, $GUI_DISABLE)
	Next

	chkUseBotHumanization()   ;==>TabHumanizationGUI

EndFunc   ;==>TabHumanizationGUI