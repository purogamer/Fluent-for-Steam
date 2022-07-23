; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - SuperXP
; Description ...: Design sub gui for SuperXP
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: NguyenAnhHD & Eloy
; Modified ......: Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkEnableSuperXP = 0, $g_hChkFastSuperXP = 0, $g_hChkSkipDragToEndSX = 0, _
	   $g_hRdoTrainingSX = 0, $g_hRdoAttackingSX = 0, $g_hRdoGoblinPicnic = 0, $g_hRdoTheArena = 0, _
	   $g_hTxtMaxXPToGain = 0, $g_hLblLockedSX = 0, $g_hChkSkipZoomOutSX = 0
Global $g_hChkBKingSX = 0, $g_hChkAQueenSX = 0, $g_hChkGWardenSX = 0
Global $g_hLblStartXP = 0, $g_hLblCurrentXP = 0, $g_hLblWonXP = 0, $g_hLblWonHourXP = 0, $g_hLblRunTimeXP = 0, _
	   $g_hLblGoblinPicnic1 = 0, $g_hLblGoblinPicnic2 = 0, $g_hLblTheArena1 = 0, $g_hLblTheArena2 = 0

Func TabSuperXPGUI()

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Group_01", "Settings"), $x - 20, $y - 20, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2)
	$x -= 5
	$y -= 5
		$g_hLblLockedSX = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_01", "LOCKED"), $x + 270, $y + 82, 173, 50)
			GUICtrlSetFont(-1, 25, 800, 0, "Arial")
			GUICtrlSetColor(-1, 0xFF0000)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hChkEnableSuperXP = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkEnableSuperXP", "Enable SuperXP"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkEnableSuperXP_Info_01", "SuperXP Attacks Continuously the 'Goblin Picnic/The Arena' To Earn XP."))
			GUICtrlSetOnEvent(-1, "chkEnableSuperXP")
		$g_hChkSkipZoomOutSX = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkSkipZoomOutSX", "Skip ZoomOut"), $x + 120, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkSkipZoomOutSX_Info_01", "Skip ZoomOut after Attack Finsihed."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkFastSuperXP = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkFastSuperXP", "Fast SuperXP"), $x + 215, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkFastSuperXP_Info_01", "Skip Current Xp Check from main screen and make SuperXP Fast."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkSkipDragToEndSX = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkSkipDragToEndSX", "Skip Drag To End"), $x + 310, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkSkipDragToEndSX_Info_01", "Skip End Drag To Start Finding 'Goblin Picnic/The Arena' From Current Mission.") & @CRLF & _
					GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkSkipDragToEndSX_Info_02", "Note: Uncheck When You Have Unlocked All 'Goblin Picnic/The Arena'. It will be fast.") & @CRLF & _
					GetTranslatedFileIni("MOD GUI Design - SuperXP", "ChkSkipDragToEndSX_Info_03", "Note: Check When You Have New Missions Locked. It will be fast."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 25
		GUICtrlCreateGroup("", $x - 11, $y - 7, $g_iSizeWGrpTab2 - 8, 70)
		GUICtrlCreateGraphic($x - 9, $y + 18, $g_iSizeWGrpTab2 - 12, 1, $SS_GRAYRECT)
		GUICtrlCreateGraphic($x + 202, $y + 2, 5, 57, $SS_GRAYRECT)

		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_02", "Farm XP Options"), $x - 10, $y + 4, 210, -1, $SS_CENTER)
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_03", "Goblin Map Options"), $x + 210, $y + 4, 210, -1, $SS_CENTER)
	$y += 20
		GUIStartGroup()
		$g_hRdoTrainingSX = GUICtrlCreateRadio(GetTranslatedFileIni("MOD GUI Design - SuperXP", "RdoTrainingSX", "Farm XP during troops Training"), $x, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_CHECKED)
		$g_hRdoAttackingSX = GUICtrlCreateRadio(GetTranslatedFileIni("MOD GUI Design - SuperXP", "RdoAttackingSX", "Farm XP instead of Attacking"), $x, $y + 20, -1, -1)

		GUIStartGroup()
		$g_hRdoGoblinPicnic = GUICtrlCreateRadio(GetTranslatedFileIni("MOD GUI Design - SuperXP", "RdoGoblinPicnic", "Goblin Picnic"), $x + 220, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "radLblGoblinMapOpt")
		$g_hRdoTheArena = GUICtrlCreateRadio(GetTranslatedFileIni("MOD GUI Design - SuperXP", "RdoTheArena", "The Arena"), $x + 220, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "radLblGoblinMapOpt")

	$y += 42
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "MaxXPToGain", "Max XP to Gain") & ":", $x, $y + 8, -1, -1)
		$g_hTxtMaxXPToGain = _GUICtrlCreateInput("500", $x + 85, $y + 4, 70, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 8)

	$x += 85
	$y += 28
		_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModBKingSX, $x, $y, 64, 64)
		_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModAQueenSX, $x + 85, $y, 64, 64)
		_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModGWardenSX, $x + 170, $y, 64, 64)
	$y += 68
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_04", "Pick Hero/es:"), $x - 85, $y, -1, -1)
		$g_hChkBKingSX = GUICtrlCreateCheckbox("", $x + 25, $y, 13, 13)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkAQueenSX = GUICtrlCreateCheckbox("", $x + 110, $y, 13, 13)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkGWardenSX = GUICtrlCreateCheckbox("", $x + 195, $y, 13, 13)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x -= 85
	$y += 28
		$g_hLblGoblinPicnic1 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_05", "Super XP attacks continuously the TH of 'Goblin Picnic' to farm XP."), $x, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hLblGoblinPicnic2 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_06", "At each attack, you win 5 XP"), $x, $y + 18, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hLblTheArena1 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_07", "Super XP attacks continuously the TH of 'The Arena' to farm XP."), $x, $y, -1, -1)
		$g_hLblTheArena2 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_08", "At each attack, you win 11 XP"), $x, $y + 18, -1, -1)

	$y += 38
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_09", "XP at Start"), $x - 13, $y, 87, 19)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_09_Info_01", "XP at The Beginning."))
			GUICtrlSetFont(-1, 10, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0x282800)
			GUICtrlSetBkColor (-1, 0xFFCC00)
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_10", "Current XP"), $x + 74, $y, 87, 19)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_10_Info_01", "Your Current XP Amount"))
			GUICtrlSetFont(-1, 10, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0x282800)
			GUICtrlSetBkColor (-1, 0xFFCC00)
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_11", "XP Won"), $x + 161, $y, 87, 19)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_11_Info_01", "Earns 5/11 XP At Each Attack"))
			GUICtrlSetFont(-1, 10, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0x282800)
			GUICtrlSetBkColor (-1, 0xFFCC00)
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_12", "XP/Hour"), $x + 248, $y, 87, 19)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_12_Info_01", "Average Earning XP."))
			GUICtrlSetFont(-1, 10, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0x282800)
			GUICtrlSetBkColor (-1, 0xFFCC00)
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_13", "Runtime"), $x + 335, $y, 90, 19)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_13_Info_01", "The length of Time You're Earning XP until Now."))
			GUICtrlSetFont(-1, 10, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0x282800)
			GUICtrlSetBkColor (-1, 0xFFCC00)

	$y += 22
		$g_hLblStartXP = GUICtrlCreateLabel("0", $x - 13, $y, 87, 30)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_09_Info_01", -1))
			GUICtrlSetFont(-1, 18, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0xFFCC00)
			GUICtrlSetBkColor (-1, 0x333300)
		$g_hLblCurrentXP = GUICtrlCreateLabel("0", $x + 74, $y, 87, 30)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_10_Info_01", -1))
			GUICtrlSetFont(-1, 18, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0xFFCC00)
			GUICtrlSetBkColor (-1, 0x333300)
		$g_hLblWonXP = GUICtrlCreateLabel("0", $x + 161, $y, 87, 30)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_11_Info_01", -1))
			GUICtrlSetFont(-1, 18, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0xFFCC00)
			GUICtrlSetBkColor (-1, 0x333300)
		$g_hLblWonHourXP = GUICtrlCreateLabel("0", $x + 248, $y, 87, 30)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_12_Info_01", -1))
			GUICtrlSetFont(-1, 18, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0xFFCC00)
			GUICtrlSetBkColor (-1, 0x333300)
		$g_hLblRunTimeXP = GUICtrlCreateLabel("00:00:00", $x + 335, $y, 90, 30)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - SuperXP", "Label_13_Info_01", -1))
			GUICtrlSetFont(-1, 18, 800, 0, "Candara")
			GUICtrlSetColor(-1, 0xFFCC00)
			GUICtrlSetBkColor (-1, 0x333300)

	$y += 36
		_GUICtrlCreatePic($g_sIcnSuperXP, $x - 7, $y, 426, 80)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>TabSuperXPGUI
