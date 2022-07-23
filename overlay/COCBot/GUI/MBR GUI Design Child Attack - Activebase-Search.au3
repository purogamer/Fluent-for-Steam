; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Search" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

; Start search if
Global $g_hChkABActivateSearches = 0, $g_hTxtABSearchesMin = 0, $g_hTxtABSearchesMax = 0  ; Search count limit
Global $g_hChkABActivateTropies = 0, $g_hTxtABTropiesMin = 0, $g_hTxtABTropiesMax = 0  ; Trophy limit
Global $g_hChkABActivateCamps = 0, $g_hTxtABArmyCamps = 0 ; Camp limit
Global $g_hChkABKingWait = 0, $g_hChkABQueenWait = 0, $g_hChkABWardenWait = 0, $g_hChkABChampionWait = 0, $g_hChkABNotWaitHeroes = 0
Global $g_hChkABSpellsWait = 0, $g_hChkABWaitForCastle = 0

Global $g_hLblABSearches = 0, $g_hLblABTropies = 0, $g_hLblABArmyCamps = 0
Global $g_hPicABHeroesWait = 0, $g_hTxtABHeroesWait = 0, $g_hPicABKingWait = 0, $g_hPicABKingSleepWait = 0, $g_hPicABQueenWait = 0, $g_hPicABQueenSleepWait = 0, _
	   $g_hPicABWardenWait = 0, $g_hPicABWardenSleepWait = 0, $g_hPicABChampionWait = 0, $g_hPicABChampionSleepWait = 0
Global $g_hPicABLightSpellWait = 0, $g_hPicABHealSpellWait = 0, $g_hPicABRageSpellWait = 0, $g_hPicABJumpSpellWait = 0, $g_hPicABFreezeSpellWait = 0, _
	   $g_hPicABPoisonSpellWait = 0, $g_hPicABEarthquakeSpellWait = 0, $g_hPicABHasteSpellWait = 0

; Filters
Global $g_hCmbABMeetGE = 0, $g_hTxtABMinGold = 0, $g_hTxtABMinElixir = 0, $g_hTxtABMinGoldPlusElixir = 0
Global $g_hChkABMeetDE = 0, $g_hTxtABMinDarkElixir = 0
Global $g_hChkABMeetTrophy = 0, $g_hTxtABMinTrophy = 0, $g_hTxtABMaxTrophy = 0
Global $g_hChkABMeetTH = 0, $g_hCmbABTH = 0, $g_hChkABMeetTHO = 0

Global $g_hGrpABFilter = 0, $g_hPicABMinGold = 0, $g_hPicABMinElixir = 0, $g_hPicABMinGPEGold = 0, $g_hPicABMinDarkElixir = 0, $g_hPicABMinTrophies = 0
Global $g_ahPicABMaxTH[15]

Func CreateAttackSearchActiveBaseSearch()
	Local $sTxtLightningSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortLightningSpells", -1)
	Local $sTxtHealSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHealSpells", -1)
	Local $sTxtRageSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortRageSpells", -1)
	Local $sTxtJumpSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortJumpSpells", -1)
	Local $sTxtFreezeSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortFreezeSpells", -1)
	Local $sTxtInvisibilitySpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortInvisibilitySpells", -1)
	Local $sTxtPoisonSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortPoisonSpells", -1)
	Local $sTxtEarthquakeSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortEarthquakeSpells", -1)
	Local $sTxtHasteSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHasteSpells", -1)
	Local $sTxtSkeletonSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortSkeletonSpells", -1)
	Local $sTxtBatSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortBatSpells", -1)

	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "Group_01", -1), $x - 20, $y - 20, 190, $g_iSizeHGrpTab4)
	$x -= 15
		$g_hChkABActivateSearches = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches", -1), $x, $y, 68, 18)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_02", -1))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkABActivateSearches")
		$g_hTxtABSearchesMin = _GUICtrlCreateInput("1", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "LblActivateMinSearches_Info_01", -1) & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_02", -1))
			GUICtrlSetLimit(-1, 6)
		$g_hLblABSearches = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
		$g_hTxtABSearchesMax = _GUICtrlCreateInput("9999", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)) ;ChrW(8734)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "LblActivateMaxSearches_Info_01", -1) & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTrophy_Info_01", -1))
			GUICtrlSetLimit(-1, 6)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMagnifier, $x + 163, $y + 1, 16, 16)

	$y += 21
		$g_hChkABActivateTropies = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies", -1), $x, $y, 68, 18)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies_Info_02", -1))
			GUICtrlSetOnEvent(-1, "chkABActivateTropies")
		$g_hTxtABTropiesMin = _GUICtrlCreateInput("0", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "LblActivateMinTropies_Info_01", -1) & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies_Info_02", -1))
			GUICtrlSetLimit(-1, 6)
		$g_hLblABTropies = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtABTropiesMax = _GUICtrlCreateInput("6000", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "LblActivateMaxTropies_Info_01", -1) & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies_Info_02", -1))
			GUICtrlSetLimit(-1, 6)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 163, $y + 1, 16, 16)

	$y += 21
		$g_hChkABActivateCamps = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateCamps", -1), $x, $y, 110, 18)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateCamps_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkABActivateCamps")
		$g_hLblABArmyCamps = GUICtrlCreateLabel(ChrW(8805), $x + 113 - 1, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtABArmyCamps = _GUICtrlCreateInput("100", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateLabel("%", $x + 163 + 3, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 23
		$g_hPicABHeroesWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 1, $y + 3, 16, 16)
		$g_hTxtABHeroesWait = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtHeroesWait", -1) & ":", $x + 20, $y + 4, 180, 18)

	$y += 20
	$x += 20
		$g_hChkABKingWait = GUICtrlCreateCheckbox("", $x - 6, $y + 45, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_01", -1) & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_02", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicABKingWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x - 18, $y + 4, 40, 40)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicABKingSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingKing, $x - 18, $y + 4, 40, 40)
			GUICtrlSetState(-1, $GUI_HIDE)

	$x += 45
		$g_hChkABQueenWait = GUICtrlCreateCheckbox("", $x - 6, $y + 45, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_01", -1) & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_02", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicABQueenWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x - 18, $y + 4, 40, 40)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicABQueenSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingQueen, $x - 18, $y + 4, 40, 40)
			GUICtrlSetState(-1, $GUI_HIDE)

	$x += 45
		$g_hChkABWardenWait = GUICtrlCreateCheckbox("", $x - 6, $y + 45, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_01", -1) & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_02", -1)
		$g_hPicABWardenWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x - 18, $y + 4, 40, 40)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicABWardenSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingWarden, $x - 18, $y + 4, 40, 40)
			GUICtrlSetState(-1, $GUI_HIDE)

	$x += 45
		$g_hChkABChampionWait = GUICtrlCreateCheckbox("", $x - 6, $y + 45, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_01", -1) & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_02", -1)
		$g_hPicABChampionWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampion, $x - 18, $y + 4, 40, 40)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicABChampionSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingChampion, $x - 18, $y + 4, 40, 40)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 70
	$x = 10
		$g_hChkABNotWaitHeroes = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkNotWaitHeroes", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkNotWaitHeroes_Info_01", -1))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkNotWaitHeroes")

	$y += 22
	$x = 8
		$g_hPicABLightSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 22, 22)
		$g_hPicABHealSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x + 23, $y, 22, 22)
		$g_hPicABRageSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x + 46, $y, 22, 22)
		$g_hPicABJumpSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x + 69, $y, 22, 22)
		$g_hPicABFreezeSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x + 92, $y, 22, 22)
		$g_hPicABPoisonSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x + 115, $y, 22, 22)
		$g_hPicABEarthquakeSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell, $x + 138, $y, 22, 22)
		$g_hPicABHasteSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x + 161, $y, 22, 22)

	$y += 25
	$x = 10
		$g_hChkABSpellsWait = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkSpellsWait", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkSpellsWait_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkSpellsWait_Info_02", -1))
			GUICtrlSetOnEvent(-1, "chkABSpellsWait")

		$g_hChkABWaitForCastle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkWaitForCastle", -1), $x, $y + 20, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkWaitForCastle_Info_01", -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 220, $y = 45
	$g_hGrpABFilter = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "Group_02", -1), $x - 20, $y - 20, 225, $g_iSizeHGrpTab4)
	$x -= 15
		$g_hCmbABMeetGE = GUICtrlCreateCombo("", $x, $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Item_01", -1) & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Item_02", -1) & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Item_03", -1), GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Item_01", -1))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Info_02", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Info_03", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Info_04", -1))
			GUICtrlSetOnEvent(-1, "cmbABGoldElixir")

			Local $sMinUmbralTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "Txt_MinUmbralTip", "Recover what I spent in the army in minimum percentage, 0 = Disabled.")

		$g_hTxtABMinGold = _GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtMinGold_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7) ;HArchH Increase to 7 digits Gold
		; Gold AB - Team AiO MOD++
;~ 		$g_hMinArmyUmbralGoldAB = _GUICtrlCreateInput("0", $x + 85 + 75, $y, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
;~ 			_GUICtrlSetTip(-1, $sMinUmbralTip)
;~ 			GUICtrlCreateLabel("%", $x + 85 + 85 + 20, $y, 12, 17)

		$g_hPicABMinGold = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		$g_hTxtABMinElixir = _GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtMinElixir_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7) ;HArchH Increase to 7 digits Elixir
		; Elixir AB - Team AiO MOD++
;~ 		$g_hMinArmyUmbralElixirAB = _GUICtrlCreateInput("0", $x + 85 + 75, $y + 1, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
;~ 			_GUICtrlSetTip(-1, $sMinUmbralTip)
;~ 			GUICtrlCreateLabel("%", $x + 85 + 85 + 20, $y + 1, 12, 17)

		$g_hPicABMinElixir = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y -= 11
		$g_hTxtABMinGoldPlusElixir = _GUICtrlCreateInput("160000", $x + 85, $y, 50, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtMinGoldPlusElixir_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7) ;HArchH Increase to 7 digits G+E
			GUICtrlSetState (-1, $GUI_HIDE)
		; Plus AB - Team AiO MOD++
;~ 		$g_hMinArmyUmbralPlusAB = _GUICtrlCreateInput("0", $x + 85 + 75, $y + 35, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
;~ 			_GUICtrlSetTip(-1, $sMinUmbralTip)
;~ 			GUICtrlCreateLabel("%", $x + 85 + 85 + 20, $y + 35, 12, 17)

		$g_hPicABMinGPEGold = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldElixir, $x + 137, $y + 1, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)

	$y += 34
		$g_hChkABMeetDE = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetDE", -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkABMeetDE")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetDE_Info_01", -1))
		$g_hTxtABMinDarkElixir = _GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtMinDarkElixir_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5) ;HArchH 5 digits for DE is plenty...unchanged.
			_GUICtrlEdit_SetReadOnly(-1, True)
		$g_hPicABMinDarkElixir = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_hChkABMeetTrophy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies", -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkABMeetTrophy")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTrophy_Info_01", -1))
		$g_hTxtABMinTrophy = _GUICtrlCreateInput("0", $x + 85, $y, 20, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTrophy_Info_02", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetLimit(-1, 2)
			GUICtrlCreateLabel("-", $x + 109, $y + 2, -1, -1)
		$g_hTxtABMaxTrophy = _GUICtrlCreateInput("0", $x + 115, $y, 20, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTrophy_Info_03", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetLimit(-1, 2)
		$g_hPicABMinTrophies = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_hChkABMeetTH = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkABMeetTH")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTH_Info_01", -1))
		$g_hCmbABTH = GUICtrlCreateCombo("", $x + 85, $y - 1, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbDBTH", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "4-6|7|8|9|10|11|12|13|14", "4-6")
			GUICtrlSetOnEvent(-1, "CmbABTH")
		$g_ahPicABMaxTH[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV06, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_SHOW)
		$g_ahPicABMaxTH[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV07, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV08, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV09, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV10, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV11, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV12, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV13, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[14] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV14, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)

	$y += 24
		$g_hChkABMeetTHO = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTHO", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTHO_Info_01", -1))
	$y += 24

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "Group_03", -1), $x, $y, 215, 120)
	$x += 5
	$y += 20
	Local $xStartColumn = $x, $yStartColumn = $y
		$g_ahChkMaxMortar[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxMortar", -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakMortar[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 52, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxMortar_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9|Lvl 10|Lvl 11|Lvl 12|Lvl 13", "Lvl 5")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakMortar[$LB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMortar, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxWizTower[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxWizTower", -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakWizTower[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 52, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxWizTower_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9|Lvl 10|Lvl 11|Lvl 12|Lvl 13", "Lvl 4")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakWizTower[$LB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizTower, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxAirDefense[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxAirDefense", -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakAirDefense[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 53, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxAirDefense_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9|Lvl 10|Lvl 11|Lvl 12", "Lvl 7")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakAirDefense[$LB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnAirdefense, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxScatter[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxScatter", -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakScatter[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 53, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxScatter_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3", "Lvl 1")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakScatter[$LB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnScattershot, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStartColumn + 104
	$y = $yStartColumn
		$g_ahChkMaxXBow[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxXBow", -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakXBow[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxXBow_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakXBow[$LB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnXBow3, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxInferno[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxInferno", -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakInferno[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxInferno_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakInferno[$LB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnInferno4, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxEagle[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxEagle", -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakEagle[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxEagle_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5", "Lvl 1")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakEagle[$LB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEagleArt, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 44
	$y += 24
	$x = $xStartColumn
		$g_ahChkMeetOne[$LB] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetOne", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetOne_Info_01", -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchActiveBaseSearch
