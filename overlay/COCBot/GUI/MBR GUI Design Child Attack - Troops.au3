; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Train Army" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), Boju (11-2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_TRAINARMY = 0
Global $g_hGUI_TRAINARMY_TAB = 0, $g_hGUI_TRAINARMY_TAB_ITEM1 = 0, $g_hGUI_TRAINARMY_TAB_ITEM2 = 0, $g_hGUI_TRAINARMY_TAB_ITEM3 = 0, $g_hGUI_TRAINARMY_TAB_ITEM4 = 0

; TrainArmy childs
Global $g_hGUI_TRAINARMY_ARMY = 0, $g_hGUI_TRAINARMY_BOOST = 0, $g_hGUI_TRAINARMY_TRAINORDER = 0, $g_hGUI_TRAINARMY_OPTIONS = 0
Global $g_hGUI_TRAINARMY_ARMY_TAB = 0, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM1 = 0, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM2 = 0
Global $g_hGUI_TRAINARMY_ORDER_TAB = 0, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM1 = 0, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM2 = 0
Global $g_hGUI_SPELLARMY_ARMY = 0, $g_hGUI_SIEGEARMY_ARMY = 0 ; Custom - Team AIO Mod++

; Custom train tab & Quick train tab
Global $g_hGUI_TRAINTYPE = 0
Global $g_hGUI_TRAINTYPE_TAB = 0, $g_hGUI_TRAINTYPE_TAB_ITEM1 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM2 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM3 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM4 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM5 = 0

; Troops/Spells sub-tab
Global $g_hRadCustomTrain = 0, $g_hRadQuickTrain = 0, $g_ahChkArmy[3] = [0, 0, 0]
Global $g_ahTxtTrainArmyTroopCount[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahLblTrainArmyTroopLevel[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtTrainArmySpellCount[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahLblTrainArmySpellLevel[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtTrainArmySiegeCount[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0]
Global $g_ahLblTrainArmySiegeLevel[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0]
Global $g_hTxtFullTroop = 0, $g_hChkTotalCampForced = 0, $g_hTxtTotalCampForced = 0
Global $g_hChkDoubleTrain = 0, $g_hChkPreciseArmy = 0

Global $g_hGrpTrainTroops = 0
Global $g_ahPicTrainArmyTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicTrainArmySpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblTotalTimeCamp = 0, $g_hLblElixirCostCamp = 0, $g_hLblDarkCostCamp = 0, $g_hCalTotalTroops = 0, $g_hLblTotalProgress = 0, $g_hLblCountTotal = 0, _
		$g_hTxtTotalCountSpell = 0, $g_hLblTotalTimeSpell = 0, $g_hLblElixirCostSpell = 0, $g_hLblDarkCostSpell = 0, _
		$g_hLblTotalTimeSiege = 0, $g_hLblCountTotalSiege = 0, $g_hLblGoldCostSiege = 0

; Quick Train sub-tab
Global $g_aQuickTroopIcon[$eTroopCount] = [$eIcnBarbarian, $eIcnSuperBarbarian, $eIcnArcher, $eIcnSuperArcher, $eIcnGiant, $eIcnSuperGiant, $eIcnGoblin, $eIcnSneakyGoblin, $eIcnWallBreaker, $eIcnSuperWallBreaker, _
	$eIcnBalloon, $eIcnRocketBalloon, $eIcnWizard, $eIcnSuperWizard, $eIcnHealer, $eIcnDragon, $eIcnSuperDragon, $eIcnPekka, $eIcnBabyDragon, $eIcnInfernoDragon, $eIcnMiner, $eIcnElectroDragon, $eIcnYeti, $eIcnDragonRider, $eIcnMinion, $eIcnSuperMinion, _
	$eIcnHogRider, $eIcnValkyrie, $eIcnSuperValkyrie, $eIcnGolem, $eIcnWitch, $eIcnSuperWitch, $eIcnLavaHound, $eIcnIceHound, $eIcnBowler, $eIcnSuperBowler, $eIcnIceGolem, $eIcnHeadhunter]
Global $g_aQuickSpellIcon[$eSpellCount] = [$eIcnLightSpell, $eIcnHealSpell, $eIcnRageSpell, $eIcnJumpSpell, $eIcnFreezeSpell, $eIcnCloneSpell, $eIcnInvisibilitySpell, $eIcnPoisonSpell, $eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnSkeletonSpell, $eIcnBatSpell]
Global $g_ahChkUseInGameArmy[3], $g_ahPicTotalQTroop[3], $g_ahPicTotalQSpell[3], $g_ahLblTotalQTroop[3], $g_ahLblTotalQSpell[3]
Global $g_ahBtnEditArmy[3], $g_ahLblEditArmy[3], $g_ahPicQuickTroop[3][22], $g_ahLblQuickTroop[3][22], $g_ahPicQuickSpell[3][11], $g_ahLblQuickSpell[3][11]
Global $g_ahLblQuickTrainNote[3], $g_ahLblUseInGameArmyNote[3]

Global $g_hGUI_QuickTrainEdit = 0, $g_hGrp_QTEdit = 0
Global $g_hBtnRemove_QTEdit, $g_hBtnSave_QTEdit, $g_hBtnCancel_QTEdit
Global $g_ahPicQTEdit_Troop[7], $g_ahTxtQTEdit_Troop[7], $g_ahPicQTEdit_Spell[7], $g_ahTxtQTEdit_Spell[7]
Global $g_ahLblQTEdit_TotalTroop, $g_ahLblQTEdit_TotalSpell
Global $g_ahPicTroop_QTEdit[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicSpell_QTEdit[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

; Boost sub-tab
Global $g_hCmbBoostBarracks = 0, $g_hCmbBoostSpellFactory = 0, $g_hCmbBoostWorkshop = 0, $g_hCmbBoostBarbarianKing = 0, $g_hCmbBoostArcherQueen = 0, $g_hCmbBoostWarden = 0, $g_hCmbBoostChampion = 0, $g_hCmbBoostEverything = 0
Global $g_hCmbBoostMaxSuperTroops = 0
Global $g_hLblBoosthour = 0, $g_ahLblBoosthoursE = 0
Global $g_hLblBoosthours[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkBoostBarracksHours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hChkBoostBarracksHoursE1 = 0, $g_hChkBoostBarracksHoursE2 = 0
Global $g_hChkSuperTroops = 0, $g_ahLblSuperTroops[$iMaxSupersTroop] = [0, 0], $g_ahCmbSuperTroops[$iMaxSupersTroop] = [0, 0], $g_ahPicSuperTroops[$iMaxSupersTroop] = [0, 0]
Global $g_hCmbSuperTroopsResources = 0, $g_hChkSuperAutoTroops = 0	; Custom Super Troops - Team AIO Mod++

; Train Order sub-tab
Global $g_asTroopOrderList, $g_asSpellsOrderList ; Custom fix - Team AIO Mod++
Func LoadTranslatedTrainTroopsOrderList()

	Local $asTroopOrderList = ["", _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperBarbarians", "Super Barbarians"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperArchers", "Super Archers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperGiants", "Super Giants"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSneakyGoblins", "Sneaky Goblin"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWallBreakers", "Super Wall Breakers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRocketBalloons", "Rocket Balloons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWizards", "Super Wizards"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Super Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtInfernoDragons", "Inferno Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroDragons", "Electro Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtYetis", "Yetis"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragonRiders", "Dragon Riders"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperMinions", "Super Minions"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperValkyries", "Super Valkyries"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWitches", "Super Witches"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceHounds", "Ice Hounds"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperBowlers", "Super Bowlers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceGolems", "Ice Golems"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHeadhunters", "Headhunters")]

			$g_asTroopOrderList = $asTroopOrderList
EndFunc   ;==>LoadTranslatedTrainTroopsOrderList

Global $g_hChkCustomTrainOrderEnable = 0
Global $g_ahCmbTroopOrder[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahImgTroopOrder[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hBtnTroopOrderSet = 0, $g_ahImgTroopOrderSet = 0
Global $g_hBtnRemoveTroops

; Spells Brew Order
Func LoadTranslatedBrewSpellsOrderList()

	Local $asSpellsOrderList = ["", _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortLightningSpells", "Lightning"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHealSpells", "Heal"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortRageSpells", "Rage"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortJumpSpells", "Jump"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortFreezeSpells", "Freeze"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortCloneSpells", "Clone"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortInvisibilitySpells", "Invisibility"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortPoisonSpells", "Poison"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortEarthquakeSpells", "EarthQuake"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHasteSpells", "Haste"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortSkeletonSpells", "Skeleton"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortBatSpells", "Bat")]

			$g_asSpellsOrderList = $asSpellsOrderList
EndFunc   ;==>LoadTranslatedBrewSpellsOrderList

Global $g_hChkCustomBrewOrderEnable = 0
Global $g_ahCmbSpellsOrder[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahImgSpellsOrder[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hBtnSpellsOrderSet = 0, $g_ahImgSpellsOrderSet = 0
Global $g_hBtnRemoveSpells

; Options sub-tab
Global $g_hChkCloseWhileTraining = 0, $g_hChkCloseWithoutShield = 0, $g_hChkCloseEmulator = 0, $g_hChkSuspendComputer = 0, $g_hChkRandomClose = 0, $g_hRdoCloseWaitExact = 0, _
		$g_hRdoCloseWaitRandom = 0, $g_hCmbCloseWaitRdmPercent = 0, $g_hCmbMinimumTimeClose = 0, $g_hSldTrainITDelay = 0, $g_hChkTrainAddRandomDelayEnable = 0, $g_hTxtAddRandomDelayMin = 0, _
		$g_hTxtAddRandomDelayMax = 0

Global $g_hLblCloseWaitRdmPercent = 0, $g_hLblCloseWaitingTroops = 0, $g_hLblSymbolWaiting = 0, $g_hLblWaitingInMinutes = 0, $g_hLblTrainITDelay = 0, $g_hLblTrainITDelayTime = 0, _
		$g_hLblAddDelayIdlePhaseBetween = 0, $g_hLblAddDelayIdlePhaseSec = 0, $g_hPicCloseWaitTrain = 0, $g_hPicCloseWaitStop = 0, $g_hPicCloseWaitExact = 0

; Max logout time - Team AiO MOD++
Global $g_hChkTrainLogoutMaxTime = 0, $g_hTxtTrainLogoutMaxTime = 0, $g_hLblTrainLogoutMaxTime = 0

; Custom Train - Team AIO Mod++
Global $g_hGUI_CreateQuickTrainSubTab = 0

Func CreateAttackTroops()
	$g_hGUI_TRAINARMY = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_ATTACK)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY)

	;creating subchilds first!
	CreateTrainTroops()
	CreateTrainSpells()
	CreateTrainSieges()
	CreateTrainBoost()
	CreateTrainOptions()
	
	; Custom Train - Team AIO Mod++
	CreateQuickTrainSubTab()

	GUISwitch($g_hGUI_TRAINARMY)
	$g_hGUI_TRAINARMY_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, $WS_CLIPSIBLINGS)
	$g_hGUI_TRAINTYPE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_Troops", "Troops"))
	$g_hGUI_TRAINTYPE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_Spells", "Spells"))
	$g_hGUI_TRAINTYPE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_Sieges_Pets", "Sieges / Pets"))
	$g_hGUI_TRAINTYPE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_02", "Boost"))
	$g_hGUI_TRAINTYPE_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_04", "Options"))

	CreateQuickTrainEdit()

	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackTroops

Func CreateQuickTrainSubTab()
	; $g_hGUI_TRAINARMY_ARMY_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_01_STab_02", "Quick Train"))
	$g_hGUI_CreateQuickTrainSubTab = _GUICreate(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_01_STab_02", "Quick Train"), 444, 500, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_CreateQuickTrainSubTab)

	Local $x = 12, $y = 50, $del_y = 108

	$g_hRadCustomTrain = GUICtrlCreateRadio("Custom train", 75, 15, 100, 25)
	GUICtrlSetState(-1, $GUI_CHECKED)
	; GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetOnEvent(-1, "radSelectTrainType")
	$g_hRadQuickTrain = GUICtrlCreateRadio("Quick Train mode (not recommended).", 300, 15, 100, 25)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	; GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetOnEvent(-1, "radSelectTrainType")

	For $i = 0 To 2
		GUICtrlCreateGroup("", $x - 2, $y, 412, $del_y)
		$g_ahChkArmy[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkArmy", "Army ") & $i + 1, $x + 10, $y + 20, 70, 15)
		If $i = 0 Then GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkQuickTrainArmy")

		$g_ahChkUseInGameArmy[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkUseInGameArmy", "In-Game Army"), $x + 10, $y + 45, -1, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkUseInGameArmy")
		GUICtrlSetTip(-1, "Uncheck and create preset army here, MBR will apply this preset to in-game quick train setting")

		$g_ahBtnEditArmy[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrain, $x + 10, $y + 70, 22, 22)
		GUICtrlSetOnEvent(-1, "EditQuickTrainArmy")
		$g_ahLblEditArmy[$i] = GUICtrlCreateLabel(" " & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Btn_Edit_Army", "Edit Army"), $x + 35, $y + 75, 50, 15, $SS_LEFT)

		$g_ahLblTotalQTroop[$i] = GUICtrlCreateLabel(0, $x + 360, $y + 25, 40, 15, $SS_RIGHT)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_ahPicTotalQTroop[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopsCost, $x + 353, $y + 20, 24, 24)

		$g_ahLblTotalQSpell[$i] = GUICtrlCreateLabel(0, $x + 360, $y + 70, 40, 15, $SS_RIGHT)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_ahPicTotalQSpell[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellsCost, $x + 350, $y + 65, 24, 24)

		$g_ahLblQuickTrainNote[$i] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblQuickTrainNote", "Use button 'Edit Army' to create troops and spells in quick Army") & $i + 1, $x + 120, $y + 30, 200, 70, $SS_CENTER)
			GUICtrlSetFont(-1, 12, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_SKYBLUE)
		$g_ahLblUseInGameArmyNote[$i] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblUseInGameArmyNote", "Quick train using in-game troops and spells preset Army") & $i + 1, $x + 120, $y + 30, 270, 70, $SS_CENTER)
			GUICtrlSetFont(-1, 12, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, $COLOR_SKYBLUE)

		For $j = 0 To 6
			$g_ahPicQuickTroop[$i][$j] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmpty3, $x + 100 + $j * 36, $y + 10, 32, 32)
			$g_ahLblQuickTroop[$i][$j] = GUICtrlCreateLabel("", $x + 101 + $j * 36, $y + 42, 30, 11, $ES_CENTER)
			$g_ahPicQuickSpell[$i][$j] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmpty3, $x + 100 + $j * 36, $y + 58, 32, 32)
			$g_ahLblQuickSpell[$i][$j] = GUICtrlCreateLabel("", $x + 101 + $j * 36, $y + 90, 30, 11, $ES_CENTER)
		Next

		GUICtrlCreateGroup("", -99, -99, 1, 1)

		For $j = $g_ahLblQuickTrainNote[$i] To $g_ahLblQuickSpell[$i][6]
			GUICtrlSetState($j, $GUI_HIDE)
		Next

		$x = 12
		$y += $del_y
	Next
	$y += 50

	$g_hBtnBBClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnQuickTrainClose", "Close"), 344, $y, 65, 25)
	GUICtrlSetOnEvent(-1, "HideQuickTrain")
EndFunc   ;==>CreateQuickTrainSubTab

Func ShowQuickTrain()
	GUISetState(@SW_SHOW, $g_hGUI_CreateQuickTrainSubTab)
EndFunc

Func HideQuickTrain()
	GUISetState(@SW_HIDE, $g_hGUI_CreateQuickTrainSubTab)
	GUISetState(@SW_HIDE, $g_hGUI_QuickTrainEdit)
EndFunc

Func CreateQuickTrainEdit()

	$g_hGUI_QuickTrainEdit = _GUICreate(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "GUI_QuickTrainEdit", "Edit troops and spells for quick train"), 472, 370, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)

	Local $x = 7
	Local $y = 5
	$g_hGrp_QTEdit = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "GUI_QuickTrainEdit", "Edit troops and spells for quick train"), $x, $y, 454, 280)

		$x = 12
		$y = 20
		GUICtrlCreateGroup("", $x, $y - 3, 444, 125)

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x + 10, $y + 15, 22, 22)
		GUICtrlSetOnEvent(-1, "RemoveArmy_QTEdit")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Btn_Remove", "Remove"), $x + 35, $y + 20, -1, 15, $SS_LEFT)
		GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Btn_Cancel", "Cancel"), $x + 10, $y + 40, 65, 20, $SS_LEFT)
		GUICtrlSetOnEvent(-1, "ExitQuickTrainEdit")
		GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Btn_Save", "Save"), $x + 10, $y + 65, 65, 20, $SS_LEFT)
		GUICtrlSetOnEvent(-1, "SaveArmy_QTEdit")

		For $i = 0 To 6
			$g_ahPicQTEdit_Troop[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmpty3, $x + 100 + $i * 36, $y + 10, 32, 32)
			GUICtrlSetOnEvent(-1, "RemoveTroop_QTEdit")
			GUICtrlSetState(-1, $GUI_HIDE)
			$g_ahTxtQTEdit_Troop[$i] = _GUICtrlCreateInput(0, $x + 101 + $i * 36, $y + 45, 30, 15, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "TxtQTEdit_Troop")
			GUICtrlSetState(-1, $GUI_HIDE)
			$g_ahPicQTEdit_Spell[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmpty3, $x + 100 + $i * 36, $y + 65, 32, 32)
			GUICtrlSetOnEvent(-1, "RemoveSpell_QTEdit")
			GUICtrlSetState(-1, $GUI_HIDE)
			$g_ahTxtQTEdit_Spell[$i] = _GUICtrlCreateInput(0, $x + 101 + $i * 36, $y + 100, 30, 15, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "TxtQTEdit_Spell")
			GUICtrlSetState(-1, $GUI_HIDE)
		Next

		$g_ahLblQTEdit_TotalTroop = GUICtrlCreateLabel(0, $x + 390, $y + 25, 40, 15, $SS_RIGHT)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopsCost, $x + 380, $y + 20, 24, 24)

		$g_ahLblQTEdit_TotalSpell = GUICtrlCreateLabel(0, $x + 390, $y + 85, 40, 15, $SS_RIGHT)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellsCost, $x + 380, $y + 80, 24, 24)

		GUICtrlCreateGroup("", -99, -99, 1, 1)

		For $i = 0 To $eTroopCount - 1
			If $i <= 12 Then
				$x = 14 + (34 * $i)
				$y = 160
			ElseIf $i > 12 And $i <= 25 Then
				$x = 14 + (34 * ($i - 13))
				$y = 200
			Else
				$x = 14 + (34 * ($i - 26))
				$y = 240
			EndIf
			$g_ahPicTroop_QTEdit[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickTroopIcon[$i], $x, $y, 32, 32)
			GUICtrlSetTip(-1, $g_asTroopNames[$i])
			GUICtrlSetOnEvent(-1, "SelectTroop_QTEdit")
		Next

		$x = 14
		$y = 290
		For $i = 0 To $eSpellCount - 1
			$g_ahPicSpell_QTEdit[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickSpellIcon[$i], $x, $y, 32, 32)
			GUICtrlSetTip(-1, $g_asSpellNames[$i])
			GUICtrlSetOnEvent(-1, "SelectSpell_QTEdit")
			$x += 34
		Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateQuickTrainEdit

#Region - Custom - Team AIO Mod++
Func CreateTrainBoost()

	Local $sTxtTip = ""

	$g_hGUI_TRAINARMY_BOOST = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY_BOOST)

	Local $x = 25, $y = 3

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost_", "Group_00", "≥ Boost until more resources | < Boost if less than value"), $x - 20, $y - 5, $g_iSizeWGrpTab3 - 12, 38)

	; Schedule boost - Team AIO Mod++ 
	$y += 10
	$g_hCmbSwitchBoostSchedule[0] = GUICtrlCreateCombo("", $x + 32, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	#Tidy_off
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtMinBoost_Info_01_", "≥ 	: Boost until this resources or more.") & @CRLF & _ 
					   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtMinBoost_Info_02_", "< 	: Boost if resources are less of this value.") )
	#Tidy_on
	GUICtrlSetOnEvent(-1, "CmbSwitchBoostSchedule")
	GUICtrlSetData(-1, 	"-|≥|<")
	_GUICtrlComboBox_SetCurSel(-1, 0)
	$x += 33
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 67 + 32, $y, 16, 16)
	$g_hTxtMinBoostGold = _GUICtrlCreateInput("100000", $x + 10 + 32, $y, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetLimit(-1, 8)
	$x += 90
	$g_hCmbSwitchBoostSchedule[1] = GUICtrlCreateCombo("", $x + 32, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	#Tidy_off
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtMinBoost_Info_01_", "≥ 	: Boost until this resources or more.") & @CRLF & _ 
					   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtMinBoost_Info_02_", "< 	: Boost if resources are less of this value.") )
	#Tidy_on
	GUICtrlSetOnEvent(-1, "CmbSwitchBoostSchedule")
	GUICtrlSetData(-1, 	"-|≥|<")
	_GUICtrlComboBox_SetCurSel(-1, 0)
	$x += 33
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 67 + 32, $y, 16, 16)
	$g_hTxtMinBoostElixir = _GUICtrlCreateInput("100000", $x + 10 + 32, $y, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetLimit(-1, 8)
	$x += 90
	$g_hCmbSwitchBoostSchedule[2] = GUICtrlCreateCombo("", $x + 32, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	#Tidy_off
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtMinBoost_Info_01_", "≥ 	: Boost until this resources or more.") & @CRLF & _ 
					   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtMinBoost_Info_02_", "< 	: Boost if resources are less of this value.") )
	#Tidy_on
	GUICtrlSetOnEvent(-1, "CmbSwitchBoostSchedule")
	GUICtrlSetData(-1, 	"-|≥|<")
	_GUICtrlComboBox_SetCurSel(-1, 0)
	$x += 33
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 67 + 32, $y, 16, 16)
	$g_hTxtMinBoostDark = _GUICtrlCreateInput("3000", $x + 10 + 32, $y, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetLimit(-1, 7)
	$y -= 4

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 25
	$y += 45

	; Army Buildings
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_01", "Boost Army Buildings"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 12, 73)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarrackBoost, $x - 10, $y - 2, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkBarrackBoost, $x + 19, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblBarracksBoost", "Barracks"), $x + 20 + 29, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblBarracksBoost_Info_01", "Use this to boost your Barracks with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostBarracks = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|" & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Troops_Boost_No_Limit", "No limit"), "0")
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellFactoryBoost, $x + 204, $y - 2, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkSpellBoost, $x + 233, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblSpellFactoryBoost", "Spell Factory"), $x + 263, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblSpellFactoryBoost_Info_01", "Use this to boost your Spell Factory with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostSpellFactory = GUICtrlCreateCombo("", $x + 330, $y, 60, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|" & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Troops_Boost_No_Limit", "No limit"), "0")
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWorkshopBoost, $x + 5, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblWorkshopBoost", "Workshop"), $x + 20 + 29, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblWorkshopBoost_Info_01", "Use this to boost your Workshop with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostWorkshop = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|" & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Troops_Boost_No_Limit", "No limit"), "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Heroes
	$y += 48
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_02_", "Boost Heroes"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 12, 75)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKingBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1), $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblKingBoost_Info_01", "Use this to boost your Barbarian King with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostBarbarianKing = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|" & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Troops_Boost_No_Limit", "No limit"), "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeKing")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueenBoost, $x + 204, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1), $x + 234, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblQueenBoost_Info_01", "Use this to boost your Archer Queen with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostArcherQueen = GUICtrlCreateCombo("", $x + 330, $y, 60, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|" & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Troops_Boost_No_Limit", "No limit"), "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeQueen")

	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Grand Warden", -1), $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblWardenBoost_Info_01", "Use this to boost your Grand Warden with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostWarden = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|" & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Troops_Boost_No_Limit", "No limit"), "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeWarden")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampionBoost, $x + 204, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Royal Champion", -1), $x + 234, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblChampionBoost_Info_01", "Use this to boost your Royal Champion with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostChampion = GUICtrlCreateCombo("", $x + 330, $y, 60, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|" & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Troops_Boost_No_Limit", "No limit"), "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeChampion")
	GUICtrlCreateGroup("", -99, -99, 1, 1)


	$y += 50
	#Region - One Gem Boost - Team AiO MOD++
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkOneGemBoostWorkshop_Group_01", "Boost one gem"), $x + 235, $y - 20, 167, 123)
	$g_hChkOneGemBoostBarracks = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkOneGemBoostBarracks_Info_01", "Barracks 1'Gem Boost"), $x + 15 + 170 + 60, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkOneGemBoostBarracks_Info_02", "Use this to boost your Barracks Automatically Only In 1-Gem Army Event."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	$y += 25
	$g_hChkOneGemBoostSpells = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkOneGemBoostSpells_Info_01", "Spells 1'Gem Boost"), $x + 15 + 170 + 60, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkOneGemBoostSpells_Info_02", "Use this to boost your Spell Factory Automatically Only In 1-Gem Army Event."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	$y += 25
	$g_hChkOneGemBoostWorkshop = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkOneGemBoostWorkshop_Info_01", "Workshop 1'Gem Boost"), $x + 15 + 170 + 60, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkOneGemBoostHeroes_Info_02", "Use this to boost your Heroes Automatically Only In 1-Gem Army Event."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	$y += 25
	$g_hChkOneGemBoostHeroes = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkOneGemBoostHeroes_Info_01", "Heroes 1'Gem Boost"), $x + 15 + 170 + 60, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkOneGemBoostWorkshop_Info_02", "Use this to boost your Workshop Automatically Only In 1-Gem Army Event."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y -= 75
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#EndRegion - One Gem Boost - Team AiO MOD++

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_03_", "Boost Everything"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 184, 48)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBoostPotion, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Potion", -1), $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblEverythingBoost_Info_01", "Use this to boost everything with POTIONS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostEverything = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|" & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Troops_Boost_No_Limit", "No limit"), "0") ; Custom boost - Team AIO Mod++
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 48
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_04", "Boost Schedule"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 184, 75)

	$g_hLblBoosthour = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", -1) & ":", $x, $y, -1, 15)
	$sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblBoosthours[0] = GUICtrlCreateLabel(" 0", $x + 30, $y)
	$g_hLblBoosthours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y)
	$g_hLblBoosthours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y)
	$g_hLblBoosthours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y)
	$g_hLblBoosthours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y)
	$g_hLblBoosthours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y)
	$g_hLblBoosthours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y)
	$g_hLblBoosthours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y)
	$g_hLblBoosthours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y)
	$g_hLblBoosthours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y)
	$g_hLblBoosthours[10] = GUICtrlCreateLabel("10", $x + 180, $y)
	$g_hLblBoosthours[11] = GUICtrlCreateLabel("11", $x + 195, $y)
	$g_ahLblBoosthoursE = GUICtrlCreateLabel("X", $x + 213, $y + 2, 11, 11)

	$y += 15
	$g_hChkBoostBarracksHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", "This button will clear or set the entire row of boxes"))
	GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE1")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", "AM"), $x + 5, $y)

	$y += 15
	$g_hChkBoostBarracksHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
	GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE2")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", "PM"), $x + 5, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	#Region - Custom Super Troops - Team AIO Mod++
	$y += 49
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_05", "Boost Super Troops"), $x - 20, $y - 22, $g_iSizeWGrpTab3 - 12, 70)

	; Local $sCmbTroopList = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtListOfSuperTroops", "Disabled|" & _ArrayToString($g_asSuperTroopNames))

	Local $sCmbTroopList = "Disabled|" & _ArrayToString($g_asSuperTroopNames)

	$g_hChkSuperTroops = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkSuperTroops", "Enable Super Troops"), $x - 14, $y - 8, -1, -1)
		GUICtrlSetOnEvent(-1, "chkSuperTroops")

	; Custom Super Troops - Team AIO Mod++
	$g_hChkSuperAutoTroops = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkAutoSuperTroops", "Automatic"), $x + 288, $y - 8, -1, -1)
		GUICtrlSetOnEvent(-1, "chkSuperTroops")
		GUICtrlSetState(-1, $GUI_CHECKED)

	$g_hCmbSuperTroopsResources = GUICtrlCreateCombo("", $x + 135, $y - 7, 115, 25, BitOR($CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL, $WS_VSCROLL))
		GUICtrlSetData(-1, "Prioritize dark elixir|Prioritize potion", "Prioritize dark elixir")
		GUICtrlSetOnEvent(-1, "cmbSuperTroopsResources")
	; ------------------------------------
	$y -= 17

	For $i = 0 To $iMaxSupersTroop - 1
		$g_ahLblSuperTroops[$i] = GUICtrlCreateLabel($i + 1 & ":", $x - 14, $y + 42, 50, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahCmbSuperTroops[$i] = GUICtrlCreateCombo("", $x + 1, $y + 37, 115, 25, BitOR($CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL, $WS_VSCROLL))
			GUICtrlSetData(-1, $sCmbTroopList, "Disabled")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbSuperTroops")
		$g_ahPicSuperTroops[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 125, $y + 35, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$x += 200
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#EndRegion - Custom Super Troops - Team AIO Mod++
EndFunc   ;==>CreateTrainBoost
#EndRegion - Custom - Team AIO Mod++
								
Func CreateTrainOptions()

	$g_hGUI_TRAINARMY_OPTIONS = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY_OPTIONS)

	Local $sTxtTip = ""
	Local $x = 25, $y = 22
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "Group_01", "Training Idle Time"), $x - 20, $y - 20, 171, 316)
	$g_hChkCloseWhileTraining = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWhileTraining", "Close While Training"), $x - 12, $y, 140, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWhileTraining_Info_01", "Option will exit CoC game for time required to complete TROOP training when SHIELD IS ACTIVE") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWhileTraining_Info_02", "Close for Spell creation will be enabled when 'Wait for Spells' is selected on Search tabs") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWhileTraining_Info_03", "Close for Hero healing will be enabled when 'Wait for Heroes' is enabled on Search tabs"))
	GUICtrlSetOnEvent(-1, "chkCloseWaitEnable")

	$y += 28
	$g_hChkCloseWithoutShield = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWithoutShield", "Without Shield"), $x + 18, $y + 1, 110, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWithoutShield_Info_01", "Option will ALWAYS close CoC for idle training time and when NO SHIELD IS ACTIVE!") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWithoutShield_Info_02", "Note - You can be attacked and lose trophies when this option is enabled!")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkCloseWaitTrain")
	$g_hPicCloseWaitTrain = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnNoShield, $x - 13, $y, 24, 24)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_hChkCloseEmulator = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseEmulator", "Close Emulator"), $x + 18, $y + 1, 110, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseEmulator_Info_01", "Option will close Android Emulator completely when selected") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseEmulator_Info_02", "Adding this option may increase offline time slightly due to variable times required for startup")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "btnCloseWaitStop")
	$g_hPicCloseWaitStop = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecycle, $x - 13, $y + 13, 24, 24)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_hChkSuspendComputer = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkSuspendComputer", "Suspend Computer"), $x + 18, $y + 1, 110, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkSuspendComputer_Info_01", "Option will suspend computer when selected\r\nAdding this option may increase offline time slightly due to variable times required for startup")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "btnCloseWaitSuspendComputer")
	;$g_hPicCloseWaitStop = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecycle, $x - 13, $y + 13, 24, 24)
	;_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_hChkRandomClose = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkRandomClose", "Random Close"), $x + 18, $y + 1, 110, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkRandomClose_Info_01", "Option will Randomly choose between time out, close CoC, or Close emulator when selected") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkRandomClose_Info_02", "Adding this option may increase offline time slightly due to variable times required for startup"))
	GUICtrlSetOnEvent(-1, "btnCloseWaitStopRandom")

	$y += 28
	$g_hRdoCloseWaitExact = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitExact", "Exact Time"), $x + 18, $y + 1, 110, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitExact_Info_01", "Select to wait exact time required for troops to complete training"))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "btnCloseWaitRandom")
	$g_hPicCloseWaitExact = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 13, $y + 13, 24, 24)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitExact_Info_02", "Select how much time to wait when feature enables"))

	$y += 24
	$g_hRdoCloseWaitRandom = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitRandom", "Random Time"), $x + 18, $y + 1, 110, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitRandom_Info_01", "Select to ADD a random extra wait time like human who forgets to clash"))
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "btnCloseWaitRandom")

	$y += 28
	$g_hCmbCloseWaitRdmPercent = GUICtrlCreateCombo("", $x + 36, $y, 40, 18, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "CmbCloseWaitRdmPercent_Info_01", "Enter maximum percentage of additional time to be used creating random wait times,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "CmbCloseWaitRdmPercent_Info_02", "Bot will compute a random wait time between exact time needed, and") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "CmbCloseWaitRdmPercent_Info_03", "maximum random percent entered to appear more human like")
	GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15", "10")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblCloseWaitRdmPercent = GUICtrlCreateLabel("%", $x + 84, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_hLblCloseWaitingTroops = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblCloseWaitingTroops", "Minimum Time To Close") & ": ", $x - 12, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblCloseWaitingTroops_Info_01", "Will be close CoC If train time troops ≥ (Minimum time required to close)" & @CRLF & _
			"Just stay in the main screen if train time troops < (Minimum time required to close)"))
	GUICtrlSetOnEvent(-1, "chkCloseWaitEnable")

	$y += 22
	$g_hLblSymbolWaiting = GUICtrlCreateLabel(">", $x + 26, $y + 3, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblSymbolWaiting_Info_01", "Enter number Minimum time to close in minutes for close CoC which you want, Default Is (2)")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbMinimumTimeClose = GUICtrlCreateCombo("", $x + 36, $y, 40, 18, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "2|3|4|5|6|7|8|9|10", "2")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblWaitingInMinutes = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "min.", "min."), $x + 84, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Max logout time - Team AiO MOD++
	$y += 25
	$g_hChkTrainLogoutMaxTime = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "TrainLogoutMaxTime", "Max Logout Time") & ": ", $x - 14, $y, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "TrainLogoutMaxTime_Info_01", "Only allow logout for a maximum amount of time")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkTrainLogoutMaxTime")
	$g_hTxtTrainLogoutMaxTime = _GUICtrlCreateInput("4", $x + 95, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 2)
	;GUICtrlSetBkColor(-1, 0xD1DFE7)
	$g_hLblTrainLogoutMaxTime = GUICtrlCreateLabel("min", $x + 127, $y + 4, 21, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 51
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "Group_02", "Train Click Timing"), $x - 20, $y - 20, 171, 55)
	$g_hLblTrainITDelay = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblTrainITDelay", "delay"), $x - 10, $y, 37, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblTrainITDelay_Info_01", "Increase the delay if your PC is slow or to create human like training click speed")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTrainITDelayTime = GUICtrlCreateLabel("100 ms", $x - 10, $y + 15, 37, 12)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hSldTrainITDelay = GUICtrlCreateSlider($x + 30, $y, 90, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblTrainITDelay_Info_01", -1))
	_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
	_GUICtrlSlider_SetTicFreq(-100, 100)
	GUICtrlSetLimit(-1, 500, 1) ; change max/min value
	GUICtrlSetData(-1, 100) ; default value
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetOnEvent(-1, "sldTrainITDelay")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 55 + 151
	$y = 22
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "Group_03", "Training Add Random Delay"), $x - 20, $y - 20, 195, 81)
	$y += 15
	$g_hChkTrainAddRandomDelayEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkTrainAddRandomDelayEnable", "Add Random Delay"), $x + 18, $y - 11, 130, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkTrainAddRandomDelayEnable_Info_01", "Add random delay between two calls of train army.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkTrainAddRandomDelayEnable_Info_02", "This option reduces the calls to the training window  humanizing the bot spacing calls each time with a causal interval chosen between the minimum and maximum values indicated below.")
	GUICtrlSetState(-1, $GUI_UNCHECKED) ; Custom - Team AIO Mod++
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkAddDelayIdlePhaseEnable")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDelay, $x - 13, $y - 13, 24, 24)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 18
	$y += 18
	$g_hLblAddDelayIdlePhaseBetween = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblAddDelayIdlePhaseBetween", "Between"), $x - 12, $y, 50, -1)
	$g_hTxtAddRandomDelayMin = _GUICtrlCreateInput($g_iTrainAddRandomDelayMin, $x + 32, $y - 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 999)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWaitForCastleSpell", "And"), $x + 61, $y, 20, -1)
	$g_hTxtAddRandomDelayMax = _GUICtrlCreateInput($g_iTrainAddRandomDelayMax, $x + 82, $y - 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 999)
	$g_hLblAddDelayIdlePhaseSec = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", "sec."), $x + 110, $y, 20, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$x = 206
	$y += 48
	; Buy guard - Team AIO Mod++
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "Group_07", "Shop"), $x - 20, $y - 20, 195, 50)
	$g_hChkBuyGuard = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkBuyTwoHourGuard", "Buy Two Hour Guard"), $x - 10, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkBuyTwoHourGuard_Info_01", "When you select this option, Bot will buy two hour when available.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkBuyTwoHourGuard_Info_02", "You can use this option safely as it is implmented in that way bot will not buy anything else.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkBuyTwoHourGuard_Info_03", "Note: Use Only when u know what u are doing as Two Hour Guard cost is 10 Gems."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$x = 206
	$y += 50
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "Group_05", "Advanced Options"), $x - 20, $y - 20, 195, 66)
	$g_hLblStickToTrainWindow = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Train_Troops", "LblStickToTrainWindow", "Stick to Army page when time left"), $x - 10, $y - 1)
	$g_hTxtStickToTrainWindow = _GUICtrlCreateInput("2", $x, $y + 17, 30, 20, $GUI_SS_DEFAULT_INPUT + $ES_CENTER + $ES_NUMBER)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Train_Troops", "TxtStickToTrainWindow_Info_1", "Will stick to army train page until troops or spells train finish. (Max 5 minutes)(Spell only available if wait for spell enable)")
	GUICtrlSetOnEvent(-1, "txtStickToTrainWindow")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 1)
	GUICtrlSetData(-1, 2)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Train_Troops", "TxtStickToTrainWindowMinute", "minute(s)"), $x + 35, $y + 17, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#Region - Custom Train - Team AIO Mod++
	$y += 66
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - FillIncorrectTroopCombo", "Group_MiscMod_", "Train GUI fix"), $x - 20, $y - 20, 195, 115)
	$y -= 3
		$g_hChkMMIgnoreIncorrectTroopCombo = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkIgnoreBadTroopCombo_", "Auto fix bad troop combo"), $x - 10, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "OnDoubleTrain_Info_01", "If Enabled DoubleTrain, Wont Empty Queued Troop, will Disable Precise Army"))
		GUICtrlSetOnEvent(-1, "chkOnDoubleTrain")
		GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 22
		$g_hLblFillIncorrectTroopCombo = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design - FillIncorrectTroopCombo", "Label_01", "Fill With :"), $x, $y+3, -1, -1)
		GUICtrlSetOnEvent(-1, "chkOnDoubleTrain")
		$g_hCmbFillIncorrectTroopCombo = GUICtrlCreateCombo("", $x + 50, $y, 110, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		Local $sCmbTxt 
		For $z = 0 To UBound($g_sCmbFICTroops) - 1
			$sCmbTxt &= $g_sCmbFICTroops[$z][1] & "|"
		Next
		GUICtrlSetData(-1, $sCmbTxt, "Barbarians")
	$y += 23	
		$g_hChkMMIgnoreIncorrectSpellCombo = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkIgnoreBadSpellCombo_", "Auto fix bad spell combo"), $x - 10, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "OnDoubleTrain_Info_02", "If Enabled DoubleTrain, Wont Empty Queued Spell, will Disable Precise Army"))
		GUICtrlSetOnEvent(-1, "chkOnDoubleTrain")
		GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 22
		$g_hLblFillIncorrectSpellCombo = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design - FillIncorrectSpellCombo", "Label_01", "Fill With :"), $x, $y+3, -1, -1)
		GUICtrlSetOnEvent(-1, "chkOnDoubleTrain")
		$g_hCmbFillIncorrectSpellCombo = GUICtrlCreateCombo("", $x + 50, $y, 110, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$sCmbTxt = ""
		For $z = 0 To UBound($g_sCmbFICSpells) - 1
			$sCmbTxt &= $g_sCmbFICSpells[$z][1] & "|"
		Next
		GUICtrlSetData(-1, $sCmbTxt, "Lightning Spell")
	#EndRegion - Custom Train - Team AIO Mod++
	GUICtrlCreateGroup("", -99, -99, 1, 1)
		
EndFunc   ;==>CreateTrainOptions

#REGION
Func CreateTrainTroops()
	$g_hGUI_TRAINARMY_ARMY = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY_ARMY)
	Local $iStartX = 10
	Local $iStartY = 38

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, 0, 3, 16, 16)
	GUICtrlSetOnEvent(-1, "Removecamptroops")

	$g_hCmbTroopSetting = GUICtrlCreateCombo("", 20, 2, 124, 20, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, GetTranslatedFileIni("sam m0d", 71, "Composition Army 1") & "|" & GetTranslatedFileIni("sam m0d", 72, "Composition Army 2") & "|" & GetTranslatedFileIni("sam m0d", 73, "Composition Army 3"), GetTranslatedFileIni("sam m0d", 71, "Composition Army 1"))
		GUICtrlSetOnEvent(-1, "CmbTroopSetting")

	GUICtrlCreateButton(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_01_STab_02", "Quick Train"), 300, 3, 65, 20, $SS_LEFT)
	GUICtrlSetOnEvent(-1, "ShowQuickTrain")

	Local $x = $iStartX, $y = $iStartY
	Local $iCol = 0

	; Create translated list of Troops for combo box
	Local $sComboData = "1"
	For $j = 1 To $eTroopCount - 1
		$sComboData &= "|" & String($j + 1)
	Next

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Train_Troops", "grpTroops", "Troops"), $x - 10, $y - 15, 430, 345)
	Local $sTroopName = ""
	For $i = 0 To $eTroopCount - 1
		$sTroopName = GetTroopName($i, 2)
		GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickTroopIcon[$i], $x, $y, 23, 23)
		; _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", "Level") & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", "Mouse Left Click to Up level" & @CRLF & "Shift + Mouse Left Click to Down level"))
		; GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		; GUICtrlCreateLabel(GetTroopName($i, 1, True), $x + 26, $y, -1, -1)
		$g_ahTxtTrainArmyTroopCount[$i] = _GUICtrlCreateInput("0", $x + 65 - 35, $y, 25, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOf", "Enter the No. of") & " " & $sTroopName)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")
		; $g_ahCmbTroopOrder[$i] = GUICtrlCreateCombo("", $x + 65 - 38, $y, 37, 20, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
		$g_ahCmbTroopOrder[$i] = GUICtrlCreateCombo("", $x + 95 - 38, $y, 36, 23, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sComboData)
			_GUICtrlComboBox_SetCurSel(-1, $i)
			GUICtrlSetOnEvent(-1, "_GUITrainOrder")
		$y += 26

		$iCol += 1
		If $iCol = 10 Then
			$iCol = 0
			$x += 100
			$y = $iStartY
		EndIf
	Next

	$y += 49 - 30
	$x = $iStartX + 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x + 321, $y + 13, 16, 16)
		GUICtrlSetOnEvent(-1, "BtnRemoveTroops")
	$g_hChkCustomTrainOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Order", "Order") , $x + 341, $y + 10, -1, -1)
			GUICtrlSetOnEvent(-1, "CustomTrainOrderEnable")
	$x = 170

	; troop count
	#cs
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopsCost, $x, $y + 10, 24, 24)
	$g_hLblTotalTimeCamp = GUICtrlCreateLabel(" 0s", $x + 28, $y + 15, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$g_hLblElixirCostCamp = GUICtrlCreateLabel(" 0", $x + 103, $y + 15, 77, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 101, $y + 14, 16, 16)
	$g_hLblDarkCostCamp = GUICtrlCreateLabel(" 0", $x + 185, $y + 15, 62, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 183, $y + 14, 16, 16)
	#ce
	$x = $iStartX
	$y += 26
	$g_hCalTotalTroops = GUICtrlCreateProgress($iStartX, $iStartY + 273 - 8, 336 + 8, 10)

	; Joke?
	; $g_hLblTotalProgress = GUICtrlCreateLabel("", $x, $y + 9, 336, 10)
	; GUICtrlSetBkColor(-1, 0x06B025)
	; GUICtrlSetState(-1, BitOR($GUI_DISABLE, $GUI_HIDE))

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblCountTotal", "Total"), $x + 341, $y + 7, -1, -1)
	$g_hLblCountTotal = GUICtrlCreateLabel(0, $x + 368, $y + 7, 30, 15, $SS_CENTER)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblCountTotal_Info_01", "The total Units of Troops should equal Total Army Camps."))
	GUICtrlSetBkColor(-1, $_COLOR_MONEYGREEN) ;lime, moneygreen
	GUICtrlCreateLabel("x", $x + 400, $y + 7, -1, -1)

	$y += 25
	$g_hChkTotalCampForced = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkTotalCampForced", "Force Army Camp") & ":", $x + 10, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "chkTotalCampForced")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkTotalCampForced_Info_01", "If not detected set army camp values (instead ask)"))
	$g_hTxtTotalCampForced = _GUICtrlCreateInput("300", $x + 170, $y + 3, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetOnEvent(-1, "SetComboTroopComp")
	GUICtrlSetLimit(-1, 3)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblFullTroop", "'Full' Camp") & " " & ChrW(8805), $x + 100 + 170 - 20, $y + 5, 70, 17, $SS_RIGHT)
	$g_hTxtFullTroop = _GUICtrlCreateInput("100", $x + 100 + 242 - 20, $y + 3, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetOnEvent(-1, "SetComboTroopComp")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtFullTroop_Info_01", "Army camps are 'Full' when reaching this %, then start attack."))
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateLabel("%", $x + 100 + 273 - 20, $y + 5, -1, 17)

	$y += 25
	$g_hChkPreciseArmy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkPreciseArmy", "Precise Army"), $x + 10, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Precise ArmyTip", "Always check and remove wrong troops or spells exist in army"))

	$g_hChkDoubleTrain = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkDoubleTrain", "Double Train"), $x + 110, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkDoubleTrain") ; Custom train - Team AIO Mod++
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip", "Train 2nd set of Troops & Spells after training 1st combo") & @CRLF & _
			GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip1", "Make sure to enter exactly the 'Total Camp',") & @CRLF & _
			GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip2", "'Total Spell' and number of Troops/Spells in your Setting") & @CRLF & _
			GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip3", "Note: Donations + Double Train can produce an unbalanced army!"))

	#Region - Custom train - Team AIO Mod++
	$g_hChkPreTrainTroopsPercent = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkDoubleTrainIf", "Double if") & " " & ChrW(8805), $x + 250, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkDoubleTrain") ; Custom train - Team AIO Mod++
	
	$g_hChkTrainBeforeAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkTrainBeforeAttack", "If full army pre train"), $x + 250, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkDoubleTrain") ; Custom train - Team AIO Mod++

	$g_hInpPreTrainTroopsPercent = _GUICtrlCreateInput("100", $x + 322, $y, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetOnEvent(-1, "ChkDoubleTrain") ; Custom train - Team AIO Mod++
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtDoubleTrainIf_Info_01", "Only double train when reaching this %."))
			GUICtrlSetLimit(-1, 3)
	$g_hLblPreTrainTroopsPercent = GUICtrlCreateLabel("%", $x + 353, $y + 2, -1, 17)
	#EndRegion - Custom train - Team AIO Mod++

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateTrainTroops

Func CreateTrainSpells()
	$g_hGUI_SPELLARMY_ARMY = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_SPELLARMY_ARMY)
	Local $iStartX = 10
	Local $iStartY = 38

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "SpellCapacity", "Spell Capacity") & ":", 10 + 288, 12 - 5, 90, 17, $SS_RIGHT)
	$g_hTxtTotalCountSpell = GUICtrlCreateCombo("", 10 + 380, 12 + 1 - 10, 35, 16, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtTotalCountSpell_Info_01", "Enter the No. of Spells Capacity."))
	GUICtrlSetData(-1, "0|2|4|6|7|8|9|10|11", "0")
	GUICtrlSetOnEvent(-1, "TotalSpellCountClick")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, 0, 3, 16, 16)
	GUICtrlSetOnEvent(-1, "Removecampspells")

	$g_hChkPreciseSpells = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkPreciseBrew", "Precise brew") , 10 + 50, 3)
	$g_hChkForcePreBrewSpells = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkForcePreBrewSpells", "Force pre brew spells") , 10 + 150, 3)

	Local $x = $iStartX, $y = $iStartY
	Local $iCol = 0

	; Create translated list of Troops for combo box
	Local $sComboData = "1"
	For $j = 1 To UBound($g_aQuickSpellIcon) - 1
		$sComboData &= "|" & String($j + 1)
	Next

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Train_Spells", "grpSpells", "Spells"), $x - 10, $y - 15, 430, 203)
	$x += 70
	Local $sSpellName = ""
	For $i = 0 To UBound($g_aQuickSpellIcon) - 1
		$sSpellName = GetTroopName($i + $eLSpell, 2)
		GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickSpellIcon[$i], $x, $y, 23, 23)
		$g_ahTxtTrainArmySpellCount[$i] = _GUICtrlCreateInput("0", $x + 65 - 35, $y, 25, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOfS", "Enter the No. of") & " " & $sSpellName)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")
		$g_ahCmbSpellsOrder[$i] = GUICtrlCreateCombo("", $x + 95 - 38, $y, 36, 23, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sComboData)
			_GUICtrlComboBox_SetCurSel(-1, $i)
			GUICtrlSetOnEvent(-1, "_GUISpellsOrder")
		$g_ahChkSpellsPre[$i] = GUICtrlCreateCheckbox("Pre. " & StringLeft($sSpellName, 1) & ".", $x + 97, $y - 1, 50, 23)
		$y += 26
		$iCol += 1
		If $iCol = Round(UBound($g_aQuickSpellIcon) / 2) Then
			$iCol = 0
			$x += 150
			$y = $iStartY
		EndIf
	Next

	$y += 150
	$x = $iStartX

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x, $y + 17, 16, 16)
		GUICtrlSetOnEvent(-1, "BtnRemoveSpells")
	$g_hChkCustomBrewOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Order", "Order") , $x + 20, $y + 14, -1, -1)
		GUICtrlSetOnEvent(-1, "CustomBrewOrderEnable")

	$x += 70
	#cs
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellsCost, $x + 4, $y + 10, 24, 24)
	$g_hLblTotalTimeSpell = GUICtrlCreateLabel(" 0s", $x + 33, $y + 15, 55, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$g_hLblElixirCostSpell = GUICtrlCreateLabel(" 0", $x + 93, $y + 15, 77, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 91, $y + 14, 16, 16)
	$g_hLblDarkCostSpell = GUICtrlCreateLabel(" 0", $x + 175, $y + 15, 62, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 173, $y + 14, 16, 16)
	#ce
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateTrainTroops

Func CreateTrainSieges()
	$g_hGUI_SIEGEARMY_ARMY = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_SIEGEARMY_ARMY)
	Local $iStartX = 10
	Local $iStartY = 38

    GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "SiegeCapacity", "Siege Capacity") & ":", 10 + 288, 12 - 5, 90, 17, $SS_RIGHT)
    $g_hTxtTotalCountSiege = _GUICtrlCreateInput("3", 10 + 380, 4, 35, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
    _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtTotalCountSpell_Info_01", "Enter the No. of Sieges Capacity."))

    _GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, 0, 3, 16, 16)
    GUICtrlSetOnEvent(-1, "Removecampsieges")
    
    ; $g_hChkPreciseSieges = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkPreciseBuild", "Precise build") , 10 + 50, 3)
    $g_hChkForcePreBuildSieges = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkForcePreBuildSieges", "Force pre build sieges") , 10 + 150, 3)

	Local $x = $iStartX, $y = $iStartY
	Local $iCol = 0

	; Create translated list of Troops for combo box
	Local $sComboData = "1"
	For $j = 1 To UBound($g_ahPicTrainArmySiege) - 1
		$sComboData &= "|" & String($j + 1)
	Next

	Local $sSiegeName = ""
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Train_Sieges", "grpSieges", "Sieges"), $x - 10, $y - 15, 430, 203)
	$x += 70
	For $i = 0 To $eSiegeMachineCount - 1
		$sSiegeName = GetTroopName($i + $eWallW, 2)
		GUICtrlCreateIcon($g_sLibIconPath, $g_ahPicTrainArmySiege[$i], $x, $y, 23, 23)
		$g_ahTxtTrainArmySiegeCount[$i] = _GUICtrlCreateInput("0", $x + 65 - 35, $y, 25, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("sam m0d", "txtNoOfSg", "Enter the No. of") & " " & $sSiegeName)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")
		$g_ahCmbSiegesOrder[$i] = GUICtrlCreateCombo("", $x + 95 - 38, $y, 36, 23, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sComboData)
			_GUICtrlComboBox_SetCurSel(-1, $i)
			GUICtrlSetOnEvent(-1, "_GUIBuildOrder")
		$y += 26
		$iCol += 1
		If $iCol = Round($eSiegeMachineCount / 2) Then
			$iCol = 0
			$x += 150
			$y = $iStartY
		EndIf
	Next

	$y += 150
	$x = $iStartX
	
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x, $y + 17, 16, 16)
		GUICtrlSetOnEvent(-1, "BtnRemoveSieges")
	$g_hChkCustomBuildOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Order", "Order") , $x + 20, $y + 14, -1, -1)
		GUICtrlSetOnEvent(-1, "CustomBuildOrderEnable")

	$y -= 50

	#cs
	$y += 100
	$x = $iStartX
	$x += 70
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSiegeCost, $x + 3, $y + 5, 24, 24)
	$g_hLblTotalTimeSiege = GUICtrlCreateLabel(" 0s", $x + 33, $y + 10, 55, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$g_hLblGoldCostSiege = GUICtrlCreateLabel(" 0", $x + 93, $y + 10, 77, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 91, $y + 9, 16, 16)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblCountTotal", "Total"), $x + 173, $y + 10, -1, -1)
	$g_hLblCountTotalSiege = GUICtrlCreateLabel(0, $x + 200, $y + 10, 30, 15, $SS_CENTER)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblCountTotal_Info_02", "The total units of Siege Machines"))
	GUICtrlSetBkColor(-1, $_COLOR_MONEYGREEN) ;lime, moneygreen
	GUICtrlCreateLabel("x", $x + 232, $y + 10, -1, -1)
	#ce
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")
	
	; Custom pets - Team AIO Mod++
	Local $sTxtHeroesNames = GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any") & "|" & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Barbarian King", "Barbarian King") & "|" & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Archer Queen", "Archer Queen") & "|" & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Grand Warden", "Grand Warden") & "|" & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Royal Champion", "Royal Champion")
	$x = $iStartX - 10
	$y += 90
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "Group_01", "Pet Attack options"), $x, $y, 430, 95)
	$g_hChkPetHouseSelector = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "CheckBox_01", "Link each heroes to their Pets:"), $x + 5, $y + 13, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkPetHouseSelector")
	$y += 35
	$g_hLblLassiHero = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Pet Troops", "TxtLassi", "L.A.S.S.I") & ":", $x + 6, $y + 5, 100, -1)
	$g_hCmbLassiPet = GUICtrlCreateCombo("", $x + 70, $y + 2, 120, 25, $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL) ; DONT use BitOR, this one doesn't work for that.
	GUICtrlSetData(-1, $sTxtHeroesNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "KingPet_Info_01", "Select which hero to link with L.A.S.S.I") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "KingPet_Info_02", "The hero icon will appear on the right."))
	GUICtrlSetOnEvent(-1, "cmbPetSelector")
	$x += 220
	$g_hLblElectroOwlHero = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Pet Troops", "TxtElectroOwl", "Electro Owl") & ":", $x + 6, $y + 5, 100, -1)
	$g_hCmbElectroOwlPet = GUICtrlCreateCombo("", $x + 70, $y + 2, 120, 25, $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL) ; DONT use BitOR, this one doesn't work for that.
	GUICtrlSetData(-1, $sTxtHeroesNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "QueenPet_Info_01", "Select which hero to link with the Electro Owl") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "QueenPet_Info_02", "The hero icon will appear on the right."))
	GUICtrlSetOnEvent(-1, "cmbPetSelector")
	$x -= 220
	$y += 30
	$g_hLblMightyYakHero = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Pet Troops", "TxtMightyYak", "Mighty Yak") & ":", $x + 6, $y + 5, 100, -1)
	$g_hCmbMightyYakPet = GUICtrlCreateCombo("", $x + 70, $y + 2, 120, 25, $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL) ; DONT use BitOR, this one doesn't work for that.
	GUICtrlSetData(-1, $sTxtHeroesNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "WardenPet_Info_01", "Select which hero to link with the Mighty Yak") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "WardenPet_Info_02", "The hero icon will appear on the right."))
	GUICtrlSetOnEvent(-1, "cmbPetSelector")
	$x += 220
	$g_hLblUnicornHero = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Pet Troops", "TxtUnicorn", "Unicorn") & ":", $x + 6, $y + 5, 100, -1)
	$g_hCmbUnicornPet = GUICtrlCreateCombo("", $x + 70, $y + 2, 120, 25, $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL) ; DONT use BitOR, this one doesn't work for that.
	GUICtrlSetData(-1, $sTxtHeroesNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "ChampionPet_Info_01", "Select which hero to link with the Unicorn") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Village - Pet_House", "ChampionPet_Info_02", "The hero icon will appear on the right."))
	GUICtrlSetOnEvent(-1, "cmbPetSelector")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateTrainTroops
#ENDREGION