; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Stats" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), kaganus (2015), Boju (2016), TheRevenor (2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_STATS = 0, $g_hGUI_STATS_TAB = 0, $g_hGUI_STATS_TAB_ITEM1 = 0, $g_hGUI_STATS_TAB_ITEM2 = 0, $g_hGUI_STATS_TAB_ITEM3 = 0, $g_hGUI_STATS_TAB_ITEM4 = 0, $g_hGUI_STATS_TAB_ITEM5 = 0, $g_hGUI_STATS_TAB_ITEM6 = 0 ; xbebenk
Global $btnResetStats = 0

; Gain
Global $g_ahPicTHLevels[15], $g_hLblTHLevels = 0
Global $g_ahPicLeague[$eLeagueCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hLblLeague = 0
Global $g_ahLblStatsStartedWith[$eLootCount] = [0, 0, 0, 0], $g_ahLblStatsGainPerHour[$eLootCount] = [0, 0, 0, 0]
Global $g_ahLblStatsTotalGain[$eLootCount] = [0, 0, 0, 0], $g_ahLblStatsLastAttack[$eLootCount] = [0, 0, 0, 0]
Global $g_ahLblStatsBonusLast[$eLootCount] = [0, 0, 0, 0], $g_ahLblStatsTop[$eLootCount] = [0, 0, 0, 0]
Global $g_hPicResultDEStart = 0, $g_hLblStatsSZRev1 = 0, $g_hLblStatsSZRev2 = 0, $g_hPicHourlyStatsDark = 0, $g_hPicDarkLoot = 0, $g_hPicDarkLastAttack = 0

; Misc
Global $g_hLblResultRuntime = 0, $g_hLblNbrOfOoS = 0, $g_hLblResultVillagesAttacked = 0, $g_hLblResultVillagesSkipped = 0, $g_hLblResultTrophiesDropped = 0
Global $g_hLblSearchCost = 0, $g_hLblTrainCostElixir = 0, $g_hLblTrainCostDElixir = 0, $g_hLblTrainCostGold = 0, $g_hLblGoldFromMines = 0, $g_hLblElixirFromCollectors = 0, $g_hLblDElixirFromDrills = 0
Global $g_hLblWallGoldMake = 0, $g_hLblWallElixirMake = 0, $g_hLblNbrOfBuildingUpgGold = 0, $g_hLblNbrOfBuildingUpgElixir = 0, $g_hLblNbrOfHeroUpg = 0
Global $g_hLblWallUpgCostGold = 0, $g_hLblWallUpgCostElixir = 0, $g_hLblBuildingUpgCostGold = 0, $g_hLblBuildingUpgCostElixir = 0, $g_hLblHeroUpgCost = 0

; Attacks
Global $g_hLblAttacked[$g_iModeCount] = [0, 0, 0], $g_hLblTotalGoldGain[$g_iModeCount] = [0, 0, 0], $g_hLblTotalElixirGain[$g_iModeCount] = [0, 0, 0], _
	   $g_hLblTotalDElixirGain[$g_iModeCount] = [0, 0, 0], $g_hLblTotalTrophyGain[$g_iModeCount] = [0, 0, 0], $g_hLblNbrOfTSSuccess = 0, $g_hLblNbrOfTSFailed = 0
Global $g_hLblNbrOfDetectedMines[$g_iModeCount] = [0, 0, 0], $g_hLblNbrOfDetectedCollectors[$g_iModeCount] = [0, 0, 0], _
	   $g_hLblNbrOfDetectedDrills[$g_iModeCount] = [0, 0, 0], $g_hLblSmartZap = 0, $g_hLblSmartLightningUsed = 0, $g_hLblSmartEarthQuakeUsed = 0

; Donations
Global $g_hLblDonTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblDonSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblDonSiegel[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0]
Global $g_hLblTotalTroopsQ = 0, $g_hLblTotalTroopsXP = 0, $g_hLblTotalSpellsQ = 0, $g_hLblTotalSpellsXP = 0, _ 
	   $g_hLblTotalSiegesQ = 0, $g_hLblTotalSiegesXP = 0, $g_hLblTotalQ = 0, $g_hLblTotalXP = 0 ; Custom Stats - Team AIO Mod++

; Multi Stats
Global $g_ahGrpVillageAcc[$g_eTotalAcc], $g_ahGrpDefaultAcc[$g_eTotalAcc], $g_ahGrpReportAcc[$g_eTotalAcc], $g_ahGrpStatsAcc[$g_eTotalAcc]
Global $g_ahLblResultGoldNowAcc[$g_eTotalAcc], $g_ahPicResultGoldNowAcc[$g_eTotalAcc], $g_ahLblResultTrophyNowAcc[$g_eTotalAcc], $g_ahPicResultTrophyNowAcc[$g_eTotalAcc], _
	$g_ahLblResultElixirNowAcc[$g_eTotalAcc], $g_ahPicResultElixirNowAcc[$g_eTotalAcc], $g_ahLblResultBuilderNowAcc[$g_eTotalAcc], $g_ahPicResultBuilderNowAcc[$g_eTotalAcc], _
	$g_ahLblResultDENowAcc[$g_eTotalAcc], $g_ahPicResultDENowAcc[$g_eTotalAcc], $g_ahLblResultGemNowAcc[$g_eTotalAcc], $g_ahPicResultGemNowAcc[$g_eTotalAcc]
Global $g_ahLblHourlyStatsGoldAcc[$g_eTotalAcc], $g_ahLblResultRuntimeNowAcc[$g_eTotalAcc], $g_ahPicResultRuntimeNowAcc[$g_eTotalAcc], _
	$g_ahLblHourlyStatsElixirAcc[$g_eTotalAcc], $g_ahLblResultAttacked[$g_eTotalAcc], $g_ahPicResultAttacked[$g_eTotalAcc], _
	$g_ahLblHourlyStatsDarkAcc[$g_eTotalAcc], $g_ahLblResultSkipped[$g_eTotalAcc], $g_ahPicResultSkipped[$g_eTotalAcc]
Global $g_ahPicArrowLeft[$g_eTotalAcc], $g_ahPicArrowRight[$g_eTotalAcc], _
	$g_ahPicResultGoldTemp[$g_eTotalAcc], $g_ahPicResultElixirTemp[$g_eTotalAcc], $g_ahPicResultDETemp[$g_eTotalAcc], $g_ahLblVillageReportTemp[$g_eTotalAcc], $g_ahGrpTempAcc[$g_eTotalAcc], _
	$g_ahLblTroopTime[$g_eTotalAcc], $g_ahPicTroopTime[$g_eTotalAcc]
Global $g_hPicHeroGrayStatus[3][$g_eTotalAcc], $g_hPicHeroBlueStatus[3][$g_eTotalAcc], $g_hPicHeroGreenStatus[3][$g_eTotalAcc], $g_hPicHeroRedStatus[3][$g_eTotalAcc], _
	$g_hPicLabGrayStatus[$g_eTotalAcc], $g_hPicLabGreenStatus[$g_eTotalAcc], $g_hPicLabRedStatus[$g_eTotalAcc]

Global $g_ahLblLabTime[$g_eTotalAcc], $g_ahPicLabTime[$g_eTotalAcc] ; xbebenk ? 

Func CreateBotStats()

	;GUISetBkColor($COLOR_WHITE, $g_hGUI_STATS)
	GUISwitch($g_hGUI_STATS)
	$g_hGUI_STATS_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, $WS_CLIPSIBLINGS)
	$btnResetStats = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "BtnResetStats", "Reset Stats"), 375, 0, 60, 20)
		GUICtrlSetOnEvent(-1, "btnResetStats")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hGUI_STATS_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_01", "Gain"))
		CreateGainSubTab()
	$g_hGUI_STATS_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_02", "Misc"))
		CreateMiscSubTab()
	$g_hGUI_STATS_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_03", "Attacks"))
		CreateAttacksSubTab()
	$g_hGUI_STATS_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_04", "Donations"))
		CreateDonationsSubTab()
	$g_hGUI_STATS_TAB_ITEM5 = GUICtrlCreateTabItem("1 - 8")
		CreateMultiStatsSubTab1()
	$g_hGUI_STATS_TAB_ITEM6 = GUICtrlCreateTabItem("9 - 16")
		CreateMultiStatsSubTab2()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateBotStats

#Region Gain SubTab
Func CreateGainSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart, $y = $yStart
	GUICtrlCreatePic(@ScriptDir & "\images\Stats\Stats001.jpg", $x - 18, $y - 20, 426, 80)

	$x = $xStart + 276
	$y = $yStart - 14
	;Boju Display TH Level in Stats
		$g_ahPicTHLevels[4] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV04, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[5] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV05, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV06, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV07, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV08, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV09, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV10, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV11, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV12, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV13, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTHLevels[14] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV14, $x - 11, $y + 15, 52, 52)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", "TownHall"), $x - 11, $y, -1, -1, $SS_CENTER)

		;-->Display TH Level in Stats
		$g_hLblTHLevels = GUICtrlCreateLabel("", $x + 38, $y + 53, 17, 17, $SS_CENTER)
			GUICtrlSetFont($g_hLblTHLevels, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 340
	$y = $yStart - 14
	;Display League in Stats ==>
		$g_ahPicLeague[$eLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x - 2, $y - 5 + 15, 56, 56)
			GUICtrlSetState(-1, $GUI_SHOW)
		$g_ahPicLeague[$eLeagueBronze] = _GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x - 2, $y - 5 + 15, 56, 56)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicLeague[$eLeagueSilver] = _GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x - 2, $y - 5 + 15, 56, 56)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicLeague[$eLeagueGold] = _GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x - 2, $y - 5 + 15, 56, 56)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicLeague[$eLeagueCrystal] = _GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x - 2, $y - 5 + 15, 56, 56)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicLeague[$eLeagueMaster] = _GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x - 2, $y - 5 + 15, 56, 56)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicLeague[$eLeagueChampion] = _GUICtrlCreateIcon($g_sLibIconPath, $eLChampion, $x - 2, $y - 5 + 15, 56, 56)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicLeague[$eLeagueTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x - 2, $y - 5 + 15, 56, 56)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicLeague[$eLeagueLegend] = _GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x - 2, $y - 5 + 15, 56, 56)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLeague", "League"), $x + 3, $y, -1, -1, $SS_CENTER)

		;-->Display League Level in Stats
		$g_hLblLeague = GUICtrlCreateLabel("", $x + 43, $y + 53, 17, 17, $SS_CENTER)
			GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 100
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStats", "Stats"), $x - 20, $y - 32, 87, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGold", "Gold"), $x - 18 + 85, $y - 32, 95, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblElixir", "Elixir"), $x - 18 + (60 * 3), $y - 32, 75, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDarkE", "DarkE"), $x - 23 + (65 * 4), $y - 32, 90, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTrophy", "Trophy"), $x - 23 + (70 * 5), $y - 32, 75, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStartedWith", "Started with") & ":", $x - 15, $y - 11, - 1, - 1)
	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_01", "The amount of Gold you had when the bot started.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsStartedWith[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_02", "The amount of Elixir you had when the bot started.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsStartedWith[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		$g_hPicResultDEStart = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_03", "The amount of Dark Elixir you had when the bot started.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsStartedWith[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_04", "The amount of Trophies you had when the bot started.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsStartedWith[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 125
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGainPerHour", "Gain per Hour") & ":", $x - 15, $y - 11, - 1, - 1)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_01", "Gold gain per hour")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsGainPerHour[$eLootGold] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_02", "Elixir gain per hour")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsGainPerHour[$eLootElixir] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		$g_hPicHourlyStatsDark = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_03", "Dark Elixir gain per hour")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsGainPerHour[$eLootDarkElixir] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_04", "Trophy gain per hour")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsGainPerHour[$eLootTrophy] = GUICtrlCreateLabel("0/h", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 150
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTotalGain", "Total Gain") & ":", $x - 15, $y - 11, - 1, - 1)
	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_01", "The total amount of Gold you gained or lost while the Bot is running.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_02", "(This includes manual spending of resources on upgrade of buildings)")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTotalGain[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_03", "The total amount of Elixir you gained or lost while the Bot is running.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_02", "(This includes manual spending of resources on upgrade of buildings)")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTotalGain[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		$g_hPicDarkLoot = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_04", "The total amount of Dark Elixir you gained or lost while the Bot is running.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_02", "(This includes manual spending of resources on upgrade of buildings)")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTotalGain[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_05", "The amount of Trophies you gained or lost while the Bot is running.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTotalGain[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 195
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLastAttack", "Last Attack") & ":", $x - 15, $y - 11, - 1, - 1)
	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_01", "The amount of Gold you gained on the last attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsLastAttack[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_02", "The amount of Elixir you gained on the last attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsLastAttack[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		$g_hPicDarkLastAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_03", "The amount of Dark Elixir you gained on the last attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsLastAttack[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_04", "The amount of Trophies you gained or lost on the last attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsLastAttack[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 220
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLeagueBonus", "League Bonus") & ":", $x - 15, $y - 11, - 1, - 1)
	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsBonusLast_Info_01", "The amount of Bonus Gold you gained on the last attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsBonusLast[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsBonusLast_Info_02", "The amount of Bonus Elixir you gained on the last attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsBonusLast[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsBonusLast_Info_03", "The amount of Bonus Dark Elixir you gained on the last attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsBonusLast[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 265
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTopLoot", "Top Loot") & ":", $x - 15, $y - 11, - 1, - 1)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_01","Top Gold gained")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTop[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_02", "Top Elixir gained")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTop[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_03", "Top Dark gained")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTop[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_04", "Top Trophy gained")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTop[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateGainSubTab
#EndRegion

#Region Misc SubTab
Func CreateMiscSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart + 3, $y = $yStart + 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblRun", "Run"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblCost-Collect", "Cost && Collect"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblRuntime_Info_01", "The total Running Time of the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblRuntime", "Runtime") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblResultRuntime = GUICtrlCreateLabel("00:00:00", $x + 35, $y + 2, 150, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecycle, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblNbr-of-OoS_Info_01", "The number of Out of Sync error occurred")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblNbr-of-OoS", "Nbr of OoS") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblNbrOfOoS = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblAttacked_Info_01", "The No. of Villages that were attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblAttacked", "Attacked") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblResultVillagesAttacked = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgX, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblSkipped_Info_01", "The No. of Villages that were skipped during search by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblSkipped", "Skipped")& ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblResultVillagesSkipped = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDropped_Info_01", "The amount of Trophies dropped by the Bot due to Trophy Settings (on Misc Tab).")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDropped", "Dropped") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblResultTrophiesDropped = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 25
	$y -= 15
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMagnifier, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblSearch-Cost_Info_01", "Search cost for skipping villages in gold")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblSearch-Cost", "Search Cost") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblSearchCost = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcher, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTrain-Cost-Elixir_Info_01", "Elixir spent for training Barrack Troops")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTrain-Cost-Elixir", "Train Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTrainCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMinion, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTrain-Cost-DElixir_Info_01", "Dark Elixir spent for training Dark Barrack Troops")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTrain-Cost-DElixir", "Train Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTrainCostDElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallW, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTrain-Cost-Gold_Info_01", "Gold spent for Building Siege Machines")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTrain-Cost-Gold", "Build Cost Gold") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTrainCostGold = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGold-collected_Info_01", "Gold gained by collecting mines")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGold-collected", "Gold collected") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblGoldFromMines = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblElixir-collected_Info_01", "Elixir gained by collecting collectors")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblElixir-collected", "Elixir collected") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblElixirFromCollectors = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDElixir-collected_Info_01", "Dark Elixir gained by collecting drills")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDElixir-collected", "DElixir collected") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblDElixirFromDrills = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 5
	$y = $yStart + 185
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpgrades-Made", "Upgrades Made"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpgrade-Costs", "Upgrade Costs"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xD4D4D4)

	$x -= 10
	$y -= 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallGold, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-by-Gold_Info_01", "The No. of Walls upgraded by Gold.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpg-by-Gold", "Upg. by Gold") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblWallGoldMake = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallElixir, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-by-Elixir_Info_01", "The No. of Walls upgraded by Elixir.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpg-by-Elixir", "Upg. by Elixir") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblWallElixirMake = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgGold, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-by-Gold_Info_01", "The number of buildings upgraded using gold")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpg-by-Gold", "Upg. by Gold") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblNbrOfBuildingUpgGold = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgElixir, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-by-Elixir_Info_01", "The number of buildings upgraded using elixir")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpg-by-Elixir", "Upg. by Elixir") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblNbrOfBuildingUpgElixir = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeroes, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblHeroesUpg_Info_01", "The number of heroes upgraded")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblHeroesUpg", "Hero Upgrade") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblNbrOfHeroUpg = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 185
	$y -= 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallGold, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Gold_Info_01", "The cost of gold used by bot while upgrading walls")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Gold", "Upg. Cost Gold") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblWallUpgCostGold = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallElixir, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Elixir_Info_01", "The cost of elixir used by bot while upgrading walls")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Elixir", "Upg. Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblWallUpgCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgGold, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-Cost-by-Gold_Info_01", "The cost of gold used by bot while upgrading buildings")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Gold", "Upg. Cost Gold") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblBuildingUpgCostGold = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgElixir, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-Cost-by-Elixir_Info_01", "The cost of elixir used by bot while upgrading buildings")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Elixir", "Upg. Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblBuildingUpgCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeroes, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblheroesUpg-Cost_Info_01", "The cost of dark elixir used by bot while upgrading heroes")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblheroesUpg-Cost", "Upg. Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblHeroUpgCost = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$x -= 20
	$y -= 85
		GUICtrlCreateLabel("", $x + 28, $y - 160, 5, 300)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateMiscSubTab
#EndRegion

#Region Attacks SubTab
Func CreateAttacksSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart + 3, $y = $yStart + 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base", "Dead Base"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base", "Live Base"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base_Info_01", "The No. of Dead Base that were attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblAttacked[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Gold_Info_01", "The amount of Gold gained from Dead Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain","gain") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalGoldGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Elixir_Info_01", "The amount of Elixir gained from Dead Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Dark_Info_01", "The amount of Dark Elixir gained from Dead Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalDElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 10, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Trophies_Info_01", "The amount of Trophies gained from Dead Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalTrophyGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$x += 30
	$y += 25
		$g_hLblNbrOfDetectedMines[$DB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 20, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedCollectors[$DB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedDrills[$DB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 25
	$y -= 15
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base_Info_01", "The No. of Live Base that were attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblAttacked[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Gold_Info_01", "The amount of Gold gained from Live Bases attacked by the Bot")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalGoldGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Elixir_Info_01", "The amount of Elixir gained from Live Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Dark_Info_01", "The amount of Dark Elixir gained from Live Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalDElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Trophy_Info_01", "The amount of Trophy gained from Live Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalTrophyGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$x += 62
	$y += 25
		$g_hLblNbrOfDetectedMines[$LB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 20, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedCollectors[$LB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedDrills[$LB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 5
	$y = $yStart + 165
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully", "TH Bully"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xD4D4D4)

	$x = $xStart + 180
	$y = $yStart + 165
	$y -= 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully_Info_01", "The No. of TH Bully bases that were attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblAttacked[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully-Gain-Gold_Info_01", "The amount of Gold gained from TH Bully bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalGoldGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully-Gain-Elixir_Info_01", "The amount of Elixir gained from TH Bully bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully-Gain-Dark_Info_01", "The amount of Dark Elixir gained from TH Bully bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalDElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 22, $y, 16, 16)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully-Gain-Trophy_Info_01", "The amount of Trophy gained from TH Bully bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 45, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalTrophyGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, $sTxtTip)
	$x += 64
	$y += 25
		$g_hLblNbrOfDetectedMines[$TB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedCollectors[$TB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedDrills[$TB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	$x -= 124
	$y -= 110
		GUICtrlCreateLabel("", $x + 28, $y - 160, 5, 300)
			GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x = $xStart + 5
	$y = $yStart + 310
		$g_hLblStatsSZRev1 = GUICtrlCreateLabel("", $x - 20, $y - 32, 420, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xD4D4D4)
		$g_hLblStatsSZRev2 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSZRev2", "Smart Zap"), $x + 155, $y - 32, 60, 17, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xD4D4D4)
	$x -= 10
	$y -= 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x - 10, $y, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartLightningUsed_Info_01", "The amount of Lightning Spells used to zap"))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSZRev2-Used", "Used") & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartLightningUsed_Info_01", -1))
		$g_hLblSmartLightningUsed = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartLightningUsed_Info_01", -1))
	$x += 145
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x - 10, $y, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartEarthQuakeUsed_Info_01", "The amount of Earthquake Spells used to zap"))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSZRev2-Used", -1) & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartEarthQuakeUsed_Info_01", -1))
		$g_hLblSmartEarthQuakeUsed = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartEarthQuakeUsed_Info_01", -1))
	$x += 145
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x - 10, $y -1, 18, 18)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartZap_Info_01", "The amount of Dark Elixir won while zapping"))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain",-1) & ":", $x + 13, $y + 2, -1, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartZap_Info_01",  -1))
		$g_hLblSmartZap = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_RIGHT)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_BLACK)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartZap_Info_01",  -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttacksSubTab
#EndRegion

#Region Donations SubTab

Func createdonationssubtab()
	Local $asiegesicons[$esiegemachinecount] = [$eicnwallw, $eicnbattleb, $eicnstones, $eicnsiegeb, $eicnlogl, $eicnflamef]
	Local $xstart = 15, $ystart = 55
	Local $x = $xstart, $y = $ystart
	Local $xMult = 0

	$y = 30
	$x = $xstart + 15
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDon-Troops", "Troops") & " - " & gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDonTroops", "Donated") & ":", $x - 20, $y, 187, 17)
	GUICtrlSetBkColor(-1, 0xD1DFE7)
	GUICtrlCreateLabel("", $x + 35 + 130, $y, 30, 17, $ss_center)
	GUICtrlSetBkColor(-1, 0xD1DFE7)
	$g_hLblTotalTroopsQ = GUICtrlCreateLabel("0", $x + 105, $y, 70, 17, $ss_right)
	GUICtrlSetBkColor(-1, 0xD1DFE7)
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDonTroopsXP", "XP") & ":", $x - 18 + 212, $y, 207, 17)
	GUICtrlSetBkColor(-1, 0xD1DFE7)
	$g_hLblTotalTroopsXP = GUICtrlCreateLabel("0", $x + 320, $y, 70, 17, $ss_right)
	GUICtrlSetBkColor(-1, 0xD1DFE7)

	$y += 25
	For $i = 0 To UBound($g_aQuickTroopIcon) -1
		_guictrlcreateicon($g_slibiconpath, $g_aQuickTroopIcon[$i], $x + ($xMult * 60), $y, 24, 24)
		_guictrlsettip(-1, $g_astroopnames[$i])
		GUICtrlCreateLabel(":", $x + ($xMult * 60) + 26, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $fw_bold, Default, "Arial", $cleartype_quality)
		$g_hlbldontroop[$i] = GUICtrlCreateLabel("0", $x + ($xMult * 60) + 30, $y + 4, 35, 17, $ss_left)
		GUICtrlSetFont(-1, 9, $fw_bold, Default, "Arial", $cleartype_quality)
		GUICtrlSetColor(-1, $color_black)
		_guictrlsettip(-1, $g_astroopnames[$i])
		$xMult += 1
		If Mod($xMult, 7) = 0 Then
			$y += 28
			$xMult = 0
		EndIf
	Next

	$y += 28 + 10
	$xMult = 0

	$x = $xstart + 15
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDon-Spells", "Spells") & " - " & gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDonSpells", "Donated") & ":", $x - 20, $y, 187, 17)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	GUICtrlCreateLabel("", $x + 35 + 130, $y, 30, 17, $ss_center)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	$g_hLblTotalSpellsQ = GUICtrlCreateLabel("0", $x + 105, $y, 70, 17, $ss_right)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDonSpellsXP", "XP") & ":", $x - 18 + 212, $y, 207, 17)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	$g_hLblTotalSpellsXP = GUICtrlCreateLabel("0", $x + 320, $y, 70, 17, $ss_right)
		GUICtrlSetBkColor(-1, 0xD1DFE7)

	$y += 25
	For $i = 0 To UBound($g_aQuickSpellIcon) -1
		_guictrlcreateicon($g_slibiconpath, $g_aQuickSpellIcon[$i], $x + ($xMult * 60), $y, 24, 24)
		_guictrlsettip(-1, $g_asspellnames[$i])
		GUICtrlCreateLabel(":", $x + ($xMult * 60) + 26, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $fw_bold, Default, "Arial", $cleartype_quality)
		$g_hlbldonspell[$i] = GUICtrlCreateLabel("0", $x + ($xMult * 60) + 30, $y + 4, 35, 17, $ss_left)
		GUICtrlSetFont(-1, 9, $fw_bold, Default, "Arial", $cleartype_quality)
		GUICtrlSetColor(-1, $color_black)
		_guictrlsettip(-1, $g_asspellnames[$i])
		$xMult += 1
		If Mod($xMult, 7) = 0 Then
			$y += 28
			$xMult = 0
		EndIf
	Next

	$y += 28 + 10
	$xMult = 0

	$x = $xstart + 15
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDon-Sieges", "Sieges") & " - " & gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDonSieges", "Donated") & ":", $x - 20, $y, 187, 17)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	GUICtrlCreateLabel("", $x + 35 + 130, $y, 30, 17, $ss_center)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	$g_hLblTotalSiegesQ = GUICtrlCreateLabel("0", $x + 105, $y, 70, 17, $ss_right)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDonSiegesXP", "XP") & ":", $x - 18 + 212, $y, 207, 17)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	$g_hLblTotalSiegesXP = GUICtrlCreateLabel("0", $x + 320, $y, 70, 17, $ss_right)
		GUICtrlSetBkColor(-1, 0xD1DFE7)

	$y += 25
	For $i = 0 To UBound($g_assiegemachinenames) -1
		_guictrlcreateicon($g_slibiconpath, $asiegesicons[$i], $x + ($xMult * 60), $y, 24, 24)
		_guictrlsettip(-1, $g_assiegemachinenames[$i])
		GUICtrlCreateLabel(":", $x + ($xMult * 60) + 26, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $fw_bold, Default, "Arial", $cleartype_quality)
		$g_hlbldonsiegel[$i] = GUICtrlCreateLabel("0", $x + ($xMult * 60) + 30, $y + 4, 35, 17, $ss_left)
		GUICtrlSetFont(-1, 9, $fw_bold, Default, "Arial", $cleartype_quality)
		GUICtrlSetColor(-1, $color_black)
		_guictrlsettip(-1, $g_assiegemachinenames[$i])
		$xMult += 1
	Next
	
	$y += 30
	$x = $xstart + 15
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDonTotal", "Total Donated") & ":", $x - 20, $y, 187, 17)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	GUICtrlCreateLabel("", $x + 35 + 130, $y, 30, 17, $ss_center)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	$g_hLblTotalQ = GUICtrlCreateLabel("0", $x + 105, $y, 70, 17, $ss_right)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Bot - Stats", "LblStatsDonTotalXP", "Total XP") & ":", $x - 18 + 212, $y, 207, 17)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
	$g_hLblTotalXP = GUICtrlCreateLabel("0", $x + 320, $y, 70, 17, $ss_right)
		GUICtrlSetBkColor(-1, 0xD1DFE7)
EndFunc
#EndRegion

; xbebenk
#Region MultiStats SubTab
Func CreateMultiStatsSubTab1()
	
	For $i = 0 To Int($g_eTotalAcc / 2) - 1
		Local $x = 25
		Local $y = 27

		Local $i_X = Mod($i, 2), $i_Y = Int($i / 2)
		Local $delY = 17, $delY2 = 95, $delX = 90, $delX2 = 215

		$g_ahGrpVillageAcc[$i] = GUICtrlCreateGroup("", $x - 3 + $i_X * $delX2, $y + $i_Y * $delY2, 180, 90)

			; Village report (resource & info)
			$g_ahLblResultGoldNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahPicResultGoldNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 75 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
			$g_ahLblResultTrophyNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultTrophyNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

			$g_ahLblResultElixirNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahPicResultElixirNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 75 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
			$g_ahLblResultBuilderNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultBuilderNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 14)

			$g_ahLblResultDENowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahPicResultDENowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 75 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
			$g_ahLblResultGemNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultGemNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGem, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

			$g_ahLblLabTime[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahPicLabTime[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x + 75 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 15, 14)

			$g_ahPicArrowLeft[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowLeft, $x - 20 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
				Local $sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage_Info_01", "Switch between village info and stats")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "SwitchVillageInfo")

			$g_ahPicArrowRight[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowRight, $x + 180 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "SwitchVillageInfo")

			; Statistics & Runtime
			$g_ahLblHourlyStatsGoldAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahLblResultRuntimeNowAcc[$i] = GUICtrlCreateLabel("00:00:00", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultRuntimeNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

			$g_ahLblHourlyStatsElixirAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahLblResultAttacked[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultAttacked[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 14)

			$g_ahLblHourlyStatsDarkAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahLblResultSkipped[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultSkipped[$i] = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnBldgX, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

			$g_ahLblTroopTime[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicTroopTime[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrain, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 15, 14)

			$g_ahGrpDefaultAcc[$i] = $g_ahGrpVillageAcc[$i] & "#" & $g_ahPicArrowLeft[$i] & "#" & $g_ahPicArrowRight[$i] & "#" & _
									$g_ahPicResultGoldNowAcc[$i] & "#" & $g_ahPicResultElixirNowAcc[$i] & "#" & $g_ahPicResultDENowAcc[$i] & "#" & _
									$g_ahLblTroopTime[$i] & "#" & $g_ahPicTroopTime[$i] & "#" & $g_ahLblLabTime[$i] & "#" & $g_ahPicLabTime[$i]
			$g_ahGrpReportAcc[$i] = $g_ahLblResultGoldNowAcc[$i] & "#" & $g_ahLblResultTrophyNowAcc[$i] & "#" & $g_ahPicResultTrophyNowAcc[$i] & "#" & _
									$g_ahLblResultElixirNowAcc[$i] & "#" & $g_ahLblResultBuilderNowAcc[$i] & "#" & $g_ahPicResultBuilderNowAcc[$i] & "#" & _
									$g_ahLblResultDENowAcc[$i] & "#" & $g_ahLblResultGemNowAcc[$i] & "#" & $g_ahPicResultGemNowAcc[$i]
			$g_ahGrpStatsAcc[$i] = 	$g_ahLblHourlyStatsGoldAcc[$i] & "#" & $g_ahLblResultRuntimeNowAcc[$i] & "#" & $g_ahPicResultRuntimeNowAcc[$i] & "#" & _
									$g_ahLblHourlyStatsElixirAcc[$i] & "#" & $g_ahLblResultAttacked[$i] & "#" & $g_ahPicResultAttacked[$i] & "#" & _
									$g_ahLblHourlyStatsDarkAcc[$i] & "#" & $g_ahLblResultSkipped[$i] & "#" & $g_ahPicResultSkipped[$i]

		GUICtrlCreateGroup("", -99, -99, 1, 1)

		_GUI_Value_STATE("HIDE", $g_ahGrpDefaultAcc[$i] & "#" & $g_ahGrpReportAcc[$i] & "#" & $g_ahGrpStatsAcc[$i])

	Next
EndFunc   ;==>CreateMultiStatsSubTab1

Func CreateMultiStatsSubTab2()

	For $i = 0 To Int($g_eTotalAcc / 2) - 1
		Local $x = 25
		Local $y = 27
		Local $real_i = $i + 8
		Local $i_X = Mod($i, 2), $i_Y = Int($i / 2)
		Local $delY = 17, $delY2 = 95, $delX = 90, $delX2 = 215

		$g_ahGrpVillageAcc[$real_i] = GUICtrlCreateGroup("", $x - 3 + $i_X * $delX2, $y + $i_Y * $delY2, 180, 90)

			; Village report (resource & info)
			$g_ahLblResultGoldNowAcc[$real_i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahPicResultGoldNowAcc[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 75 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
			$g_ahLblResultTrophyNowAcc[$real_i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultTrophyNowAcc[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

			$g_ahLblResultElixirNowAcc[$real_i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahPicResultElixirNowAcc[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 75 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
			$g_ahLblResultBuilderNowAcc[$real_i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultBuilderNowAcc[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 14)

			$g_ahLblResultDENowAcc[$real_i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahPicResultDENowAcc[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 75 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
			$g_ahLblResultGemNowAcc[$real_i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultGemNowAcc[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGem, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

			$g_ahLblLabTime[$real_i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahPicLabTime[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x + 75 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 15, 14)

			$g_ahPicArrowLeft[$real_i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowLeft, $x - 20 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
				Local $sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage_Info_01", "Switch between village info and stats")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "SwitchVillageInfo")

			$g_ahPicArrowRight[$real_i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowRight, $x + 180 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "SwitchVillageInfo")

			; Statistics & Runtime
			$g_ahLblHourlyStatsGoldAcc[$real_i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahLblResultRuntimeNowAcc[$real_i] = GUICtrlCreateLabel("00:00:00", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultRuntimeNowAcc[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

			$g_ahLblHourlyStatsElixirAcc[$real_i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahLblResultAttacked[$real_i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultAttacked[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 14)

			$g_ahLblHourlyStatsDarkAcc[$real_i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 70, 17, $SS_RIGHT)
			$g_ahLblResultSkipped[$real_i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicResultSkipped[$real_i] = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnBldgX, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

			$g_ahLblTroopTime[$real_i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 55, 17, $SS_RIGHT)
			$g_ahPicTroopTime[$real_i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrain, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 15, 14)

			$g_ahGrpDefaultAcc[$real_i] = $g_ahGrpVillageAcc[$real_i] & "#" & $g_ahPicArrowLeft[$real_i] & "#" & $g_ahPicArrowRight[$real_i] & "#" & _
									$g_ahPicResultGoldNowAcc[$real_i] & "#" & $g_ahPicResultElixirNowAcc[$real_i] & "#" & $g_ahPicResultDENowAcc[$real_i] & "#" & _
									$g_ahLblTroopTime[$real_i] & "#" & $g_ahPicTroopTime[$real_i] & "#" & $g_ahLblLabTime[$real_i] & "#" & $g_ahPicLabTime[$real_i]
			$g_ahGrpReportAcc[$real_i] = $g_ahLblResultGoldNowAcc[$real_i] & "#" & $g_ahLblResultTrophyNowAcc[$real_i] & "#" & $g_ahPicResultTrophyNowAcc[$real_i] & "#" & _
									$g_ahLblResultElixirNowAcc[$real_i] & "#" & $g_ahLblResultBuilderNowAcc[$real_i] & "#" & $g_ahPicResultBuilderNowAcc[$real_i] & "#" & _
									$g_ahLblResultDENowAcc[$real_i] & "#" & $g_ahLblResultGemNowAcc[$real_i] & "#" & $g_ahPicResultGemNowAcc[$real_i]
			$g_ahGrpStatsAcc[$real_i] = 	$g_ahLblHourlyStatsGoldAcc[$real_i] & "#" & $g_ahLblResultRuntimeNowAcc[$real_i] & "#" & $g_ahPicResultRuntimeNowAcc[$real_i] & "#" & _
									$g_ahLblHourlyStatsElixirAcc[$real_i] & "#" & $g_ahLblResultAttacked[$real_i] & "#" & $g_ahPicResultAttacked[$real_i] & "#" & _
									$g_ahLblHourlyStatsDarkAcc[$real_i] & "#" & $g_ahLblResultSkipped[$real_i] & "#" & $g_ahPicResultSkipped[$real_i]

		GUICtrlCreateGroup("", -99, -99, 1, 1)

		_GUI_Value_STATE("HIDE", $g_ahGrpDefaultAcc[$real_i] & "#" & $g_ahGrpReportAcc[$real_i] & "#" & $g_ahGrpStatsAcc[$real_i])

	Next
EndFunc   ;==>CreateMultiStatsSubTab2
#EndRegion
