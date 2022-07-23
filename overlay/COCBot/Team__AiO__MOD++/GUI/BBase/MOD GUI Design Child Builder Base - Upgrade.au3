; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Train Army" tab under the "Builder Base" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac (03-2018), CodeSlinger69 (2017), Chilly-Chill (2019), Team AIO Mod++/xbebenk (2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkBBSuggestedUpgrades = 0, $g_hChkBBSuggestedUpgradesIgnoreGold = 0, $g_hChkBBSuggestedUpgradesIgnoreElixir
Global $g_hRadioBBUpgradesToIgnore = 0, $g_hRadioBBCustomOTTO = 0 ; xbebenk
Global $g_hChkPlacingNewBuildings = 0, $g_hChkUpgradeTroops = 0, $g_hChkUpgradeMachine = 0, $g_hChkBBNextUpgradeRepeat = 0
Global $g_hChkBBUpgradeWalls = 0, $g_hLblBBWallLevelInfo = 0, $g_hLblBBWallNumberInfo = 0, $g_hCmbBBWallLevel = 0, $g_hPicBBWallUpgrade = "", $g_hBBWallNumber = 0, $g_hLblBBWallCostInfo = 0, $g_hLblBBWallCost = 0
Global $g_hChkBBWallRing = 0, $g_hChkBBUpgWallsGold = 0, $g_hChkBBUpgWallsElixir = 0
Global $g_hbtnBBAttack = 0
Global $g_hDebugBBattack = 0;, $g_hLblBBNextUpgrade = 0, $g_hCmbBBLaboratory = 0, $g_hPicBBLabUpgrade = ""
Global $g_hChkAutoStarLabUpgrades = 0, $g_hCmbStarLaboratory = 0, $g_hLblNextSLUpgrade = 0, $g_hBtnResetStarLabUpgradeTime = 0, $g_hPicStarLabUpgrade = 0
Global $g_hBtnBBUpgradeOrderGUI ; xbebenk mod.
Global $g_hGUI_BBUpgradeOrder, $g_hGUI_BBUpgradeOrderClose

Func CreateUpgradeBuilderBaseSubTab()
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "Group_01", "Buildings Upgrades"), $x - 10, $y - 20, $g_iSizeWGrpTab2, 230)
    _GUICtrlCreatePic($g_sIcnMBisland, $x , $y , 64, 64)
	$g_hChkBBSuggestedUpgrades = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgrades", "Suggested Upgrades"), $x + 65, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgrades")
	$g_hChkPlacingNewBuildings = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkPlacingNewBuildings", "Build 'New' tagged buildings"), $x + 195, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkPlacingNewBuildings")
	$g_hChkBBSuggestedUpgradesIgnoreGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_01", "Ignore Gold Upgrades"), $x + 65, $y + 20, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesGold")
	$g_hChkBBSuggestedUpgradesIgnoreElixir = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_02", "Ignore Elixir Upgrades"), $x + 195, $y + 20, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesElixir")
	$g_hRadioBBUpgradesToIgnore = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Radio_01", "Upgrades to ignore"), $x + 80, $y + 43, -1, -1)
	GUICtrlSetOnEvent(-1, "RadioIgnoreUpgradesBBOrOtto")
	$g_hRadioBBCustomOTTO = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Radio_02", "Optimize O.T.T.O."), $x + 200, $y + 43, -1, -1) ; xbebenk
	GUICtrlSetOnEvent(-1, "RadioIgnoreUpgradesBBOrOtto")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_05", "Optimize OTTO, will only upgrade suggested on OTTO Upgrade.\r\nSuch: Archer Tower, DoubleCannon, MultiMortar, Mega Tesla and Battle Machine"))
	$x = 20
	$y += 60

	Local $iCol = 0
	For $i = 0 To UBound($g_hChkBBUpgradesToIgnore) -1
		$iCol += 1
		
		$g_hChkBBUpgradesToIgnore[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design Names Buildings", $g_sBBUpgradesToIgnore[$i], $g_sBBUpgradesToIgnore[$i]), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkIgnoreUpgradesBB")
		
		If Mod($iCol, 4) = 0 Then
			$x = 20
			$y += 20
		Else
			$x += 100
		EndIf
	Next

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$x = 15
	$y = 45 + 100 + 130

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "Group_02", "Troops Upgrade"), $x - 10, $y - 20, $g_iSizeWGrpTab2, 90)
	Local $sTxtSLNames = GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtRagedBarbarian", "Raged Barbarian") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtSneakyArcher", "Sneaky Archer") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBoxerGiant", "Boxer Giant") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBetaMinion", "Beta Minion") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBomber", "Bomber") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBabyDragon", "Baby Dragon") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtCannonCart", "Cannon Cart") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtNightWitch", "Night Witch") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtDropShip", "Drop Ship") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtSuperPekka", "Super Pekka") & "|" & _
					   GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtHogGlider", "Hog Glider")
		
	; _GUICtrlCreateIcon($g_sLibIconPath, $eIcnStarLaboratory, $x, $y, 64, 64)
	$g_hChkAutoStarLabUpgrades = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoStarLabUpgrades", "Auto Star Laboratory Upgrades"), $x + 80 + 105, $y + 12, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoStarLabUpgrades_Info_01", "Check box to enable automatically starting Upgrades in star laboratory"))
	GUICtrlSetOnEvent(-1, "chkStarLab")
	; $g_hLblNextSLUpgrade = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "LblNextUpgrade", "Next one") & ":", $x + 80, $y + 38, 50, -1)
	; GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hCmbStarLaboratory = GUICtrlCreateCombo("", $x + 190, $y + 37, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, $sTxtSLNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "CmbLaboratory_Info_01", "Select the troop type to upgrade with this pull down menu") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "CmbLaboratory_Info_02", "The troop icon will appear on the right."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbStarLab")

	$x += 271
	$g_hBtnBBUpgradeOrderGUI = GUICtrlCreateButton ("Ord.", $x, $y + 36, 40, 25)
	GUICtrlSetOnEvent(-1, "BBUpgradeOrder")
	$x -= 271
	
	; Red button, will show on upgrade in progress. Temp unhide here and in Func ChkLab() if GUI needs editing.
	$g_hBtnResetStarLabUpgradeTime = GUICtrlCreateButton("", $x + 120 + 172, $y + 36, 18, 18, BitOR($BS_PUSHLIKE,$BS_DEFPUSHBUTTON))
	GUICtrlSetBkColor(-1, $COLOR_ERROR)
	;_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnRedLight)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE) ; comment this line out to edit GUI
	GUICtrlSetOnEvent(-1, "ResetStarLabUpgradeTime")
	$g_hPicStarLabUpgrade = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330 + 31, $y, 64, 64)
	GUICtrlSetState(-1, $GUI_HIDE)


	_GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnMachine, $x, $y + 3, 48, 48)
	$g_hChkUpgradeMachine = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "ChkUpgradeMachine", "Upgrade Machine"), $x + 63, $y + 12, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "ChkUpgradeMachine_Info_01", "Prioritize the Machine upgrades if 'Any' was selected."))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 15
	$y = 45 + 100 + 105 + 115
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "Group_03", "Upgrade Walls"), $x - 10, $y - 20, $g_iSizeWGrpTab2, 90)
	_GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBWallInfo, $x, $y + 5, 48, 48)
	$g_hChkBBUpgradeWalls = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "ChkBBUpgradeWalls", "Upgrade Walls"), $x + 60, $y - 5, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkBBWalls")
	$g_hLblBBWallLevelInfo = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "LblBBWallLevelInfo", "Search for Walls Level") & ":", $x + 70, $y + 21, 120, -1)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hCmbBBWallLevel = GUICtrlCreateCombo("", $x + 185, $y + 18, 50, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, "1|2|3|4|5|6|7|8", GetTranslatedFileIni("MBR Global GUI Design", "Level1", "1"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "CmbBBWallLevel_Info_01", "Select the wall level to upgrade with this pull down menu") & @CRLF & GetTranslatedFileIni("MMBR GUI Design Child Builder Base - Upgrade", "CmbBBWallLevel_Info_02", "The wall icon will appear below."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbBBWall")
	$g_hLblBBWallCostInfo = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "LblBBNextWalllevelcosts", "Next Wall level costs") & ":", $x + 70, $y + 46, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "LblBBNextWalllevelcosts_Info_01", "Use this value as an indicator.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "LblBBNextWalllevelcosts_Info_02", "The value will update if you select an other wall level."))
	$g_hLblBBWallCost = GUICtrlCreateLabel("10 000", $x + 175, $y + 46, 50, -1, $SS_RIGHT)
	$g_hLblBBWallNumberInfo = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "LblBBWallNumberInfo", "Wall Counter") & ":", $x + 315, $y + 34, 80, -1)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hBBWallNumber = _GUICtrlCreateInput("0", $x + 385, $y + 30, 40, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicBBWallUpgrade = _GUICtrlCreateIcon($g_sLibBBIconPath, 11, $x + 260, $y + 20, 48, 48)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hChkBBWallRing = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "ChkBBUpgradeWalls_Info_01", "Use Wall Rings"), $x + 180, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "ChkBBUpgradeWalls_Info_02", "Check this box to use Wall Ring to upgrade BB walls."))
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hChkBBUpgWallsGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "ChkBBUpgradeWalls_Info_03", "Use Gold"), $x + 280, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "ChkBBUpgradeWalls_Info_04", "Check this box to use Gold to upgrade BB walls."))
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hChkBBUpgWallsElixir = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "ChkBBUpgradeWalls_Info_05", "Use Elixir"), $x + 350, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Upgrade", "ChkBBUpgradeWalls_Info_06", "Check this box to use Elixir to upgrade BB walls."))
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateUpgradeBuilderBaseSubTab 

Func CreateBBUpgradeOrderGUI()
	$g_hGUI_BBUpgradeOrder = _GUICreate(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "GUISLabUpgradeOrder", "Enable upgrade order."), 444, 240, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)

	Local $sTxtSLNames = $g_avStarLabTroops[0][3]
	For $i = 1 To UBound($g_avStarLabTroops) -1
		$sTxtSLNames &= "|" & $g_avStarLabTroops[$i][3]
	Next

	Local $x = 0, $y = 8
		
	GUICtrlCreateGroup("BB Custom upgrade order.", 8, $y, 425, 164)
	$y += 16
	
	;Enable StarLab Upgrade Order
	$g_hChkSLabUpgradeOrder = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkSLabUpgradeOrder", "Enable StarLab Upgrades Order"), 16, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoLabUpgrades_Info_04_Star", "Check box to enable Upgrades Order in Star laboratory"))
		GUICtrlSetOnEvent(-1, "chkSLabUpgradeOrder")

	; Create translated list of Troops for combo box
	Local $sSComboData = ""
	$sSComboData = StringTrimLeft($sTxtSLNames, 4); trim "Any," from list

	; Create ComboBox(es) for selection of troop training order
	$x += 36
	$y += 44
	For $z = 0 To UBound($g_ahCmbSLabUpgradeOrder) - 1
		If $z < 3 Then
			GUICtrlCreateLabel($z + 1 & ":", $x - 16, $y + 2, -1, 18)
			$g_ahCmbSLabUpgradeOrder[$z] = GUICtrlCreateCombo("", $x, $y, 110, 18, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "cmbSLabUpgradeOrder")
			GUICtrlSetData(-1, $sSComboData, "")
			GUICtrlSetState(-1, $GUI_DISABLE)
			$y += 22 ; move down to next combobox location
		ElseIf $z > 2 And $z < 7 Then
			If $z = 3 Then
				$x += 141
				$y -= 66
			EndIf
			GUICtrlCreateLabel($z + 1 & ":", $x - 13, $y + 2, -1, 18)
			$g_ahCmbSLabUpgradeOrder[$z] = GUICtrlCreateCombo("", $x + 4, $y, 110, 18, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "cmbSLabUpgradeOrder")
			GUICtrlSetData(-1, $sSComboData, "")
			GUICtrlSetState(-1, $GUI_DISABLE)
			$y += 22 ; move down to next combobox location
		EndIf
	Next
	
	$x += 140
	$y -= 24
	$y -= 34
	$g_hBtnRemoveSLabUpgradeOrder = GUICtrlCreateButton("Clear List", $x - 6, $y, 96, 20)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	GUICtrlSetOnEvent(-1, "btnRemoveSLabUpgradeOrder")

	$y += 25
	$g_hBtnSetSLabUpgradeOrder = GUICtrlCreateButton("Apply Order", $x - 6, $y, 96, 20)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	GUICtrlSetOnEvent(-1, "btnSetSLabUpgradeOrder")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 34
	$y += 50

	$g_hGUI_BBUpgradeOrderClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrderClose", "Close"), 344, $y, 65, 25)
	GUICtrlSetOnEvent(-1, "BBUpgradeOrderClose")

EndFunc

