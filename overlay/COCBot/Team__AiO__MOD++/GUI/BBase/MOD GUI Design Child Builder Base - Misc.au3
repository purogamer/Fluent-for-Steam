; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Train Army" tab under the "Builder Base" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac (03-2018)
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2015-2018
;                  MultiBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_alblBldBaseStats[4] = ["", "", "", ""]
Global $g_hNextBBAttack = 0
Global $g_hChkCollectBuilderBase = 0, $g_hChkStartClockTowerPotion = 0
Global $g_hChkCollectBldGE = 0, $g_hChkCollectBldGems = 0, $g_hChkActivateClockTower = 0, $g_hChkCleanBBYard = 0
Global $g_hBtnBBAtkLogClear = 0,$g_hBtnBBAtkLogCopyClipboard=0

Global $g_hTxtBBMinAttack, $g_hTxtBBMaxAttack, $g_hDebugBBattack, $g_hbtnBBAttack ; AIO ++

Global $g_hChkStartClockTowerBoost = 0, $g_hCmbStartClockTowerBoost = 0, $g_hChkClockTowerPotion = 0, $g_hCmbClockTowerPotion = 0 ; AIO ++

Global $g_sTranslateBBTower = ""

Global $g_hChkDSICGBB = 0

Func TowerBoostTranslate()
	Local $sTranslateBBTower = ""
	$sTranslateBBTower = GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "CmbStartClockTowerBoostLabORBuilderbs", "Lab OR builder busy.") & "|" & _ ; Snorlax
	GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "CmbStartClockTowerBoostLabANDBuilderbs", "Lab AND builder busy.") & "|" & _
	GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "CmbStartClockTowerBoostBuilder", "Builder active") & "|" & _
	GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "CmbStartClockTowerBoostLab", "Lab active")
	
	$g_sTranslateBBTower = $sTranslateBBTower
EndFunc

Func CreateMiscBuilderBaseSubTab()
	Local $x = 15, $y = 45
	
	TowerBoostTranslate()
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "Group_01", "Collect && Activate"), $x - 10, $y - 20, $g_iSizeWGrpTab2, 125)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldMineL5, $x + 7, $y - 5, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixirCollectorL5, $x + 32, $y - 5, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGemMine, $x + 57, $y - 5, 24, 24)
		$g_hChkCollectBuilderBase = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCollectBuilderBase", "Collect Resources"), $x + 100, $y - 1, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCollectBuilderBase_Info_01", "Check this to collect Resources on the Builder Base"))

	$y += 22
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnClockTower, $x + 32, $y, 24, 24)
		$g_hChkStartClockTowerBoost = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkActivateClockTowerBoostWhen", "Activate clock tower boost when: "), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkActivateClockTowerBoost_Info_01", "Check this to activate the Clock Tower Boost when it is available.\r\nThis option doesn't use your Gems"))
			GUICtrlSetOnEvent(-1, "chkStartClockTowerBoost")
		$g_hCmbStartClockTowerBoost = GUICtrlCreateCombo("", 320, $y + 5, 89 + 35, 25, BitOR($CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL, $WS_VSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "CmbStartClockTowerBoostAlways", "Always") & "|" & $g_sTranslateBBTower)
			_GUICtrlComboBox_SetCurSel(-1, 1)
			GUICtrlSetOnEvent(-1, "chkStartClockTowerBoost")
	$y += 25
		GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModClockTowerP, $x + 32, $y, 24, 24)
		$g_hChkClockTowerPotion = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkActivateClockTowerPotionWhen", "Activate clock tower with potion when: "), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkActivateClockTowerBoost_Info_01", "Check this to activate the Clock Tower Boost when it is available.\r\nThis option doesn't use your Gems"))
			GUICtrlSetOnEvent(-1, "chkStartClockTowerBoostPotion")
		$g_hCmbClockTowerPotion = GUICtrlCreateCombo("", 320, $y + 5, 89 + 35, 25, BitOR($CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL, $WS_VSCROLL))
			GUICtrlSetData(-1, $g_sTranslateBBTower)
			_GUICtrlComboBox_SetCurSel(-1, 0)
			GUICtrlSetOnEvent(-1, "chkStartClockTowerBoostPotion")
	$y += 28
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTree, $x + 20, $y, 24, 24)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBark, $x + 45, $y, 24, 24)
		$g_hChkCleanBBYard = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCleanBBYard", "Remove Obstacles"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCleanYardBB_Info_01", "Check this to automatically clear Yard from Trees, Trunks etc. from Builder base."))
			GUICtrlSetOnEvent(-1, "chkCleanBBYard")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hChkCleanYardBBall = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCleanBBYardAll", "Remove all"), $x + 100 + 115, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCleanBBYardAll_Info_01", "Will try to remove all obstacles at same loop."))
			GUICtrlSetOnEvent(-1, "chkCleanBBYardAll")
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 55

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "Group_03", "Builders Base Loop"), $x - 10, $y - 20, $g_iSizeWGrpTab2, 52)
		$g_hChkDSICGBB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "ChkDSICG", "Increase cycles during clan games"), $x + 10, $y, 175, -1)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "LblMaxLoopsAttackBB", "Attack cycles :"), $x + 220, $y + 4, -1, -1)

		$g_hTxtBBMinAttack = _GUICtrlCreateInput("1", $x + 318, $y, 40, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetLimit(-1, 3, 1)
		GUICtrlSetOnEvent(-1, "ChkBBAttackLoops")

		GUICtrlCreateLabel("-", $x + 360, $y + 2)

		$g_hTxtBBMaxAttack = _GUICtrlCreateInput("4", $x + 365, $y, 40, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetLimit(-1, 3, 1)
		GUICtrlSetOnEvent(-1, "ChkBBAttackLoops")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 54

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "Group_02", "Builders Base Stats"), $x - 10, $y - 20, $g_iSizeWGrpTab2, 223)
		$y += 5
		_GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBGold, $x , $y, 16, 16)
		$g_alblBldBaseStats[$eLootGoldBB] = GUICtrlCreateLabel("---", $x + 35, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$y += 30
		_GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBElixir, $x , $y, 16, 16)
		$g_alblBldBaseStats[$eLootElixirBB] = GUICtrlCreateLabel("---", $x + 35 , $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$y += 30
		_GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBTrophies, $x , $y, 16, 16)
		$g_alblBldBaseStats[$eLootTrophyBB] = GUICtrlCreateLabel("---", $x + 35 , $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$y += 30
		_GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnVersus, $x , $y, 16, 16)
		$g_hNextBBAttack = GUICtrlCreateLabel("---", $x + 35 , $y + 2, 100, 40)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

		$y += 100

		$g_hDebugBBattack = GUICtrlCreateCheckbox("Debug BB Attack", $x, $y - 55, -1, -1)
		If Not $g_bDevMode Then
			GUICtrlSetState(-1, $GUI_HIDE)
		EndIf
		GUICtrlSetOnEvent(-1, "chkDebugBBattack")
		$g_hbtnBBAttack = GUICtrlCreateButton("Debug UI", $x, $y - 25, 85, 25)
		If Not $g_bDevMode Then
			GUICtrlSetState(-1, $GUI_HIDE)
		EndIf
		GUICtrlSetOnEvent(-1, "DebugUI")

		$y -= 22

		$g_hBtnBBAtkLogClear = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "BtnBBAtkLogClear", "Clear Atk. Log"), $x + 245, $y - 1, 80, 23)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "BtnBBAtkLogClear_Info_01", "Use this to clear the Attack Log."))
			GUICtrlSetOnEvent(-1, "btnBBAtkLogClear")

		$g_hBtnBBAtkLogCopyClipboard = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "BtnBBAtkLogCopyClipboard", "Copy to Clipboard"), $x + 325, $y - 1, 100, 23)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "BtnBBAtkLogCopyClipboard_Info_01", "Use this to copy the Attack Log to the Clipboard (CTRL+C)"))
			GUICtrlSetOnEvent(-1, "btnBBAtkLogCopyClipboard")


	GUICtrlCreateGroup("", -99, -99, 1, 1)


EndFunc   ;==>CreateMiscBuilderBaseSubTab
