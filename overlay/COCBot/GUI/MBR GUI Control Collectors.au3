; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Collectors
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: zengzeng
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func checkCollectors($log = False, $showLabel = True)
	Local $anyCollectorsEnabled = 0
	For $i = 6 To ubound($g_aiCollectorLevelFill) -1
		If $g_abCollectorLevelEnabled[$i] Then
			$anyCollectorsEnabled = 1
			ExitLoop
		EndIf
	Next
	If $anyCollectorsEnabled = 0 Then
		If $showLabel Then GUICtrlSetState($g_hLblCollectorWarning, $GUI_SHOW)
		If $log Then
			SetLog("Warning: Dead base is enabled, but no collectors are selected!", $COLOR_ERROR)
			SetLog("Dead base will never be found!", $COLOR_ERROR)
			SetLog("Select some in Attack Plan-Search&Attack-DeadBase-Collectors", $COLOR_ERROR)
			Return False
		EndIf
	ElseIf $anyCollectorsEnabled = 1 Then
		If $showLabel Then GUICtrlSetState($g_hLblCollectorWarning, $GUI_HIDE)
		Return True
	EndIf
	Return False
EndFunc   ;==>checkCollectors

Func chkDBCollector()
	For $i = 6 To ubound($g_aiCollectorLevelFill) -1
		If $g_ahChkDBCollectorLevel[$i] = @GUI_CtrlId Then
			If $i = 6 Then
				$g_abCollectorLevelEnabled[6] = False
				GUICtrlSetState($g_ahCmbDBCollectorLevel[6], $GUI_DISABLE)
			Else
				$g_abCollectorLevelEnabled[$i] = (GUICtrlRead($g_ahChkDBCollectorLevel[$i]) = $GUI_CHECKED ? True : False)
				GUICtrlSetState($g_ahCmbDBCollectorLevel[$i], GUICtrlRead($g_ahChkDBCollectorLevel[$i]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
			EndIf
			ExitLoop
		EndIf
	Next
	checkCollectors()
EndFunc   ;==>chkDBCollector

Func cmbDBCollector()
	For $i = 6 To ubound($g_aiCollectorLevelFill) -1
		If $g_ahCmbDBCollectorLevel[$i] = @GUI_CtrlId Then
			$g_aiCollectorLevelFill[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbDBCollectorLevel[$i])
			ExitLoop
		EndIf
	Next
EndFunc   ;==>cmbDBCollector

Func sldCollectorTolerance()
	$g_iCollectorToleranceOffset = GUICtrlRead($g_hSldCollectorTolerance)
EndFunc   ;==>sldCollectorTolerance

Func cmbMinCollectorMatches()
	$g_iCollectorMatchesMin = _GUICtrlComboBox_GetCurSel($g_hCmbMinCollectorMatches) + 1
EndFunc   ;==>cmbLvl12
