;FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Search" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; Start search if
Global $g_hChkDBActivateSearches = 0, $g_hTxtDBSearchesMin = 0, $g_hTxtDBSearchesMax = 0  ; Search count limit
Global $g_hChkDBActivateTropies = 0, $g_hTxtDBTropiesMin = 0, $g_hTxtDBTropiesMax = 0  ; Trophy limit
Global $g_hChkDBActivateCamps = 0, $g_hTxtDBArmyCamps = 0 ; Camp limit
Global $g_hChkDBKingWait = 0, $g_hChkDBQueenWait = 0, $g_hChkDBWardenWait = 0, $g_hChkDBChampionWait = 0, $g_hChkNotWaitHeros = 0, $g_hChkDBNotWaitHeroes = 0
Global $g_hChkDBSpellsWait = 0, $g_hChkDBWaitForCastle = 0

Global $g_hLblDBSearches = 0, $g_hLblDBTropies = 0, $g_hLblDBArmyCamps = 0
Global $g_hPicDBHeroesWait = 0, $g_hTxtDBHeroesWait = 0, $g_hPicDBKingWait = 0, $g_hPicDBKingSleepWait = 0, $g_hPicDBQueenWait = 0, $g_hPicDBQueenSleepWait = 0, _
	   $g_hPicDBWardenWait = 0, $g_hPicDBWardenSleepWait = 0, $g_hPicDBChampionWait = 0, $g_hPicDBChampionSleepWait = 0
Global $g_hPicDBLightSpellWait = 0, $g_hPicDBHealSpellWait = 0, $g_hPicDBRageSpellWait = 0, $g_hPicDBJumpSpellWait = 0, $g_hPicDBFreezeSpellWait = 0, _
	   $g_hPicDBPoisonSpellWait = 0, $g_hPicDBEarthquakeSpellWait = 0, $g_hPicDBHasteSpellWait = 0

; Filters
Global $g_hCmbDBMeetGE = 0, $g_hTxtDBMinGold = 0, $g_hTxtDBMinElixir = 0, $g_hTxtDBMinGoldPlusElixir = 0
Global $g_hChkDBMeetDE = 0, $g_hTxtDBMinDarkElixir = 0
Global $g_hChkDBMeetTrophy = 0, $g_hTxtDBMinTrophy = 0, $g_hTxtDBMaxTrophy = 0
Global $g_hChkDBMeetTH = 0, $g_hCmbDBTH = 0, $g_hChkDBMeetTHO = 0, $g_hChkDBMeetDeadEagle = 0, $g_hTxtDeadEagleSearch = 0

Global $g_hGrpDBFilter = 0, $g_hPicDBMinGold = 0, $g_hPicDBMinElixir = 0, $g_hPicDBMinGPEGold = 0, $g_hPicDBMinDarkElixir = 0, $g_hPicDBMinTrophies = 0
Global $g_ahPicDBMaxTH[15]

; Check No League for Dead Base - Team AiO MOD++
Global $g_hChkDBNoLeague = 0

Func CreateAttackSearchDeadBaseSearch()

	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "Group_01", "Start Search IF"), $x - 20, $y - 20, 190, $g_iSizeHGrpTab4)
	$x -= 15
		$g_hChkDBActivateSearches = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches", "Search"), $x, $y, 68, 18)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_01", "Note - enables SEARCH range for this attack type ONLY.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_02", "Setting will not set search limit to restart search process!"))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBActivateSearches")
		$g_hTxtDBSearchesMin = _GUICtrlCreateInput("1", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "LblActivateMinSearches_Info_01", "Set the Min. number of searches to activate this attack option") & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_02", -1))
			GUICtrlSetLimit(-1, 6)
		$g_hLblDBSearches = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
		$g_hTxtDBSearchesMax = _GUICtrlCreateInput("9999", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)) ;ChrW(8734)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "LblActivateMaxSearches_Info_01", "Set the Max number of searches to activate this attack option") & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateSearches_Info_02", -1))
			GUICtrlSetLimit(-1, 6)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMagnifier, $x + 163, $y + 1, 16, 16)

	$y += 21
		$g_hChkDBActivateTropies = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies", "Trophies"), $x, $y, 68, 18)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies_Info_01", "Set the trophy range where this attack will be used") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies_Info_02", "Note: - This option will NOT adjust trophies to stay in range entered!"))
			GUICtrlSetOnEvent(-1, "chkDBActivateTropies")
		$g_hTxtDBTropiesMin = _GUICtrlCreateInput("0", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "LblActivateMinTropies_Info_01", "Set the Min. number of trophies where this attack will be used") & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies_Info_02", -1))
			GUICtrlSetLimit(-1, 6)
		$g_hLblDBTropies = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtDBTropiesMax = _GUICtrlCreateInput("6000", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "LblActivateMaxTropies_Info_01", "Set the Max number of trophies where this attack will be used") & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies_Info_02", -1))
			GUICtrlSetLimit(-1, 6)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 163, $y + 1, 16, 16)

	$y += 21
		$g_hChkDBActivateCamps = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateCamps", "Army Camps"), $x, $y, 110, 18)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateCamps_Info_01", "Set the % Army camps required to enable this attack option while searching")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkDBActivateCamps")
		$g_hLblDBArmyCamps = GUICtrlCreateLabel(ChrW(8805), $x + 113 - 1, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtDBArmyCamps = _GUICtrlCreateInput("80", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateLabel("%", $x + 163 + 3, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 23
		$g_hPicDBHeroesWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 1, $y + 3, 16, 16)
		$g_hTxtDBHeroesWait = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtHeroesWait", "Wait for Heroes to be Ready") & ":", $x + 20, $y + 4, 180, 18)

	$y += 20
	$x += 20
		$g_hChkDBKingWait = GUICtrlCreateCheckbox("", $x - 6, $y + 45, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_01", "Wait for King to be ready before attacking...") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_02", "Enabled with TownHall 7 and higher")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicDBKingWait=_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x - 18, $y + 4, 40, 40)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicDBKingSleepWait=_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingKing, $x - 18, $y + 4, 40, 40)
			GUICtrlSetState(-1, $GUI_HIDE)

	$x += 45
		$g_hChkDBQueenWait = GUICtrlCreateCheckbox("", $x - 6, $y + 45, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_01", "Wait for Queen to be ready before attacking...") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_02", "Enabled with TownHall 9 and higher")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicDBQueenWait=_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x - 18, $y + 4, 40, 40)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicDBQueenSleepWait=_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingQueen, $x - 18, $y + 4, 40, 40)
			GUICtrlSetState(-1, $GUI_HIDE)

	$x += 45
		$g_hChkDBWardenWait = GUICtrlCreateCheckbox("", $x - 6, $y + 45, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_01", "Wait for Warden to be ready before attacking...") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_02", "Enabled with TownHall 11")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicDBWardenWait=_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x - 18, $y + 4, 40, 40)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicDBWardenSleepWait=_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingWarden, $x - 18, $y + 4, 40, 40)
			GUICtrlSetState(-1, $GUI_HIDE)

	$x += 45
		$g_hChkDBChampionWait = GUICtrlCreateCheckbox("", $x - 6, $y + 45, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_01", "Wait for Champion to be ready before attacking...") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_02", "Enabled with TownHall 13")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicDBChampionWait=_GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampion, $x - 18, $y + 4, 40, 40)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicDBChampionSleepWait=_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingChampion, $x - 18, $y + 4, 40, 40)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 70
	$x = 10
		$g_hChkDBNotWaitHeroes = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkNotWaitHeroes", "Not wait for Heroes when upgrade"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkNotWaitHeroes_Info_01", "Continue to attack, when Upgrade heroes and enable Wait for heroes."))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkNotWaitHeroes")

	$y += 22
	$x = 8
		$g_hPicDBLightSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 22, 22)
		$g_hPicDBHealSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x + 23, $y, 22, 22)
		$g_hPicDBRageSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x + 46, $y, 22, 22)
		$g_hPicDBJumpSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x + 69, $y, 22, 22)
		$g_hPicDBFreezeSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x + 92, $y, 22, 22)
		$g_hPicDBPoisonSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x + 115, $y, 22, 22)
		$g_hPicDBEarthquakeSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell, $x + 138, $y, 22, 22)
		$g_hPicDBHasteSpellWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x + 161, $y, 22, 22)

	$y += 25
	$x = 10
		$g_hChkDBSpellsWait = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkSpellsWait", "Wait for Spells to be Ready"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkSpellsWait_Info_01", "Stop searching for this attack type when Spells are not ready") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkSpellsWait_Info_02", "Warning: Do not enable unless you have spell factory or bot will not attack!"))
			GUICtrlSetOnEvent(-1, "chkDBSpellsWait")

		$g_hChkDBWaitForCastle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkWaitForCastle", "Wait for Clan Castle"), $x, $y + 20, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkWaitForCastle_Info_01", "Wait until your Clan Castle is filled, as requested."))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 220
	$y = 45
	$g_hGrpDBFilter = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "Group_02", "Filters"), $x - 20, $y - 20, 225, $g_iSizeHGrpTab4)
	$x -= 15
		$g_hCmbDBMeetGE = GUICtrlCreateCombo("", $x, $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Item_01", "G And E") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Item_02", "G Or E") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Item_03", "G + E"), GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Item_01", -1))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Info_01", "Search for a base that meets the values set for Gold And/Or/Plus Elixir.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Info_02", "AND: Both conditions must meet, Gold and Elixir.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Info_03", "OR: One condition must meet, Gold or Elixir.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMeetGE_Info_04", "+ (PLUS): Total amount of Gold + Elixir must meet."))
			GUICtrlSetOnEvent(-1, "cmbDBGoldElixir")

;~ Local $sMinUmbralTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "Txt_MinUmbralTip", "Recover what I spent in the army in minimum percentage, 0 = Disabled.")

		$g_hTxtDBMinGold = _GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtMinGold_Info_01", "Set the Min. amount of Gold to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7) ;HArchH Increase to 7 digits for Gold

		$g_hPicDBMinGold = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 140, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		$g_hTxtDBMinElixir = _GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtMinElixir_Info_01", "Set the Min. amount of Elixir to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7) ;HArchH Increase to 7 digits for Elixir

		$g_hPicDBMinElixir = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 140, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y -= 11
		$g_hTxtDBMinGoldPlusElixir = _GUICtrlCreateInput("160000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtMinGoldPlusElixir_Info_01", "Set the Min. amount of Gold + Elixir to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7) ;HArchH Increase to 7 digits for G+E
			GUICtrlSetState (-1, $GUI_HIDE)

		$g_hPicDBMinGPEGold = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldElixir, $x + 140, $y + 1, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)

	$y += 34
		$g_hChkDBMeetDE = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetDE", "Dark Elixir"), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkDBMeetDE")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetDE_Info_01", "Search for a base that meets the value set for Min. Dark Elixir."))
		$g_hTxtDBMinDarkElixir = _GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtMinDarkElixir_Info_01", "Set the Min. amount of Dark Elixir to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, True)

		$g_hPicDBMinDarkElixir = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 140, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		$g_hChkDBMeetTrophy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkActivateTropies", -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkDBMeetTrophy")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTrophy_Info_01", "Search for a base that meets the value set for Min. Trophies."))
		$g_hTxtDBMinTrophy = _GUICtrlCreateInput("0", $x + 85, $y, 20, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTrophy_Info_02", "Set the Min. amount of Trophies to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetLimit(-1, 2)
			GUICtrlCreateLabel("-", $x + 109, $y + 2, -1, -1)
		$g_hTxtDBMaxTrophy = _GUICtrlCreateInput("0", $x + 115, $y, 20, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTrophy_Info_03", "Set the Max. amount of Trophies to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetLimit(-1, 2)
		$g_hPicDBMinTrophies = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 140, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		$g_hChkDBMeetTH = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkDBMeetTH")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTH_Info_01", "Search for a base that meets the value set for Max. Townhall Level."))
		$g_hCmbDBTH = GUICtrlCreateCombo("", $x + 85, $y - 1, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbDBTH", "Set the Max. level of the Townhall to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "4-6|7|8|9|10|11|12|13|14", "4-6")
			GUICtrlSetOnEvent(-1, "CmbDBTH")
		$g_ahPicDBMaxTH[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV06, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_SHOW)
		$g_ahPicDBMaxTH[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV07, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicDBMaxTH[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV08, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicDBMaxTH[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV09, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicDBMaxTH[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV10, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicDBMaxTH[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV11, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicDBMaxTH[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV12, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicDBMaxTH[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV13, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicDBMaxTH[14] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV14, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)

	$y += 21
			; create checkbox with handle $g_hChkDBMeetDeadEagle
		$g_hChkDBMeetDeadEagle = GUICtrlCreateCheckbox("Dead Eagle Search", $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkDBMeetDeadEagle")
	
	$y += 21
		$g_hTxtDeadEagleSearch = _GUICtrlCreateInput("50", $x + 115, $y - 18, 20, 18)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTrophy_Info_03", "Set the Max. amount of Trophies to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetLimit(-1, 2)	

		$g_hChkDBMeetTHO = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTHO", "Townhall Outside"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetTHO_Info_01", "Search for a base that has an exposed Townhall. (Outside of Walls)"))
	$y += 21
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "Group_03", "Weak base | max defenses"), $x, $y, 215, 120)
	$x += 5
	$y += 20
	Local $xStartColumn = $x, $yStartColumn = $y
		$g_ahChkMaxMortar[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxMortar", "Search for a base that has Mortar below this level."))
			GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		$g_ahCmbWeakMortar[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 52, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxMortar_Info_01", "Set the Max. level of the Mortar to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9|Lvl 10|Lvl 11|Lvl 12|Lvl 13", "Lvl 5")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakMortar[$DB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMortar, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxWizTower[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxWizTower", "Search for a base that has Wizard Tower below this level"))
			GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		$g_ahCmbWeakWizTower[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 52, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxWizTower_Info_01", "Set the Max. level of the Wizard Tower to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9|Lvl 10|Lvl 11|Lvl 12|Lvl 13", "Lvl 4")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakWizTower[$DB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizTower, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxAirDefense[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxAirDefense", "Search for a base that has Air Defense below this level"))
			GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		$g_ahCmbWeakAirDefense[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 53, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxAirDefense_Info_01", "Set the Max. level of the Air Defense to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9|Lvl 10|Lvl 11|Lvl 12", "Lvl 7")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakAirDefense[$DB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnAirdefense, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxScatter[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxScatter", "Search for a base that has Scattershot below this level"))
			GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		$g_ahCmbWeakScatter[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 53, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxScatter_Info_01", "Set the Max. level of the Scattershot to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3", "Lvl 1")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakScatter[$LB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnScattershot, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStartColumn + 104
	$y = $yStartColumn
		$g_ahChkMaxXBow[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxXBow", "Search for a base that has X-Bow below this level"))
			GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		$g_ahCmbWeakXBow[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxXBow_Info_01", "Set the Max. level of the X-Bow to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakXBow[$DB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnXBow3, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxInferno[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxInferno", "Search for a base that has Inferno below this level"))
			GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		$g_ahCmbWeakInferno[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxInferno_Info_01", "Set the Max. level of the Inferno Tower to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakInferno[$DB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnInferno4, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxEagle[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMaxEagle", "Search for a base that has Eagle Artillery below this level"))
			GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		$g_ahCmbWeakEagle[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "CmbMaxEagle_Info_01", "Set the Max. level of the Eagle Artillery to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5", "Lvl 1")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakEagle[$DB] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEagleArt, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 55
	$x = $xStartColumn
		$g_ahChkMeetOne[$LB] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetOne", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "ChkMeetOne_Info_01", -1))
	#Region - Check Collector Outside & Check No League for Dead Base - Team AiO MOD++
	$y += 25
		$g_hChkDBNoLeague = GUICtrlCreateCheckbox("No League", $x, $y, -1, -1)
			_GUICtrlSetTip(-1, "Search for a Dead bases that has no league.")
			GUICtrlSetOnEvent(-1, "chkDBNoLeague")
	#EndRegion - Check Collector Outside & Check No League for Dead Base - Team AiO MOD++
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchDeadBaseSearch
