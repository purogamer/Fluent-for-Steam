; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Tab SmartZap
; Description ...: This file creates the "SmartZap" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(February, 2016), Team AIO Mod++ (2021)
; Modified ......: TheRevenor (November, 2016), TheRevenor (Desember, 2017), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#Region - Custom SmartZap - Team AIO Mod++
Global $g_hChkSmartLightSpell = 0, $g_hChkSmartEQSpell = 0, $g_hChkNoobZap = 0, $g_hChkSmartZapDB = 0, $g_hChkSmartZapSaveHeroes = 0, _
		$g_hTxtSmartZapMinDE = 0, $g_hTxtSmartExpectedDE = 0, $g_hChkDebugSmartZap = 0, $g_hChkSmartZapFTW = 0
		
Global $g_hLblSmartUseLSpell = 0, $g_hLblSmartUseEQSpell = 0, $g_hLblSmartZap = 0, $g_hLblNoobZap = 0, $g_hLblSmartLightningUsed = 0, $g_hLblSmartEarthQuakeUsed = 0, _
		$g_hRemainTimeToZap = 0, $g_hLblRemainTimeToZap = 0
		
Global $g_hChkSmartZapDestroyCollectors = 0, $g_hChkSmartZapDestroyMines = 0, $g_hInpSmartZapTimes = 0

Func CreateAttackNewSmartZap()

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "Group_01", "SmartZap/NoobZap"), $x - 20, $y - 20, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblUse_This_Spell_to_Zap", "Use This Spell to Zap Dark Drills"), $x + 20, $y, -1, -1)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnNewSmartZap, $x - 10, $y, 25, 25)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 45, $y + 20, 25, 25)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x + 125, $y + 20, 25, 25)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x - 10, $y + 90, 25, 25)

	$y += 50
		$g_hLblSmartUseLSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblSmartUseLSpell", "Use LSpells"), $x + 27, $y + 15, -1, -1)
			GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hChkSmartLightSpell = GUICtrlCreateCheckbox("", $x + 51, $y - 3, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblSmartUseLSpell_Info_01", "Check this to drop Lightning Spells on top of Dark Elixir Drills.") & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblSmartUseLSpell_Info_02", "Remember to go to the tab 'troops' and put the maximum capacity") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblSmartUseLSpell_Info_03", "of your spell factory and the number of spells so that the bot can function perfectly."))
			GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hLblSmartUseEQSpell = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblSmartUseEQSpell", "Use EQSpell"), $x + 105, $y + 15, -1, -1)
			GUICtrlSetOnEvent(-1, "chkEarthQuakeZap")
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hChkSmartEQSpell = GUICtrlCreateCheckbox("", $x + 131, $y - 3, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblSmartUseEQSpell_Info_01", "Check this to drop EarthQuake Castle Spell on any Dark Elixir Drill"))
			GUICtrlSetOnEvent(-1, "chkEarthQuakeZap")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkNoobZap = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkNoobZap", "Use NoobZap"), $x + 20 + 2, $y + 35, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkNoobZap_Info_01", "Check this to drop lightning spells on any Dark Elixir Drills"))
			GUICtrlSetOnEvent(-1, "chkNoobZap")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkSmartZapDB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapDB", "Only Zap Drills in Dead Bases"), $x + 20 + 2, $y + 55, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapDB_Info_01", "This will only SmartZap a Dead Base (Recommended)"))
			GUICtrlSetOnEvent(-1, "chkSmartZapDB")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkSmartZapSaveHeroes = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapSaveHeroes", "TH Snipe Not Zap if Heroes Deployed"), $x + 20 + 2, $y + 75, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapSaveHeroes_Info_01", "This will stop SmartZap from zapping a base on a Town Hall Snipe if your Heroes were deployed"))
			GUICtrlSetOnEvent(-1, "chkSmartZapSaveHeroes")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hChkSmartZapFTW = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapFTW", "Strike For The Win"), $x + 20 + 2, $y + 95, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapFTW_Info_01", "SmartZap/NoobZap will try to reach 50% Destruction to get the win.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapFTW_Info_02", "It will not zap, if one Star is already reached, or if there is no chance to win."))
			GUICtrlSetOnEvent(-1, "chkSmartZapFTW")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hLblRemainTimeToZap = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblRemainTimeToZap", "Remain Time to Zap"), $x + 20, $y + 120, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "RemainTimeToZap_Info_01", "[0] Disabled, [1-99] Will Proceed with Smart Zap before battle ends."))
			$g_hRemainTimeToZap = _GUICtrlCreateInput("90", $x + 120, $y + 116, 40, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "RemainTimeToZap_Info_01", "[0] Disabled, [1-99] Will Proceed with Smart Zap before battle ends."))
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetOnEvent(-1, "ZapRemainTime")
			GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hChkSmartZapDestroyCollectors = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapDestroyCollectors", "Destroy Collectors"), $x + 20 + 2, $y + 140, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapDestroyCollectors_Info_01", "Will try to destroy filled Collectors after Drills."))
			GUICtrlSetOnEvent(-1, "ChkSmartZapDestroyCollectors")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hChkSmartZapDestroyMines = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapDestroyMines", "Destroy Mines"), $x + 20 + 2, $y + 160, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "ChkSmartZapDestroyMines_Info_01", "Will try to destroy Mines after Drills."))
			GUICtrlSetOnEvent(-1, "ChkSmartZapDestroyMines")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblSmartZapTimes", "Zap times per collector"), $x + 20, $y + 120 + 65, -1, -1)
	$g_hInpSmartZapTimes = _GUICtrlCreateInput("1", $x + 160, $y + 116 + 65, 40, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "SmartZapTimes_Info_01", "How many times to zap per collector."))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetOnEvent(-1, "InpSmartZapTimes")
			
	$y -= 55
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 200 + 9, $y + 11, 24, 24)
			GUICtrlCreateGroup("", $x + 199, $y - 1, 192, 106)
	$g_hLblSmartZap = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblSmartZap", "Min. amount of Dark Elixir") & ":", $x + 160 + 79, $y + 12, -1, -1)
	$g_hTxtSmartZapMinDE = _GUICtrlCreateInput("350", $x + 289, $y + 32, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblSmartZap_Info_01", "Set the Value of the minimum amount of Dark Elixir in the Drills"))
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "txtMinDark")
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 200 + 9, $y + 57, 24, 24)
	$g_hLblNoobZap = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblNoobZap", "Expected gain of Dark Drills") & ":", $x + 160 + 79, $y + 58, -1, -1)
	$g_hTxtSmartExpectedDE = _GUICtrlCreateInput("320", $x + 289, $y + 78, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblNoobZap_Info_01", "Set value for expected gain every dark drill") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Options-SmartZap", "LblNoobZap_Info_02", "NoobZap will be stopped if the last zap gained less DE than expected"))
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "txtExpectedDE")
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackNewSmartZap
#EndRegion - Custom SmartZap - Team AIO Mod++