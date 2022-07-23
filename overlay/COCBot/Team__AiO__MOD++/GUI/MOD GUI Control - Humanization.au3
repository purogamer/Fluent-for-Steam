; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Control - Humanization
; Description ...: This file controls the "Humanization" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: RoroTiti, NguyenAnhHD
; Modified ......: RoroTiti (11.11.2016), Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkUseBotHumanization()
	If GUICtrlRead($g_hChkUseBotHumanization) = $GUI_CHECKED Then
		$g_bUseBotHumanization = True
		For $i = $g_hChkLookAtRedNotifications To $g_hCmbMaxActionsNumber
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		cmbStandardReplay()
		cmbWarReplay()
	Else
		$g_bUseBotHumanization = False
		For $i = $g_hChkLookAtRedNotifications To $g_hCmbMaxActionsNumber
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkUseBotHumanization

Func chkLookAtRedNotifications()
	If GUICtrlRead($g_hChkLookAtRedNotifications) = $GUI_CHECKED Then
		$g_bLookAtRedNotifications = True
	Else
		$g_bLookAtRedNotifications = False
	EndIf
EndFunc   ;==>chkLookAtRedNotifications

Func cmbStandardReplay()
	If GUICtrlRead($g_hChkUseBotHumanization) = $GUI_CHECKED Then
		If (_GUICtrlComboBox_GetCurSel($g_acmbPriority[1]) > 0) Or (_GUICtrlComboBox_GetCurSel($g_acmbPriority[2]) > 0) Then
			For $i = $g_hLabel7 To $g_acmbPause[0]
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
		Else
			For $i = $g_hLabel7 To $g_acmbPause[0]
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		EndIf
	EndIf
EndFunc   ;==>cmbStandardReplay

Func cmbWarReplay()
	If GUICtrlRead($g_hChkUseBotHumanization) = $GUI_CHECKED Then
		If _GUICtrlComboBox_GetCurSel($g_acmbPriority[8]) > 0 Then
			For $i = $g_hLabel13 To $g_acmbPause[1]
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
		Else
			For $i = $g_hLabel13 To $g_acmbPause[1]
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		EndIf
	EndIf
EndFunc   ;==>cmbWarReplay
