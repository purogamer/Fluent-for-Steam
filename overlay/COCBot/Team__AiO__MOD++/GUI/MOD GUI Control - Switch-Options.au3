; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Control
; Description ...: This file controls the "Switch Profiles & Farm Schedule" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: NguyenAnhHD
; Modified ......: Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; Switch Profiles
Func chkSwitchProfile()
	For $i = 0 To 3
		If GUICtrlRead($g_ahChk_SwitchMax[$i]) = $GUI_CHECKED Then
			_GUI_Value_STATE("ENABLE", $g_ahCmb_SwitchMax[$i] & "#" & $g_ahLbl_SwitchMax[$i] & "#" & $g_ahTxt_ConditionMax[$i])
			If GUICtrlRead($g_hChkSwitchAcc) = $GUI_CHECKED Then
				GUICtrlSetState($g_ahChk_BotTypeMax[$i], $GUI_ENABLE)
			Else
				GUICtrlSetState($g_ahChk_BotTypeMax[$i], BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		Else
			For $j = $g_ahCmb_SwitchMax[$i] To $g_ahTxt_ConditionMax[$i]
				GUICtrlSetState($j, $GUI_DISABLE)
			Next
			GUICtrlSetState($g_ahChk_BotTypeMax[$i], $GUI_UNCHECKED)
		EndIf
		If GUICtrlRead($g_ahChk_SwitchMin[$i]) = $GUI_CHECKED Then
			_GUI_Value_STATE("ENABLE", $g_ahCmb_SwitchMin[$i] & "#" & $g_ahLbl_SwitchMin[$i] & "#" & $g_ahTxt_ConditionMin[$i])
			If GUICtrlRead($g_hChkSwitchAcc) = $GUI_CHECKED Then
				GUICtrlSetState($g_ahChk_BotTypeMin[$i], $GUI_ENABLE)
			Else
				GUICtrlSetState($g_ahChk_BotTypeMin[$i], BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		Else
			For $j = $g_ahCmb_SwitchMin[$i] To $g_ahTxt_ConditionMin[$i]
				GUICtrlSetState($j, $GUI_DISABLE)
			Next
			GUICtrlSetState($g_ahChk_BotTypeMin[$i], $GUI_UNCHECKED)
		EndIf
	Next
	chkSwitchBotType()
EndFunc   ;==>chkSwitchProfile

Func chkSwitchBotType()
	For $i = 0 To 3
		If GUICtrlRead($g_ahChk_BotTypeMax[$i]) = $GUI_CHECKED Then
			GUICtrlSetState($g_ahCmb_BotTypeMax[$i], $GUI_ENABLE)
		Else
			GUICtrlSetState($g_ahCmb_BotTypeMax[$i], $GUI_DISABLE)
		EndIf
		If GUICtrlRead($g_ahChk_BotTypeMin[$i]) = $GUI_CHECKED Then
			GUICtrlSetState($g_ahCmb_BotTypeMin[$i], $GUI_ENABLE)
		Else
			GUICtrlSetState($g_ahCmb_BotTypeMin[$i], $GUI_DISABLE)
		EndIf
	Next
EndFunc   ;==>chkSwitchBotType

; Farm Schedule
Func chkSetFarmSchedule()
	For $i = 0 To UBound($g_ahChkSetFarm) - 1
		If @GUI_CtrlId = $g_ahChkSetFarm[$i] Then
			Return _chkSetFarmSchedule($i)
		EndIf
	Next
EndFunc   ;==>chkSetFarmSchedule

Func _chkSetFarmSchedule($i)
	If GUICtrlRead($g_ahChkSetFarm[$i]) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_ahCmbAction1[$i] & "#" & $g_ahCmbAction2[$i] & "#" & $g_ahCmbCriteria1[$i] & "#" & $g_ahCmbCriteria2[$i])
		_cmbCriteria1($i)
		_cmbCriteria2($i)
	Else
		_GUI_Value_STATE("DISABLE", $g_ahCmbAction1[$i] & "#" & $g_ahCmbCriteria1[$i] & "#" & $g_ahTxtResource1[$i] & "#" & $g_ahCmbTime1[$i] & "#" & _
				$g_ahCmbAction2[$i] & "#" & $g_ahCmbCriteria2[$i] & "#" & $g_ahTxtResource2[$i] & "#" & $g_ahCmbTime2[$i])
	EndIf
EndFunc   ;==>_chkSetFarmSchedule

Func cmbCriteria1()
	For $i = 0 To UBound($g_ahCmbCriteria1) - 1
		If @GUI_CtrlId = $g_ahCmbCriteria1[$i] Then
			Return _cmbCriteria1($i)
		EndIf
	Next
EndFunc   ;==>cmbCriteria1

Func _cmbCriteria1($i)
	Local $aiDefaultValue[4] = ["12000000", "12000000", "240000", "6000"]
	Local $aiDefaultLimit[4] = [99999999, 99999999, 299999, 9999]
	Local $iCmbCriteria = _GUICtrlComboBox_GetCurSel($g_ahCmbCriteria1[$i])
	Switch $iCmbCriteria
		Case 0
			_GUI_Value_STATE("DISABLE", $g_ahCmbTime1[$i] & "#" & $g_ahTxtResource1[$i])
		Case 1 To 4
			GUICtrlSetState($g_ahCmbTime1[$i], $GUI_HIDE)
			GUICtrlSetState($g_ahTxtResource1[$i], BitOR($GUI_SHOW, $GUI_ENABLE))
			If GUICtrlRead($g_ahTxtResource1[$i]) = "" Or GUICtrlRead($g_ahTxtResource1[$i]) > $aiDefaultLimit[$iCmbCriteria - 1] Then GUICtrlSetData($g_ahTxtResource1[$i], $aiDefaultValue[$iCmbCriteria - 1])
			GUICtrlSetLimit($g_ahTxtResource1[$i], StringLen($aiDefaultValue[$iCmbCriteria - 1]))
		Case 5
			GUICtrlSetState($g_ahTxtResource1[$i], $GUI_HIDE)
			GUICtrlSetState($g_ahCmbTime1[$i], BitOR($GUI_SHOW, $GUI_ENABLE))
	EndSwitch
EndFunc   ;==>_cmbCriteria1

Func cmbCriteria2()
	For $i = 0 To UBound($g_ahCmbCriteria2) - 1
		If @GUI_CtrlId = $g_ahCmbCriteria2[$i] Then
			Return _cmbCriteria2($i)
		EndIf
	Next
EndFunc   ;==>cmbCriteria2

Func _cmbCriteria2($i)
	Local $aiDefaultValue[4] = ["1000000", "1000000", "020000", "3000"]
	Local $aiDefaultLimit[4] = [9999999, 9999999, 199999, 9999]
	Local $iCmbCriteria = _GUICtrlComboBox_GetCurSel($g_ahCmbCriteria2[$i])
	Switch $iCmbCriteria
		Case 0
			_GUI_Value_STATE("DISABLE", $g_ahTxtResource2[$i] & "#" & $g_ahCmbTime2[$i])
		Case 1 To 4
			GUICtrlSetState($g_ahCmbTime2[$i], $GUI_HIDE)
			GUICtrlSetState($g_ahTxtResource2[$i], BitOR($GUI_SHOW, $GUI_ENABLE))
			If GUICtrlRead($g_ahTxtResource2[$i]) = "" Or GUICtrlRead($g_ahTxtResource2[$i]) > $aiDefaultLimit[$iCmbCriteria - 1] Then GUICtrlSetData($g_ahTxtResource2[$i], Number($aiDefaultValue[$iCmbCriteria - 1]))
			GUICtrlSetLimit($g_ahTxtResource2[$i], StringLen($aiDefaultValue[$iCmbCriteria - 1]))
		Case 5
			GUICtrlSetState($g_ahTxtResource2[$i], $GUI_HIDE)
			GUICtrlSetState($g_ahCmbTime2[$i], BitOR($GUI_SHOW, $GUI_ENABLE))
	EndSwitch
EndFunc   ;==>_cmbCriteria2
