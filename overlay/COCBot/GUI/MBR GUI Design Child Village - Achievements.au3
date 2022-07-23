; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Achievements" tab under the "Village" tab
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

Global $g_hChkUnbreakable = 0, $g_hTxtUnbreakable = 0, $g_hTxtUnBrkMinGold = 0, $g_hTxtUnBrkMaxGold = 0, $g_hTxtUnBrkMinElixir = 0, _
	   $g_hTxtUnBrkMaxElixir = 0, $g_hTxtUnBrkMinDark = 0, $g_hTxtUnBrkMaxDark = 0
Global $g_hLblUnbreakableHelp = 0, $g_hLblUnbreakableLink = 0

Func CreateVillageAchievements()
	Local $x = 25
	Local $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "Group_01", "Defense Farming"), $x - 20, $y - 20, $g_iSizeWGrpTab2, 150)
	$y +=10
		$g_hChkUnbreakable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "ChkUnbreakable", "Enable Unbreakable"), $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "ChkUnbreakable_Info_01", "Enable farming Defense Wins for Unbreakable achievement."))
			GUICtrlSetOnEvent(-1, "chkUnbreakable")

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldStar, $x + 10, $y + 51, 32, 32)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldStar, $x + 42, $y + 36, 48, 48)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldStar, $x + 90, $y + 51, 32, 32)

	$x = 150
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "LblUnbreakable", "Wait Time") & ":", $x - 10, $y + 3, 86, -1, $SS_RIGHT)
		$g_hTxtUnbreakable = _GUICtrlCreateInput("5", $x + 80, $y, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnbreakable_Info_01", "Set the amount of time to stop CoC and wait for enemy attacks to gain defense wins. (1-99 minutes)"))
			GUICtrlSetLimit(-1, 2)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Minutes", "Minutes"), $x + 113, $y + 3, -1, -1)

	$y += 28
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "Lbl_FarmMin._Info_01", "Farm Min."), $x + 25, $y, -1, -1)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "Lbl_SaveMin._Info_01", "Save Min."), $x + 115, $y, -1, -1)

	$y += 16
		$g_hTxtUnBrkMinGold = _GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMinGold_Info_01", "Amount of Gold that stops Defense farming, switches to normal farming if below.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMinGold_Info_02", "Set this value to amount of Gold you need for searching or upgrades."))
			GUICtrlSetLimit(-1, 7)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 80, $y + 2, 16, 16)
		$g_hTxtUnBrkMaxGold = _GUICtrlCreateInput("600000", $x + 110, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMaxGold_Info_01", "Amount of Gold in Storage Required to Enable Defense Farming.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMaxGold_Info_02", "Input amount of Gold you need to attract enemy or for upgrades."))
			GUICtrlSetLimit(-1, 7)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 170, $y + 2, 16, 16)

	$y += 26
		$g_hTxtUnBrkMinElixir = _GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMinElixir_Info_01", "Amount of Elixir that stops Defense farming, switches to normal farming if below.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMinElixir_Info_02", "Set this value to amount of Elixir you need for making troops or upgrades."))
			GUICtrlSetLimit(-1, 7)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 80, $y, 16, 16)
		$g_hTxtUnBrkMaxElixir = _GUICtrlCreateInput("600000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMaxElixir_Info_01", "Amount of Elixir in Storage Required to Enable Defense Farming.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMaxElixir_Info_02", "Input amount of Elixir you need to attract enemy or for upgrades."))
			GUICtrlSetLimit(-1, 7)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 170, $y, 16, 16)

	$y += 24
		$g_hTxtUnBrkMinDark = _GUICtrlCreateInput("5000", $x + 20, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMinDark_Info_01", "Amount of Dark Elixir that stops Defense farming, switches to normal farming if below.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMinDark_Info_02", "Set this value to amount of Dark Elixir you need for making troops or upgrades."))
			GUICtrlSetLimit(-1, 6)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 80, $y, 16, 16)
		$g_hTxtUnBrkMaxDark = _GUICtrlCreateInput("6000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMaxDark_Info_01", "Amount of Dark Elixir in Storage Required to Enable Defense Farming.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "TxtUnBrkMaxDark_Info_02", "Input amount of Dark Elixir you need to attract enemy or for upgrades."))
			GUICtrlSetLimit(-1, 6)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 170, $y, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 25
	$y = 200
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "Group_02", "How to use Unbreakable Mode"), $x - 20, $y - 20, $g_iSizeWGrpTab2, 200)
		Local $txtHelp = GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "txtHelp_01", "Unbreakable mode will help you gain defense wins and the ""Unbreakable"" achievement.") & @CRLF & _
						 GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "txtHelp_02", "Set ""Wait Time"" to how long you want the bot to wait for defenses.") & @CRLF & _
						 GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "txtHelp_03", "Farm Min is how many resources the bot must have before attacking.") & @CRLF & _
						 GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "txtHelp_04", "Save Min is how many resources the bot must have before starting unbreakable mode.") & @CRLF & _
						 GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "txtHelp_05", "Click the below link for more information:")
		$g_hLblUnbreakableHelp = GUICtrlCreateLabel($txtHelp, $x - 10, $y, 430, 100)
		$g_hLblUnbreakableLink = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Achievements", "LblUnbreakableLink", "More Info"), $x - 10, $y + 100, 100, 20)
			_GUICtrlSetTip(-1, "https://mybot.run/forums/index.php?/topic/2964-guide-how-to-use-mybot-unbreakable-mode-updated/")
			GUICtrlSetFont(-1, 8.5, $FW_BOLD, $GUI_FONTUNDER)
			GUICtrlSetColor(-1, $COLOR_INFO)
			GUICtrlSetCursor(-1, 0)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateVillageAchievements
