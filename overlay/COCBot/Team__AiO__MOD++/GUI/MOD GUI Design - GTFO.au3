; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - GTFO
; Description ...: This file is used for Fenix MOD GUI functions of GTFO Tab will be here.
; Author ........: Boldina/Boludoz (2018 FOR SIMBIOS)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Global $g_hLblGFTO = 0, $g_hExitAfterCyclesGTFO = 0, $g_hChkUseGTFO = 0, $g_hTxtMinSaveGTFO_Elixir = 0, $g_hTxtMinSaveGTFO_DE = 0, $g_hTxtCyclesGTFO = 0
Global $g_hLblKickout = 0, $g_hChkUseKickOut = 0, $g_hTxtDonatedCap = 0, $g_hTxtReceivedCap = 0, $g_hChkKickOutSpammers = 0, $g_hTxtKickLimit = 0
Global $g_hLblInitialDonated = 0, $g_hLblCurrentDonated = 0, $g_hGUI_GTFOMOD = 0
Global $g_hChkGTFOClanHop = False, $g_hChkGTFOReturnClan = False

Func TabGTFOGUI()

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - Misc", "Group_01", "Special Kickass Donation"), $x - 20, $y, $g_iSizeWGrpTab2, 230)
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)

	$y += 17
	$x -= 17
	$g_hLblGFTO = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "LblGTFO", "Lightning Fast Troops'n'Spells Donation"), $x, $y, 436, 22, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Misc", "LblGTFO_Info_01", "This is a Standalone feature!") & @CRLF & _
			GetTranslatedFileIni("MOD GUI Design - Misc", "LblGTFO_Info_02", "Just Set your custom train, correct capacities") & @CRLF & _
			GetTranslatedFileIni("MOD GUI Design - Misc", "LblGTFO_Info_03", "And This feature!"))
	GUICtrlSetBkColor($g_hLblGFTO, 0x333300) ; Blue
	GUICtrlSetFont($g_hLblGFTO, 12, 500, 0, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, 0xFFCC00)

	$y += 30
	$g_hChkUseGTFO = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Misc", "ChkUseGTFO", "Enable it (at your own risks...)"), $x + 20, $y, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyGTFO")

	$y += 5
	$x -= 15
	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "LblMinSaveGTFO_01", "Exit SKD when Elixir") & " <", $x + 25, $y + 25, -1, -1)
	$g_hTxtMinSaveGTFO_Elixir = _GUICtrlCreateInput("200000", $x + 160 + 75, $y + 22, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyElixirGTFO")

	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "LblMinSaveGTFO_02", "Exit SKD when Dark Elixir") & " <", $x + 25, $y + 50, -1, -1)
	$g_hTxtMinSaveGTFO_DE = _GUICtrlCreateInput("2000", $x + 160 + 75, $y + 47, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyDarkElixirGTFO")

	$g_hChkGTFOClanHop = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Misc", "GTFOClanHop", "Clan hop after jump donate"), $x + 30, $y + 75, -1, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "chkGTFOClanHop")

	$g_hChkGTFOReturnClan = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Misc", "GTFOReturnClan", "Return to clan after finish"), $x + 30, $y + 100, -1, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "chkGTFOReturnClan")

	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "LblClanReturn", "Return to clan") & ": ", $x + 25, $y + 125, -1, -1)
	$g_hTxtClanID = _GUICtrlCreateInput("#XXXXXX", $x + 160 + 75, $y + 123, 56, 21, $ES_NUMBER)
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyClanReturnGTFO")

	$g_hExitAfterCyclesGTFO = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Misc", "LblMaxCyclesGTFO", "Exit after cycles") & ": ", $x + 30, $y + 150, -1, -1)
	GUICtrlSetOnEvent(-1, "ApplyCyclesGTFO")
	$g_hTxtCyclesGTFO = _GUICtrlCreateInput("200", $x + 160 + 75, $y + 147, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyCyclesGTFO")
	$x += 210
	$y += 2
	#CS
	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "Label_01", "Goal of SKD is lightning fast donation"), $x + 2, $y, 250, -1, $SS_CENTER)
	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "Label_02", "SKD is perfect for GTFO and to win a lot of XP!"), $x + 2, $y + 18, 250, -1, $SS_CENTER)
	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "Label_03", "Time usage: 95% on Donations, 5% on Training"), $x + 2, $y + 36, 250, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)

	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "Label_04", "Initial") & ": ", $x + 17, $y + 54, -1, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	$g_hLblInitialDonated = GUICtrlCreateLabel("0", $x + 52, $y + 54, 40, -1, $SS_LEFT)

	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "Label_05", "Current") & ": ", $x + 112, $y + 54, -1, -1)
	$g_hLblCurrentDonated = GUICtrlCreateLabel("0", $x + 157, $y + 54, 40, -1, $SS_LEFT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	#CE
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 25, $y = 300
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - Misc", "Group_02", "Special Kickass New Members"), $x - 20, $y - 20, $g_iSizeWGrpTab2, 150)
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)

	$x -= 17
	$g_hLblKickout = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "LblKickout", "Kickout Spammers / New Members"), $x, $y, 436, 22, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetBkColor($g_hLblKickout, 0x333300)
	GUICtrlSetFont($g_hLblKickout, 12, 500, 0, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, 0xFFCC00)

	$y += 30
	$g_hChkUseKickOut = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Misc", "ChkUseKickOut", "Enable it (at your own risks...)"), $x + 20, $y, -1, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Misc", "ChkUseKickOut_Info_01", "Is necessary to be a Co-Leader or Leader"))
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyKickOut")

	$y += 25
	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "LblDonatedCap", "Donated Cap"), $x + 20, $y, -1, -1)
	$g_hTxtDonatedCap = _GUICtrlCreateInput("8", $x + 120, $y - 2, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Misc", "LblDonatedCap_Info_01", "New member + Donated Troops Limits, when reach will be kick [0-8]"))
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyDonatedCap")

	$y += 25
	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "LblReceivedCap", "Received Cap"), $x + 20, $y, -1, -1)
	$g_hTxtReceivedCap = _GUICtrlCreateInput("35", $x + 120, $y - 2, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Misc", "LblReceivedCap_Info_01", "New member + Received Troops limits, when reach will be kick [0-35]"))
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyReceivedCap")

	$y -= 10
	$g_hChkKickOutSpammers = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Misc", "ChkKickOutSpammers", "KickOut Spammers"), $x + 190, $y, -1, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Misc", "ChkKickOutSpammers_Info_01", "Kick only members with Donations and '0' Requests!"))
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyKickOutSpammers")

	GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - Misc", "LblKickLimit", "Kickout Limits"), $x + 359, $y - 15, -1, -1)
	$g_hTxtKickLimit = _GUICtrlCreateInput("6", $x + 365, $y, 56, 21, BitOR($ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Misc", "LblKickLimit_Info_01", "How many Members will be kick each time.[1-9]") & @CRLF & _
			GetTranslatedFileIni("MOD GUI Design - Misc", "LblKickLimit_Info_02", "From Bottom Rank to Top"))
	GUICtrlSetFont(-1, 9, $FW_BOLD, "Candara", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetOnEvent(-1, "ApplyKickLimits")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>TabGTFOGUI
