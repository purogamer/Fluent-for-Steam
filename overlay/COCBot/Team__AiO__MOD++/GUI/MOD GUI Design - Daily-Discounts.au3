; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - Daily-Discounts
; Description ...: Design sub gui for daily discounts
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (2019)
; Modified ......: Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DailyDiscounts = 0
Global $g_ahChkDD_Deals[$g_iDDCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hBtnDDApply = 0, $g_hBtnDDClear = 0, $g_hBtnDDClose = 0

Func CreateDailyDiscountGUI()
	$g_hGUI_DailyDiscounts = _GUICreate(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "GUI_DailyDiscounts", "Village Trader Daily Discounts"), 410, 310, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)

	Local $x = 25, $y = 25
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "Group_01", "Daily Discounts Options"), $x - 15, $y - 18, 386, 225)
		$g_ahChkDD_Deals[$g_eDDPotionTrain] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDPotionTrain", "Training Potion") & " (" & String($g_aiDD_DealsCosts[$g_eDDPotionTrain]) & " gems)", $x, $y, -1, -1)
		$g_ahChkDD_Deals[$g_eDDPotionClock] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDPotionClock", "Clock Tower Potion") & " (" & String($g_aiDD_DealsCosts[$g_eDDPotionClock]) & " gems)", $x, $y + 20, -1, -1)
		$g_ahChkDD_Deals[$g_eDDPotionResearch] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDPotionResource", "Research Potion") & " (" & String($g_aiDD_DealsCosts[$g_eDDPotionResearch]) & " gems)", $x, $y + 40, -1, -1)
		$g_ahChkDD_Deals[$g_eDDPotionResource] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDPotionResource", "Resource Potion") & " (" & String($g_aiDD_DealsCosts[$g_eDDPotionResource]) & " gems)", $x, $y + 60, -1, -1)
		$g_ahChkDD_Deals[$g_eDDPotionBuilder] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDPotionBuilder", "Builder Potion") & " (" & String($g_aiDD_DealsCosts[$g_eDDPotionBuilder]) & " gems)", $x, $y + 80, -1, -1)
		$g_ahChkDD_Deals[$g_eDDPotionPower] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDPotionPower", "Power Potion") & " (" & String($g_aiDD_DealsCosts[$g_eDDPotionPower]) & " gems)", $x, $y + 100, -1, -1)
		$g_ahChkDD_Deals[$g_eDDPotionHero] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDPotionHero", "Hero Potion") & " (" & String($g_aiDD_DealsCosts[$g_eDDPotionHero]) & " gems)", $x, $y + 120, -1, -1)
		$g_ahChkDD_Deals[$g_eDDSuperPotion] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDPotionSuper", "Super Potion") & " (" & String($g_aiDD_DealsCosts[$g_eDDPotionHero]) & " gems)", $x, $y + 140, -1, -1)
		$g_ahChkDD_Deals[$g_eDDWallRing5] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDWallRing5", "Wall Ring x5") & " (" & String($g_aiDD_DealsCosts[$g_eDDWallRing5]) & " gems)", $x, $y + 160, -1, -1)
		$g_ahChkDD_Deals[$g_eDDWallRing10] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDWallRing10", "Wall Ring x10") & " (" & String($g_aiDD_DealsCosts[$g_eDDWallRing10]) & " gems)", $x, $y + 180, -1, -1)

	$x += 195
		$g_ahChkDD_Deals[$g_eDDShovel] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDShovel", "Shovel x1") & " (" & String($g_aiDD_DealsCosts[$g_eDDShovel]) & " gems)", $x, $y, -1, -1)
		$g_ahChkDD_Deals[$g_eDDBookHeros] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDBookHeros", "Book of Heros") & " (" & String($g_aiDD_DealsCosts[$g_eDDBookHeros]) & " gems)", $x, $y + 20, -1, -1)
		$g_ahChkDD_Deals[$g_eDDBookFighting] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDBookFighting", "Book of Fighting") & " (" & String($g_aiDD_DealsCosts[$g_eDDBookFighting]) & " gems)", $x, $y + 40, -1, -1)
		$g_ahChkDD_Deals[$g_eDDBookSpells] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDBookSpells", "Book of Spells") & " (" & String($g_aiDD_DealsCosts[$g_eDDBookSpells]) & " gems)", $x, $y + 60, -1, -1)
		$g_ahChkDD_Deals[$g_eDDBookBuilding] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDBookBuilding", "Book of Building") & " (" & String($g_aiDD_DealsCosts[$g_eDDBookBuilding]) & " gems)", $x, $y + 80, -1, -1)
		$g_ahChkDD_Deals[$g_eDDRuneGold] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDRuneGold", "Rune of Gold") & " (" & String($g_aiDD_DealsCosts[$g_eDDRuneGold]) & " gems)", $x, $y + 100, -1, -1)
		$g_ahChkDD_Deals[$g_eDDRuneElixir] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDRuneElixir", "Rune of Elixir") & " (" & String($g_aiDD_DealsCosts[$g_eDDRuneElixir]) & " gems)", $x, $y + 120, -1, -1)
		$g_ahChkDD_Deals[$g_eDDRuneDarkElixir] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDRuneDarkElixir", "Rune of Dark Elixir") & " (" & String($g_aiDD_DealsCosts[$g_eDDRuneDarkElixir]) & " gems)", $x, $y + 140, -1, -1)
		$g_ahChkDD_Deals[$g_eDDRuneBBGold] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDRuneBBGold", "Rune of BB Gold") & " (" & String($g_aiDD_DealsCosts[$g_eDDRuneBBGold]) & " gems)", $x, $y + 160, -1, -1)
		$g_ahChkDD_Deals[$g_eDDRuneBBElixir] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "ChkDDRuneBBElixir", "Rune of BB Elixir") & " (" & String($g_aiDD_DealsCosts[$g_eDDRuneBBElixir]) & " gems)", $x, $y + 180, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 30
	$y += 215
	$g_hBtnDDApply = GUICtrlCreateButton(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "BtnDDApply", "Apply") & " ✔", $x, $y, 85, 25)
		GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "BtnDDApply_Info_01", "Set the gem deals you would like to be purchased on your behalf."))
		GUICtrlSetOnEvent(-1, "btnDDApply")

	$g_hBtnDDClear = GUICtrlCreateButton(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "BtnDDClear", "Clear All"), $x + 200, $y, 85, 25)
		GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "BtnDDClear_Info_01", "Clear selected deals."))
		GUICtrlSetOnEvent(-1, "btnDDClear")

	$g_hBtnDDClose = GUICtrlCreateButton(GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "BtnDDClose", "Close") & " ❌", $x + 295, $y, 55, 25)
		GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design Child Village - Misc", "BtnDDClose_Info_01", "Exit without setting any gem deals to be purchased."))
		GUICtrlSetOnEvent(-1, "btnDDClose")

EndFunc   ;==>CreateDailyDiscountGUI