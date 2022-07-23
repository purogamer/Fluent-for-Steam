; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Standard Attack" tab under the "Attack" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hGUI_ACTIVEBASE_ATTACK_STANDARD = 0
Global $g_hCmbStandardDropOrderAB = 0, $g_hCmbStandardDropSidesAB = 0, $g_hCmbStandardUnitDelayAB = 0, $g_hCmbStandardWaveDelayAB = 0, $g_hChkRandomSpeedAtkAB = 0, $g_hChkSmartAttackRedAreaAB = 0, _
	   $g_hCmbSmartDeployAB = 0, $g_hChkAttackNearGoldMineAB = 0, $g_hChkAttackNearElixirCollectorAB = 0, $g_hChkAttackNearDarkElixirDrillAB = 0

Global $g_hLblSmartDeployAB = 0, $g_hPicAttackNearDarkElixirDrillAB = 0
Global $g_hBtnCustomDropOrderAB = 0

#Region - Custom smart attack - Team AIO Mod++
Global $g_hChkAttackStdSmartDropSpellsAB = 0
#EndRegion - Custom smart attack - Team AIO Mod++

Func CreateAttackSearchActiveBaseStandard()

	$g_hGUI_ACTIVEBASE_ATTACK_STANDARD = _GUICreate("", $_GUI_MAIN_WIDTH - 195, $g_iSizeHGrpTab4, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_ACTIVEBASE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_ACTIVEBASE_ATTACK_STANDARD)

	Local $sTxtTip = ""
	Local $x = 25, $y = 20
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Group_01", -1), $x - 20, $y - 20, 270, $g_iSizeHGrpTab4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Label_01",  -1), $x, $y, 143, 18, $SS_LEFT)

		$y += 15
			$g_hCmbStandardDropOrderAB = GUICtrlCreateCombo("", $x, $y, 150, Default, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Item_01", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Item_02", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Item_03", -1), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Item_01", -1))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Info_01", -1) & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Info_02", -1) & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Info_03", -1))

		$y += 25
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Label_02", "Attack on") & ":", $x, $y + 5, -1, -1)
			$g_hCmbStandardDropSidesAB = GUICtrlCreateCombo("", $x + 55, $y, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_01", -1) & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_02", -1) & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_03", -1) & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_05", "Attack on the single side closest to the Dark Elixir Storage") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_06", "Attack on the single side closest to the Townhall") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_04", -1))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_01", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_02", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_03", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_04", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_05", "DE Side Attack") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_06", "TH Side Attack"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_04", -1))
		#Region - Custom sleep Drop - Team AIO Mod++
		$y += 25
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Lbl-CmbStandardUnitDelay", "Delay Unit") & ":", $x, $y + 5, -1, -1)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Lbl-CmbStandardUnitDelay_Info_01", "This delays the deployment of troops, 1 (fast) = like a Bot, 10 (slow) = Like a Human.") & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Lbl-CmbStandardUnitDelay_Info_02", "Random will make bot more varied and closer to a person.")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hDeployDelay[2] = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15", "4")
				GUICtrlSetOnEvent(-1, "chkMiscModOptions")
				;GUICtrlSetOnEvent(-1, "chkSpeedAtkDB")
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Lbl-CmbStandardWaveDelay_Info_01", "Wave") & ":", $x + 100, $y + 5, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hDeployWave[2] = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15", "4")
				GUICtrlSetOnEvent(-1, "chkMiscModOptions")
				;GUICtrlSetOnEvent(-1, "chkSpeedAtkDB")
		$y += 22
			$g_hChkEnableRandom[2] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkRandomSpeedAtk", "Randomize delay for Units && Waves"), $x, $y, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "chkMiscModOptions")
				;GUICtrlSetOnEvent(-1, "chkRandomSpeedAtkDB")
		$y +=22
		#EndRegion - Custom sleep Drop - Team AIO Mod++
			$g_hChkSmartAttackRedAreaAB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkSmartAttackRedArea", -1), $x, $y, -1, -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkSmartAttackRedArea_Info_01", -1))
				GUICtrlSetState(-1, $GUI_CHECKED)
				GUICtrlSetOnEvent(-1, "chkSmartAttackRedAreaAB")
		$y +=22
			$g_hChkAttackStdSmartDropSpellsAB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkAttackStdSmartDropSpellsDB", "Drop Rage/Heal spell."), $x, $y, -1, -1)
				GUICtrlSetState(-1, $GUI_CHECKED)

		$y += 22
			$g_hLblSmartDeployAB = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "LblSmartDeploy", -1) & ":", $x, $y + 5, -1, -1)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "LblSmartDeploy_Info_01", -1) & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "LblSmartDeploy_Info_02", -1) & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "LblSmartDeploy_Info_03", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hCmbSmartDeployAB = GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbSmartDeploy_Info_01", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbSmartDeploy_Info_02", -1), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbSmartDeploy_Info_01", -1))
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 26
			$g_hChkAttackNearGoldMineAB = GUICtrlCreateCheckbox("", $x + 20, $y, 17, 17)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkAttackNearGoldMine_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 40 , $y - 3 , 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 75
			$g_hChkAttackNearElixirCollectorAB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkAttackNearElixirCollector_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20 , $y - 3 , 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 55
			$g_hChkAttackNearDarkElixirDrillAB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkAttackNearDarkElixirDrill_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hPicAttackNearDarkElixirDrillAB = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 20 , $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 40
		$x = 98
			$g_hBtnCustomDropOrderAB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnCustomDropOrder", -1), $x, $y, 85, 25)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnCustomDropOrder_Info_01", -1))
				GUICtrlSetOnEvent(-1, "CustomDropOrder")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchActiveBaseStandard
