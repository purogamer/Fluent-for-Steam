; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), kaganus (August 2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func btnResetStats()
	ResetStats()
EndFunc   ;==>btnResetStats

Func UpdateMultiStats($bCheckSwitchAccEnable = True)
	Local $bEnableSwitchAcc = $g_iCmbSwitchAcc > 0
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	If Not $bCheckSwitchAccEnable Then $bEnableSwitchAcc = True ; added for Farm Schedule

	For $i = 0 To $g_eTotalAcc - 1 ; Custom Acc - Team AIO Mod++
		If $bEnableSwitchAcc And $i <= $iCmbTotalAcc Then
			_GUI_Value_STATE("SHOW", $g_ahGrpDefaultAcc[$i])
			If GUICtrlGetState($g_ahLblHourlyStatsGoldAcc[$i]) = $GUI_ENABLE + $GUI_HIDE Then _GUI_Value_STATE("SHOW", $g_ahGrpReportAcc[$i])
			_GUI_Value_STATE("SHOW", $g_hPicHeroGrayStatus[0][$i] & "#" & $g_hPicHeroGrayStatus[1][$i] & "#" & $g_hPicHeroGrayStatus[2][$i] & "#" & $g_hPicLabGrayStatus[$i])

			If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then
				If GUICtrlRead($g_ahChkDonate[$i]) = $GUI_UNCHECKED Then
					GUICtrlSetData($g_ahGrpVillageAcc[$i], GUICtrlRead($g_ahCmbProfile[$i]) & " (Active)")
				Else
					GUICtrlSetData($g_ahGrpVillageAcc[$i], GUICtrlRead($g_ahCmbProfile[$i]) & " (Donate)")
				EndIf
			Else
				GUICtrlSetData($g_ahGrpVillageAcc[$i], GUICtrlRead($g_ahCmbProfile[$i]) & " (Idle)")
			EndIf
		Else
			_GUI_Value_STATE("HIDE", $g_ahGrpDefaultAcc[$i] & "#" & $g_ahGrpReportAcc[$i] & "#" & $g_ahGrpStatsAcc[$i])
			_GUI_Value_STATE("HIDE", $g_hPicHeroGrayStatus[0][$i] & "#" & $g_hPicHeroGrayStatus[1][$i] & "#" & $g_hPicHeroGrayStatus[2][$i] & "#" & $g_hPicLabGrayStatus[$i])
		EndIf
	Next
EndFunc   ;==>UpdateMultiStats

Func SwitchVillageInfo()
	For $i = 0 To $g_eTotalAcc - 1 ; Custom Acc - Team AIO Mod++
		If @GUI_CtrlId = $g_ahPicArrowLeft[$i] Or @GUI_CtrlId = $g_ahPicArrowRight[$i] Then
			Return _SwitchVillageInfo($i)
		EndIf
	Next
EndFunc   ;==>SwitchVillageInfo

Func _SwitchVillageInfo($i)
	If GUICtrlGetState($g_ahLblResultGoldNowAcc[$i]) = $GUI_ENABLE + $GUI_SHOW Then
		_GUI_Value_STATE("HIDE", $g_ahGrpReportAcc[$i])
		_GUI_Value_STATE("SHOW", $g_ahGrpStatsAcc[$i])
	Else
		_GUI_Value_STATE("HIDE", $g_ahGrpStatsAcc[$i])
		_GUI_Value_STATE("SHOW", $g_ahGrpReportAcc[$i])
	EndIf
EndFunc   ;==>_SwitchVillageInfo
