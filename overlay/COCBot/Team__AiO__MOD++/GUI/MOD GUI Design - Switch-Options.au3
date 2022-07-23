; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - Switch-Options
; Description ...: This file creates the "Switch Accounts" & "Farming Schedule" tab under the "Profiles" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen, NguyenAnhHD (03-2018), Boldina (16-2-2022)
; Modified ......: Team AiO MOD++ (2019-2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2022
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_SWITCH_OPTIONS = 0, _
	   $g_hGUI_SWITCH_OPTIONS_TAB = 0, $g_hGUI_SWITCH_OPTIONS_TAB_ITEM1 = 0, $g_hGUI_SWITCH_OPTIONS_TAB_ITEM2 = 0, $g_hGUI_SWITCH_OPTIONS_TAB_ITEM3 = 0

Global $g_hGUI_LOG_SA = 0

Global $g_hChkSwitchAcc = 0, $g_hCmbSwitchAcc = 0, $g_hChkSharedPrefs = 0, $g_hCmbTotalAccount = 0, $g_hChkSmartSwitch = 0, $g_hCmbTrainTimeToSkip = 0, $g_hChkDonateLikeCrazy = 0, _
	   $g_ahChkAccount[$g_eTotalAcc], $g_ahCmbProfile[$g_eTotalAcc], $g_ahChkDonate[$g_eTotalAcc], _
	   $g_hRadSwitchGooglePlay = 0, $g_hRadSwitchSuperCellID = 0, $g_hRadSwitchSharedPrefs = 0

; Switch Profiles
Global $g_ahChk_SwitchMax[4], $g_ahCmb_SwitchMax[4], $g_ahChk_BotTypeMax[4], $g_ahCmb_BotTypeMax[4], $g_ahLbl_SwitchMax[4], $g_ahTxt_ConditionMax[4], _
	   $g_ahChk_SwitchMin[4], $g_ahCmb_SwitchMin[4], $g_ahChk_BotTypeMin[4], $g_ahCmb_BotTypeMin[4], $g_ahLbl_SwitchMin[4], $g_ahTxt_ConditionMin[4]

Global $g_ahChkSetFarm[$g_eTotalAcc], _
	   $g_ahCmbAction1[$g_eTotalAcc], $g_ahCmbCriteria1[$g_eTotalAcc], $g_ahTxtResource1[$g_eTotalAcc], $g_ahCmbTime1[$g_eTotalAcc], _
	   $g_ahCmbAction2[$g_eTotalAcc], $g_ahCmbCriteria2[$g_eTotalAcc], $g_ahTxtResource2[$g_eTotalAcc], $g_ahCmbTime2[$g_eTotalAcc]

Global $g_hTxtSALog = 0

Global $g_hBtnNextFarmingScheduleTab = 0

Func CreateSwitchOptions()
	; GUI Tab for Switch Accounts & Farm Schedule
	$g_hGUI_LOG_SA = _GUICreate("", 205, 145, 235, 225, BitOR($WS_CHILD, 0), -1, $g_hGUI_SWITCH_OPTIONS)

	GUISwitch($g_hGUI_SWITCH_OPTIONS)
	$g_hGUI_SWITCH_OPTIONS_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2 + 2, $g_iSizeHGrpTab4 + 5, $WS_CLIPSIBLINGS)
	$g_hGUI_SWITCH_OPTIONS_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_04_STab_01", "Switch Accounts"))
		CreateSwitchAccount()
	$g_hGUI_SWITCH_OPTIONS_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_04_STab_02", "Switch Profiles"))
		CreateSwitchProfile()
	$g_hGUI_SWITCH_OPTIONS_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_04_STab_03", "Farming Schedule"))
		CreateFarmSchedule()

	; This dummy is used in btnStart and btnStop to disable/enable all labels, text, buttons etc. on all tabs.
	$g_hLastControlToHide = GUICtrlCreateDummy()
	ReDim $g_aiControlPrevState[$g_hLastControlToHide + 1]
	CreateBotSwitchAccLog() ; Set SwitchAcc Log
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateBotProfileSchedule

#Region Switch Accounts tab
Func CreateSwitchAccount()
	Local $x = 15, $y = 30
	$x -= 10
		$g_hCmbSwitchAcc = GUICtrlCreateCombo("", $x, $y-3, 145, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		Local $s = "No Switch Accounts Group"
		For $i = 1 To UBound($g_ahChkAccount)
			$s &= "|Switch Accounts Group " & $i
		Next
		GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbSwitchAcc", $s), "No Switch Accounts Group")
		GUICtrlSetOnEvent(-1, "cmbSwitchAcc")
		
		; Custom - Team AIO Mod++
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x + 152, $y, 16, 16)
		GUICtrlSetOnEvent(-1, "ResetGroupSwAcc")

	$y += 20
		$g_hChkSwitchAcc = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkSwitchAcc", "Enable Switch"), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkSwitchAcc")
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkSwitchAcc_Info_01", "Enable or disable current selected Switch Accounts Group"))
		
		; $g_hChkFastSwitchAcc = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkFastSwitchAcc", "Fast Switch"), $x + 100, $y, -1, -1)
		; GUICtrlSetOnEvent(-1, "chkSwitchAcc")
		; _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkSwitchAcc_Info_01", "Enable Fast Switch Account"))

		$g_hCmbTotalAccount = GUICtrlCreateCombo("", $x + 345, $y - 1, 77, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "2 accounts|3 accounts|4 accounts|5 accounts|6 accounts|7 accounts|8 accounts|9 accounts|10 accounts|11 accounts|12 accounts|13 accounts|14 accounts|15 accounts|16 accounts", "2 accounts")
		GUICtrlSetOnEvent(-1, "cmbTotalAcc")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbTotalAccount", "Total CoC Accounts") & ": ", $x + 220, $y + 4, -1, -1)

		$g_hRadSwitchSharedPrefs = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchSharedPrefs", "Shared_prefs"), $x + 185, $y - 25, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchSharedPrefs_Info_01", "Support for Google Play and SuperCell ID accounts"))
		GUICtrlSetState(-1, $GUI_CHECKED)
		$g_hRadSwitchGooglePlay = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchGooglePlay", "Google Play"), $x + 270, $y - 25, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchGooglePlay_Info_01", "Only support for all Google Play accounts"))
		$g_hRadSwitchSuperCellID = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchSuperCellID", "SuperCell ID"), $x + 347, $y - 25, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "RadSwitchSuperCellID_Info_01", "Only support for all SuperCell ID accounts"))

	$y += 25
		$g_hChkSmartSwitch = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkSmartSwitch", "Smart switch"), $x, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "ChkSmartSwitch_Info_01", "Switch to account with the shortest remain training time"))
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetOnEvent(-1, "chkSmartSwitch")

		$g_hChkDonateLikeCrazy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "DonateLikeCrazy", "Donate like Crazy"), $x + 100, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "DonateLikeCrazy_Info_01", "Enable it allows account switching in the order: Donate - Shortest Active - Donate - Shortest Active  - Donate...!"))
		GUICtrlSetOnEvent(-1, "chkSmartSwitch")

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbTrainTime", "Skip switch if train time") & " <", $x + 220, $y + 4, -1, -1)
		$g_hCmbTrainTimeToSkip = GUICtrlCreateCombo("", $x + 345, $y - 1, 77, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0 minute|1 minute|2 minutes|3 minutes|4 minutes|5 minutes|6 minutes|7 minutes|8 minutes|9 minutes", "1 minute")

	;$y += 23
	;	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Description", _
	;		"Using Switch Accounts requires that not more Google Accounts are registered in Android than configured here. " & _
	;		"Maximum of 8 Google/CoC Accounts is supported."), $x, $y, $g_iSizeWGrpTab2 - 20, 42, $SS_CENTER)

	$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_01", "Accounts"), $x - 5, $y, 60, -1, $SS_CENTER)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_02", "Profile name"), $x + 62, $y, 70, -1, $SS_CENTER)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_03", "Donate only"), $x + 145, $y, 60, -1, $SS_CENTER)
		$x = 230
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_01", "Accounts"), $x - 5, $y, 60, -1, $SS_CENTER)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_02", "Profile name"), $x + 72, $y, 70, -1, $SS_CENTER)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_03", "Donate only"), $x + 150, $y, 60, -1, $SS_CENTER)
		;GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Label_04", "SwitchAcc log"), $x + 285, $y, -1, -1, $SS_CENTER)
	
	$x = 15
	$y += 14
		GUICtrlCreateGraphic($x, $y, 422, 1, $SS_GRAYRECT)

	$y += 7
		Local $yRef = $y
		For $i = 0 To UBound($g_ahChkAccount) - 1
			If $i = 11 Then 
				$x += 216
				$y = $yRef - Int((11) * 20)
			EndIf
			
			$g_ahChkAccount[$i] = GUICtrlCreateCheckbox("Acc " & $i + 1 & ".", $x, $y + ($i) * 20, -1, -1)
			GUICtrlSetOnEvent(-1, "chkAccountX")
			$g_ahCmbProfile[$i] = GUICtrlCreateCombo("", $x + 65, $y + ($i) * 20, 110, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
			GUICtrlSetOnEvent(-1, "cmbSwitchAccProfileX")
			GUICtrlSetData(-1, _GUICtrlComboBox_GetList($g_hCmbProfile))
			$g_ahChkDonate[$i] = GUICtrlCreateCheckbox("", $x + 190, $y + ($i) * 20 - 3, -1, 25)
		Next

EndFunc   ;==>CreateSwitchAccount

Func ResetGroupSwAcc()
	If _GUICtrlComboBox_GetCurSel($g_hCmbSwitchAcc) <= 0 Then Return
	
	For $i = 0 To $g_eTotalAcc - 1
		GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
		_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$i], -1)
		GUICtrlSetState($g_ahChkDonate[$i], $GUI_UNCHECKED)
		
		GUICtrlSetState($g_ahChkAccount[$i], $g_bChkSwitchAcc ? $GUI_ENABLE : $GUI_DISABLE)
		GUICtrlSetState($g_ahChkDonate[$i], $GUI_DISABLE)
		GUICtrlSetState($g_ahCmbProfile[$i], $GUI_DISABLE)

		; Farm Schedule - Team AiO MOD++
		GUICtrlSetState($g_ahChkSetFarm[$i], $GUI_UNCHECKED)

		_GUICtrlComboBox_SetCurSel($g_ahCmbAction1[$i], 0)
		_GUICtrlComboBox_SetCurSel($g_ahCmbCriteria1[$i], 0)
		GUICtrlSetData($g_ahTxtResource1[$i], $g_aiTxtResource1[$i])
		_GUICtrlComboBox_SetCurSel($g_ahCmbTime1[$i], 0)

		_GUICtrlComboBox_SetCurSel($g_ahCmbAction2[$i], 0)
		_GUICtrlComboBox_SetCurSel($g_ahCmbCriteria2[$i], 0)
		GUICtrlSetData($g_ahTxtResource2[$i], $g_aiTxtResource2[$i])
		_GUICtrlComboBox_SetCurSel($g_ahCmbTime2[$i], 0)
		For $h = $g_ahCmbAction1[$i] To $g_ahCmbTime2[$i]
			GUICtrlSetState($h, $GUI_DISABLE)
		Next
	Next
	ApplyConfig_600_35_2("Save")
EndFunc   ;==>ResetGroupSwAcc

#EndRegion

#Region Switch Profiles tab
Func CreateSwitchProfile()

	Local $asText[4] = ["Gold", "Elixir", "Dark Elixir", "Trophy"]
	Local $aIcon[4] = [$eIcnGold, $eIcnElixir, $eIcnDark, $eIcnTrophy]
	Local $aiValueMax[4] = ["12000000", "12000000", "240000", "5000"]
	Local $aiValueMin[4] = ["1000000", "1000000", "20000", "3000"]
	Local $aiLimitMax[4] = [8, 8, 6, 4]
	Local $aiLimitMin[4] = [7, 7, 5, 4]

	Local $x = 25, $y = 41
	Local $profileString = _GUICtrlComboBox_GetList($g_hCmbProfile)

	For $i = 0 To 3
		GUICtrlCreateGroup("        " & $asText[$i] & " " & GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Group_03", "conditions"), $x - 20, $y - 15 + $i * 51, $g_iSizeWGrpTab3, 78)
		_GUICtrlCreateIcon($g_sLibIconPath, $aIcon[$i], $x - 10, $y - 17 + $i * 51, 20, 20)
			$g_ahChk_SwitchMax[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Switch", "Switch to.."), $x - 10, $y + 7 + $i * 51, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchProfile")
			$g_ahCmb_SwitchMax[$i] = GUICtrlCreateCombo("", $x + 60, $y + 7 + $i * 51, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $profileString, "<No Profiles>")

			$g_ahChk_BotTypeMax[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BotType", "Turn.."), $x + 145, $y + 7 + $i * 51, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchBotType")
			$g_ahCmb_BotTypeMax[$i] = GUICtrlCreateCombo("", $x + 195, $y + 7 + $i * 51, 58, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Off|Donate|Active", "Donate")

			$g_ahLbl_SwitchMax[$i] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition", "when") & " " & $asText[$i] & " >", $x + 262, $y + 11 + $i * 51, -1, -1)
			$g_ahTxt_ConditionMax[$i] = _GUICtrlCreateInput($aiValueMax[$i], $x + 352, $y + 7 + $i * 51, 55, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition_Info_01", "Set the amount of") & " " & $asText[$i] &  " " & _
								   GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition_Info_02", "to trigger switching Profile & Bot Type."))
				GUICtrlSetLimit(-1, $aiLimitMax[$i])

		$y += 30
			$g_ahChk_SwitchMin[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Switch", -1), $x - 10, $y + 5 + $i * 51, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchProfile")
			$g_ahCmb_SwitchMin[$i] = GUICtrlCreateCombo("", $x + 60, $y + 5 + $i * 51, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $profileString, "<No Profiles>")

			$g_ahChk_BotTypeMin[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BotType", -1), $x + 145, $y + 5 + $i * 51, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchBotType")
			$g_ahCmb_BotTypeMin[$i] = GUICtrlCreateCombo("", $x + 195, $y + 5 + $i * 51, 58, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Off|Donate|Active", "Active")

			$g_ahLbl_SwitchMin[$i] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition", -1) & " " & $asText[$i] & " <", $x + 262, $y + 9 + $i * 51, -1, -1)
			$g_ahTxt_ConditionMin[$i] = _GUICtrlCreateInput($aiValueMin[$i], $x + 352, $y + 5 + $i * 51, 55, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition_Info_01", -1) & " " & $asText[$i] & " " & _
								   GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition_Info_02", -1))
				GUICtrlSetLimit(-1, $aiLimitMin[$i])

		GUICtrlCreateGroup("", -99, -99, 1, 1)
	Next

EndFunc   ;==>CreateSwitchProfile
#EndRegion

#Region Farming Schedule tab
Func CreateFarmSchedule()

	Local $x = 10, $y = 30
	GUICtrlCreateLabel("Account", $x - 5, $y, 60, -1, $SS_CENTER)
	GUICtrlCreateLabel("Farm Schedule 1", $x + 80, $y, 80, -1, $SS_CENTER)
	GUICtrlCreateLabel("Farm Schedule 2", $x + 260, $y, 80, -1, $SS_CENTER)
	$g_hBtnNextFarmingScheduleTab = GUICtrlCreateButton ( "< >", $x + 400 - 14, $y -2, 35, 15, $SS_CENTER)
	GUICtrlSetOnEvent(-1, "FarmScheduleNext")

	$y += 18
	GUICtrlCreateGraphic($x, $y, 425, 1, $SS_GRAYRECT)
	
	$y += 8
	Local $bSecondPart = False, $i2 = -1
	For $i = 0 To $g_eTotalAcc - 1
		$i2 += 1
		$x = 10
		$g_ahChkSetFarm[$i] = GUICtrlCreateCheckbox("Acc " & $i + 1 & ".", $x, $y + $i2 * 30, -1, -1)
			GUICtrlSetOnEvent(-1, "chkSetFarmSchedule")
		$g_ahCmbAction1[$i] = GUICtrlCreateCombo("Turn...", $x + 60, $y + $i2 * 30, 58, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Idle|Donate|Active")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$g_ahCmbCriteria1[$i] = GUICtrlCreateCombo("When...", $x + 123, $y + $i2 * 30, 62, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Gold >|Elixir >|DarkE >|Trop. >|Time:")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetOnEvent(-1, "cmbCriteria1")
		$g_ahTxtResource1[$i] = _GUICtrlCreateInput("", $x + 187, $y + $i2 * 30, 50, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$g_ahCmbTime1[$i] = GUICtrlCreateCombo("", $x + 187, $y + $i2 * 30, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, 	"0 am|1 am|2 am|3 am|4 am|5 am|6 am|7 am|8 am|9 am|10am|11am|" & _
								"12pm|1 pm|2 pm|3 pm|4 pm|5 pm|6 pm|7 pm|8 pm|9 pm|10pm|11pm")
			GUICtrlSetState(-1, $GUI_HIDE)

		$x = 248 + 10 - 60
		$g_ahCmbAction2[$i] = GUICtrlCreateCombo("Turn...", $x + 60, $y + $i2 * 30, 58, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Idle|Donate|Active")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$g_ahCmbCriteria2[$i] = GUICtrlCreateCombo("When...", $x + 123, $y + $i2 * 30, 62, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Gold <|Elixir <|DarkE <|Trop. <|Time:")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetOnEvent(-1, "cmbCriteria2")
		$g_ahTxtResource2[$i] = _GUICtrlCreateInput("", $x + 187, $y + $i2 * 30, 50, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$g_ahCmbTime2[$i] = GUICtrlCreateCombo("", $x + 187, $y + $i2 * 30, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, 	"0 am|1 am|2 am|3 am|4 am|5 am|6 am|7 am|8 am|9 am|10am|11am|" & _
								"12pm|1 pm|2 pm|3 pm|4 pm|5 pm|6 pm|7 pm|8 pm|9 pm|10pm|11pm")
			GUICtrlSetState(-1, $GUI_HIDE)
		 $y -= 4
		
		If $i = 7 Then
			$y = 56
			$i2 = -1
		EndIf
	Next

EndFunc   ;==>CreateFarmSchedule

Func FarmScheduleNext()
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	If $iCmbTotalAcc < 8 Then Return
	
	Local $s_iFarmScheduleNext = (BitAND(GUICtrlGetState($g_ahChkSetFarm[0]), $GUI_SHOW) = $GUI_SHOW) ; Take ref
	
	For $i = 0 To $g_eTotalAcc - 1
		If $iCmbTotalAcc >= 0 And $i <= $iCmbTotalAcc Then
			For $j = $g_ahChkSetFarm[$i] To $g_ahCmbTime2[$i]
				If ($s_iFarmScheduleNext = True And $i <= 7) Or ($s_iFarmScheduleNext = False And $i > 7) Then
					GUICtrlSetState($j, $GUI_HIDE)
				Else
					GUICtrlSetState($j, $GUI_SHOW)
				EndIf
			Next
		Else
			For $j = $g_ahChkSetFarm[$i] To $g_ahCmbTime2[$i]
				GUICtrlSetState($j, $GUI_HIDE)
			Next
		EndIf
	Next
EndFunc   ;==>FarmScheduleNext
#EndRegion

Func CreateBotSwitchAccLog()

	Local $x = 0, $y = 0
	Local $activeHWnD1 = WinGetHandle("") ; RichEdit Controls tamper with active window
	$g_hTxtSALog = _GUICtrlRichEdit_Create($g_hGUI_LOG_SA, "", $x, $y, 205, 145, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL, $ES_UPPERCASE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_NUMBER, 0x200), $WS_EX_STATICEDGE)
	WinActivate($activeHWnD1) ; restore current active window

EndFunc   ;==>CreateBotSwitchAccLog
