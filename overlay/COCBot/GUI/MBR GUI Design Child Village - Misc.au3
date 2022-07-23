; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Misc" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017), Chilly-Chill (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Global $g_hGUI_MISC = 0, $g_hGUI_MISC_TAB = 0, $g_hGUI_MISC_TAB_ITEM1 = 0, $g_hGUI_MISC_TAB_ITEM2 = 0, $g_hGUI_MISC_TAB_ITEM3 = 0, $g_hGUI_MISC_TAB_ITEM4 = 0

#include "..\Team__AiO__MOD++\GUI\MOD GUI Design - Daily-Discounts.au3"

Global $g_hChkBotStop = 0, $g_hCmbBotCommand = 0, $g_hCmbBotCond = 0, $g_hCmbHoursStop = 0, $g_hCmbTimeStop = 0
Global $g_LblResumeAttack = 0, $g_ahTxtResumeAttackLoot[$eLootCount] = [0, 0, 0, 0], $g_hCmbResumeTime = 0
Global $g_hChkCollectStarBonus = 0, $g_hChkAvoidInCG = 0 ; Custom CG - Team AIO Mod++
Global $g_hTxtRestartGold = 0, $g_hTxtRestartElixir = 0, $g_hTxtRestartDark = 0
Global $g_hChkTrap = 1, $g_hChkCollect = 1, $g_hChkTombstones = 1, $g_hChkCleanYard = 0, $g_hChkGemsBox = 0
; Global $g_hChkCollectCartFirst = 0, $g_hTxtCollectGold = 0, $g_hTxtCollectElixir = 0, $g_hTxtCollectDark = 0  ; Custom Collect - Team AIO Mod++
Global $g_hChkCollectLootCar = 0, $g_hTxtCollectGold = 0, $g_hTxtCollectElixir = 0, $g_hTxtCollectDark = 0  ; Custom Collect - Team AIO Mod++

Global $g_hBtnLocateSpellfactory = 0, $g_hBtnLocateDarkSpellFactory = 0
; #Region - Custom Locate - Team AIO Mod++
Global $g_hlblLocateTH = 0, $g_hlblLocateCastle = 0, $g_hlblLocateKingAltar = 0, $g_hlblLocateQueenAltar = 0, $g_hlblLocateWardenAltar = 0, $g_hlblLocateChampionAltar = 0, $g_hlblLocateLaboratory = 0, $g_hlblLocatePetHouse = 0
Global $g_hBtnLocateTH = 0, $g_hBtnLocateCastle = 0
Global $g_hBtnLocateKingAltar = 0, $g_hBtnLocateQueenAltar = 0, $g_hBtnLocateWardenAltar = 0, $g_hBtnLocateChampionAltar = 0, $g_hBtnLocateLaboratory = 0, $g_hBtnLocatePetHouse = 0, $g_hBtnResetBuilding = 0
; #EndRegion - Custom Locate - Team AIO Mod++

Global $g_hInputDarkElixirItems = 0, $g_hInputElixirItems = 0, $g_hInputGoldItems = 0 ; Team AIO Mod++

Global $g_hChkTreasuryCollect = 0, $g_hTxtTreasuryGold = 0, $g_hTxtTreasuryElixir = 0, $g_hTxtTreasuryDark = 0, $g_hChkCollectAchievements = 0, $g_hChkFreeMagicItems = 0, $g_hChkCollectRewards = 0, $g_hChkSellRewards = 0

Global $g_hChkCollectMagicItems = 0, $g_hChkFreeMagicItems = 0, $g_hBtnMagicItemsConfig = 0, $g_hChkResourcePotion = 0


; xbebenk clanGames
Global $g_hChkClanGamesEnabled = 0, $g_hChkClanGames60 = 0
Global $g_hChkClanGamesLoot = 0, $g_hChkClanGamesBattle = 0, $g_hChkClanGamesMiscellaneous = 0
Global $g_hcmbPurgeLimit = 0, $g_hChkClanGamesStopBeforeReachAndPurge = 0
Global $g_hTxtClanGamesLog = 0
Global $g_hChkClanGamesDebug = 0
Global $g_hLblRemainTime = 0, $g_hLblYourScore = 0

;ClanGames Challenges
Global $g_hChkClanGamesDes = 0, $g_hBtnCGDes = 0, $g_hGUI_CGDes = 0, $g_hBtnCGDesSet = 0, $g_hBtnCGDesRemove = 0, $g_hBtnCGDesClose = 0, $g_sTxtCGDes
Global $g_hChkClanGamesAirTroop = 0, $g_hBtnCGAirTroop = 0, $g_hGUI_CGAirTroops = 0, $g_hBtnCGAirTroopsSet = 0, $g_hBtnCGAirTroopsRemove = 0, $g_hBtnCGAirTroopsClose = 0, $g_sTxtCGAirTroop
Global $g_hChkClanGamesGroundTroop = 0, $g_hBtnCGGroundTroop = 0, $g_hGUI_CGGroundTroops = 0, $g_hBtnCGGroundTroopSet = 0, $g_hBtnCGGroundTroopRemove = 0, $g_hBtnCGGroundTroopClose = 0, $g_sTxtCGGroundTroop
Global $g_hChkClanGamesSpell = 0, $g_hBtnCGSpell = 0, $g_hGUI_CGSpells = 0, $g_hBtnCGSpellsSet = 0, $g_hBtnCGSpellsRemove = 0, $g_hBtnCGSpellsClose = 0, $g_sTxtCGSpell
Global $g_hChkClanGamesBBBattle = 0
Global $g_hChkClanGamesBBDes = 0, $g_hBtnCGBBDes = 0, $g_hGUI_CGBBDes = 0, $g_hBtnCGBBDesSet = 0, $g_hBtnCGBBDesRemove = 0, $g_hBtnCGBBDesClose = 0, $g_sTxtCGBBDes
Global $g_hChkClanGamesBBTroops = 0, $g_hBtnCGBBTroop = 0, $g_hGUI_CGBBTroops = 0, $g_hBtnCGBBTroopsSet = 0, $g_hBtnCGBBTroopsRemove = 0, $g_hBtnCGBBTroopsClose = 0, $g_sTxtCGBBTroop
Global $g_hChkForceBBAttackOnClanGames = 0, $g_hChkClanGamesPurgeAny = 0, $g_hChkOnlyBuilderBaseGC = 0

;ClanCapitalTAB
Global $g_lblCapitalGold = 0, $g_lblCapitalMedal = 0, $g_hCmbForgeBuilder = 0, $g_hChkEnableAutoUpgradeCC = 0, $g_hChkAutoUpgradeCCIgnore = 0
Global $g_hChkEnableCollectCCGold = 0, $g_hChkEnableForgeGold = 0, $g_hChkEnableForgeElix = 0, $g_hChkEnableForgeDE = 0, $g_hChkEnableForgeBBGold = 0, $g_hChkEnableForgeBBElix = 0

Func CreateVillageMisc()
	$g_hGUI_MISC = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, ($WS_CHILD + $WS_TABSTOP), -1, $g_hGUI_VILLAGE)

	CreateDailyDiscountGUI() ; Daily Discounts - Team AiO MOD++
	;CreateBBDropOrderGUI() ; Builder Base Attack - Team AiO MOD++
	; #EndRegion - Team AiO MOD++

	; xbebenk clan games
	CreateCGDes()
	CreateClanGamesAirTroops()
	CreateClanGamesGroundTroops()
	CreateClanGamesBBDes()
	CreateClanGamesBBTroops()
	CreateClanGamesSpell()
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUISwitch($g_hGUI_MISC)
	$g_hGUI_MISC_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, ($TCS_MULTILINE + $TCS_RIGHTJUSTIFY))
	; #Cs
	$g_hGUI_MISC_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM1", "Normal Village"))
	CreateMiscNormalVillageSubTab()
	; #Region - Team AiO MOD++
	$g_hGUI_MISC_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM3", "Clan Games"))
	CreateMiscClanGamesV3SubTab()
	$g_hGUI_MISC_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM4", "Clan Capital")) 
	CreateClanCapitalTab()
	$g_hGUI_MISC_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM_MISC_", "Misc"))
	TabMiscGUI()

	; #ce
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageMisc

Func CreateMiscNormalVillageSubTab()
	Local $sTxtTip = ""
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_01", "Halt Attack"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 132) ; Ex 145 ; Team__AiO__MOD
	$g_hChkBotStop = GUICtrlCreateCheckbox("", $x, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BotStop_Info_01", "Use these options to set when the bot will stop attacking.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkBotStop")

	$g_hCmbBotCommand = GUICtrlCreateCombo("", $x + 20, $y - 3, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_01", "Halt Attack") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_02", "Stop Bot") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_03", "Close Bot") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_04", "Close CoC+Bot") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_05", "Shutdown PC") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_06", "Sleep PC") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_07", "Reboot PC") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_08", "Turn Idle") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_09", "Play BB Only"))
	_GUICtrlComboBox_SetCurSel($g_hCmbBotCommand, 0)
	GUICtrlSetOnEvent(-1, "cmbBotCond")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBotCommand", "When..."), $x + 125, $y, 45, 17)

	$g_hCmbBotCond = GUICtrlCreateCombo("", $x + 173, $y - 3, 160, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_01", "G and E Full and Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_02", "(G and E) Full or Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_03", "(G or E) Full and Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_04", "G or E Full or Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_05", "Gold and Elixir Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_06", "Gold or Elixir Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_07", "Gold Full and Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_08", "Elixir Full and Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_09", "Gold Full or Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_10", "Elixir Full or Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_11", "Gold Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_12", "Elixir Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_13", "Reach Max. Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_14", "Dark Elixir Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_15", "All Storage (G+E+DE) Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_16", "Bot running for...") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_17", "Now (Train/Donate Only)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_18", "Now (Donate Only)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_19", "Now (Only stay online)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_20", "W/Shield (Train/Donate Only)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_21", "W/Shield (Donate Only)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_22", "W/Shield (Only stay online)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_23", "At certain time in the day"))
	_GUICtrlComboBox_SetCurSel($g_hCmbBotCond, 0)
	GUICtrlSetOnEvent(-1, "cmbBotCond")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hCmbHoursStop = GUICtrlCreateCombo("", $x + 337, $y - 3, 80, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	Local $sTxtHours = GetTranslatedFileIni("MBR Global GUI Design", "Hours", "Hours")
	GUICtrlSetData(-1, "-|1 " & GetTranslatedFileIni("MBR Global GUI Design", "Hour", "Hour") & "|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & _
			$sTxtHours & "|7 " & $sTxtHours & "|8 " & $sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & _
			$sTxtHours & "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & _
			$sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours, "-")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hCmbTimeStop = GUICtrlCreateCombo("", $x + 337, $y - 3, 80, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0:00 AM|1:00 AM|2:00 AM|3:00 AM|4:00 AM|5:00 AM|6:00 AM|7:00 AM|8:00 AM|9:00 AM|10:00 AM|11:00 AM" & _
			"|12:00 PM|1:00 PM|2:00 PM|3:00 PM|4:00 PM|5:00 PM|6:00 PM|7:00 PM|8:00 PM|9:00 PM|10:00 PM|11:00 PM", "0:00 AM")
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 25
	$g_LblResumeAttack = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblResumeAttack", "Resume Attack") & ":", $x + 20, $y + 2, 80, -1)

	$x += 94
	$g_hCmbResumeTime = GUICtrlCreateCombo("", $x + 15, $y - 1, 80, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_01", "After Halt-attack due to time schedule, the Bot will resume attack when the clock turns this time in a day"))
	GUICtrlSetData(-1, "0:00 AM|1:00 AM|2:00 AM|3:00 AM|4:00 AM|5:00 AM|6:00 AM|7:00 AM|8:00 AM|9:00 AM|10:00 AM|11:00 AM" & _
			"|12:00 PM|1:00 PM|2:00 PM|3:00 PM|4:00 PM|5:00 PM|6:00 PM|7:00 PM|8:00 PM|9:00 PM|10:00 PM|11:00 PM", "12:00 PM")
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_ahTxtResumeAttackLoot[$eLootTrophy] = _GUICtrlCreateInput("", $x + 15, $y, 40, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", "After Halt-attack due to full resource, the Bot will resume attack when one of the resources drops below this minimum"))
	GUICtrlSetLimit(-1, 4)
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 56, $y, 16, 16) ;HArchH Was 65, now 56.

	$g_hChkCollectStarBonus = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectStarBonus", "When star bonus available"), $x - 45, $y + 20, -1, -1)  ; Custom CG - Team AIO Mod++
	
	$g_hChkAvoidInCG = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAvoidInCG", "Avoid in clan games"), $x + 175, $y + 20, -1, -1) ; Custom CG - Team AIO Mod++

	$x += 75
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 70, $y, 16, 16)
	$g_ahTxtResumeAttackLoot[$eLootGold] = _GUICtrlCreateInput("", $x + 15, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", -1))
	GUICtrlSetLimit(-1, 8)

	$x += 80
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 70, $y, 16, 16)
	$g_ahTxtResumeAttackLoot[$eLootElixir] = _GUICtrlCreateInput("", $x + 15, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", -1))
	GUICtrlSetLimit(-1, 8)

	$x += 80
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 65, $y, 16, 16)
	$g_ahTxtResumeAttackLoot[$eLootDarkElixir] = _GUICtrlCreateInput("", $x + 15, $y, 45, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", -1))
	GUICtrlSetLimit(-1, 6)

	$x = 15
	$y += 45
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBotWillHaltAutomatically", "The bot will Halt automatically when you run out of Resources. It will resume when reaching these minimal values:"), $x + 20, $y - 8, 400, 25, $BS_MULTILINE)     ; Team__AiO__MOD

	$y += 20 ; Ex 30 ; Team__AiO__MOD
	$x += 90
	GUICtrlCreateLabel(ChrW(8805), $x + 89, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 149, $y, 16, 16)
	$g_hTxtRestartGold = _GUICtrlCreateInput("10000", $x + 99, $y, 50, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartGold_Info_01", "Minimum Gold value for the bot to resume attacking after halting because of low gold."))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel(ChrW(8805), $x + 89, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 149, $y, 16, 16)
	$g_hTxtRestartElixir = _GUICtrlCreateInput("25000", $x + 99, $y, 50, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartElixir_Info_01", "Minimum Elixir value for the bot to resume attacking after halting because of low elixir."))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel(ChrW(8805), $x + 89, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 149, $y, 16, 16)
	$g_hTxtRestartDark = _GUICtrlCreateInput("500", $x + 99, $y, 50, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartDark_Info_01", "Minimum Dark Elixir value for the bot to resume attacking after halting because of low dark elixir."))
	GUICtrlSetLimit(-1, 6)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; #Region - Custom - Team__AiO__MOD
	Local $x = 15, $y = 192 - 16 ; Team__AiO__MOD
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_02", "Collect, Clear"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 170 + 25) ; Team__AiO__MOD

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x, $y, 24, 24)
	; _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 24, 24)
	; _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 45, $y, 24, 24)
	; _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLootCart, $x + 70, $y, 24, 24)
	$g_hChkCollect = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect", "Collect Resources"), $x + 25, $y - 6, -1, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkCollect")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_01", "Check this to automatically collect the Villages Resources") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_02", "from Gold Mines, Elixir Collectors and Dark Elixir Drills.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_03", "This will also search for a Loot Cart in your village and collect it."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	; #Region - Custom Collect - Team AIO Mod++
	$g_hChkCollectLootCar = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectLootCar", "Collect Loot Cart"), $x + 190, $y - 6, -1, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectLootCar_Info_01", "Not collecting the loot cart can save you time if you're in a rush, or want to save resources on it."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	; #Region - Custom Collect - Team AIO Mod++
	$x += 120
	$y += 15
	GUICtrlCreateLabel("<", $x + 32, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 67 + 32, $y, 16, 16)
	$g_hTxtCollectGold = _GUICtrlCreateInput("0", $x + 10 + 32, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_01", "Minimum Gold Storage amount to collect Gold.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_02", "Set same as Resume Attack values to collect when 'out of gold' error") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_03", "happens while searching for attack.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_04", "Set to zero to always collect."))
	GUICtrlSetLimit(-1, 8)
	$x += 90
	GUICtrlCreateLabel("<", $x + 32, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 67 + 32, $y, 16, 16)
	$g_hTxtCollectElixir = _GUICtrlCreateInput("0", $x + 10 + 32, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_01", "Minimum Elixir Storage amount to collect Elixir.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_02", "Set same as Resume Attack values to collect when 'out of elixir' error") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_03", "happens during troop training.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_04", -1))
	GUICtrlSetLimit(-1, 8)
	$x += 90
	GUICtrlCreateLabel("<", $x + 32, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 67 + 32, $y, 16, 16)
	$g_hTxtCollectDark = _GUICtrlCreateInput("0", $x + 10 + 32, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectDark_Info_01", "Minimum Dark Elixir Storage amount to collect Dark Elixir.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_02", -1) & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_03", -1) & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_04", -1))
	GUICtrlSetLimit(-1, 7)
	$x -= (120 + 180)
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTreasury, $x, $y - 10, 24, 24)
	$g_hChkTreasuryCollect = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect", "Treasury"), $x + 25, $y - 6, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", "Check this to automatically collect Treasury when FULL,") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_02", "'OR' when Storage values are BELOW minimum values on right,") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_03", "Use zero as min values to ONLY collect when Treasury is full") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_04", "Large minimum values will collect Treasury loot more often!"))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "ChkTreasuryCollect")
	$x += 120
	; $y += 15
	GUICtrlCreateLabel("<", $x + 32, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 67 + 32, $y, 16, 16)
	$g_hTxtTreasuryGold = _GUICtrlCreateInput("1000000", $x + 10 + 32, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_01", "Minimum Gold Storage amount to collect Treasury.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_02", "Set same as Resume Attack values to collect when 'out of gold' error") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_03", "happens while searching for attack") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
	GUICtrlSetLimit(-1, 8)
	$x += 90
	GUICtrlCreateLabel("<", $x + 32, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 67 + 32, $y, 16, 16)
	$g_hTxtTreasuryElixir = _GUICtrlCreateInput("1000000", $x + 10 + 32, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_01", "Minimum Elixir Storage amount to collect Treasury.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_02", "Set same as Resume Attack values to collect when 'out of elixir' error") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_03", "happens during troop training") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
	GUICtrlSetLimit(-1, 8)
	$x += 90
	GUICtrlCreateLabel("<", $x + 32, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 67 + 32, $y, 16, 16)
	$g_hTxtTreasuryDark = _GUICtrlCreateInput("1000", $x + 10 + 32, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryDark_Info_01", "Minimum Dark Elixir Storage amount to collect Treasury.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_02", -1) & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_03", -1) & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
	GUICtrlSetLimit(-1, 7)
	$x -= (120 + 180)
	$y += 21
	;;;;;;;;;;;
	_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModResourceP, $x, $y - 10, 25, 25)
	$g_hChkResourcePotion = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResourcePotion", "Resource potion if"), $x + 25, $y - 6)
		GUICtrlSetOnEvent(-1, "ChkResourcePotion")
		GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x += 120
	GUICtrlCreateLabel("<", $x + 32, $y + 2, -1, -1)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 67 + 32, $y, 16, 16)
	$g_hInputGoldItems = _GUICtrlCreateInput("1000000", $x + 10 + 32, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
		GUICtrlSetState(-1, $GUI_DISABLE)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "InputGoldItems_Info_01", "Minimum Gold Storage amount to resource potion."))
		GUICtrlSetLimit(-1, 8)

	$x += 90
		GUICtrlCreateLabel("<", $x + 32, $y + 2, -1, -1)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 67 + 32, $y, 16, 16)
	$g_hInputElixirItems = _GUICtrlCreateInput("1000000", $x + 10 + 32, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
		GUICtrlSetState(-1, $GUI_DISABLE)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "InputElixirItems_Info_01", "Minimum Elixir Storage amount to resource potion."))
		GUICtrlSetLimit(-1, 8)

	$x += 90
		GUICtrlCreateLabel("<", $x + 32, $y + 2, -1, -1)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 67 + 32, $y, 16, 16)
	$g_hInputDarkElixirItems = _GUICtrlCreateInput("1000", $x + 10 + 32, $y, 55, 18, ($GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER))
		GUICtrlSetState(-1, $GUI_DISABLE)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "InputDarkElixirItems_Info_01", "Minimum Dark Elixir Storage amount to resource potion."))
		GUICtrlSetLimit(-1, 7)

	$x -= (120 + 180)
	$y += 22 - 8
	;;;;;;;;;;;
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTombstone, $x, $y, 24, 24)
	$g_hChkTombstones = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTombstones", "Clear Tombstones"), $x + 25, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTombstones_Info_01", "Check this to automatically clear tombstones after enemy attack."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	; _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollectAchievements, $x + 230, $y + 2, 24, 24)
	; $g_hChkFreeMagicItems = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkFreeMagicItems", "Collect Free Magic Items"), $x + 270, $y + 4, -1, -1)
	; GUICtrlSetState(-1, $GUI_CHECKED)
	;;;;;;;;;;;
	_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnShop, $x + 245, $y + 8, 24, 24)
	$g_hChkCollectMagicItems = GUICtrlCreateCheckbox("Collect magic items", $x + 270, $y + 4, 122, -1)
	GUICtrlSetOnEvent(-1, "btnDDApply")

	$g_hBtnMagicItemsConfig = GUICtrlCreateButton("...", $x + 270 + 70 + 55, $y + 4, 20, 20)
	GUICtrlSetOnEvent(-1, "btnDailyDiscounts")

	$y += 20
	$g_hChkFreeMagicItems = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkFreeMagicItems", "Collect Free Magic Items"), $x + 270, $y + 4, -1, -1)
		GUICtrlSetOnEvent(-1, "ChkFreeMagicItems")

	;;;;;;;;;;;
	$y += 20
	$g_hChkCollectRewards = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectRewards", "Collect Challenge Rewards"), $x + 270, $y + 4 + 5, -1, -1)
		GUICtrlSetOnEvent(-1, "ChkCollectRewards")
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkSeasonChallenges_Info_01", "Check this to automatically Collect Daily/Season Rewards."))
		GUICtrlSetState(-1, $GUI_CHECKED)

	$y += 20

	$g_hChkSellRewards = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkSellRewards", "Sell Extras"), $x + 270 + 5, $y + 4 + 5, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoSellSeasonRewards_Info_01", "Check this to automatically Sell Daily/Season Rewards."))
		GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y -= 45
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTree, $x, $y + 8, 24, 24)
	; _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBark, $x + 45, $y, 24, 24)
	$g_hChkCleanYard = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanYard", "Remove Obstacles"), $x + 25, $y + 4, -1, -1)
	GUICtrlSetOnEvent(-1, "chkEdgeObstacle")         ; Team AiO MOD++
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanYard_Info_01", "Check this to automatically clear Yard from Trees, Trunks, etc."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 20 - 3
	; #Region - EdgeObstacles - Team AiO MOD++
	$g_hEdgeObstacle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MiscMODs", "ChkEdgeObstacles", "Remove edge obstacles"), $x + 30, $y + 4, -1, -1)
	GUICtrlSetOnEvent(-1, "chkEdgeObstacle")         ; Team AiO MOD++
	; #EndRegion - EdgeObstacles - Team AiO MOD++

	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGembox, $x, $y, 24, 24)
	$g_hChkGemsBox = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkGemsBox", "Remove GemBox"), $x + 25, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkGemsBox_Info_01", "Check this to automatically clear GemBox."))
	GUICtrlSetState(-1, $GUI_CHECKED)

	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollectAchievements, $x, $y, 24, 24)
	$g_hChkCollectAchievements = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectAchievements", "Collect Achievements"), $x + 25, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectAchievements_Info", "Check this to automatically collect achievement rewards."))

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	; #EndRegion - Custom Collect - Team AIO Mod++

	Local $x = 20, $y = 367 + 3 ; Team__AiO__MOD
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_03", "Locate Manually"), $x - 15, $y - 20, $g_iSizeWGrpTab3, 58 - 3) ; Team__AiO__MOD
	Local $sTxtRelocate = GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRelocate_Info_01", "Relocate your") & " "
	$x -= 9
	$y -= 4
	$g_hlblLocateTH = GUICtrlCreateLabel("", $x - 2, $y, 2, 36)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
	$g_hBtnLocateTH = GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", -1), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTH14, 1)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnTownhall", "Town Hall"))
	GUICtrlSetOnEvent(-1, "btnLocateTownHall")

	$x += 40
	$g_hlblLocateCastle = GUICtrlCreateLabel("", $x - 2, $y, 2, 36)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
	$g_hBtnLocateCastle = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCC", "Clan Castle"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnCC, 1)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCC", "Clan Castle"))
	GUICtrlSetOnEvent(-1, "btnLocateClanCastle")

	$x += 40
	$g_hlblLocateKingAltar = GUICtrlCreateLabel("", $x - 2, $y, 2, 36)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
	$g_hBtnLocateKingAltar = GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", "King"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnKingBoostLocate)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnAltarKing_Info_01", "Barbarian King Altar"))
	GUICtrlSetOnEvent(-1, "btnLocateKingAltar")

	$x += 40
	$g_hlblLocateQueenAltar = GUICtrlCreateLabel("", $x - 2, $y, 2, 36)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
	$g_hBtnLocateQueenAltar = GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", "Queen"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnQueenBoostLocate)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnAltarQueen_Info_01", "Archer Queen Altar"))
	GUICtrlSetOnEvent(-1, "btnLocateQueenAltar")

	$x += 40
	$g_hlblLocateWardenAltar = GUICtrlCreateLabel("", $x - 2, $y, 2, 36)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
	$g_hBtnLocateWardenAltar = GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Grand Warden", "Grand Warden"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWardenBoostLocate)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnAltarWarden_Info_01", "Grand Warden Altar"))
	GUICtrlSetOnEvent(-1, "btnLocateWardenAltar")

	$x += 40
	$g_hlblLocateChampionAltar = GUICtrlCreateLabel("", $x - 2, $y, 2, 36)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
	$g_hBtnLocateChampionAltar = GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Royal Champion", "Royal Champion"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnChampionBoostLocate)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnAltarChampion_Info_01", "Royal Champion Altar"))
	GUICtrlSetOnEvent(-1, "btnLocateChampionAltar")

	$x += 40
	$g_hlblLocateLaboratory = GUICtrlCreateLabel("", $x - 2, $y, 2, 36)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
	$g_hBtnLocateLaboratory = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateLaboratory", "Lab."), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLaboratory)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateLaboratory_Info_01", "Laboratory"))
	GUICtrlSetOnEvent(-1, "btnLab")

	$x += 40
	$g_hlblLocatePetHouse = GUICtrlCreateLabel("", $x - 2, $y, 2, 36)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
	$g_hBtnLocatePetHouse = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateLaboratory", "Pet House"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnPetHouse)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocatePetHouse_Info_01", "Pet House"))
	GUICtrlSetOnEvent(-1, "btnPet")

	$x += 108

	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnReset", "Reset."), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBldgX)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnReset_Info_01", "Click here to reset all building locations,") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnReset_Info_02", "when you have changed your village layout."))
	GUICtrlSetOnEvent(-1, "btnResetBuilding")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateMiscNormalVillageSubTab

; Clan Games v3
Func CreateMiscClanGamesV3SubTab()

	Local Const $g_sLibIconPathMOD = @ScriptDir & "\images\ClanGames.bmp"

	; GUI SubTab
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "Group_CG", "Clan Games"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 245)
	GUICtrlCreatePic($g_sLibIconPathMOD, $x - 6, $y + 30, 76, 103, $SS_BITMAP)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesTime", "Time"), $x - 6, $y + 135, 110 - 36, 35)
	$g_hLblRemainTime = GUICtrlCreateLabel("0d 00h", $x + 15 - 22, $y + 135 + 15, 65, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 8, $FW_BOLD, $GUI_FONTNORMAL)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesYourScore", "Your Score"), $x - 6, $y + 158 + 20, 110 - 36, 35)
	$g_hLblYourScore = GUICtrlCreateLabel("0/0", $x + 15 - 30, $y + 158 + 35, 65, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 8, $FW_BOLD, $GUI_FONTNORMAL)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 33
	$x = 100
	$g_hChkClanGamesEnabled = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesEnabled", "Enabled"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	$g_hChkClanGames60 = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGames60", "No 60min Events"), $x + 90, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGames60_Info_01", "will not choose 60 minute events"))
	$g_hChkClanGamesDebug = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesDebug", "Debug"), $x + 215, $y, -1, -1)

	$y += 40
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "Group_CG_Challenges", "Challenges"), $x - 10, $y - 15, 345, 205)
	$g_hChkClanGamesLoot = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesLoot", "Loot"), $x, $y, -1, -1)
	$y += 23
	$g_hChkClanGamesBattle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesBattle", "Battle"), $x, $y, -1, -1)
	$y += 23
	$g_hChkClanGamesDes = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesDestruction", "Destruction"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	$g_hBtnCGDes = GUICtrlCreateButton("...", $x + 142, $y, 20, 20)
	GUICtrlSetOnEvent(-1, "btnCGDes")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 23
	$g_hChkClanGamesAirTroop = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesAirTroop", "Air Troops"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	$g_hBtnCGAirTroop = GUICtrlCreateButton("...", $x + 142, $y, 20, 20)
	GUICtrlSetOnEvent(-1, "btnCGAirTroops")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 23
	$g_hChkClanGamesGroundTroop = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesGroundTroop", "Ground Troops"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	$g_hBtnCGGroundTroop = GUICtrlCreateButton("...", $x + 142, $y, 20, 20)
	GUICtrlSetOnEvent(-1, "btnCGGroundTroops")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 23
	$g_hChkClanGamesMiscellaneous = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesMiscellaneous", "Miscellaneous"), $x, $y, -1, -1)

	$x = 270
	$y -= 115
	$g_hChkClanGamesSpell = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesSpell", "Spell"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	$g_hBtnCGSpell = GUICtrlCreateButton("...", $x + 140, $y, 20, 20)
	GUICtrlSetOnEvent(-1, "btnCGSpells")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 23
	$g_hChkClanGamesBBBattle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesBBBattle", "BB Battle"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	$y += 23
	$g_hChkClanGamesBBDes = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesBBDestruction", "BB Destruction"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	$g_hBtnCGBBDes = GUICtrlCreateButton("...", $x + 140, $y, 20, 20)
	GUICtrlSetOnEvent(-1, "btnCGBBDes")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 23
	$g_hChkClanGamesBBTroops = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesBBTroop", "BB Troops"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	$g_hBtnCGBBTroop = GUICtrlCreateButton("...", $x + 140, $y, 20, 20)
	GUICtrlSetOnEvent(-1, "BtnCGBBTroops")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$x = 125
	$y += 63
	$g_hChkClanGamesPurgeAny = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesPurgeAny", "Purge Any Event"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGames60_Info_03", "If No Event Found, Purge Any Event"))
	$y += 17
	$g_hChkClanGamesStopBeforeReachAndPurge = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGamesStopBeforeReachAndPurge", "Stop before completing your limit and only Purge"), $x, $y, -1, -1)
	; #cs
	$y += 17
	$g_hChkForceBBAttackOnClanGames = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkForceBBAttackOnClanGames", "Force BB Attack"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkClanGames60_Info_02", "If ClanGames Enabled : Ignore BB Trophy, BB Loot, BB Wait BM"))

	$g_hChkOnlyBuilderBaseGC = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan games", "ChkOnlyBuilderBaseGC", "Builder base only if BB challenge"), $x + 125, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	; #ce
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 15
	$y = 45
	$g_hTxtClanGamesLog = GUICtrlCreateEdit("", $x - 10, 275, $g_iSizeWGrpTab3, 127, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc - Clan game", "TxtClanGamesLog", _
			"--------------------------------------------------------- Clan Games LOG ------------------------------------------------") & @CRLF)

EndFunc   ;==>CreateMiscClanGamesV3SubTab


Func MarkUnMarkChallenges()
	Local $iWIN_STATE_VISIBLE = 2
	Local $bCondition = False
	Select
		Case BitAND(WinGetState($g_hGUI_CGDes), $iWIN_STATE_VISIBLE) > 0
			; Setlog("g_hGUI_CGDes")
            $bCondition = (GUICtrlRead($g_hCGDestructionChallenges[0]) = $GUI_CHECKED)
			For $h In $g_hCGDestructionChallenges
				GUICtrlSetState($h, ($bCondition = True) ? ($GUI_UNCHECKED) : ($GUI_CHECKED))
			Next
		Case BitAND(WinGetState($g_hGUI_CGAirTroops), $iWIN_STATE_VISIBLE) > 0
			; Setlog("g_hGUI_CGAirTroops")
			$bCondition = (GUICtrlRead($g_hCGAirTroopChallenges[0]) = $GUI_CHECKED)
			For $h In $g_hCGAirTroopChallenges
				GUICtrlSetState($h, ($bCondition = True) ? ($GUI_UNCHECKED) : ($GUI_CHECKED))
			Next
		Case BitAND(WinGetState($g_hGUI_CGGroundTroops), $iWIN_STATE_VISIBLE) > 0
			; Setlog("g_hGUI_CGGroundTroops")
			$bCondition = (GUICtrlRead($g_hCGGroundTroopChallenges[0]) = $GUI_CHECKED)
			For $h In $g_hCGGroundTroopChallenges
				GUICtrlSetState($h, ($bCondition = True) ? ($GUI_UNCHECKED) : ($GUI_CHECKED))
			Next
		Case BitAND(WinGetState($g_hGUI_CGSpells), $iWIN_STATE_VISIBLE) > 0
			; Setlog("g_hGUI_CGSpells")
			$bCondition = (GUICtrlRead($g_hCGSpellChallenges[0]) = $GUI_CHECKED)
			For $h In $g_hCGSpellChallenges
				GUICtrlSetState($h, ($bCondition = True) ? ($GUI_UNCHECKED) : ($GUI_CHECKED))
			Next
		Case BitAND(WinGetState($g_hGUI_CGBBDes), $iWIN_STATE_VISIBLE) > 0
			; Setlog("g_hGUI_CGBBDes")
			$bCondition = (GUICtrlRead($g_hCGBBDestructionChallenges[0]) = $GUI_CHECKED)
			For $h In $g_hCGBBDestructionChallenges
				GUICtrlSetState($h, ($bCondition = True) ? ($GUI_UNCHECKED) : ($GUI_CHECKED))
			Next
		Case BitAND(WinGetState($g_hGUI_CGBBTroops), $iWIN_STATE_VISIBLE) > 0
			; Setlog("g_hGUI_CGBBTroops")
			$bCondition = (GUICtrlRead($g_hCGBBTroopChallenges[0]) = $GUI_CHECKED)
			For $h In $g_hCGBBTroopChallenges
				GUICtrlSetState($h, ($bCondition = True) ? ($GUI_UNCHECKED) : ($GUI_CHECKED))
			Next
	EndSelect
EndFunc   ;==>MarkUnMarkChallenges

Func CreateCGDes()
	$g_hGUI_CGDes = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGDes", "Main Village Destruction Challenge"), 675, 315, $g_iFrmBotPosX, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)
	Local $x = 25, $y = 25, $iMid = 656
	GUISetBkColor($COLOR_WHITE, $g_hGUI_CGDes)
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SelectCGDes", "Select Destruction Challenges"), $x - 20, $y - 20, $iMid, 220)
	$x += 10
	$y += 5

	Local $ixFix = 20
	Local $iyFix = 0

	For $i = 0 To UBound($g_hCGDestructionChallenges) - 1
		$g_hCGDestructionChallenges[$i] = GUICtrlCreateCheckbox($g_aCGDestructionChallenges[$i][1], $x + $ixFix - 20, $y + ($iyFix * 20))
		_GUICtrlSetTip(-1, GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGDes_" & $g_aCGDestructionChallenges[$i][0], $g_aCGDestructionChallenges[$i][5]))
		$iyFix += 1
		If Mod($i + 1, 7) = 0 Then
			$ixFix += 125
			$iyFix = 0
			$y = 30
		EndIf

	Next

	$y = 215
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hBtnCGDesClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCGDesClose", "Close"), Round($iMid / 2 - 42.5), $y - 5 + 35, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCGDes")

	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Unmark_All", "Un/mark"), Round($iMid / 2 - 42.5) + 25 + 62, $y - 5 + 35, 62, 25)
	GUICtrlSetOnEvent(-1, "MarkUnMarkChallenges")

EndFunc   ;==>CreateCGDes

Func CreateClanGamesAirTroops()
	$g_hGUI_CGAirTroops = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGAirTroops", "Air Troops Challenges"), 322 * 2 - 354, 315, $g_iFrmBotPosX, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)
	Local $x = 25, $y = 25, $iMid = 272
	GUISetBkColor($COLOR_WHITE, $g_hGUI_CGAirTroops)
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SelectCGAirTroops", "Select Air Troops Challenges"), $x - 20, $y - 20, $iMid, 220)
	$x += 10
	$y += 5

	Local $ixFix = 20
	Local $iyFix = 0

	For $i = 0 To UBound($g_hCGAirTroopChallenges) - 1
		$g_hCGAirTroopChallenges[$i] = GUICtrlCreateCheckbox($g_aCGAirTroopChallenges[$i][1], $x + $ixFix - 20, $y + ($iyFix * 20))
		_GUICtrlSetTip(-1, GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGAirTroops_" & $g_aCGAirTroopChallenges[$i][0], $g_aCGAirTroopChallenges[$i][5]))

		$iyFix += 1
		If Mod($i + 1, 7) = 0 Then
			$ixFix += 125
			$iyFix = 0
			$y = 30
		EndIf

	Next

	$y = 215
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hBtnCGAirTroopsClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCGAirTroopsClose", "Close"), Round($iMid / 2 - 42.5), $y - 5 + 35, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCGAirTroops")

	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Unmark_All", "Un/mark"), Round($iMid / 2 - 42.5) + 25 + 62, $y - 5 + 35, 62, 25)
	GUICtrlSetOnEvent(-1, "MarkUnMarkChallenges")

EndFunc   ;==>CreateClanGamesAirTroops

Func CreateClanGamesGroundTroops()
	$g_hGUI_CGGroundTroops = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGGroundTroop", "Ground Troops Challenges"), 322 * 2, 315, $g_iFrmBotPosX, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)
	Local $x = 25, $y = 25, $iMid = 626
	GUISetBkColor($COLOR_WHITE, $g_hGUI_CGGroundTroops)
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SelectCGGroundTroop", "Select Ground Troops Challenges"), $x - 20, $y - 20, $iMid, 220)
	$x += 10
	$y += 5

	Local $ixFix = 20
	Local $iyFix = 0

	For $i = 0 To UBound($g_hCGGroundTroopChallenges) - 1
		$g_hCGGroundTroopChallenges[$i] = GUICtrlCreateCheckbox($g_aCGGroundTroopChallenges[$i][1], $x + $ixFix - 20, $y + ($iyFix * 20))
		_GUICtrlSetTip(-1, GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGGroundTroop_" & $g_aCGGroundTroopChallenges[$i][0], $g_aCGGroundTroopChallenges[$i][5]))

		$iyFix += 1
		If Mod($i + 1, 7) = 0 Then
			$ixFix += 125
			$iyFix = 0
			$y = 30
		EndIf

	Next

	$y = 215
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hBtnCGGroundTroopClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCGGroundTroopClose", "Close"), Round($iMid / 2 - 42.5), $y - 5 + 35, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCGGroundTroops")

	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Unmark_All", "Un/mark"), Round($iMid / 2 - 42.5) + 25 + 62, $y - 5 + 35, 62, 25)
	GUICtrlSetOnEvent(-1, "MarkUnMarkChallenges")
EndFunc   ;==>CreateClanGamesGroundTroops

Func CreateClanGamesSpell()
	$g_hGUI_CGSpells = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGSpellsEx", "Spell Challenges"), 290, 315, $g_iFrmBotPosX, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)
	Local $x = 25, $y = 25, $iMid = 272
	GUISetBkColor($COLOR_WHITE, $g_hGUI_CGSpells)
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SelectCGSpellsEx", "Select Spell Challenges"), $x - 20, $y - 20, $iMid, 220)
	$x += 10
	$y += 5

	Local $ixFix = 20
	Local $iyFix = 0

	For $i = 0 To UBound($g_hCGSpellChallenges) - 1
		$g_hCGSpellChallenges[$i] = GUICtrlCreateCheckbox($g_aCGSpellChallenges[$i][1], $x + $ixFix - 20, $y + ($iyFix * 20))
		_GUICtrlSetTip(-1, GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGSpellsEx_" & $g_aCGSpellChallenges[$i][0], $g_aCGSpellChallenges[$i][5]))

		$iyFix += 1
		If Mod($i + 1, 7) = 0 Then
			$ixFix += 125
			$iyFix = 0
			$y = 30
		EndIf

	Next

	$y = 215
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hBtnCGSpellsClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCGSpellsClose", "Close"), Round($iMid / 2 - 42.5), $y - 5 + 35, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCGSpells")


	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Unmark_All", "Un/mark"), Round($iMid / 2 - 42.5) + 25 + 62, $y - 5 + 35, 62, 25)
	GUICtrlSetOnEvent(-1, "MarkUnMarkChallenges")
EndFunc   ;==>CreateClanGamesSpell

Func CreateClanGamesBBDes()
	$g_hGUI_CGBBDes = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGBBDes", "BB Destruction Challenges"), 322 * 2 - 250, 315, $g_iFrmBotPosX, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)
	Local $x = 25, $y = 25, $iMid = 376
	GUISetBkColor($COLOR_WHITE, $g_hGUI_CGBBDes)
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SelectCGBBDes", "Select BB Destruction Challenges"), $x - 20, $y - 20, $iMid, 220)
	$x += 10
	$y += 5

	Local $ixFix = 20
	Local $iyFix = 0

	For $i = 0 To UBound($g_hCGBBDestructionChallenges) - 1
		$g_hCGBBDestructionChallenges[$i] = GUICtrlCreateCheckbox($g_aCGBBDestructionChallenges[$i][1], $x + $ixFix - 20, $y + ($iyFix * 20))
		_GUICtrlSetTip(-1, GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGBBDes_" & $g_aCGBBDestructionChallenges[$i][0], $g_aCGBBDestructionChallenges[$i][5]))

		$iyFix += 1
		If Mod($i + 1, 7) = 0 Then
			$ixFix += 125
			$iyFix = 0
			$y = 30
		EndIf

	Next

	$y = 215
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hBtnCGSpellsClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCGBBDesClose", "Close"), Round($iMid / 2 - 42.5), $y - 5 + 35, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCGBBDes")

	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Unmark_All", "Un/mark"), Round($iMid / 2 - 42.5) + 25 + 62, $y - 5 + 35, 62, 25)
	GUICtrlSetOnEvent(-1, "MarkUnMarkChallenges")
EndFunc   ;==>CreateClanGamesBBDes

Func CreateClanGamesBBTroops()
	$g_hGUI_CGBBTroops = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGBBTroops", "BB Troops Challenges"), 322 * 2 - 354, 315, $g_iFrmBotPosX, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)
	Local $x = 25, $y = 25, $iMid = 272
	GUISetBkColor($COLOR_WHITE, $g_hGUI_CGBBTroops)
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SelectCGBBTroops", "Select BB Troops Challenges"), $x - 20, $y - 20, $iMid, 220)
	$x += 10
	$y += 5

	Local $ixFix = 20
	Local $iyFix = 0

	For $i = 0 To UBound($g_hCGBBTroopChallenges) - 1
		$g_hCGBBTroopChallenges[$i] = GUICtrlCreateCheckbox($g_aCGBBTroopChallenges[$i][1], $x + $ixFix - 20, $y + ($iyFix * 20))
		_GUICtrlSetTip(-1, GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGBBTroops_" & $g_aCGBBTroopChallenges[$i][0], $g_aCGBBTroopChallenges[$i][5]))

		$iyFix += 1
		If Mod($i + 1, 7) = 0 Then
			$ixFix += 125
			$iyFix = 0
			$y = 30
		EndIf

	Next

	$y = 215
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hBtnCGBBTroopsClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCGBBTroopsClose", "Close"), Round($iMid / 2 - 42.5), $y - 5 + 35, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCGBBTroops")

	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Unmark_All", "Un/mark"), Round($iMid / 2 - 42.5) + 25 + 62, $y - 5 + 35, 62, 25)
	GUICtrlSetOnEvent(-1, "MarkUnMarkChallenges")
EndFunc   ;==>CreateClanGamesBBTroops

Func CreateClanCapitalTab()
	Local $x = 15, $y = 40
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_Stats", "Stats"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 70)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalGold,  $x, $y, 24, 24)
		$g_lblCapitalGold = GUICtrlCreateLabel("---", $x + 35, $y + 5, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalMedal, $x + 140, $y, 24, 24)
		$g_lblCapitalMedal = GUICtrlCreateLabel("---", $x + 175, $y + 5, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$y += 30
		$g_hChkEnableCollectCCGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CollectCCGold", "Collect Clan Capital Gold"), $x, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_Forge", "Forge/Craft Gold"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 88)
		$g_hChkEnableForgeGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeGold", "Use Gold"), $x, $y, -1, -1)
	$y += 20
		$g_hChkEnableForgeElix = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeElix", "Use Elixir"), $x, $y, -1, -1)
	$x += 100
	$y -= 20
		$g_hChkEnableForgeDE = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeDE", "Use Dark Elixir"), $x, $y, -1, -1)
	$y += 20
		$g_hChkEnableForgeBBGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeBBGold", "Use BuilderBase Gold"), $x, $y, -1, -1)
	$x += 140
	$y -= 20
		$g_hChkEnableForgeBBElix = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeBBElix", "Use BuilderBase Elixir"), $x, $y, -1, -1)
	$x = 15
	$y += 48
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeUseBuilder", "Use"), $x, $y + 2, 45, 17)
		$g_hCmbForgeBuilder = GUICtrlCreateCombo("", $x + 23, $y, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "1|2|3|4", "1")
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "InputForgeUseBuilder", "Put How many builder to use to Forge"))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builder for Forge"), $x + 65, $y + 2, 100, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$y += 47
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_AutoUpgrade", "Auto Upgrade Clan Capital"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 65)
		$g_hChkEnableAutoUpgradeCC = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableAutoUpgradeCC", "Enable"), $x, $y, -1, -1)
	$y += 20	
		$g_hChkAutoUpgradeCCIgnore = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCIgnore", "Ignore Decoration Building"), $x, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCIgnore", "Enable Ignore Upgrade for Groove, Tree, Forest, Campsite"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
