; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Standard Attack" tab under the "Attack" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac(07-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DEADBASE_ATTACK_SMARTFARM = 0

Global $g_hTxtInsidePercentage = 0, $g_hTxtOutsidePercentage = 0, $g_hBtnCustomDropOrderDB1 = 0, $g_hChkDebugSmartFarm = 0, $g_hChkByPassToSmartFarm = 0

Func CreateAttackSearchDeadBaseSmartFarm()

	$g_hGUI_DEADBASE_ATTACK_SMARTFARM = _GUICreate("", $_GUI_MAIN_WIDTH - 195, $g_iSizeHGrpTab4, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DEADBASE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_DEADBASE_ATTACK_STANDARD)

	Local $sTxtTip = ""
	Local $x = 25, $y = 20
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Group_01", "Options"), $x - 20, $y - 20, 270, $g_iSizeHGrpTab4)

		#Region - Custom SmartFarm - Team AIO Mod++
		$y += 25
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-CmbStandardUnitDelay", "Delay Unit"), $x + 25, $y + 25, -1, -1)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-CmbStandardUnitDelay_Info_01", "This delays the deployment of troops, 1 (fast) = like a Bot, 10 (slow) = Like a Human.") & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-CmbStandardUnitDelay_Info_02", "Random will make bot more varied and closer to a person.")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hDeployDelay[1] = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15", "4")
				GUICtrlSetOnEvent(-1, "chkMiscModOptions")

			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Lbl-CmbStandardWaveDelay_Info_01", "Wave"), $x + 140, $y + 25, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hDeployWave[1] = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15", "4")
				GUICtrlSetOnEvent(-1, "chkMiscModOptions")

		$y += 22
			$g_hChkEnableRandom[1] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkRandomSpeedAtk", "Randomize delay for Units && Waves"), $x, $y-50, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "chkMiscModOptions")

		$y += 20
		$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "RandomDP_01", "Random drop point deployment in the line.")
		$g_hChkSmartFarmAndRandomDeploy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "RandomDP_02", "Random drop points along line."), $x, $y, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
				; GUICtrlSetOnEvent(-1, "UseSmartFarmAndRandomDeploy")

		$y += 20
		$g_hChkSmartFarmAndRandomQuant = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkSmartFarmAndRandomQuant", "Use Random Troops Quant by side"), $x, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkSmartFarmAndRandomDeploy_Info_03", "Will random deploy quantities each side from Barb, Arch, Wiza, Mini and Gobl"))
		GUICtrlSetOnEvent(-1, "chkUseSmartFarmAndRandomQuant")
		$y += 20
		$g_hChkUseSmartFarmRedLine = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkUseSmartFarmRedLine", "Smart RedLines"), $x, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkUseSmartFarmRedLine_Info_01", "Will not use Edges points to deploy. Will use Green Tiles"))
		GUICtrlSetOnEvent(-1, "CheckUseSmartFarmRedLine")
		$y += 20
		$g_hSmartFarmSpellsEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkSmartFarmSpellsEnable", "Use Rage/Heal Spells"), $x, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkSmartFarmSpellsEnable_info_01", "Will deploy Rage or/and Heal Spells when is available."))
		GUICtrlSetOnEvent(-1, "ChkSmartFarmSpellsEnable")
		$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-ChkSmartFarmSpellsEnable", "How Many Sides") & ":", $x + 5, $y + 5, -1, -1)
		$g_hCmbSmartFarmSpellsHowManySides = GUICtrlCreateCombo("", $x + 95, $y + 1, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkSmartFarmSpellsEnable_info_02", "Deploy Spells when is to attack in 1 or 2 side(s)."))
		GUICtrlSetData(-1, "1|2", "1")
		GUICtrlSetOnEvent(-1, "cmbHowManySidesSpells")
		$y += 25
		$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "HumaneSides", "Set a limit for places, the minimum limit is random.")
		$g_hMaxSidesSF = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "MaxSidesSM", "Max sides to attack") & ":", $x, $y, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "chkMaxSidesSF")
		$g_hCmbMaxSidesSF = GUICtrlCreateCombo("", $x + 140, $y, 40, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "1|2|3|4", "4")
			GUICtrlSetOnEvent(-1, "chkMaxSidesSF")
		#EndRegion - Custom SmartFarm - Team AIO Mod++

		$y += 40
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-TxtInsidePercentage", "Inside resources") & ":", $x, $y + 2, -1, -1)
			$g_hTxtInsidePercentage = _GUICtrlCreateInput("65" , $x + 140, $y , 25 , -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "txt-TxtInsidePercentage", "Percentage to force attack in one side only"))
			GUICtrlCreateLabel("%" , $x + 117 , $y + 3)
		$y += 22
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-TxtOutsidePercentage", "Outside resources") & ":", $x, $y + 2, -1, -1)
			$g_hTxtOutsidePercentage = _GUICtrlCreateInput("80" , $x + 140 , $y , 25 , -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "txt-TxtOutsidePercentage", "Percentage to force attack in 4 sides"))
			GUICtrlCreateLabel("%" , $x + 117 , $y + 3)
		$y += 25
		$x = 98
			$g_hBtnCustomDropOrderDB1 = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnCustomDropOrder", -1), $x, $y, 85, 25)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnCustomDropOrder_Info_01", -1))
				GUICtrlSetOnEvent(-1, "CustomDropOrder")
		$x = 35
			$g_hChkDebugSmartFarm = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkDebugSmartFarm", "Debug Smart Farm"), $x, $y + 100, -1, -1)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchDeadBaseStandard

#Region - SmartMilk
Global $g_hgui_deadbase_attack_smartmilk = 0
Global $g_hcmbmilkstrategyarmy = 0, $g_hchkdebugsmartmilk = 0, $g_hchkmilkforcedeployheroes = 0, $g_hchkmilkforcealltroops = 0, $g_hchkmilkforceth = 0, $g_hcmbmilkdelays = 0
Global $g_hicnmilk[10] = [$eicnbabydragon, $eicnbarbarian, $eicnarcher, $eicngiant, $eicngoblin, $eicnminion, $eIcnSuperMinion, $eIcnSuperBarbarian, $eIcnSneakyGoblin, $eIcnMiner], $g_ahpicmilk = 0

Func createattacksearchdeadbasesmartmilk()
	$g_hgui_deadbase_attack_smartmilk = _guicreate("", $_gui_main_width - 195, $g_isizehgrptab4, 150, 25, BitOR($ws_child, $ws_tabstop), -1, $g_hgui_deadbase)
	Local $stxttip = "You can use, Barbarians, Archers, Giants, Goblins, Minions, Super Minions, " & @CRLF & " Baby Dragons, Super Barbarians, Sneak Goblins, Miners and Super Wall Breakers"
	Local $x = 35, $y = 20
	GUICtrlCreateGroup(gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Milk", "Group_01", "Options"), $x - 30, $y - 20, 270, $g_isizehgrptab4)
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Milk", "Lbl-CmbMilkStrategyArmy", "Army Composition Strategy") & ":", $x, $y + 5, -1, -1)
	$g_ahpicmilk = _guictrlcreateicon($g_slibiconpath, $g_hicnmilk[$g_imilkstrategyarmy], $x, $y + 20, 32, 32)
	$g_hcmbmilkstrategyarmy = GUICtrlCreateCombo("", $x + 40, $y + 25, 150, 21, BitOR($cbs_dropdownlist, $cbs_autohscroll))
	_guictrlsettip(-1, $stxttip)
	GUICtrlSetData(-1, "Full Baby Dragons|Full Barbs|Full Archs|Gibarch|Full Goblins|Full Minions|Full Super Minions|Full Super Barbarians|Full Sneaky Goblins|Full Miners", "Baby Dragons")
	GUICtrlSetOnEvent(-1, "CmbMilkStrategyArmy")
	$y += 60
	$g_hchkmilkforcedeployheroes = GUICtrlCreateCheckbox(gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Milk", "ChkMilkForceDeployHeroes", "Force to Deploy Heroes/CC"), $x + 40, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "MilkForceDeployHeroes")
	$g_hchkmilkforcealltroops = GUICtrlCreateCheckbox(gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Milk", "ChkMilkForceAllTroops", "Force to Deploy All Troops"), $x + 40, $y + 25, -1, -1)
	GUICtrlSetOnEvent(-1, "MilkForceDeployHeroes")
	$g_hchkmilkforceth = GUICtrlCreateCheckbox(gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Milk", "ChkMilkForceTH", "Force TH detection"), $x + 40, $y + 25 + 25, -1, -1)
	_guictrlsettip(-1, gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Farm", "ChkMilkForceTH_Info_01", "Forcing TH detection, Town Hall sniping."))
	GUICtrlSetOnEvent(-1, "MilkForceTH")
	GUICtrlCreateLabel(gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Milk", "Lbl-CmbMilkDelay", "Speed Control") & ":", $x + 40, $y + 25 + 25 + 25, -1, -1)
	_guictrlsettip(-1, gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Milk", "ChkMilkDelay_info_01", "Make the Script Faster or Slower! 0-Faster, 10-Slower"))
	$g_hcmbmilkdelays = GUICtrlCreateCombo("", $x + 45, $y + 25 + 25 + 25 + 20, 50, 21, BitOR($cbs_dropdownlist, $cbs_autohscroll))
	_guictrlsettip(-1, gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Milk", "ChkMilkDelay_info_01", "Make the Script Faster or Slower! 0-Faster, 10-Slower"))
	GUICtrlSetData(-1, "00|01|02|03|04|05|06|07|08|09|10", "03")
	GUICtrlSetOnEvent(-1, "CmbMilkDelay")
	$g_hchkdebugsmartmilk = GUICtrlCreateCheckbox(gettranslatedfileini("MBR GUI Design Child Attack - Attack Smart Milk", "ChkDebugSmartMilk", "Debug Smart Milk"), $x, $g_isizehgrptab4 - 30, -1, -1)
	GUICtrlSetOnEvent(-1, "DebugSmartAttacks")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
#EndRegion - SmartMilk
