; #FUNCTION# ====================================================================================================================
; Name ..........: _GUICtrlSetTip
; Description ...: Replacement for GUICtrlSetTip because doesn't create a tool tip window control everytime
; Syntax ........:
; Parameters ....: See GUICtrlSetTip
; Return values .: See _GUIToolTip_AddTool
; Author ........: Cosote (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hToolTip = 0

Func _GUICtrlSetTip($controlID, $tiptext, $title = Default, $icon = Default, $options = Default, $useControlID = True)
	Return GUICtrlSetTip($controlID, $tiptext, $title, $icon, $options)
	; If $g_hToolTip = 0 Then
		; SetDebugLog("_GUICtrlSetTip: Missing $hToolTip! $controlID=" & $controlID, $COLOR_ERROR)
		; Return False
	; EndIf

	; Local $hCtrl = ($useControlID = True ? GUICtrlGetHandle($controlID) : $controlID)

	; Return _GUIToolTip_AddTool($g_hToolTip, 0, $tiptext, $hCtrl)
EndFunc   ;==>_GUICtrlSetTip
