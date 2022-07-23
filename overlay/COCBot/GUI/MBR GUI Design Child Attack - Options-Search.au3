; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Search" tab under the "Options" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

#Region - Custom Search Reduction - Team AIO Mod++
Global $g_hChkSearchReduction = 0, $g_hTxtSearchReduceCount = 0, $g_hTxtSearchReduceByMin = 0, $g_hChkSearchReduceCount = 0, $g_hChkSearchReduceByMin = 0, $g_hTxtSearchReduceGold = 0, $g_hTxtSearchReduceElixir = 0, $g_hTxtSearchReduceGoldPlusElixir = 0, $g_hTxtSearchReduceDark = 0, $g_hTxtSearchReduceTrophy = 0, $g_hTxtSearchReduceShieldTrophy = 0
Global $g_hSldVSDelay = 0, $g_hSldMaxVSDelay = 0
Global $g_hChkAttackNow = 0, $g_hCmbAttackNowDelay = 0, $g_hChkRestartSearchLimit = 0, $g_hTxtRestartSearchlimit = 0, $g_hChkAlertSearch = 0
Global $g_hLblVSDelay = 0, $g_hLblTextVSDelay = 0, $g_hLblMaxVSDelay = 0, $g_hLblTextMaxVSDelay = 0, $g_hLblAttackNow = 0, $g_hLblAttackNowSec = 0
Global $g_hChkRestartSearchPickupHero = 0
Global $g_hChkSearchTimeout = 0, $g_hLblSearchTimeout = 0, $g_hTxtSearchTimeout = 0, $g_hLblSearchTimeoutminutes = 0

Func CreateAttackSearchOptionsSearch()
	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "Group_01", "Search Reduction"), $x - 20, $y - 20, 223, 212)
	$x -= 15
	$g_hChkSearchReduction = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkSearchReduction", "Enable Search Reduction"), $x, $y - 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkSearchReduction_Info_01", "Check this if you want the search values to automatically be lowered after a certain amount of searches."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkSearchReduction")
	$y += 15
	$x += 3
	$g_hChkSearchReduceCount = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceCount", "Reduce targets every"), $x, $y, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceCount_Info_01", "Enter the No. of searches to wait before each reduction occurs.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "chkSearchReduceCount")
	$g_hTxtSearchReduceCount = _GUICtrlCreateInput("20", $x + 122, $y + 2, 38, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "search(es).", "search(es)."), $x + 162, $y + 3, -1, -1)
	$y += 21
	$g_hChkSearchReduceByMin = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceByMin", "Reduce targets every"), $x, $y, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceByMin_Info_01", "Enter the No. of XX minutes to wait before each reduction occurs.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceByMin_Info_02", "Note: If Search got restart due to any obstacle e.g Connection lost. Bot will take new time when again search started")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkSearchReduceByMin")
	$g_hTxtSearchReduceByMin = _GUICtrlCreateInput("40", $x + 122, $y + 2, 38, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "min(s).", "min(s)."), $x + 162, $y + 3, -1, -1)
	$y += 21
	$x += 2
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceGold", "- Reduce Gold"), $x, $y + 3, -1, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceGold_Info_01", "Lower value for Gold by this amount on each step.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hTxtSearchReduceGold = _GUICtrlCreateInput("2000", $x + 120, $y, 38, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 5)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 165, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 21
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceElixir", "- Reduce Elixir"), $x, $y + 3, -1, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceElixir_Info_01", "Lower value for Elixir by this amount on each step.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hTxtSearchReduceElixir = _GUICtrlCreateInput("2000", $x + 120, $y, 38, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 5)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 165, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 21
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceGoldPlusElixir", "- Reduce Gold + Elixir"), $x, $y + 3, -1, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceGoldPlusElixir_Info_01", "Lower total sum for G+E by this amount on each step.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hTxtSearchReduceGoldPlusElixir = _GUICtrlCreateInput("4000", $x + 120, $y, 38, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 5)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 165, $y + 1, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel("+", $x + 181, $y + 1, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 187, $y + 1, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 21
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceDark", "- Reduce Dark Elixir"), $x, $y + 3, -1, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceDark_Info_01", "Lower value for Dark Elixir by this amount on each step.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hTxtSearchReduceDark = _GUICtrlCreateInput("100", $x + 120, $y, 38, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 3)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 165, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 21
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceTrophy", "- Reduce Trophies"), $x, $y + 3, -1, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceTrophy_Info_01", "Lower value for Trophies by this amount on each step.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hTxtSearchReduceTrophy = _GUICtrlCreateInput("2", $x + 120, $y, 38, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 165, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#cs
	$y += 21
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceShieldTrophy", "- Reduce Shield Trophies"), $x, $y + 3, -1, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceShieldTrophy_Info_01", "Lower value for Shield Trophies by this amount on each step.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hTxtSearchReduceShieldTrophy = _GUICtrlCreateInput("2", $x + 120, $y, 38, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 165, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#ce
	$x = 25
	$y = 259
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "Group_02", "Village Search Delay"), $x - 20, $y - 20, 223, 72)
	$x += 20
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblMinVSDelay_Info_01", "Use this slider to change the time to wait between Next clicks when searching for a Village to Attack.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblMinVSDelay_Info_02", "This might compensate for Out of Sync errors on some PC's.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblMinVSDelay_Info_03", "NO GUARANTEES! This will not always have the same results!")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Mini", "Min"), $x - 25, $y - 2, 25, 15, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblVSDelay = GUICtrlCreateLabel("0", $x + 2, $y - 2, 12, 15, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTextVSDelay = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "seconds", "seconds"), $x + 18, $y - 2, 50, -1)
	$g_hSldVSDelay = GUICtrlCreateSlider($x + 70, $y - 4, 105, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	_GUICtrlSetTip(-1, $sTxtTip)
	_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	GUICtrlSetLimit(-1, 12, 0)
	GUICtrlSetData(-1, 1)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetOnEvent(-1, "sldVSDelay")
	$y += 25
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Maxi", "Max"), $x - 25, $y - 2, 25, 15, $SS_RIGHT)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblMaxVSDelay_Info_01", "Enable random village search delay value by setting") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblMaxVSDelay_Info_02", "bottom Max slide value higher than the top minimum slide")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblMaxVSDelay = GUICtrlCreateLabel("0", $x + 2, $y - 2, 12, 15, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTextMaxVSDelay = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "seconds", -1), $x + 18, $y - 2, 50, -1)
	$g_hSldMaxVSDelay = GUICtrlCreateSlider($x + 70, $y - 4, 105, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	_GUICtrlSetTip(-1, $sTxtTip)
	_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	GUICtrlSetLimit(-1, 15, 0)
	GUICtrlSetData(-1, 4)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetOnEvent(-1, "sldMaxVSDelay")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$x = 253
	$y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "Group_03", "Search Options"), $x - 20, $y - 20, 189, 212)
	$x -= 10
	$g_hChkAttackNow = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAttackNow", "Attack Now! option."), $x - 5, $y - 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAttackNow_Info_01", "Check this if you want the option to have an 'Attack Now!' button next to") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAttackNow_Info_02", "the Start and Pause buttons to bypass the dead base or all base search values.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAttackNow_Info_03", "The Attack Now! button will only appear when searching for villages to Attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkAttackNow")
	$g_hLblAttackNow = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblAttackNow", "Add") & ":", $x + 10, $y + 20, 27, -1, $SS_RIGHT)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblAttackNow_Info_01", "Add this amount of reaction time to slow down the search.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hCmbAttackNowDelay = GUICtrlCreateCombo("", $x + 45, $y + 17, 35, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetData(-1, "0|1|2|3|4|5", "3")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hLblAttackNowSec = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 85, $y + 20, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 49
	$g_hChkRestartSearchLimit = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkRestartSearchLimit", "Restart every") & ":", $x - 5, $y - 8, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkRestartSearchLimit_Info_01", "Return To Base after x searches and restart to search enemy villages.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "chkRestartSearchLimit")
	$g_hTxtRestartSearchlimit = _GUICtrlCreateInput("50", $x + 15, $y + 15, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "search(es).", -1), $x + 47, $y + 17, -1, -1)
	$y += 45
	$g_hChkRestartSearchPickupHero = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkRestartSearchPickupHero", "Restart to pickup healed hero"), $x - 5, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkRestartSearchPickupHero_Info_01", "Return to base when a hero is healed and ready to join the attack"))
	GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 25
	$g_hChkAlertSearch = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAlertSearch", "Alert me when Village found"), $x - 5, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAlertSearch_Info_01", "Check this if you want an Audio alarm & a Balloon Tip when a Base to attack is found."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	#EndRegion - Custom Search Reduction - Team AIO Mod++

	#Region - Return Home by Time - Team AIO Mod++
	$y += 32
	$g_hChkResetByCloudTimeEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblChkSearchTimeout", "Restart search IF Cloud Time"), $x - 5, $y - 8, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ResetByCloudTimeEnable_Info_01", "Reset game if is bugged in clouds in minutes"))
	GUICtrlSetOnEvent(-1, "chkReturnTimer")
	GUICtrlCreateLabel(ChrW(62), $x + 5, $y + 17, -1, -1)
	$g_hTxtReturnTimer = _GUICtrlCreateInput("5", $x + 15, $y + 15, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "Label_15", "min.", -1), $x + 47, $y + 17, -1, -1)
	#EndRegion - Return Home by Time - Team AIO Mod++
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchOptionsSearch
