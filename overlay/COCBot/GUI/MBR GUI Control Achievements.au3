; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Achievements
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkUnbreakable()
	If GUICtrlRead($g_hChkUnbreakable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtUnbreakable, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtUnBrkMinGold, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtUnBrkMaxGold, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtUnBrkMinElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtUnBrkMaxElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtUnBrkMinDark, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtUnBrkMaxDark, $GUI_ENABLE)
		$g_iUnbrkMode = 1
	ElseIf GUICtrlRead($g_hChkUnbreakable) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hTxtUnbreakable, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtUnBrkMinGold, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtUnBrkMaxGold, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtUnBrkMinElixir, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtUnBrkMaxElixir, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtUnBrkMinDark, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtUnBrkMaxDark, $GUI_DISABLE)
		$g_iUnbrkMode = 0
	EndIf
EndFunc   ;==>chkUnbreakable
